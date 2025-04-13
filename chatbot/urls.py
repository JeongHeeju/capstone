from django.urls import path
from .views import ChatAPIView, get_chat_history 

urlpatterns = [
    path('chat/', ChatAPIView.as_view(), name='chatbot'), 
    path('chat/history/', get_chat_history),
]
