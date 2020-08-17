-- Cкрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);


-- показать в каком магазине больше всего совершено покупок. Сортировать по количеству заказов. + оценка магазина по оценкам пользователей.
SELECT 
	s.name_shop,
	COUNT(o.id) AS quantity_orders,
	(SELECT AVG(estimation) 
		FROM feedback f 
		WHERE category_message = 'User-Saller' AND s.id = f.from_id 
		GROUP BY from_id) AS reiting_seller
	FROM sallers s 
	JOIN orders o
		ON o.buyer_id = s.id
	GROUP BY s.id
	ORDER BY quantity_orders DESC;

	

-- выборка по продавцам. 
-- показать какой магазин продал больше товаров в каждой каттегории.

SELECT 
	cp.name AS name_category,
	(SELECT saller_id 
	 FROM orders o 
	 	WHERE product_id IN (SELECT id 
	 		FROM products p 
	 			WHERE category_product_id = cp.id) 
	 GROUP BY saller_id 
	 ORDER BY COUNT(saller_id) 
	 DESC LIMIT 1) AS top_buer
FROM categories_product cp
ORDER BY name; 


-- в какие страны и сколько дней в среднем занимает доставка заказа. 
	SELECT 
		country, 
		AVG(TO_DAYS(d.order_delivery_at) - TO_DAYS(o.created_at)) AS len_days
	FROM users u 
	LEFT JOIN orders o
		ON o.buyer_id = u.id
	LEFT JOIN deliveries d 
		ON d.order_id = o.id
	GROUP BY country 
	ORDER BY len_days DESC;


-- Статистика по месяцам в году в которых совершается больше всего заказов. 

	-- создадим временную таблицу с месяцами
	CREATE TEMPORARY TABLE tmp_month (
		name DATE PRIMARY KEY NOT NULL);
	
	INSERT INTO tmp_month VALUES 
		('2020.01.01'), 
		('2020.02.01'), 
		('2020.03.01'), 
		('2020.04.01'), 
		('2020.05.01'), 
		('2020.06.01'), 
		('2020.07.01'), 
		('2020.08.01'), 
		('2020.09.01'), 
		('2020.10.01'), 
		('2020.11.01'), 
		('2020.12.01');

	
	-- И сама выборка.
	SELECT 
		MONTHNAME(name) AS month_name,
		COUNT(o.id) AS orders_month
	FROM tmp_month t
	LEFT JOIN orders o
		ON MONTHNAME(o.created_at) =  MONTHNAME(t.name) 
	GROUP BY month_name
	ORDER BY orders_month DESC;
