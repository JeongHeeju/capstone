from django.urls import path
from .views import ChatAPIView, get_chat_history 
from .views import ChatAPIView, proxy_kakao_map_image

urlpatterns = [
    path('chat/', ChatAPIView.as_view(), name='chatbot'), 
    path('chat/history/', get_chat_history),
    path('proxy/map/', proxy_kakao_map_image, name='proxy_kakao_map'),
]
