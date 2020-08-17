USE ali;

-- Вставлем в ручную значения для categories_product

INSERT INTO categories_product VALUES 
(NULL, 'Телефоны и аксессуары', NOW(), NOW()),
(NULL, 'Компьютеры и оргтехника', NOW(), NOW()),
(NULL, 'Электроника', NOW(), NOW()),
(NULL, 'Бытовая техника', NOW(), NOW()), 
(NULL, 'Одежда для женщин', NOW(), NOW()),
(NULL, 'Одежда для мужчин', NOW(), NOW()),
(NULL, 'Всё для детей', NOW(), NOW()),
(NULL, 'Бижутерия и часы', NOW(), NOW()),
(NULL, 'Сумки и обувь', NOW(), NOW()),
(NULL, 'Дом и зоотовары', NOW(), NOW()),
(NULL, 'Автотовары', NOW(), NOW()),
(NULL, 'Красота и здоровье', NOW(), NOW()),
(NULL, 'Спорт и развлечения', NOW(), NOW());


-- После заполнения таблиц из ДАМПА, заполним таблицу статистики:
INSERT INTO statistic_all VALUES (NULL, 
(SELECT COUNT(id) FROM users), (SELECT COUNT(id) FROM sallers), (SELECT COUNT(id) FROM categories_product), (SELECT COUNT(id) FROM orders), (SELECT COUNT(id) FROM products));

-- Выравниваем везде даты чтобы update было >= created
UPDATE users SET update_at = created_at WHERE created_at > update_at;
UPDATE sallers SET update_at = created_at WHERE created_at > update_at;
UPDATE products SET update_at = created_at WHERE created_at > update_at;
UPDATE feedback SET update_at = created_at WHERE created_at > update_at;
UPDATE media SET update_at = created_at WHERE created_at > update_at;

-- Поправляем ссылки в media:
UPDATE media SET link = CONCAT('https://aliexpress.com/', link); 

-- (Не сделал изначально) Создаём столбец даты доставки товара до покупателя, фактического, когда заказ получил покупатеель. 
ALTER TABLE deliveries ADD COLUMN order_delivery_at DATE;
 
		-- Заполняем его случайными датами начиная со дня планируемой даты отправки + 1-30 дней.
		UPDATE deliveries d
			SET order_delivery_at = DATE_ADD(sent_plan_delivery, INTERVAL FLOOR(1 + RAND() * 29) DAY) 
			WHERE d.delivered_status = 'Delivered';



		SELECT * FROM deliveries d LIMIT 10;

-- т.к. мы решили что срок отправки 7 дней с момента совершения заказа, в доставке нужно изменить данные. 
-- Так же изменить дату планируемой максимальной доставки на 40 дней с момента отправки.

SELECT 
	o.id, 
	o.created_at,
	d.sent_plan_delivery,
	d.receipt_plan_delivery
FROM orders AS o
JOIN deliveries AS d 
	ON d.order_id = o.id 
LIMIT 5;

UPDATE deliveries 
	SET sent_plan_delivery = DATE_ADD((SELECT created_at FROM orders WHERE deliveries.order_id = orders.id LIMIT 1), INTERVAL 7 DAY);

-- Так же изменить дату планируемой максимальной доставки на 40 дней с момента отправки.
UPDATE deliveries 
	SET receipt_plan_delivery = DATE_ADD(sent_plan_delivery, INTERVAL 40 DAY);


-- Ошибки в названиях столбцов.
ALTER TABLE messages CHANGE COLUMN category_message_id category_message ENUM('user-saller','saller-user') NOT NULL;
ALTER TABLE orders CHANGE COLUMN sailers_id saller_id INT UNSIGNED;


-- Создаём внешние ключи
   
SHOW TABLES;

SELECT * from categories_product LIMIT 10;
SELECT * FROM deliveries LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM sallers LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM followers LIMIT 10;
SELECT * FROM feedback LIMIT 10;
SELECT * FROM media LIMIT 10;
SELECT * FROM messages LIMIT 10;
SELECT * FROM users LIMIT 10;

-- Изменяем структуру, т.к. не учёл этот момент при создании. Убираем NOT NULL.
ALTER TABLE deliveries MODIFY COLUMN order_id INT UNSIGNED;
ALTER TABLE deliveries
	ADD CONSTRAINT delivery_order_id_fk
	FOREIGN KEY (order_id) REFERENCES orders(id)
		ON DELETE RESTRICT;


ALTER TABLE orders MODIFY COLUMN buyer_id INT UNSIGNED;
ALTER TABLE orders MODIFY COLUMN product_id INT UNSIGNED;
ALTER TABLE orders MODIFY COLUMN saller_id INT UNSIGNED;
ALTER TABLE orders 
	ADD CONSTRAINT orders_buyer_id_fk
	FOREIGN KEY (buyer_id) REFERENCES users(id)
		ON DELETE RESTRICT,
	ADD CONSTRAINT orders_saller_id_fk
	FOREIGN KEY (saller_id) REFERENCES sallers(id)
		ON DELETE RESTRICT,
	ADD CONSTRAINT orders_product_id_fk
	FOREIGN KEY (product_id) REFERENCES products(id)
		ON DELETE RESTRICT;

ALTER TABLE followers MODIFY COLUMN saller_id INT UNSIGNED;
ALTER TABLE followers MODIFY COLUMN user_id INT UNSIGNED;
ALTER TABLE followers 
	ADD CONSTRAINT followers_user_id_fk
	FOREIGN KEY (user_id) REFERENCES users(id)
		ON DELETE RESTRICT,
	ADD CONSTRAINT followers_saller_id_fk
	FOREIGN KEY (saller_id) REFERENCES sallers(id)
		ON DELETE RESTRICT;
		
ALTER TABLE followers MODIFY COLUMN saller_id INT UNSIGNED;
ALTER TABLE followers MODIFY COLUMN user_id INT UNSIGNED;
ALTER TABLE followers 
	ADD CONSTRAINT followers_user_id_fk
	FOREIGN KEY (user_id) REFERENCES users(id)
		ON DELETE RESTRICT,
	ADD CONSTRAINT followers_saller_id_fk
	FOREIGN KEY (saller_id) REFERENCES sallers(id)
		ON DELETE RESTRICT;
		

ALTER TABLE products MODIFY COLUMN category_product_id INT UNSIGNED;
ALTER TABLE products MODIFY COLUMN media_id INT UNSIGNED;
ALTER TABLE products 
	ADD CONSTRAINT products_category_product_id_fk
	FOREIGN KEY (category_product_id) REFERENCES categories_product(id)
		ON DELETE RESTRICT,
	ADD CONSTRAINT products_media_id_fk
	FOREIGN KEY (media_id) REFERENCES media(id)
		ON DELETE RESTRICT;

-- Создаём только для  media_id, т.к. to_id и from_id могут быть из разных таблиц, в зависимости от category_message
ALTER TABLE feedback MODIFY COLUMN media_id INT UNSIGNED;
ALTER TABLE feedback 
	ADD CONSTRAINT feedback_media_id_fk
	FOREIGN KEY (media_id) REFERENCES media(id)
		ON DELETE RESTRICT;
		
	
-- Таблицу messages ни с чем не связываем, так как to_message и from_message зависят от значения category_messages, от этого to_message и from_message может быть как продавцом так и покупателем.
	
	
	
	