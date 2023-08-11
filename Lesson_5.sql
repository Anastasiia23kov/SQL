CREATE DATABASE Lesson_5;

USE Lesson_5;

CREATE TABLE IF NOT EXISTS sales
(
sales_employee VARCHAR(50) NOT NULL,
fiscal_year INT NOT NULL,
sale DECIMAL(14,2) NOT NULL,              # для DECIMAL 2 числа в скобках
PRIMARY KEY(sales_employee, fiscal_year)  # 2 первичных ключа
);

INSERT INTO sales(sales_employee, fiscal_year, sale)
VALUES
('Bob', 2016, 100),
('Bob', 2017, 150),
('Bob', 2018, 200),
('Alice', 2016, 150),
('Alice', 2017, 100),
('Alice', 2018, 200),
('John', 2016, 200),
('John', 2017, 150),
('John', 2018, 250);

SELECT * FROM sales;

# Агрегатные функции

# 1. Сумма продаж по столбцу sale
SELECT SUM(sale)
FROM sales;

# 2. Объем продаж по финансовым годам
SELECT fiscal_year, SUM(sale) AS total_sum
FROM sales
GROUP BY fiscal_year;


/*
1. Обычный запрос - это одно целое. Всё выполняется одновременно. 

2. Оконные функции - это несколько подзапросов отдельных окон. 
Запрос делится на несколько окон, которые выполняются отдельно.
Производительность выше.

Окно определяется с помощью обязательной инструкции OVER(). 
*/

DROP TABLE Orders;

CREATE TABLE IF NOT EXISTS Orders
( Date DATE NOT NULL,
Medium VARCHAR(25) NOT NULL,
Conversions INT
);

INSERT INTO Orders(Date, Medium, Conversions)
VALUES
('10.05.2020', 'cpa', 1),
('10.05.2020', 'cpc', 2),
('10.05.2020', 'organic', 1),
('11.05.2020', 'cpa', 1),
('11.05.2020', 'cpc', 3),
('11.05.2020', 'organic', 2),
('11.05.2020', 'direct', 1),
('12.05.2020', 'cpc', 1),
('12.05.2020', 'organic', 2);

# 1. OVER()
# OVER() - суммируем столбец 'Conversions' и добавляем в таблицу столбец 'Sum', 
# в котором в каждой строчке прописывается одно и то же значение:
# сумма по столбцу 'Conversions'
SELECT Date, Medium, Conversions, 
	   SUM(Conversions) OVER() AS 'Sum'
FROM Orders;

# 2. OVER () + PARTITION BY
# PARTITION BY - условие, по которому будет производится группировка
# группируем таблицу по дате (столбец Date) и ищем сумму по конверсий для каждой группы
SELECT Date, Medium, Conversions, 
	   SUM(Conversions) OVER(PARTITION BY Date) AS 'Sum'
FROM Orders;

# 3. OVER () + PARTITION BY + ORDER BY
# ORDER BY - сортировка по столбцу
SELECT Date, Medium, Conversions, 
	   SUM(Conversions) OVER(PARTITION BY Date ORDER BY Medium) AS 'Sum'
FROM Orders;
# тут суммируются строки внутри одной группы (группы по Date))

/*
ROWS и RANGE:

- UNBOUNDED PRECEDING — указывает, что окно начинается с 1-ой строки группы;
- UNBOUNDED FOLLOWING – указывает, то окно заканчивается на последней строке группы;
- CURRENT ROW – указывает, что окно начинается или заканчивается на текущей строке;
- BETWEEN «граница окна» AND «граница окна» — указывает нижнюю и верхнюю границу окна;
- «Значение» PRECEDING – определяет число строк перед текущей строкой 
						 (не допускается в предложении RANGE).;
- «Значение» FOLLOWING — определяет число строк после текущей строки 
						 (не допускается в предложении RANGE).
*/
# 4. Сортируем между текущей строкой и 1 последующей
SELECT Date, Medium, Conversions, 
	   SUM(Conversions) OVER(PARTITION BY Date ORDER BY Conversions 
       ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS 'Sum'
FROM Orders;

/*
Виды оконных функций:
1. Агрегатные функции;
2. Ранжирующие функции;
3. Функции смещения;
4. Аналитические функции.
*/

/*
Агрегатные функции – это функции, которые выполняют на наборе данных 
					 арифметические вычисления и возвращают итоговое значение.
- SUM – возвращает сумму значений в столбце;
- COUNT — вычисляет количество значений в столбце (значения NULL не учитываются);
- AVG — определяет среднее значение в столбце;
- MAX — определяет максимальное значение в столбце;
- MIN — определяет минимальное значение в столбце
*/

# 5. Агрегатные функции + оконная инструкция OVER()
SELECT Date, Medium, Conversions, 
	   SUM(Conversions) OVER(PARTITION BY Date ) AS 'Sum',
       COUNT(Conversions) OVER(PARTITION BY Date ) AS 'Count',
       AVG(Conversions) OVER(PARTITION BY Date ) AS 'Avg',
       MAX(Conversions) OVER(PARTITION BY Date ) AS 'Max',
       MIN(Conversions) OVER(PARTITION BY Date ) AS 'Min'
FROM Orders;

/*
Ранжирующие функции – это функции, которые ранжируют значение для каждой строки в окне. 
					  Например, их можно использовать для того, чтобы присвоить порядковый номер
					  строки или составить рейтинг.
- ROW_NUMBER – функция возвращает номер строки и используется для нумерации;
- RANK — возвращает ранг каждой строки. 
		Если есть одинаковые, возвращает одинаковый ранг с пропуском следующего значения: 
        если 2 одинаковых, то обоим присваивается ранг 1, а следующий уже имеет ранг 3;
- DENSE_RANK —  возвращает ранг каждой строки. 	
				Но в отличие от RANK, для одинаковых значений возвращает одинаковый ранг (1 и 1), 
                а следующие НЕ пропускает (ранг 3);
- NTILE – это функция, которая позволяет определить к какой	группе относится текущая строка. 
		  Количество групп задается в скобках.
*/

# 6. Ранжирующие функции + оконная инструкция OVER()
SELECT Date, Medium, Conversions, 
	   ROW_NUMBER()                             # задает индекс каждой строке
       OVER(PARTITION BY Date ORDER BY Conversions) AS 'Row_number',
       RANK()                                   # задает ранг (для одинаковых пропускает)
       OVER(PARTITION BY Date ORDER BY Conversions) AS 'Rank',
       DENSE_RANK()                             # задает ранг (для одинаковых НЕ пропускает)
       OVER(PARTITION BY Date ORDER BY Conversions) AS 'Dense_Rank',
       NTILE(3)                                 # делит по группам
       OVER(PARTITION BY Date ORDER BY Conversions) AS 'Ntile'
FROM Orders;

/*
Функции смещения – это функции, которые позволяют перемещаться и обращаться 
				   к разным строкам в окне, относительно текущей строки, 
                   а также обращаться к значениям в начале или в конце окна.
- LAG - обращается к данным из предыдущей строки окна 
- LEAD – обращается к данным из следующей строки. 

		Функции LAG и LEAD можно использовать для того, чтобы сравнивать текущее значение строки 
        с предыдущим или следующим. 
        Имеет 3 параметра: 1). столбец, значение которого необходимо вернуть, 
                           2). количество строк для смещения (по умолчанию 1), 
                           3). значение, которое необходимо вернуть,
                               если после смещения возвращается значение NULL;
- FIRST_VALUE или LAST_VALUE — с помощью функции можно получить 1-ое и последнее значение в окне. 
                               Принимает столбец, значение которого необходимо вернуть.
*/

# 7. Функции смещения + оконная инструкция OVER()
SELECT Date, Medium, Conversions, 
	   LAG(Conversions) OVER(PARTITION BY Date ORDER BY Date) AS 'Lag',
	   LEAD(Conversions) OVER(PARTITION BY Date ORDER BY Date) AS 'Lead',
	   FIRST_VALUE(Conversions) OVER(PARTITION BY Date ORDER BY Date) AS 'First_value',
	   LAST_VALUE(Conversions) OVER(PARTITION BY Date ORDER BY Date) AS 'Last_value'
FROM Orders;

/*
Представление (VIEW) — объект базы данных, являющийся результатом выполнения запроса к базе данных, 
					   определенного с помощью оператора SELECT, в момент обращения к представлению.
                       Представления иногда называют «виртуальными таблицами». 
                       Представление доступно для пользователя как таблица, но само оно
                       не содержит данных, а извлекает их из таблиц в момент обращения к нему. 
*/

# 8. VIEW - создание виртуальной таблицы 
CREATE VIEW Organic_orders
	AS SELECT *                  # выбираем все столбцы
    FROM Orders                  # из исходной таблицы
    WHERE Medium = 'organic';    # которые подходят условию

# 9. Удаление представления
DROP VIEW Organic_orders;

CREATE VIEW direct_orders
	AS SELECT *                  # выбираем все столбцы
    FROM Orders                  # из исходной таблицы
    WHERE Medium = 'direct'; 

# 10. Объединение представлений VIEW
CREATE VIEW organic_direct_orders
AS SELECT organic_orders.Date, organic_orders.Conversions FROM organic_orders
INNER JOIN direct_orders
ON organic_orders.Date = direct_orders.Date;

# 11. ALTER - изменения представления
ALTER VIEW Organic_orders
	AS SELECT *                  
    FROM Orders                  
    WHERE Medium = 'cpa';  

# 12. Добавление столбца в таблицу
ALTER TABLE sales
ADD COLUMN discriptions VARCHAR(25) ;

# 13. Удаление столбца
ALTER TABLE sales
DROP COLUMN discriptions;
