
# 🏨 Velora Hotel Melbourne — Housekeeping Operations Analytics

## Project Overview

**Context:**
Velora Hotel Melbourne is a 5-star, 300-room property in Southbank. As the data-savvy Housekeeping Manager, I identified recurring operational issues that were impacting guest satisfaction scores and blowing out labour budgets. Rather than continuing to manage reactively, I built a data pipeline to analyse root causes and recommend sustainable improvements.

**Tools Used:** SQL (MySQL) · Python (pandas, matplotlib, seaborn) · Power BI · Excel

**Data:** Simulated operational data based on real housekeeping workflows (anonymised and restructured for portfolio purposes)

---

## 🚨 The Problems

Through daily operations, I identified five recurring issues:

| # | Problem | Business Impact |
|---|---------|----------------|
| 1 | Uneven room allocation across floors | Some staff finished early, others ran overtime |
| 2 | Peak checkout bottlenecks (10am–12pm) | Rooms not cleared fast enough for early check-ins |
| 3 | Staff overtime blowouts | Labour cost exceeded budget 3 out of 4 weeks |
| 4 | Rooms not ready on time for check-in | Guest complaints and front desk escalations |
| 5 | No visibility into individual staff productivity | Impossible to identify training needs or top performers |

---

## 📁 Repository Structure

```
velora-hotel-housekeeping-analytics/
│
├── README.md
├── data/
│   ├── room_assignments.csv       ← Which staff member was assigned which room each day
│   ├── staff_roster.csv           ← Staff shifts, hours scheduled vs worked
│   ├── checkout_log.csv           ← Guest checkout times and room clearance times
│   └── room_status_log.csv        ← Room ready timestamps vs check-in request times
├── sql/
│   ├── 01_data_exploration.sql    ← Initial data profiling and quality checks
│   ├── 02_peak_checkout_analysis.sql  ← Identifying bottleneck windows
│   ├── 03_staff_overtime.sql      ← Overtime patterns and root cause
│   └── 04_room_readiness.sql      ← Room ready rate and delay analysis
├── python/
│   └── housekeeping_analysis.ipynb  ← Full EDA, visualisations, and insights
├── excel/
│   └── staffing_model_guide.md    ← How to use the Excel staffing model
└── powerbi/
    └── dashboard_guide.md         ← Power BI dashboard structure and instructions
```

---

## 🔍 Key Findings

- **62% of overtime hours** occurred on Mondays and Fridays — peak checkout days — yet staffing levels were identical across all weekdays
- **Floor 3 and Floor 7** were consistently over-allocated while **Floors 1 and 2** were under-allocated, creating imbalanced workloads
- **The 10am–11am window** accounted for 48% of all room clearance delays, directly tied to checkout bottlenecks
- **Room readiness SLA (ready within 2hrs of checkout)** was only being met 61% of the time
- Top 20% of staff by productivity were completing rooms **35% faster** than the bottom 20% — no structured mentoring existed

---

## 💡 Recommendations & Impact

| Recommendation | Estimated Impact |
|---------------|-----------------|
| Shift 2 additional staff to Monday/Friday morning shifts | Reduce overtime by ~28% |
| Rebalance floor allocation using room count + room type weighting | Reduce idle time by ~22% |
| Introduce a dedicated 10–11am checkout blitz team (3 staff) | Improve room readiness SLA from 61% to 85%+ |
| Pair bottom-quartile staff with top performers for 4-week shadowing | Projected 15% productivity uplift |

---

## 📊 Dashboard Preview

The Power BI dashboard contains 4 pages:
1. **Operations Overview** — Daily room clearance KPIs, SLA compliance rate
2. **Checkout Bottleneck Analysis** — Hourly checkout volume vs clearance capacity
3. **Staff Productivity Tracker** — Individual and team-level performance
4. **Staffing Optimisation** — Recommended vs actual allocation by day and floor

---

## 🚀 How to Run This Project

### Step 1 — Set up the database
```sql
CREATE DATABASE velora_hotel;
USE velora_hotel;
-- Then run the SQL files in order: 01 → 02 → 03 → 04
```

### Step 2 — Run the Python notebook
```bash
pip install pandas matplotlib seaborn jupyter
jupyter notebook python/housekeeping_analysis.ipynb
```

### Step 3 — Open Power BI
- Import the CSV files from the `/data` folder
- Follow the instructions in `/powerbi/dashboard_guide.md`

---

## 👩‍💻 About This Project

This project was developed to demonstrate how operational experience in hotel management can be combined with data analytics skills to drive measurable improvements. The data has been simulated to protect confidentiality while reflecting real operational patterns.

**Author:** Ashwini Harikumar
**LinkedIn:** [linkedin.com/in/ashwini-h-051a4a1b9](https://linkedin.com/in/ashwini-h-051a4a1b9)
**GitHub:** [github.com/rd5qtryvvp-hue/Ashwini-Data-Analyst-Portfolio](https://github.com/rd5qtryvvp-hue/Ashwini-Data-Analyst-Portfolio)
