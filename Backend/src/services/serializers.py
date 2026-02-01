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
    provider_id = serializers.IntegerField(required=True)
    title = serializers.CharField(required=True, max_length=100),
    service_type = serializers.CharField(required=True)
    description = serializers.CharField(required=True)
    thumbnail = serializers.ImageField(required=False, validators=[validate_file_size])
    price = serializers.IntegerField(required=True, min_value=MIN_SERVICE_PRICE)
    price_unit = serializers.CharField(required=True)
    
    def validate(self, attrs):
        provider_id = attrs.get("provider_id")
        provider = Provider().get(id=provider_id)
        if not provider:
            raise serializers.ValidationError({
                "message": PROVIDER_NOT_FOUND
            })

        return attrs
        
    def create(self, validated_data):
        thumbnail = validated_data.pop("thumbnail", None)
        
        service = Service().create(**validated_data)
        if thumbnail:
            file_name = service.upload_thumbnail(thumbnail)     
            service.update(thumbnail=file_name)      
            service.thumbnail = service.get_thumbnail_url(file_name)
        return service.__dict__