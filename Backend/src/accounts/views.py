from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.status import (
    HTTP_200_OK, 
    HTTP_400_BAD_REQUEST,
    HTTP_404_NOT_FOUND,
    HTTP_500_INTERNAL_SERVER_ERROR,
    HTTP_429_TOO_MANY_REQUESTS
)
from drf_spectacular.utils import extend_schema
from django.core.cache import cache
from django.conf import settings

from src.accounts.utils.generators import generate_otp
from src.accounts.utils.verification import send_user_OTP_email

from .tables import (
    Token,
    User,
    Customer,
    Provider,
    Document
)

from .serializers import (
    UserRegisterSeriaizer,
    AdminLoginSerializer,
    CustomerRegisterSerializer,
    CustomerLoginSerializer,
    CustomerSerializer,
    ProviderRegisterSerializer,
    ProviderLoginSerializer,
    ProviderSerializer,
    ProviderSubmitVerificationSerializer,
    VerificationListSerializer,
    VerificationRetrieveSerializer,
    VerificationPatchSerializer,
)

from .constants import (
    VERIFICATION_STATUS
)

from .messages import (
    STATUS_NOT_MATCHED,
    CUSTOMER_NOT_FOUND,
    PROVIDER_NOT_FOUND
)

# Account verification views
# -----------------------------------------------------------------------------------------
class SendOTPAPIView(APIView):
    def post(self, request):
        email = request.data.get("email")
        otp_expiry_time = settings.OTP_EXPIRY_TIME
        otp_expiry_minutes = otp_expiry_time // 60
        origin_url = settings.ORIGIN_URL

        if not email:
            return Response(
                {"detail": "Email address is required for verification."},
                status=HTTP_400_BAD_REQUEST
            )

        if cache.get(f"otp:{email}"):
            return Response(
                {
                    "detail": f"An OTP has already been sent. Please wait {otp_expiry_minutes} minutes before requesting a new one."
                },
                status=HTTP_429_TOO_MANY_REQUESTS
            )

        otp = generate_otp()
        cache.set(f"otp:{email}", otp, otp_expiry_time)

        if send_user_OTP_email(
            recipient_email=email,
            otp=otp,
            otp_expiry_minutes=otp_expiry_minutes,
            origin_url=origin_url
        ):
            return Response(
                {
                    "message": f"A verification code has been sent to your email. It will expire in {otp_expiry_minutes} minutes."
                },
                status=HTTP_200_OK
            )
        else:
            cache.delete(f"otp:{email}")
        
        return Response(
            {"detail": "We were unable to send the verification code. Please try again later."},
            status=HTTP_500_INTERNAL_SERVER_ERROR
        )
        
class VerifyOTPAPIView(APIView):
    def post(self, request):
        email = request.data.get("email")
        otp = request.data.get("otp")
        
        if not email or not otp:
            return Response(
                {"detail": "Email and OTP are required."},
                status=HTTP_400_BAD_REQUEST
            )

        cached_otp = cache.get(f"otp:{email}")

        if cached_otp is None:
            return Response(
                {"detail": "OTP expired or not found."},
                status=HTTP_400_BAD_REQUEST
            )

        if otp != str(cached_otp):
            return Response(
                {"detail": "Invalid OTP."},
                status=HTTP_400_BAD_REQUEST
            )
        
        cache.delete(f"otp:{email}")

        return Response(
            {"message": "OTP verified successfully."},
            status=HTTP_200_OK
        )
        

# Admin views
# -----------------------------------------------------------------------------------------

class AdminRegisterAPIView(APIView):
    def post(self, request):
        serializer = UserRegisterSeriaizer(data=request.data)
        if serializer.is_valid():
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


class AdminLoginAPIView(APIView):
    def post(self, request):
        serializer = AdminLoginSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)        
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


# Customer views
# ----------------------------------------------------------------------------------------- 

class CustomerRegisterAPIView(APIView):    
    def post(self, request):
        serializer = CustomerRegisterSerializer(data=request.data)        
        if serializer.is_valid():
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)        
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
    
class CustomerLoginAPIView(APIView):
    def post(self, request):
        serializer = CustomerLoginSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)        
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
   

@extend_schema(
    summary="List all customers",
    description="Returns a lits of all customers",
    operation_id="customer_list"
)   
class CustomerListAPIView(APIView):
    def get(self, request):
        order_by = request.query_params.get("order_by")
        order_dir = request.query_params.get("order_dir")
        direction = 0
        if order_dir:
            direction = 1 if order_dir.lower() == 'desc' else 0
            
        customers_data = Customer().join(
            right_table=User(),
            join_on=("user_id","id"),
            left_attrs=("id", "first_name", "last_name", "gender"),
            right_attrs = ("email",)
        )
        transformed_data = []
        for item in customers_data:
            temp_dict = {}
            for key, val in item.items():
                new_key = key.removeprefix(f"{Customer.table_name}_")
                new_key = new_key.removeprefix(f"{User.table_name}_")
                temp_dict[new_key] = val
            
            transformed_data.append(temp_dict)

        serializer = CustomerSerializer(transformed_data, many=True)        
        return Response(serializer.data, status=HTTP_200_OK) 

@extend_schema(
    summary="Retrive a customer details",
    description="Returns details of customer using their id.",
    operation_id='customer_detail'
)   
class CustomerRetrieveAPIView(APIView):
    def get(self, request, id):
        customer = Customer().get(id=id)
        if customer:
            serializer = CustomerSerializer(customer.__dict__)        
            return Response(serializer.data, status=HTTP_200_OK)
                     
        return Response({"detail": CUSTOMER_NOT_FOUND}, status=HTTP_404_NOT_FOUND)
    
        
# Provider views
# -----------------------------------------------------------------------------------------

class ProviderRegisterAPIView(APIView):    
    def post(self, request):
        serializer = ProviderRegisterSerializer(data=request.data)        
        if serializer.is_valid():
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)        
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
    
    
class ProviderLoginAPIView(APIView):
    def post(self, request):
        serializer = ProviderLoginSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.save()
            return Response(data, status=HTTP_200_OK)        
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
   

@extend_schema(
    summary="List all providers",
    description="Returns a lits of all providers",
    operation_id="provider_list"
)   
class ProviderListAPIView(APIView):
    def get(self, request):        
        order_by = request.query_params.get("order_by")
        order_dir = request.query_params.get("order_dir")
        direction = 0
        if order_dir:
            direction = 1 if order_dir.lower() == 'desc' else 0

        providers_data = Provider().join(
            right_table=User(),
            join_on=("user_id","id"),
            left_attrs=("id", "first_name", "last_name", "gender", "photo", "verified"),
            right_attrs = ("email",)
        )
        transformed_data = []
        for item in providers_data:
            temp_dict = {}
            for key, val in item.items():
                new_key = key.removeprefix(f"{Provider.table_name}_")
                new_key = new_key.removeprefix(f"{User.table_name}_")
                temp_dict[new_key] = val
            
            transformed_data.append(temp_dict)
        serializer = ProviderSerializer(transformed_data, many=True)        
        return Response(serializer.data, status=HTTP_200_OK) 


@extend_schema(
    summary="Retrive a provider details",
    description="Returns details of provider using their id.",
    operation_id='provider_detail'
)   
class ProviderRetrieveAPIView(APIView):
    def get(self, request, id):
        provider = Provider().get(id=id)
        if provider:
            serializer = ProviderSerializer(provider.__dict__)        
            return Response(serializer.data, status=HTTP_200_OK)
                     
        return Response({"detail": PROVIDER_NOT_FOUND}, status=HTTP_404_NOT_FOUND)
    
    
class ProviderSubmitVerificationAPIView(APIView):
    def post(self, request):
        serializer = ProviderSubmitVerificationSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.save()
            return Response(data=data, status=HTTP_200_OK)
            
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)
        
        
class VerificationListAPIView(APIView):
    def get(self, request):
        verification_status = request.query_params.get("status", 'Pending')
        verification_data = Provider().join(
            right_table=Document(),
            join_on=("id","provider_id"),
            left_attrs=("id", "first_name", "last_name", "gender"),
            right_attrs = ("document_number", "status",),
            left_conditions={},
            right_conditions={"status": verification_status}
            )
        
        # Removing the prefixes 'provider_' and 'document_' from keys eg: provider_column_name or
        transformed_data = []
        for item in verification_data:
            temp_dict = {}
            for key, val in item.items():
                new_key = key.removeprefix(f"{Provider.table_name}_")
                new_key = new_key.removeprefix(f"{Document.table_name}_")
                temp_dict[new_key] = val
            
            transformed_data.append(temp_dict)

        serializer = VerificationListSerializer(transformed_data, many=True)
        
        return Response(serializer.data, status=HTTP_200_OK)
 
    
class VerificationRetrieveAPIView(APIView):
    def get(self, request, id):
        verification_status = request.query_params.get("status", "Pending")
        if verification_status not in VERIFICATION_STATUS:
            return Response(
                {"message": [STATUS_NOT_MATCHED.format(VERIFICATION_STATUS)]}
            )
        verification_data = Provider().join(
            right_table=Document(),
            join_on=("id","provider_id"),
            left_attrs=("id", "first_name", "last_name", "gender", "photo", "verified"),
            right_attrs = ("document_type", "document_number", "file_name", "status"),
            left_conditions={"id":id},
            right_conditions={"status": verification_status}
            )
        
        # Removing the prefixes 'provider_' and 'document_' from keys eg: provider_column_name or        
        if len(verification_data)>0:
            transformed_data = {}
            for key, val in verification_data[0].items():
                    new_key = key.removeprefix(f"{Provider.table_name}_")
                    new_key = new_key.removeprefix(f"{Document.table_name}_")
                    transformed_data[new_key] = val
                    
            user_data = User().join(
                right_table=Provider(),
                join_on=("id","user_id"),
                left_attrs=("email", "phone_number"),
                left_conditions={},
                right_conditions={"id": id}
            )
            transformed_data["email"] = user_data[0].get("users_email")
            transformed_data["phone_number"] = user_data[0].get("users_phone_number")
           
            serializer = VerificationRetrieveSerializer(transformed_data)
            
            return Response(serializer.data, status=HTTP_200_OK)
        return Response({"message": ["No pending verification request found for this provider."]}, status=HTTP_400_BAD_REQUEST)
    
    def patch(self, request, id):
        provider_id = id
        serializer = VerificationPatchSerializer(data=request.data, instance={"id": provider_id})
        if serializer.is_valid():
            data = serializer.save()
            return Response(data=data, status=HTTP_200_OK)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)