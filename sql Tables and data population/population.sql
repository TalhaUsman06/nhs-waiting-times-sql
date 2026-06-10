-- ============================================================
-- NHS RTT Waiting Times Database
-- Sample Data Population
-- ============================================================

-- ============================================================
-- REGION (6 rows)
-- ============================================================
INSERT INTO Region (region_name, region_code) VALUES
    ('London' , 'LON'),
    ('South East' , 'SE'),
    ('South West' , 'SW'),
    ('Midlands', 'MID'),
    ('North East and Yorkshire', 'NEY'),
    ('North West' , 'NW');

-- ============================================================
-- TRUST (15 rows)
-- ============================================================
INSERT INTO Trust (trust_name, trust_code, region_id, parent_organisation) VALUES
    ('Barts Health NHS Trust' , 'RNJ', 1, 'NHS England'),
    ('Kings College Hospital NHS Foundation Trust','RJZ', 1, 'NHS England'),
    ('Guy''s and St Thomas'' NHS Foundation Trust','RJ1', 1, 'NHS England'),
    ('Oxford University Hospitals NHS FT' , 'RTH', 2, 'NHS England'),
    ('Brighton and Sussex University Hospitals', 'RYR', 2, 'NHS England'),
    ('Royal Devon and Exeter NHS FT', 'RH8', 3, 'NHS England'),
    ('North Bristol NHS Trust' , 'RVJ', 3, 'NHS England'),
    ('University Hospitals Birmingham NHS FT' , 'RRK', 4, 'NHS England'),
    ('Nottingham University Hospitals NHS Trust','RX1', 4, 'NHS England'),
    ('Leicester University Hospitals NHS Trust', 'RWE', 4, 'NHS England'),
    ('Leeds Teaching Hospitals NHS Trust' , 'RR8', 5, 'NHS England'),
    ('Sheffield Teaching Hospitals NHS FT',  'RHQ', 5, 'NHS England'),
    ('Manchester University NHS FT',  'R0A', 6, 'NHS England'),
    ('Liverpool University Hospitals NHS FT' , 'REM', 6, 'NHS England'),
    ('Salford Royal NHS FT' , 'RM3', 6, 'NHS England');

-- ============================================================
-- SPECIALTY (12 rows)
-- ============================================================
INSERT INTO Specialty (specialty_name, department) VALUES
    ('Trauma and Orthopaedics' , 'Surgical'),
    ('General Surgery', 'Surgical'),
    ('Cardiology' , 'Medical'),
    ('Gastroenterology' , 'Medical'),
    ('Ophthalmology' , 'Surgical'),
    ('Ear Nose and Throat', 'Surgical'),
    ('Neurology' , 'Medical'),
    ('Dermatology',  'Medical'),
    ('Urology',  'Surgical'),
    ('Gynaecology',  'Surgical'),
    ('Rheumatology' , 'Medical'),
    ('Respiratory Medicine' , 'Medical');

-- ============================================================
-- WAITING LIST SNAPSHOT (15 rows — one per trust, Jan 2025)
-- ============================================================
INSERT INTO Waiting_List_Snapshot (snapshot_date, trust_id, specialty_id, total_waiting) VALUES
    ('2025-01-31', 1,  1, 4820),
    ('2025-01-31', 2,  3, 3105),
    ('2025-01-31', 3,  5, 2870),
    ('2025-01-31', 4,  2, 5340),
    ('2025-01-31', 5,  6, 1950),
    ('2025-01-31', 6,  4, 2210),
    ('2025-01-31', 7,  9, 3670),
    ('2025-01-31', 8,  1, 6120),
    ('2025-01-31', 9,  2, 4490),
    ('2025-01-31', 10, 7, 2780),
    ('2025-01-31', 11, 1, 5910),
    ('2025-01-31', 12, 8, 1640),
    ('2025-01-31', 13, 3, 4230),
    ('2025-01-31', 14, 10,3380),
    ('2025-01-31', 15, 11,1720);

-- ============================================================
-- PATIENT PATHWAY (30 rows — 2 pathways per snapshot)
-- ============================================================
INSERT INTO Patient_Pathway (snapshot_id, trust_id, specialty_id, rtt_part_type, weeks_waiting, patient_count, is_breach) VALUES
    -- Snapshot 1 — Barts / T&O
    (1,  1,  1, 'Incomplete' , 12, 2100, 0),
    (1,  1,  1, 'Incomplete' , 22,  890, 1),
    -- Snapshot 2 — Kings / Cardiology
    (2,  2,  3, 'Non-Admitted' , 8, 1450, 0),
    (2,  2,  3, 'Non-Admitted',  20,  610, 1),
    -- Snapshot 3 — Guys / Ophthalmology
    (3,  3,  5, 'Admitted' , 6,  980, 0),
    (3,  3,  5, 'Admitted',  24,  430, 1),
    -- Snapshot 4 — Oxford / General Surgery
    (4,  4,  2, 'Incomplete' , 10, 2800, 0),
    (4,  4,  2, 'Incomplete' , 26,  910, 1),
    -- Snapshot 5 — Brighton / ENT
    (5,  5,  6, 'Non-Admitted',  14,  870, 0),
    (5,  5,  6, 'Non-Admitted',  19,  340, 1),
    -- Snapshot 6 — Royal Devon / Gastroenterology
    (6,  6,  4, 'Admitted' , 9, 1100, 0),
    (6,  6,  4, 'Admitted',  21,  380, 1),
    -- Snapshot 7 — North Bristol / Urology
    (7,  7,  9, 'Incomplete' , 11, 1840, 0),
    (7,  7,  9, 'Incomplete' , 23,  620, 1),
    -- Snapshot 8 — Birmingham / T&O
    (8,  8,  1, 'Incomplete' , 15, 3100, 0),
    (8,  8,  1, 'Incomplete' , 28, 1200, 1),
    -- Snapshot 9 — Nottingham / General Surgery
    (9,  9,  2, 'Non-Admitted',  13, 2300, 0),
    (9,  9,  2, 'Non-Admitted',  25,  780, 1),
    -- Snapshot 10 — Leicester / Neurology
    (10, 10, 7, 'Admitted' , 7,  980, 0),
    (10, 10, 7, 'Admitted',  30,  520, 1),
    -- Snapshot 11 — Leeds / T&O
    (11, 11, 1, 'Incomplete' , 16, 2900, 0),
    (11, 11, 1, 'Incomplete' , 32, 1100, 1),
    -- Snapshot 12 — Sheffield / Dermatology
    (12, 12, 8, 'Non-Admitted' , 5,  840, 0),
    (12, 12, 8, 'Non-Admitted',  18,  190, 1),
    -- Snapshot 13 — Manchester / Cardiology
    (13, 13, 3, 'Incomplete' , 10, 2200, 0),
    (13, 13, 3, 'Incomplete' , 27,  780, 1),
    -- Snapshot 14 — Liverpool / Gynaecology
    (14, 14, 10,'Admitted',  11, 1700, 0),
    (14, 14, 10,'Admitted',  22,  560, 1),
    -- Snapshot 15 — Salford / Rheumatology
    (15, 15, 11,'Non-Admitted',  13,  890, 0),
    (15, 15, 11,'Non-Admitted',  20,  350, 1);
