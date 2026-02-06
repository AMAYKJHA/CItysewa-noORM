from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK,
    HTTP_400_BAD_REQUEST
)

from drf_spectacular.utils import extend_schema

from .tables import (
    Service
)

from .serializers import (
    ServiceCreateSeriazlier,
    ServiceListSerializer,
    ServiceRetrieveSerializer
)

from .messages import (
    SERVICE_NOT_FOUND
)

class ServiceCreateAPIView(APIView):
    def post(self, request):
        serializer = ServiceCreateSeriazlier(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(data=serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, HTTP_400_BAD_REQUEST)
  
@extend_schema(
    summary="List all services",
    description="Returns a lits of all services",
    operation_id="service_list"
)   
class ServiceListAPIView(APIView):
    def get(self, request):
        order_by = request.query_params.get("order_by")
        order_dir = request.query_params.get("order_dir")
        direction = 0
        if order_dir:
            direction = 1 if order_dir.lower() == 'desc' else 0
        services = Service().all(order_by=order_by, order_dir=direction)
        
        serializer = ServiceListSerializer(services, many=True)
        return Response(serializer.data, status=HTTP_200_OK)

@extend_schema(
    summary="Retrieve a service",
    description="Returns a services by its id",
    operation_id="service_retrieve"
)       
class ServiceRetrieveAPIView(APIView):
    def get(self, request, id):        
        service = Service().get(id=id)
        if service:
            serializer = ServiceListSerializer(service)
            return Response(serializer.data, status=HTTP_200_OK)
        return Response({"detail": SERVICE_NOT_FOUND}, status=HTTP_400_BAD_REQUEST)