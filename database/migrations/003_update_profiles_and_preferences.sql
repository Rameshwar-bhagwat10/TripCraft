-- TripCraft Phase 04 Database Migration: User Profile & Preferences Extension

-- 1. Extend profiles table
ALTER TABLE public.profiles
  ADD COLUMN IF NOT EXISTS "language" TEXT NOT NULL DEFAULT 'en',
  ADD COLUMN IF NOT EXISTS "currency" TEXT NOT NULL DEFAULT 'USD';

-- 2. Extend user_preferences table
ALTER TABLE public.user_preferences
  ADD COLUMN IF NOT EXISTS "reduced_motion" BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS "larger_text" BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS "high_contrast" BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS "personalized_recommendations" BOOLEAN NOT NULL DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS "ai_personalization" BOOLEAN NOT NULL DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS "contextual_suggestions" BOOLEAN NOT NULL DEFAULT TRUE;
