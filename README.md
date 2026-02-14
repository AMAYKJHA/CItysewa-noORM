[![Live on Render](https://img.shields.io/badge/Live-Render-green)](https://citysewa2.onrender.com)
![Python](https://img.shields.io/badge/Python-3.12-blue)
![Django](https://img.shields.io/badge/Django-5.2-green)
![DRF](https://img.shields.io/badge/DRF-3.16-red)
![License](https://img.shields.io/badge/License-MIT-yellow)

## CitySewa: A HyperLocal Service Marketplace platform

CitySewa is a hyperlocal service marketplace platform that connects customers with nearby service providers.

## Why this project was built

- To make local service booking faster and easier for customers.
- To give service providers a direct digital channel to receive bookings.
- To provide one shared backend and multiple client experiences (web + mobile/provider).

## Core products in this repository

1. Web app (`Frontend/`)
- React + Vite web application.
- Includes public pages and role-based dashboards for customer, provider, and admin.

2. Customer app('citysewa_customer/`)
- A mobile-style showcase shell for customer/provider demo views.
- Useful for presenting app-like flows in browser.

3. Provider app (`citysewa_provider/`)
- Flutter app focused on provider onboarding and account operations.
- Supports provider login, registration, profile, and verification submission.

4. Backend API (`Backend/`)
- Django + DRF service layer used by web and provider clients.
- Handles accounts, services, authentication, and API docs.

## High-level architecture

- Clients: `Frontend`, `citysewa_provider`, `MobileWeb`
- API: `Backend` (`/api/v1/...`)
- Data: PostgreSQL in production; SQLite local mode supported via `LOCAL=True`
- Optional object storage: Supabase S3 compatible buckets

## Repository layout

- `Backend/` Django REST API
- `Frontend/` React web frontend
- `citysewa_provider/` Flutter provider application
- `MobileWeb/` Mobile-view demo showcase

## Live endpoint references in current code

- Backend API base URL: `https://citysewa2.onrender.com/api/v1`
- Frontend is configured to call that same API via `VITE_API_URL`

