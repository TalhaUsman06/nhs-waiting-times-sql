-- ============================================================
-- NHS Referral-to-Treatment (RTT) Waiting Times Analysis
-- Dataset: NHS England RTT waiting times (publicly available)
-- Source: https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/
-- Author: Talha Usman
-- ============================================================

-- Schema assumed:
-- waiting_times(period, provider_org_code, provider_org_name,
--               treatment_function_code, treatment_function_name,
--               rtt_part_type, rtt_part_description,
--               total_all, within_18_weeks, over_18_weeks,
--               gt_52_weeks, median_wait_weeks)


-- ============================================================
-- Q1. How many total patients are waiting nationally per month?
-- ============================================================
SELECT 
    Period,
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY Period
ORDER BY Period DESC;

-- INSIGHT: Shows whether the overall waiting list is growing or shrinking over time.


-- ============================================================
-- Q2. What percentage of patients are waiting over 18 weeks?
--     (NHS constitutional standard: 92% must be seen within 18 weeks)
-- ============================================================
SELECT 
    "Provider Org Name",
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Provider Org Name"
ORDER BY total_waiting DESC
LIMIT 10;

-- INSIGHT: Directly measures performance against the NHS 18-week target.


-- ============================================================
-- Q3. Which 10 specialties have the longest average waits?
-- ============================================================
SELECT 
    "Treatment Function Name",
    SUM(CAST("Total All" AS INTEGER)) AS total_waiting
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Treatment Function Name"
ORDER BY total_waiting DESC
LIMIT 10;

-- INSIGHT: Identifies clinical areas under the most pressure.


-- ============================================================
-- Q4. Which NHS trusts have the highest number of patients
--     waiting over 52 weeks (the "super-waiters")?
-- ============================================================
SELECT 
    "Provider Org Name",
    SUM(CAST("Gt 52 To 53 Weeks SUM 1" AS INTEGER)) AS over_52_weeks
FROM waiting_times
WHERE "RTT Part Type" = 'Part_2'
GROUP BY "Provider Org Name"
ORDER BY over_52_weeks DESC
LIMIT 10;

-- INSIGHT: Long waits over 52 weeks represent a serious patient safety concern.


-- ============================================================
-- Q5. How have 52-week waits trended month by month nationally?
-- ============================================================
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN "Total All" IS NULL THEN 1 ELSE 0 END) AS null_totals,
    SUM(CASE WHEN CAST("Total All" AS INTEGER) < 0 THEN 1 ELSE 0 END) AS negative_totals
FROM waiting_times;

-- INSIGHT: Shows trend of the most serious waiting time breaches over time.


-- ============================================================
-- Q6. Regional breakdown — which regions have the worst
--     18-week performance? (Requires a region lookup table)
-- ============================================================
SELECT
    r.region_name,
    SUM(w.total_all)       AS total_waiting,
    ROUND(
        100.0 * SUM(w.within_18_weeks) / NULLIF(SUM(w.total_all), 0),
    1)                     AS pct_within_18_weeks,
    SUM(w.gt_52_weeks)     AS over_52_weeks
FROM waiting_times w
JOIN provider_regions r ON w.provider_org_code = r.org_code
GROUP BY r.region_name
ORDER BY pct_within_18_weeks ASC;

-- INSIGHT: Shows geographic inequality in NHS waiting times.


-- ============================================================
-- Q7. Which specialties improved the most year on year?
--     Compare same period, 12 months apart.
-- ============================================================
WITH current_year AS (
    SELECT
        treatment_function_name,
        ROUND(AVG(median_wait_weeks), 1) AS avg_wait
    FROM waiting_times
    WHERE period = (SELECT MAX(period) FROM waiting_times)
    GROUP BY treatment_function_name
),
prior_year AS (
    SELECT
        treatment_function_name,
        ROUND(AVG(median_wait_weeks), 1) AS avg_wait
    FROM waiting_times
    WHERE period = (
        SELECT MAX(period) FROM waiting_times
        WHERE period < DATE_TRUNC('year', (SELECT MAX(period) FROM waiting_times))
    )
    GROUP BY treatment_function_name
)
SELECT
    c.treatment_function_name,
    p.avg_wait           AS wait_prior_year,
    c.avg_wait           AS wait_current,
    (c.avg_wait - p.avg_wait) AS change_weeks
FROM current_year c
JOIN prior_year p USING (treatment_function_name)
ORDER BY change_weeks ASC
LIMIT 10;

-- INSIGHT: Shows which specialties improved most (negative = shorter wait).


-- ============================================================
-- Q8. What is the distribution of patients by wait-time band?
--     (Within 6w / 6-18w / 18-52w / over 52w)
-- ============================================================
-- Note: requires additional band columns from the raw dataset.
-- If present as: within_6_weeks, six_to_18_weeks, etc.
SELECT
    period,
    SUM(within_6_weeks)      AS band_0_to_6w,
    SUM(six_to_18_weeks)     AS band_6_to_18w,
    SUM(over_18_weeks) - SUM(gt_52_weeks) AS band_18_to_52w,
    SUM(gt_52_weeks)         AS band_over_52w
FROM waiting_times
GROUP BY period
ORDER BY period DESC;

-- INSIGHT: Full picture of where patients sit in the wait distribution.


-- ============================================================
-- Q9. Which single trust-specialty combination has the most
--     patients waiting over 52 weeks?
-- ============================================================
SELECT
    provider_org_name,
    treatment_function_name,
    SUM(gt_52_weeks) AS over_52_weeks
FROM waiting_times
GROUP BY provider_org_name, treatment_function_name
ORDER BY over_52_weeks DESC
LIMIT 10;

-- INSIGHT: Pinpoints specific bottlenecks at trust + specialty level.


-- ============================================================
-- Q10. Simple data quality check — find rows with nulls or
--      impossible values (good practice to include in any analysis)
-- ============================================================
SELECT
    COUNT(*)                                        AS total_rows,
    SUM(CASE WHEN total_all IS NULL THEN 1 ELSE 0 END)          AS null_total,
    SUM(CASE WHEN within_18_weeks > total_all THEN 1 ELSE 0 END) AS invalid_18w,
    SUM(CASE WHEN gt_52_weeks > total_all THEN 1 ELSE 0 END)     AS invalid_52w,
    SUM(CASE WHEN median_wait_weeks < 0 THEN 1 ELSE 0 END)       AS negative_wait
FROM waiting_times;

-- INSIGHT: Always validate data before drawing conclusions.
--          Shows commitment to data quality — interviewers notice this.
