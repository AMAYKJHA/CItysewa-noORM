from rest_framework import serializers

from src.accounts.tables import Customer, Provider
from src.services.tables import Service
from src.addresses.tables import Address

from .tables import Booking

from src.accounts.messages import (
    CUSTOMER_NOT_FOUND
)
from src.services.messages import (
    SERVICE_NOT_FOUND
)

from src.addresses.messages import (
    ADDRESS_NOT_FOUND
)

from .messages import (
    PROVIDER_NOT_AVAILABLE,
    SAME_PROVIDER_AND_CUSTOMER
)

class BookingCreateSerializer(serializers.Serializer):
    service_id = serializers.IntegerField()
    customer_id = serializers.IntegerField()
    address_id = serializers.IntegerField()
    booking_date = serializers.DateField()
    booking_time = serializers.TimeField()
    status = serializers.CharField(required=False, default='Pending')
    
    def is_provider_available(self, customer, service_id, booking_date, booking_time):
        service = Service().get(id=service_id)
        if not service:
            raise serializers.ValidationError({
                "message": SERVICE_NOT_FOUND
            })
            
        provider = Provider().get(id=service.provider_id)
        if(customer.user_id == provider.user_id):
            raise serializers.ValidationError({
                "message": SAME_PROVIDER_AND_CUSTOMER
            })
            
        provider_services = Service().all(provider_id=service.provider_id)
        provider_services_id = [service.get("id") for service in provider_services]
        provider_bookings = Booking().all(service_id=tuple(provider_services_id)) 
        
        provider_bookings_date = [booking.get("booking_date") for booking in provider_bookings]
        provider_bookings_time = [booking.get("booking_time") for booking in provider_bookings]
        
        return not (booking_date in provider_bookings_date and booking_time in provider_bookings_time)            
        
    def validate(self, attrs):   
        customer = Customer().get(id=attrs.get("customer_id"))
        if not customer:
            raise serializers.ValidationError({
                "message": CUSTOMER_NOT_FOUND
            })
            
        if not Address().get(id=attrs.get("address_id")):
            raise serializers.ValidationError({
                "message": ADDRESS_NOT_FOUND
            })
            
        if not self.is_provider_available(
            customer=customer,
            service_id=attrs.get("service_id"),
            booking_date=attrs.get("booking_date"),
            booking_time=attrs.get("booking_time")
            ):
            raise serializers.ValidationError({
                "message": PROVIDER_NOT_AVAILABLE
            })
            
        return attrs
    
    def create(self, validated_data):
        booking = Booking().create(**validated_data)
        return booking.__dict__

    
class BookingSerializer(serializers.Serializer):
    id = serializers.IntegerField()    
    service_id = serializers.IntegerField()
    customer_id = serializers.IntegerField()
    address_id = serializers.IntegerField()
    booking_date = serializers.DateField()
    booking_time = serializers.TimeField()
    status = serializers.CharField()