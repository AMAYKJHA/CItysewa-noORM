from rest_framework import serializers
from rest_framework.exceptions import NotFound

from src.accounts.tables import (
    User
)
from src.accounts.messages import (
    USER_NOT_FOUND
)

from .tables import (
    District,
    Location,
    Address
)

from .constants import (
    MAX_WARD_VALUE,
    MIN_WARD_VALUE
)

from .messages import (
    ADDRESS_NOT_FOUND,
    ADDRESS_ALREADY_EXISTS,
    DISTRICT_NOT_FOUND,
    LOCATION_NOT_FOUND
)


class DistrictCreateSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=50)
    
    def validate(self, attrs):
        attrs["name"] = attrs.get("name").capitalize()
        district = District().get(name=attrs.get("name"))
        if district:
            attrs["district"] = district
        return attrs
    
    def create(self, validated_data):
        district = validated_data.pop("district", None)
        if not district:
            district = District().create(name=validated_data.get("name"))
            
        return district.__dict__
    
class DistrictSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    name = serializers.CharField(required=False, max_length=50)    
    
    def to_representation(self, instance):
        data = super().to_representation(instance)
        if not data.get("name"):
            data["name"] = District().get(id=instance.get("id")).name
        return data
    
    
class LocationCreateSerializer(serializers.Serializer):
    area = serializers.CharField(max_length=100)
    ward = serializers.IntegerField(min_value=MIN_WARD_VALUE, max_value=MAX_WARD_VALUE)
    city = serializers.CharField(max_length=50)
    district_id = serializers.IntegerField()
    
    def validate(self, attrs):
        district_id = attrs.get("district_id")
        district = District().get(id=district_id)
        if not district:
            raise serializers.ValidationError({
                "message": DISTRICT_NOT_FOUND
            })
            
        attrs["area"] = attrs.get("area").capitalize()
        location = Location().get(area=attrs.get("area"))
        if location:
            if location.ward == attrs.get("ward"):
                attrs["location"] = location
        
        return attrs
    
    def create(self, validated_data):
        location = validated_data.pop("location", None)
        if not location:
            location = Location().create(**validated_data)        
        return location.__dict__
   
    
class LocationSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    area = serializers.CharField(max_length=100)
    ward = serializers.IntegerField(min_value=MIN_WARD_VALUE, max_value=MAX_WARD_VALUE)
    city = serializers.CharField(max_length=50)
    district_id = serializers.IntegerField(write_only=True)
    district = serializers.SerializerMethodField()
    
    def get_district(self, obj):
        district_id = obj.get("district_id")
        district_serializer = DistrictSerializer({"id":district_id})
        return district_serializer.data


class AddressCreateSerializer(serializers.Serializer):
    user_id = serializers.IntegerField()
    location_id = serializers.IntegerField()
    landmarks = serializers.CharField(max_length=150)
    
    def validate(self, attrs):
        user = User().get(id=attrs.get("user_id"))
        if not user:
            raise serializers.ValidationError({
                "message": USER_NOT_FOUND
            })
            
        address = Address().get(user_id=attrs.get("user_id"), location_id=attrs.get("location_id"))
        if address:
            raise serializers.ValidationError({
                "message": ADDRESS_ALREADY_EXISTS
            })
            
        attrs["landmarks"] = attrs.get("landmarks").strip()
        return attrs
    
    def create(self, validated_data):
        address = Address().create(**validated_data)
        return address.__dict__

   
class AddressSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    user_id = serializers.IntegerField()
    location_id = serializers.IntegerField(write_only=True)
    landmarks = serializers.CharField(max_length=150)
    location = serializers.SerializerMethodField()
    
    def get_location(self, obj):
        location_id = obj.get("location_id")
        location = Location().get(id=location_id)
        if not location:
            raise NotFound(detail=LOCATION_NOT_FOUND)
        location_serializer = LocationSerializer(location.__dict__)
        return location_serializer.data 
    
    