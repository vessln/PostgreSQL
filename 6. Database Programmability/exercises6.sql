1. User-defined Function Full Name:

CREATE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
DECLARE
	full_name VARCHAR;
BEGIN
	IF first_name IS NULL AND last_name IS NULL THEN
		full_name := null;
	ELSIF first_name IS NULL THEN
		full_name := INITCAP(last_name);
	ELSIF last_name IS NULL THEN
		full_name := INITCAP(first_name);
	ELSE
		full_name := INITCAP(first_name || ' ' || last_name);
	END IF;
	RETURN full_name;
END;
$$
LANGUAGE plpgsql;


2. User-defined Function Future Value:

CREATE FUNCTION fn_calculate_future_value(initial_sum DECIMAL, yearly_interest_rate DECIMAL, number_of_years INT)
RETURNS DECIMAL AS
$$
DECLARE
	future_value DECIMAL;
BEGIN
	future_value := (initial_sum * POWER(1 + yearly_interest_rate, number_of_years));
	RETURN TRUNC(future_value, 4);
END;
$$
LANGUAGE plpgsql;


3. User-defined Function Is Word Comprised:

CREATE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR, word VARCHAR)
RETURNS BOOLEAN AS
$$
DECLARE
	i INT;
	current_char VARCHAR;
BEGIN
	FOR i in 1..LENGTH(word) LOOP
		current_char := LOWER(SUBSTRING(word, i, 1));
		IF POSITION(current_char IN LOWER(set_of_letters)) = 0 THEN
		RETURN FALSE;
		END IF;
	END LOOP;

	RETURN TRUE;
END;
$$
LANGUAGE plpgsql;

# or

CREATE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR, word VARCHAR)
RETURNS BOOLEAN AS
$$
BEGIN
	RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
END;
$$
LANGUAGE plpgsql;


4. Game Over:

CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE (name VARCHAR(50),
			   game_type_id INT,
			   is_finished BOOLEAN)
AS
$$
BEGIN
	RETURN QUERY
		SELECT g.name, g.game_type_id, g.is_finished
		FROM games AS g
		WHERE g.is_finished = is_game_over;
END;
$$
LANGUAGE plpgsql;


5. Difficulty Level:

CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
RETURNS VARCHAR(30)
AS
$$
DECLARE current_lvl VARCHAR(30);
BEGIN
	IF (level < 41) THEN current_lvl := 'Normal Difficulty';
	ELSIF (level BETWEEN 41 AND 60) THEN current_lvl := 'Nightmare Difficulty';
	ELSIF (level > 60) THEN current_lvl := 'Hell Difficulty';
	END IF;
	RETURN current_lvl;
END;
$$
LANGUAGE plpgsql;

SELECT
	ug.user_id,
	ug.level,
	ug.cash,
	fn_difficulty_level(ug.level)
FROM users_games AS ug
ORDER BY user_id ASC;


6. Cash in User Games Odd Rows✶:



8. Deposit Money:



9. Withdraw Money:



10. Money Transfer:



11. Delete Procedure:



12. Log Accounts Trigger:



13. Notification Email on Balance Change: