from django.contrib import admin
from .models import User, UserProfile, FoodPreference, Allergy

admin.site.register(User)
class FoodPreferenceInline(admin.TabularInline):
    model = FoodPreference
    extra = 0  

class AllergyInline(admin.TabularInline):
    model = Allergy
    extra = 0

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    inlines = [FoodPreferenceInline, AllergyInline]