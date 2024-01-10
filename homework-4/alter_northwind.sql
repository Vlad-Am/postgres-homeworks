-- Подключиться к БД Northwind и сделать следующие изменения:
-- 1. Добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)
ALTER TABLE products ADD CONSTRAINT chk_price_unit_price CHECK (unit_price > 0)

-- 2. Добавить ограничение, что поле discontinued таблицы products может содержать только значения 0 или 1
ALTER TABLE products ADD CONSTRAINT chk_discontinued_discontinued CHECK (discontinued IN  (1, 0))

-- 3. Создать новую таблицу, содержащую все продукты, снятые с продажи (discontinued = 1)
SELECT *
INTO zero_product
FROM products
WHERE discontinued = 1

-- 4. Удалить из products товары, снятые с продажи (discontinued = 1)
-- Для 4-го пункта может потребоваться удаление ограничения, связанного с foreign_key. Подумайте, как это можно решить, чтобы связь с таблицей order_details все же осталась.
-- Сначала удаляем ограничение:
ALTER TABLE order_details
DROP CONSTRAINT fk_orderdetails_products;

-- Удаляем продукты, снятые с продажи:
DELETE FROM products
WHERE discontinued = 1;

-- Удаляем заказы из order_details для сохранения единения этой таблицы с таблицей products
DELETE *
FROM order_details
WHERE EXISTS (SELECT * FROM products WHERE discontinued = 1)
-- Возвращаем ограничение:
ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_products FOREIGN KEY (product_id)
REFERENCES products(product_id);

