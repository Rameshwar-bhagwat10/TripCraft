-- Migration SQL for 007_create_itinerary_tables.sql

CREATE TABLE IF NOT EXISTS public.trip_days (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_id UUID NOT NULL REFERENCES public.trips(id) ON DELETE CASCADE,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    day_number INTEGER NOT NULL,
    title TEXT,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT trip_days_trip_day_number_key UNIQUE (trip_id, day_number)
);

CREATE TABLE IF NOT EXISTS public.itinerary_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    trip_day_id UUID NOT NULL REFERENCES public.trip_days(id) ON DELETE CASCADE,
    place_id UUID,
    title TEXT NOT NULL,
    description TEXT,
    type TEXT DEFAULT 'sightseeing' NOT NULL,
    start_time TEXT,
    end_time TEXT,
    duration TEXT,
    order_index INTEGER DEFAULT 0 NOT NULL,
    notes TEXT,
    image_url TEXT,
    is_all_day BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_trip_days_trip ON public.trip_days(trip_id);
CREATE INDEX IF NOT EXISTS idx_trip_days_date ON public.trip_days(date);
CREATE INDEX IF NOT EXISTS idx_itinerary_items_day ON public.itinerary_items(trip_day_id);
CREATE INDEX IF NOT EXISTS idx_itinerary_items_order ON public.itinerary_items(order_index);
CREATE INDEX IF NOT EXISTS idx_itinerary_items_type ON public.itinerary_items(type);
