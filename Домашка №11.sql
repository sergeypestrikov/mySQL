-- 2. Создайте SQL-запрос, который помещает в таблицу users миллион записей

USE vk;

DROP PROCEDURE IF EXISTS add_users;
delimiter //
CREATE PROCEDURE add_users()
BEGIN
	DECLARE i INT DEFAULT 1000000;
	DECLARE j INT DEFAULT 0;
	WHILE i > 0 DO
		INSERT INTO users(firstname, lastname) VALUES (CONCAT('user_', j), NOW());
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;
END //
delimiter;

-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
-- catalogs и products в таблицу logs помещается время и дата создания записи,
-- название таблицы, идентификатор первичного ключа и содержимое поля name

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(100) NOT NULL,
	str_id BIGINT(50) NOT NULL,
	name_value VARCHAR(100) NOT NULL
) ENGINE=ARCHIVE;