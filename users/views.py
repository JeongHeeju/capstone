from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate
from .forms import UserRegisterForm, UserLoginForm
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import User, UserProfile
from .serializers import UserSerializer, UserLoginSerializer, UserProfileSerializer, FoodPreferenceSerializer, AllergySerializer, UserProfileSerializer,PersonalInfoSerializer
from django.contrib.auth.hashers import make_password
from django.http import JsonResponse
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.decorators import api_view, permission_classes


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
    if user:
        return Response({'message': 'Login successful', 'user_id': user.user_id}, status=200)
    return Response({'error': 'Invalid credentials'}, status=400)


#설문조사 저장 부분
@api_view(['POST'])
@permission_classes([AllowAny])
def save_personal_info(request):
    data = request.data  
    serializer = UserProfileSerializer(data=data)  
    test_user = User.objects.get(user_id='qqqq1111')
    user_profile = UserProfile.objects.filter(user_id=test_user).first()
    if not user_profile:
      user_profile = UserProfile(user_id=test_user)
    
    serializer = PersonalInfoSerializer(instance=user_profile, data=data, partial=True)
    if serializer.is_valid():
        serializer.save(user_id=test_user) 
        return Response({'message': 'Personal information saved successfully'}, status=status.HTTP_201_CREATED)
    else:
        print("Validation failed:", serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)  



@api_view(['POST'])
def save_food_preferences(request):
    data = request.data
    user_profile = UserProfile.objects.get(user_id__user_id='qqqq1111')  
    for item in data:
        serializer = FoodPreferenceSerializer(data=item)
        if serializer.is_valid():
            serializer.save(user=user_profile)  
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response({'message': 'Food preferences saved successfully'}, status=status.HTTP_201_CREATED)


@api_view(['POST'])
def save_allergy_info(request):
    data = request.data
    user_profile = UserProfile.objects.get(user_id__user_id='qqqq1111')  # 사용자 프로필 가져오기
    for item in data:
        serializer = AllergySerializer(data=item)
        if serializer.is_valid():
            serializer.save(user=user_profile)  # 사용자 프로필 연결
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    return Response({'message': 'Allergy information saved successfully'}, status=status.HTTP_201_CREATED)

@api_view(['POST'])
@permission_classes([AllowAny])  # 인증을 무시해서 테스트 쉽게
def save_all_in_one(request):
    serializer = UserProfileSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({'message': 'All data saved'}, status=201)
    return Response(serializer.errors, status=400)