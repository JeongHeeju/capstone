import json, re, os, logging
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
#from langchain_openai import ChatOpenAI#
from langchain_community.chat_models import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage
from dotenv import load_dotenv
from django.shortcuts import get_object_or_404

from users.models import User, UserProfile, FoodPreference, Allergy

# 환경 변수 로드
load_dotenv()

# 세션에 대화 이력(또는 마지막 상태) 저장/로드
def get_last_food_state(session):
    """ 마지막 메시지가 음식 대화였는지 여부를 불러옴 """
    return session.get("last_was_food", False)

def set_last_food_state(session, is_food):
    """ 마지막 메시지가 음식 대화였는지 여부를 세션에 저장 """
    session["last_was_food"] = is_food
    session.modified = True

load_dotenv()
logger = logging.getLogger(__name__)


class ChatAPIView(APIView):
    def post(self, request):
        try:
            # 1. 사용자 입력 검증
            user_message = request.data.get("message", "").strip()
            if not user_message:
                return Response({"error": "Message is required."}, status=status.HTTP_400_BAD_REQUEST)

            # 2. 환경 변수 검증
            api_key = os.getenv("OPENAI_API_KEY")
            if not api_key:
                logger.error("OpenAI API key is missing in environment variables.")
                return Response(
                    {"error": "OpenAI API key not found. Check your environment variables."},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )

            # 3. GPT 모델 초기화
            try:
                llm = ChatOpenAI(model="gpt-3.5-turbo", openai_api_key=api_key, temperature=0)
            except Exception as e:
                logger.error(f"OpenAI model initialization error: {e}")
                return Response(
                    {"error": "GPT 모델을 초기화할 수 없습니다. 잠시 후 다시 시도해 주세요."},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )

            # 4. 하드코딩된 유저 정보 불러오기
            try:
                test_user = User.objects.get(user_id='qqqq1111')
                user_profile = UserProfile.objects.get(user_id=test_user)
                preferences = FoodPreference.objects.filter(user=user_profile)
                allergies = Allergy.objects.filter(user=user_profile)

                medical_conditions_list = []
                if user_profile.medical_conditions:
                    medical_conditions_list = [
                        cond.strip() for cond in user_profile.medical_conditions.split(',')
                    ]
            except (User.DoesNotExist, UserProfile.DoesNotExist) as e:
                logger.error(f"Test user or UserProfile not found: {e}")
                return Response(
                    {"error": "Test user (qqqq1111) not found in DB."},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )

            # 5. 음식 관련 여부 1차 판단
            primary_decision = self.ask_gpt_yes_no(
                llm,
                "You are a classifier that decides if a user message is strictly about food or dining. "
                "Respond ONLY with 'Yes' or 'No'. Nothing else.\n\nQuestion: ",
                user_message
            )
            if not primary_decision:
                primary_decision = "no"

            # 6. 키워드 보정 로직
            final_decision = self.keyword_based_correction(user_message, primary_decision)

            # ──────────────────────────────────────────────────────────
            # 7. **직전 대화가 음식 주제였다면** 이번 메시지도 yes로 보정 (대화 맥락 이어가기)
            #    단, 사용자가 "주제 전환"을 명시적으로 하지 않았다면 계속 yes
            # ──────────────────────────────────────────────────────────
            last_was_food = get_last_food_state(request.session)
            # "그거 말고는 없어?" 같은 후속 맥락인지 확인하는 간단한 조건식
            # (예: 다른 새로운 주제를 묻는 게 아니라면 그대로 yes로 간주)
            followup_pattern = r"(말고|더\s*없|추가|다른\s*메뉴|색다른|새로운|또\s*뭐)"

            if last_was_food and final_decision == "no":
                # 만약 현재 메시지에 음식 키워드가 없더라도
                # "그거 말고는 없어?" 등 맥락 상 후속 질문이라면 yes로 보정
                if re.search(followup_pattern, user_message.lower()):
                    logger.info("Continuing the conversation about food. Overriding 'no' to 'yes' based on context.")
                    final_decision = "yes"

            is_food_related = (final_decision == "yes")

            # 8. 최종 응답 생성
            if is_food_related:
                # 음식 주제이면 SystemMessage (사용자 정보 반영)
                system_answer_msg = SystemMessage(
                    content=(
                        "You are 푸렌즈, an AI assistant specializing in food and dining.\n"
                        "You have user profile info. They have certain allergies, preferences, and possibly medical conditions.\n"
                        "Even if the user expresses emotion (like feeling sad), you can provide relevant food suggestions.\n\n"
                        f"Medical Conditions: {medical_conditions_list}\n"
                        f"Allergies: {[al.allergy_name for al in allergies]}\n"
                        f"Liked Foods: {[p.food_name for p in preferences if p.is_liked]}\n"
                        f"Disliked Foods: {[p.food_name for p in preferences if not p.is_liked]}\n\n"
                        "Respond in Korean, focusing on meal suggestions, recipes, or dining info.\n"
                        "Try to avoid recommending any allergens. Also provide creative or varied suggestions when possible.\n"
                    )
                )
                user_msg = HumanMessage(content=user_message)

                try:
                    result_msg = llm.invoke([system_answer_msg, user_msg])
                    bot_text = result_msg.content.strip()
                except Exception as e:
                    logger.error(f"Error during GPT invocation: {e}")
                    bot_text = "답변을 생성하는 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."

                final_answer = f"푸렌즈가 알려드릴게요! {bot_text}"
                # 대화 끝나고, 이번 메시지를 '음식 대화'로 표시
                set_last_food_state(request.session, True)

            else:
                final_answer = "푸렌즈는 음식 관련 질문에만 답변할 수 있어요!"
                set_last_food_state(request.session, False)

            return Response(
                {
                    "user_message": user_message,
                    "response": final_answer,
                    "debug_info": {
                        "primary_decision": primary_decision,
                        "final_decision": final_decision,
                        "last_was_food_before": last_was_food,
                        "test_user": "qqqq1111"
                    }
                },
                status=status.HTTP_200_OK
            )

        except Exception as e:
            logger.error(f"Server error: {e}")
            return Response(
                {"error": "서버 내부 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def ask_gpt_yes_no(self, llm, prompt_text, user_message):
        system_msg = SystemMessage(content=prompt_text + user_message)
        user_msg = HumanMessage(content=user_message)

        ai_response = llm.invoke([system_msg, user_msg])
        raw_output = ai_response.content.strip().lower()

        logger.info(f"Classifier GPT response: {raw_output}")
        first_token = raw_output.split()[0] if raw_output else ""
        if first_token.startswith("yes"):
            return "yes"
        elif first_token.startswith("no"):
            return "no"
        else:
            logger.warning(f"Unexpected GPT response for classification: {raw_output}")
            return None

    def keyword_based_correction(self, user_message: str, gpt_decision: str) -> str:
        user_lower = user_message.lower()
        food_keywords = [
            "아침", "점심", "저녁", "식사", "메뉴", "맛집", "레시피", "요리",
            "배달", "주문", "카페", "디저트", "간식", "다이어트", "건강식",
            "추천", "뭐 먹을까", "뭘 먹지", "음식", "밥", "국", "찌개",
            "비빔밥", "라면", "샌드위치", "피자", "햄버거", "치킨", "샐러드"
        ]
        if gpt_decision == "no":
            if any(keyword in user_lower for keyword in food_keywords):
                if re.search(r"(추천|뭐\s*먹|뭘\s*먹|메뉴|맛집|레시피|요리|식사|배달)", user_lower):
                    logger.info("Keyword-based correction: Overriding 'no' -> 'yes'")
                    return "yes"
        return gpt_decision

