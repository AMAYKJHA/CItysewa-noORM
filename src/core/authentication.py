from src.accounts.tables import Users


class Backend:
    """
    Custom backend for authentication.
    settings.AUTHENTICATION_BACKENDS should point to this Backend.
    """

    def authenticate(self, request, email=None, password=None, **kwargs):
        if email is None:
            email = kwargs.get(email)
        
        if email is None or password is None:
            return
        
        try:
            user = Users().get(email=email)
        except Exception as e:
            ...








