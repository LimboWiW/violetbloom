-- Violet Bloom: личный кабинет + привязка заказов к пользователю
-- Выполнить один раз в Supabase SQL Editor.

ALTER TABLE public.orders
ADD COLUMN IF NOT EXISTS user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON public.orders(user_id);

ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "users read own orders" ON public.orders;
DROP POLICY IF EXISTS "users create own orders" ON public.orders;
DROP POLICY IF EXISTS "users read own order items" ON public.order_items;

CREATE POLICY "users read own orders"
ON public.orders
FOR SELECT
TO authenticated
USING (user_id = auth.uid() OR public.is_admin());

CREATE POLICY "users create own orders"
ON public.orders
FOR INSERT
TO anon, authenticated
WITH CHECK (user_id IS NULL OR user_id = auth.uid() OR public.is_admin());

CREATE POLICY "users read own order items"
ON public.order_items
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1
        FROM public.orders o
        WHERE o.id = order_items.order_id
          AND (o.user_id = auth.uid() OR public.is_admin())
    )
);

-- Для оформления заказа состав заказа может добавлять авторизованный или гость.
-- Существующую политику вставки оставляем совместимой.

NOTIFY pgrst, 'reload schema';
