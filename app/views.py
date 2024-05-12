from django.shortcuts import render
from django.http import HttpResponse

def frontpage(request):

    return HttpResponse('Welcome friend!')