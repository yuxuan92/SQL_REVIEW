/*SELECT*/
SELECT * FROM teachers;

SELECT last_name, first_name, salary FROM teachers;

/*DISTINCT*/
SELECT DISTINCT school
	FROM teachers;

SELECT DISTINCT school, salary
	FROM teachers;

/*ORDER BY, DESC, ASC*/
SELECT first_name, last_name, salary
	FROM teachers
	ORDER BY salary DESC, hire_date ASC;

/*WHERE*/
SELECT last_name, school, hire_date
	FROM teachers
	WHERE school = 'Myers Middle School';

/* =, <>, !=, >, <, >=, <=, BETWEEN, IN, LIKE(分大小寫), ILIKE(不分大小寫), NOT */
SELECT school
	FROM teachers
	WHERE school != 'F.D. Roosevelt HS';

SELECT first_name, last_name, hire_date
	FROM teachers
	WHERE salary >= 43500;

SELECT first_name, last_name, school, salary
	FROM teachers
	WHERE salary BETWEEN 40000 AND 65000;

SELECT first_name
	FROM teachers
	WHERE first_name LIKE 'sam%';

SELECT first_name
	FROM teachers
	WHERE first_name ILIKE 'sam%';

/* AND, OR */
SELECT *
	FROM teachers
	WHERE school = 'Myers Middle School' AND
		salary < 40000;

SELECT *
	FROM teachers
	WHERE last_name = 'Cole' OR
		last_name = 'Bush';

SELECT *
	FROM teachers
	WHERE school = 'F.D. Roosevelt HS' AND
		(salary < 38000 OR salary >40000);

/* _(一個底線代表一個字元) , %(萬用字元) */
SELECT first_name, last_name, school, hire_date, salary
	FROM teachers
	WHERE school LIKE '%Roos%'
	ORDER BY hire_date DESC;
