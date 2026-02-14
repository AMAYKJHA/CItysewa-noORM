[![Live on Render](https://img.shields.io/badge/Live-Render-green)](https://citysewa2.onrender.com)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![Django](https://img.shields.io/badge/Django-5.2-green)
![DRF](https://img.shields.io/badge/DRF-3.16-red)
![License](https://img.shields.io/badge/License-MIT-yellow)

This backend is a Django + Django REST Framework API for CitySewa.

## Tech stack

- Python 3.12+
- Django 5.2
- Django REST Framework 3.16
- drf-spectacular (OpenAPI/Swagger docs)
- PostgreSQL (production) / SQLite (local mode)
- Optional S3-compatible object storage (Supabase)
- Sentry SDK (optional monitoring)

## Main backend modules

- `config/` project config (`settings.py`, `urls.py`)
- `src/accounts/` auth and role-based account endpoints
- `src/services/` service listing and management APIs
- `src/addresses/` address-related views
- `src/bookings/` booking data layer utilities
- `src/core/` authentication, db manager, schema, validators
- `src/utils/` shared utility code (including storage integration)

## API entry points

- API root include: `api/v1/`
- Accounts routes: `api/v1/accounts/...`
- Services routes: `api/v1/services...`
- OpenAPI schema: `api/v1/schema`
- Swagger docs: `api/v1/docs`

## Setup (local)

1. Open terminal in `Backend/`.
2. Install `uv` if needed.
3. Create virtual environment and install dependencies:
```bash
uv venv
uv sync
```
4. Create `.env` from `.env.example`.
5. For SQLite local mode set:
```env
LOCAL=True
DEBUG=True
```
6. For PostgreSQL mode keep `LOCAL=False` and fill DB values.
7. Run server:
```bash
python manage.py runserver
```

## Environment variables

Important settings in `.env`:

- `DEBUG`
- `LOCAL`
- `DJANGO_SECRET_KEY`
- `DJANGO_ALLOWED_HOSTS`
- `CORS_ALLOW_ALL_ORIGINS`, `CORS_ALLOWED_ORIGINS`
- `DB_NAME`, `DB_USER`, `DB_HOST`, `DB_PORT`, `DB_PASSWORD`
- `USE_S3` + Supabase S3 keys/buckets
- `SENTRY_DSN` (optional)

## Deployment notes

- Render deployment config exists as `render.yaml`.
- `gunicorn` is included for production serving.
- When using managed PostgreSQL, SSL and statement timeout settings are already handled in `settings.py`.
