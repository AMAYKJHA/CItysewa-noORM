from rest_framework import serializers

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
    DISTRICT_NOT_FOUND,
    ADDRESS_ALREADY_EXISTS
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
    name = serializers.CharField()    
    
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
    


class AddressCreateSerializer(serializers.Serializer):
    user_id = serializers.IntegerField()
    location_id = serializers.IntegerField()
    landmarks = serializers.CharField(max_length=150)
    
    def validate(self, attrs):
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