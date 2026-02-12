from django.urls import path

from .views import (
    BookingAPIView,
    booking_stats,
)

urlpatterns = [
    path("", BookingAPIView.as_view(), name="booking"),
    path("/<int:id>", BookingAPIView.as_view(), name="retrieve-booking"),
    path("/stats", booking_stats, name="booking-stats")
]