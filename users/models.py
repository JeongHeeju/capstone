from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, User , PermissionsMixin

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
        user.is_staff = True  
        user.is_superuser = True  
        user.is_active = True  
        user.save(using=self._db)
        return user


class User(AbstractBaseUser, PermissionsMixin):
    user_id = models.CharField(max_length=50, unique=True)  # For login ID
    username = models.CharField(max_length=50)              # For display name
    password = models.CharField(max_length=100)

    is_active = models.BooleanField(default=True)  # 로그인 허용 여부
    is_staff = models.BooleanField(default=False)  # 관리자 페이지 접근 여부

    objects = UserManager()

    USERNAME_FIELD = 'user_id'  # 로그인 시 사용할 필드
    REQUIRED_FIELDS = ['username']  # createsuperuser 시 입력할 필드

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
    food_name = models.CharField(max_length=100)
    is_liked = models.BooleanField()
    tags = models.JSONField(default=list)  # 태그 저장용 필드 추가

    def __str__(self):
        return f"{self.user.user_id.username} - {self.food_name} - {'Liked' if self.is_liked else 'Disliked'}"



class Allergy(models.Model):
    user = models.ForeignKey(UserProfile, on_delete=models.CASCADE, related_name='allergies')
    allergy_name = models.CharField(max_length=100)  # 알러지 항목 이름

    def __str__(self):
        return f"{self.user.user_id.username} - {self.allergy_name}"
      
class UserSurveyRecord(models.Model):
  user = models.OneToOneField(User, on_delete = models.CASCADE)
  completed = models.BooleanField(default=False)
  completed_at = models.DateTimeField(auto_now_add=True)
  
  def  __str__(self):
    return f"{self.user.username} - {'Completed' if self.completed else 'Not Completed'}"
