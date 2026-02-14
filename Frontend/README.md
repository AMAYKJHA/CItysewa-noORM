
This frontend is the React web application for CitySewa.

## Tech stack

- React 19
- Vite 7
- React Router DOM 7
- Axios for API calls
- ESLint for code quality

## Application coverage

The web app supports multiple user experiences:

- Public browsing (home, about, services)
- Customer flows (dashboard, bookings, addresses, profile)
- Provider flows (dashboard, service management, profile)
- Admin flows (dashboard, users, services)

## Project structure

- `src/api/` API client and request helpers
- `src/routes/` route tree and protected route logic
- `src/layouts/` public/auth/customer/provider/admin layouts
- `src/pages/` page-level features
- `src/components/` reusable UI modules by feature area
- `src/hooks/` data-fetch and auth hooks
- `src/Style/` CSS stylesheets
- `public/` static media assets

## Setup

1. Open terminal in `Frontend/`.
2. Install dependencies:
```bash
npm install
```
3. Configure environment:
```env
VITE_API_URL=https://citysewa2.onrender.com/api/v1
```
4. Start dev server:
```bash
npm run dev
```
5. Build for production:
```bash
npm run build
```

## Routing summary

- Public: `/`, `/services`, `/services/:id`, `/about`
- Auth: `/login`, `/register`, `/login-admin`, `/register-admin`, `/forgot-password`
- Customer: `/customer`, `/customer/bookings/...`, `/customer/addresses...`, `/customer/profile`
- Provider: `/provider`, `/provider/services...`, `/provider/profile`
- Admin: `/admin`, `/admin/users`, `/admin/services`

## Backend integration

- Frontend requests are built on Axios in `src/api/client.js`.
- Auth token is injected from `localStorage` into `Authorization` header.
- Current API base in code points to `https://citysewa2.onrender.com/api/v1`.

