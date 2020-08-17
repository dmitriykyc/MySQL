

-- —оздадим представление по пользовател€м, какой рейтинг у них, какое количество отзывов от магазинов.
DROP VIEW IF EXISTS reiting_users;
CREATE VIEW reiting_users AS 
SELECT 
	(SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = to_id) AS Name, 
	COUNT(to_id) AS sum_feedback,
	TRUNCATE(AVG(estimation), 1) AS estimation 
FROM feedback f 
WHERE category_message = 'Saller-User' 
GROUP BY to_id 
ORDER BY estimation DESC;

SELECT * FROM reiting_users LIMIT 10;

-- ѕредставление по количеству:
-- зарегистрированных пользователей,
-- магазинов,
-- количеству заказов,
-- количество написанных отзывов,
-- «а 2020 год

DROP VIEW IF EXISTS statistic;
CREATE VIEW statistic AS 
SELECT 
	(SELECT COUNT(id) FROM users WHERE created_at > DATE('2020.01.01')) AS users,
	(SELECT COUNT(id) FROM sallers WHERE created_at > DATE('2020.01.01')) AS sellers,
	(SELECT COUNT(id) FROM orders WHERE created_at > DATE('2020.01.01')) AS orders,
	(SELECT COUNT(id) FROM feedback WHERE created_at > DATE('2020.01.01')) AS feedback;

SELECT * FROM statistic;