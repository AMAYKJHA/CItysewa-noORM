from datetime import datetime

from django.conf import settings
from rest_framework import serializers

from src.utils.send_mail import _send_email


def send_user_OTP_email(
    recipient_email: str,
    otp: int,
    otp_expiry_minutes: int,
    origin_url=None
):


    try:
        subject = "Email Verification"
        body = "Account Information"
        email_template_name = "accounts/account-verification"

        logo_url = settings.APP_LOGO

        email_context = {
            "origin_url": origin_url,
            "logo": logo_url,
            "otp": otp,
            "otp_expiry_minutes": otp_expiry_minutes,
            "year": datetime.now().year
        }

        _send_email(
            subject,
            body,
            email_template_name,
            email_context,
            recipient_email,
        )
        return True

    except Exception as err:
        print(f"Error: {err}")
        raise serializers.ValidationError({"error": "Something went wrong. Please try again."})
