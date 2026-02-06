from rest_framework import serializers

from src.accounts.tables import (
    Provider
)
from src.accounts.messages import (
    PROVIDER_NOT_FOUND
)
from src.core.validators import (
    validate_file_size
)

from .tables import (
    Service,
)

from .constants import (
    MIN_SERVICE_PRICE
)


# Service serializers
# ------------------------------------------------------------------------------------------

class ServiceCreateSeriazlier(serializers.Serializer):
    provider_id = serializers.IntegerField()
    title = serializers.CharField(max_length=100)
    service_type = serializers.CharField()
    description = serializers.CharField()
    price = serializers.IntegerField(min_value=MIN_SERVICE_PRICE)
    price_unit = serializers.CharField()
    thumbnail = serializers.ImageField(required=False, validators=[validate_file_size])
    
    def validate(self, attrs):
        provider_id = attrs.get("provider_id")
        provider = Provider().get(id=provider_id)
        if not provider:
            raise serializers.ValidationError({
                "message": PROVIDER_NOT_FOUND
            })

        attrs["title"] = attrs.get("title").strip().capitalize()
        attrs["service_type"] = attrs.get("service_type").strip().capitalize()
        attrs["description"] = attrs.get("description").strip().capitalize()
        
        return attrs
        
    def create(self, validated_data):
        thumbnail = validated_data.pop("thumbnail", None)
        
        service = Service().create(**validated_data)
        if thumbnail:
            file_name = service.upload_thumbnail(thumbnail)     
            service.update(id=service.id, thumbnail=file_name)      
            service.thumbnail = service.get_thumbnail_url(file_name)
        return service.__dict__
 
 
class ServiceListSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    title = serializers.CharField(max_length=100)
    service_type = serializers.CharField()
    price = serializers.IntegerField(min_value=MIN_SERVICE_PRICE)
    price_unit = serializers.CharField()    
    thumbnail = serializers.ImageField(required=False, validators=[validate_file_size])
    
    def to_representation(self, instance):
        data =  super().to_representation(instance)
        if instance.get("thumbnail"):
            data["thumbnail"] = Service().get_thumbnail_url(instance.get("id"), instance("thumbnail"))
        return data 
   
class ServiceRetrieveSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    provider_id = serializers.IntegerField()
    title = serializers.CharField(max_length=100)
    service_type = serializers.CharField()
    description = serializers.CharField()
    price = serializers.IntegerField(min_value=MIN_SERVICE_PRICE)
    price_unit = serializers.CharField()
    thumbnail = serializers.ImageField(required=False, validators=[validate_file_size])
    
    def to_representation(self, instance):
        data =  super().to_representation(instance)
        if instance.get("thumbnail"):
            data["thumbnail"] = Service().get_thumbnail_url(instance.get("id"), instance("thumbnail"))
        return data