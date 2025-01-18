from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, User

class UserManager(BaseUserManager):
    def create_user(self, user_id, username, password=None):
        if not user_id:
            raise ValueError("Users must have a user ID")
        
        user = self.model(user_id=user_id, username=username)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, user_id, username, password=None):
        user = self.create_user(user_id=user_id, username=username, password=password)
        user.is_admin = True
        user.save(using=self._db)
        return user

class User(AbstractBaseUser):
    user_id = models.CharField(max_length=50, unique=True)  # For login ID
    username = models.CharField(max_length=50)               # For display name
    password = models.CharField(max_length=100)
    
    objects = UserManager()

    USERNAME_FIELD = 'user_id'  # Specify user_id as the field for login
    REQUIRED_FIELDS = ['username']  # Require username when creating a user

    def __str__(self):
        return self.username
      
#설문조사 저장 내용
class UserProfile(models.Model):
    user_id = models.OneToOneField('users.User', on_delete=models.CASCADE)  # Django의 기본 User 모델과 연결
    gender = models.CharField(max_length=10, choices=[('남성', '남성'), ('여성', '여성')])
    birth_date = models.DateField()
    height = models.FloatField()  # 신장
    weight = models.FloatField()  # 몸무게
    medical_conditions = models.TextField(blank=True)  # 진단받은 질환 (쉼표로 구분)

    def __str__(self):
        return self.user_id.username


class FoodPreference(models.Model):
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name='food_preferences')
    food_name = models.CharField(max_length=100)  # 음식 이름
    is_liked = models.BooleanField()  # 선호 여부

    def __str__(self):
        return f"{self.user.user_id.username} - {self.food_name} - {'Liked' if self.is_liked else 'Disliked'}"


class Allergy(models.Model):
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name='allergies')
    allergy_name = models.CharField(max_length=100)  # 알러지 항목 이름

    def __str__(self):
        return f"{self.user.user_id.username} - {self.allergy_name}"