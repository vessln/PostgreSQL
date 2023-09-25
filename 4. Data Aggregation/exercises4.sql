1. COUNT of Records:

SELECT
	COUNT(*)
FROM wizard_deposits;


2. Total Deposit Amount:

SELECT
	SUM(deposit_amount) AS "Total Amount"
FROM wizard_deposits;


3. AVG Magic Wand Size:

SELECT
	ROUND(AVG(magic_wand_size), 3) AS "Average Magic Wand Size"
FROM wizard_deposits;


4. MIN Deposit Charge:

SELECT
	MIN(deposit_charge) AS "Minimum Deposit Charge"
FROM wizard_deposits;


5. MAX Age:

SELECT
	MAX(age) AS "Maximum Age"
FROM wizard_deposits;


6. GROUP BY Deposit Interest:

SELECT
	deposit_group,
	SUM(deposit_interest) AS "Deposit Interest"
FROM wizard_deposits
GROUP BY deposit_group
ORDER BY "Deposit Interest" DESC;


7. LIMIT the Magic Wand Creator:

SELECT
	magic_wand_creator,
	MIN(magic_wand_size) AS "Minimum Wand Size"
FROM wizard_deposits
GROUP BY magic_wand_creator
ORDER BY "Minimum Wand Size" ASC
LIMIT 5;


8. Bank Profitability:

SELECT
	deposit_group,
	is_deposit_expired,
	FLOOR(AVG(deposit_interest)) AS "Deposit Interest"
FROM wizard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group, is_deposit_expired
ORDER BY deposit_group DESC, is_deposit_expired ASC;


9. Notes with Dumbledore:

SELECT
	last_name,
	COUNT(notes) AS "Notes with Dumbledore"
FROM wizard_deposits
WHERE notes LIKE '%Dumbledore%'
GROUP BY last_name;


10. Wizard View:

CREATE VIEW "view_wizard_deposits_with_expiration_date_before_1983_08_17"
AS
SELECT
	CONCAT(first_name, ' ', last_name) AS "Wizard Name",
	deposit_start_date AS "Start Date",
	deposit_expiration_date AS "Expiration Date",
	deposit_amount AS "Amount"
FROM wizard_deposits
WHERE deposit_expiration_date <= '1983-08-17'
GROUP BY "Wizard Name", "Start Date", "Expiration Date", "Amount"
ORDER BY deposit_expiration_date ASC;


11. Filter Max Deposit:

SELECT
	magic_wand_creator,
	MAX(deposit_amount) AS "Max Deposit Amount"
FROM wizard_deposits
GROUP BY magic_wand_creator
HAVING MAX(deposit_amount) < 20000 OR MAX(deposit_amount) > 40000
ORDER BY "Max Deposit Amount" DESC
LIMIT 3;


12. Age Group13. SUM the Employees:

SELECT
	CASE
		WHEN age BETWEEN 0 and 10 THEN '[0-10]'
		WHEN age BETWEEN 11 and 20 THEN '[11-20]'
		WHEN age BETWEEN 21 and 30 THEN '[21-30]'
		WHEN age BETWEEN 31 and 40 THEN '[31-40]'
		WHEN age BETWEEN 41 and 50 THEN '[41-50]'
		WHEN age BETWEEN 51 and 60 THEN '[51-60]'
		WHEN age >= 61 THEN '[61+]'
	END AS "Age Group",
	COUNT(*)
FROM wizard_deposits
GROUP BY "Age Group"
ORDER BY "Age Group" ASC;


14. Update Employees’ Data:



15. Categorizes Salary:



16. WHERE Project Status:



17. HAVING Salary Level:



18. Nested CASE Conditions✶:



19. Foreign Key✶:



20. JOIN Tables✶: