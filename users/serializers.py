from rest_framework import serializers
from .models import User, UserProfile, FoodPreference, Allergy

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'user_id', 'password']

class UserLoginSerializer(serializers.Serializer):
    user_id = serializers.CharField(max_length=50)
    password = serializers.CharField(max_length=100)

class PersonalInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['gender', 'birth_date', 'height', 'weight', 'medical_conditions']

class FoodPreferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = FoodPreference
        fields = ['food_name', 'is_liked']
        extra_kwargs = {
            'user': {'read_only': True}  # 클라이언트에서 직접 설정하지 못하도록 read_only 설정
        }


class AllergySerializer(serializers.ModelSerializer):
    class Meta:
        model = Allergy
        fields = ['allergy_name']
        extra_kwargs = {
            'user': {'read_only': True}  # 클라이언트에서 직접 설정하지 못하도록 read_only 설정
        }
    
#설문조사 저장 부분
class UserProfileSerializer(serializers.ModelSerializer):
    food_preferences = FoodPreferenceSerializer(many=True, required=False)
    allergies = AllergySerializer(many=True, required=False)

    class Meta:
        model = UserProfile
        fields = ['user_id', 'gender', 'birth_date', 'height', 'weight', 'medical_conditions','food_preferences', 'allergies']
        def create(self, validated_data):
          food_prefs_data =  validated_data.pop('food_preferences', [])
          allergy_data = validated_data.pop('allergies', [])
          user_profile = UserProfile.objects.create(**validated_data)
          for fp in food_prefs_data:
            FoodPreference.objects.create(user=user_profile, **fp_data)
          for al in allergy_data:
            Allergy.objects.create(user=user_profile, **al_data)
            
            return user_profile
        def update(self, instance, validated_data):
          return super().update(instance, validated_data)
        extra_kwargs = {
            'user_id': {'read_only': True}  # 클라이언트에서 직접 설정하지 못하도록 read_only 설정
        }




