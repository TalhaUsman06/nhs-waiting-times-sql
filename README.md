# NHS Waiting Times Analysis & Dashboard

Exploratory SQL analysis and interactive visualisation of NHS England Referral-to-Treatment (RTT) waiting times data — 183,400 rows covering March 2026.

**🔴 Live Dashboard:** [talhausman06.github.io/nhs-waiting-times-sql](https://talhausman06.github.io/nhs-waiting-times-sql/)

**Dataset:** [NHS England RTT Waiting Times](https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/) — publicly available, updated monthly.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Data analysis | SQL (SQLite via DB Browser for SQLite) |
| Visualisation | HTML5, CSS3, JavaScript (vanilla) |
| Charting library | Chart.js 4.4 |
| Data source | NHS England open data (CSV, ~183k rows) |
| Hosting | GitHub Pages |

---

## Key Findings

*Based on NHS England RTT incomplete pathway data, March 2026*

- The national incomplete pathway waiting list stood at **14.09 million** patient pathways as of March 2026
- **Trauma and Orthopaedic Service** was the most pressured specialty with 826,172 patients waiting — nearly double the next highest specialty (Other Medical Services at 614,175)
- **Mid and South Essex NHS Foundation Trust** had the highest number of patients waiting over 52 weeks at 2,338 — more than 2.5× the second-placed trust (Northern Care Alliance at 928)
- Data quality check across all 183,400 rows found **zero null values and zero negative values**, confirming a clean and consistent dataset

---

## What's in this repo

```
nhs-waiting-times-sql/
├── analysis.sql      # 7 SQL queries with real results and comments
├── index.html        # Interactive dashboard (Chart.js visualisations)
└── README.md
```

---

## SQL Queries Included

| Query | What it answers |
|-------|----------------|
| Q1 — Total patients waiting | Scale of the national waiting list |
| Q2 — Trusts with most patients | Where capacity pressure is concentrated |
| Q3 — Specialties with most patients | Which clinical areas face the most demand |
| Q4 — 52-week breaches by trust | Which trusts have the most serious long waits |
| Q5 — Data quality check | Validating the dataset before drawing conclusions |
| Q6 — Patients crossing 18-week mark | Performance against the NHS constitutional standard |
| Q7 — Regional breakdown by provider parent | Geographic distribution of waiting list pressure |

---

## How to Run Locally

### Step 1 — Download the data
Go to [NHS England RTT Waiting Times](https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/), download the latest **Incomplete Pathways** CSV.

### Step 2 — Load into SQLite
1. Download [DB Browser for SQLite](https://sqlitebrowser.org/dl/) (free)
2. New Database → save as `nhs.db`
3. File → Import → Table from CSV → tick "Column names in first line" → table name: `waiting_times`

### Step 3 — Run the queries
Open the Execute SQL tab, paste queries from `analysis.sql` and run.

---

## What I Learned

- NHS RTT data uses specific coding conventions (`RTT Part Type`: Part_1A, Part_1B, Part_2, Part_2A, Part_3) that must be understood before filtering — querying without the right `WHERE` clause returns no results
- Real public datasets require exploration before analysis — running `PRAGMA table_info()` and `SELECT DISTINCT` to understand the schema is essential
- Data quality checks should always be included in any analysis — even well-maintained government datasets can have reporting inconsistencies at trust level
- `CAST(column AS INTEGER)` is necessary in SQLite when numeric columns are stored as TEXT during CSV import

---

## Skills Demonstrated

- SQL aggregations, `GROUP BY`, `HAVING`, `ORDER BY`
- `CAST` and type handling in SQLite
- Data exploration with `PRAGMA table_info()` and `SELECT DISTINCT`
- Data quality validation
- Translating real-world policy questions into SQL queries
- Frontend data visualisation with Chart.js
- Deploying a static site via GitHub Pages

---

## Author

Talha Usman — MSc Computer Science, University of Law London
[linkedin.com/in/talha-usman](https://linkedin.com/in/talha-usman) · [github.com/TalhaUsman06](https://github.com/TalhaUsman06)
