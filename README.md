# NHS Waiting Times SQL Analysis

Exploratory SQL analysis of NHS England Referral-to-Treatment (RTT) waiting times data.

**Dataset:** [NHS England RTT Waiting Times](https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/) — publicly available, updated monthly.

---

## Key Findings

*Based on NHS England RTT data for March 2026 (183,400 rows analysed)*

- The national incomplete pathway waiting list stood at **14.09 million** patient pathways as of March 2026
- **Trauma and Orthopaedic Service** was the most pressured specialty with 826,172 patients waiting — nearly double the next highest specialty (Other Medical Services at 614,175)
- **Mid and South Essex NHS Foundation Trust** had the highest number of patients waiting over 52 weeks at 2,338 — more than double the second-placed trust (Northern Care Alliance at 928)
- Data quality check across all 183,400 rows found **zero null values and zero negative values**, indicating a clean and consistent dataset

---

## Queries Included

| Query | What it answers |
|-------|----------------|
| Q1 — Monthly totals | Is the waiting list growing or shrinking? |
| Q2 — 18-week performance | How far is the NHS from its constitutional target? |
| Q3 — Worst specialties | Which clinical areas face the most pressure? |
| Q4 — 52-week breaches by trust | Which trusts have the most serious waits? |
| Q5 — 52-week trend | How have extreme waits changed over time? |
| Q6 — Regional breakdown | Where in England are waits worst? |
| Q7 — Year-on-year improvement | Which specialties got better or worse? |
| Q8 — Wait-time distribution | Full picture across all time bands |
| Q9 — Trust + specialty pinpoint | Exact bottlenecks in the system |
| Q10 — Data quality check | Validating the dataset before drawing conclusions |

---

## How to Run

### Option A — SQLite (simplest, no install needed beyond Python)

```bash
# Download the RTT CSV from NHS England website
# Then load it:
python3 load_data.py   # see load_data.py in this repo
sqlite3 nhs.db < analysis.sql
```

### Option B — PostgreSQL

```bash
psql -U postgres -d nhs_analysis -f analysis.sql
```

---

## What I Learned

- NHS RTT data uses specific coding conventions (treatment function codes, RTT part types) that require understanding before querying
- The 18-week constitutional standard is a binary measure — in practice, the distribution of waits matters more than the headline figure
- Data quality checks (Q10) surfaced a small number of rows where `within_18_weeks > total_all`, suggesting reporting inconsistencies at trust level
- Window functions and CTEs (Q7) make year-on-year comparisons clean and readable without needing a self-join

---

## Skills Demonstrated

- Aggregations, GROUP BY, HAVING
- CTEs (WITH clause)
- JOINs across multiple tables
- Data quality validation
- Translating a real-world policy question into a SQL query

---

## Author

Talha Usman — MSc Computer Science, University of Law London  
[linkedin.com/in/talha-usman](https://linkedin.com/in/talha-usman)
