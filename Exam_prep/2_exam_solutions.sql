1.1. Database Design:

CREATE TABLE addresses(
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(100) NOT NULL
);

CREATE TABLE categories(
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(10) NOT NULL
);

CREATE TABLE clients(
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	age INTEGER NOT NULL CHECK (age > 0),
	rating NUMERIC(5, 2) DEFAULT 5.5
);

CREATE TABLE cars(
	id SERIAL PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
	model VARCHAR(20),
	year INTEGER NOT NULL DEFAULT 0 CHECK (year > 0),
	mileage INTEGER DEFAULT 0 CHECK (mileage > 0),
	condition CHAR(1) NOT NULL,
	category_id INTEGER NOT NULL,

	CONSTRAINT fk_cars_categories
	FOREIGN KEY (category_id)
		REFERENCES categories(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE courses(
	id SERIAL PRIMARY KEY,
	from_address_id INTEGER NOT NULL,
	start TIMESTAMP NOT NULL,
	bill NUMERIC(10, 2) DEFAULT 10 CHECK (bill > 0),
	car_id INTEGER NOT NULL,
	client_id INTEGER NOT NULL,

	CONSTRAINT fk_courses_addresses
	FOREIGN KEY (from_address_id)
		REFERENCES addresses(id)
			ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_courses_cars
	FOREIGN KEY (car_id)
		REFERENCES cars(id)
			ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_courses_clients
	FOREIGN KEY (client_id)
		REFERENCES clients(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE cars_drivers(
	car_id INTEGER NOT NULL,
	driver_id INTEGER NOT NULL,

	CONSTRAINT fk_cars_drivers_cars
	FOREIGN KEY (car_id)
		REFERENCES cars(id)
			ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_cars_drivers_drivers
	FOREIGN KEY (driver_id)
		REFERENCES drivers(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);


2.2. Insert:

INSERT INTO clients(full_name, phone_number)
SELECT
	CONCAT(d.first_name, ' ', d.last_name),
	'(088) 9999' || d.id * 2
FROM drivers AS d
WHERE id BETWEEN 10 AND 20;


2.3. Update:

UPDATE cars
SET condition = 'C'
WHERE (cars.mileage >= 800000 OR cars.mileage IS NULL)
	AND cars.year <= 2010
	AND cars.make <> 'Mercedes-Benz';


2.4. Delete:

DELETE FROM clients
WHERE NOT EXISTS (
	SELECT *
	FROM courses AS co
	WHERE clients.id = co.client_id)
AND LENGTH(full_name) > 3;


3.5. Cars:

SELECT
	make,
	model,
	condition
FROM cars
ORDER BY id ASC;


3.6. Drivers and Cars:

SELECT
	d.first_name,
	d.last_name,
	c.make,
	c.model,
	c.mileage
FROM drivers AS d
JOIN cars_drivers AS cd
	ON cd.driver_id = d.id
		JOIN cars AS c
			ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name ASC;


3.7. Number of Courses for Each Car:

SELECT
	ca.id AS "car_id",
	ca.make,
	ca.mileage,
	COUNT(c.id) AS "count_of_courses",
	ROUND(AVG(c.bill), 2) AS "average_bill"
FROM
    cars AS ca
LEFT JOIN courses AS c
    ON c.car_id = ca.id
GROUP BY ca.id
HAVING COUNT(c.id) <> 2
ORDER BY "count_of_courses" DESC, ca.id;


3.8. Regular Clients:

SELECT
	cl.full_name,
	COUNT(co.car_id) AS "count_of_cars",
	SUM(co.bill) AS "total_sum"
FROM
	clients AS cl
JOIN courses AS co
    ON co.client_id = cl.id
WHERE cl.full_name LIKE '_a%'
GROUP BY cl.full_name
HAVING COUNT(co.car_id) > 1
ORDER BY cl.full_name ASC;


3.9. Full Information of Courses:

SELECT
	a.name AS "address",
	CASE
		WHEN EXTRACT('hour' FROM c.start) BETWEEN 6 AND 20 THEN 'Day'
		ELSE 'Night'
	END AS "day_time",
	c.bill,
	cl.full_name,
	ca.make,
	ca.model,
	ct.name AS "category_name"
FROM
	addresses AS a
JOIN courses AS c
	ON a.id = c.from_address_id
		JOIN clients AS cl
			ON cl.id = c.client_id
				JOIN cars AS ca
					ON ca.id = c.car_id
						JOIN categories AS ct ON ct.id = ca.category_id
ORDER BY c.id;

4.10. Find all Courses by Client’s Phone Number:



4.11. Full Info for Address:

