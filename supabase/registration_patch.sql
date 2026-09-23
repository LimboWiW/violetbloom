-- Violet Bloom — регистрация пользователей и защита ролей
-- Выполнить один раз в Supabase SQL Editor.

-- Автоматически создаём профиль после регистрации в Supabase Auth.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'name', 'Пользователь'),
    'user'
  )
  on conflict (id) do update
    set email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- Обычный пользователь может менять только свой профиль,
-- но не может самостоятельно назначить себе роль admin.
drop policy if exists "users update own profile" on public.profiles;
create policy "users update own profile"
on public.profiles
for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id and role = 'user');

-- Администратор может менять роли и профили пользователей.
drop policy if exists "admins update profiles" on public.profiles;
create policy "admins update profiles"
on public.profiles
for update
to authenticated
using (public.is_admin())
with check (public.is_admin());
