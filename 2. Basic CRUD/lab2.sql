1. Select Employee Information:

SELECT
	id,
	concat(first_name, ' ', last_name) AS "Full Name",
	job_title AS "Job Title"
FROM
	employees;


2. Select Employees by Filtering:

SELECT
	id,
	concat(first_name, ' ', last_name) AS full_name,
	job_title,
	salary
FROM
	employees
WHERE
	salary > 1000.00
ORDER BY id;


3. Select Employees by Multiple Filters:

SELECT * FROM employees
WHERE
	salary >= 1000.00
AND
	department_id = 4
ORDER BY id;


4. Insert Data into Employees Table:

INSERT INTO employees
	(first_name,
	 last_name,
	 job_title,
	 department_id,
	 salary)
VALUES
	('Samantha', 'Young', 'Housekeeping', 4, 900),
	('Roger', 'Palmer', 'Waiter', 3, 928.33);

SELECT * FROM employees;


5. Update Salary and Select:

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';

SELECT *
FROM employees
WHERE job_title = 'Manager';


6. Delete from Table:

DELETE FROM employees
WHERE
	department_id = 2
OR
	department_id = 1;

SELECT * FROM employees
ORDER BY id;


7. Top Paid Employee View:

CREATE VIEW top_paid_employee AS
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT * FROM top_paid_employee;