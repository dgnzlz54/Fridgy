-- ============================================================
-- FRIDGY — Supabase Database Schema
-- Paste this entire file into Supabase SQL Editor → Run
-- ============================================================

create table if not exists profiles (
  id              uuid references auth.users(id) on delete cascade primary key,
  household_name  text not null default 'My Kitchen',
  created_at      timestamptz not null default now()
);

create table if not exists household_members (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid references profiles(id) on delete cascade not null,
  name            text not null,
  initials        text,
  sex             text check (sex in ('male','female','other')),
  age             integer,
  height_cm       numeric(5,1),
  weight_kg       numeric(5,1),
  goal_weight_kg  numeric(5,1),
  activity        text not null default 'moderate',
  goal            text not null default 'maintain',
  restrictions    text[] not null default '{}',
  dislikes        text[] not null default '{}',
  created_at      timestamptz not null default now()
);

create table if not exists pantry_items (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references profiles(id) on delete cascade not null,
  name        text not null,
  qty         numeric(10,2) not null,
  unit        text not null,
  cat         text,
  loc         text not null default 'fridge',
  exp         date,
  created_at  timestamptz not null default now()
);

create table if not exists shopping_items (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references profiles(id) on delete cascade not null,
  name        text not null,
  amt         text,
  checked     boolean not null default false,
  created_at  timestamptz not null default now()
);

create table if not exists meal_plans (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references profiles(id) on delete cascade not null,
  day         text not null,
  breakfast   text,
  lunch       text,
  dinner      text,
  created_at  timestamptz not null default now(),
  unique (user_id, day)
);

-- Row Level Security
alter table profiles         enable row level security;
alter table household_members enable row level security;
alter table pantry_items      enable row level security;
alter table shopping_items    enable row level security;
alter table meal_plans        enable row level security;

create policy "own" on profiles          for all using (auth.uid() = id)         with check (auth.uid() = id);
create policy "own" on household_members for all using (auth.uid() = user_id)    with check (auth.uid() = user_id);
create policy "own" on pantry_items      for all using (auth.uid() = user_id)    with check (auth.uid() = user_id);
create policy "own" on shopping_items    for all using (auth.uid() = user_id)    with check (auth.uid() = user_id);
create policy "own" on meal_plans        for all using (auth.uid() = user_id)    with check (auth.uid() = user_id);

-- Auto-create profile row on signup
create or replace function handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, household_name)
  values (new.id, 'My Kitchen');
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- Performance indexes
create index if not exists idx_hm_user   on household_members(user_id);
create index if not exists idx_pi_user   on pantry_items(user_id);
create index if not exists idx_pi_exp    on pantry_items(exp);
create index if not exists idx_si_user   on shopping_items(user_id);
create index if not exists idx_mp_user   on meal_plans(user_id);
