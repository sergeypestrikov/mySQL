USE vk;

-- 2. Подсчитать общее количество лайков, которые получили пользователи младше 11 лет.

SELECT COUNT(*) as 'Всего лайков'
	FROM media m
	JOIN likes l ON l.media_id=m.id
	JOIN profiles p ON m.user_id=p.user_id
	WHERE TIMESTAMPDIFF(YEAR,birthday,NOW()) < 11;
	
-- 3. Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT 
	gender
	, COUNT(*)
FROM likes l
JOIN profiles p ON l.user_id= p.user_id
GROUP BY gender;