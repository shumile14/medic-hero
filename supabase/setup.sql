-- Medic Hero backend. Safe to run more than once.
create table if not exists public.admins (email text primary key);
insert into public.admins values ('officialmedichero@gmail.com') on conflict do nothing;
alter table public.admins enable row level security;

create or replace function public.is_admin() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where email = (auth.jwt() ->> 'email'));
$$;

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  slug text unique not null,
  genre text not null default 'episode',
  ep int,
  title text not null,
  blurb text not null default '',
  mins int not null default 3,
  date date not null default current_date,
  cover_url text,
  body text not null default '',
  credits jsonb not null default '{}',
  extras jsonb not null default '{}',
  published boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  blurb text not null default '',
  price text not null default '',
  buy_url text,
  file_url text,
  genre text not null default 'medicine',
  sort int not null default 0,
  published boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.views (
  id bigint generated always as identity primary key,
  path text not null,
  created_at timestamptz not null default now()
);
create table if not exists public.subscribers (
  email text primary key,
  created_at timestamptz not null default now()
);

alter table public.posts enable row level security;
alter table public.books enable row level security;
alter table public.views enable row level security;
alter table public.subscribers enable row level security;

drop policy if exists "read posts" on public.posts;
create policy "read posts" on public.posts for select using (published or public.is_admin());
drop policy if exists "admin posts" on public.posts;
create policy "admin posts" on public.posts for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "read books" on public.books;
create policy "read books" on public.books for select using (published or public.is_admin());
drop policy if exists "admin books" on public.books;
create policy "admin books" on public.books for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "log view" on public.views;
create policy "log view" on public.views for insert to anon, authenticated with check (char_length(path) < 80);
drop policy if exists "admin reads views" on public.views;
create policy "admin reads views" on public.views for select to authenticated using (public.is_admin());

drop policy if exists "join list" on public.subscribers;
create policy "join list" on public.subscribers for insert to anon, authenticated
  with check (char_length(email) < 200 and email ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$');
drop policy if exists "admin reads list" on public.subscribers;
create policy "admin reads list" on public.subscribers for select to authenticated using (public.is_admin());
drop policy if exists "admin edits list" on public.subscribers;
create policy "admin edits list" on public.subscribers for delete to authenticated using (public.is_admin());

create or replace function public.views_by_day(days int default 30) returns table(day date, n bigint)
language sql stable as $$
  select (created_at at time zone 'Europe/London')::date, count(*) from public.views
  where created_at > now() - make_interval(days => days) group by 1 order by 1;
$$;
create or replace function public.views_by_path(days int default 30) returns table(path text, n bigint)
language sql stable as $$
  select v.path, count(*) from public.views v
  where v.created_at > now() - make_interval(days => days) group by 1 order by 2 desc limit 15;
$$;

grant usage on schema public to anon, authenticated;
grant select on public.posts, public.books to anon, authenticated;
grant insert, update, delete on public.posts, public.books to authenticated;
grant insert on public.views, public.subscribers to anon, authenticated;
grant select on public.views to authenticated;
grant select, delete on public.subscribers to authenticated;
grant execute on function public.is_admin(), public.views_by_day(int), public.views_by_path(int) to anon, authenticated;

insert into storage.buckets (id, name, public) values ('media', 'media', true) on conflict (id) do nothing;
drop policy if exists "media read" on storage.objects;
create policy "media read" on storage.objects for select using (bucket_id = 'media');
drop policy if exists "media add" on storage.objects;
create policy "media add" on storage.objects for insert to authenticated with check (bucket_id = 'media' and public.is_admin());
drop policy if exists "media change" on storage.objects;
create policy "media change" on storage.objects for update to authenticated using (bucket_id = 'media' and public.is_admin());
drop policy if exists "media remove" on storage.objects;
create policy "media remove" on storage.objects for delete to authenticated using (bucket_id = 'media' and public.is_admin());
