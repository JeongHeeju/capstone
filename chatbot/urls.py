from django.urls import path
from .views import ChatAPIView

urlpatterns = [
    path('chat/', ChatAPIView.as_view(), name='chatbot'),  # '/api/chat/'로 접근 가능
]