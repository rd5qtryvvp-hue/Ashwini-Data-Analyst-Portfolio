-- ============================================================
-- Velora Hotel Melbourne | Housekeeping Analytics
-- File 01: Data Exploration & Quality Checks
-- Author: Ashwini Harikumar
-- Description: Initial profiling of all four data tables to
--              understand structure, completeness, and quality
--              before deeper analysis.
-- ============================================================

-- STEP 1: Create the database and tables
-- Run this first before importing your CSV files

CREATE DATABASE IF NOT EXISTS velora_hotel;
USE velora_hotel;

-- -------------------------------------------------------
-- TABLE 1: staff_roster
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS staff_roster (
    staff_id        VARCHAR(10),
    staff_name      VARCHAR(50),
    shift_date      DATE,
    day_of_week     VARCHAR(15),
    shift_start     TIME,
    shift_end       TIME,
    hours_scheduled DECIMAL(4,1),
    hours_worked    DECIMAL(4,1),
    overtime_hours  DECIMAL(4,1),
    floor_assigned  INT,
    rooms_assigned_count INT
);

-- TABLE 2: room_assignments
CREATE TABLE IF NOT EXISTS room_assignments (
    assignment_id       VARCHAR(10),
    shift_date          DATE,
    staff_id            VARCHAR(10),
    staff_name          VARCHAR(50),
    floor               INT,
    room_number         INT,
    room_type           VARCHAR(30),
    checkout_flag       VARCHAR(5),
    time_assigned       TIME,
    time_started        TIME,
    time_completed      TIME,
    minutes_taken       INT,
    standard_minutes    INT
);

-- TABLE 3: checkout_log
CREATE TABLE IF NOT EXISTS checkout_log (
    checkout_id             VARCHAR(10),
    checkout_date           DATE,
    room_number             INT,
    floor                   INT,
    room_type               VARCHAR(30),
    guest_checkout_time     TIME,
    room_cleared_time       TIME,
    minutes_to_clear        INT,
    checkout_hour_bucket    VARCHAR(20),
    cleared_within_60min    VARCHAR(5)
);

-- TABLE 4: room_status_log
CREATE TABLE IF NOT EXISTS room_status_log (
    status_id               VARCHAR(10),
    log_date                DATE,
    room_number             INT,
    floor                   INT,
    room_type               VARCHAR(30),
    checkout_time           TIME,
    cleaning_start_time     TIME,
    cleaning_end_time       TIME,
    room_ready_time         TIME,
    checkin_requested_time  TIME,
    ready_before_checkin    VARCHAR(5),
    delay_minutes           INT,
    sla_met                 VARCHAR(5)
);

-- -------------------------------------------------------
-- SECTION 1: Row counts — confirm data loaded correctly
-- -------------------------------------------------------
SELECT 'staff_roster' AS table_name, COUNT(*) AS row_count FROM staff_roster
UNION ALL
SELECT 'room_assignments', COUNT(*) FROM room_assignments
UNION ALL
SELECT 'checkout_log', COUNT(*) FROM checkout_log
UNION ALL
SELECT 'room_status_log', COUNT(*) FROM room_status_log;

-- -------------------------------------------------------
-- SECTION 2: Check for NULL values in key columns
-- -------------------------------------------------------

-- Nulls in staff_roster
SELECT
    SUM(CASE WHEN staff_id IS NULL THEN 1 ELSE 0 END)        AS null_staff_id,
    SUM(CASE WHEN shift_date IS NULL THEN 1 ELSE 0 END)      AS null_shift_date,
    SUM(CASE WHEN hours_worked IS NULL THEN 1 ELSE 0 END)    AS null_hours_worked,
    SUM(CASE WHEN overtime_hours IS NULL THEN 1 ELSE 0 END)  AS null_overtime
FROM staff_roster;

-- Nulls in room_assignments
SELECT
    SUM(CASE WHEN staff_id IS NULL THEN 1 ELSE 0 END)          AS null_staff_id,
    SUM(CASE WHEN room_number IS NULL THEN 1 ELSE 0 END)       AS null_room_number,
    SUM(CASE WHEN minutes_taken IS NULL THEN 1 ELSE 0 END)     AS null_minutes_taken,
    SUM(CASE WHEN standard_minutes IS NULL THEN 1 ELSE 0 END)  AS null_standard_minutes
FROM room_assignments;

-- -------------------------------------------------------
-- SECTION 3: Date range covered
-- -------------------------------------------------------
SELECT
    MIN(shift_date) AS earliest_date,
    MAX(shift_date) AS latest_date,
    COUNT(DISTINCT shift_date) AS total_days
FROM staff_roster;

-- -------------------------------------------------------
-- SECTION 4: Unique staff and floors
-- -------------------------------------------------------
SELECT staff_id, staff_name, COUNT(DISTINCT shift_date) AS days_worked
FROM staff_roster
GROUP BY staff_id, staff_name
ORDER BY staff_id;

SELECT floor_assigned, COUNT(*) AS shift_days
FROM staff_roster
GROUP BY floor_assigned
ORDER BY floor_assigned;

-- -------------------------------------------------------
-- SECTION 5: Room type distribution
-- -------------------------------------------------------
SELECT room_type, COUNT(*) AS total_rooms_cleaned
FROM room_assignments
GROUP BY room_type
ORDER BY total_rooms_cleaned DESC;

-- -------------------------------------------------------
-- SECTION 6: Sanity check — are any rooms taking 0 or
--             negative minutes? (data quality flag)
-- -------------------------------------------------------
SELECT *
FROM room_assignments
WHERE minutes_taken <= 0 OR minutes_taken IS NULL;

-- -------------------------------------------------------
-- SECTION 7: Overview of overtime distribution
-- -------------------------------------------------------
SELECT
    day_of_week,
    COUNT(*) AS total_shifts,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2) AS avg_overtime_per_shift
FROM staff_roster
GROUP BY day_of_week
ORDER BY total_overtime_hours DESC;
