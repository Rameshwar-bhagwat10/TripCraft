# TripCraft — AI-powered Travel Planning SaaS

TripCraft is a premium, mobile-first travel planning SaaS platform. It leverages Clean Architecture principles on the mobile front-end and a modular dependency-injected design on the NestJS backend to deliver a highly testable, secure, and maintainable software ecosystem.

---

## 1. Technology Stack

### Mobile Frontend
- **Framework:** Flutter (Dart SDK)
- **State Management:** Riverpod (with Code Generation)
- **Navigation:** GoRouter
- **HTTP client:** Dio
- **ORM / Local Database:** Drift (SQLite wrapper)
- **Secure Persistence:** Flutter Secure Storage
- **Cloud Backend Integration:** Supabase Client

### Backend API
- **Runtime:** Node.js (TypeScript)
- **Framework:** NestJS
- **ORM:** Prisma
- **Database:** Supabase PostgreSQL
- **Docs:** OpenAPI / Swagger (at `/api/docs`)

---

## 2. Directory Structure

```text
tripcraft/
├── .github/workflows/          # GitHub CI Actions (mobile & backend)
├── scripts/                    # Bootstrap setup scripts
├── mobile/                     # Flutter Mobile App
│   ├── lib/
│   │   ├── app/                # Global routing, themes, Riverpod providers
│   │   ├── config/             # Environment & api config
│   │   ├── core/               # Errors, networks, database, secure storage
│   │   ├── data/               # Data repositories & datasources
│   │   ├── domain/             # Domain entities & usecases
│   │   └── features/           # Modular features
│   └── test/                   # Unit & Widget tests
├── backend/                    # NestJS Backend API
│   ├── prisma/                 # Database schema & seed file
│   └── src/                    # Backend modular services
└── docs/                       # Project documentation
```

---

## 3. Development Prerequisites

Ensure you have the following installed on your local development machine:
- **Flutter SDK:** stable (`^3.19.x` or later)
- **Dart SDK:** compatible with Flutter (`^3.9.x` or later)
- **Node.js:** version `18` or `20`
- **npm:** or standard package manager
- **Supabase CLI:** (optional, for local Supabase emulator)

---

## 4. Setup & Installation

### Environment Configuration
1. **Mobile Env Setup:**
   Copy `mobile/.env.example` to `mobile/.env` (Note: `.env` is ignored by Git).
   Update with your Supabase Anon/Public configuration.
2. **Backend Env Setup:**
   Copy `backend/.env.example` to `backend/.env` (Note: `.env` is ignored by Git).
   Update `DATABASE_URL` with your Supabase PostgreSQL connection string.

### Mobile Frontend Setup
```bash
cd mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Backend Services Setup
```bash
cd backend
npm install
npx prisma generate
```

---

## 5. Running the Projects

### Running Mobile Frontend
Make sure you have an active emulator or a USB debugging device connected:
```bash
cd mobile
flutter run
```

### Running Backend API
```bash
cd backend
npm run start:dev
```
- Access Healthcheck: `GET http://localhost:3000/api/v1/health`
- Access API Documentation (Swagger): `http://localhost:3000/api/docs`
