# CitySewa — Frontend

The React web application for **CitySewa**, a local-services marketplace that connects neighborhood talent (electricians, tutors, etc.) with people who need help.

## Tech Stack

| Tool                                                                               | Version | Purpose                      |
| ---------------------------------------------------------------------------------- | ------- | ---------------------------- |
| [React](https://react.dev/)                                                        | 19      | UI library                   |
| [Vite](https://vite.dev/)                                                          | 7       | Build tool & dev server      |
| [React Router DOM](https://reactrouter.com/)                                       | 7       | Client-side routing          |
| [Axios](https://axios-http.com/)                                                   | 1.x     | HTTP client for API calls    |
| [react-phone-number-input](https://www.npmjs.com/package/react-phone-number-input) | 3.x     | Phone number input component |
| [ESLint](https://eslint.org/)                                                      | 9       | Code quality & linting       |

## Application Coverage

The web app supports multiple user experiences:

- **Public browsing** — Home, About, and Services pages accessible without authentication.
- **Customer flows** — Dashboard, bookings, addresses, and profile management.
- **Provider flows** — Dashboard, service management, and profile.
- **Admin flows** — Dashboard, user management, and service oversight.

## Project Structure

```
Frontend/
├── public/                  # Static media assets
├── src/
│   ├── api/                 # Axios client & request helpers
│   ├── assets/              # Images & static imports
│   ├── components/          # Reusable UI modules organised by feature
│   │   ├── admin/           #   Admin-specific components (sidebar, etc.)
│   │   ├── bookings/        #   Booking cards & lists
│   │   ├── common/          #   Shared components (Navbar, Footer)
│   │   └── services/        #   Service browsing & cards
│   ├── hooks/               # Custom hooks (auth, data-fetching)
│   ├── layouts/             # Route-level layouts
│   │   ├── AdminLayout.jsx
│   │   ├── AuthLayout.jsx
│   │   ├── BaseLayout.jsx
│   │   └── PublicLayout.jsx
│   ├── pages/               # Page-level features
│   │   ├── auth/            #   Login, Register, Forgot Password
│   │   ├── addresses/       #   Address management
│   │   ├── bookings/        #   Booking detail, form, list
│   │   ├── dashboard/       #   Customer, Provider & Admin dashboards
│   │   ├── profiles/        #   Customer & Provider profiles
│   │   ├── services/        #   Service listing & detail
│   │   ├── Home.jsx
│   │   └── About.jsx
│   ├── routes/              # Route tree & protected-route logic
│   │   └── AppRoutes.jsx
│   ├── Style/               # CSS stylesheets
│   ├── App.jsx              # Root component
│   └── main.jsx             # Entry point (renders into DOM)
├── package.json
└── vite.config.js
```

## Prerequisites

- **Node.js** ≥ 18
- **npm** ≥ 9

## Setup

1. **Navigate** into the `Frontend/` directory:

   ```bash
   cd Frontend
   ```

2. **Install dependencies:**

   ```bash
   npm install
   ```

3. **Configure environment** — create a `.env` file in `Frontend/`:

   ```env
   VITE_API_URL=https://citysewa2.onrender.com/api/v1
   ```

4. **Start the dev server:**

   ```bash
   npm run dev
   ```

5. **Build for production:**

   ```bash
   npm run build
   ```

6. **Preview the production build:**

   ```bash
   npm run preview
   ```

7. **Lint the codebase:**
   ```bash
   npm run lint
   ```

## Routing Summary

### Public Routes

| Path            | Page            |
| --------------- | --------------- |
| `/`             | Home            |
| `/about`        | About           |
| `/services`     | Browse Services |
| `/services/:id` | Service Detail  |

### Auth Routes

| Path               | Page                          |
| ------------------ | ----------------------------- |
| `/login`           | Customer Login                |
| `/register`        | Customer Registration         |
| `/login-admin`     | Admin / Provider Login        |
| `/register-admin`  | Admin / Provider Registration |
| `/forgot-password` | Password Recovery             |

### Customer Routes (Protected)

| Path                      | Page               |
| ------------------------- | ------------------ |
| `/customer`               | Customer Dashboard |
| `/customer/bookings/...`  | Booking Management |
| `/customer/addresses/...` | Address Management |
| `/customer/profile`       | Customer Profile   |

### Provider Routes (Protected)

| Path                     | Page               |
| ------------------------ | ------------------ |
| `/provider`              | Provider Dashboard |
| `/provider/services/...` | Service Management |
| `/provider/profile`      | Provider Profile   |

### Admin Routes (Protected)

| Path              | Page              |
| ----------------- | ----------------- |
| `/admin`          | Admin Dashboard   |
| `/admin/users`    | User Management   |
| `/admin/services` | Service Oversight |

## Backend Integration

- All HTTP requests go through the Axios client configured in `src/api/client.js`.
- The auth token stored in `localStorage` is automatically injected into the `Authorization` header on each request.
- The API base URL is controlled by the `VITE_API_URL` environment variable (defaults to `https://citysewa2.onrender.com/api/v1`).

## Architecture Notes

- **`AuthProvider`** wraps the entire app (in `main.jsx`) to provide authentication context via the `useAuth` hook.
- **Layout components** (`PublicLayout`, `AuthLayout`, `AdminLayout`, etc.) compose a shared Navbar/Footer around nested `<Outlet />` routes.
- **Admin layout** uses a sidebar navigation pattern with an `activeSection` state passed via React Router's `useOutletContext`.

## Related

- [Backend (Django REST API)](../Backend/)
- [Provider App (Flutter)](../citysewa_provider/)
- [Mobile Web Demo](../MobileWeb/)
