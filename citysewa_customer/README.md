# CitySewa — Customer App 📱

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-^3.10.1-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-yellow)

The **Flutter** mobile application for **customers** of [CitySewa](https://github.com/AMAYKJHA/CItysewa-noORM) — a hyperlocal service marketplace that connects people with nearby service providers such as electricians, plumbers, tutors, and cleaners.

This app provides a native mobile experience for customers to browse services, manage bookings, and interact with service providers on the go.

---

## ✨ Features

- 🏠 **Splash Screen** — Branded launch screen with session-aware navigation
- 🔐 **Authentication** — Customer login & registration with token-based session persistence
- 🔍 **Browse Services** — Discover and explore local services by category
- 📅 **Book Services** — Schedule service appointments with date and time selection
- 📍 **Address Management** — Save and manage multiple delivery/service addresses
- 👤 **Profile Management** — View and edit personal profile information
- 📊 **Dashboard** — Track active and past bookings in one place
- 🖼️ **Image Support** — Profile photo upload via camera or gallery
- 🎠 **Carousel UI** — Image carousels for enhanced browsing experience

---

## 🛠️ Tech Stack

| Technology | Version / Details |
|---|---|
| Flutter | 3.x — Cross-platform framework |
| Dart | SDK ^3.10.1 |
| Platforms | Android, iOS, Web |

### Key Dependencies

| Package | Purpose |
|---|---|
| `http` | HTTP client for API communication |
| `shared_preferences` | Token-based session persistence |
| `image_picker` | Camera/gallery photo selection |
| `flutter_svg` | SVG asset rendering |
| `cached_network_image` | Efficient network image caching |
| `carousel_slider` | Image carousel/slider widgets |
| `curved_navigation_bar` | Curved bottom navigation bar |
| `flutter_launcher_icons` | Custom app launcher icon generation |

---

## 📂 Project Structure

```
citysewa_customer/
├── android/                # Android platform files
├── ios/                    # iOS platform files
├── web/                    # Web platform files
├── assets/
│   ├── images/             # Image assets (logos, icons, etc.)
│   └── fonts/
│       └── Inter/          # Inter font family (Regular, Medium, SemiBold, Bold)
├── lib/
│   ├── api/                # API client & request helpers
│   ├── screens/            # Screen-level UI components
│   ├── widgets/            # Reusable widget components
│   ├── utils/              # Shared utility functions
│   ├── session_manager.dart # Token/session management
│   └── main.dart           # App entry point
├── pubspec.yaml            # Flutter project configuration & dependencies
├── pubspec.lock            # Locked dependency versions
├── analysis_options.yaml   # Dart linting rules
├── vercel.json             # Vercel deployment config (web build)
└── README.md               # This file
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.10.1)
- Android Studio / Xcode (for mobile) or Chrome (for web)

### Installation

1. **Navigate** to the customer app directory:
   ```bash
   cd citysewa_customer
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   # Android / iOS (connected device or emulator)
   flutter run

   # Web (Chrome)
   flutter run -d chrome
   ```

4. **Build for production:**
   ```bash
   # Android APK
   flutter build apk

   # iOS
   flutter build ios

   # Web
   flutter build web
   ```

### Generate Launcher Icons

```bash
flutter pub run flutter_launcher_icons
```

---

## 🌐 Web Deployment

The app includes a `vercel.json` configuration for deploying the Flutter web build to [Vercel](https://vercel.com).

```bash
flutter build web
# Deploy the build/web directory to Vercel
```

---

## 🔗 Backend Integration

The customer app communicates with the CitySewa Django REST API:

| Environment | API URL |
|---|---|
| **Production** | `https://citysewa2.onrender.com/api/v1` |
| **Local Dev** | `http://localhost:8000/api/v1` |

### Key API Endpoints Used

| Endpoint | Description |
|---|---|
| `api/v1/accounts/...` | Authentication & account management |
| `api/v1/services/...` | Browse & search services |
| `api/v1/bookings/...` | Create & manage bookings |
| `api/v1/addresses/...` | Address CRUD operations |

---

## 🏗️ Part of the CitySewa Monorepo

This app is one of four core products in the [CItysewa-noORM](https://github.com/AMAYKJHA/CItysewa-noORM) monorepo:

| Product | Directory | Tech |
|---|---|---|
| **Backend API** | `Backend/` | Django + DRF (Raw SQL) |
| **Web App** | `Frontend/` | React + Vite |
| **Provider App** | `citysewa_provider/` | Flutter |
| **Customer App** | `citysewa_customer/` | Flutter ← *You are here* |

---

## 📜 License

This project is licensed under the **MIT License**.
