USE vk;

-- 1. Пусть задан некоторый пользователь.
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

SELECT from_user_id,
	(SELECT CONCAT(firstname, ' ', lastname) FROM users WHERE id=messages.from_user_id) as name,
	COUNT(*) AS 'Всего отправлено'
	FROM messages
	WHERE to_user_id = 1
	AND from_user_id IN (
	SELECT initiator_user_id FROM friend_requests
	WHERE (target_user_id = 1) AND status='approved'
	UNION
	SELECT target_user_id FROM friend_requests
	WHERE (initiator_user_id = 1) AND status='approved'
	)
	GROUP BY from_user_id
	ORDER BY 'Всего отправлено' DESC;
	
-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.

SELECT COUNT(*) AS 'Всего лайков'
	FROM likes
	WHERE media_id IN (
	SELECT id
	FROM media
	WHERE user_id IN (
		SELECT user_id
		FROM profiles AS p
		WHERE TIMESTAMPDIFF(YEAR,birthday,NOW()) < 11)
	);
	
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT
	gender
	, COUNT(*)
	FROM (
		SELECT user_id AS user,
		(
			SELECT gender
			FROM vk.profiles
			WHERE user_id = user
		) AS gender 
	FROM likes
) AS p
GROUP BY gender;






-- COUNT(*) AS 'likes'
	-- FROM profiles
	-- GROUP BY gender
	-- ORDER BY 'likes' DESC;
