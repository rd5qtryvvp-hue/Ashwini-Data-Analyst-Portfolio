Donor Segmentation & Retention Dashboard
Power BI • DAX • Donor Insights • CRM Analytics

This project focuses on analysing donor behaviour, segmenting donors into meaningful categories, and identifying patterns that can support fundraising strategy and retention planning. The dataset simulates CRM donation activity and donor demographics, enabling insights into donor value, loyalty, and giving trends.

📌 Objective

To segment donors based on donation behaviour and build insights that answer:

Who are our most valuable donors?

How many donors give repeatedly?

What segments contribute the highest revenue?

Are there patterns based on donor attributes (e.g., gender, country)?

How can we optimise donor-targeting campaigns?

📊 Dashboard Overview

The dashboard includes:

1. Donor Segmentation Chart

Segments donors into categories such as:

High-Value Donors

Occasional Donors

New Donors

Loyal Donors

This helps identify where to focus retention and engagement efforts.

2. Repeat Donor KPI

A KPI card displays the number of repeat donors (donors with more than one donation).
This metric is crucial for understanding donor loyalty and long-term fundraising sustainability.

3. Donation Summary KPIs

Key financial and volume metrics:

Total Donations

Total Revenue

Average Donation

Repeat Donor Count

These cards provide a quick snapshot for leadership and fundraising teams.

📂 Dataset

The analysis uses two CSV files:
| File                   | Description                                                    |
| ---------------------- | -------------------------------------------------------------- |
| `donors_sample.csv`    | Contains donor demographics (country, gender, etc.)            |
| `donations_sample.csv` | Contains transaction details (donation date, amount, donor_id) |

A relationship was created on:
donors_sample[donor_id] 1 → * donations_sample[donor_id]

🧮 Key DAX Measures Used
Total Donations
Total Donations = COUNT(donations_sample[donation_id])

Total Revenue
Total Revenue = SUM(donations_sample[amount])

Average Donation
Average Donation = AVERAGE(donations_sample[amount])

Repeat Donors
Repeat Donors =
CALCULATE(
    DISTINCTCOUNT(donations_sample[donor_id]),
    FILTER(
        donations_sample,
        CALCULATE(COUNT(donations_sample[donation_id])) > 1
    )
)

Donor Segment (Calculated Column)
Donor Segment =
VAR DonationCount =
    CALCULATE(COUNT(donations_sample[donation_id]), ALLEXCEPT(donations_sample, donations_sample[donor_id]))
VAR TotalAmount =
    CALCULATE(SUM(donations_sample[amount]), ALLEXCEPT(donations_sample, donations_sample[donor_id]))

RETURN
SWITCH(
    TRUE(),
    DonationCount > 3 && TotalAmount > 2000, "High Value Donor",
    DonationCount > 1, "Repeat Donor",
    DonationCount = 1, "New Donor",
    "Other"
)

📈 Visuals Included
| Visual                            | Purpose                                    |
| --------------------------------- | ------------------------------------------ |
| **Card KPIs**                     | Quick overview of volume & revenue metrics |
| **Donor Segment Bar / Pie Chart** | Breakdown of donor groups                  |
| **Repeat Donor KPI Card**         | Measures donor loyalty                     |
| **Table View of Donors**          | Shows donor-level insights                 |

💡 Key Insights

Repeat donors represent a small portion of total donors → opportunity for loyalty campaigns.

High-value donors contribute disproportionately to total fundraising revenue.

New donors form the largest group → acquisition is strong but retention can improve.

Segmentation highlights patterns needed for targeted fundraising.

📁 Folder Structure
Donor-Segmentation-Analysis/
│
├── donor_segmentation.pbix
├── donors_sample.csv
├── donations_sample.csv
└── README.md   ← (this file)

▶️ How to Run the Dashboard

Download the repository or this project folder.

Open donor_segmentation.pbix in Power BI Desktop.

Make sure both CSV files are in the same folder as the PBIX.

Refresh the data model if needed.

✨ Skills Demonstrated

✔ Power BI
✔ DAX (measures & calculated columns)
✔ Data Modelling (1-to-many relationships)
✔ KPI Design & Reporting
✔ Segmentation Analysis
✔ CRM Data Analysis
✔ Data Storytelling
