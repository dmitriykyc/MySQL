-- Lesson 1: 
-- ************* Операторы, фильтрация, сортировка и ограничение. Агрегация данных ************* 
-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

USE shop;
SELECT * FROM test;
UPDATE test SET created_at = NOW();
UPDATE test SET update_at = NOW();
SELECT * FROM test;

-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

USE shop;

CREATE TABLE test2 (
  id INT PRIMARY KEY,
  created_at VARCHAR(150),
  update_at VARCHAR(150));
 
INSERT INTO test2 VALUES (1, '20.10.2017', '18.10.2017 8:10'), (2, '40.10.2017', '19.10.2017 8:10');
 
SELECT * FROM test2;

UPDATE test2 SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %h:%i');
UPDATE test2 SET update_at = STR_TO_DATE(update_at, '%d.%m.%Y %h:%i');

ALTER TABLE test2 CHANGE created_at created_at DATETIME;
ALTER TABLE test2 CHANGE update_at update_at DATETIME;	

DESCRIBE test2;



-- В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.

USE shop;

CREATE TABLE test3 (
  id INT PRIMARY KEY,
  quantity INT);
  

INSERT INTO test3 VALUES (1, 0), (2, 2500), (3, 0), (4, 30), (5, 500), (6, 1);

SELECT * FROM test3;

SELECT * FROM test3 ORDER BY CASE WHEN quantity = 0 THEN 999999999 ELSE quantity END;



-- “Агрегация данных”
-- Подсчитайте средний возраст пользователей в таблице users

USE shop;

SELECT ROUND(AVG((TO_DAYS(NOW()) - TO_DAYS(brithday_at))/365.25), 1) FROM users; 
-- 29.8

SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, brithday_at, NOW()))) FROM users;
-- 29


-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT COUNT(*), DAYNAME(CONCAT(2020, SUBSTRING(brithday_at, 5, 6))) AS bd_now FROM users GROUP BY bd_now;

-- 1	Wednesday
-- 1	Monday
-- 1	Tuesday
-- 2	Sunday
-- 1	Saturday
-- 1	Thursday
-- 1	Friday


-- (по желанию) Подсчитайте произведение чисел в столбце таблицы
 

USE shop;

CREATE TABLE test4(
  id INT);
  
 INSERT INTO test4 VALUES (1), (2), (3), (4), (5);
 
SELECT * FROM test4;

SELECT exp(SUM(log(id))) FROM test4;

-- Результат: 120


-- Lesson 2:  
-- ************* Операторы, фильтрация, сортировка и ограничение. Агрегация данных ************* 
-- Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

SELECT 
  (SELECT id FROM users WHERE id = likes.target_id) AS User_ID, 
   COUNT(*) AS count_like
FROM 
  likes 
WHERE target_type_id = 2
GROUP BY 
  target_id
ORDER BY (SELECT birthday FROM profiles WHERE user_id = likes.target_id) DESC;

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT 
  SUM(gender = 'm') AS Men, 
  SUM(gender = 'w') AS Women 
FROM profiles 
WHERE user_id 
  IN (SELECT likes.user_id FROM likes);
 
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- По наименьшему количеству лайков.

SELECT 
  profiles.user_id,
  (SELECT COUNT(user_id) FROM likes WHERE profiles.user_id = likes.user_id) AS `Count`
FROM profiles
ORDER BY `count`
LIMIT 10;


-- Lesson 3: 
-- ************* Сложные запросы ************* 

-- Составьте список пользователей users, которые осуществили хотя 
-- бы один заказ orders в интернет магазине.

SELECT name 
FROM users AS u JOIN orders_products AS o  
WHERE u.id IN (o.order_id);

-- Выведите список товаров products и разделов 
-- catalogs, который соответствует товару.

SELECT p.name, c.name 
FROM products AS p JOIN catalogs AS c
ON p.catalog_id = c.id;

-- Пусть имеется таблица рейсов flights (id, from, to) и таблица 
-- городов cities (label, name). Поля from, to и label содержат 
-- английские названия городов, поле name — русское. 
-- Выведите список рейсов flights с русскими названиями городов.

SELECT 
  (SELECT name FROM cities WHERE `from`  = label) AS `from`,
  (SELECT name FROM cities WHERE `to` = label) AS `to`
FROM 
  flights ;



--lesson 4: 
-- ************* Сложные запросы *************

-- Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).

SELECT SUM(like_table) FROM 
(SELECT 
(SELECT COUNT(*) FROM likes WHERE target_id = profiles.user_id 
AND target_type_id = 2) AS like_table
FROM profiles ORDER BY birthday DESC LIMIT 10) AS user_like;
-- результат 6


-- join запросы
-- Не могу понять как SUM сделать в JOIN заросе а не вложенным.

SELECT SUM(finish_table.result_likes) AS total FROM 
(SELECT COUNT(target_id) AS result_likes, profiles.user_id, likes.target_id, likes.target_type_id
FROM profiles
  LEFT JOIN likes 
    ON likes.target_id = profiles.user_id 
      AND likes.target_type_id = 2
GROUP BY profiles.user_id 
ORDER BY profiles.birthday DESC
LIMIT 10) AS finish_table;
-- результат 6

-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
 SELECT 
(SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
COUNT(*) AS total
FROM likes
GROUP BY gender
ORDER BY total DESC 
LIMIT 1;

-- Join

SELECT profiles.gender, COUNT(profiles.gender) AS total
  FROM likes
  JOIN profiles
    ON profiles.user_id = likes.user_id
  GROUP BY profiles.gender
  ORDER BY total DESC 
  LIMIT 1;
   
 
-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- По наименьшему количеству лайков.

SELECT 
  profiles.user_id,
  (SELECT COUNT(user_id) FROM likes WHERE profiles.user_id = likes.user_id) AS `Count`
FROM profiles
ORDER BY `count`
LIMIT 10;

-- JOIN

SELECT 
 users.id,
 COUNT(likes.user_id) AS put_a_like
  FROM users
    LEFT JOIN likes 
      ON users.id = likes.user_id
  GROUP BY users.id
  ORDER BY put_a_like
  LIMIT 10;
 
 
-- Lesson 5 
-- ************* Транзакции, переменные, представления *************
-- В базе данных shop и sample присутствуют одни и те же таблицы, 
-- учебной базы данных. Переместите запись id = 1 из таблицы shop.users 
-- в таблицу sample.users. Используйте транзакции.

DROP DATABASE IF EXISTS sample;

CREATE DATABASE sample;

USE sample;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

START TRANSACTION;

INSERT INTO sample.users 
 SELECT * FROM shop.users
 WHERE id = 1;

COMMIT;

SELECT * FROM users;


-- Создайте представление, которое выводит название name товарной позиции 
-- из таблицы products и соответствующее название каталога name из 
-- таблицы catalogs.

USE shop;

CREATE OR REPLACE VIEW result (name, name_catalog) 
  AS SELECT 
    p.name, c.name
    FROM products AS p
    JOIN catalogs AS c
    ON p.catalog_id = c.id; 
   
SELECT * FROM result;




-- Пусть имеется таблица с календарным полем created_at. 
-- В ней размещены разряженые календарные записи за август 2018 года 
-- '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
-- Составьте запрос, который выводит полный список дат за август, 
-- выставляя в соседнем поле значение 1, если дата присутствует в 
-- исходном таблице и 0, если она отсутствует.


DROP TABLE IF EXISTS lesson_date; 
CREATE TABLE lesson_date (
  `data` DATE PRIMARY KEY) ;
 
INSERT INTO lesson_date VALUES ('2018-08-01'), ('2016-08-04'), ('2018-08-16'), ('2018-08-17');

SELECT * FROM lesson_date;

SELECT selected_date, (SELECT EXISTS(SELECT * FROM lesson_date WHERE DAYOFMONTH(data) = DAYOFMONTH(selected_date))) AS true_result FROM 
(SELECT adddate('1970-01-01',t4*10000 + t3*1000 + t2*100 + t1*10 + t0) AS selected_date FROM
 (SELECT 0 t0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t0,
 (SELECT 0 t1 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
 (SELECT 0 t2 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
 (SELECT 0 t3 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
 (SELECT 0 t4 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t4) AS v
WHERE selected_date BETWEEN '2020-05-01' AND '2020-05-31' ORDER BY selected_date;



-- Пусть имеется любая таблица с календарным полем created_at. 
-- Создайте запрос, который удаляет устаревшие записи из таблицы, 
-- оставляя только 5 самых свежих записей.

DROP TABLE IF EXISTS lesson_date2; 
CREATE TABLE lesson_date2 (
  `created_at` DATE PRIMARY KEY) ;
 
INSERT INTO lesson_date2 VALUES ('2018-08-01'), ('2016-08-04'), ('2018-08-16'), ('2018-08-17'), ('2005-03-19'), ('1992-10-11'), ('2009-01-23'), ('2019-07-11');

SET @res = (SELECT created_at FROM lesson_date2 ORDER BY created_at DESC LIMIT 5, 1); 

SELECT @res;

DELETE FROM lesson_date2 WHERE TO_DAYS(created_at) <= TO_DAYS(@res);

SELECT * FROM lesson_date2 ORDER BY created_at;



-- Lesson 6
--  ************* “Хранимые процедуры и функции, триггеры" *************
-- Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", 
-- с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;

CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
	CASE 
	WHEN DATE_FORMAT(NOW(), "%H") BETWEEN 6 AND 12 THEN
		RETURN 'Доброе утро!';
	WHEN DATE_FORMAT(NOW(), "%H") BETWEEN 12 AND 18 THEN
		RETURN 'Добрый день!';
	WHEN DATE_FORMAT(NOW(), "%H") > 18 THEN
		RETURN 'Добрый вечер!';
	WHEN DATE_FORMAT(NOW(), "%H") < 6 THEN
		RETURN 'Доброй ночи!';
	ELSE 
		RETURN 'Ошибка';
	END CASE;
END

-- Lesson 7
-- *********** Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггеры **********
-- 1. 
-- Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы

CREATE INDEX users_email_idx ON users(email);

CREATE INDEX media_filename_idx ON media(filename);

CREATE INDEX profiles_birthday_idx ON profiles(birthday);

CREATE INDEX users_first_name_idx ON users(first_name);

CREATE INDEX users_last_name_idx ON users(last_name);

CREATE INDEX users_phone_idx ON users(phone);


-- 2. Не знаю как избавиться от NULL, и кажется я не правильно подошёл к решению.

-- Задание на оконные функции
-- Построить запрос, который будет выводить следующие столбцы:
-- имя группы
-- среднее количество пользователей в группах
-- самый молодой пользователь в группе
-- самый старший пользователь в группе
-- общее количество пользователей в группе
-- всего пользователей в системе
-- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100     
     

SELECT DISTINCT communites.name,
	COUNT(communites.name) OVER(PARTITION BY communites.id) AS hh,
	FLOOR(MAX(profiles.user_id) OVER() / MAX(communites.id) OVER()) AS average_users_in_group,
	NTH_VALUE(communites_users.user_id, 1) OVER(PARTITION BY communites_users.community_id ORDER BY profiles.birthday) AS bt_yong,
	NTH_VALUE(communites_users.user_id, 1) OVER(PARTITION BY communites_users.community_id ORDER BY profiles.birthday DESC) AS bt_old,
	COUNT(profiles.user_id ) OVER(PARTITION BY communites.id) AS quantity_users_in_group,
	MAX(profiles.user_id ) OVER() AS quantity_users_all,
	COUNT(profiles.user_id ) OVER(PARTITION BY communites.id) / MAX(profiles.user_id ) OVER() * 100 AS '%'
FROM profiles
LEFT JOIN communites_users 
ON communites_users.user_id = profiles.user_id 
LEFT JOIN communites 
ON communites_users.community_id = communites.id;


-- Lesson 8. 
-- **********  “Оптимизация запросов” **********
1. 
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs 
-- помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name_table VARCHAR(255),
	value_name VARCHAR(255),
	create_at DATETIME) ENGINE = Archive;

DROP TRIGGER IF EXISTS logs_insert_users;
CREATE TRIGGER logs_insert_users AFTER INSERT ON users
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (name_table, value_name, create_at) VALUES ('users', NEW.name, NOW());
END;

DROP TRIGGER IF EXISTS logs_insert_catalog; 
CREATE TRIGGER logs_insert_catalog AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (name_table, value_name, create_at) VALUES ('catalogs', NEW.name, NOW());
END;


DROP TRIGGER IF EXISTS logs_insert_products;
CREATE TRIGGER logs_insert_products AFTER INSERT ON products
FOR EACH ROW 
BEGIN 
	INSERT INTO logs (name_table, value_name, create_at) VALUES ('products', NEW.name, NOW());
END;


SELECT * FROM users;
INSERT INTO users VALUES (NULL, 'Дмитрий', '1990-10-05', NOW(), NOw());

SELECT * FROM catalogs;
INSERT INTO catalogs VALUES (7, 'Звукорвые устройства');

SELECT * FROM products p ;
INSERT INTO products VALUES (NULL, 'Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890, 4);

SELECT * FROM logs;



-- 2.
-- Создайте SQL-запрос, который помещает в таблицу users миллион записей.
DROP PROCEDURE IF EXISTS million;

CREATE PROCEDURE million()
BEGIN
	DECLARE i INT;
	SET i = 1000000;
	WHILE i != 0 DO
		INSERT INTO users VALUES (NULL, 'Дмитрий', '1992-10-11', NOW(), NOW());
		SET i = i - 1;
	END WHILE;
END;

CALL million(); 

-- Всегда считает разное количество записей, почему? как будто прогружает постоянно, как узнать сколько записей в большой таблице? Или дело в моем компе?
SELECT COUNT(*) FROM users u;

SELECT * FROM users u ; 

-- И удаляет так же не все, а как будто подгружает.
DELETE FROM users WHERE id > 7; 

-- даже так не вышло всё удалить)) Как работать с большими данными?
CREATE PROCEDURE dellete()
BEGIN
	WHILE (SELECT COUNT(*) FROM users u2)  > 7 DO
		DELETE FROM users WHERE id > 7; 
	END WHILE;
END;

CALL dellete(); 
 

-- ********** “NoSQL” **********
-- 1. 
-- В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов.

-- Единственное что в этой коллекции значения добавляются только уникальные, если нужно посчитать 
-- сколько посещений было у одного ip, тут вероятно не получится.
SADD ip 0.0.0.1

SADD ip 0.0.0.2 0.0.0.3 0.0.0.4

SMEMBERS ip

SCARD ip

-- 2.
-- При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
-- поиск электронного адреса пользователя по его имени.

-- поиск по ключу
HSET database_name Dmitriy dmitriykyc@gmail.com
HSET database_name Elena elena@gmail.com
HSET database_name Alex alex@gmail.com
HSET database_name Varvara varvara@gmail.com

HGET database_name Alex
"alex@gmail.com"

-- А как сделать поиск по значению, пока не разобрался. 
-- Пока только идея если сделать ключем Email а значением имя, но наверное это не правильный подход. 
-- Еще поищу как все доделаю, если не исправил - не нашел)))












