from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK,
    HTTP_400_BAD_REQUEST
)

from src.accounts.tables import (
    User,
    Customer,
    Provider
)

from .tables import (
    District,
    Location,
    Address
)

from .serializers import (
    DistrictSerializer,
    DistrictCreateSerializer,
    LocationSerializer,
    LocationCreateSerializer,
    AddressSerializer,
    AddressCreateSerializer    
)

from .messages import (
    DISTRICT_NOT_FOUND,
    ADDRESS_NOT_FOUND,
    LOCATION_NOT_FOUND
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
        if id:
            location = Location().get(id=id)
            if location:
                serializer = LocationSerializer(location.__dict__)
                return Response(serializer.data, status=HTTP_200_OK)
            else:
                return Response({"detail": LOCATION_NOT_FOUND}, status=HTTP_400_BAD_REQUEST)
        
        order_by = request.query_params.get("order_by")
        order_by = order_by if order_by else "city"
        try:
            locations = Location().all(order_by=order_by)
        except ValueError:
            return Response({"detail": "Invalid order_by field."}, status=HTTP_200_OK)
        
        serializer = LocationSerializer(locations, many=True)
        return Response(serializer.data, status=HTTP_200_OK)
    
    def post(self, request):
        serializer = LocationCreateSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            data = serializer.save()
            return Response(data=data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
    

class AddressAPIView(APIView):
    def get(self, request, id=None):
        if id:
            address = Address().get(id=id)
            if address:
                serializer = AddressSerializer(address.__dict__)
                return Response(serializer.data, status=HTTP_200_OK)
            else:
                return Response({"detail": ADDRESS_NOT_FOUND}, status=HTTP_400_BAD_REQUEST)
          
        customer_id = request.query_params.get("customer_id")
        user_id = None
        if customer_id:
            try:
                customer_id = int(customer_id)
                customer = Customer().get(id=customer_id)
                user_id = customer.user_id if customer else None
            except ValueError:
                return Response({"detail": "Customer id must be integer."}, status=HTTP_400_BAD_REQUEST)
            
        addresses = Address().all(user_id=user_id)
        serializer = AddressSerializer(addresses, many=True)
        return Response(serializer.data, status=HTTP_200_OK)
        
    def post(self, request):
        data = request.data
        location = request.data.pop("location", {})
        if not location:
            return Response({"location": "Location field is reqired with (area, ward, city, district_id)."}, status=HTTP_400_BAD_REQUEST)
        
        location_serializer = LocationCreateSerializer(data=location)
        if location_serializer.is_valid(raise_exception=True):
            location_data = location_serializer.save()
            data["location_id"] = location_data.get("id")
        else:
            return Response(location_serializer.errors, status=HTTP_400_BAD_REQUEST)
    
                
        serializer = AddressCreateSerializer(data=data)
        if serializer.is_valid(raise_exception=True):
            data = serializer.save()
            return Response(data=data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)