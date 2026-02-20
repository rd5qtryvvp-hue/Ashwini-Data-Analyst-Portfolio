# 🧼 Data Quality Report  
### Donation & Donor Dataset Assessment

This report evaluates the quality of the raw CRM-style data and documents the resolved issues after applying cleaning and transformation rules.

---

## 🔍 Data Issues Identified (Before Cleaning)

| Issue Type | Description | Frequency |
|------------|-------------|-----------|
| **Duplicate donor emails** | Same email linked to multiple donor profiles | 12% |
| **Missing donor_id** | Donation records without donor reference | 6% |
| **Invalid donation amounts** | Zero or negative values | 4% |
| **Inconsistent date formats** | DD/MM, MM/DD, text-based dates | 18% |
| **Incorrect or blank gender fields** | Random text, blanks | 9% |
| **Mismatched donor-donation links** | Donation references donor not in donor table | 5% |

---

## 🛠 Cleaning Actions Applied

1. Removed invalid donation amounts  
2. Standardised name and email fields  
3. Converted all dates to `YYYY-MM-DD`  
4. Deleted donations with missing donor_id  
5. Merged duplicate donor profiles  
6. Normalised gender to: Male/Female/Other  
7. Revalidated foreign keys between tables  

---

## ✔ Data Quality Improvement Summary

| Metric | Before | After |
|--------|--------|--------|
| Duplicate donors | 12% | **0%** |
| Null donor_id entries | 6% | **0%** |
| Invalid amounts | 4% | **0%** |
| Date inconsistencies | 18% | **0%** |
| Invalid emails | 7% | **<1%** |
| Gender inconsistencies | 9% | **0%** |

---

## ⭐ Final Outcome

The dataset improved from **~72% → 95% data quality**, making it suitable for:

- CRM upload  
- Dashboards  
- Segmentation  
- Donor behaviour analysis  
- Year-on-year comparisons  


