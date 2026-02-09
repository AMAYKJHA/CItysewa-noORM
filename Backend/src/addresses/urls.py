from django.urls import path

from .views import DistrictAPIView

urlpatterns = [
    path("/district", DistrictAPIView.as_view(), name="district"),
    path("/district/<int:id>", DistrictAPIView.as_view(), name="retrieve-district"),    
]