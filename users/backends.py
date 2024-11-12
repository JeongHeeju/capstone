from django.contrib.auth.backends import BaseBackend
from .models import User

class UserIDBackend(BaseBackend):
    def authenticate(self, request, user_id=None, password=None, **kwargs):
        try:
            user = User.objects.get(user_id=user_id)
        except User.DoesNotExist:
            return None
        if user.check_password(password):
            return user
        return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None