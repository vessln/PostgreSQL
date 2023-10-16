1. Database Design:

CREATE TABLE towns(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

CREATE TABLE stadiums(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	capacity INTEGER NOT NULL,
	town_id INTEGER NOT NULL,

	CONSTRAINT ck_stadiums_capacity
		CHECK (capacity > 0),

	CONSTRAINT fk_stadiums_towns
	FOREIGN KEY (town_id)
		REFERENCES towns(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE teams(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	established DATE NOT NULL,
	fan_base INTEGER NOT NULL DEFAULT 0,
	stadium_id INTEGER NOT NULL,

	CONSTRAINT ck_teams_fan_base
		CHECK (fan_base >= 0),

	CONSTRAINT fk_teams_stadiums
	FOREIGN KEY (stadium_id)
		REFERENCES stadiums(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE coaches(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 0,
	coach_level INTEGER NOT NULL DEFAULT 0,

	CONSTRAINT ck_coaches_salary
		CHECK (salary >= 0),

	CONSTRAINT ck_coaches_coach_level
		CHECK (coach_level >= 0)
);

CREATE TABLE skills_data(
	id SERIAL PRIMARY KEY,
	dribbling INTEGER DEFAULT 0,
	pace INTEGER DEFAULT 0,
	passing INTEGER DEFAULT 0,
	shooting INTEGER DEFAULT 0,
	speed INTEGER DEFAULT 0,
	strength INTEGER DEFAULT 0,

	CONSTRAINT ck_skills_data_dribbling
		CHECK (dribbling >= 0),

	CONSTRAINT ck_skills_data_pace
		CHECK (pace >= 0),

	CONSTRAINT ck_skills_data_passing
		CHECK (passing >= 0),

	CONSTRAINT ck_skills_data_shooting
		CHECK (shooting >= 0),

	CONSTRAINT ck_skills_data_speed
		CHECK (speed >= 0),

	CONSTRAINT ck_skills_data_strength
		CHECK (strength >= 0)
);

CREATE TABLE players(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	age INTEGER NOT NULL DEFAULT 0,
	position CHAR(1) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL DEFAULT 0,
	hire_date TIMESTAMP,
	skills_data_id INTEGER NOT NULL,
	team_id INTEGER,

	CONSTRAINT ck_players_age
		CHECK (age >= 0),

	CONSTRAINT ck_players_salary
		CHECK (salary >= 0),

	CONSTRAINT fk_players_skills_data
	FOREIGN KEY (skills_data_id)
		REFERENCES skills_data(id)
			ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_players_teams
	FOREIGN KEY (team_id)
		REFERENCES teams(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE players_coaches(
	player_id INTEGER,
	coach_id INTEGER,

	CONSTRAINT fk_players_coaches_players
	FOREIGN KEY (player_id)
		REFERENCES players(id)
			ON UPDATE CASCADE ON DELETE CASCADE,

	CONSTRAINT fk_players_coaches_coaches
	FOREIGN KEY (coach_id)
		REFERENCES coaches(id)
			ON UPDATE CASCADE ON DELETE CASCADE
);


2.2. Insert:

INSERT INTO coaches(first_name, last_name, salary, coach_level)
SELECT
	first_name,
	last_name,
	salary * 2,
	CHAR_LENGTH(first_name)
FROM players
WHERE hire_date < '2013-12-13 07:18:46';


2.3. Update:

UPDATE coaches
SET salary = salary * coach_level
WHERE first_name LIKE 'C%'
AND id IN (SELECT coach_id FROM players_coaches);


2.4. Delete:

DELETE FROM players_coaches
WHERE player_id IN (SELECT id FROM players
                    WHERE hire_date < '2013-12-13 07:18:46');

DELETE FROM players
WHERE hire_date < '2013-12-13 07:18:46';


3.5. Players:

SELECT
	CONCAT(first_name, ' ', last_name) AS "full_name",
	age,
	hire_date
FROM players
WHERE first_name LIKE 'M%'
ORDER BY age DESC, full_name ASC;


3.6. Offensive Players without Team

SELECT
	p.id,
	CONCAT(p.first_name, ' ', p.last_name) AS "full_name",
	p.age,
	p.position,
	p.salary,
	sd.pace,
	sd.shooting
FROM
	players AS p
JOIN skills_data AS sd ON sd.id = p.skills_data_id
WHERE p.position LIKE 'A'
AND (sd.pace + sd.shooting) > 130
AND p.team_id IS NULL;


3.7. Teams with Player Count and Fan Base

SELECT
	t.id,
	t.name,
	COUNT(p.id) AS "player_count",
	t.fan_base
FROM teams AS t
LEFT JOIN players AS p
	ON p.team_id = t.id
WHERE fan_base > 30000
GROUP BY t.id
ORDER BY "player_count" DESC, t.fan_base DESC;


3.8. Coaches, Players Skills and Teams Overview

SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS "coach_full_name",
	CONCAT(p.first_name, ' ', p.last_name) AS "player_full_name",
	t.name AS "team_name",
	sd.passing,
	sd.shooting,
	sd.speed
FROM coaches AS c
	JOIN players_coaches AS pc ON pc.coach_id = c.id
		JOIN players AS p ON p.id = pc.player_id
			JOIN teams AS t ON t.id = p.team_id
				JOIN skills_data AS sd ON sd.id = p.skills_data_id
ORDER BY "coach_full_name" ASC,
		"player_full_name" DESC;


4.9. Stadium Teams Information

CREATE OR REPLACE FUNCTION fn_stadium_team_name(stadium_name VARCHAR(30))
RETURNS TABLE (team_name VARCHAR(50))
AS
$$
BEGIN
	RETURN QUERY
		SELECT t.name
		FROM teams AS t
		JOIN stadiums AS s
			ON t.stadium_id = s.id
		WHERE s.name = stadium_name
		ORDER BY t.name ASC;
END;
$$
LANGUAGE plpgsql;


4.10. Player Team Finder:

CREATE OR REPLACE PROCEDURE sp_players_team_name(
		IN player_name VARCHAR(50),
		OUT team_name VARCHAR(50))
AS
$$
BEGIN
	SELECT
		COALESCE(t.name, 'The player currently has no team') INTO team_name
	FROM teams AS t
	RIGHT JOIN players AS p ON t.id = p.team_id
	WHERE CONCAT(p.first_name, ' ', p.last_name) LIKE player_name;

END;
$$
LANGUAGE plpgsql;

