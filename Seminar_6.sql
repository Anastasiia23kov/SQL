-- СОЗДАНИЕ ПЕРЕМЕННОЙ

# 1 способ
SET @start := 1;
SELECT @start;

# 2 способ
SET @start2 = 2;    # без двуеточия
SELECT @start2;

-- ВРЕМЕННАЯ ТАБЛИЦА
# автоматически УНИЧТОЖИТСЯ, если отключить соединение с БД

-- ПРОЦЕДУРЫ
# сохраняются в Schemas -> Stored Procedures

USE lesson_3;
SELECT * FROM staff;

# создали переменную @res_out
SELECT @res_out := 5; 

/*
В процедурах:
- IN - то, что передаем в процедуру
- OUT - то, что она нам возвращает 
если у нас только IN, можем НЕ прописывать OUT

DELIMITER $$:
- понимает, что разделители(;) находятся внутри процедуры (т.е. это одно целое) 
- показывает SQL, где начинается и заканчивается процедура
*/

# Задание 1. 
# Процедура, которая по id сотрудника выводит какая у него ЗП (высокая, средняя, низкая)

# создание процедуры get_status
DROP PROCEDURE IF EXISTS get_status;
delimiter $$
CREATE PROCEDURE get_status
(
IN staff_number INT,
OUT staff_status VARCHAR(45)
)
BEGIN 
	DECLARE staff_salary DOUBLE;   # DOUBLE - тип данных + создали переменную staff_salary
	SELECT salary INTO staff_salary
	FROM staff
    WHERE staff_number = id;
	IF staff_salary BETWEEN 0 AND 49999
		THEN SET staff_status = 'Средняя ЗП';
	ELSEIF staff_salary BETWEEN 50000 AND 69999
		THEN SET staff_status = 'ЗП выше средней';
	ELSEIF staff_salary >= 70000
		THEN SET staff_status = 'Высокая ЗП';
	END IF;   # END IF - закрыли IF
    
END $$        # END - закрыли BEGIN, $$ - закрыли delimier
    
-- ВЫЗОВ ПРОЦЕДУРЫ 
# создаем переменную
CALL get_status(4, @res_out); # IN - 4 (id сотрудника), OUT - @res_out (результат процедуры)
  
# выводим переменную    
SELECT @res_out; 


-- ФУНКЦИИ

# Задание 2.
# Функция, которая возвращает количество лет по дате рождения

# встроенная функция - возвращает текущее время и дату
SELECT now();

# создание функции
DROP FUNCTION IF EXISTS get_age;
delimiter $$
CREATE FUNCTION get_age
(
date_birth DATE,      # то, что передаем в функцию
current_t DATETIME    # то, что она возвращает
)
RETURNS INT           # RETURNS - какой тип данных возвращаем
deterministic         # deterministic - при запуске с одними и теми же параметрами - будет выдавать один и тот же результат
RETURN(year(current_t) - year(date_birth));  # RETURN - что возвращаем
$$ # закрыли delimiter  
 
SELECT get_age('1983-09-04', now()) AS 'Возраст';
  
  
-- ПРОЦЕДУРА С ЦИКЛОМ  
  
# Задание 3.
# Вывести последовательность чисел '10 9 8 7 6 5 4 3 2 1 '

DROP PROCEDURE IF EXISTS print_number;
delimiter $$
CREATE PROCEDURE print_number
( 
input_number INT   
)
BEGIN 
DECLARE n INT;
DECLARE result VARCHAR(45) DEFAULT "";
SET n = input_number;
REPEAT  # REPEAT - запускаем цикл
	SET result = concat(result, n, " "); # concat(result, n) - слединяем числа через пробел
	SET n = n - 1;
	UNTIL n <= 0 # UNTIL - как WHILE
END REPEAT; # закрыли REPEAT
SELECT result; # вывели result
END $$ # закрыли BEGIN и delimiter

# Вызов процедуры
CALL print_number(10);
