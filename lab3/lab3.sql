use bd_course; 

-- 1. INSERT
-- 1.1. Без указания списка полей
   INSERT INTO employee VALUES ('1', 'Andrey', 'Tokarev', 'QA engineer', 'tokarinze@gmail.com' );

--  1.2. Ñ óêàçàíèåì ñïèñêà ïîëåé
  	INSERT INTO project (title, cost, start_date, ending_date) VALUES ('BD course', '1000000000', '11-12-20', '12-10-28');

--  3. Ñ ÷òåíèåì çíà÷åíèÿ èç äðóãîé òàáëèöû
  	INSERT INTO unemployed (first_name, last_name, position) SELECT first_name, last_name, position FROM employee;

-- 2. DELETE
-- 1. Âñåõ çàïèñåé
   DELETE unemployed;
-- 2. Ïî óñëîâèþ
   DELETE FROM unemployed WHERE first_name = 'Andrey';
-- 3. Î÷èñòèòü òàáëèöó
   TRUNCATE TABLE unemployed;

-- 3. UPDATE
-- 1. Âñåõ çàïèñåé
   UPDATE employee SET position = 'fired';
-- 2. Ïî óñëîâèþ îáíîâëÿÿ îäèí àòðèáóò
   UPDATE employee SET position = 'Middle developer' WHERE position = 'Junior developer';
-- 3. Ïî óñëîâèþ îáíîâëÿÿ íåñêîëüêî àòðèáóòîâ
   UPDATE employee SET position = 'Rockstar', email='johnyrockstar@gmail.com' WHERE first_name = 'John' AND last_name='Dohn';

-- 4. SELECT
--	1. Ñ îïðåäåëåííûì íàáîðîì èçâëåêàåìûõ àòðèáóòîâ (SELECT atr1, atr2 FROM...)
	SELECT first_name, last_name, position, email FROM employee;
--	2. Ñî âñåìè àòðèáóòàìè (SELECT * FROM...)
	SELECT * FROM project;
--	3. Ñ óñëîâèåì ïî àòðèáóòó (SELECT * FROM ... WHERE atr1 = "")
	SELECT * FROM project WHERE cost < 100000000;

	-- 5. SELECT ORDER BY + TOP (LIMIT)
--  1. Ñ ñîðòèðîâêîé ïî âîçðàñòàíèþ ASC + îãðàíè÷åíèå âûâîäà êîëè÷åñòâà çàïèñåé
	SELECT TOP 5 * FROM project ORDER BY cost ASC;
--  2. Ñ ñîðòèðîâêîé ïî óáûâàíèþ DESC
	SELECT TOP 5 * FROM employee ORDER BY last_name DESC;
--  3. Ñ ñîðòèðîâêîé ïî äâóì àòðèáóòàì + îãðàíè÷åíèå âûâîäà êîëè÷åñòâà çàïèñåé
	SELECT TOP 5 * FROM employee ORDER BY first_name, last_name DESC;
--  4. Ñ ñîðòèðîâêîé ïî ïåðâîìó àòðèáóòó, èç ñïèñêà èçâëåêàåìûõ
	SELECT TOP 5 * FROM employee ORDER BY 1;

-- 6. Ðàáîòà ñ äàòàìè. Íåîáõîäèìî, ÷òîáû îäíà èç òàáëèö ñîäåðæàëà àòðèáóò ñ òèïîì DATETIME.
--  1. WHERE ïî äàòå
	SELECT * FROM project WHERE start_date = '19/09/2012 00:00:00';
--  2. Èçâëå÷ü èç òàáëèöû íå âñþ äàòó, à òîëüêî ãîä. Íàïðèìåð, ãîä ðîæäåíèÿ àâòîðà.
	SELECT title, YEAR(start_date) AS start_date FROM project;

	-- 7. SELECT GROUP BY ñ ôóíêöèÿìè àãðåãàöèè
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
--  1. Íàïèñàòü 3 ðàçíûõ çàïðîñà ñ èñïîëüçîâàíèåì GROUP BY + HAVING
	SELECT start_date FROM project GROUP BY start_date HAVING start_date < '19/09/2020 00:00:00';
	SELECT title FROM project GROUP BY title HAVING MAX(cost) > 1000000;
	SELECT title FROM project GROUP BY title HAVING COUNT(title) > 1;

-- 9. SELECT JOIN
--  1. LEFT JOIN äâóõ òàáëèö è WHERE ïî îäíîìó èç àòðèáóòîâ
	SELECT * FROM employee LEFT JOIN project_participation ON employee.id_employee = project_participation.id_employee WHERE employee.id_employee > 2;
--  2. RIGHT JOIN. Ïîëó÷èòü òàêóþ æå âûáîðêó, êàê è â 9.1
	SELECT * FROM project_participation RIGHT JOIN employee ON employee.id_employee = project_participation.id_employee WHERE employee.id_employee > 2;
--  3. LEFT JOIN òðåõ òàáëèö + WHERE ïî àòðèáóòó èç êàæäîé òàáëèöû
	SELECT 
		employee.id_employee, employee.last_name, 
		project_participation.id_project, project_participation.id_employee, 
		project.id_project, project.title
	FROM
		employee LEFT JOIN project_participation ON employee.id_employee = project_participation.id_employee
    LEFT JOIN project ON project.id_project = project_participation.id_project
    WHERE employee.last_name = 'Holmes' AND employee.id_employee > 2 AND project.cost > 10000;
--  4. FULL OUTER JOIN äâóõ òàáëèö
	SELECT * FROM project FULL OUTER JOIN employee ON project.id_project = employee.id_employee;

-- 10. Ïîäçàïðîñû
--  1. Íàïèñàòü çàïðîñ ñ WHERE IN (ïîäçàïðîñ)
	SELECT * FROM project WHERE cost IN ('100000', '1000000');
	--  2. Íàïèñàòü çàïðîñ SELECT atr1, atr2, (ïîäçàïðîñ) FROM ...    

	SELECT title, cost FROM project where start_date in('12/11/2020', '16/03/2030');



	 
