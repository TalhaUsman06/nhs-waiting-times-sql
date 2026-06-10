 *************************************
-- NHS RTT Waiting Times Database
-- DDL Script — Assessment Task 2
 *************************************

-- REGION Table
CREATE TABLE Region (
    region_id INTEGER PRIMARY KEY AUTOINCREMENT,
    region_name TEXT NOT NULL UNIQUE,
    region_code TEXT NOT NULL UNIQUE
);
 
 
-- TRUST Table
CREATE TABLE Trust (
    trust_id INTEGER PRIMARY KEY AUTOINCREMENT,
    trust_name  TEXT    NOT NULL,
    trust_code  TEXT    NOT NULL UNIQUE,
    region_id   INTEGER NOT NULL,
    parent_organisation TEXT,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

 
-- SPECIALTY Table
CREATE TABLE Specialty (
    specialty_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    specialty_name  TEXT    NOT NULL UNIQUE,
    department  TEXT    NOT NULL
);

 
-- WAITING LIST SNAPSHOT Table
CREATE TABLE Waiting_List_Snapshot (
    snapshot_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    snapshot_date    TEXT    NOT NULL, 
    trust_id INTEGER NOT NULL,
    specialty_id INTEGER NOT NULL,
    total_waiting    INTEGER NOT NULL CHECK (total_waiting >= 0),
    FOREIGN KEY (trust_id) REFERENCES Trust(trust_id),
    FOREIGN KEY (specialty_id) REFERENCES Specialty(specialty_id)
);

 
-- PATIENT PATHWAY Table
CREATE TABLE Patient_Pathway (
    pathway_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    snapshot_id INTEGER NOT NULL,
    trust_id INTEGER NOT NULL,
    specialty_id    INTEGER NOT NULL,
    rtt_part_type   TEXT    NOT NULL CHECK (rtt_part_type IN ('Admitted','Non-Admitted','Incomplete')),
    weeks_waiting   INTEGER NOT NULL CHECK (weeks_waiting >= 0),
    patient_count   INTEGER NOT NULL CHECK (patient_count >= 0),
    is_breach   INTEGER NOT NULL DEFAULT 0 CHECK (is_breach IN (0, 1)),  -- 1 = waiting > 18 weeks
    FOREIGN KEY (snapshot_id)  REFERENCES Waiting_List_Snapshot(snapshot_id),
    FOREIGN KEY (trust_id) REFERENCES Trust(trust_id),
    FOREIGN KEY (specialty_id) REFERENCES Specialty(specialty_id)
);

 
-- Indexes for common query patterns
CREATE INDEX idx_pathway_trust  ON Patient_Pathway(trust_id);
CREATE INDEX idx_pathway_specialty  ON Patient_Pathway(specialty_id);
CREATE INDEX idx_pathway_breach ON Patient_Pathway(is_breach);
CREATE INDEX idx_snapshot_date  ON Waiting_List_Snapshot(snapshot_date);
CREATE INDEX idx_trust_region   ON Trust(region_id);
