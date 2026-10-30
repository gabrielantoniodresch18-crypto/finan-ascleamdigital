-- Aba "Clientes": cobranças mensais pelo WhatsApp
-- Rode uma vez no Supabase: SQL Editor > New query > cole tudo > Run

-- Dia do mês em que o cliente paga (1 a 31; em meses mais curtos vale o último dia)
alter table public.clients add column if not exists due_day smallint
  check (due_day between 1 and 31);

-- Meses já pagos, no formato AAAA-MM (ex.: 2026-11)
alter table public.clients add column if not exists paid_months text[] not null default '{}';
