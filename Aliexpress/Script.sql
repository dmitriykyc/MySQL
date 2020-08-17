-- ����������� ����������!!!



CREATE DATABASE ali;

USE ali;

������������ 
��������
���������
������������
������
���������
��������
������ ��� ����������
������
������?
UNSIGNED - �� ������������� ��������

CREATE TABLE users (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
firstname VARCHAR(100) NOT NULL,
adress TEXT NOT NULL,
languege_id VARCHAR(15) DEFAULT 1 COMMENT '����� ���� ������������, english �� ���������',
money_id INT DEFAULT 1 COMMENT '����� ������ ������������ � ������������, �� ��������� ������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COOMENT '������������, ����������';


CREATE TABLE sallers ()
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name_shop VARCHAR(30),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COMMENT '��������, �������';



CREATE TABLE products (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL, 
price DECIMAL(10, 2) NOT NULL COMMENT '����',
description TEXT NOT NULL,
category_product_id INT NOT NULL,
media_id INT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COMMENT '���������� � ������';

CREATE TABLE categories_product ( 
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR (50) COMMENT '�������� ���������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
) COMMENT '��������� �������';

CREATE TABLE messages (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
from_message INT NOT NULL,
to_message INT NOT NULL,
category_message_id ENUM('user-saller', 'saller-user') NOT NULL COMMENT '�� ���� � ���� ���������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
) COMMENT '��������� ����� ������������ � ����������'; 

CREATE TABLE orders (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
buyer_id INT NOT NULL COMMENT '��� �������',
sailer_id INT NOT NULL COMMENT '� ���� �������', 
product_id INT NOT NULL COMMENT '��� �������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
) COMMENT '���������� � �������';



CREATE TABLE delivery ( -- �������� � ��� � ��� �������. ������ �������, ������� ��� ���, ��������� ��� ���, ������ ��, ������ ��������, 
                         -- ���� ��������, ���� ��������� �����������, ��������� �� ���
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
order_id INT NOT NULL COMMENT '����� ������',
pay_inform TINYINT(1) COMMENT '������� �� �����',
delivered_status ENUM('Waiting to sent', 'Shipped', 'Delivered') NOT NULL DEFAULT 1 COMMENT '������ ��������',
sent_plan_delivery DATE NOT NULL COMMENT '����������� ���� ��������', --  ���� �������� ��������� ��������� ������???
receipt_plan_delivery -- ����������� ���� ���������, ���� �������� ��������� ��������� ������???
) COMMENT '���������� � ��������';

CREATE TABLE feedback (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
from_id INT UNSIGNED, 
to_id INT UNSIGNED,
category_message_id ENUM('user-saller', 'saller-user') NOT NULL,
messages TEXT,
estimation INT(1) NOT NULL, -- ������ 
media_id INT, 
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '������';

CREATE TABLE media (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
media_type ENUM('Photo', 'Video') NOT NULL,
link VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
update_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT '����� �������';


CREATE TABLE followers (
id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
saller_id INT NOT NULL,
) COMMENT '�������� ����������� �� ��������';






-- ????? CREATE TABLE shoppng_cart () --��������������???
-- created_at
-- update_at



-- ???? �����? CREATE TABLE pay () -- ��������� ����������, ��� �������� ������, �������� - ��������� - ������
-- id
-- order_id
-- 
-- created_at
-- update_at

