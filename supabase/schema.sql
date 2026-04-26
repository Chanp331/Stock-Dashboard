-- SignalCircle schema for Supabase (PostgreSQL)
-- Execute in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  handle text unique,
  bio text,
  avatar_path text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.circles (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique,
  owner_id uuid not null references public.profiles(id) on delete cascade,
  invite_code text unique,
  created_at timestamptz not null default now()
);

create table if not exists public.circle_members (
  circle_id uuid not null references public.circles(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null default 'member' check (role in ('owner','member')),
  created_at timestamptz not null default now(),
  primary key (circle_id, user_id)
);

create table if not exists public.watchlists (
  id uuid primary key default gen_random_uuid(),
  circle_id uuid not null references public.circles(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  ticker text not null,
  note text,
  signal text not null default 'watch' check (signal in ('buy','hold','sell','watch')),
  created_at timestamptz not null default now(),
  unique(circle_id, user_id, ticker)
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  circle_id uuid not null references public.circles(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  ticker text not null,
  signal text not null check (signal in ('buy','hold','sell')),
  thesis text not null,
  entry_price numeric,
  target_price numeric,
  stop_price numeric,
  created_at timestamptz not null default now()
);

create table if not exists public.likes (
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

create index if not exists idx_circle_members_user on public.circle_members(user_id);
create index if not exists idx_watchlists_circle on public.watchlists(circle_id);
create index if not exists idx_posts_circle_created on public.posts(circle_id, created_at desc);
create index if not exists idx_comments_post_created on public.comments(post_id, created_at desc);

alter table public.profiles enable row level security;
alter table public.circles enable row level security;
alter table public.circle_members enable row level security;
alter table public.watchlists enable row level security;
alter table public.posts enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;

create or replace function public.is_circle_member(_circle uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.circle_members cm
    where cm.circle_id = _circle
      and cm.user_id = auth.uid()
  );
$$;

create policy "profiles self read"
on public.profiles
for select
using (id = auth.uid());

create policy "profiles self write"
on public.profiles
for all
using (id = auth.uid())
with check (id = auth.uid());

create policy "circles members read"
on public.circles
for select
using (public.is_circle_member(id));

create policy "circles owner write"
on public.circles
for all
using (owner_id = auth.uid())
with check (owner_id = auth.uid());

create policy "members in own circles"
on public.circle_members
for select
using (public.is_circle_member(circle_id));

create policy "owner manages members"
on public.circle_members
for insert
with check (exists (
  select 1 from public.circles c where c.id = circle_id and c.owner_id = auth.uid()
));

create policy "watchlists members rw"
on public.watchlists
for all
using (public.is_circle_member(circle_id) and user_id = auth.uid())
with check (public.is_circle_member(circle_id) and user_id = auth.uid());

create policy "posts members rw"
on public.posts
for all
using (public.is_circle_member(circle_id))
with check (public.is_circle_member(circle_id) and user_id = auth.uid());

create policy "likes members rw"
on public.likes
for all
using (exists (
  select 1 from public.posts p where p.id = post_id and public.is_circle_member(p.circle_id)
) and user_id = auth.uid())
with check (exists (
  select 1 from public.posts p where p.id = post_id and public.is_circle_member(p.circle_id)
) and user_id = auth.uid());

create policy "comments members rw"
on public.comments
for all
using (exists (
  select 1 from public.posts p where p.id = post_id and public.is_circle_member(p.circle_id)
))
with check (exists (
  select 1 from public.posts p where p.id = post_id and public.is_circle_member(p.circle_id)
) and user_id = auth.uid());
