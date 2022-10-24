USE eshop;


-- ХРАНИМЫЕ ПРОЦЕДУРЫ

-- Выборка товаров с одинаковым описанием

DROP PROCEDURE IF EXISTS sp_product_offer;
DELIMITER //
CREATE PROCEDURE sp_product_offer(name VARCHAR(100))
BEGIN
	SELECT s2.product_id
	FROM storage s1
	JOIN storage s2 ON s1.description = s2.description
	WHERE s1.product_id = name AND s2.product_id <> name;
END//
DELIMITER ;

CALL sp_product_offer(30);


-- ПРЕДСТАВЛЕНИЯ

-- Представление, которое выводит фамилию пользователя из таблицы users 
-- и номер заказа из таблицы orders


CREATE OR REPLACE VIEW v_user(user_id, user_lastname, o_id) AS
SELECT u.id, u.lastname, o.id
FROM users AS u
JOIN orders AS o
ON u.id = o.id;

SELECT * FROM v_user;

-- ТРИГГЕРЫ

-- Подмена даты рождения при некорректном вводе
CREATE DEFINER=`root`@`localhost` TRIGGER `check_birthday_date` BEFORE INSERT ON `users` FOR EACH ROW BEGIN 
	IF NEW.birthday > CURRENT_DATE() THEN
		SET NEW.birthday = CURRENT_DATE();
	END IF;
	
END

-- Проверка при обновлении даты рождения
CREATE DEFINER=`root`@`localhost` TRIGGER `updating_age` BEFORE UPDATE ON `users` FOR EACH ROW BEGIN 
	IF NEW.birthday > CURRENT_DATE() THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Сработал триггер! Обновление отменено по причине некорректного ввода данных';
	END IF;
END