from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK,
    HTTP_400_BAD_REQUEST
)

from .tables import (
    District,
    Location,
    Address
)

from .serializers import (
    DistrictSerializer,
    DistrictCreateSerializer,
    LocationCreateSerializer,
    AddressCreateSerializer
)

from .messages import (
    DISTRICT_NOT_FOUND
)


class DistrictAPIView(APIView):
    def get(self, request, id=None):
        if id:
            # Fetch single district
            district = District().get(id=id)
            if district:
                serializer = DistrictSerializer(district.__dict__)
                return Response(serializer.data, status=HTTP_200_OK)
            return Response(data={"detail": DISTRICT_NOT_FOUND}, status=HTTP_400_BAD_REQUEST)
        
        # Fetch list of districts 
        order_by = request.query_params.get("order_by")
        order_by = order_by if order_by else "name"
        try:
            district_list = District().all(order_by=order_by)
        except ValueError:
            return Response({"detail": "Invalid order_by field."}, status=HTTP_200_OK)
        
        serializer = DistrictSerializer(district_list, many=True)
        return Response(serializer.data, status=HTTP_200_OK)
               
    def post(self, request):
        serializer = DistrictCreateSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            data = serializer.save()
            return Response(data=data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
    
    def delete(self, request, id):
        rows_deleted = District().delete(id=id)
        if not rows_deleted == 0:
            return Response({"detail": "District deleted successfully"}, status=HTTP_200_OK)
        else:
            return Response({"detail": "District not found for this id."}, status=HTTP_400_BAD_REQUEST)  
  
        
class LocationAPIView(APIView):
    def get(self, request, id=None):
        ...
        
    def post(self, request):
        ...