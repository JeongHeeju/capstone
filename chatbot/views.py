import json
import re
import os
import logging
import requests
from datetime import datetime, timedelta
from dotenv import load_dotenv

from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt
from django.utils.dateparse import parse_date
from django.utils.timezone import make_aware
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from openai import OpenAI
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage, AIMessage

from users.models import UserProfile, FoodPreference, Allergy
from .models import ChatHistory
from .session_helpers import (
    get_chat_session, set_chat_session,
    get_last_food_state, set_last_food_state,
    recent_chat_contains_food_keyword
)
from .prompt_utils import (
    NON_FOOD_PROMPT, FOOD_TAGS,
    MORE_RESULTS_PATTERN, extract_radius, get_system_prompt
)
from .restaurant_search import (
    get_coords_from_keyword, search_kakao_restaurants,
    format_restaurant_info
)
load_dotenv()
logger = logging.getLogger(__name__)

HEALTH_KEYWORDS = [
    '다이어트','저칼로리','칼로리','열량','영양','영양소',
    '단백질','지방','탄수화물','비타민','미네랄','살 안찌는','살 안찔',
    '체중','체중 감량','살이 안 찔','건강하게','헬스',
]
COOKING_KEYWORDS = [
    '레시피','요리','요리법','조리법','만드는 법','만들기',
    '재료','조리','굽는 법','삶는 법','볶는 법','찜','구이',
    '무침','조림','전','국','탕','굽기','시간',
]

def classify_topics(llm: ChatOpenAI, user_message: str) -> str:
    system_msg = SystemMessage(content=(
        "You are a topic classifier for food-related user queries.\n"
        "Possible topics: 음식 지식, 요리, 메뉴 추천, 식당 찾기.\n"
        "Respond ONLY with the topic name, or '비음식'."
    ))
    try:
        res = llm.invoke([system_msg, HumanMessage(content=user_message)])
        topic = res.content.strip()
        return topic if topic in ["음식 지식","요리","메뉴 추천","식당 찾기"] else "비음식"
    except Exception as e:
        logger.error(f"Topic classification error: {e}")
        return "비음식"

def get_user_context(user):
    if not getattr(user, "is_authenticated", False):
        return [], [], [], []
    try:
        profile = UserProfile.objects.get(user_id=user)
        prefs = FoodPreference.objects.filter(user=profile)
        allergies = [a.allergy_name for a in Allergy.objects.filter(user=profile)]
        liked = [tag for p in prefs if p.is_liked for tag in FOOD_TAGS.get(p.food_name, [])]
        disliked = [tag for p in prefs if not p.is_liked for tag in FOOD_TAGS.get(p.food_name, [])]
        conditions = [c.strip() for c in profile.medical_conditions.split(',') if c.strip()]
        return allergies, liked, disliked, conditions
    except Exception as e:
        logger.error(f"Failed to load user context: {e}")
        return [], [], [], []

@csrf_exempt
def proxy_kakao_map_image(request):
    lat = request.GET.get("lat")
    lng = request.GET.get("lng")
    if not lat or not lng:
        return HttpResponse("Missing lat/lng", status=400)

    url = (
        f"https://map.kakao.com/staticmap?"
        f"center={lng},{lat}&level=3&map_type=TYPE_MAP"
        f"&width=700&height=500&marker={lng},{lat}"
    )
    try:
        resp = requests.get(url, headers={"Referer":"https://map.kakao.com/"}, stream=True, timeout=5)
        if resp.status_code == 200:
            return HttpResponse(resp.content, content_type="image/png")
        return HttpResponse("Failed to fetch image", status=resp.status_code)
    except Exception as e:
        logger.error(f"Kakao map proxy error: {e}")
        return HttpResponse(f"Error: {e}", status=500)

class ChatAPIView(APIView):
    permission_classes = [AllowAny]

    def handle_restaurant_search(self, request, llm, user_message):
        # 0. 반경 추출
        radius = extract_radius(user_message)
        request.session["chatbot_last_radius"] = radius

        # 1. 검색 키워드 요약
        query = llm.invoke([
            SystemMessage(content="다음 문장을 검색 키워드로 요약해 주세요"),
            HumanMessage(content=user_message)
        ]).content.strip() or "맛집"
        request.session["chatbot_last_query"] = query

        # 2. 사용자 정보 불러오기
        try:
            profile = UserProfile.objects.get(user_id=request.user)
            prefs = FoodPreference.objects.filter(user=profile)
            allergies = [a.allergy_name for a in Allergy.objects.filter(user=profile)]
            liked_tags = [tag for p in prefs if p.is_liked for tag in FOOD_TAGS.get(p.food_name, [])]
            medical_conditions = [cond.strip() for cond in profile.medical_conditions.split(',') if cond.strip()]
        except:
            allergies, liked_tags, medical_conditions = [], [], []

        # 3. 위치 추출
        location = llm.invoke([
            SystemMessage(content="다음 문장에서 장소 또는 지역명을 정확히 추출해 주세요"),
            HumanMessage(content=user_message)
        ]).content.strip()
        note = ""
        if not location or len(location) < 2:
            location = request.session.get("chatbot_last_location")
            note = " (최근 검색한 위치 기준)"
        else:
            request.session["chatbot_last_location"] = location

        if not location:
            return Response(
                {"response": "위치 정보가 필요해요! 예: '서울 강남역 2km 고기집'"},
                status=200
            )

        # 4. 페이지 처리
        page = request.session.get("chatbot_last_page", 1)
        if MORE_RESULTS_PATTERN.search(user_message):
            page = min(page + 1, 5)
        request.session["chatbot_last_page"] = page

        # 5. 좌표 가져오기
        lat, lng = get_coords_from_keyword(location)
        if lat is None or lng is None:
            return Response(
                {"response": "위치 정보를 찾을 수 없어요 😢"},
                status=200
            )

        # 6. 식당 검색
        places = search_kakao_restaurants(query, lat, lng, radius, page)
        if places and "error" not in places[0]:
            formatted = format_restaurant_info(places)

            #  알러지 경고 문구 생성
            allergy_warnings = []
            for allergen in allergies:
                stems = {allergen}
                if allergen.endswith("고기"):
                    stems.add(allergen[:-2])   # '돼지고기' -> '돼지'
                if allergen.endswith("류"):
                    stems.add(allergen[:-1])   # '조개류' -> '조개'
                if any(stem in user_message for stem in stems):
                  allergy_warnings.append(allergen)
                  continue
                for place in places:
                    name = place.get("name", "")
                    category = place.get("category", "")
                    if any(stem in name or stem in category for stem in stems):
                        allergy_warnings.append(allergen)
                        break

            warning_text = ""
            if allergy_warnings:
                warning_text = (
                    "⚠️ 주의: 사용자의 알러지({})에 해당할 수 있는 음식점입니다. 섭취 시 유의하세요!\n\n"
                    .format(", ".join(allergy_warnings))
                )

            # 7. 응답 메시지 구성
            response_text = (
                f"{warning_text}"
                f"{location} 근처 추천 리스트{note} (반경 {radius//1000}km)\n"
                f"{formatted}"
            )

            # 8. DB 저장
            if request.user.is_authenticated:
                ChatHistory.objects.create(
                    user_id=request.user.user_id,
                    message=user_message,
                    response=response_text
                )
                map_url = f"https://map.kakao.com/link/map/{lat},{lng}"
                ChatHistory.objects.create(
                    user_id=request.user.user_id,
                    message="",
                    response=map_url
                )

            return Response({
                "response": response_text,
                "map_lat": lat,
                "map_lng": lng
            }, status=200)

        # 추천 결과 없을 때
        return Response(
            {"response": f"{location} 근처 식당을 찾지 못했어요 😢"},
            status=200
        )


    def ask_gpt_yes_no(self, llm, user_message):
        try:
            res = llm.invoke([
                SystemMessage(content="You are a classifier for food messages. Reply 'Yes' or 'No'."),
                HumanMessage(content=user_message)
            ]).content.strip().lower()
            return "yes" if res.startswith("yes") else "no"
        except Exception as e:
            logger.error(f"Yes/No classification error: {e}")
            return "no"

    def keyword_based_correction(self, request, msg, decision):
        lower = msg.lower()
        if any(k in lower for k in HEALTH_KEYWORDS + COOKING_KEYWORDS):
            return "yes"
        if decision == "no":
            if re.search(r"(뭐\s*먹|추천|레시피|요리법)", lower):
                return "yes"
            if get_last_food_state(request.session) and re.search(r"(말고|추가|다른|더)", lower):
                return "yes"
            if recent_chat_contains_food_keyword(request.session):
                return "yes"
        return decision

    def post(self, request):
        user_message = request.data.get("message", "").strip()
        if not user_message:
            return Response({"error":"메시지를 입력해 주세요."}, status=400)

        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            return Response({"error":"OPENAI_API_KEY가 설정되지 않았습니다."}, status=500)

        # 1) 식당 찾기 우선 분기
        llm_cl = ChatOpenAI(model="gpt-4o", openai_api_key=api_key, temperature=0.3)
        topic = classify_topics(llm_cl, user_message)
        request.session["chatbot_last_topic"] = topic
        if topic == "식당 찾기":
            return self.handle_restaurant_search(request, llm_cl, user_message)

        # 2) 일반 음식 챗
        primary = self.ask_gpt_yes_no(llm_cl, user_message)
        final = self.keyword_based_correction(request, user_message, primary)
        if final != "yes":
            return Response({"response":NON_FOOD_PROMPT}, status=200)

        # 유저 컨텍스트 & 시스템 프롬프트
        allergies, liked, disliked, conditions = get_user_context(request.user)
        system_prompt = get_system_prompt(topic, request.user, liked, disliked, allergies, conditions)

        # 과거 대화 불러오기
        history = get_chat_session(request.session, topic)
        msgs = [SystemMessage(content=system_prompt)]
        for entry in history[-5:]:
            msgs.append(
                HumanMessage(content=entry["content"])
                if entry["role"] == "user"
                else AIMessage(content=entry["content"])
            )
        msgs.append(HumanMessage(content=user_message))

        # GPT 응답
        llm_chat = ChatOpenAI(model="gpt-4o", openai_api_key=api_key, temperature=0.3)
        bot_text = llm_chat.invoke(msgs).content.strip()

        # 3) 레시피 이미지 생성 (옵션)
        recipe_image_url = None
        if (topic == "요리"
            and any(k in user_message for k in ["레시피","만드는 법", "만들기", "만드는 방법", "만드는법","만들어"])
            and any(k in bot_text for k in ["레시피","조리법","만드는 법","요리법","만들기","방법"])
        ):
            try:
                img = OpenAI(api_key=api_key).images.generate(
                    model="dall-e-3",
                    prompt=f"A delicious dish: {bot_text}",
                    size="1024x1024", n=1
                )
                recipe_image_url = img.data[0].url if img.data else None
            except Exception as e:
                logger.error(f"이미지 생성 실패: {e}")

        # 4) 세션 및 DB 저장 (텍스트 + 이미지)
        history.extend([
            {"role":"user","content":user_message},
            {"role":"assistant","content":bot_text}
        ])
        set_chat_session(request.session, topic, history[-5:])
        set_last_food_state(request.session, True)

        if request.user.is_authenticated:
            # 텍스트 답변 저장
            ChatHistory.objects.create(
                user_id=request.user.user_id,
                message=user_message,
                response=bot_text
            )
            # 이미지 URL 저장 (response 필드에)
            if recipe_image_url:
                ChatHistory.objects.create(
                    user_id=request.user.user_id,
                    message="",
                    response=recipe_image_url
                )

        return Response({
            "response": f"푸렌즈가 알려드릴게요! {bot_text}",
            "recipe_image_url": recipe_image_url
        }, status=200)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_chat_history(request):
    user_id = request.user.user_id
    date_str = request.GET.get("date")
    qs = ChatHistory.objects.filter(user_id=user_id)
    if date_str:
        try:
            d = parse_date(date_str)
            start = make_aware(datetime.combine(d, datetime.min.time()))
            end = start + timedelta(days=1)
            qs = qs.filter(timestamp__range=(start, end))
        except Exception as e:
            return Response({'error':f'날짜 파싱 오류: {e}'}, status=400)
    qs = qs.order_by('timestamp')
    data = []
    for c in qs:
        if c.message:
          data.append({
            "sender": "user",
            "type": "text",
            "message": c.message
          })
        if c.response.startswith("https://map.kakao.com/link/map/"):
          data.append({
            "sender": "bot",
            "type": "map",
            "map_url": c.response
          })
        elif re.match(r'^https?://.*\.(png|jpe?g|gif)$', c.response):
          data.append({
            "sender": "bot",
            "type": "image",
            "image_url": c.response
          })
        else:
          data.append({
            "sender": "bot",
            "type": "text",
            "message": c.response
          })
    return JsonResponse(data, safe=False, json_dumps_params={'ensure_ascii':False})

