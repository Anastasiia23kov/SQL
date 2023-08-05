# UNION - объединяет 2 и более SELECT
SELECT 1, 2 UNION SELECT 'a', 'b';

CREATE DATABASE Lesson_4;

USE Lesson_4;

# покупатели
CREATE TABLE IF NOT EXISTS  Customers
(
Id INT PRIMARY KEY AUTO_INCREMENT,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL,
AccountSum DECIMAL
);

# сотрудники
CREATE TABLE IF NOT EXISTS  Employees
(
Id INT PRIMARY KEY AUTO_INCREMENT,
FirstName VARCHAR(20) NOT NULL,
LastName VARCHAR(20) NOT NULL
);

INSERT INTO Customers (FirstName, LastName, AccountSum)
VALUES
('Tom', 'Smith', 2000),
('Sam', 'Brown', 3000),
('Mark', 'Adams', 2500),
('Paul', 'Ins', 4200),
('John', 'Smith', 2800),
('Tim', 'Cook', 2800);

INSERT INTO Employees (FirstName, LastName)
VALUES
('Homer', 'Simpson'),
('Tom', 'Smith'),
('Mark', 'Adams'),
('Nick', 'Svensson');

# UNION и UNION ALL - объединение 2+ select'ов

# Выбираем имена и фамилии из обеих таблиц и объединяем в одну 
# с помощью UNION
SELECT FirstName, LastName
FROM Customers
UNION
SELECT FirstName, LastName
FROM Employees; 
-- получилось 8 строк (а суммарно в двух таблицах 10),
-- т.к. UNION удалил повторяющиеся строки при объединении

# UNION + ORDER BY
SELECT FirstName, LastName FROM Customers
UNION
SELECT FirstName, LastName FROM Employees
ORDER BY FirstName DESC; 

# UNION ALL - как UNION 
# + НЕ удаляет повторяющиеся строки
SELECT FirstName, LastName FROM Customers
UNION ALL
SELECT FirstName, LastName FROM Employees;
-- вывел все 10 строк,
-- UNION ALL не удаляет повторяющиеся строки при объединении

# UNION ALL + ORDER BY
SELECT FirstName, LastName FROM Customers
UNION ALL
SELECT FirstName, LastName FROM Employees
ORDER BY FirstName DESC; 
-- видим повторы

# UNION, где SELECTы из одной таблицы 
# если сумма меньше 3000, то начисляется 10% от суммы на счете
# если больше 3000, то начисляется 30% 
SELECT FirstName, LastName, AccountSum + AccountSum * 0.1 AS TotalSum
FROM Customers WHERE AccountSum < 3000
UNION
SELECT FirstName, LastName, AccountSum + AccountSum * 0.3 AS TotalSum
FROM Customers WHERE AccountSum >= 3000;
 
# JOIN'ы - объединение таблиц
 
# INNER JOIN - общее из 2х таблиц
SELECT Customers.FirstName, Customers.AccountSum, Employees.FirstName AS employeses_firstname
FROM Customers
JOIN Employees 
ON Employees.LastName = Customers.LastName;  

# добавили псевдонимы для названий таблиц
SELECT C.FirstName, C.AccountSum, E.FirstName AS employeses_firstname
FROM Customers AS C
JOIN Employees AS E
ON E.LastName = C.LastName;  
  
# LEFT OUTER JOIN - всё из левой + из правой то, что удовлетворяет условию
# + псевдонимы для названий таблиц
SELECT C.FirstName, C.AccountSum, E.FirstName
FROM Customers AS C
LEFT JOIN Employees AS E
ON C.Id = E.Id;  

# RIGHT OUTER JOIN - всё из правой + из левой то, что удовлетворяет условию
# + псевдонимы для названий таблиц
SELECT C.FirstName, C.AccountSum, E.FirstName
FROM Customers AS C
RIGHT JOIN Employees AS E
ON C.Id = E.Id; 

# FULL JOIN - НЕ поддерживается в MySQL
# альтернатива: LEFT JOIN + UNION (UNION ALL) + RIGHT JOIN
SELECT C.FirstName, C.AccountSum, E.FirstName
FROM Customers AS C
LEFT JOIN Employees AS E
ON C.Id = E.Id
UNION   # или UNION ALL - он быстрее
SELECT C.FirstName, C.AccountSum, E.FirstName
FROM Customers AS C
RIGHT JOIN Employees AS E
ON C.Id = E.Id;  

# CROSS JOIN - объединение каждой строки 1ой таблицы с каждой строкой 2ой таблицы.
# Декартово произведение
SELECT *
FROM Customers
CROSS JOIN Employees;

# оператор IN
SELECT *
FROM Customers
WHERE LastName IN (SELECT LastName FROM Employees);
# показать всё из таблицы Customers, 
# где LastName ЕСТЬ в столбце LastName таблицы Employees

# NOT IN
SELECT *
FROM Customers
WHERE LastName NOT IN (SELECT LastName FROM Employees);
# показать всё из таблицы Customers, 
# где LastName НЕТУ в столбце LastName таблицы Employees

# оператор EXISTS
# позволяет проверить существует ли ... в подзапросе
SELECT *
FROM Customers 
WHERE EXISTS
(SELECT * FROM Employees WHERE Customers.LastName = Employees.LastName);

# создание новой таблицы копированием существующей 
CREATE TABLE copy_customers SELECT * FROM Customers;

SELECT *
FROM copy_customers;

