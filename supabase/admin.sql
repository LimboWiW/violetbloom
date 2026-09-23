-- 1) In Supabase Dashboard -> Authentication -> Users create:
-- Email: admin@violet-bloom.local
-- Password: VioletAdmin_2026!
-- For a course project you may disable Confirm email in Authentication settings.
-- 2) Then run this SQL with the created user's UUID:
-- Replace ADMIN_UUID with the actual id shown in Authentication -> Users.

-- update public.profiles set role='admin', name='Администратор'
-- where id='ADMIN_UUID';

-- If you prefer email lookup, run after the user exists:
update public.profiles p
set role='admin', name='Администратор', email=u.email
from auth.users u
where p.id=u.id and u.email='admin@violet-bloom.local';
