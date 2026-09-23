# Настройка Supabase

1. Выполните `schema.sql` в SQL Editor.
2. В Authentication -> Users создайте администратора:
   - admin@violet-bloom.local
   - VioletAdmin_2026!
3. Выполните `admin.sql`.
4. Скопируйте Project URL и anon/publishable key из Settings -> API.
5. В `index.html` замените значения в `CONFIG`.

Storage bucket `bouquets` создаётся SQL-скриптом как public. Для реальных загрузок файлов можно добавить отдельную админскую форму загрузки в Storage; текущая админка поддерживает URL изображения и локальные fallback-изображения.
