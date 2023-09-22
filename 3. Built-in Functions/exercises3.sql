1. River Info:

CREATE VIEW view_river_info
AS
SELECT
	CONCAT('The river', ' ', river_name,' ',
		   'flows into the', ' ', outflow, ' ',
		   'and is', ' ', "length", ' ', 'kilometers long.') AS "River Information"
FROM rivers
ORDER BY river_name ASC


2. Concatenate Geography Data:

CREATE VIEW view_continents_countries_currencies_details
AS
SELECT
	CONCAT(cntn.continent_name, ': ', cntn.continent_code) AS "Continent Details",
	CONCAT_WS(' - ', coun.country_name, coun.capital, coun.area_in_sq_km, 'km2') AS "Country Information",
	CONCAT(cur.description, ' (', cur.currency_code, ')') AS "Currencies"
FROM continents AS cntn
JOIN countries AS coun ON cntn.continent_code = coun.continent_code
JOIN currencies AS cur ON coun.currency_code = cur.currency_code
ORDER BY "Country Information" ASC, "Currencies" ASC;

# or

CREATE VIEW view_continents_countries_currencies_details
AS
SELECT
	CONCAT(cntn.continent_name, ': ', cntn.continent_code) AS "Continent Details",
	CONCAT_WS(' - ', coun.country_name, coun.capital, coun.area_in_sq_km, 'km2') AS "Country Information",
	CONCAT(cur.description, ' (', cur.currency_code, ')') AS "Currencies"
FROM continents AS cntn,
	countries AS coun,
	currencies AS cur
WHERE cntn.continent_code = coun.continent_code
AND coun.currency_code = cur.currency_code
ORDER BY "Country Information" ASC, "Currencies" ASC;


3. Capital Code:

ALTER TABLE countries
ADD COLUMN capital_code CHAR(2);

UPDATE countries
SET capital_code = SUBSTRING(capital, 1, 2);


4. (Descr)iption:

SELECT
	RIGHT(description, -4)
FROM currencies;

# or

SELECT
	SUBSTRING(description, 5)
FROM currencies;


5. Substring River Length:

SELECT
	SUBSTRING("River Information", '([0-9]{1,4})') AS "river_length"
FROM
	view_river_info;


6. Replace A:

SELECT
	REPLACE(mountain_range, 'a', '@') AS "replace_a",
	REPLACE(mountain_range, 'A', '$') AS "replace_A"
FROM mountains;


7. Translate:

SELECT
	capital,
	TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS "translated_name"
FROM countries;


8. LEADING:

SELECT
	continent_name,
	LTRIM(continent_name)
FROM continents;

# or

SELECT
	continent_name,
	TRIM(LEADING FROM continent_name)
FROM continents;


9. TRAILING:

SELECT
	continent_name,
	RTRIM(continent_name)
FROM
	continents;

# or

SELECT
	continent_name,
	TRIM(TRAILING FROM continent_name)
FROM continents;


10. LTRIM & RTRIM:

SELECT
	LTRIM(peak_name, 'M') AS "Left Trim",
	RTRIM(peak_name, 'm') AS "Right Trim"
FROM peaks;


11. Character Length and Bits:

SELECT
	population,
	LENGTH(CAST(population AS TEXT))
FROM countries;


12. Length of a Number:

SELECT
	population,
	LENGTH(CAST(population AS TEXT))
FROM countries;


13. Positive and Negative LEFT:

SELECT
	peak_name,
	LEFT(peak_name, 4) AS "Positive Left",
	LEFT(peak_name, -4) AS "Negative Left"
FROM peaks;


14. Positive and Negative RIGHT:

SELECT
	peak_name,
	RIGHT(peak_name, 4) AS "Positive Right",
	RIGHT(peak_name, -4) AS "Negative Right"
FROM peaks;


15. Update iso_code:

UPDATE countries
SET iso_code = UPPER(SUBSTRING(country_name, 1, 3))
WHERE iso_code IS NULL;


16. REVERSE country_code:

UPDATE countries
SET country_code = LOWER(REVERSE(country_code));


17. Elevation --->> Peak Name:

SELECT
	CONCAT(elevation, ' ', REPEAT('-' , 3), REPEAT('>', 2), ' ', peak_name)
	AS "Elevation -->> Peak Name"
FROM peaks
WHERE elevation >= 4884;


18. Arithmetical Operators:

CREATE TABLE bookings_calculation
AS
SELECT
	booked_for,
	CAST(booked_for * 50 AS NUMERIC) AS "multiplication",
	CAST(booked_for % 50 AS NUMERIC) AS "modulo"
FROM bookings
WHERE apartment_id = 93;


19. ROUND vs TRUNC:

SELECT
	latitude,
	ROUND(latitude, 2),
	TRUNC(latitude, 2)
FROM apartments;


20. Absolute Value:

SELECT
	longitude,
	ABS(longitude)
FROM apartments;


21. Billing Day**:

ALTER TABLE bookings
ADD COLUMN billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;

SELECT TO_CHAR(billing_day, 'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS') AS "Billing Day"
FROM bookings;


22. EXTRACT Booked At:

SELECT
	EXTRACT('year' FROM booked_at) AS YEAR,
	EXTRACT('month' FROM booked_at) AS MONTH,
	EXTRACT('day' FROM booked_at) AS DAY,
	EXTRACT('hour' FROM booked_at AT TIME ZONE 'UTC') AS HOUR,
	EXTRACT('minute' FROM booked_at) AS MINUTE,
	CEIL(EXTRACT('second' FROM booked_at)) AS SECOND
FROM bookings;


23. Early Birds**:

SELECT
	user_id,
	AGE(starts_at, booked_at) AS "Early Birds"
FROM bookings
WHERE AGE(starts_at, booked_at) >= '10 MONTHS'

# or

SELECT
	user_id,
	AGE(starts_at, booked_at) AS "Early Birds"
FROM bookings
WHERE AGE(starts_at, booked_at) >= INTERVAL '10 months'

# or

SELECT
	user_id,
	AGE(starts_at, booked_at) AS "Early Birds"
FROM bookings
WHERE starts_at - booked_at >= '10 months'


24. Match or Not:

SELECT
	companion_full_name,
	email
FROM users
WHERE companion_full_name ILIKE '%aNd%'  --- ILIKE is case insensitive
AND email NOT LIKE '%@gmail';


25. COUNT by Initial✶:

SELECT
	SUBSTRING(first_name, 1, 2) AS initials,
	COUNT('initials') AS user_count
FROM users
GROUP BY initials
ORDER BY user_count DESC, initials ASC;


26. SUM✶:

SELECT
	SUM(booked_for) AS "total_value"
FROM bookings
WHERE apartment_id = 90;


27. Average Value✶:

SELECT
	AVG(multiplication) AS "average_value"
FROM bookings_calculation;

