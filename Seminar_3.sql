CREATE DATABASE IF NOT EXISTS lesson_3;

USE lesson_3;

DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    post VARCHAR(45) NOT NULL,
    seniority INT, 
    salary DECIMAL(8,2), -- 100 000 . 00
    age INT
);

INSERT staff(firstname, lastname, post, seniority,salary,age)
VALUES ("Петр", "Петров", "Начальник", 8, 70000, 30); -- id = 1
INSERT staff (firstname, lastname, post, seniority, salary, age)
VALUES
  ('Вася', 'Петров', 'Начальник', 40, 100000, 60),
  ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
  ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
  ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
  ('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
  ('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
  ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
  ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
  ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
  ('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
  ('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
  ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);

SELECT * FROM staff;

# Задача 1. Выведите все записи, отсортированные по полю "age" по возрастанию
# 1.1.
SELECT *
FROM staff
ORDER BY age;

# 1.2. сортировка по 2 столбцам
SELECT *
FROM staff
ORDER BY firstname, age;

# 1.3. сортировка по 2 столбцам (ASC + DESC)
SELECT *
FROM staff
ORDER BY firstname ASC, age DESC;


# Задача 2. Выведите уникальные значения полей "name"
SELECT DISTINCT firstname
FROM staff;

# Задача 3. Выведите кол-во уникальных значений полей "name"
SELECT  COUNT( DISTINCT firstname) 
FROM staff;

# Задача 4. Выведите первые 2 записи из таблицы
SELECT *
FROM staff
LIMIT 2;

# Задача 5. Пропустите  первые 4 строки ("id" = 1, "id" = 2,"id" = 3,"id" = 4)
# и извлеките следующие 3 строки ("id" = 5, "id" = 6, "id" = 7)
SELECT *
FROM staff
LIMIT 4, 3;

# Задача 6. Пропустите 2 последнии строки (где id=12, id=11) 
# и извлекаются следующие за ними 3 строки (где id=10, id=9, id=8)
SELECT * 
FROM staff 
ORDER BY id DESC 
LIMIT 3, 3;

# Задача 7. 
# 7.1. Выведите общий зп фонд по компании
SELECT SUM(salary)
FROM staff;

# 7.2. Выведите общий зп фонд по профессиям + top 1
SELECT post, SUM(salary) AS sum_salary
FROM staff
GROUP BY post
ORDER BY sum_salary DESC
LIMIT 1;

SELECT post, SUM(salary) AS sum_salary
FROM staff
GROUP BY post
ORDER BY 2 DESC   # по второму столбцу (цифрой, а не названием)
LIMIT 1;

# Задача 8. Выведите среднюю зп по должностям
SELECT post, AVG(salary) AS avg_salary
FROM staff
GROUP BY post;

# Задача 9.
# Вывести те должности, где кол-во людей больше 2
SELECT post, COUNT(*) 
FROM staff
GROUP BY post
HAVING COUNT(*) > 2;

# 1 способ
SELECT post  # убрали столбец с количеством
FROM staff
GROUP BY post
HAVING COUNT(*) > 2;

# 2 способ
SELECT post  
FROM staff
GROUP BY post
HAVING COUNT(*) BETWEEN 3 AND 100; # от 3 до 100

# 3 способ
SELECT post 
FROM staff
GROUP BY post
HAVING COUNT(*) IN(1, 2, 3); # через IN