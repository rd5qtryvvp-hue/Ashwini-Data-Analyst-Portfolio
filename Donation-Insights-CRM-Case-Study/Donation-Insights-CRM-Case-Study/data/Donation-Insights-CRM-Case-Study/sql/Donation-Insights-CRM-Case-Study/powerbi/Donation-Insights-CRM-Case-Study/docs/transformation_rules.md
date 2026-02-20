# 🔄 Transformation Rules  
### Standardisation Guidelines for CRM-Style Donation Data

The transformation rules below ensure consistency and readiness for analytics and CRM migration.

---

## 🗂 Donor Table Rules

### 1. Name Formatting
- Apply `INITCAP()`  
- Remove leading/trailing whitespace  

### 2. Email Normalisation
- Convert to lowercase  
- Trim whitespace  
- Validate pattern: `*@*.*`  

### 3. Gender Standardisation
Convert any variation into:
- Male  
- Female  
- Other  

### 4. Missing Fields
- If state is null → infer from country when possible  
- Invalid characters removed from first/last name  

---

## 💰 Donation Table Rules

### 1. Invalid Amount Handling
- Remove donations <= $0  
- Remove extremely high values (likely errors)  

### 2. Date Normalisation
- Convert all donation dates to `YYYY-MM-DD`  

### 3. FK Validation
- Any donation referencing missing donor_id → flagged  

### 4. Duplicate Detection
Duplicates detected via:
- donor_id + amount + donation_date (same timestamp)  

---

## 🔍 Optional Enhancements
- Add proxy donor IDs when missing  
- Use fuzzy matching for name/email similarity  
- Map donation campaigns (if available)

---

## 🧩 Final Output
A clean, standardised dataset ready for:

- CRM migration  
- Power BI dashboards  
- Donor segmentation  
- KPI reporting  


