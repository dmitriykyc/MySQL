

-- ѕроцедуры

-- ѕроцедура дл€ вывода самого дорогого товара в заданной пользователем каттегории
DROP PROCEDURE IF EXISTS test;
CREATE PROCEDURE test (name_category VARCHAR(70))
BEGIN
	SET @x = name_category; 
	IF(@x IN (SELECT name FROM categories_product)) THEN
		SET @price = (SELECT price FROM products WHERE category_product_id = (SELECT id FROM categories_product cp WHERE cp.name = @x) ORDER BY price DESC LIMIT 1);
		SET @name = (SELECT name FROM products WHERE category_product_id = (SELECT id FROM categories_product cp WHERE cp.name = @x) ORDER BY price DESC LIMIT 1);
		SELECT CONCAT('¬ категории ', @x, ' самый дорогой товар ', @name, ' cтоимостью: ', @price);
	ELSE
		SELECT '“акой категории не существует';
	END IF;
END

CALL test('јвтотовары');
CALL test('јвтотовары111');

-- ѕроцедура дл€ добавлени€ товара, с обработкой ошибки при указании неправильного значени€:
DROP PROCEDURE IF EXISTS insert_to_products;
CREATE PROCEDURE insert_to_products (IN id INT, IN name VARCHAR(100), IN price INT, IN description TEXT, IN category_product_id INT, IN media_id INT)
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SELECT 'ќшибка вставки значений';
  INSERT INTO products VALUES(id, name, price, description, category_product_id, media_id, NOW(), NOW());
END

CALL insert_to_products (1000, 'Sneakers', 1000, 'My shoes', 1, 22);
CALL insert_to_products (1001, 'Sneakers', 1000, 'My shoes', 1, 22);

SELECT * FROM products p  ORDER BY id DESC LIMIT 2;

-- “ригер на добавление товара, при создании заказа, он заполн€ет таблицу deliveries (информаци€ о доставке заказа), 
-- заносит планируемый срок отправки,
--  планируемую дату доставки, 
-- ID пользовател€ и покупател€:

SELECT * FROM orders ORDER BY id DESC LIMIT 10 ;
SELECT * FROM deliveries d ORDER BY id DESC LIMIT 10;

DROP TRIGGER IF EXISTS insert_delivery;
CREATE TRIGGER insert_delivery AFTER INSERT ON orders
FOR EACH ROW
BEGIN 
	INSERT INTO deliveries (order_id, pay_inform, delivered_status, sent_plan_delivery, receipt_plan_delivery)
	VALUES (NEW.id, 0, 'Waiting to sent', DATE_ADD(NEW.created_at, INTERVAL 7 DAY), DATE_ADD(NEW.created_at, INTERVAL 40 DAY));
END

INSERT INTO orders (buyer_id, saller_id, product_id) VALUES (125, 77, 333); 

-- “ригер который добавл€ет в таблицу статистики каждого нового пользовател€.


DROP TRIGGER IF EXISTS count_user_stat;
CREATE TRIGGER count_user_stat AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET users_stat = users_stat + 1;
END

INSERT INTO users VALUES (NULL, 'Dmitriy', 'Kusov', 'adresssss', 'Russia', NOW(), NOW());



-- “ригер который добавл€ет в таблицу статистики каждый новый заказ
DROP TRIGGER IF EXISTS count_orders_stat;
CREATE TRIGGER count_orders_stat AFTER INSERT ON orders
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET orders_stat = orders_stat + 1;
END

-- “ригер который добавл€ет в таблицу статистики каждый новый товар
DROP TRIGGER IF EXISTS count_products_stat;
CREATE TRIGGER count_products_stat AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET products_stat = products_stat + 1;
END

-- “ригер который добавл€ет в таблицу статистики каждую категорию
DROP TRIGGER IF EXISTS count_categories_stat;
CREATE TRIGGER count_categories_stat AFTER INSERT ON categories_product
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET categories_stat = categories_stat + 1;
END

-- “ригер который добавл€ет в таблицу статистики каждый новый магазин
DROP TRIGGER IF EXISTS count_sellers_stat;
CREATE TRIGGER count_sellers_stat AFTER INSERT ON sallers
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET sellers_stat = sellers_stat + 1;
END
