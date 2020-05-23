use bd_course; 

-- 1. INSERT
-- 1.1. ��� �������� ������ �����
   INSERT INTO employee VALUES ('1', 'Andrey', 'Tokarev', 'QA engineer', 'tokarinze@gmail.com' );

--  1.2. � ��������� ������ �����
  	INSERT INTO project (title, cost, start_date, ending_date) VALUES ('BD course', '1000000000', '11-12-20', '12-10-28');

--  3. � ������� �������� �� ������ �������
  	INSERT INTO unemployed (first_name, last_name, position) SELECT first_name, last_name, position FROM employee;

-- 2. DELETE
-- 1. ���� �������
   DELETE unemployed;
-- 2. �� �������
   DELETE FROM unemployed WHERE first_name = 'Andrey';
-- 3. �������� �������
   TRUNCATE TABLE unemployed;

-- 3. UPDATE
-- 1. Всех записей
   UPDATE position SET title = 'fired';
-- 2. По условию обновляя один атрибут
   UPDATE position SET title = 'Middle developer' WHERE title = 'Junior developer';
-- 3. По условию обновляя несколько атрибутов
   UPDATE position SET title = 'Rockstar', salary='1000000' WHERE skills = 'guitar, drags, c++';

-- 4. SELECT
--	1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
	SELECT first_name, last_name, email FROM employee;
--	2. Со всеми атрибутами (SELECT * FROM...)
	SELECT * FROM project;
--	3. � �������� �� �������� (SELECT * FROM ... WHERE atr1 = "")
	SELECT * FROM project WHERE cost < 100000000;

	-- 5. SELECT ORDER BY + TOP (LIMIT)
--  1. � ����������� �� ����������� ASC + ����������� ������ ���������� �������
	SELECT TOP 5 * FROM project ORDER BY cost ASC;
--  2. � ����������� �� �������� DESC
	SELECT TOP 5 * FROM employee ORDER BY last_name DESC;
--  3. � ����������� �� ���� ��������� + ����������� ������ ���������� �������
	SELECT TOP 5 * FROM employee ORDER BY first_name, last_name DESC;
--  4. � ����������� �� ������� ��������, �� ������ �����������
	SELECT TOP 5 * FROM employee ORDER BY 1;

-- 6. ������ � ������. ����������, ����� ���� �� ������ ��������� ������� � ����� DATETIME.
--  1. WHERE �� ����
	SELECT * FROM project WHERE start_date = '19/09/2012 00:00:00';
--  2. ������� �� ������� �� ��� ����, � ������ ���. ��������, ��� �������� ������.
	SELECT title, YEAR(start_date) AS start_date FROM project;

	-- 7. SELECT GROUP BY � ��������� ���������
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
--  1. �������� 3 ������ ������� � �������������� GROUP BY + HAVING
	SELECT start_date FROM project GROUP BY start_date HAVING start_date < '19/09/2020 00:00:00';
	SELECT title FROM project GROUP BY title HAVING MAX(cost) > 1000000;
	SELECT id_project_participation, COUNT(*) as projects_number 
	FROM project_participation 
	GROUP BY id_project_participation 
	HAVING MAX(id_employee) >= 3;

-- 9. SELECT JOIN
--  1. LEFT JOIN ���� ������ � WHERE �� ������ �� ���������
	SELECT * FROM employee LEFT JOIN project_participation ON employee.id_employee = project_participation.id_employee WHERE employee.id_employee > 2;
--  2. RIGHT JOIN. �������� ����� �� �������, ��� � � 9.1
	SELECT * FROM project_participation RIGHT JOIN employee ON employee.id_employee = project_participation.id_employee WHERE employee.id_employee > 2;
--  3. LEFT JOIN ���� ������ + WHERE �� �������� �� ������ �������
	SELECT 
		employee.id_employee, employee.last_name, 
		project_participation.id_project, project_participation.id_employee, 
		project.id_project, project.title
	FROM
		employee LEFT JOIN project_participation ON employee.id_employee = project_participation.id_employee
    LEFT JOIN project ON project.id_project = project_participation.id_project
    WHERE employee.last_name = 'Holmes' AND employee.id_employee > 2 AND project.cost > 10000;
--  4. FULL OUTER JOIN ���� ������
	SELECT * FROM project FULL OUTER JOIN employee ON project.id_project = employee.id_employee;

-- 10. ����������
--  1. �������� ������ � WHERE IN (���������)
	SELECT * FROM project WHERE cost IN ('100000', '1000000');
	--  2. �������� ������ SELECT atr1, atr2, (���������) FROM ...    

	SELECT title, cost FROM project where start_date in('12/11/2020', '16/03/2030');



	 
