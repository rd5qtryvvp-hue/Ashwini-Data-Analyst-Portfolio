/* ============================================================
   SQL FILE 3: DATA VALIDATION SCRIPT
   Purpose: Ensure data quality before loading into Power BI
   ============================================================ */

/* 1. Check for nulls in critical fields */
SELECT *
FROM donations
WHERE donor_id IS NULL
   OR amount IS NULL
   OR donation_date IS NULL;

/* 2. Identify out-of-range donation amounts */
SELECT *
FROM donations
WHERE amount < 1 OR amount > 10000;

/* 3. Ensure donor table has valid emails */
SELECT *
FROM donors
WHERE email NOT LIKE '%@%';

/* 4. Detect duplicate donor profiles by exact email match */
SELECT email, COUNT(*) AS occurrences
FROM donors
GROUP BY email
HAVING COUNT(*) > 1;

/* 5. Check for mismatched donor IDs */
SELECT n.donor_id
FROM donations n
LEFT JOIN donors d ON n.donor_id = d.donor_id
WHERE d.donor_id IS NULL;

/* 6. Validate that donation dates fall within expected range */
SELECT *
FROM donations
WHERE donation_date < '2010-01-01'
   OR donation_date > CURRENT_DATE;

/* 7. Validate gender values */
SELECT *
FROM donors
WHERE gender NOT IN ('Male', 'Female', 'Other');

