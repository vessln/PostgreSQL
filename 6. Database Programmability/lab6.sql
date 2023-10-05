1. Count Employees by Town:

CREATE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT AS
$$
DECLARE count_empl INT;
	BEGIN
		SELECT
			COUNT(e.employee_id)
		FROM employees AS e
				JOIN addresses AS a
					USING(address_id)
						JOIN towns AS t
							USING(town_id)
		WHERE t.name = town_name
		INTO count_empl;
		RETURN count_empl;
	END;
$$
LANGUAGE plpgsql;

# or

CREATE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT AS
$$
DECLARE count_empl INT;
	BEGIN
	RETURN(
		SELECT
			COUNT(e.employee_id)
		FROM employees AS e
				JOIN addresses AS a
					USING(address_id)
						JOIN towns AS t
							USING(town_id)
		WHERE t.name = town_name
		);
	END;
$$
LANGUAGE plpgsql;


2. Employees Promotion:

CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR)
AS
$$
	BEGIN
		UPDATE employees
		SET salary = salary * 1.05
		WHERE employees.department_id = (SELECT d.department_id FROM departments AS d
							   			WHERE d.name = department_name);
	END;
$$
LANGUAGE plpgsql;

# or

CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR)
AS
$$
	BEGIN
		UPDATE employees
		SET salary = salary * 1.05
		WHERE department_id = (SELECT
									d.department_id
								FROM employees AS e
								JOIN departments AS d
									USING(department_id)
							   	WHERE d.name = department_name
								GROUP BY d.department_id);
	END;
$$
LANGUAGE plpgsql;


3. Employees Promotion By ID:

CREATE PROCEDURE sp_increase_salary_by_id(id INT)
AS
$$
	BEGIN
		IF (SELECT salary FROM employees WHERE employee_id = id) IS NULL THEN
			RETURN;
		ELSE
			UPDATE employees
			SET salary = salary * 1.05
			WHERE employee_id = id;
		END IF;
		COMMIT;
	END;
$$
LANGUAGE plpgsql;


4. Triggered:

CREATE TABLE deleted_employees(
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    middle_name VARCHAR(20),
    job_title VARCHAR(50),
    department_id INT,
    salary NUMERIC(19,4)
);

CREATE FUNCTION save_deleted_employees()
RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO deleted_employees
        (first_name,
        last_name,
        middle_name,
        job_title,
        department_id,
        salary)
    VALUES
		(OLD.first_name,
        OLD.last_name,
        OLD.middle_name,
        OLD.job_title,
        OLD.department_id,
        OLD.salary);
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER del_empl_trigger
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE save_deleted_employees();

