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

CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR(50))
RETURNS TABLE(total_cash NUMERIC) AS
$$
DECLARE
BEGIN
	RETURN QUERY WITH cash_games AS (
		SELECT
			ug.cash,
			ROW_NUMBER() OVER (ORDER BY cash DESC) AS ordered_row
		FROM users_games AS ug
		JOIN games AS g
			ON g.id = ug.game_id
		WHERE g.name = game_name)

	SELECT ROUND(SUM(cash), 2)
	FROM cash_games
	WHERE ordered_row % 2 <> 0;
END;
$$
LANGUAGE plpgsql;

7. Retrieving Account Holders**:

CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(searched_balance NUMERIC)
AS
$$
DECLARE
	full_name VARCHAR;
	total_balance NUMERIC;
	data_for_holder RECORD;
BEGIN
	FOR data_for_holder IN
		SELECT
			CONCAT(ah.first_name, ' ', ah.last_name) AS full_name,
			SUM(a.balance) AS total_balance
		FROM account_holders AS ah
			JOIN accounts AS a
				ON ah.id = a.account_holder_id
		GROUP BY full_name
		HAVING SUM(a.balance) > searched_balance
		ORDER BY full_name ASC
	LOOP
		RAISE NOTICE '% - %', data_for_holder.full_name, data_for_holder.total_balance;
	END LOOP;
END;
$$
LANGUAGE plpgsql;


# CALL sp_retrieving_holders_with_balance_higher_than(200000)

# NOTICE:  Monika Miteva - 565649.2000
# NOTICE:  Petar Kirilov - 245656.2300
# NOTICE:  Petko Petkov Junior - 6546543.2300
# NOTICE:  Susan Cane - 5585351.2400
# NOTICE:  Zlatko Zlatyov - 1112627.9000


8. Deposit Money:

CREATE OR REPLACE PROCEDURE sp_deposit_money(
	account_id INTEGER,
	money_amount NUMERIC(12, 4)) AS
$$
BEGIN
	UPDATE accounts
	SET balance = balance + money_amount
	WHERE account_id = accounts.id;
END;
$$
LANGUAGE plpgsql;


9. Withdraw Money:

CREATE OR REPLACE PROCEDURE sp_withdraw_money(
	account_id INTEGER,
	money_amount NUMERIC(12, 4)) AS
$$
DECLARE
	balance_var NUMERIC(12, 4);
BEGIN
	SELECT balance FROM accounts WHERE account_id = id INTO balance_var;
	IF balance_var < money_amount THEN
		RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
	ELSE
		UPDATE accounts
		SET balance = balance - money_amount
		WHERE account_id = accounts.id;
	END IF;
END;
$$
LANGUAGE plpgsql;


10. Money Transfer:

CREATE OR REPLACE PROCEDURE sp_transfer_money(
	sender_id INTEGER,
	receiver_id INTEGER,
	amount NUMERIC(12, 4)) AS
$$
BEGIN
	CALL sp_withdraw_money(sender_id, amount);
	IF (SELECT balance FROM accounts WHERE sender_id = id) >= 0 THEN
		CALL sp_deposit_money(receiver_id, amount);
	END IF;
END;
$$
LANGUAGE plpgsql;

# or

CREATE OR REPLACE PROCEDURE sp_transfer_money(
	sender_id INTEGER,
	receiver_id INTEGER,
	amount NUMERIC(12, 4)) AS
$$
BEGIN
	CALL sp_withdraw_money(sender_id, amount);
	CALL sp_deposit_money(receiver_id, amount);

	IF (SELECT balance FROM accounts WHERE sender_id = id) < 0 THEN
		ROLLBACK;
	END IF;
END;
$$
LANGUAGE plpgsql;


11. Delete Procedure:

DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;


12. Log Accounts Trigger:



13. Notification Email on Balance Change: