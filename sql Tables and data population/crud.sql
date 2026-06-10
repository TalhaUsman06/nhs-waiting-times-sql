***************************************************************
-- NHS RTT Waiting Times Database
-- Modifications & Updates Script — Assessment Task 2
***************************************************************
     

-- 1. UPDATE — Correct a trust's parent organisation name
     
UPDATE Trust
SET    parent_organisation = 'NHS England (Integrated Care Board)'
WHERE  trust_code = 'RNJ';

-- Verify
SELECT trust_id, trust_name, parent_organisation
FROM   Trust
WHERE  trust_code = 'RNJ';

     
--2. UPDATE — Recategorise a pathway as a breach after audit
  --(pathway_id 1 found to have exceeded 18 weeks on review)
     
UPDATE Patient_Pathway
SET    is_breach = 1
WHERE  pathway_id = 1
  AND  weeks_waiting > 18;

-- Verify
SELECT pathway_id, weeks_waiting, is_breach
FROM   Patient_Pathway
WHERE  pathway_id = 1;

     
-- 3. UPDATE — Bulk-mark all pathways with weeks_waiting > 52 as breaches (52-week RTT constitutional standard breach)
     
UPDATE Patient_Pathway
SET    is_breach = 1
WHERE  weeks_waiting > 52;

-- Verify — show any updated rows
SELECT pathway_id, trust_id, weeks_waiting, is_breach
FROM   Patient_Pathway
WHERE  weeks_waiting > 52;

     
-- 4. INSERT — Add a new NHS region
     
INSERT INTO Region (region_name, region_code)
VALUES ('East of England', 'EAE');

-- Verify
SELECT * FROM Region;

     
-- 5. INSERT — Add a new Trust in the new region
     
INSERT INTO Trust (trust_name, trust_code, region_id, parent_organisation)
VALUES (
    'Cambridge University Hospitals NHS FT',
    'RGT',
    (SELECT region_id FROM Region WHERE region_code = 'EAE'),
    'NHS England'
);

-- Verify
SELECT t.trust_name, t.trust_code, r.region_name
FROM   Trust t
JOIN   Region r ON t.region_id = r.region_id
WHERE  t.trust_code = 'RGT';

     
-- 6. INSERT — Add a new specialty
     
INSERT INTO Specialty (specialty_name, department)
VALUES ('Oncology', 'Medical');

     
-- 7. INSERT — Add a snapshot for the new trust (Feb 2025)
     
INSERT INTO Waiting_List_Snapshot (snapshot_date, trust_id, specialty_id, total_waiting)
VALUES (
    '2025-02-28',
    (SELECT trust_id FROM Trust WHERE trust_code = 'RGT'),
    (SELECT specialty_id FROM Specialty WHERE specialty_name = 'Oncology'),
    1280
);

     
-- 8. DELETE — Remove a duplicate/erroneous snapshot entry (safety: only delete if snapshot has no child pathways)
     
   First, insert a throwaway snapshot to safely demo DELETE
INSERT INTO Waiting_List_Snapshot (snapshot_date, trust_id, specialty_id, total_waiting)
VALUES ('2025-01-01', 1, 1, 0);

   Now delete it
DELETE FROM Waiting_List_Snapshot
WHERE  snapshot_date = '2025-01-01'
  AND  trust_id = 1
  AND  total_waiting = 0;

-- Verify it is gone
SELECT * FROM Waiting_List_Snapshot WHERE snapshot_date = '2025-01-01';

     
-- 9. UPDATE — Increase patient count after data re-submission from a trust (pathway_id 3 corrected by source system)
     
UPDATE Patient_Pathway
SET    patient_count = patient_count + 45
WHERE  pathway_id = 3;

-- Verify
SELECT pathway_id, patient_count FROM Patient_Pathway WHERE pathway_id = 3;

     
-- 10. UPDATE — Update total_waiting in snapshot after patient_count corrections are applied
     
UPDATE Waiting_List_Snapshot
SET    total_waiting = (
    SELECT SUM(patient_count)
    FROM   Patient_Pathway
    WHERE  snapshot_id = 3
)
WHERE  snapshot_id = 3;

-- Verify
SELECT snapshot_id, total_waiting FROM Waiting_List_Snapshot WHERE snapshot_id = 3;
