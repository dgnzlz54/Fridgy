-- ============================================================
-- FRIDGY — Supabase Database Schema
-- Run this entire file in the Supabase SQL Editor
-- Project: https://supabase.com → SQL Editor → New Query
-- ============================================================

-- ── PROFILES ──────────────────────────────────────────────
-- One row per authenticated user, created on signup
create table if not exists profiles (
  id              uuid references auth.users(id) on delete cascade primary key,
  household_name  text not null default 'My Kitchen',
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- ── HOUSEHOLD MEMBERS ─────────────────────────────────────
-- People in the household — can be more than just the account owner
create table if not exists household_members (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references profiles(id) on delete cascade not null,
  name            text not null,
  initials        text,
  sex             text check (sex in ('male', 'female', 'other')),
  age             integer check (age > 0 and age < 130),
  height_cm       numeric(5,1) check (height_cm > 0),
  weight_kg       numeric(5,1) check (weight_kg > 0),
  goal_weight_kg  numeric(5,1),
  activity        text not null default 'moderate'
                    check (activity in ('sedentary','light','moderate','active','very_active')),
  goal            text not null default 'maintain'
                    check (goal in ('cut','maintain','lean_bulk','bulk')),
  restrictions    text[] not null default '{}',
  dislikes        text[] not null default '{}',
  created_at      timestamptz not null default now()
);

-- ── PANTRY ITEMS ──────────────────────────────────────────
create table if not exists pantry_items (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references profiles(id) on delete cascade not null,
  name            text not null,
  qty             numeric(10,2) not null check (qty >= 0),
  unit            text not null,
  cat             text,
  loc             text not null default 'fridge'
                    check (loc in ('fridge','freezer','pantry')),
  exp             date,
  created_at      timestamptz not null default now()
);

-- ── SHOPPING ITEMS ────────────────────────────────────────
create table if not exists shopping_items (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references profiles(id) on delete cascade not null,
  name            text not null,
  amt             text,
  checked         boolean not null default false,
  created_at      timestamptz not null default now()
);

-- ── MEAL PLANS ────────────────────────────────────────────
create table if not exists meal_plans (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references profiles(id) on delete cascade not null,
  day             text not null,
  breakfast       text,
  lunch           text,
  dinner          text,
  created_at      timestamptz not null default now(),
  unique (user_id, day)
);

-- ============================================================
-- ROW LEVEL SECURITY
-- Users can only read/write their own data
-- ============================================================

alter table profiles          enable row level security;
alter table household_members enable row level security;
alter table pantry_items      enable row level security;
alter table shopping_items    enable row level security;
alter table meal_plans        enable row level security;

-- Profiles: user owns their own profile
create policy "profiles: own row"
  on profiles for all
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Household members
create policy "household_members: own rows"
  on household_members for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Pantry items
create policy "pantry_items: own rows"
  on pantry_items for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Shopping items
create policy "shopping_items: own rows"
  on shopping_items for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Meal plans
create policy "meal_plans: own rows"
  on meal_plans for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ============================================================
-- AUTO-CREATE PROFILE ON SIGNUP
-- Trigger: when a new user signs up, create their profile row
-- ============================================================

create or replace function handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, household_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'household_name', 'My Kitchen'));
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- ============================================================
-- INDEXES for performance
-- ============================================================

create index if not exists idx_household_members_user_id on household_members(user_id);
create index if not exists idx_pantry_items_user_id      on pantry_items(user_id);
create index if not exists idx_pantry_items_exp          on pantry_items(exp);
create index if not exists idx_shopping_items_user_id    on shopping_items(user_id);
create index if not exists idx_meal_plans_user_id        on meal_plans(user_id);

-- ============================================================
-- DONE ✅
-- Your Fridgy database is ready!
-- ============================================================
