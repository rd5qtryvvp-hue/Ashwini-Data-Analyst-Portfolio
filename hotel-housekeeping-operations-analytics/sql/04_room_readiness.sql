
-- ============================================================
-- Velora Hotel Melbourne | Housekeeping Analytics
-- File 04: Room Readiness & SLA Compliance Analysis
-- Author: Ashwini Harikumar
-- Description: Measure how often rooms are ready before
--              check-in is requested. Identify which floors,
--              room types, and time windows fail the SLA.
-- ============================================================

USE velora_hotel;

-- -------------------------------------------------------
-- ANALYSIS 1: Overall SLA compliance rate
-- What % of rooms are ready before check-in?
-- -------------------------------------------------------
SELECT
    COUNT(*) AS total_rooms,
    SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) AS rooms_met_sla,
    SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) AS rooms_missed_sla,
    ROUND(
        SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS sla_compliance_pct
FROM room_status_log;

-- -------------------------------------------------------
-- ANALYSIS 2: SLA compliance by floor
-- Which floors are the worst offenders?
-- -------------------------------------------------------
SELECT
    floor,
    COUNT(*) AS total_rooms,
    SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) AS met_sla,
    SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) AS missed_sla,
    ROUND(
        SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS sla_compliance_pct
FROM room_status_log
GROUP BY floor
ORDER BY sla_compliance_pct ASC;

-- -------------------------------------------------------
-- ANALYSIS 3: SLA compliance by room type
-- Are suites consistently failing SLA?
-- -------------------------------------------------------
SELECT
    room_type,
    COUNT(*) AS total_rooms,
    ROUND(AVG(delay_minutes), 1) AS avg_delay_when_late,
    SUM(CASE WHEN sla_met = 'No' THEN 1 ELSE 0 END) AS sla_failures,
    ROUND(
        SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS compliance_pct
FROM room_status_log
GROUP BY room_type
ORDER BY compliance_pct ASC;

-- -------------------------------------------------------
-- ANALYSIS 4: Average cleaning duration by room type
-- vs standard time — are we above standard?
-- -------------------------------------------------------
SELECT
    ra.room_type,
    ROUND(AVG(ra.minutes_taken), 1) AS avg_actual_minutes,
    AVG(ra.standard_minutes) AS standard_minutes,
    ROUND(AVG(ra.minutes_taken) - AVG(ra.standard_minutes), 1) AS avg_overrun_minutes
FROM room_assignments ra
GROUP BY ra.room_type
ORDER BY avg_overrun_minutes DESC;

-- -------------------------------------------------------
-- ANALYSIS 5: Worst individual SLA breaches
-- Which specific rooms had the longest delays?
-- -------------------------------------------------------
SELECT
    log_date,
    room_number,
    floor,
    room_type,
    checkout_time,
    room_ready_time,
    checkin_requested_time,
    delay_minutes
FROM room_status_log
WHERE sla_met = 'No'
ORDER BY delay_minutes DESC
LIMIT 10;

-- -------------------------------------------------------
-- ANALYSIS 6: Cleaning start lag
-- How long after checkout does cleaning actually begin?
-- (Should ideally be < 10 minutes)
-- -------------------------------------------------------
SELECT
    floor,
    room_type,
    ROUND(AVG(
        TIMESTAMPDIFF(MINUTE, checkout_time, cleaning_start_time)
    ), 1) AS avg_start_lag_minutes
FROM room_status_log
GROUP BY floor, room_type
ORDER BY avg_start_lag_minutes DESC;

-- -------------------------------------------------------
-- ANALYSIS 7: Date-level SLA trend
-- Is performance improving or worsening over time?
-- -------------------------------------------------------
SELECT
    log_date,
    COUNT(*) AS total_rooms,
    SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) AS met_sla,
    ROUND(
        SUM(CASE WHEN sla_met = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS daily_sla_pct
FROM room_status_log
GROUP BY log_date
ORDER BY log_date ASC;

-- -------------------------------------------------------
-- ANALYSIS 8: Staff productivity — avg minutes per room
--             vs standard, grouped by staff member
-- -------------------------------------------------------
SELECT
    ra.staff_id,
    ra.staff_name,
    COUNT(*) AS rooms_cleaned,
    ROUND(AVG(ra.minutes_taken), 1) AS avg_minutes_per_room,
    ROUND(AVG(ra.standard_minutes), 1) AS avg_standard_minutes,
    ROUND(AVG(ra.minutes_taken) - AVG(ra.standard_minutes), 1) AS avg_overrun
FROM room_assignments ra
GROUP BY ra.staff_id, ra.staff_name
ORDER BY avg_overrun ASC;
