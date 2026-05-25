-- ============================================================
-- NHS Referral-to-Treatment (RTT) Waiting Times Analysis
-- Dataset: NHS England RTT Incomplete Pathways - March 2026
-- Source: https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/
-- Author: Talha Usman
-- Total rows: 183,400
-- RTT Part Type used: Part_2 (Incomplete Pathways)
-- ============================================================


-- ============================================================
-- Q1. How many total patients are waiting nationally?
-- ============================================================
SELECT 
    Period,
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY Period
ORDER BY Period DESC;

-- RESULT: 14,091,020 patient pathways as of March 2026
-- INSIGHT: Shows the total scale of the NHS waiting list.


-- ============================================================
-- Q2. Which NHS trusts have the most patients waiting?
-- ============================================================
SELECT 
    "Provider Org Name",
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Provider Org Name"
ORDER BY total_waiting DESC
LIMIT 10;

-- RESULT: Mid and South Essex NHS FT leads with 347,954 patients
-- INSIGHT: Larger trusts with more specialties naturally have higher totals.
--          This query identifies where capacity pressure is concentrated.


-- ============================================================
-- Q3. Which specialties have the most patients waiting?
-- ============================================================
SELECT 
    "Treatment Function Name",
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Treatment Function Name"
ORDER BY total_waiting DESC
LIMIT 10;

-- RESULT: Trauma & Orthopaedic Service: 826,172 patients
--         Ophthalmology: 603,966 | ENT: 580,054 | Gynaecology: 555,528
-- INSIGHT: Elective surgical specialties dominate the waiting list,
--          reflecting pandemic backlog in planned procedures.


-- ============================================================
-- Q4. Which trusts have the most patients waiting over 52 weeks?
-- ============================================================
SELECT 
    "Provider Org Name",
    SUM(CAST("Gt 52 To 53 Weeks SUM 1" AS INTEGER)) AS over_52_weeks
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Provider Org Name"
ORDER BY over_52_weeks DESC
LIMIT 10;

-- RESULT: Mid and South Essex NHS FT: 2,338 patients over 52 weeks
--         Northern Care Alliance: 928 | University Hospitals Sussex: 818
-- INSIGHT: 52-week waits represent a serious patient safety concern.
--          Mid Essex has more than double the second-placed trust.


-- ============================================================
-- Q5. Data quality check
-- ============================================================
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN "Total All" IS NULL THEN 1 ELSE 0 END) AS null_totals,
    SUM(CASE WHEN CAST("Total All" AS INTEGER) < 0 THEN 1 ELSE 0 END) AS negative_totals
FROM waiting_times;

-- RESULT: 183,400 rows | 0 nulls | 0 negative values
-- INSIGHT: Dataset is clean with no missing or invalid values.
--          Always validate data before drawing conclusions.


-- ============================================================
-- Q6. Which specialties have the longest average wait?
--     (using week buckets to find where most patients sit)
-- ============================================================
SELECT 
    "Treatment Function Name",
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting,
    SUM(CAST("Gt 18 To 19 Weeks SUM 1" AS INTEGER)) AS entering_over_18w
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
  AND "Treatment Function Name" != 'Total'
GROUP BY "Treatment Function Name"
ORDER BY entering_over_18w DESC
LIMIT 10;

-- INSIGHT: Shows which specialties have the most patients
--          crossing the 18-week NHS constitutional standard.


-- ============================================================
-- Q7. Regional breakdown by Provider Parent (NHS region)
-- ============================================================
SELECT 
    "Provider Parent Name",
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting,
    SUM(CAST("Gt 52 To 53 Weeks SUM 1" AS INTEGER)) AS over_52_weeks
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Provider Parent Name"
ORDER BY total_waiting DESC
LIMIT 10;

-- INSIGHT: Shows geographic distribution of waiting list pressure
--          across NHS regions and provider groups.
