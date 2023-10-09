1.1. Database Design:

CREATE TABLE owners(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50)
);

CREATE TABLE animal_types(
	id INT GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
	animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE cages(
	id SERIAL PRIMARY KEY,
	animal_type_id INT NOT NULL,

	CONSTRAINT fk_cages_animal_types
		FOREIGN KEY (animal_type_id)
			REFERENCES animal_types(id)
				ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE animals(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	birthdate DATE NOT NULL,
	owner_id INT,
	animal_type_id INT NOT NULL,

	CONSTRAINT fk_animals_owners
		FOREIGN KEY (owner_id)
			REFERENCES owners(id)
				ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_animals_animal_types
		FOREIGN KEY (animal_type_id)
			REFERENCES animal_types(id)
				ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE volunteers_departments(
	id SERIAL PRIMARY KEY,
	department_name VARCHAR(30) NOT NULL
);

CREATE TABLE volunteers(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(15) NOT NULL,
	address VARCHAR(50),
	animal_id INT,
	department_id INT NOT NULL,

	CONSTRAINT fk_volunteers_animals
		FOREIGN KEY (animal_id)
			REFERENCES animals(id)
				ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_volunteers_volunteers_departments
		FOREIGN KEY (department_id)
			REFERENCES volunteers_departments(id)
				ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE animals_cages(
	cage_id INT NOT NULL,
	animal_id INT NOT NULL,

	CONSTRAINT fk_animals_cages_cages
		FOREIGN KEY (cage_id)
			REFERENCES cages(id)
				ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_animals_cages_animals
		FOREIGN KEY (animal_id)
			REFERENCES animals(id)
				ON UPDATE CASCADE ON DELETE CASCADE
);


2.2. Insert:

INSERT INTO volunteers(name, phone_number, address, animal_id, department_id)
VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223',	NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5);

INSERT INTO animals(name, birthdate, owner_id, animal_type_id)
VALUES
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4);


2.3. Update:

UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE name LIKE 'Kaloqn Stoqnov')
WHERE owner_id IS NULL;


2.4. Delete:

DELETE FROM volunteers_departments
WHERE department_name LIKE 'Education program assistant';


3.5. Volunteers:

SELECT
	name,
	phone_number,
	address,
	animal_id,
	department_id
FROM volunteers
ORDER BY "name" ASC, department_id ASC;


3.6. Animals Data:

SELECT
	a.name,
	at.animal_type,
	TO_CHAR(a.birthdate, 'DD.MM.YYYY')
FROM animals AS a
	JOIN animal_types AS at
		ON at.id = a.animal_type_id
ORDER BY a.name;


3.7. Owners and Their Animals:

SELECT
	o.name AS "owner",
	COUNT(a.id) AS "count_of_animals"
FROM owners AS o
	JOIN animals AS a
		ON o.id = a.owner_id
GROUP BY o.name
ORDER BY COUNT(a.id) DESC, o.name ASC
LIMIT 5;


3.8. Owners, Animals and Cages:

SELECT
	CONCAT_WS(' ', o.name, '-', a.name) AS "Owners - Animals",
	o.phone_number AS "Phone Number",
	ac.cage_id AS "Cage ID"
FROM owners AS o
	JOIN animals AS a ON o.id = a.owner_id
		JOIN animals_cages AS ac ON ac.animal_id = a.id
WHERE a.animal_type_id = 1
ORDER BY o.name ASC, a.name DESC;


3.9. Volunteers in Sofia:

SELECT
	v.name,
	v.phone_number,
	LTRIM(v.address, 'Sofia ,') AS "address"
FROM volunteers AS v
	JOIN volunteers_departments AS vd ON vd.id = v.department_id
WHERE vd.department_name LIKE 'Education program assistant'
	AND v.address LIKE '%Sofia%'
ORDER BY v.name ASC;


3.10. Animals for Adoption:

SELECT
	a.name AS "animal",
	TO_CHAR(a.birthdate, 'YYYY') AS "birth_year",
	at.animal_type
FROM animals AS a JOIN animal_types AS at
	ON at.id = a.animal_type_id
WHERE at.animal_type <> 'Birds'
    AND a.owner_id IS NULL
    AND a.birthdate > '01/01/2022'::DATE - INTERVAL '5 years'
ORDER BY a.name ASC;


4.11. All Volunteers in a Department:

CREATE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department VARCHAR(30))
RETURNS INTEGER AS
$$
BEGIN
	RETURN (SELECT
		COUNT(v.id)
	FROM volunteers AS v
		JOIN volunteers_departments AS vd
			ON vd.id = v.department_id
	WHERE vd.department_name = searched_volunteers_department);
END;
$$
LANGUAGE plpgsql;


4.12. Animals with Owner or Not:

CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not(
	IN animal_name VARCHAR(30),
	OUT owner_name VARCHAR(50))
AS
$$
BEGIN
	SELECT
		COALESCE(o.name, 'For adoption') INTO owner_name
	FROM owners AS o
	RIGHT JOIN animals AS a ON o.id = a.owner_id
	WHERE a.name = animal_name;
END;
$$
LANGUAGE plpgsql;

# CALL sp_animals_with_owners_or_not('Brown bear', '')