import json
import re
import os
import logging
from typing import Any, Dict, List
from dotenv import load_dotenv

from django.http import HttpResponse, JsonResponse
from django.shortcuts import get_object_or_404
from django.utils.dateparse import parse_date
from django.utils.timezone import make_aware
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from openai import OpenAI
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage

from users.models import User, UserProfile, FoodPreference, Allergy
from .models import ChatHistory

# ────────── session_helpers (Developer code) ──────────
load_dotenv()
logger = logging.getLogger(__name__)

from .prompt_utils import MORE_RESULTS_PATTERN

def get_last_food_state(session: Dict[str, Any]) -> bool:
    return bool(session.get("last_was_food", False))


def set_last_food_state(session: Dict[str, Any], is_food: bool) -> None:
    session["last_was_food"] = is_food
    session.modified = True


def get_chat_session(session: Dict[str, Any], topic: str = "default") -> List[Dict[str, Any]]:
    return session.get("chat_sessions", {}).get("topics", {}).get(topic, [])


def set_chat_session(session: Dict[str, Any], topic: str, history: List[Dict[str, Any]]) -> None:
    session.setdefault("chat_sessions", {"topics": {}})
    session["chat_sessions"]["current_topic"] = topic
    session["chat_sessions"]["topics"][topic] = history
    session.modified = True


def recent_chat_contains_food_keyword(session: Dict[str, Any], check_count: int = 3) -> bool:
    topics = session.get("chat_sessions", {}).get("topics", {})
    recent = []
    for msgs in topics.values():
        recent.extend(msgs[-check_count:])
    keywords = ["레시피","요리","재료","음식","조리","먹어","만드는 법"]
    return any(
        m.get("role") == "user" and any(kw in m.get("content","") for kw in keywords)
        for m in recent
    )


def clear_chat_sessions(session: Dict[str, Any]) -> None:
    session["chat_sessions"] = {"current_topic": None, "topics": {}}
    session.modified = True


def is_follow_up_question(message: str, session: Dict[str, Any]) -> bool:
    if MORE_RESULTS_PATTERN.search(message):
        return True
    keywords = ["그건?","더","추가","또","말해줘","그 외"]
    if any(kw in message for kw in keywords):
        return True
    prev = session.get("chat_sessions", {}).get("current_topic", "")
    recent = session.get("chat_sessions", {}).get("topics", {}).get(prev, [])
    user_msgs = [m.get("content","") for m in recent if m.get("role")=="user"]
    last_two = user_msgs[-2:]
    return any(len(m)<=10 for m in last_two)

# ────────── ChatAPIView (User code) ──────────
class ChatAPIView(APIView):
    def post(self, request):
        try:
            # 1. 사용자 입력 검증
            user_message = request.data.get("message", "").strip()
            if not user_message:
                return Response({"error": "Message is required."}, status=status.HTTP_400_BAD_REQUEST)

            # 2. OpenAI API 키
            api_key = os.getenv("OPENAI_API_KEY")
            if not api_key:
                logger.error("OpenAI API key missing.")
                return Response({"error": "OPENAI_API_KEY not found."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            # 3. GPT 모델 초기화
            try:
                llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=api_key, temperature=0)
            except Exception as e:
                logger.error(f"GPT init error: {e}")
                return Response({"error": "GPT initialization failed."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            # 5. 1차 분류
            primary = self.ask_gpt_yes_no(
                llm,
                "You are a classifier that decides if a user message is strictly about food or dining. Respond ONLY with 'Yes' or 'No'.\n\nQuestion: ",
                user_message
            ) or "no"

            # 6. 키워드 보정
            final_decision = self.keyword_based_correction(user_message, primary)

            # 7. 전 대화 상태 보정
            last_was = get_last_food_state(request.session)
            followup_pat = r"(말고|더\s*없|추가|다른\s*메뉴|색다른|새로운|또\s*뭐)"
            if last_was and final_decision == "no" and re.search(followup_pat, user_message.lower()):
                logger.info("Override to yes based on follow-up pattern.")
                final_decision = "yes"

            is_food = (final_decision == "yes")

            # 8. 응답 생성
            if is_food:
                # TODO: 정의되지 않은 변수 medical_conditions_list, preferences 사용
                system = SystemMessage(content=(
                    "You are 푸렌즈, an AI assistant specializing in food and dining.\n"
                    f"Allergies: {[a.allergy_name for a in allergies]}\n"
                ))
                user_msg = HumanMessage(content=user_message)
                try:
                    res = llm.invoke([system, user_msg])
                    bot_text = res.content.strip()
                except Exception as e:
                    logger.error(f"GPT invoke error: {e}")
                    bot_text = "답변 생성 중 오류 발생."

                final_answer = f"푸렌즈가 알려드릴게요! {bot_text}"
                set_last_food_state(request.session, True)
            else:
                final_answer = "푸렌즈는 음식 관련 질문에만 답변할 수 있어요!"
                set_last_food_state(request.session, False)

            return Response({
                "user_message": user_message,
                "response": final_answer,
                "debug": {"primary": primary, "final": final_decision, "prev_was_food": last_was}
            }, status=status.HTTP_200_OK)
        except Exception as e:
            logger.error(f"Server error: {e}")
            return Response({"error": "Internal server error."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def ask_gpt_yes_no(self, llm, prompt_text, user_message):
        system_msg = SystemMessage(content=prompt_text + user_message)
        user_msg = HumanMessage(content=user_message)
        res = llm.invoke([system_msg, user_msg]).content.strip().lower()
        if res.startswith("yes"): return "yes"
        if res.startswith("no"): return "no"
        return None

    def keyword_based_correction(self, user_message: str, decision: str) -> str:
        lower = user_message.lower()
        food_keys = ["아침","점심","저녁","식사","메뉴","맛집","레시피","요리"]
        if decision == "no" and any(k in lower for k in food_keys):
            if re.search(r"(추천|뭐\s*먹|메뉴|맛집|레시피|요리)", lower):
                logger.info("Keyword override no->yes.")
                return "yes"
        return decision

# 채팅 히스토리 조회
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_chat_history(request):
    user_id = request.user.user_id
    date_str = request.GET.get('date')
    qs = ChatHistory.objects.filter(user_id=user_id)
    if date_str:
        try:
            d = parse_date(date_str)
            start = make_aware(datetime.combine(d, datetime.min.time()))
            end = start + timedelta(days=1)
            qs = qs.filter(timestamp__range=(start, end))
        except Exception as e:
            return Response({'error': f"Date parse error: {e}"}, status=400)
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
