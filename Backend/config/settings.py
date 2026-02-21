from pathlib import Path
import environ
import sentry_sdk

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent
APP_DIR = BASE_DIR / "src"

env = environ.Env(DEBUG=(bool,False))
environ.Env.read_env(BASE_DIR / ".env")


SECRET_KEY = env(
        "DJANGO_SECRET_KEY",
        default='#3s(&hhwg1e)vq5+!y=p*uxke82mgk_zb%lgn_i)qmt2g59x@e'
    )

DEBUG = env.bool("DEBUG")

ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS", default=["*"])

CORS_ALLOW_ALL_ORIGINS=env.bool("CORS_ALLOW_ALL_ORIGINS", default=True)
CORS_ALLOWED_ORIGINS=env.list("CORS_ALLOWED_ORIGINS", default=["*"])

# Application definition
DJANGO_APPS = [
    "django.contrib.auth",
    "django.contrib.contenttypes",
    # "django.contrib.staticfiles",
    
    "corsheaders"
]

LOCAL_APPS = []

THIRD_PARTY_APPS = [
    "rest_framework",
    "drf_spectacular"
]

INSTALLED_APPS = DJANGO_APPS + LOCAL_APPS + THIRD_PARTY_APPS

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    # "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    # "django.contrib.auth.middleware.AuthenticationMiddleware",
    # "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [str(APP_DIR / "templates")],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.request",
                # "django.contrib.auth.context_processors.auth",
                # "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

LOCAL = env.bool("LOCAL", False)
if LOCAL:
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": BASE_DIR / "db.sqlite3",
        }
    }
    
else:
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.postgresql",
            "NAME": env("DB_NAME"),
            "USER": env("DB_USER"),
            "PASSWORD": env("DB_PASSWORD"),
            "HOST": env("DB_HOST"),
            "PORT": env("DB_PORT"),
            "OPTIONS": {
                "sslmode": "require",
                "connect_timeout": 10,
                "options": "-c statement_timeout=30000"
            },
            "CONN_MAX_AGE": 30,
        }
    }

# Supabase S3 bucket
USE_S3=env.bool("USE_S3", False)
if USE_S3:
    SUPABASE_S3_ACCESS_KEY_ID=env("SUPABASE_S3_ACCESS_KEY_ID")
    SUPABASE_S3_SECRET_ACCESS_KEY = env("SUPABASE_S3_SECRET_ACCESS_KEY")
    SUPABASE_S3_REGION_NAME = env("SUPABASE_S3_REGION_NAME")
    SUPABASE_S3_ENDPOINT_URL = env("SUPABASE_S3_ENDPOINT_URL")
    STORAGE_BUCKETS = {
        "customer": env("SUPABASE_S3_CUSTOMER_BUCKET_NAME"),
        "provider": env("SUPABASE_S3_PROVIDER_BUCKET_NAME"),
        "service": env("SUPABASE_S3_SERVICE_BUCKET_NAME")
    }
else:
    SUPABASE_S3_ACCESS_KEY_ID = None
    SUPABASE_S3_SECRET_ACCESS_KEY = None
    SUPABASE_S3_REGION_NAME = None
    SUPABASE_S3_ENDPOINT_URL = None
    STORAGE_BUCKETS = {
        "customer": None,
        "provider": None,
        "service": None
    }

# Password validation
# https://docs.djangoproject.com/en/5.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    # {
    #     "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    # },
    # {
    #     "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    # },
    # {
    #     "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    # },
    # {
    #     "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    # },
]


LANGUAGE_CODE = "en-us"

TIME_ZONE = "UTC"

USE_I18N = True

USE_TZ = True

STATIC_URL = "static/"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"


REST_FRAMEWORK = {  
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
}

ORIGIN_URL=env.str("ORIGIN_URL", None)
OTP_EXPIRY_TIME=env.int("OTP_EXPIRY_TIME", 300) # 5 minutes

REDIS_HOST=env.str("REDIS_HOST")
REDIS_PORT=env.int("REDIS_PORT")
REDIS_PASSWORD=env.str("REDIS_PASSWORD")

# Redis caching
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": f"redis://default:{REDIS_PASSWORD}@{REDIS_HOST}:{REDIS_PORT}/0",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

APP_LOGO=env.str("APP_LOGO")

# Email settings
if env.bool("USE_SMTP", False):
    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
    EMAIL_HOST = env.str("EMAIL_HOST")
    EMAIL_PORT = env.int("EMAIL_PORT")
    EMAIL_USE_TLS = True                         

    EMAIL_HOST_USER = env.str("EMAIL_LOGIN")
    EMAIL_HOST_PASSWORD = env.str("EMAIL_SMTP_KEY")
else:
    BREVO_API_URL = env.str("BREVO_API_URL")
    BREVO_API_KEY = env.str("BREVO_API_KEY")
    
DEFAULT_FROM_EMAIL = env.str("FROM_EMAIL")

if env.bool("USE_SENTRY", default=True):
    sentry_sdk.init(
        dsn=env.str("SENTRY_DSN"),
        send_default_pii=True,
    )

SPECTACULAR_SETTINGS = {
    'TITLE': 'CitySewa API',
    'DESCRIPTION': 'API documentation',
    'VERSION': '1.0.0',
}


