-- Aba "Agenda": compromissos e demandas de cada pessoa
-- Rode uma vez no Supabase: SQL Editor > New query > cole tudo > Run
-- Cada pessoa só enxerga a própria agenda (nem o administrador vê a dos outros).

create table if not exists public.agenda (
  id uuid primary key default gen_random_uuid(),
  owner uuid not null default auth.uid() references auth.users(id) on delete cascade,
  title text not null,
  kind text not null default 'compromisso' check (kind in ('compromisso','demanda')),
  date date,
  start_time time,
  end_time time,
  all_day boolean not null default false,
  alert_min integer,
  priority text not null default 'media' check (priority in ('baixa','media','alta')),
  status text not null default 'todo' check (status in ('todo','doing','done')),
  note text,
  created_at timestamptz not null default now()
);

create index if not exists agenda_owner_date on public.agenda (owner, date);

alter table public.agenda enable row level security;

drop policy if exists "agenda_own" on public.agenda;
create policy "agenda_own" on public.agenda for all to authenticated
  using (owner = auth.uid())
  with check (owner = auth.uid());

do $$ begin
  alter publication supabase_realtime add table public.agenda;
exception when others then null;
end $$;
