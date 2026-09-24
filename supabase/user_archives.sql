create table if not exists public.user_archives (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"rooms":[],"bestiary":[],"tags":[]}'::jsonb,
  settings jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.user_archives enable row level security;

drop policy if exists "Users can read own archive" on public.user_archives;
create policy "Users can read own archive"
on public.user_archives for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can insert own archive" on public.user_archives;
create policy "Users can insert own archive"
on public.user_archives for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can update own archive" on public.user_archives;
create policy "Users can update own archive"
on public.user_archives for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
