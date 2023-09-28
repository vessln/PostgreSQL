1. PRIMARY KEY:

CREATE TABLE products(
	product_name VARCHAR(100)
);

INSERT INTO products(product_name)
VALUES ('Broccoli'),
		('Shampoo'),
		('Toothpaste'),
		('Candy');

ALTER TABLE products
ADD COLUMN id SERIAL PRIMARY KEY;


2. Remove Primary Key:

ALTER TABLE products
DROP CONSTRAINT products_pkey;


3. Customs:

CREATE TABLE passports(
	id INT GENERATED ALWAYS AS IDENTITY (START WITH 100 INCREMENT BY 1) PRIMARY KEY,
	nationality VARCHAR(50)
);

INSERT INTO passports(nationality)
VALUES ('N34FG21B'),
		('K65LO4R7'),
		('ZE657QP2');

CREATE TABLE people(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	salary NUMERIC(10, 2),
	passport_id INTEGER,

	CONSTRAINT fk_people_passports
		FOREIGN KEY (passport_id)
			REFERENCES passports(id)
);

INSERT INTO people(first_name, salary, passport_id)
VALUES ('Roberto', 43300.0000, 101),
		('Tom', 56100.0000, 102),
		('Yana', 60200.0000, 100);


4. Car Manufacture:

CREATE TABLE manufacturers(
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(30)
);

CREATE TABLE models(
	id INT GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1) PRIMARY KEY,
	model_name VARCHAR(30),
	manufacturer_id INTEGER,

	CONSTRAINT fk_models_manufacturers
		FOREIGN KEY (manufacturer_id)
			REFERENCES manufacturers(id)
);

CREATE TABLE production_years(
	id SERIAL PRIMARY KEY,
	established_on DATE,
	manufacturer_id INTEGER,

	CONSTRAINT fk_production_years_manufacturers
		FOREIGN KEY (manufacturer_id)
			REFERENCES manufacturers(id)
);

INSERT INTO manufacturers(name)
VALUES ('BMW'),
		('Tesla'),
		('Lada');

INSERT INTO models(model_name, manufacturer_id)
VALUES ('X1', 1),
		('i6', 1),
		('Model S', 2),
		('Model X', 2),
		('Model 3', 2),
		('Nova', 3);

INSERT INTO production_years(established_on, manufacturer_id)
VALUES('1916-03-01', 1),
		('2003-01-01', 2),
		('1966-05-01', 3);


6. Photo Shooting:

CREATE TABLE customers(
	id SERIAL PRIMARY KEY,
	"name" VARCHAR(30),
	"date" DATE
);

CREATE TABLE photos(
	id SERIAL PRIMARY KEY,
	url VARCHAR(50),
	place VARCHAR(50),
	customer_id INTEGER,

	CONSTRAINT fk_photos_customers
		FOREIGN KEY (customer_id)
			REFERENCES customers(id)
);

INSERT INTO customers(name, date)
VALUES('Bella', '2022-03-25'),
('Philip', '2022-07-05');

INSERT INTO photos(url, place, customer_id)
VALUES ('bella_1111.com', 'National Theatre', 1),
		('bella_1112.com', 'Largo', 1),
		('bella_1113.com', 'The View Restaurant', 1),
		('philip_1121.com', 'Old Town', 2),
		('philip_1122.com', 'Rowing Canal', 2),
		('philip_1123.com', 'Roman Theater', 2);


8. Study Session:

CREATE TABLE students(
	id SERIAL PRIMARY KEY,
	student_name VARCHAR(30)
);

CREATE TABLE exams(
	id INT GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1) PRIMARY KEY,
	exam_name VARCHAR(50)
);

CREATE TABLE study_halls(
	id SERIAL PRIMARY KEY,
	study_hall_name	VARCHAR(50),
	exam_id INTEGER,

	CONSTRAINT fk_students_halls_exams
		FOREIGN KEY (exam_id)
			REFERENCES exams(id)
);

CREATE TABLE students_exams(
	student_id INTEGER,
	exam_id INTEGER,

	CONSTRAINT fk_students_exams_students
		FOREIGN KEY (student_id)
			REFERENCES students(id),

	CONSTRAINT fk_students_exams_exams
		FOREIGN KEY (exam_id)
			REFERENCES exams(id)
);


INSERT INTO students(student_name)
VALUES('Mila'),
		('Toni'),
		('Ron');

INSERT INTO exams(exam_name)
VALUES('Python Advanced'),
		('Python OOP'),
		('PostgreSQL');

INSERT INTO study_halls(study_hall_name, exam_id)
VALUES
	('Open Source Hall', 102),
	('Inspiration Hall', 101),
	('Creative Hall', 103),
	('Masterclass Hall', 103),
	('Information Security Hall', 103);

INSERT INTO students_exams(student_id, exam_id)
VALUES
	(1, 101),
	(1, 102),
	(2, 101),
	(3, 103),
	(2, 102),
	(2, 103);


10. Online Store:


11. Delete Cascade:


12. Update Cascade:


13. SET NULL:


14. Peaks in Rila✶:


15. Countries Without Any Rivers✶: