# 🏨 Velora Hotel Melbourne — Housekeeping Operations Analytics

> Operational analytics project combining hotel management experience with SQL, Python, Tableau, and Excel to identify root causes of overtime blowouts, SLA failures, and staffing imbalances across a 300-room property.

---

## 📌 Project Overview

**Context:**
Velora Hotel Melbourne is a 5-star, 300-room property in Southbank. As the data-savvy Housekeeping Manager, I noticed we were managing reactively — staff were allocated evenly regardless of actual workload, overtime was routine, and rooms were regularly not ready for check-in. I built a full analytics pipeline to diagnose the root causes and present data-backed operational recommendations.

**Tools Used:**

| Tool | Purpose |
|------|---------|
| SQL (MySQL) | Data profiling, validation, overtime and SLA analysis |
| Python (pandas, matplotlib, seaborn) | Exploratory analysis, visualisations, productivity modelling |
| Tableau Public | Interactive KPI dashboards, trend reporting |
| Excel (VLOOKUP, CEILING) | Dynamic staffing calculator with floor-level allocation |

**Data:** Simulated operational data based on real housekeeping workflows. Anonymised and restructured for portfolio purposes.

---

## 🚨 The Problems

Through daily operations I identified five recurring issues that were consistently impacting guest satisfaction and labour costs:

| # | Problem | Business Impact |
|---|---------|----------------|
| 1 | Uneven room allocation across floors | Some staff finished 2hrs early, others ran overtime daily |
| 2 | Peak checkout bottleneck (10–11am) | Rooms not cleared fast enough for early arrivals |
| 3 | Staff overtime blowouts | Labour cost exceeded budget 3 out of 4 weeks |
| 4 | Rooms not ready on time for check-in | Front desk escalations and guest complaints |
| 5 | No visibility into individual staff productivity | Impossible to identify training needs or top performers |

---

## 📁 Repository Structure

```
velora-hotel-housekeeping-analytics/
│
├── README.md
├── data/
│   ├── staff_roster.csv           ← Staff shifts, hours scheduled vs worked, overtime
│   ├── room_assignments.csv       ← Which staff cleaned which room, time taken vs standard
│   ├── checkout_log.csv           ← Guest checkout times, clearance times, SLA flag
│   └── room_status_log.csv        ← Room ready timestamps vs check-in request times
├── sql/
│   ├── 01_data_exploration.sql    ← Data profiling, null checks, quality validation
│   ├── 02_peak_checkout_analysis.sql  ← Bottleneck windows by hour and floor
│   ├── 03_staff_overtime.sql      ← Overtime patterns by staff, day, and floor
│   └── 04_room_readiness.sql      ← SLA compliance rate, delays, productivity
├── python/
│   └── housekeeping_analysis.ipynb  ← Full EDA, 5 charts, summary findings
├── excel/
│   └── staffing_model_guide.md    ← Dynamic staffing calculator — instructions
└── powerbi/
    └── dashboard_guide.md         ← 4-page Power BI dashboard — step-by-step guide
```

---

## 🔍 Key Findings

- **62% of overtime hours** occurred on Mondays and Fridays — peak checkout days — yet staffing levels were identical across all weekdays
- **Floors 3 and 7** were consistently over-allocated while **Floors 1 and 2** were under-utilised on the same shifts, creating avoidable imbalance
- **The 10–11am window** accounted for 48% of all room clearance delays, directly tied to checkout volume peaking at that hour
- **Room readiness SLA** (ready before check-in) was only being met **61% of the time** against a target of 85%
- Top 20% of staff by productivity completed rooms **35% faster** than the bottom 20% — no structured mentoring or coaching existed

---

## 💡 Recommendations & Impact

| Recommendation | Estimated Impact |
|---------------|-----------------|
| Add 2 staff to Monday/Friday morning shifts | Reduce overtime by ~28% |
| Rebalance floor allocation using room count + room type weighting | Reduce idle time by ~22% |
| Deploy a dedicated 10–11am checkout blitz team (3 staff) | Improve room readiness SLA from 61% → 85%+ |
| Pair bottom-quartile staff with top performers for 4-week shadowing | Projected 15% productivity uplift |

---

## 📊 Tableau Dashboard

The dashboard is built from the 4 CSV files and contains 4 pages. Full overview is in `/tableau/README.md`.

| Page | Content |
|------|---------|
| 1. Operations Overview | SLA compliance %, total overtime, avg clearance time — KPI cards + trend line |
| 2. Checkout Bottleneck Analysis | Hourly checkout volume vs clearance speed, SLA pass/fail by floor |
| 3. Staff Productivity Tracker | Actual vs standard minutes per room, overtime by staff member |
| 4. Staffing Optimisation | Floor workload imbalance, recommended vs actual allocation by day |

---

## 📋 Excel Staffing Model

The Excel model replaces flat daily staff allocation with a **workload-driven calculation** that accounts for room type and checkout volume. Full build instructions are in `/excel/staffing_model_guide.md`.

### How it works — 5 tabs

**Tab 1 — Inputs:** Daily forecast data entered here

| Column | Description | Example |
|--------|-------------|---------|
| Date | Shift date | 01/01/2024 |
| Day of Week | `=TEXT(A2,"dddd")` | Monday |
| Expected Checkouts | From front office | 45 |
| Suite Count | Suite checkouts | 8 |
| Deluxe King Count | Deluxe checkouts | 15 |
| Standard Room Count | Standard checkouts | 22 |

**Tab 2 — Time Standards:** Reference table for VLOOKUP

| Room Type | Standard Clean (min) | Checkout Clean (min) |
|-----------|---------------------|---------------------|
| Standard Double | 25 | 30 |
| Deluxe King | 35 | 40 |
| Suite | 50 | 60 |

**Tab 3 — Staffing Calculator:** Core formulas

```excel
Total workload (min):
=VLOOKUP("Standard Double",TimeStandards,3,FALSE)*Inputs!G2
+VLOOKUP("Deluxe King",TimeStandards,3,FALSE)*Inputs!F2
+VLOOKUP("Suite",TimeStandards,3,FALSE)*Inputs!E2

Recommended staff count:
=CEILING(B2/480, 1)
```
> 480 = minutes in an 8-hour shift. CEILING always rounds up — you can't have half a person.

```excel
Variance from actual:  =C2-D2
Risk flag:             =IF(E2<0,"⚠️ UNDERSTAFFED","✅ OK")
```

**Tab 4 — Floor Allocation:** Weighted split across floors

| Floor | Room Mix | Formula |
|-------|----------|---------|
| Floor 1 | All Standard | `=ROUND(20/total_rooms * total_staff, 0)` |
| Floor 2 | All Standard | `=ROUND(20/total_rooms * total_staff, 0)` |
| Floor 3 | Mixed | `=ROUND(25/total_rooms * total_staff, 0)` |
| Floor 5 | Deluxe/Suites | `=ROUND(25/total_rooms * 1.3 * total_staff, 0)` |
| Floor 6 | Mixed | `=ROUND(20/total_rooms * total_staff, 0)` |
| Floor 7 | Suites/Deluxe | `=ROUND(25/total_rooms * 1.3 * total_staff, 0)` |

> Floors 5 and 7 use a **1.3x weighting factor** — suites take 30% longer to clean than standard rooms. This directly corrects the historical under-allocation identified in the SQL analysis.

**Tab 5 — Dashboard:** Conditional formatting traffic light
- 🟢 Green — staffing within ±1 of recommendation
- 🟡 Yellow — off by 2
- 🔴 Red — off by 3 or more

---

## 🚀 How to Run This Project

### Step 1 — Set up the SQL database
```sql
CREATE DATABASE velora_hotel;
USE velora_hotel;
-- Run SQL files in order: 01 → 02 → 03 → 04
-- Each file includes CREATE TABLE statements at the top
```

### Step 2 — Import CSV data
After running `01_data_exploration.sql` to create the tables, import the 4 CSV files from the `/data` folder using your MySQL client (MySQL Workbench: Table → Import Wizard).

### Step 3 — Run the Python notebook
```bash
pip install pandas matplotlib seaborn jupyter
jupyter notebook python/housekeeping_analysis.ipynb
```
Make sure the `/data` folder is one level above the `/python` folder before running.

### Step 4 — Open Tableau Public
- Download Tableau Public free from **public.tableau.com**
- Connect to the 4 CSV files from the `/data` folder
- Follow `/tableau/README.md` for dashboard build instructions

### Step 5 — Build the Excel staffing model
Open Excel → create 5 tabs as described in `/excel/staffing_model_guide.md` → use the VLOOKUP and CEILING formulas above.

---

## 👩‍💻 About This Project

This project bridges two sides of my background — operational hotel management and data analytics. The problems in this project are real problems I observed firsthand. The data has been simulated to protect confidentiality while accurately reflecting operational patterns.

The goal was to show that someone who has worked on the floor of a hotel understands *which* metrics actually matter — not just how to query them.

**Author:** Ashwini Harikumar
**LinkedIn:** [linkedin.com/in/ashwini-h-051a4a1b9](https://linkedin.com/in/ashwini-h-051a4a1b9)
**GitHub:** [github.com/rd5qtryvvp-hue/Ashwini-Data-Analyst-Portfolio](https://github.com/rd5qtryvvp-hue/Ashwini-Data-Analyst-Portfolio)
