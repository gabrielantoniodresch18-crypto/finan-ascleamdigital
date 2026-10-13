-- Aba "Comissões": tabela de planos e produtos
-- Rode uma vez no Supabase: SQL Editor > New query > cole tudo > Run

create table if not exists public.plans (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  kind text not null default 'plano' check (kind in ('plano','produto')),
  recurrence text not null default 'mensal' check (recurrence in ('mensal','unica')),
  price numeric not null default 0,
  cost numeric not null default 0,
  commission_pct numeric not null default 0 check (commission_pct between 0 and 100),
  note text,
  created_at timestamptz not null default now()
);

alter table public.plans enable row level security;

-- Toda a equipe aprovada pode ver
drop policy if exists "plans_select" on public.plans;
create policy "plans_select" on public.plans for select to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.approved));

-- Só administradores criam, editam e excluem
drop policy if exists "plans_admin" on public.plans;
create policy "plans_admin" on public.plans for all to authenticated
  using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'))
  with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin'));

-- Atualização ao vivo no app
do $$ begin
  alter publication supabase_realtime add table public.plans;
exception when others then null;
end $$;
