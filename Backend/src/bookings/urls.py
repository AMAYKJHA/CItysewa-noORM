from django.urls import path

from .views import (
    BookingAPIView
)

urlpatterns = [
    path("", BookingAPIView.as_view(), name="booking"),
    path("/<int:id>", BookingAPIView.as_view(), name="retrieve-booking")
]