-- ============================================================
-- Velora Hotel Melbourne | Housekeeping Analytics
-- File 03: Staff Overtime Analysis
-- Author: Ashwini Harikumar
-- Description: Identify which staff, floors, and days are
--              driving overtime blowouts and whether workload
--              distribution is the root cause.
-- ============================================================

USE velora_hotel;

-- -------------------------------------------------------
-- ANALYSIS 1: Total overtime by staff member
-- Who is consistently working overtime?
-- -------------------------------------------------------
SELECT
    staff_id,
    staff_name,
    COUNT(shift_date) AS total_shifts,
    SUM(hours_worked) AS total_hours_worked,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2) AS avg_overtime_per_shift,
    SUM(rooms_assigned_count) AS total_rooms_cleaned
FROM staff_roster
GROUP BY staff_id, staff_name
ORDER BY total_overtime_hours DESC;

-- -------------------------------------------------------
-- ANALYSIS 2: Overtime by day of week
-- Is overtime concentrated on specific days?
-- -------------------------------------------------------
SELECT
    day_of_week,
    COUNT(*) AS total_shifts,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2) AS avg_overtime_per_shift,
    ROUND(SUM(overtime_hours) * 100.0 / (SELECT SUM(overtime_hours) FROM staff_roster), 1) AS pct_of_all_overtime
FROM staff_roster
GROUP BY day_of_week
ORDER BY total_overtime_hours DESC;

-- -------------------------------------------------------
-- ANALYSIS 3: Overtime by floor
-- Are certain floors consistently overloaded?
-- -------------------------------------------------------
SELECT
    floor_assigned,
    COUNT(*) AS total_shift_days,
    SUM(rooms_assigned_count) AS total_rooms_assigned,
    ROUND(AVG(rooms_assigned_count), 1) AS avg_rooms_per_shift,
    SUM(overtime_hours) AS total_overtime_hours,
    ROUND(AVG(overtime_hours), 2) AS avg_overtime_per_shift
FROM staff_roster
GROUP BY floor_assigned
ORDER BY avg_overtime_per_shift DESC;

-- -------------------------------------------------------
-- ANALYSIS 4: Rooms assigned vs overtime correlation
-- Do more rooms assigned = more overtime?
-- -------------------------------------------------------
SELECT
    rooms_assigned_count,
    COUNT(*) AS shift_count,
    ROUND(AVG(overtime_hours), 2) AS avg_overtime,
    SUM(overtime_hours) AS total_overtime
FROM staff_roster
GROUP BY rooms_assigned_count
ORDER BY rooms_assigned_count ASC;

-- -------------------------------------------------------
-- ANALYSIS 5: Workload imbalance — compare rooms assigned
--             across floors on the SAME days
-- This reveals if some floors are over-allocated
-- -------------------------------------------------------
SELECT
    shift_date,
    day_of_week,
    floor_assigned,
    staff_name,
    rooms_assigned_count,
    overtime_hours,
    -- Flag imbalance: flag floors with 3+ more rooms than avg for that day
    ROUND(AVG(rooms_assigned_count) OVER (PARTITION BY shift_date), 1) AS daily_avg_rooms,
    rooms_assigned_count - ROUND(AVG(rooms_assigned_count) OVER (PARTITION BY shift_date), 1) AS rooms_above_avg
FROM staff_roster
ORDER BY shift_date, rooms_above_avg DESC;

-- -------------------------------------------------------
-- ANALYSIS 6: High overtime shifts (overtime > 1.5 hrs)
-- Pull the details of every blowout shift
-- -------------------------------------------------------
SELECT
    shift_date,
    day_of_week,
    staff_name,
    floor_assigned,
    rooms_assigned_count,
    hours_scheduled,
    hours_worked,
    overtime_hours
FROM staff_roster
WHERE overtime_hours >= 1.5
ORDER BY overtime_hours DESC;

-- -------------------------------------------------------
-- ANALYSIS 7: Estimated overtime cost
-- Assuming AUD $28/hr base + 50% penalty = $42/hr OT
-- -------------------------------------------------------
SELECT
    staff_name,
    SUM(overtime_hours) AS total_ot_hours,
    ROUND(SUM(overtime_hours) * 42, 2) AS estimated_ot_cost_aud
FROM staff_roster
GROUP BY staff_name
ORDER BY estimated_ot_cost_aud DESC;

SELECT
    'Total Overtime Cost (All Staff)' AS summary,
    ROUND(SUM(overtime_hours) * 42, 2) AS total_estimated_cost_aud
FROM staff_roster;
