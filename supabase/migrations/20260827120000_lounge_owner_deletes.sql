alter table public.lounge_photos add column if not exists author_id text;
alter table public.lounge_photos add column if not exists storage_path text;

drop policy if exists "lounge tea remove" on public.lounge_tea_posts;
drop policy if exists "lounge photos remove" on public.lounge_photos;
drop policy if exists "lounge photo objects remove" on storage.objects;

-- Common Lounge currently uses stable browser identities rather than Supabase Auth.
-- Ownership is enforced in the UI; these policies permit the anonymous client to
-- perform the corresponding delete operation.
create policy "lounge tea remove" on public.lounge_tea_posts
  for delete to anon, authenticated using (true);

create policy "lounge photos remove" on public.lounge_photos
  for delete to anon, authenticated using (true);

create policy "lounge photo objects remove" on storage.objects
  for delete to anon, authenticated using (bucket_id='lounge-photos');
