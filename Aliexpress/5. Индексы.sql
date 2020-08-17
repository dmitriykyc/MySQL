-- Создание индексов.


-- Будем проверять через EXPLAIN все выборки и за одно создадим нужные индексы.

-- 1.
EXPLAIN SELECT 
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

CREATE INDEX feedbacs_category_message_idx  ON feedback(category_message); 

-- 2.
EXPLAIN SELECT 
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

CREATE INDEX category_product_id_idx ON products(category_product_id);


-- 3.

EXPLAIN SELECT 
		country, 
		AVG(TO_DAYS(d.order_delivery_at) - TO_DAYS(o.created_at)) AS len_days
	FROM users u 
	LEFT JOIN orders o
		ON o.buyer_id = u.id
	LEFT JOIN deliveries d 
		ON d.order_id = o.id
	GROUP BY country 
	ORDER BY len_days DESC;


CREATE INDEX users_country_idx ON users(country);

-- 4.

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
	
EXPLAIN SELECT 
		MONTHNAME(t.name) AS month_name,
		COUNT(o.id) AS orders_month
	FROM tmp_month t
	LEFT JOIN orders o
		ON MONTHNAME(o.created_at) =  MONTHNAME(t.name) 
	GROUP BY month_name
	ORDER BY orders_month DESC;

CREATE INDEX orders_created_at_idx ON orders(created_at);

-- Получаем индексы: 
CREATE INDEX feedbacs_category_message_idx  ON feedback(category_message);
CREATE INDEX category_product_id_idx ON products(category_product_id);
CREATE INDEX users_country_idx ON users(country);
CREATE INDEX orders_created_at_idx ON orders(created_at);


