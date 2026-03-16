# 📋 Excel Staffing Model Guide
## Velora Hotel Melbourne — Optimal Staffing Calculator

---

## Purpose

This Excel model lets you input daily occupancy and checkout volume to calculate the **recommended number of housekeeping staff per floor** — replacing the current flat daily allocation.

---

## How to Build It in Excel

### Tab 1 — Inputs

Create a table with these columns:

| Column | Description | Example Value |
|--------|-------------|---------------|
| Date | Shift date | 01/01/2024 |
| Day of Week | Auto-calculated with =TEXT(A2,"dddd") | Monday |
| Expected Checkouts | From front office forecast | 45 |
| Expected Stay-Overs | Rooms not checking out | 60 |
| Suite Count | Number of suite checkouts | 8 |
| Deluxe King Count | Number of deluxe checkouts | 15 |
| Standard Room Count | Remaining checkouts | 22 |

---

### Tab 2 — Time Standards

Set up a reference table your formulas will look up:

| Room Type | Standard Clean Time (min) | Checkout Clean Time (min) |
|-----------|--------------------------|--------------------------|
| Standard Double | 25 | 30 |
| Deluxe King | 35 | 40 |
| Suite | 50 | 60 |

---

### Tab 3 — Staffing Calculator

**Column A:** Date (linked from Tab 1)  
**Column B:** Total workload minutes

Formula for B2:
```
=VLOOKUP("Standard Double",TimeStandards,3,FALSE)*Inputs!G2
+VLOOKUP("Deluxe King",TimeStandards,3,FALSE)*Inputs!F2
+VLOOKUP("Suite",TimeStandards,3,FALSE)*Inputs!E2
```

**Column C:** Recommended staff count
```
=CEILING(B2/480, 1)
```
> 480 = 8-hour shift in minutes. CEILING rounds up to nearest whole person.

**Column D:** Current staff allocated (manually enter)

**Column E:** Variance
```
=C2-D2
```

**Column F:** Overtime risk flag
```
=IF(E2<0,"⚠️ UNDERSTAFFED","✅ OK")
```

---

### Tab 4 — Floor Allocation

Once you know total staff count, split them across floors:

| Floor | Room Count | Room Mix | Recommended Staff |
|-------|-----------|----------|-------------------|
| Floor 1 | 20 | All Standard | =ROUND(20/total_rooms * total_staff, 0) |
| Floor 2 | 20 | All Standard | =ROUND(20/total_rooms * total_staff, 0) |
| Floor 3 | 25 | Mixed | =ROUND(25/total_rooms * total_staff, 0) |
| Floor 5 | 25 | Deluxe/Suites | =ROUND(25/total_rooms * 1.3 * total_staff, 0) |
| Floor 6 | 20 | Mixed | =ROUND(20/total_rooms * total_staff, 0) |
| Floor 7 | 25 | Suites/Deluxe | =ROUND(25/total_rooms * 1.3 * total_staff, 0) |

> **Note:** Floors 5 and 7 use a 1.3x weighting factor because suites take longer. This corrects the historical under-allocation problem identified in this project.

---

### Tab 5 — Dashboard (Optional)

Add a simple summary table and conditional formatting:
- **Green:** Staffing within ±1 of recommendation
- **Yellow:** Off by 2
- **Red:** Off by 3 or more

---

## How to Use This in Interviews

This model demonstrates:
1. **Business logic** — you understood that suites take longer and applied a weighting
2. **Data-driven planning** — replacing gut-feel rostering with calculation
3. **Excel skills** — VLOOKUP, CEILING, conditional formatting, structured tables

Say: *"I built this after identifying that we were allocating staff evenly when workload was anything but even. Floors with heavy suite volumes needed 30% more time per room — this model calculates that automatically."*

---

*Part of the Velora Hotel Housekeeping Analytics project by Ashwini Harikumar*
