from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from .forms import UserRegisterForm, UserLoginForm
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from .models import User, UserProfile, UserSurveyRecord
from .serializers import (
    UserSerializer, UserLoginSerializer, UserProfileSerializer,
    FoodPreferenceSerializer, AllergySerializer, PersonalInfoSerializer
)
from django.contrib.auth.hashers import make_password
from django.http import JsonResponse
from rest_framework.authtoken.models import Token


@api_view(['POST'])
def signup(request):
    data = request.data
    if User.objects.filter(user_id=data['user_id']).exists():
        return Response({'error': 'Username already exists'}, status=400)
    try:
        user = User.objects.create(
            user_id=data['user_id'],
            username=data['username'],
            password=make_password(data['password'])
        )
        return Response({'message': 'User created successfully'}, status=201)
    except Exception as e:
        return Response({'error': str(e)}, status=400)


@api_view(['POST'])
def login_view(request):
    data = request.data
    user = authenticate(user_id=data['user_id'], password=data['password'])
    print("DEBUG: user =", user, "| type =", type(user))
    if user:
      token, _ = Token.objects.get_or_create(user=user)
      return Response({'message': 'Login successful', 'user_id': user.user_id, 'token': token.key}, status=200)
    return Response({'error': 'Invalid credentials'}, status=400)
    print('로그인된 user:',user,type(user))


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def profile_exists(request):
  user = request.user
  exists = UserProfile.objects.filter(user_id=user). exists()
  return Response({'exists': exists})


# 설문조사 저장 부분
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_personal_info(request):
    data = request.data  
    user = request.user
    user_profile = UserProfile.objects.filter(user_id=user).first()
    if not user_profile:
        user_profile = UserProfile(user_id=user)

    serializer = PersonalInfoSerializer(instance=user_profile, data=data, partial=True)
    if serializer.is_valid():
        serializer.save(user_id=user)
        return Response({'message': 'Personal information saved successfully'}, status=status.HTTP_201_CREATED)
    else:
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_food_preferences(request):
    data = request.data
    user_profile = UserProfile.objects.get(user_id=request.user)
    for item in data:
        serializer = FoodPreferenceSerializer(data=item)
        if serializer.is_valid():
            serializer.save(user=user_profile)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response({'message': 'Food preferences saved successfully'}, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_allergy_info(request):
    data = request.data
    user_profile = UserProfile.objects.get(user_id=request.user)  # 사용자 프로필 가져오기
    for item in data:
        serializer = AllergySerializer(data=item)
        if serializer.is_valid():
            serializer.save(user=user_profile)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response({'message': 'Allergy information saved successfully'}, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_all_in_one(request):
    serializer = UserProfileSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'All data saved'}, status=201)
    return Response(serializer.errors, status=400)
