
from django.contrib.auth import views as auth_views
from django.urls import path
from . import views

urlpatterns = [
    path('signup/', views.signup, name='signup'),
    path('login/', views.login_view, name='login'),
    path('save_personal_info/', views.save_personal_info, name='save_personal_info'),
    path('save_food_preferences/', views.save_food_preferences, name='save_food_preferences'),
    path('save_allergy_info/', views.save_allergy_info, name='save_allergy_info'),
]