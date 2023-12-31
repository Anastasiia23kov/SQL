# Задание 1.
# Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней часов.
# Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

DROP FUNCTION IF EXISTS sec_in_days;
delimiter $$
CREATE FUNCTION sec_in_days
(
sec INT
)
RETURNS VARCHAR(40)
deterministic
RETURN concat(round((sec / 86400), 0), " days ",  # days
round((sec / 3600) - (24 * round((sec / 86400), 0)), 0), " hours ",  # hours
round((sec / 60), 0) - 60 * (24 * round((sec / 86400), 0) + (round((sec / 3600) - (24 * round((sec / 86400), 0)), 0))) - 1, " minutes ", # minutes
sec - 86400*(round((sec / 86400), 0)) 
- 3600 *round((sec / 3600) - (24 * round((sec / 86400), 0)), 0) 
- 60 * (round((sec / 60), 0) - 60 * (24 * round((sec / 86400), 0) + (round((sec / 3600) - (24 * round((sec / 86400), 0)), 0))) - 1), " seconds" # seconds
);
$$
SELECT sec_in_days(123456);


# Задание 2.
# Выведите только четные числа от 1 до 10. Пример: 2,4,6,8,10

DROP PROCEDURE IF EXISTS even_numbers;
delimiter $$
CREATE PROCEDURE even_numbers()        # процедура ничего не принимает
BEGIN                                  # начинаю процедуру
DECLARE n INT;                         # задаю переменную n 
DECLARE result VARCHAR(45) DEFAULT ""; # задаю переменную result = ""
SET n = 2;                             # присваиваю премеменной n значение 2
REPEAT                                 # запускаю цикл
	SET result = concat(result, n, " "); # 'склеиваю' результаты (значения n) в одну строку
	SET n = n + 2;                     # увеличиваю переменную n 
    UNTIl n > 10                       # цикл работает до условия n > 10
END REPEAT;	                           # заканчиваю цикл REPEAT
SELECT result;                         # вывожу result
END $$                                 # закрываю BEGIN и delimiter

# Вызов процедуры
CALL even_numbers();                   # ничего не передаю в процедуру