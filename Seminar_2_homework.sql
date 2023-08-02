CREATE DATABASE Seminar_2_homework;

USE Seminar_2_homework;

/*
Задача 1. Используя операторы языка SQL, 
создайте табличку “sales”. 
Заполните ее данными
*/

DROP TABLE IF EXISTS sales;

CREATE TABLE sales
(
id INT PRIMARY KEY AUTO_INCREMENT,
order_date DATE NOT NULL,
bucket INT NOT NULL);

INSERT INTO sales (order_date, bucket)
VALUES
('2021-01-01', 150),
('2021-01-02', 184),
('2021-01-03', 77),
('2021-01-04', 193),
('2021-01-05', 401);

SELECT * FROM sales;

/*
Задача 2. Разделите  значения количества в 3 сегмента 
— меньше 100(“Маленький заказ”), 100-300(“Средний заказ” 
и больше 300 (“Большой заказ”).
*/

# 1 способ. Через IF
SELECT id, order_date,
    IF(bucket < 100, 'Маленький заказ',
	IF(bucket > 300, 'Большой заказ', 'Средний заказ')) AS bucket
FROM sales;

# 2 способ. Через CASE
SELECT id, order_date,
CASE
	WHEN bucket < 100 THEN 'Маленький заказ'
    WHEN bucket > 300 THEN 'Большой заказ'
    ELSE 'Средний заказ'
END AS bucket
FROM sales;


/*
Задача 3. Создайте таблицу “orders”, заполните ее значениями. 
Покажите “полный” статус заказа, используя оператор CASE.
*/

# удалили таблицу orders, если она уже существует
DROP TABLE IF EXISTS orders; 

CREATE TABLE orders
(
orderid INT PRIMARY KEY AUTO_INCREMENT,
employeeid VARCHAR(5) NOT NULL,
amount DECIMAL NOT NULL,
orderstatus VARCHAR(20)
);

INSERT INTO orders (employeeid, amount, orderstatus)
VALUES
('e03', 15.00, 'OPEN'),
('e01', 25.50, 'OPEN'),
('e05', 100.70, 'CLOSED'),
('e02', 22.18, 'OPEN'),
('e04', 9.50, 'CANCELLED'),
('e04', 99.99, 'OPEN');

SELECT * FROM orders;

SELECT orderid, orderstatus,
CASE
	WHEN orderstatus = 'OPEN' THEN 'Order is in open state.'
	WHEN orderstatus = 'CLOSED' THEN 'Order is closed.'
	WHEN orderstatus = 'CANCELLED' THEN 'Order is cancelled.'
END AS order_summary
FROM orders;

/*
Задача 4. Чем 0 отличается от NULL?

0 - это число.
NULL - это пустое значение (пустая ячейка), т.е. в ячейке отсутствуют данные.
*/
