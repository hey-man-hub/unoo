-- UNO Club: simple shared rooms. The publishable key is intended for browser use.
-- This deliberately uses open room policies for a casual prototype; room state is visible to all visitors.
create table if not exists public.uno_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text not null unique,
  created_at timestamptz not null default now()
);

create table if not exists public.uno_rooms (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null default 'UNO room',
  host_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'waiting' check (status in ('waiting','playing','finished')),
  state jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.uno_profiles enable row level security;
alter table public.uno_rooms enable row level security;
drop policy if exists "Profiles are readable" on public.uno_profiles;
create policy "Profiles are readable" on public.uno_profiles for select to anon, authenticated using (true);
drop policy if exists "Profiles can be created" on public.uno_profiles;
create policy "Profiles can be created" on public.uno_profiles for insert to anon, authenticated with check (true);
drop policy if exists "Profiles can be updated" on public.uno_profiles;
create policy "Profiles can be updated" on public.uno_profiles for update to anon, authenticated using (true) with check (true);
drop policy if exists "Rooms are readable" on public.uno_rooms;
create policy "Rooms are readable" on public.uno_rooms for select to anon, authenticated using (true);
drop policy if exists "Rooms can be created" on public.uno_rooms;
create policy "Rooms can be created" on public.uno_rooms for insert to anon, authenticated with check (true);
drop policy if exists "Rooms can be updated" on public.uno_rooms;
create policy "Rooms can be updated" on public.uno_rooms for update to anon, authenticated using (true) with check (true);

-- Realtime updates are used by everyone in a table. In Supabase, enable Realtime for uno_rooms
-- (Database > Publications > supabase_realtime) if it is not enabled automatically.
