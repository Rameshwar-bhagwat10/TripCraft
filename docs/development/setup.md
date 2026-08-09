# Developer Setup & Troubleshooting Guide

This handbook describes the manual installation, configuration, testing, and debugging steps for the **Tripcraft** monorepo environment.

---

## 1. Software Prerequisites

Ensure the following tools are installed and present on your local system path:

| Software | Version Required | Verifying Command |
| :--- | :--- | :--- |
| **Flutter SDK** | `^3.19.x` or later | `flutter --version` |
| **Dart SDK** | `^3.9.x` or later | `dart --version` |
| **Node.js** | `v18` or `v20` | `node --version` |
| **npm** | `^9.x.x` or later | `npm --version` |
| **Prisma CLI** | `^5.5.x` | `npx prisma --version` |

---

## 2. Setting Up Environment Files

### A. Mobile Environment Setup
Create a `.env` file in the `mobile/` directory (or define them during compile time via `--dart-define` / `--dart-define-from-file`):
```ini
APP_ENV=development
API_BASE_URL=http://localhost:3000/api/v1
SUPABASE_URL=https://your-supabase-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-public-key
```

### B. Backend Environment Setup
Create a `.env` file in the `backend/` directory:
```ini
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1
DATABASE_URL="postgresql://postgres:password@localhost:5432/tripcraft?schema=public"
JWT_SECRET="some-secure-development-jwt-token-secret"
CORS_ORIGIN="http://localhost:3000"
```

---

## 3. Running Setup and Verification

### A. Frontend Compilation & Test
1. Install dependencies:
   ```bash
   cd mobile
   flutter pub get
   ```
2. Run builders to generate Drift schemas (`local_database.g.dart`):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Run verification checks:
   ```bash
   flutter analyze
   flutter test
   ```

### B. Backend API Setup & Test
1. Install dependencies:
   ```bash
   cd backend
   npm install
   ```
2. Compile Prisma schemas:
   ```bash
   npx prisma generate
   ```
3. Run NestJS test suites:
   ```bash
   npm run lint
   npm run test
   npm run build
   ```
4. Start the API locally in watch mode:
   ```bash
   npm run start:dev
   ```

---

## 4. Verification Checkpoints

Verify that everything is operational by checking these endpoints while the NestJS backend is running:

1. **System Health Check API:**
   - **URL:** `GET http://localhost:3000/api/v1/health`
   - **Response Schema:**
     ```json
     {
       "status": "ok",
       "service": "tripcraft-api",
       "database": "connected",
       "timestamp": "..."
     }
     ```
2. **OpenAPI Swagger UI:**
   - **URL:** `http://localhost:3000/api/docs`
   - Verify that the `Health` controller is documented and try sending a test request from the interactive page.

---

## 5. Troubleshooting Common Issues

### A. Flutter Code Generation Conflicts
If you encounter errors when running `build_runner`, try cleaning the cache and rebuilding:
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### B. Prettier Formatting Warnings
If your NestJS build fails due to formatting, auto-fix all typescript styling:
```bash
npm run format
```

### C. Prisma Connection Timeouts
If the Prisma client fails to compile or query the database:
1. Double-check your `DATABASE_URL` credentials in `backend/.env`.
2. Confirm the database is running (if using a local Postgres container via `docker-compose up -d`).
3. Make sure the database allows incoming queries on port `5432`.