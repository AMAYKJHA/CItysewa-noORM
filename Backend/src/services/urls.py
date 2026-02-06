from django.urls import path

from .views import (
    ServiceCreateAPIView, 
    ServiceListAPIView,
    ServiceRetrieveAPIView
)

urlpatterns = [
    path('/register', ServiceCreateAPIView.as_view(), name="service-create"),
    path('', ServiceListAPIView.as_view(), name="service-list"),
    path('/<int:id>', ServiceRetrieveAPIView.as_view(), name="service-retrieve")
]