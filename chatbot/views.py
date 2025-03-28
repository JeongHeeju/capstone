import json, re, os, logging
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
#from langchain_openai import ChatOpenAI#
from langchain_community.chat_models import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from dotenv import load_dotenv
from django.shortcuts import get_object_or_404
from rest_framework.permissions import AllowAny


from users.models import User, UserProfile, FoodPreference, Allergy

# 환경 변수 로드
load_dotenv()

def get_last_food_state(session):
    return session.get("last_was_food", False)

def set_last_food_state(session, is_food):
    session["last_was_food"] = is_food
    session.modified = True

load_dotenv()
logger = logging.getLogger(__name__)

class ChatAPIView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        try:
            user_message = request.data.get("message", "").strip()
            if not user_message:
                return Response({"error": "Message is required."}, status=status.HTTP_400_BAD_REQUEST)

            api_key = os.getenv("OPENAI_API_KEY")
            if not api_key:
                logger.error("OPENAI_API_KEY is missing.")
                return Response({"error": "OPENAI_API_KEY not found."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            try:
                llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=api_key, temperature=0)
            except Exception as e:
                logger.error(f"GPT init error: {e}")
                return Response({"error": "GPT model initialization failed."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            if request.user.is_authenticated:
                try:
                    user_profile = UserProfile.objects.get(user_id=request.user)
                except UserProfile.DoesNotExist:
                    return Response({"error": "UserProfile not found."}, status=status.HTTP_400_BAD_REQUEST)
                preferences = FoodPreference.objects.filter(user=user_profile)
                allergies = Allergy.objects.filter(user=user_profile)
                medical_conditions_list = []
                if user_profile.medical_conditions:
                    medical_conditions_list = [c.strip() for c in user_profile.medical_conditions.split(',')]
                system_prompt = (
                    "You are 푸렌즈, an AI assistant specializing in food and dining.\n"
                    "User Profile Information:\n"
                    f"Medical Conditions: {medical_conditions_list}\n"
                    f"Allergies: {[al.allergy_name for al in allergies]}\n"
                    f"Liked Foods: {[p.food_name for p in preferences if p.is_liked]}\n"
                    f"Disliked Foods: {[p.food_name for p in preferences if not p.is_liked]}\n"
                    "Based on this information, provide personalized meal suggestions in Korean.\n"
                )
            else:
                system_prompt = (
                    "You are 푸렌즈, an AI assistant specializing in food and dining.\n"
                    "Provide general meal suggestions in Korean.\n"
                )

            primary_decision = self.ask_gpt_yes_no(
                llm,
                "You are a classifier that decides if a user message is strictly about food or dining. "
                "Respond ONLY with 'Yes' or 'No'.\nQuestion: ",
                user_message
            )
            if not primary_decision:
                primary_decision = "no"

            final_decision = self.keyword_based_correction(user_message, primary_decision)

            last_was_food = get_last_food_state(request.session)
            followup_pattern = r"(말고|더\s*없|추가|다른\s*메뉴|색다른|새로운|또\s*뭐)"
            if last_was_food and final_decision == "no":
                if re.search(followup_pattern, user_message.lower()):
                    final_decision = "yes"
            is_food_related = (final_decision == "yes")

            if is_food_related:
                system_msg = SystemMessage(content=system_prompt)
                user_msg = HumanMessage(content=user_message)
                try:
                    result_msg = llm.invoke([system_msg, user_msg])
                    bot_text = result_msg.content.strip()
                except Exception as e:
                    logger.error(f"GPT invocation error: {e}")
                    bot_text = "Error generating response. Please try again later."
                final_answer = f"푸렌즈가 알려드릴게요! {bot_text}"
                set_last_food_state(request.session, True)
            else:
                final_answer = "푸렌즈는 음식 관련 질문에만 답변할 수 있어요!"
                set_last_food_state(request.session, False)

            # 로그인 상태 표시 제거
            final_answer_with_status = final_answer

            return Response({
                "user_message": user_message,
                "response": final_answer_with_status,
            }, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(f"Server error: {e}")
            return Response({"error": "Internal server error. Please try again later."}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def ask_gpt_yes_no(self, llm, prompt_text, user_message):
        sys_msg = SystemMessage(content=prompt_text + user_message)
        user_msg = HumanMessage(content=user_message)
        ai_response = llm.invoke([sys_msg, user_msg])
        raw_output = ai_response.content.strip().lower()
        first_token = raw_output.split()[0] if raw_output else ""
        if first_token.startswith("yes"):
            return "yes"
        elif first_token.startswith("no"):
            return "no"
        else:
            return None

    def keyword_based_correction(self, user_message, gpt_decision):
        user_lower = user_message.lower()
        food_keywords = [
            "아침", "점심", "저녁", "식사", "메뉴", "맛집", "레시피", "요리",
            "배달", "주문", "카페", "디저트", "간식", "다이어트", "건강식",
            "추천", "뭐 먹을까", "뭘 먹지", "음식", "밥", "국", "찌개",
            "비빔밥", "라면", "샌드위치", "피자", "햄버거", "치킨", "샐러드"
        ]
        if gpt_decision == "no":
            if any(k in user_lower for k in food_keywords):
                if re.search(r"(추천|뭐\s*먹|뭘\s*먹|메뉴|맛집|레시피|요리|식사|배달)", user_lower):
                    return "yes"
        return gpt_decision
