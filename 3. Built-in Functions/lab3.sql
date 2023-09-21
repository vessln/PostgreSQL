1. Find Book Titles:

SELECT
	title
FROM books
WHERE SUBSTRING(title, 1, 3) = 'The'
ORDER BY id;


2. Replace Titles:

SELECT
	REPLACE(title, SUBSTRING(title, 1, 3), '***')
FROM
	books
WHERE SUBSTRING(title, 1, 3) = 'The';


3. Triangles on Bookshelves:

SELECT
	id,
	side * height / 2 AS "area"
FROM triangles;


4. Format Costs:

SELECT
	title,
	ROUND(cost, 3) AS "modified_price"
FROM books
ORDER BY id;


5. Year of Birth:

SELECT
	first_name,
	last_name,
	EXTRACT('year' FROM born) AS "year"
FROM authors;

# or

SELECT
	first_name,
	last_name,
	TO_CHAR(born, 'YYYY') AS "year"
FROM authors;


6. Format Date of Birth:

SELECT
	last_name AS "Last Name",
	TO_CHAR(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
FROM authors;


7. Harry Potter Books:

SELECT
	title
FROM books
WHERE title LIKE '%Harry Potter%'
ORDER BY id;
