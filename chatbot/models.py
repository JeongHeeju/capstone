from django.db import models
class ChatHistory(models.Model):
    user_id = models.CharField(max_length=100)
    message = models.TextField()
    response = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

class ChatMessage(models.Model):
    user_message = models.TextField()  # 사용자 메시지
    bot_response = models.TextField()  # 챗봇 응답
    timestamp = models.DateTimeField(auto_now_add=True)  # 타임스탬프

    def __str__(self):
        return f"User: {self.user_message[:50]} | Bot: {self.bot_response[:50]}"
# Create your models here.
