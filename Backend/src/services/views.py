from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK,
    HTTP_400_BAD_REQUEST
)

from .serializers import (
    ServiceCreateSeriazlier
)

class ServiceCreateAPIView(APIView):
    def post(self, request):
        serializer = ServiceCreateSeriazlier(data=request.data)
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(data=serializer.data, status=HTTP_200_OK)
        return Response(serializer.errors, HTTP_400_BAD_REQUEST)