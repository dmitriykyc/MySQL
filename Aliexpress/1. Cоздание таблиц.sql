-- Я создаю базу данных Aliexpress. Через которую мы можем видеть статистику по заказам, времени доставки заказов, отзывов и обратной связи, рейтинги продавцов и покупателей. 
-- Сможем делать выборки по категориям товаров, какие товары в какой месяц лучше продаются, из каких стран больше покупают, сколько времени занимает доставка в эти странны и т.д.
-- Возьмем среднее значение сроков отправки заказа после его оформления = 7 дней.
-- Возьмем максимальное значение сроков доставки заказа после его отправки = 40 дней, иначе доставка просрочена.

-- Допустил граматических ошибок, и некоторые поля не правильно выставил, исправления в файле донастройка таблиц. 

CREATE DATABASE ali;

CREATE TABLE users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(100) NOT NULL,
last_name VARCHAR(100) NOT NULL,
adress TEXT NOT NULL,
country VARCHAR(20)
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Пользователи или покупатели';

-- исправил опечатку sallers на sellers в 3. Донастройка таблиц
CREATE TABLE sallers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_shop VARCHAR(30),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Продавец, магазин';



CREATE TABLE products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
price DECIMAL(10, 2) NOT NULL COMMENT 'Цена',
description TEXT NOT NULL,
category_product_id INT NOT NULL,
media_id INT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Информация о товаре';

CREATE TABLE messages (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
from_message INT NOT NULL,
to_message INT NOT NULL,
messages TEXT,
category_message_id ENUM('user-saller', 'saller-user') NOT NULL COMMENT 'От кого и кому сообщение',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'сообщения между покупателями и продавцами'; 

CREATE TABLE orders (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
buyer_id INT NOT NULL COMMENT 'кто заказал',
sailer_id INT NOT NULL COMMENT 'у кого заказал', 
product_id INT NOT NULL COMMENT 'что заказал',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Информация о заказах';



CREATE TABLE deliveries (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL COMMENT 'Номер заказа',
pay_inform TINYINT(1) COMMENT 'Оплачен ли заказ',
delivered_status ENUM('Waiting to sent', 'Shipped', 'Delivered') NOT NULL DEFAULT 'Waiting to sent' COMMENT 'Статус доставки',
sent_plan_delivery DATE NOT NULL COMMENT 'планируемая дата отправки', --  Сюда наверное триггером добавлять данные???
receipt_plan_delivery DATE NOT NULL COMMENT 'планируемая дата доставки'
) COMMENT = 'Информация о доставке';

CREATE TABLE feedback (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
from_id INT UNSIGNED, 
to_id INT UNSIGNED,
category_message_id ENUM('user-saller', 'saller-user') NOT NULL,
messages TEXT,
estimation INT(1) NOT NULL COMMENT 'Оценка', 
media_id INT, 
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Отзывы';

CREATE TABLE media (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
media_type ENUM('Photo', 'Video') NOT NULL,
link VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Медиа товаров';


CREATE TABLE followers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
saller_id INT NOT NULL
) COMMENT = 'Подписки покупателей на магазины';

CREATE TABLE categories_product ( 
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (50) COMMENT 'Название категории',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Категории товаров';

-- создадим таблицу статистики по общему количеству:
-- Пользователей,
-- Продавцов,
-- Категорий,
-- Заказов,
-- Продуктов
CREATE TABLE statistic_all (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	users_stat INT NOT NULL,
	sellers_stat INT NOT NULL,
	categories_stat INT NOT NULL,
	orders_stat INT NOT NULL,
	products_stat INT NOT NULL);




