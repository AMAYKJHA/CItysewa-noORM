from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK,
    HTTP_400_BAD_REQUEST
)
from drf_spectacular.utils import extend_schema

from src.accounts.tables import (
    Provider, Customer, User
)

from src.services.tables import (
    Service
)

from .tables import (
    Booking
)

from .serializers import (
    BookingSerializer,
    BookingCreateSerializer
)

from .messages import (
    BOOKING_NOT_FOUND
)

class BookingAPIView(APIView):
    def get(self, request, id=None):
        if id:
            booking = Booking().get(id=id)
            if booking:
                serializer = BookingSerializer(booking.__dict__)
                return Response(data=serializer.data, status=HTTP_200_OK)
            return Response({"detail": BOOKING_NOT_FOUND}, status=HTTP_400_BAD_REQUEST)
        
        # List bookings
        order_by = request.query_params.get("order_by")
        order_dir = request.query_params.get("order_dir")
        direction = 0
        if order_dir:
            direction = 1 if order_dir.lower() == 'desc' else 0        
        
        provider_id = request.query_params.get("provider_id")
        try:
            provider_id = int(provider_id) if provider_id is not None else None
        except ValueError:
            provider_id = None
        service_ids = None
        if provider_id:
            service_and_provider_id = Service().join(
                right_table=Provider(),
                join_on=("provider_id","id"),
                left_attrs=("id",),
                right_conditions={"id": provider_id}
            )
            service_ids = tuple([item.get("services_id") for item in service_and_provider_id])
            
        bookings = Booking().all(order_by=order_by, order_dir=direction, service_id=service_ids)        
        serializer = BookingSerializer(bookings, many=True)
        return Response(serializer.data, status=HTTP_200_OK)
        
        
    def post(self, request):
        serializer = BookingCreateSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)