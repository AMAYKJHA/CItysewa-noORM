# CitySewa Backend

[![Live on Render](https://img.shields.io/badge/Live-Render-green)](https://citysewa2.onrender.com)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![Django](https://img.shields.io/badge/Django-5.2-green)
![DRF](https://img.shields.io/badge/DRF-3.16-red)
![License](https://img.shields.io/badge/License-MIT-yellow)

The backend for **CitySewa** — a city services marketplace connecting customers with service providers. Built with **Django** and **Django REST Framework**, this project deliberately avoids Django's ORM in favor of raw SQL with a custom database manager.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [Getting Started](#getting-started)
- [Environment Variables](#environment-variables)
- [Custom Migrations](#custom-migrations)
- [Deployment](#deployment)

---

## Tech Stack

| Technology | Version / Notes |
|---|---|
| Python | 3.12+ |
| Django | 5.2 |
| Django REST Framework | 3.16 |
| drf-spectacular | OpenAPI / Swagger docs |
| PostgreSQL | Production database |
| SQLite | Local development mode |
| Boto3 | S3-compatible storage (Supabase) |
| Gunicorn | Production WSGI server |
| Sentry SDK | Optional error monitoring |
| uv | Package manager |

---

## Project Structure

```
Backend/
├── config/                  # Django project configuration
│   ├── settings.py          # Project settings (DB, CORS, S3, Sentry)
│   ├── urls.py              # Root URL routing
│   └── wsgi.py              # WSGI entry point
├── src/
│   ├── accounts/            # Auth & role-based account endpoints
│   ├── addresses/           # Address-related views & logic
│   ├── api/                 # API versioning & URL routing
│   ├── bookings/            # Booking data layer utilities
│   ├── core/                # Authentication, DB manager, schema, validators
│   ├── services/            # Service listing & management APIs
│   ├── templates/           # HTML templates (if any)
│   └── utils/               # Shared utilities (storage integration, etc.)
├── schema.sql               # Full PostgreSQL schema (tables, triggers)
├── manage.py                # Django management CLI (with custom migrate)
├── pyproject.toml           # Project metadata & dependencies
├── uv.lock                  # Locked dependency versions
├── render.yaml              # Render.com deployment config
├── .env.example             # Environment variable template
└── .python-version          # Python version pin (3.12)
```

---

## Database Schema

The project uses **raw SQL** (no ORM). The schema is defined in [`schema.sql`](schema.sql) and includes:

| Table | Description |
|---|---|
| `users` | Core user accounts (email, phone, password, admin flag) |
| `tokens` | Auth tokens linked to users |
| `customers` | Customer profiles (name, gender, photo) |
| `providers` | Service provider profiles (name, description, verification status) |
| `documents` | Provider verification documents (type, number, status) |
| `services` | Service listings (title, type, price, thumbnail) |
| `districts` | Geographic districts |
| `locations` | Locations with area, ward, city, district |
| `addresses` | User addresses linked to locations |
| `bookings` | Service bookings (date, time, status) |

All tables include `created_at` and `updated_at` timestamps with an auto-update trigger via `set_updated_at()`.

---

## API Endpoints

| Route | Description |
|---|---|
| `/` | Redirects to Swagger UI |
| `api/v1/` | API root |
| `api/v1/accounts/...` | Authentication & account management |
| `api/v1/services/...` | Service listing & CRUD |
| `api/v1/schema` | OpenAPI 3.0 schema (JSON) |
| `api/v1/docs` | Interactive Swagger documentation |
| `sentry-debug` | Sentry integration test endpoint |

---

## Getting Started

### Prerequisites

- Python 3.12+
- [`uv`](https://docs.astral.sh/uv/) package manager
- PostgreSQL (for production) or SQLite (for local dev)

### Installation

1. **Navigate to the Backend directory:**
   ```bash
   cd Backend
   ```

2. **Create a virtual environment and install dependencies:**
   ```bash
   uv venv
   uv sync
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` with your values (see [Environment Variables](#environment-variables)).

4. **Run the database schema migration:**
   ```bash
   python manage.py custommigrate
   ```

5. **Start the development server:**
   ```bash
   python manage.py runserver
   ```

6. **Visit the API docs:**
   Open [http://localhost:8000/api/v1/docs](http://localhost:8000/api/v1/docs) in your browser.

---

## Environment Variables

Create a `.env` file from `.env.example`. Key settings:

| Variable | Description | Default |
|---|---|---|
| `DEBUG` | Enable debug mode | `True` |
| `LOCAL` | Use SQLite instead of PostgreSQL | `False` |
| `DJANGO_SECRET_KEY` | Django secret key | — |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated allowed hosts | `127.0.0.1,localhost` |
| `CORS_ALLOW_ALL_ORIGINS` | Allow all CORS origins | `True` |
| `CORS_ALLOWED_ORIGINS` | Specific allowed origins | `http://localhost:3001` |
| `DB_NAME` | PostgreSQL database name | — |
| `DB_USER` | PostgreSQL user | — |
| `DB_HOST` | PostgreSQL host | — |
| `DB_PORT` | PostgreSQL port | `5432` |
| `DB_PASSWORD` | PostgreSQL password | — |
| `USE_S3` | Enable Supabase S3 storage | `False` |
| `SUPABASE_S3_ACCESS_KEY_ID` | S3 access key | — |
| `SUPABASE_S3_SECRET_ACCESS_KEY` | S3 secret key | — |
| `SUPABASE_S3_BUCKET_NAME` | S3 bucket name | — |
| `SUPABASE_S3_REGION_NAME` | S3 region | — |
| `SUPABASE_S3_ENDPOINT_URL` | S3 endpoint URL | — |
| `SENTRY_DSN` | Sentry DSN (optional) | — |

### Quick start for local development (SQLite):

```env
LOCAL=True
DEBUG=True
DJANGO_SECRET_KEY=your-secret-key
```

---

## Custom Migrations

This project does **not** use Django's built-in ORM migrations. Instead, it uses a custom `db_manager` module that executes the raw SQL in `schema.sql`.

Run migrations with:

```bash
python manage.py custommigrate
```

---

## Deployment

### Render.com

The project includes a [`render.yaml`](render.yaml) for deployment on [Render](https://render.com):

- **Build:** `pip install -r requirements.txt`
- **Start:** Runs `custommigrate` then launches Gunicorn
- **Workers:** 1 worker, 2 threads (starter plan)
- **Auto-deploy:** Disabled (manual deploys)

The live deployment is available at: **[https://citysewa2.onrender.com](https://citysewa2.onrender.com)**

### Manual Production Setup

```bash
python manage.py custommigrate --noinput
gunicorn config.wsgi:application --workers 2 --threads 2 --bind 0.0.0.0:8000
```

---

## License

This project is licensed under the MIT License.
