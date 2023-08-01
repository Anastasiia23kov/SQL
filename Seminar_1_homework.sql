USE Seminar_1_homework;

# 1. Создайте таблицу с мобильными телефонами, используя 
# графический интерфейс. Заполните БД данными.

create table if not exists phones
(
Id int primary key auto_increment,
ProductName varchar(50),
Manufacturer varchar(50),
ProductCount int,
Price int
);

insert into phones (ProductName, Manufacturer, ProductCount, Price)
values
('iPhone X', 'Apple', '3', '76000'),
('iPhone 8', 'Apple', '2', '51000'),
('Galaxy S9', 'Samsung', '2', '56000'),
('Galaxy S8', 'Samsung', '1', '41000'),
('P20 Pro', 'Huawei', '5', '36000');

SELECT * FROM phones; 

# 2. Выведите название, производителя и цену для товаров, 
# количество которых превышает 2
SELECT ProductName, Manufacturer, Price
FROM phones
WHERE ProductCount > 2;

# 3. Выведите весь ассортимент товаров марки “Samsung”
SELECT *
FROM phones
WHERE Manufacturer = 'Samsung';

# 4. С помощью регулярных выражений найти товары, в которых есть: 
# 4.1.  "Iphone"
SELECT *
FROM phones
WHERE ProductName LIKE '%Iphone%' 
OR Manufacturer LIKE '%Iphone%';

# 4.2. "Samsung"
SELECT *
FROM phones
WHERE ProductName LIKE '%Samsung%'
OR Manufacturer LIKE 'Samsung';

# 4.3.  ЦИФРЫ
SELECT * 
FROM phones
WHERE ProductName RLIKE '[0-9]';

# 4.4.  ЦИФРА "8"  
SELECT * 
FROM phones
WHERE ProductName LIKE '%8%'
OR Manufacturer LIKE '%8%';

