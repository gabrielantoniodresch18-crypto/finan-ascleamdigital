-- Aba "Postagens": perfis do Instagram dos clientes e registro de stories, feed e reels
-- Rode uma vez no Supabase: SQL Editor > New query > cole tudo > Run
-- Cada pessoa só vê os próprios perfis.

create table if not exists public.ig_profiles (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null default auth.uid() references auth.users(id) on delete cascade,
  client_id uuid references public.clients(id) on delete set null,
  name text,
  handle text not null,
  freq_stories integer not null default 1,
  freq_feed integer not null default 3,
  freq_reels integer not null default 7,
  created_at timestamptz not null default now(),
  unique (owner, handle)
);

create table if not exists public.ig_posts (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null default auth.uid() references auth.users(id) on delete cascade,
  profile_id uuid not null references public.ig_profiles(id) on delete cascade,
  kind text not null check (kind in ('stories','feed','reels')),
  posted_on date not null default current_date,
  created_at timestamptz not null default now()
);

create index if not exists ig_posts_profile on public.ig_posts (profile_id, kind, posted_on desc);

alter table public.ig_profiles enable row level security;
alter table public.ig_posts enable row level security;

drop policy if exists "ig_profiles_own" on public.ig_profiles;
create policy "ig_profiles_own" on public.ig_profiles for all to authenticated
  using (owner = auth.uid()) with check (owner = auth.uid());

drop policy if exists "ig_posts_own" on public.ig_posts;
create policy "ig_posts_own" on public.ig_posts for all to authenticated
  using (owner = auth.uid()) with check (owner = auth.uid());

do $$ begin
  alter publication supabase_realtime add table public.ig_profiles;
exception when others then null;
end $$;
do $$ begin
  alter publication supabase_realtime add table public.ig_posts;
exception when others then null;
end $$;
