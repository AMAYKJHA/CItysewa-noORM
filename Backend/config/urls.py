"""
URL configuration for config project.
"""

from django.urls import path, include
from django.core.cache import cache
from rest_framework.renderers import JSONRenderer
from django.http import JsonResponse
from django.shortcuts import redirect
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularSwaggerView
)  

def homepage(request):
    return redirect("swagger-ui")

def trigger_error(request):
    """
    Method to test if sentry is working.
    """
    division_by_zero = 1/0

def keep_alive(request):
    try:
        cache.get_or_set("cache_active", "ok")
        cache_msg = "Cache is working fine."        
    except Exception:
        cache_msg = "Cache is not working."
    return JsonResponse({
        "message": "Server is running.",
        "cache": cache_msg
        })
    
urlpatterns = [
    path("", homepage, name="home-page"),
    path("api/v1/", include('src.api.urls')),
    path("api/v1/schema", SpectacularAPIView.as_view(renderer_classes=[JSONRenderer]), name="schema"),
    path("api/v1/docs", SpectacularSwaggerView.as_view(url_name='schema'), name="swagger-ui"),
    path("keepalive", keep_alive, name="keep-alive"),
    path("sentry-debug", trigger_error, name="sentry-debug")
]
