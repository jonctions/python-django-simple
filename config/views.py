from django.http import HttpResponse
from django.conf import settings


def get_author(request):
    return HttpResponse(settings.AUTHOR)

def get_life_quote(request):
    return HttpResponse(settings.LIFE_QUOTE)

def get_purpose(request):
    return HttpResponse(settings.PURPOSE)