/* ============================================================
   SQL FILE 2: KPI & METRIC QUERIES
   Purpose: Generate core KPIs for dashboard & reporting
   ============================================================ */

/* 1. Total number of donations */
SELECT COUNT(*) AS total_donations
FROM donations;

/* 2. Total number of unique donors */
SELECT COUNT(DISTINCT donor_id) AS total_donors
FROM donations;

/* 3. Total donation amount */
SELECT SUM(amount) AS total_revenue
FROM donations;

/* 4. Average donation value */
SELECT AVG(amount) AS avg_donation
FROM donations;

/* 5. Monthly donation trend */
SELECT 
    DATE_TRUNC('month', donation_date) AS month,
    SUM(amount) AS monthly_amount,
    COUNT(*) AS monthly_donations
FROM donations
GROUP BY month
ORDER BY month;

/* 6. Repeat donor analysis */
SELECT 
    donor_id,
    COUNT(*) AS donation_count
FROM donations
GROUP BY donor_id
HAVING COUNT(*) > 1;

/* 7. Donor retention rate (simple version) */
SELECT
    (COUNT(DISTINCT donor_id) FILTER (WHERE donation_date >= CURRENT_DATE - INTERVAL '1 year')
     /
     COUNT(DISTINCT donor_id) FILTER (WHERE donation_date < CURRENT_DATE - INTERVAL '1 year')
    )::numeric(10,2) AS retention_rate;

/* 8. High-value donor list */
SELECT donor_id,
       SUM(amount) AS total_contributed
FROM donations
GROUP BY donor_id
HAVING SUM(amount) > 200
ORDER BY total_contributed DESC;

/* 9. Donations by country */
SELECT d.country,
       SUM(n.amount) AS total_amount
FROM donations n
JOIN donors d ON n.donor_id = d.donor_id
GROUP BY d.country
ORDER BY total_amount DESC;

