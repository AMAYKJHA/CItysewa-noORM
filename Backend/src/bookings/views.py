from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK,
    HTTP_400_BAD_REQUEST
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
        
        bookings = Booking().all()
        serializer = BookingSerializer(bookings, many=True)
        return Response(data=serializer.data, status=HTTP_200_OK)
        
    def post(self, request):
        serializer = BookingCreateSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)