-- Создайте представление, которое выводит название name товарной позиции из таблицы products
-- и соответствующее название каталога name из таблицы catalogs


use shop;
CREATE OR REPLACE VIEW v_product(prod_id, prod_name, cat_name) AS
SELECT p.id AS prod_id, p.name, cat.name
FROM products AS p
JOIN catalogs AS cat 
ON p.catalog_id = cat.id;

SELECT * FROM v_product;


-- Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу
-- "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи"

DROP PROCEDURE IF EXISTS hello();
CREATE PROCEDURE hello()
BEGIN
	CASE
		WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN
		SELECT "Доброе утро!";
		WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN
		SELECT "Добрый день!";
		WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN
		SELECT "Добрый вечер!";
		ELSE
			SELECT "Доброй ночи!";
	END CASE;
END;


CALL hello();

