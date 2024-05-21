from django.contrib import admin
from . import models

class HelloAdmin(admin.ModelAdmin):
    list_display = ['title', 'description', 'coolness']


admin.site.register(models.HelloWorld, HelloAdmin)