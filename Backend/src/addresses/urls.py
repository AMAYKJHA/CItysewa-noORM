from django.urls import path

from .views import (
    DistrictAPIView,
    LocationAPIView,
    AddressAPIView
)


urlpatterns = [
    path("/district", DistrictAPIView.as_view(), name="district"),
    path("/district/<int:id>", DistrictAPIView.as_view(), name="retrieve-district"),  
    
    path("/location", LocationAPIView.as_view(), name="location"),
    path("/location/<int:id>", LocationAPIView.as_view(), name="retrieve-location"),
    
    path("", AddressAPIView.as_view(), name="address"),
    path("/<int:id>", AddressAPIView.as_view(), name="retrieve-address")
]