from django.urls import path, include


urlpatterns = [
    path('accounts/', include('src.accounts.urls')),
    path('services', include('src.services.urls')),
    path('addresses', include('src.addresses.urls')),
]