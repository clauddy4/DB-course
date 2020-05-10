use bd_course; 

-- 1. INSERT
-- 1.1. Без указания списка полей
   INSERT INTO employee VALUES ('1', 'Andrey', 'Tokarev', 'QA engineer', 'tokarinze@gmail.com' );

--  1.2. С указанием списка полей
  	INSERT INTO project (title, cost, start_date, ending_date) VALUES ('BD course', '1000000000', '11-12-20', '12-10-28');

--  3. С чтением значения из другой таблицы
  	INSERT INTO unemployed (first_name, last_name, position) SELECT first_name, last_name, position FROM employee;

-- 2. DELETE
-- 1. Всех записей
   DELETE unemployed;
-- 2. По условию
   DELETE FROM unemployed WHERE first_name = 'Andrey';
-- 3. Очистить таблицу
   TRUNCATE TABLE unemployed;

-- 3. UPDATE
-- 1. Всех записей
   UPDATE employee SET position = 'fired';
-- 2. По условию обновляя один атрибут
   UPDATE employee SET position = 'Middle developer' WHERE position = 'Junior developer';
-- 3. По условию обновляя несколько атрибутов
   UPDATE employee SET position = 'Rockstar', email='johnyrockstar@gmail.com' WHERE first_name = 'John' AND last_name='Dohn';

-- 4. SELECT
--	1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
	SELECT first_name, last_name, position, email FROM employee;
--	2. Со всеми атрибутами (SELECT * FROM...)
	SELECT * FROM project;
--	3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
	SELECT * FROM project WHERE cost < 100000000;

	-- 5. SELECT ORDER BY + TOP (LIMIT)
--  1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
	SELECT TOP 5 * FROM project ORDER BY cost ASC;
--  2. С сортировкой по убыванию DESC
	SELECT TOP 5 * FROM employee ORDER BY last_name DESC;
--  3. С сортировкой по двум атрибутам + ограничение вывода количества записей
	SELECT TOP 5 * FROM employee ORDER BY first_name, last_name DESC;
--  4. С сортировкой по первому атрибуту, из списка извлекаемых
	SELECT TOP 5 * FROM employee ORDER BY 1;

-- 6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
--  1. WHERE по дате
	SELECT * FROM project WHERE start_date = '19/09/2012 00:00:00';
--  2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
	SELECT title, YEAR(start_date) AS start_date FROM project;

	-- 7. SELECT GROUP BY с функциями агрегации
--  1. MIN
	SELECT title, MIN(cost) AS min_cost FROM project GROUP BY title;
--  2. MAX
	SELECT title, MAX(cost) AS max_cost FROM project GROUP BY title;
--  3. AVG
	SELECT title, AVG(cost) AS avg_cost FROM project GROUP BY title;
--  4. SUM
	SELECT title, SUM(cost) AS sum_cost FROM project GROUP BY title;
--  5. COUNT
	SELECT title, COUNT(title) AS count FROM project GROUP BY title;

-- 8. SELECT GROUP BY + HAVING
--  1. Написать 3 разных запроса с использованием GROUP BY + HAVING
	SELECT start_date FROM project GROUP BY start_date HAVING start_date < '19/09/2020 00:00:00';
	SELECT title FROM project GROUP BY title HAVING MAX(cost) > 1000000;
	SELECT title FROM project GROUP BY title HAVING COUNT(title) > 1;

-- 9. SELECT JOIN
--  1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
	SELECT * FROM employee LEFT JOIN project_participation ON employee.id_employee = project_participation.id_employee WHERE employee.id_employee > 2;
--  2. RIGHT JOIN. Получить такую же выборку, как и в 9.1
	SELECT * FROM project_participation RIGHT JOIN employee ON employee.id_employee = project_participation.id_employee WHERE employee.id_employee > 2;
--  3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
	SELECT 
		employee.id_employee, employee.last_name, 
		project_participation.id_project, project_participation.id_employee, 
		project.id_project, project.title
	FROM
		employee LEFT JOIN project_participation ON employee.id_employee = project_participation.id_employee
    LEFT JOIN project ON project.id_project = project_participation.id_project
    WHERE employee.last_name = 'Holmes' AND employee.id_employee > 2 AND project.cost > 10000;
--  4. FULL OUTER JOIN двух таблиц
	SELECT * FROM project FULL OUTER JOIN employee ON project.id_project = employee.id_employee;

-- 10. Подзапросы
--  1. Написать запрос с WHERE IN (подзапрос)
	SELECT * FROM project WHERE cost IN ('100000', '1000000');
	--  2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...    

	SELECT title, cost FROM project where start_date in('12/11/2020', '16/03/2030');



	 
