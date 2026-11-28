create table public.drift_admins(uid uuid primary key references auth.users(id));
alter table public.drift_admins enable row level security;
create policy own_admin on public.drift_admins for select to authenticated using(uid=auth.uid());
create table public.drift_event(id integer primary key check(id=1), location text not null default '', event_time text not null default '');
insert into public.drift_event(id) values(1);
alter table public.drift_event enable row level security;
create policy admin_event on public.drift_event for all to authenticated using(exists(select 1 from public.drift_admins where uid=auth.uid())) with check(exists(select 1 from public.drift_admins where uid=auth.uid()));
create table public.drift_requests(id uuid primary key default gen_random_uuid(), created_at timestamptz not null default now(), name text not null check(length(name) between 1 and 100), phone text not null check(phone ~ '^\+?[0-9 ]{9,16}$'), instagram text not null check(length(instagram) between 1 and 100), car text not null check(length(car) between 1 and 100), plate text not null check(length(plate) between 1 and 15), photo text not null check(length(photo) between 30 and 4100000 and photo ~ '^data:image/(jpeg|png|webp);base64,'), state text not null default 'pending' check(state in ('pending','approved','rejected')));
alter table public.drift_requests enable row level security;
revoke all on public.drift_requests from anon, authenticated;
grant insert(name,phone,instagram,car,plate,photo) on public.drift_requests to anon,authenticated;
grant select on public.drift_requests to authenticated;
create policy submit_request on public.drift_requests for insert to anon,authenticated with check(state='pending');
create policy admin_read on public.drift_requests for select to authenticated using(exists(select 1 from public.drift_admins where uid=auth.uid()));
create function public.drift_decide(rid uuid,decision text) returns void language plpgsql security definer set search_path='' as $$
begin
if not exists(select 1 from public.drift_admins where uid=auth.uid()) then raise exception 'Přístup odepřen'; end if;
if decision not in ('approved','rejected') then raise exception 'Neplatný stav'; end if;
perform pg_catalog.pg_advisory_xact_lock(505050);
if decision='approved' and (select count(*) from public.drift_requests where state='approved' and id<>rid)>=50 then raise exception 'Kapacita 50 vozidel naplněna'; end if;
update public.drift_requests set state=decision where id=rid;
end $$;
revoke all on function public.drift_decide(uuid,text) from public,anon;
grant execute on function public.drift_decide(uuid,text) to authenticated;
-- Create admin user in Authentication > Users, then run:
-- insert into public.drift_admins(uid) values ('ADMIN_USER_UUID');
-- Create secret-drift/config.json containing {"url":"https://PROJECT.supabase.co","key":"PUBLIC_ANON_OR_PUBLISHABLE_KEY"}.
-- Never use service_role key. Disable public Auth signups. Add rate limiting before public launch.