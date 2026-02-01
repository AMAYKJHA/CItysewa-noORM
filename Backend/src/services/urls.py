from django.urls import path

from .views import (
    ServiceCreateAPIView
)

urlpatterns = [
    path('', ServiceCreateAPIView.as_view(), name="service-create"),
]