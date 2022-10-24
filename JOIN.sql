USE eshop;

-- 1. Пользователи, которые осуществили хотя бы один заказ

SELECT
	u.id AS users, u.lastname, u.firstname,
	o.id AS orders 
FROM 
	users AS u
JOIN
	orders AS o 
ON
	u.id = o.id;
	
-- 2. Кто больше сделал заказов: мужчины или женщины

SELECT 
	gender
	, COUNT(*)
FROM orders o
JOIN users u ON o.user_id=u.id
GROUP BY gender;


-- 3. Подсчитать количество заказов, которые сделали покупатели старше 30 лет

SELECT COUNT(*) as 'Всего заказов'
	FROM orders o
	JOIN users u ON u.id=o.id
	WHERE TIMESTAMPDIFF(YEAR,birthday,NOW()) > 30;
	
-- 4. Какое кол-во заказов было сделано из новой коллекции

SELECT
	new_collection
	, COUNT(*)
	FROM products p
	JOIN orders_products op ON op.product_id=p.new_collection
	GROUP BY op.product_id;