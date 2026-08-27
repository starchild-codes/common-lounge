create extension if not exists pgcrypto;

create table if not exists public.lounge_tea_posts (
  id uuid primary key default gen_random_uuid(),
  room_code text not null,
  author_id text not null,
  author_name text not null,
  body text not null check (char_length(body) between 1 and 500),
  created_at timestamptz not null default now()
);

create table if not exists public.lounge_tea_likes (
  post_id uuid not null references public.lounge_tea_posts(id) on delete cascade,
  user_id text not null,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

create table if not exists public.lounge_tea_replies (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.lounge_tea_posts(id) on delete cascade,
  room_code text not null,
  author_id text not null,
  author_name text not null,
  body text not null check (char_length(body) between 1 and 300),
  created_at timestamptz not null default now()
);

create table if not exists public.lounge_photos (
  id uuid primary key default gen_random_uuid(),
  room_code text not null,
  session_id uuid not null unique,
  image_url text not null,
  prompt text not null,
  effect text not null,
  participants text[] not null default '{}',
  created_at timestamptz not null default now()
);

create index if not exists lounge_tea_posts_room_created_idx on public.lounge_tea_posts(room_code, created_at desc);
create index if not exists lounge_tea_replies_post_idx on public.lounge_tea_replies(post_id, created_at);
create index if not exists lounge_photos_room_created_idx on public.lounge_photos(room_code, created_at desc);

alter table public.lounge_tea_posts enable row level security;
alter table public.lounge_tea_likes enable row level security;
alter table public.lounge_tea_replies enable row level security;
alter table public.lounge_photos enable row level security;

drop policy if exists "lounge tea read" on public.lounge_tea_posts;
drop policy if exists "lounge tea create" on public.lounge_tea_posts;
drop policy if exists "lounge likes read" on public.lounge_tea_likes;
drop policy if exists "lounge likes create" on public.lounge_tea_likes;
drop policy if exists "lounge likes remove" on public.lounge_tea_likes;
drop policy if exists "lounge replies read" on public.lounge_tea_replies;
drop policy if exists "lounge replies create" on public.lounge_tea_replies;
drop policy if exists "lounge photos read" on public.lounge_photos;
drop policy if exists "lounge photos create" on public.lounge_photos;

create policy "lounge tea read" on public.lounge_tea_posts for select to anon, authenticated using (true);
create policy "lounge tea create" on public.lounge_tea_posts for insert to anon, authenticated with check (true);
create policy "lounge likes read" on public.lounge_tea_likes for select to anon, authenticated using (true);
create policy "lounge likes create" on public.lounge_tea_likes for insert to anon, authenticated with check (true);
create policy "lounge likes remove" on public.lounge_tea_likes for delete to anon, authenticated using (true);
create policy "lounge replies read" on public.lounge_tea_replies for select to anon, authenticated using (true);
create policy "lounge replies create" on public.lounge_tea_replies for insert to anon, authenticated with check (true);
create policy "lounge photos read" on public.lounge_photos for select to anon, authenticated using (true);
create policy "lounge photos create" on public.lounge_photos for insert to anon, authenticated with check (true);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('lounge-photos', 'lounge-photos', true, 5242880, array['image/jpeg','image/png'])
on conflict (id) do update set public=true, file_size_limit=5242880, allowed_mime_types=array['image/jpeg','image/png'];

drop policy if exists "lounge photo objects read" on storage.objects;
drop policy if exists "lounge photo objects create" on storage.objects;
drop policy if exists "lounge photo objects update" on storage.objects;
create policy "lounge photo objects read" on storage.objects for select to anon, authenticated using (bucket_id='lounge-photos');
create policy "lounge photo objects create" on storage.objects for insert to anon, authenticated with check (bucket_id='lounge-photos');
create policy "lounge photo objects update" on storage.objects for update to anon, authenticated using (bucket_id='lounge-photos') with check (bucket_id='lounge-photos');

do $$ begin
  alter publication supabase_realtime add table public.lounge_tea_posts;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.lounge_tea_likes;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.lounge_tea_replies;
exception when duplicate_object then null; end $$;
do $$ begin
  alter publication supabase_realtime add table public.lounge_photos;
exception when duplicate_object then null; end $$;
