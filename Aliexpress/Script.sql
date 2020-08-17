-- Рассмотреть юлокировки!!!



CREATE DATABASE ali;

USE ali;

Пользователи 
Продавцы
Категории
Подкатегории
Товары
Сообщения
Доставка
Оплата или транзакции
Отзывы
Заказы?
UNSIGNED - не отрицательное значение

CREATE TABLE users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
firstname VARCHAR(100) NOT NULL,
adress TEXT NOT NULL,
languege_id VARCHAR(15) DEFAULT 1 COMMENT 'какой язык пользователя, english по умолчанию',
money_id INT DEFAULT 1 COMMENT 'Какая валюта используется у пользователя, по умолчанию доллар',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COOMENT 'Пользователи, покупатели';


CREATE TABLE sallers ()
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_shop VARCHAR(30),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COMMENT 'Продавец, магазин';



CREATE TABLE products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
price DECIMAL(10, 2) NOT NULL COMMENT 'Цена',
description TEXT NOT NULL,
category_product_id INT NOT NULL,
media_id INT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COMMENT 'Информация о товаре';

CREATE TABLE categories_product ( 
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (50) COMMENT 'Название категории',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COMMENT 'Категории товаров';

CREATE TABLE messages (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
from_message INT NOT NULL,
to_message INT NOT NULL,
category_message_id ENUM('user-saller', 'saller-user') NOT NULL COMMENT 'От кого и кому сообщение',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
) COMMENT 'сообщения между покупателями и продавцами'; 

CREATE TABLE orders (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
buyer_id INT NOT NULL COMMENT 'кто заказал',
sailer_id INT NOT NULL COMMENT 'у кого заказал', 
product_id INT NOT NULL COMMENT 'что заказал',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
) COMMENT 'Информация о заказах';



CREATE TABLE delivery ( -- доставка и что с ней связано. Номера заказов, оплачен или нет, доставлен или нет, оценен ли, статус доставки, 
                         -- дата отправки, дата получения планируемая, просрочен ли уже
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL COMMENT 'Номер заказа',
pay_inform TINYINT(1) COMMENT 'Оплачен ли заказ',
delivered_status ENUM('Waiting to sent', 'Shipped', 'Delivered') NOT NULL DEFAULT 1 COMMENT 'Статус доставки',
sent_plan_delivery DATE NOT NULL COMMENT 'планируемая дата отправки', --  Сюда наверное триггером добавлять данные???
receipt_plan_delivery -- планируемая дата получения, Сюда наверное триггером добавлять данные???
) COMMENT 'Информация о доставке';

CREATE TABLE feedback (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
from_id INT UNSIGNED, 
to_id INT UNSIGNED,
category_message_id ENUM('user-saller', 'saller-user') NOT NULL,
messages TEXT,
estimation INT(1) NOT NULL, -- оценка 
media_id INT, 
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Отзывы';

CREATE TABLE media (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
media_type ENUM('Photo', 'Video') NOT NULL,
link VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Медиа товаров';


CREATE TABLE followers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
saller_id INT NOT NULL,
) COMMENT 'Подписки покупателей на магазины';






-- ????? CREATE TABLE shoppng_cart () --корзинапокупок???
-- created_at
-- update_at



-- ???? зачем? CREATE TABLE pay () -- платежная информация, где держится оплата, продавец - платформа - клиент
-- id
-- order_id
-- 
-- created_at
-- update_at

