# CitySewa Provider App

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)

The **CitySewa Provider** app is a Flutter-based mobile application built for service providers on the [CitySewa](https://citysewa2.onrender.com) hyperlocal service marketplace platform. It enables providers to onboard, manage their profiles, submit verification documents, and manage the services they offer.

## Features

- **Splash Screen** — Branded launch screen with session-aware auto-navigation
- **Authentication** — Provider login and registration
- **Profile Management** — View and update provider profile details
- **Verification Submission** — Upload documents for identity/account verification
- **Service Management** — Add and view services offered
- **Booking Overview** — View incoming bookings from customers
- **Session Persistence** — Token-based session management using `shared_preferences`

## Tech Stack

| Layer         | Technology                        |
| ------------- | --------------------------------- |
| Framework     | Flutter                           |
| Language      | Dart (SDK ^3.10.1)                |
| HTTP Client   | [`http`](https://pub.dev/packages/http) |
| SVG Rendering | [`flutter_svg`](https://pub.dev/packages/flutter_svg) |
| Session       | [`shared_preferences`](https://pub.dev/packages/shared_preferences) |
| Image Picker  | [`image_picker`](https://pub.dev/packages/image_picker) |
| Navigation    | [`curved_navigation_bar`](https://pub.dev/packages/curved_navigation_bar) / [`circle_nav_bar`](https://pub.dev/packages/circle_nav_bar) |
| Font          | Inter (bundled custom font)       |

## Project Structure

```
citysewa_provider/
├── android/              # Android platform files
├── ios/                  # iOS platform files
├── web/                  # Web platform files
├── assets/
│   ├── images/           # App images and icons
│   └── fonts/Inter/      # Inter font family (Regular, Medium, SemiBold, Bold)
├── lib/
│   ├── main.dart             # App entry point, routing, and theme configuration
│   ├── session_manager.dart  # Token/session persistence via shared_preferences
│   ├── api/                  # API service layer (HTTP calls to backend)
│   ├── screens/
│   │   ├── splash_screen.dart        # Splash / launch screen
│   │   ├── login_screen.dart         # Provider login
│   │   ├── signup_screen.dart        # Provider registration
│   │   ├── main_screen.dart          # Main shell with bottom navigation
│   │   ├── profile_screen.dart       # Provider profile view/edit
│   │   ├── verification_screen.dart  # Document upload for verification
│   │   ├── add_service_screen.dart   # Add a new service listing
│   │   ├── reset_pass_screen.dart    # Password reset (placeholder)
│   │   └── pages/
│   │       ├── home_page.dart        # Home / dashboard tab
│   │       ├── booking_page.dart     # Bookings tab
│   │       └── service_page.dart     # Services tab
│   └── widgets/
│       └── widgets.dart              # Reusable UI components
├── pubspec.yaml          # Dependencies and asset declarations
├── analysis_options.yaml # Lint rules
├── devtools_options.yaml # DevTools configuration
└── vercel.json           # Vercel deployment config (web builds)
```

## App Routes

| Route          | Screen               | Description                      |
| -------------- | -------------------- | -------------------------------- |
| `/`            | `SplashScreen`       | Launch screen with auto-redirect |
| `/login`       | `LoginScreen`        | Provider sign-in                 |
| `/register`    | `SignupScreen`       | Provider registration            |
| `/main`        | `MainScreen`         | Main app shell (Home, Bookings, Services) |
| `/profile`     | `ProfileScreen`      | View/edit provider profile       |
| `/verify`      | `VerificationScreen` | Submit verification documents    |
| `/add-service` | `AddServiceScreen`   | Add a new service listing        |

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK ^3.10.1)
- Android Studio / Xcode (for mobile builds)
- Chrome (for web builds)

### Installation

1. Navigate to the provider app directory:
   ```bash
   cd citysewa_provider
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # Android / iOS
   flutter run

   # Web
   flutter run -d chrome
   ```

### Build

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Backend Integration

This app communicates with the CitySewa Django REST API backend.

- **API Base URL:** `https://citysewa2.onrender.com/api/v1`
- **Key endpoints used:**
  - `api/v1/accounts/...` — Authentication, profile, verification
  - `api/v1/services/...` — Service listing and management

## Related Components

This app is part of the larger [CItysewa-noORM](https://github.com/AMAYKJHA/CItysewa-noORM) monorepo:

| Component            | Path                 | Description                       |
| -------------------- | -------------------- | --------------------------------- |
| Backend API          | `Backend/`           | Django + DRF REST API             |
| Web Frontend         | `Frontend/`          | React + Vite web application      |
| Customer App         | `citysewa_customer/` | Mobile-style customer demo views  |
| **Provider App**     | `citysewa_provider/` | **This app** — Flutter provider client |
