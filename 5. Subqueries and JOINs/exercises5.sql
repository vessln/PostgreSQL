1. Booked for Nights:

SELECT
	CONCAT(a.address, ' ', a.address_2) AS "apartment_address",
	b.booked_for AS nights
FROM apartments AS a
INNER JOIN bookings AS b
	ON a.booking_id = b.booking_id
ORDER BY a.apartment_id ASC;


2. First 10 Apartments Booked At:

SELECT
	a."name",
	a.country,
	b."booked_at"::DATE
FROM apartments AS a
LEFT JOIN bookings AS b
	ON a.booking_id = b.booking_id
LIMIT 10;

# or

SELECT
	a."name",
	a.country,
	b."booked_at"::DATE
FROM apartments AS a
LEFT JOIN bookings AS b
	USING(booking_id)
LIMIT 10;


3. First 10 Customers with Bookings:

SELECT
	b.booking_id,
	b.starts_at::DATE,
	b.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS "customer_name"
FROM bookings AS b
RIGHT JOIN customers AS c
	ON b.customer_id = c.customer_id
ORDER BY "customer_name" ASC
LIMIT 10;


4. Booking Information

SELECT
	b.booking_id,
	a.name AS "apartment_owner",
	a.apartment_id,
	CONCAT(c.first_name, ' ', c.last_name) AS "customer_name"
FROM apartments AS a
FULL JOIN bookings AS b
	ON a.booking_id = b.booking_id
		FULL JOIN customers AS c
				ON b.customer_id = c.customer_id
ORDER BY booking_id ASC,
		apartment_owner ASC,
		customer_name ASC;


5. Multiplication of Information**:

SELECT
	b.booking_id,
	c.first_name
FROM bookings AS b
CROSS JOIN customers AS c
ORDER BY first_name ASC;


6. Unassigned Apartments:

SELECT
	b.booking_id,
	b.apartment_id,
	c.companion_full_name
FROM bookings AS b
JOIN customers AS c
	USING(customer_id)
WHERE b.apartment_id IS NULL;


7. Bookings Made by Lead:

SELECT
	b.apartment_id,
	b.booked_for,
	c.first_name,
	c.country
FROM bookings AS b
INNER JOIN customers AS c
	ON b.customer_id = c.customer_id
WHERE job_type LIKE 'Lead';


8. Hahn`s Bookings:

SELECT
	COUNT(*)
FROM
	customers
WHERE last_name LIKE 'Hahn';


9. Total Sum of Nights:

SELECT
	a.name,
	SUM(booked_for)
FROM
	apartments AS a
JOIN bookings AS b
	ON a.apartment_id = b.apartment_id
GROUP BY a.name
ORDER BY a.name ASC;


10. Popular Vacation Destination:

SELECT
	a.country,
	COUNT(*) AS "booking_count"
FROM
	 apartments AS a
JOIN bookings AS b
	ON a.apartment_id = b.apartment_id
WHERE b.booked_at >'2021-05-18 07:52:09.904+03'
	AND b.booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY a.country
ORDER BY "booking_count" DESC;


11. Bulgaria's Peaks Higher than 2835 Meters:

SELECT
	mc.country_code,
	m.mountain_range,
	p.peak_name,
	p.elevation
FROM mountains_countries AS mc
	JOIN mountains AS m
		ON mc.mountain_id = m.id
			JOIN peaks AS p
				ON m.id = p.mountain_id
WHERE elevation > 2835 AND country_code LIKE 'BG'
ORDER BY elevation DESC;


12. Count Mountain Ranges:

SELECT
	mc.country_code,
	COUNT(m.mountain_range) AS "mountain_range_count"
FROM mountains_countries AS mc
JOIN mountains AS m
	ON mc.mountain_id = m.id
WHERE mc.country_code IN ('US', 'RU', 'BG')
GROUP BY country_code
ORDER BY "mountain_range_count" DESC;


13. Rivers in Africa:

SELECT
	c.country_name,
	r.river_name
FROM countries AS c
LEFT JOIN countries_rivers AS cr
	ON c.country_code = cr.country_code
		LEFT JOIN rivers AS r
			ON cr.river_id = r.id
WHERE c.continent_code LIKE 'AF'
ORDER BY country_name ASC
LIMIT 5;


14. Minimum Average Area Across Continents:

SELECT
	MIN(min_average_area)
FROM (SELECT
		continent_code,
		AVG(area_in_sq_km) AS min_average_area
	FROM countries
	GROUP BY continent_code) AS a;


15. Countries Without Any Mountains:

SELECT COUNT(*) AS "countries_without_mountains"
FROM countries AS c
LEFT JOIN mountains_countries AS mc
	ON c.country_code = mc.country_code
WHERE mc.country_code IS NULL;

# or

SELECT COUNT(*) AS "countries_without_mountains"
FROM countries
WHERE country_code NOT IN (SELECT country_code FROM mountains_countries);


16. Monasteries by Country✶:

CREATE TABLE monasteries(
	id SERIAL PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);

INSERT INTO monasteries(monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
	('Bachkovo Monastery "Virgin Mary"', 'BG'),
	('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR');

ALTER TABLE countries
ADD COLUMN three_rivers BOOLEAN DEFAULT FALSE;

UPDATE countries
SET three_rivers = (
	SELECT COUNT(*) >= 3
	FROM countries_rivers AS cr
		WHERE cr.country_code = countries.country_code);

SELECT
	m.monastery_name,
	c.country_name
FROM monasteries AS m
JOIN countries AS c
	ON m.country_code = c.country_code
WHERE NOT three_rivers
ORDER BY monastery_name ASC;


17. Monasteries by Continents and Countries✶:

UPDATE countries
SET country_name = 'Burma'
WHERE country_name = 'Myanmar';

INSERT INTO monasteries(monastery_name, country_code)
VALUES
	('Hanga Abbey', (SELECT country_code FROM countries WHERE country_name = 'Tanzania'));

SELECT
	ct.continent_name,
	cn.country_name,
	COUNT(m.id) AS "monasteries_count"
FROM countries AS cn
	LEFT JOIN continents AS ct
		USING(continent_code)
			LEFT JOIN monasteries AS m
				USING(country_code)
WHERE three_rivers = FALSE OR three_rivers IS NULL
GROUP BY country_name, continent_name
ORDER BY monasteries_count DESC,
		country_name ASC;

# ignore: 'Another row should also be inserted into the "monasteries" table with 'Myin-Tin-Daik'....'


18. Retrieving Information about Indexes:

SELECT
	tablename,
	indexname,
	indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename ASC,
		indexname ASC;















