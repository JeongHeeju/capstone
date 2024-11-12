from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

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

