-- ============================================================
-- Velora Hotel Melbourne | Housekeeping Analytics
-- File 02: Peak Checkout Bottleneck Analysis
-- Author: Ashwini Harikumar
-- Description: Identify which time windows have the highest
--              checkout volume and the slowest clearance times.
--              This analysis exposed the 10-11am bottleneck.
-- ============================================================

USE velora_hotel;

-- -------------------------------------------------------
-- ANALYSIS 1: Volume of checkouts by hour bucket
-- Which hours are the busiest?
-- -------------------------------------------------------
SELECT
    checkout_hour_bucket,
    COUNT(*) AS total_checkouts,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_total
FROM checkout_log
GROUP BY checkout_hour_bucket
ORDER BY total_checkouts DESC;

-- -------------------------------------------------------
-- ANALYSIS 2: Average clearance time by hour bucket
-- Are certain windows slower to clear?
-- -------------------------------------------------------
SELECT
    checkout_hour_bucket,
    COUNT(*) AS total_rooms,
    ROUND(AVG(minutes_to_clear), 1) AS avg_minutes_to_clear,
    MIN(minutes_to_clear) AS fastest,
    MAX(minutes_to_clear) AS slowest
FROM checkout_log
GROUP BY checkout_hour_bucket
ORDER BY avg_minutes_to_clear DESC;

-- -------------------------------------------------------
-- ANALYSIS 3: SLA compliance (cleared within 60 min)
--             by hour bucket
-- -------------------------------------------------------
SELECT
    checkout_hour_bucket,
    COUNT(*) AS total_checkouts,
    SUM(CASE WHEN cleared_within_60min = 'Yes' THEN 1 ELSE 0 END) AS cleared_within_sla,
    ROUND(
        SUM(CASE WHEN cleared_within_60min = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS sla_compliance_pct
FROM checkout_log
GROUP BY checkout_hour_bucket
ORDER BY sla_compliance_pct ASC;

-- -------------------------------------------------------
-- ANALYSIS 4: Clearance delays by floor and room type
-- Which floors are slowest to turn over?
-- -------------------------------------------------------
SELECT
    floor,
    room_type,
    COUNT(*) AS total_checkouts,
    ROUND(AVG(minutes_to_clear), 1) AS avg_minutes_to_clear,
    SUM(CASE WHEN cleared_within_60min = 'No' THEN 1 ELSE 0 END) AS missed_sla_count
FROM checkout_log
GROUP BY floor, room_type
ORDER BY avg_minutes_to_clear DESC;

-- -------------------------------------------------------
-- ANALYSIS 5: Day-of-week checkout volume
-- (JOIN with staff_roster to get day name)
-- -------------------------------------------------------
SELECT
    sr.day_of_week,
    COUNT(cl.checkout_id) AS total_checkouts,
    ROUND(AVG(cl.minutes_to_clear), 1) AS avg_clearance_time,
    SUM(CASE WHEN cl.cleared_within_60min = 'No' THEN 1 ELSE 0 END) AS sla_failures
FROM checkout_log cl
JOIN staff_roster sr ON cl.checkout_date = sr.shift_date
GROUP BY sr.day_of_week
ORDER BY total_checkouts DESC;

-- -------------------------------------------------------
-- ANALYSIS 6: Top 10 slowest individual room clearances
-- -------------------------------------------------------
SELECT
    checkout_date,
    room_number,
    floor,
    room_type,
    guest_checkout_time,
    room_cleared_time,
    minutes_to_clear
FROM checkout_log
ORDER BY minutes_to_clear DESC
LIMIT 10;

-- -------------------------------------------------------
-- ANALYSIS 7: Summary — what % of delays happen in 
--             the peak 10-11am window specifically?
-- -------------------------------------------------------
SELECT
    CASE
        WHEN checkout_hour_bucket = '10:00-11:00' THEN 'Peak Window (10-11am)'
        ELSE 'All Other Windows'
    END AS window_group,
    COUNT(*) AS total_checkouts,
    SUM(CASE WHEN cleared_within_60min = 'No' THEN 1 ELSE 0 END) AS sla_failures,
    ROUND(
        SUM(CASE WHEN cleared_within_60min = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS failure_rate_pct
FROM checkout_log
GROUP BY window_group;
