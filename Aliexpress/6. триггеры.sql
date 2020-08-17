

-- ���������

-- ��������� ��� ������ ������ �������� ������ � �������� ������������� ����������
DROP PROCEDURE IF EXISTS test;
CREATE PROCEDURE test (name_category VARCHAR(70))
BEGIN
	SET @x = name_category; 
	IF(@x IN (SELECT name FROM categories_product)) THEN
		SET @price = (SELECT price FROM products WHERE category_product_id = (SELECT id FROM categories_product cp WHERE cp.name = @x) ORDER BY price DESC LIMIT 1);
		SET @name = (SELECT name FROM products WHERE category_product_id = (SELECT id FROM categories_product cp WHERE cp.name = @x) ORDER BY price DESC LIMIT 1);
		SELECT CONCAT('� ��������� ', @x, ' ����� ������� ����� ', @name, ' c���������: ', @price);
	ELSE
		SELECT '����� ��������� �� ����������';
	END IF;
END

CALL test('����������');
CALL test('����������111');

-- ��������� ��� ���������� ������, � ���������� ������ ��� �������� ������������� ��������:
DROP PROCEDURE IF EXISTS insert_to_products;
CREATE PROCEDURE insert_to_products (IN id INT, IN name VARCHAR(100), IN price INT, IN description TEXT, IN category_product_id INT, IN media_id INT)
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SELECT '������ ������� ��������';
  INSERT INTO products VALUES(id, name, price, description, category_product_id, media_id, NOW(), NOW());
END

CALL insert_to_products (1000, 'Sneakers', 1000, 'My shoes', 1, 22);
CALL insert_to_products (1001, 'Sneakers', 1000, 'My shoes', 1, 22);

SELECT * FROM products p  ORDER BY id DESC LIMIT 2;

-- ������ �� ���������� ������, ��� �������� ������, �� ��������� ������� deliveries (���������� � �������� ������), 
-- ������� ����������� ���� ��������,
--  ����������� ���� ��������, 
-- ID ������������ � ����������:

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

-- ������ ������� ��������� � ������� ���������� ������� ������ ������������.


DROP TRIGGER IF EXISTS count_user_stat;
CREATE TRIGGER count_user_stat AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET users_stat = users_stat + 1;
END

INSERT INTO users VALUES (NULL, 'Dmitriy', 'Kusov', 'adresssss', 'Russia', NOW(), NOW());



-- ������ ������� ��������� � ������� ���������� ������ ����� �����
DROP TRIGGER IF EXISTS count_orders_stat;
CREATE TRIGGER count_orders_stat AFTER INSERT ON orders
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET orders_stat = orders_stat + 1;
END

-- ������ ������� ��������� � ������� ���������� ������ ����� �����
DROP TRIGGER IF EXISTS count_products_stat;
CREATE TRIGGER count_products_stat AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET products_stat = products_stat + 1;
END

-- ������ ������� ��������� � ������� ���������� ������ ���������
DROP TRIGGER IF EXISTS count_categories_stat;
CREATE TRIGGER count_categories_stat AFTER INSERT ON categories_product
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET categories_stat = categories_stat + 1;
END

-- ������ ������� ��������� � ������� ���������� ������ ����� �������
DROP TRIGGER IF EXISTS count_sellers_stat;
CREATE TRIGGER count_sellers_stat AFTER INSERT ON sallers
FOR EACH ROW 
BEGIN 
	UPDATE statistic_all SET sellers_stat = sellers_stat + 1;
END
