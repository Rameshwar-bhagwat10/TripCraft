# Supabase Authentication & Deep Link Setup Guide

This guide details the manual setup required in the Supabase Dashboard, Google Cloud Console, and Apple Developer Portal for **TripCraft Phase 03**.

---

## 1. Supabase Dashboard Configuration

### A. Enable Email Provider
1. Log in to [Supabase Dashboard](https://supabase.com/dashboard/project/qnexcdrdvdxdggllanre).
2. Navigate to **Authentication** -> **Providers** -> **Email**.
3. Ensure **Enable Email provider** is toggled **ON**.
4. Set **Confirm email** to **ON** for production environments (or OFF during rapid local prototyping).
5. Set **Minimum password length** to `6` characters.

### B. Configure Redirect URLs & Site URL
1. Navigate to **Authentication** -> **URL Configuration**.
2. Set **Site URL**:
   ```text
   https://qnexcdrdvdxdggllanre.supabase.co
   ```
3. Add **Redirect URLs**:
   ```text
   io.supabase.tripcraft://login-callback
   io.supabase.tripcraft://reset-password
   http://localhost:3000/api/v1/auth/callback
   ```

---

## 2. Google OAuth Configuration

### A. Create Google OAuth Credentials
1. Open [Google Cloud Console](https://console.cloud.google.com/).
2. Select your project and navigate to **APIs & Services** -> **Credentials**.
3. Create **OAuth 2.0 Client IDs**:
   - **Web Application Client ID** (Used by Supabase Backend).
   - **Android Client ID** (Package name: `com.tripcraft.tripcraft`, SHA-1 fingerprint from local keystore).
   - **iOS Client ID** (Bundle ID: `com.tripcraft.tripcraft`).

### B. Configure Supabase Google Provider
1. Go to Supabase Dashboard -> **Authentication** -> **Providers** -> **Google**.
2. Toggle **Enable Google provider** **ON**.
3. Paste **Client ID** (from Google Web Application Client ID).
4. Paste **Client Secret** (from Google Web Application Client ID).
5. Save changes.

---

## 3. Apple Sign-In Configuration (iOS Only)

### A. Apple Developer Portal Setup
1. Log in to [Apple Developer Account](https://developer.apple.com/).
2. Register an **App ID** with **Sign in with Apple** capability enabled (`com.tripcraft.tripcraft`).
3. Create a **Services ID** (e.g. `com.tripcraft.tripcraft.sid`).
4. Set Primary App ID and domain/return URLs:
   ```text
   Domain: qnexcdrdvdxdggllanre.supabase.co
   Return URL: https://qnexcdrdvdxdggllanre.supabase.co/auth/v1/callback
   ```
5. Create a **Private Key** for Sign in with Apple and download the `.p8` file.

### B. Configure Supabase Apple Provider
1. Go to Supabase Dashboard -> **Authentication** -> **Providers** -> **Apple**.
2. Toggle **Enable Apple provider** **ON**.
3. Input **Services ID**, **Key ID**, **Team ID**, and paste the `.p8` Private Key content.

---

## 4. Database Migrations & RLS Execution

Execute the SQL script located at `database/migrations/002_create_profiles_and_preferences.sql` inside the Supabase SQL Editor:

```sql
-- Creates public.profiles and public.user_preferences with RLS policies enabled
```
This enables isolated row access so users can only view/update their own profile (`auth.uid() = id`) and preferences (`auth.uid() = user_id`).
