-- Migration: 002_create_profiles_and_preferences
-- Description: Create public.profiles and public.user_preferences tables with Supabase Row Level Security (RLS)

-- 1. Create Profiles Table (mapped to auth.users.id)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    onboarding_completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create User Preferences Table
CREATE TABLE IF NOT EXISTS public.user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES public.profiles(id) ON DELETE CASCADE,
    travel_styles TEXT[] DEFAULT '{}',
    interests TEXT[] DEFAULT '{}',
    budget_level TEXT NOT NULL DEFAULT 'Moderate',
    travel_pace TEXT NOT NULL DEFAULT 'Balanced',
    companion_types TEXT[] DEFAULT '{}',
    activity_preferences TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Enable Row Level Security (RLS)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;

-- 4. RLS Policies for Profiles
DROP POLICY IF EXISTS "Users can view own profile" ON public.profiles;
CREATE POLICY "Users can view own profile" 
    ON public.profiles FOR SELECT 
    USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile" 
    ON public.profiles FOR UPDATE 
    USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile" 
    ON public.profiles FOR INSERT 
    WITH CHECK (auth.uid() = id);

-- 5. RLS Policies for User Preferences
DROP POLICY IF EXISTS "Users can view own preferences" ON public.user_preferences;
CREATE POLICY "Users can view own preferences" 
    ON public.user_preferences FOR SELECT 
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own preferences" ON public.user_preferences;
CREATE POLICY "Users can update own preferences" 
    ON public.user_preferences FOR UPDATE 
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own preferences" ON public.user_preferences;
CREATE POLICY "Users can insert own preferences" 
    ON public.user_preferences FOR INSERT 
    WITH CHECK (auth.uid() = user_id);
