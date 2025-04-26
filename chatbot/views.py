import json, re, os, logging, openai
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage, AIMessage
from dotenv import load_dotenv
from django.shortcuts import get_object_or_404
from rest_framework.permissions import AllowAny
from users.models import UserProfile, FoodPreference, Allergy
from .models import ChatHistory
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from django.http import JsonResponse
from django.utils.dateparse import parse_date
from datetime import datetime, timedelta
from django.utils.timezone import make_aware
from openai import OpenAI

load_dotenv()
logger = logging.getLogger(__name__)

FOOD_TAGS = {
    "불고기": ["양념고기", "익힌고기", "소고기", "달짝지근한 맛"],
    "김치찌개": ["매운맛", "국물요리", "돼지고기", "김치"],
    "비빔밥": ["채소", "고추장", "비벼먹는 음식"],
    "떡볶이": ["떡", "매운맛", "간식", "분식"],
    "삼겹살": ["구이", "돼지고기", "쌈채소"],
    "초밥": ["해산물", "생선", "밥", "일식"],
    "햄버거": ["패스트푸드", "빵", "고기", "치즈"],
    "쌀국수": ["면요리", "국물요리", "베트남 음식"],
    "샐러드": ["채소", "건강식", "다이어트식"],
    "케이크": ["디저트", "달콤한맛", "빵", "크림"],
}

def get_last_food_state(session):
    return session.get("last_was_food", False)

def set_last_food_state(session, is_food):
    session["last_was_food"] = is_food
    session.modified = True

def get_chat_session(session, topic="default"):
    sessions = session.get("chat_sessions", {})
    return sessions.get("topics", {}).get(topic, [])

def set_chat_session(session, topic, history):
    if "chat_sessions" not in session:
        session["chat_sessions"] = {"current_topic": topic, "topics": {topic: history}}
    else:
        session["chat_sessions"]["current_topic"] = topic
        if "topics" not in session["chat_sessions"]:
            session["chat_sessions"]["topics"] = {}
        session["chat_sessions"]["topics"][topic] = history
    session.modified = True

def extract_topic_with_gpt(llm, user_message):
    system_msg = SystemMessage(content=(
        "You are a topic classifier for food-related user queries.\n"
        "Possible topics: 한식, 양식, 일식, 중식, 다이어트, 디저트, 카페, 기타.\n"
        "Respond ONLY with the topic name from the list above, nothing else."
    ))
    user_msg = HumanMessage(content=user_message)

    try:
        result = llm.invoke([system_msg, user_msg])
        topic = result.content.strip()
        allowed_topics = ["한식", "양식", "일식", "중식", "다이어트", "디저트", "카페", "기타"]
        return topic if topic in allowed_topics else "기타"
    except Exception as e:
        logger.error(f"Topic classification error: {e}")
        return "기타"

class ChatAPIView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        try:
            user_message = request.data.get("message", "").strip()
            if not user_message:
                return Response({"error": "메시지를 입력받지 못했어요. :("}, status=status.HTTP_400_BAD_REQUEST)

            api_key = os.getenv("OPENAI_API_KEY")
            if not api_key:
                logger.error("OPENAI_API_KEY is missing.")
                return Response({"error": "OPENAI_API_KEY를 확인해주세요. :)"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            llm = ChatOpenAI(model="gpt-4-turbo", openai_api_key=api_key, temperature=0.3, max_tokens=1024)
            openai_client = OpenAI(api_key=api_key)

            if request.user.is_authenticated:
                try:
                    user_profile = UserProfile.objects.get(user_id=request.user)
                    preferences = FoodPreference.objects.filter(user=user_profile)
                    allergies = Allergy.objects.filter(user=user_profile)

                    liked_foods = [p.food_name for p in preferences if p.is_liked]
                    disliked_foods = [p.food_name for p in preferences if not p.is_liked]
                    liked_tags = [tag for food in liked_foods for tag in FOOD_TAGS.get(food, [])]
                    disliked_tags = [tag for food in disliked_foods for tag in FOOD_TAGS.get(food, [])]

                    system_prompt = (
                        "너는 '푸렌즈'라는 이름을 가진 친절한 한국어 식단 추천 챗봇이야."
                        "항상 사용자 입장에서 공감하며, 부담 없는 말투로 이야기해줘."
                        "의학적 진단이나 치료는 하지 않고, 사용자의 건강 상태에 맞춰 식단만 제안해야 해."
                        "허구의 요리 이름이나 검증되지 않은 레시피는 절대 추천하지 마."
                        "다양한 스타일의 요리를 제안하되, 실제 존재하는 음식이나 일반적으로 알려진 요리를 사용해."
                        f"- 알레르기: {[al.allergy_name for al in allergies]}"
                        f"- 좋아하는 음식: {liked_foods} (관련 태그: {liked_tags})"
                        f"- 싫어하는 음식: {disliked_foods} (관련 태그: {disliked_tags})"
                    )
                except Exception as e:
                    logger.error(f"User profile fetch error: {e}")
                    system_prompt = (
                        "너는 '푸렌즈'라는 이름을 가진 친절한 한국어 식단 추천 챗봇이야."
                        "항상 사용자 입장에서 공감하며, 부담 없는 말투로 이야기해줘."
                        "의학적 진단이나 치료는 하지 않고, 사용자가 부담 없이 즐길 수 있는 음식을 추천해줘."
                        "허구의 요리 이름이나 검증되지 않은 레시피는 절대 추천하지 마."
                        "다양한 스타일의 요리를 제안하되, 실제 존재하는 음식이나 일반적으로 알려진 요리를 사용해."
                    )
            else:
                system_prompt = (
                    "너는 '푸렌즈'라는 이름을 가진 친절한 한국어 식단 추천 챗봇이야."
                    "항상 사용자 입장에서 공감하며, 부담 없는 말투로 이야기해줘."
                    "의학적 진단이나 치료는 하지 않고, 사용자가 부담 없이 즐길 수 있는 음식을 추천해줘."
                    "허구의 요리 이름이나 검증되지 않은 레시피는 절대 추천하지 마."
                    "다양한 스타일의 요리를 제안하되, 실제 존재하는 음식이나 일반적으로 알려진 요리를 사용해."
                )

            primary_decision = self.ask_gpt_yes_no(llm, user_message)
            final_decision = self.keyword_based_correction(user_message, primary_decision)
            is_food_related = (final_decision == "yes")

            if not is_food_related:
                return Response({"response": "푸렌즈는 음식 관련 질문에만 답변할 수 있어요!"}, status=status.HTTP_200_OK)

            topic = extract_topic_with_gpt(llm, user_message)
            prev_topic = request.session.get("chat_sessions", {}).get("current_topic", None)
            recipe_followup_keywords = ["레시피", "만드는 법", "조리법", "요리법", "요리", "또 뭐 있어", "다른 메뉴"]
            is_recipe_followup = any(k in user_message.lower() for k in recipe_followup_keywords)

            if topic != prev_topic and not is_recipe_followup:
                chat_history = []
            else:
                chat_history = get_chat_session(request.session, prev_topic or topic)

            messages = [SystemMessage(content=system_prompt)]
            for entry in chat_history[-5:]:
                if entry["role"] == "user":
                    messages.append(HumanMessage(content=entry["content"]))
                elif entry["role"] == "assistant":
                    messages.append(AIMessage(content=entry["content"]))
            messages.append(HumanMessage(content=user_message))

            result_msg = llm.invoke(messages)
            bot_text = result_msg.content.strip()

            final_answer = f"푸렌즈가 알려드릴게요! {bot_text}"

            chat_history.append({"role": "user", "content": user_message})
            chat_history.append({"role": "assistant", "content": bot_text})
            chat_history = chat_history[-5:]
            set_chat_session(request.session, topic, chat_history)
            set_last_food_state(request.session, True)

            if request.user.is_authenticated:
                ChatHistory.objects.create(
                    user_id=request.user.user_id,
                    message=user_message,
                    response=final_answer
                )

            return Response({
                "response": final_answer,
                "recipe_image_url": None  # 필요 시 이미지 처리 가능
            }, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(f"Server error: {e}")
            return Response({"error": "Internal server error."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def ask_gpt_yes_no(self, llm, user_message):
        messages = [
            SystemMessage(content="You are a Korean chatbot that ONLY classifies whether a message is food or eating related. Respond only with 'Yes' or 'No'."),
            HumanMessage(content=user_message)
        ]
        ai_response = llm.invoke(messages)
        raw_output = ai_response.content.strip().lower()
        first_token = raw_output.split()[0] if raw_output else ""
        if first_token.startswith("yes"):
            return "yes"
        elif first_token.startswith("no"):
            return "no"
        return None

    def keyword_based_correction(self, user_message, gpt_decision):
        def recent_chat_contains_food_keyword(session):
            recent_chats = []
            for topic_chats in session.get("chat_sessions", {}).get("topics", {}).values():
                recent_chats.extend(topic_chats[-3:])
            keywords = ["레시피", "요리", "재료", "음식", "조리", "먹어", "만드는 법"]
            return any(any(k in c["content"] for k in keywords) for c in recent_chats if c["role"] == "user")

        user_lower = user_message.lower()
        strong_pattern = r"(뭐\s*먹(을|지)|먹(고\s*싶|을까)|추천(해)?줘|요리법|레시피|만드는\s*법|조리법)"
        followup_pattern = r"(말고|더\s*없|추가|다른.*|색다른|새로운|또\s*뭐|다른\s*건|다른\s*거)"

        if gpt_decision == "no":
            if re.search(strong_pattern, user_lower):
                return "yes"
            elif get_last_food_state(self.request.session) and re.search(followup_pattern, user_lower):
                return "yes"
            elif recent_chat_contains_food_keyword(self.request.session):
                return "yes"

        return gpt_decision

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_chat_history(request):
    user_id = request.user.user_id
    date_str = request.GET.get("date", None)
    chats = ChatHistory.objects.filter(user_id=user_id)

    if date_str:
        try:
            date_obj = parse_date(date_str)
            start = make_aware(datetime.combine(date_obj, datetime.min.time()))
            end = make_aware(datetime.combine(date_obj + timedelta(days=1), datetime.min.time()))
            chats = chats.filter(timestamp__range=(start, end))
        except Exception as e:
            return Response({'error': f'날짜 파싱 오류: {e}'}, status=400)

    chats = chats.order_by('timestamp')
    data = []
    for chat in chats:
        data.append({"sender": "user", "message": chat.message})
        data.append({"sender": "bot", "message": chat.response})

    return JsonResponse(data, safe=False, json_dumps_params={'ensure_ascii': False})
