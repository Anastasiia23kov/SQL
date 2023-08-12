/*
СТЕ (Common Table Expressions) - обобщенные табличные выражения. 

							   - это временный результирующий набор данных, 
								к которому можно обращаться в последующих запросах.

								Результаты табличных выражений можно 
                                временно сохранять в памяти и обращаться к ним повторно.
                                
                                Аналог функций в python. Когда создаем функцию, 
                                а после используем её сколько угодно раз. 

Для написания обобщённого табличного выражения используется оператор WITH

CTE работают быстрее, чем обычные подзапросы.
('сти')

Выражение с WITH считается «временным», потому что результат не сохраняется 
где-либо на постоянной основе в схеме базы данных, а действует как временное представление,
которое существует только на время выполнения запроса, то есть оно доступно только 
во время выполнения операторов SELECT, INSERT, UPDATE, DELETE или MERGE.
*/

# 1. Пример использования CTE - конструкции WITH
WITH Aeroflot_trips AS
    (SELECT TRIP.* FROM Company
        INNER JOIN Trip ON Trip.company = Company.id WHERE name = "Aeroflot")

SELECT plane, COUNT(plane) AS amount FROM Aeroflot_trips GROUP BY plane;

# Теперь чтобы обратиться к запросу, достаточно написать: FROM Aeroflot_trips
# Так мы сократили код + его можно использовать повторно.

/*
Также существуют рекурсивные CTE.

CTE является рекурсивным, если его подзапрос ссылается на его собственное имя. 
						 Если планируется использовать рекурсивный CTE,
                         то в запрос должен быть включен параметр RECURSIVE.
*/

# 2. Рекурсивные CTE
# Пример: генерация набора от 1 до 10
WITH RECURSIVE cte AS
(
	SELECT 1 AS a
	UNION ALL
	SELECT a + 1 FROM cte  			# ссылается на саму себя -> рекурсия
	WHERE a < 10
)
SELECT * FROM cte;

-- Создание таблицы для работы
CREATE TABLE IF NOT EXISTS bank
(
tb VARCHAR(10) NOT NULL,
id_client INT NOT NULL,
id_dog INT NOT NULL,
osz INT NOT NULL,
procent_rate INT NOT NULL,
rating INT,
segment VARCHAR(25)
);

INSERT INTO bank (tb, id_client, id_dog, osz, procent_rate, rating, segment)
VALUES
('A', 1, 111, 100, 6, 10, 'SREDN'),
('A', 1, 222, 150, 6, 10, 'SREDN'),
('A', 2, 333, 50, 9, 15, 'MMB'),
('B', 1, 444, 200, 7, 10, 'SREDN'),
('B', 3, 555, 1000, 5, 16, 'CIB'),
('B', 4, 666, 500, 10, 20, 'CIB'),
('B', 4, 777, 10, 12, 17, 'MMB'),
('C', 5, 888, 20, 11, 21, 'MMB'),
('C', 5, 999, 200, 9, 13, 'SREDN');

# Задача 1. Собрать дэшборд, в котором содержится информация:
#			1). о максимальной задолженности в каждом банке,
#           2). средний размер процентной ставки в каждом банке в зависимости от сегмента 
#           3). количество договоров всего всем банкам.
# Используем агрегирующие оконные функции.
SELECT *, 
	MAX(osz) OVER(PARTITION BY tb) AS 'max_osz', 									  #1
    ROUND(AVG(procent_rate) OVER(PARTITION BY tb, segment), 2) AS 'avg_procent_rate', #2
    COUNT(tb) OVER() AS 'number_of_contracts' 									      #3
FROM bank;

# ROUND(AVG(procent_rate) OVER(PARTITION BY tb, segment), 2) 
# ROUND(n, 2)- округление до 2 знаков после запятой

# Задача 2. Найти 2-ой отдел во всех банках по количеству задолженностей.
# osz - задолженность
SELECT MAX(osz)
FROM bank
WHERE osz != (SELECT Max(osz) FROM bank);


# Задача 3. Найти 3-й, 4-й ... отдел во всех банках по количеству задолженностей.
# ORDER BY - по убыванию, т.е. ds = 1 выведет самые маленькие задолженности
WITH osz_rate AS
	(
	SELECT * , DENSE_RANK() OVER(PARTITION BY tb ORDER BY osz) ds # ds - псевдоним
	FROM bank
	)
    
SELECT tb, id_dog, osz
FROM osz_rate
WHERE ds = 1;

# DESC - по возрастанию, т.е. ds = 1 выведет самые большие задолженности
WITH osz_rate2 AS
	(
	SELECT * , DENSE_RANK() OVER(PARTITION BY tb ORDER BY osz DESC)  AS ds
	FROM bank
	)
SELECT tb, id_dog, osz
FROM osz_rate2
WHERE ds = 1;

# Задача 4. Нумируем строки по сегменту 
# Ранжирующая функция ROW_NUMBER()
SELECT *,
	ROW_NUMBER() OVER(ORDER BY segment) # segment выстраивается в алфавитном порядке
FROM bank;

SELECT *,
	ROW_NUMBER() OVER(ORDER BY segment DESC) # segment по убыванию
FROM bank;

# Задача 5. Задаем ранги по сегменту. Ранжирующая функция RANK()
# После одинаковых значений - ЕСТЬ пропуски. (тут нет рангов 2, 4, 5...)
SELECT *,
	ROW_NUMBER() OVER(ORDER BY segment) AS 'Row_number_segment',
    RANK() OVER(ORDER BY segment) AS 'Rank_segment'
FROM bank;

# Задача 6. Задаем ранги по сегменту. Ранжирующая функция DENSE_RANK()
# После одинаковых значений - НЕТ пропусков
SELECT *,
	ROW_NUMBER() OVER(ORDER BY segment) AS 'Row_number_segment',
    RANK() OVER(ORDER BY segment) AS 'Rank_segment',
    DENSE_RANK() OVER(ORDER BY segment) AS 'Dense_rank_segment'
FROM bank;

# Задача 7. Функции смещения LEAD – обращается к данным из следующей строки. 
SELECT *,
	LEAD(procent_rate, 1, 'end') 
	OVER(PARTITION BY tb ORDER BY id_dog) AS next_procent_rate
FROM bank;
# в next_procent_rate выводит следующую строку по группе,
# в последней строке выводит 'end', т.к. она последняя.

SELECT *,
	LEAD(procent_rate, 1)  # без 'end' выводит в последних строках NULL
	OVER(PARTITION BY tb ORDER BY id_dog) AS next_procent_rate
FROM bank;

# Задача 8. Функции смещения LAG - обращается к данным из предыдущей строки окна 
SELECT *,
	LAG(procent_rate, 1, 'start') 
	OVER(PARTITION BY tb ORDER BY osz) AS previous_procent_rate
FROM bank;
# в previous_procent_rate выводит предыдущую строку по группе,
# в 1-ой строке выводит 'start', т.к. она перед ней нет строки по группе.