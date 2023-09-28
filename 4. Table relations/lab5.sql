1. Mountains and Peaks:

CREATE TABLE mountains(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE peaks(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	mountain_id INT,
	CONSTRAINT fk_peaks_mountains
		FOREIGN KEY (mountain_id)
			REFERENCES mountains(id)
);


2. Trip Organization:

SELECT
	v.driver_id,
	v.vehicle_type,
	CONCAT(c.first_name, ' ', c.last_name) AS "driver_name"
FROM vehicles AS v
JOIN campers AS c
	ON v.driver_id = c.id;


3. SoftUni Hiking:

SELECT
	r.start_point,
	r.end_point,
	r.leader_id,
	CONCAT(ca.first_name, ' ', ca.last_name) AS "leader_name"
FROM routes AS r
JOIN campers AS ca
	ON r.leader_id = ca.id;


4. Delete Mountains:

CREATE TABLE mountains(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE peaks(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	mountain_id INTEGER,
	CONSTRAINT fk_mountain_id
		FOREIGN KEY (mountain_id)
			REFERENCES mountains(id) ON DELETE CASCADE
);


5.

CREATE TABLE clients(
	id SERIAL PRIMARY KEY,
	name VARCHAR(10)
);

CREATE TABLE employees(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30),
	last_name VARCHAR(30),
	project_id INT
);

CREATE TABLE projects(
	id SERIAL PRIMARY KEY,
	client_id INTEGER,
	project_lead_id INTEGER,

	CONSTRAINT fk_client_id
		FOREIGN KEY (client_id)
			REFERENCES clients(id),

	CONSTRAINT fk_project_lead_id
		FOREIGN KEY (project_lead_id)
			REFERENCES employees(id)
);

ALTER table employees
ADD CONSTRAINT fk_project_id
	FOREIGN KEY (project_id)
		REFERENCES projects(id);




