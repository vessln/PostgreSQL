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


4. Game Over:



5. Difficulty Level:



6. Cash in User Games Odd Rows✶:



8. Deposit Money:



9. Withdraw Money:



10. Money Transfer:



11. Delete Procedure:



12. Log Accounts Trigger:



13. Notification Email on Balance Change: