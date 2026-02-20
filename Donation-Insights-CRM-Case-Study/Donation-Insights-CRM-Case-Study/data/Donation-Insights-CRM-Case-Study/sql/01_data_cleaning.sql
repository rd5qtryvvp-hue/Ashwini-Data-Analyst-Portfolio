/* ============================================================
   SQL FILE 1: DATA CLEANING SCRIPT
   Purpose: Clean donation & donor records before analysis
   ============================================================ */

/* 1. Remove donations with invalid or negative amounts */
DELETE FROM donations
WHERE amount <= 0;

/* 2. Standardise email casing and trim whitespace */
UPDATE donors
SET email = LOWER(TRIM(email));

/* 3. Remove rows with missing donor_id (unreliable records) */
DELETE FROM donations
WHERE donor_id IS NULL;

/* 4. Remove donations with missing essential fields */
DELETE FROM donations
WHERE donation_date IS NULL
   OR amount IS NULL;

/* 5. Standardise name formatting */
UPDATE donors
SET first_name = INITCAP(first_name),
    last_name = INITCAP(last_name);

/* 6. Remove exact duplicate donation records */
DELETE FROM donations
WHERE donation_id IN (
    SELECT donation_id
    FROM (
        SELECT donation_id,
               ROW_NUMBER() OVER (PARTITION BY donor_id, amount, donation_date ORDER BY donation_id) AS rn
        FROM donations
    ) t
    WHERE rn > 1
);

/* 7. Identify potential duplicate donors (fuzzy match pattern) */
SELECT *
FROM donors
WHERE email IN (
    SELECT email
    FROM donors
    GROUP BY email
    HAVING COUNT(*) > 1
);

/* 8. Standardise gender field */
UPDATE donors
SET gender = CASE
                WHEN gender ILIKE 'M%' THEN 'Male'
                WHEN gender ILIKE 'F%' THEN 'Female'
                ELSE 'Other'
             END;

