# 📊 Power BI Dashboard Guide
## Velora Hotel Melbourne — Housekeeping Operations Analytics

---

## Overview

This guide walks you through building the 4-page Power BI dashboard from the project CSV files.
No prior Power BI experience assumed — every step is explained.

---

## Step 1 — Import Your Data

1. Open **Power BI Desktop** (free download from microsoft.com/powerbi)
2. Click **Home → Get Data → Text/CSV**
3. Import all four files one at a time:
   - `staff_roster.csv`
   - `room_assignments.csv`
   - `checkout_log.csv`
   - `room_status_log.csv`
4. For each file, click **Load** (not Transform — the data is already clean)

---

## Step 2 — Create Relationships (Data Model)

Go to **Model view** (icon on left sidebar) and create these relationships:

| From Table | From Column | To Table | To Column | Cardinality |
|-----------|-------------|----------|-----------|-------------|
| staff_roster | shift_date | checkout_log | checkout_date | Many-to-Many |
| staff_roster | staff_id | room_assignments | staff_id | One-to-Many |
| checkout_log | room_number | room_status_log | room_number | Many-to-Many |

> **Note:** Power BI may auto-detect some of these. Check they exist before building visuals.

---

## Step 3 — Create Key Measures (DAX)

In **Report view**, click **New Measure** and create the following:

### Measure 1 — Overall SLA Compliance %
```
SLA Compliance % =
DIVIDE(
    COUNTROWS(FILTER(room_status_log, room_status_log[sla_met] = "Yes")),
    COUNTROWS(room_status_log),
    0
) * 100
```

### Measure 2 — Total Overtime Hours
```
Total Overtime Hours =
SUM(staff_roster[overtime_hours])
```

### Measure 3 — Avg Room Clearance Time (minutes)
```
Avg Clearance Time =
AVERAGE(checkout_log[minutes_to_clear])
```

### Measure 4 — SLA Failures Count
```
SLA Failures =
COUNTROWS(FILTER(room_status_log, room_status_log[sla_met] = "No"))
```

### Measure 5 — Overtime Cost Estimate (AUD)
```
Overtime Cost AUD =
SUM(staff_roster[overtime_hours]) * 42
```
> Assumes AUD $28 base rate + 50% penalty = $42/hr overtime

---

## Step 4 — Build the Dashboard (4 Pages)

---

### PAGE 1 — Operations Overview

**Purpose:** High-level KPI snapshot for management

**Add these visuals:**

| Visual Type | Field | Purpose |
|------------|-------|---------|
| Card | `SLA Compliance %` | Headline KPI |
| Card | `Total Overtime Hours` | Labour headline |
| Card | `Avg Clearance Time` | Speed metric |
| Card | `SLA Failures` | Risk metric |
| Bar Chart | X: `day_of_week`, Y: `SUM(overtime_hours)` | Overtime by day |
| Line Chart | X: `log_date`, Y: `SLA Compliance %` | SLA trend over time |

**Formatting tips:**
- Set the SLA card conditional colour: green if ≥ 85, red if < 70
- Sort day of week: Mon, Tue, Wed, Thu, Fri (use Sort by Column)

---

### PAGE 2 — Checkout Bottleneck Analysis

**Purpose:** Show which time windows cause the most pressure

**Add these visuals:**

| Visual Type | Field | Purpose |
|------------|-------|---------|
| Clustered Bar | X: `checkout_hour_bucket`, Y: `COUNT(checkout_id)` | Volume by hour |
| Line Chart | X: `checkout_hour_bucket`, Y: `Avg Clearance Time` | Speed by hour |
| Stacked Bar | X: `floor`, Y: count, Legend: `cleared_within_60min` | SLA pass/fail by floor |
| Table | room_type, avg minutes_to_clear, SLA failures | Room type detail |

**Formatting tips:**
- Use a **dual-axis combo chart** for volume (bar) + clearance time (line) on one visual
- Highlight the 10:00-11:00 bar in red using conditional formatting

---

### PAGE 3 — Staff Productivity Tracker

**Purpose:** Compare individual staff performance

**Add these visuals:**

| Visual Type | Field | Purpose |
|------------|-------|---------|
| Bar Chart | Y: `staff_name`, X: `SUM(overtime_hours)` | Overtime per person |
| Scatter Chart | X: `AVG(minutes_taken)`, Y: `AVG(standard_minutes)`, Details: `staff_name` | Actual vs standard |
| Bar Chart | Y: `staff_name`, X: `COUNT(assignment_id)` | Rooms cleaned |
| Table | staff_name, avg_minutes_taken, avg_standard_minutes, overtime | Full comparison |

**Formatting tips:**
- Add a reference line on the scatter chart at Y=X (perfect efficiency)
- Colour-code bars: red for staff above avg overtime, green for below

---

### PAGE 4 — Staffing Optimisation

**Purpose:** Recommend reallocation based on data

**Add these visuals:**

| Visual Type | Field | Purpose |
|------------|-------|---------|
| Bar Chart | X: `floor_assigned`, Y: `AVG(rooms_assigned_count)` | Avg load per floor |
| Bar Chart | X: `floor_assigned`, Y: `AVG(overtime_hours)` | Avg OT per floor |
| Bar Chart | X: `day_of_week`, Y: `SUM(overtime_hours)` | OT concentration by day |
| Text Box | Manually add your 4 recommendations | Insight narrative |

**Formatting tips:**
- Add an average reference line to floor workload charts
- Use conditional formatting: floors above average in red, below in green

---

## Step 5 — Final Formatting

1. Add a **consistent colour theme** (go to View → Themes → choose a professional theme)
2. Add **page titles** using Text Box on each page
3. Add a **hotel logo or banner** at the top (Insert → Image)
4. Add **Velora Hotel Melbourne** as the report title on Page 1
5. Add your name and date in a footer text box

---

## Step 6 — Export / Share

- **Export to PDF:** File → Export → Export to PDF (for portfolio)
- **Publish:** File → Publish → Publish to Power BI (requires free account)
- **Screenshots:** Take screenshots of each page for your GitHub README

---

## Tips for Your Portfolio

- Take a **screenshot of each dashboard page** and add them to your GitHub README under a "Dashboard Preview" section
- In interviews, be ready to explain: *"I built this because we had no visibility into when our peak pressure hit. The 10-11am finding directly changed how we allocated staff."*
- Mention the specific DAX measures you wrote — it shows technical depth

---

*Built as part of the Velora Hotel Housekeeping Analytics case study by Ashwini Harikumar*
