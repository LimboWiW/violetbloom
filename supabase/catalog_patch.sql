-- Violet Bloom — обновление каталога
-- Нормальные фотографии букетов + русские названия.
-- Выполнить один раз после создания таблиц.

UPDATE public.bouquets
SET name = CASE lower(trim(name))
    WHEN 'violet signal' THEN 'Фиолетовый сигнал'
    WHEN 'soft focus' THEN 'Мягкий фокус'
    WHEN 'green room' THEN 'Зелёная комната'
    ELSE name
END
WHERE lower(trim(name)) IN ('violet signal', 'soft focus', 'green room');

WITH images AS (
    SELECT * FROM (VALUES
        (1, 'https://images.unsplash.com/photo-1549048799-482af26246f3?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (2, 'https://images.unsplash.com/photo-1772411535489-17a31842d152?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (3, 'https://images.unsplash.com/photo-1570118281125-84ec73b8008a?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (4, 'https://images.unsplash.com/photo-1550610261-f693c1ad0fe2?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (5, 'https://images.unsplash.com/photo-1539221633233-8d541016a8ce?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (6, 'https://images.unsplash.com/photo-1657725157904-d555dd29f84b?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (7, 'https://images.unsplash.com/photo-1748085901522-9a5d42d11039?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (8, 'https://images.unsplash.com/photo-1620740167802-2519857467b4?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (9, 'https://images.unsplash.com/photo-1680616565644-efeda5f3a9f6?auto=format&fit=crop&fm=jpg&q=85&w=1200'),
        (10, 'https://images.unsplash.com/photo-1726828953407-de293a320ed1?auto=format&fit=crop&fm=jpg&q=85&w=1200')
    ) AS t(n, image_url)
), ranked AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY created_at, id) AS n
    FROM public.bouquets
)
UPDATE public.bouquets b
SET image_url = images.image_url,
    updated_at = NOW()
FROM ranked
JOIN images ON images.n = ranked.n
WHERE b.id = ranked.id;

NOTIFY pgrst, 'reload schema';

SELECT name, price, category, image_url
FROM public.bouquets
ORDER BY created_at, id;
