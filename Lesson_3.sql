USE Seminar_1_homework;

# сортирвка от наименьшего к наибольшему (по возрастанию)
SELECT * FROM phones
ORDER BY Price;

# использование псевдонима (ProductCount * Price AS TotalSum)
SELECT ProductName, ProductCount, Price, ProductCount * Price AS TotalSum
FROM phones
ORDER BY TotalSum;

# без псевдонима (не отображается итоговое произведение)
SELECT ProductName, ProductCount, Price 
FROM phones
ORDER BY ProductCount * Price;

# вывод первых 3 строк
SELECT *
FROM phones
LIMIT 3;

# вывод 3 строк, начиная со 2ой строки (строки нумеруются с 0)
SELECT *
FROM phones
LIMIT 2, 3;

# вывод уникальных значений из столбца Manufacturer
SELECT DISTINCT Manufacturer
FROM phones;

# вывод уникальных значений из нескольких столбцов 
SELECT DISTINCT Manufacturer, ProductCount
FROM phones;

# группировка по столбцу Manufacturer
# COUNT(*) - считает количество
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM phones
GROUP BY Manufacturer;

# добавить новые строки в таблицу
INSERT INTO phones (ProductName, Manufacturer, ProductCount, Price)
VALUES
('iPhone 7', 'Apple', 5, 32000),
('Honor 10', 'Huawei', 5, 28000),
('Nokia 8', 'HMD Global', 6, 38000);

SELECT * FROM phones;

# найти среднее по столбцу Price и вывод под псевдонимом
SELECT AVG(Price) AS Average_Price
FROM phones;

/*
Агрегатные функции 
(обрабатывают несколько столбцов и получают 1 результирующее значение):
- SUM, 
- MIN, 
- MAX, 
- COUNT (количество строк в запросе)
- AVG (среднее значение)
*/

# вывод суммы по столбцу
SELECT SUM(Price)
FROM phones;

# вывод суммы по столбцу + псевдоним
SELECT SUM(Price) AS TotalSum
FROM phones;

# найти среднее по столбцу Price (без псевдонима) + условие
SELECT AVG(Price)
FROM phones
WHERE Manufacturer = 'Apple';

# вывод количества строк из таблицы phones
SELECT COUNT(*)
FROM phones;

# вывод min и max по столбцу
SELECT MIN(Price), MAX(Price)
FROM phones;

# вывод min и max по столбцу + псевдонимы
SELECT MIN(Price) AS min_price, MAX(Price) AS max_price
FROM phones;

# выбрать группы, где количество COUNT(*) > 1
# HAVING - фильтрует группы, WHERE - строки
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM phones
GROUP BY Manufacturer
HAVING COUNT(*) > 1;

# HAVING + WHERE
SELECT Manufacturer, COUNT(*) AS ModelsCount
FROM phones
WHERE Price * ProductCount > 80000  # фильтр по строкам
GROUP BY Manufacturer               # группировка по столбцу
HAVING COUNT(*) > 1;                # фильтр по группам

# + фильтр по столбцу (по убыванию)
SELECT Manufacturer, COUNT(*) AS Models, SUM(ProductCount) AS Units
FROM phones
WHERE Price * ProductCount > 80000
GROUP BY Manufacturer
HAVING SUM(ProductCount) > 2
ORDER BY Units DESC;                # сортировка по убыванию

/*
HAVING может работать со всеми агрегатными функциями:
SUM, MIN, MAX, COUNT, AVG
*/

/*
Приоритет операций:
1. FROM, включая JOINs
2. WHERE
3. GROUP BY
4. HAVING
5. Функции WINDOW
6. SELECT
7. DISTINCT
8. UNION
9. ORDER BY
10. LIMIT и OFFSET
*/
