# Подключение Supabase

Проект уже настроен на следующие публичные переменные:

```env
VITE_SUPABASE_URL=https://rquwkqcodjemwmlfrbjj.supabase.co
VITE_SUPABASE_ANON_KEY=<публичный anon key из настроек проекта>
```

В рабочем WebDev-проекте эти переменные уже сохранены. Для переноса на Vercel откройте:

**Vercel → Project → Settings → Environment Variables**

Добавьте:

- `VITE_SUPABASE_URL` = `https://rquwkqcodjemwmlfrbjj.supabase.co`
- `VITE_SUPABASE_ANON_KEY` = ваш публичный anon key из Supabase → Project Settings → API

Выберите окружения **Production**, **Preview** и **Development**, затем сделайте новый Deploy.

В исходниках клиент создаётся в `client/src/lib/supabase.ts`. Используется только публичный anon key. `service_role` key не нужен и не должен добавляться в браузер, GitHub или Vercel-переменные с префиксом `VITE_`.

Перед первым запуском выполните `supabase/schema.sql` в Supabase SQL Editor. Затем создайте пользователя через Supabase Auth и назначьте ему роль `admin` командой из `supabase/SETUP.md`.
