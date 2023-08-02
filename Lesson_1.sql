USE Lesson_1;

CREATE TABLE IF NOT EXISTS teacher
(
teacher_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
post VARCHAR(50)
);

INSERT INTO teacher (name, post) VALUES 
('Смит', 'Профессор'),
('Адамс', 'Ассистент');

SELECT * FROM teacher;

CREATE TABLE IF NOT EXISTS student
(
student_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50),
course_name VARCHAR(50),
email VARCHAR(50),
phone_number VARCHAR(50)
);

INSERT INTO student (name, course_name, email, phone_number) VALUES 
('Том', 'Математика', 'tom@tom.com', '983-2842-22'),
('Сэм', 'Математика', 'sem@tom.com', '983-4342-22'),
('Bob', 'Алгоритмы', 'bob@tom.com', '393-2842-22');

SELECT * FROM student;

CREATE TABLE IF NOT EXISTS course
(
name VARCHAR(50),
student_name VARCHAR(50),
teacher_name VARCHAR(50)
);

INSERT INTO course(name, student_name, teacher_name) VALUES 
('Математика', 'Том', 'Смит'), 
('Математика', 'Сэм', 'Смит'), 
('Алгоритмы', 'Боб', 'Адамс');


SELECT * FROM student;

SELECT * FROM student
WHERE name = 'Сэм';

SELECT name, course_name
FROM student;

SELECT *
FROM student
WHERE name LIKE 'B%'; 
