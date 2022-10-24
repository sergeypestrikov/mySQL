DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	firstname VARCHAR(100),
	lastname VARCHAR(100) COMMENT 'Фамилия',
	email VARCHAR(120) UNIQUE,
	password_hash VARCHAR(100),
	phone BIGINT UNSIGNED UNIQUE,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE NOW(),
	is_deleted bit default 0,
	INDEX users_lastname_firstname_idx(lastname, firstname)
) COMMENT = 'Покупатели';


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles`(
	user_id SERIAL PRIMARY KEY,
	gender CHAR(1),
	birthday DATE,
	photo_id BIGINT UNSIGNED,
	created_at DATETIME DEFAULT NOW()
);


ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;


DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL, -- отправитель
	to_user_id BIGINT UNSIGNED NOT NULL, -- получатель
	body TEXT,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (from_user_id) REFERENCES users(id),
	FOREIGN KEY (to_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL PRIMARY KEY,
	initiator_user_id BIGINT UNSIGNED NOT NULL,
	target_user_id BIGINT UNSIGNED NOT NULL,
	`status` ENUM('requested', 'approved', 'declined', 'unfriended'),
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE NOW(), -- CURRENT TIMESTAMP
	PRIMARY KEY (initiator_user_id, target_user_id),
	FOREIGN KEY (initiator_user_id) REFERENCES users(id),
	FOREIGN KEY (target_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	INDEX communities_name_idx(name)
);


DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (user_id, community_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (community_id) REFERENCES communities(id)
	);


DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255)
);


DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	media_type_id BIGINT UNSIGNED,
	body TEXT,
	-- filename BLOB,
	filename VARCHAR(255),
	`size` INT,
	metadata JSON,
	created_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE SET NULL
);


DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED NOT NULL,
media_id BIGINT UNSIGNED NOT NULL,
created_at DATETIME DEfAULT NOW(),
FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums`(
	`id` SERIAL,
	`name` VARCHAR(255) DEFAULT NULL,
	`user_id` BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
	PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos`(
	id SERIAL PRIMARY KEY,
	`album_id` BIGINT UNSIGNED NOT NULL,
	`media_id` BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
	FOREIGN KEY (media_id) REFERENCES media(id)
);

-- ДОМАШНЕЕ ЗАДАНИЕ

-- МУЗЫКА

DROP TABLE IF EXISTS play_list;
CREATE TABLE `play_list`( -- создание плейлиста
	id SERIAL,
	name VARCHAR(250) DEFAULT NULL, -- название файла
	user_id BIGINT UNSIGNED DEFAULT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id), -- ссылка на таблицу пользователя
	PRIMARY KEY (id), -- первичный ключ
	INDEX music_name_idx(name) -- поиск по индексу
);


DROP TABLE IF EXISTS music;
CREATE TABLE music( -- создание музыкальной коллекции
	id SERIAL PRIMARY KEY,
	track_id BIGINT UNSIGNED NOT NULL, 
	media_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (track_id) REFERENCES `play_list`(id), -- ссылка на плейлист
	FOREIGN KEY (media_id) REFERENCES media(id) -- ссылка на папку медиа
);


-- ИГРЫ

DROP TABLE IF EXISTS `game_zone`;
CREATE TABLE `game_zone`( -- общая база игр
	id SERIAL PRIMARY KEY, -- первичный ключ
	name VARCHAR(250), -- название игры
	INDEX game_name_idx(name) -- поиск
);


DROP TABLE IF EXISTS users_games;
CREATE TABLE users_games( -- игры пользователя
	user_id BIGINT UNSIGNED NOT NULL,
	game_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (user_id, game_id), -- первичный ключ
	FOREIGN KEY (user_id) REFERENCES users(id), 
	FOREIGN KEY (game_id) REFERENCES `game_zone`(id)
	);
	
-- СТАТУСЫ

DROP TABLE IF EXISTS `user_status`;
CREATE TABLE `user_status`( -- создание статуса пользователя
	user_id SERIAL PRIMARY KEY,
	actual_status VARCHAR(20),
	FOREIGN KEY (user_id) REFERENCES users(id) -- связь с пользователем
);