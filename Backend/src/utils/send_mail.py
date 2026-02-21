import requests

from django.core.mail import EmailMultiAlternatives, get_connection
from django.template.loader import render_to_string
from django.conf import settings

def get_email_config():
    return {
            "EMAIL_HOST": settings.EMAIL_HOST,
            "EMAIL_USE_TLS": settings.EMAIL_USE_TLS,
            "EMAIL_PORT": settings.EMAIL_PORT,
            "EMAIL_HOST_USER": settings.EMAIL_HOST_USER,
            "EMAIL_HOST_PASSWORD": settings.EMAIL_HOST_PASSWORD,
            "DEFAULT_FROM_EMAIL": settings.DEFAULT_FROM_EMAIL
    }

"""
# Using SMTP
def _send_email(
    subject,
    body,
    template_name,
    context,
    recipient_email,
):
    email_config = get_email_config()
    print(email_config)
    try:
        connection = get_connection(
            host=email_config["EMAIL_HOST"],
            port=email_config["EMAIL_PORT"],
            username=email_config["EMAIL_HOST_USER"],
            password=email_config["EMAIL_HOST_PASSWORD"],
            use_tls=email_config["EMAIL_USE_TLS"],
        )
    except (KeyError, Exception):
        print("Email connection failed.")
        raise

    email_template = render_to_string(f"{template_name}.html", context)
    mail = EmailMultiAlternatives(
        subject,
        body,
        from_email=email_config["DEFAULT_FROM_EMAIL"],
        to=[recipient_email],
        connection=connection,
    )

    if email_template:
        mail.attach_alternative(email_template, "text/html")

    try:
        mail.send(fail_silently=False)
    except Exception as e:
        print("EMAIL ERROR:", str(e))
        raise

    return True
"""

# Using api request
def _send_email(
    subject,
    body,
    template_name,
    context,
    recipient_email,
):
    html_content = render_to_string(f"{template_name}.html", context)

    if not html_content:
        html_content = body

    url = settings.BREVO_API_URL

    headers = {
        "accept": "application/json",
        "api-key": settings.BREVO_API_KEY,
        "content-type": "application/json",
    }

    payload = {
        "sender": {
            "name": "CitySewa",
            "email": settings.DEFAULT_FROM_EMAIL,
        },
        "to": [
            {"email": recipient_email}
        ],
        "subject": subject,
        "htmlContent": html_content,
        "textContent": body,
    }

    try:
        response = requests.post(url, json=payload, headers=headers, timeout=10)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print("EMAIL API ERROR:", str(e))
        raise

    return True