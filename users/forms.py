from django import forms
from django.contrib.auth import authenticate
from django.contrib.auth.forms import UserCreationForm
from .models import User

class UserRegisterForm(UserCreationForm):
    class Meta:
        model = User
        fields = ['username', 'user_id', 'password1', 'password2']

class UserLoginForm(forms.Form):
    user_id = forms.CharField(label='User ID')
    password = forms.CharField(widget=forms.PasswordInput)

    def clean(self):
        user_id = self.cleaned_data.get('user_id')
        password = self.cleaned_data.get('password')
        user = authenticate(user_id=user_id, password=password)
        if not user:
            raise forms.ValidationError("Invalid login credentials")
        return self.cleaned_data