create database sealink;
use sealink;

create table shipping_agent (
    license_no      varchar(20),
    name            varchar(100) not null,
    contact_email   varchar(100) not null,
    primary key (license_no),
    unique (contact_email) 
);

create table customs_officer (
    badge_id        varchar(20),
    name            varchar(100) not null,
    rank_title            varchar(50),
    primary key (badge_id)
);

create table berth (
    berth_id        varchar(10),
    length_cap      numeric(10, 2) not null,
    status          varchar(20) not null,
    primary key (berth_id),
    check (status in ('Available', 'Occupied', 'Maintenance', 'Weather_Closed'))
);

create table equipment (
    equip_id        varchar(20),
    type            varchar(50) not null,
    engine_hours    numeric(10, 2) default 0.0,
    status          varchar(20) not null,
    primary key (equip_id),
    check (status in ('Active', 'Needs_Service'))
);

create table invoice (
    invoice_id      varchar(20),
    amount          numeric(15, 2) not null,
    payment_status  varchar(20) default 'Pending',
    inv_date        date not null,
    agent_license_no varchar(20),
    primary key (invoice_id),
    foreign key (agent_license_no) references shipping_agent (license_no),
    check (payment_status in ('Pending', 'Paid', 'Overdue'))
);

create table vessel (
    imo_number      varchar(20),
    name            varchar(100) not null,
    type            varchar(50) not null,
    draft           numeric(5, 2) not null,
    agent_license_no varchar(20) not null,
    primary key (imo_number),
    foreign key (agent_license_no) references shipping_agent (license_no)
);

create table voyage (
    imo_number      varchar(20),
    voyage_no       numeric(5,0),
    arrival_date    date not null,
    departure_date  date,
    berth_id        varchar(10),
    primary key (imo_number, voyage_no),
    foreign key (imo_number) references vessel (imo_number) on delete cascade,
    foreign key (berth_id) references berth (berth_id)
);

create table equipment_usage (
    imo_number      varchar(20),
    voyage_no       numeric(5,0),
    equip_id        varchar(20),
    hours_used      numeric(5, 2) not null,
    primary key (imo_number, voyage_no, equip_id),
    foreign key (imo_number, voyage_no) references voyage (imo_number, voyage_no) on delete cascade,
    foreign key (equip_id) references equipment (equip_id)
);

create table container (
    container_id    varchar(20),
    type            varchar(50) not null,
    status          varchar(20) default 'Held',
    block           varchar(5),
    row_num         numeric(3,0),
    tier_num        numeric(3,0),
    imo_number      varchar(20) not null,
    voyage_no       numeric(5,0) not null,
    cleared_by_id   varchar(20),
    
    primary key (container_id),
    foreign key (imo_number, voyage_no) references voyage (imo_number, voyage_no),
    foreign key (cleared_by_id) references customs_officer (badge_id),
    check (status in ('Held', 'Cleared')),
    unique (block, row_num, tier_num)
);

create index idx_berth_status on berth (status);
create index idx_cont_status on container (status);
create index idx_equip_status on equipment (status);
create index idx_voyage_arrival on voyage (arrival_date);
create index idx_vessel_agent on vessel (agent_license_no);

insert into shipping_agent values ('SA_001', 'Maersk Line', 'contact@maersk.com');
insert into shipping_agent values ('SA_002', 'MSC Global', 'ops@msc.com');

insert into customs_officer values ('CO_991', 'Amit Verma', 'Inspector');

insert into berth values ('B1', 300.00, 'Occupied');
insert into berth values ('B2', 400.00, 'Available');

insert into equipment values ('QC_01', 'Quay Crane', 450.5, 'Active');
insert into equipment values ('TUG_01', 'Tug Boat', 120.0, 'Active');

insert into invoice values ('INV_101', 50000.00, 'Paid', date '2026-01-10', 'SA_001');

insert into vessel values ('IMO_9876543', 'Maersk Seletar', 'Container', 14.5, 'SA_001');

insert into voyage values ('IMO_9876543', 101, date '2026-01-15', date '2026-01-16', 'B1');

insert into equipment_usage values ('IMO_9876543', 101, 'QC_01', 12.5);

insert into container values ('CNTR_001', 'Standard', 'Cleared', 'A', 1, 1, 'IMO_9876543', 101, 'CO_991');
insert into container values ('CNTR_002', 'Reefer', 'Held', 'A', 1, 2, 'IMO_9876543', 101, null);

SELECT * FROM vessel;

SELECT * from customs_officer where rank_title = 'Inspector';

INSERT INTO shipping_agent VALUES 
('SA_003', 'Hapag-Lloyd', 'info@hlag.com'),
('SA_004', 'CMA CGM India', 'mumbai.ops@cma-cgm.com'),
('SA_005', 'Evergreen Marine', 'biz@evergreen.com'),
('SA_006', 'ONE Network', 'contact@one-line.com'),
('SA_007', 'Yang Ming', 'service@yangming.com'),
('SA_008', 'HMM Co Ltd', 'ops@hmm21.com'),
('SA_009', 'ZIM Line', 'service@zim.com'),
('SA_010', 'Wan Hai Lines', 'mumbai@wanhai.com'),
('SA_011', 'PIL Pte Ltd', 'enquiry@pilship.com'),
('SA_012', 'Seaboard Marine', 'info@seaboard.com');

INSERT INTO customs_officer VALUES 
('CO_992', 'Sarah Khan', 'Senior Officer'),
('CO_993', 'Rajesh Gupta', 'Inspector'),
('CO_994', 'Priya Singh', 'Inspector'),
('CO_995', 'Vikram Malhotra', 'Chief Inspector'),
('CO_996', 'Anjali Desai', 'Officer'),
('CO_997', 'Rohan Mehra', 'Inspector'),
('CO_998', 'Sneha Patel', 'Senior Officer'),
('CO_999', 'Arjun Rampal', 'Inspector'),
('CO_1000', 'Meera Iyer', 'Officer'),
('CO_1001', 'Kabir Bedi', 'Chief Inspector');

INSERT INTO berth VALUES 
('B3', 350.00, 'Available'),
('B4', 400.00, 'Occupied'),
('B5', 250.00, 'Maintenance'),
('B6', 500.00, 'Available'),
('B7', 300.00, 'Weather_Closed'),
('B8', 450.00, 'Occupied'),
('B9', 200.00, 'Available'),
('B10', 350.00, 'Occupied'),
('B11', 280.00, 'Maintenance'),
('B12', 600.00, 'Available');

INSERT INTO equipment VALUES 
('QC_02', 'Quay Crane', 600.5, 'Needs_Service'),
('QC_03', 'Quay Crane', 100.0, 'Active'),
('RTG_01', 'Rubber Tyre Gantry', 250.0, 'Active'),
('RTG_02', 'Rubber Tyre Gantry', 310.5, 'Active'),
('RTG_03', 'Rubber Tyre Gantry', 550.0, 'Needs_Service'),
('TUG_02', 'Tug Boat', 80.0, 'Active'),
('TUG_03', 'Tug Boat', 150.0, 'Needs_Service'),
('FORK_01', 'Heavy Forklift', 45.0, 'Active'),
('FORK_02', 'Heavy Forklift', 200.0, 'Active'),
('TRK_01', 'Terminal Truck', 1200.0, 'Needs_Service');

INSERT INTO invoice VALUES 
('INV_102', 75000.50, 'Pending', date '2026-01-18', 'SA_002'),
('INV_103', 12000.00, 'Paid', date '2026-01-20', 'SA_003'),
('INV_104', 4500.00, 'Overdue', date '2025-12-15', 'SA_004'),
('INV_105', 98000.00, 'Paid', date '2026-01-22', 'SA_001'),
('INV_106', 3200.00, 'Pending', date '2026-02-01', 'SA_005'),
('INV_107', 15000.00, 'Paid', date '2026-01-25', 'SA_006'),
('INV_108', 60000.00, 'Pending', date '2026-02-05', 'SA_002'),
('INV_109', 2500.00, 'Paid', date '2026-01-30', 'SA_003'),
('INV_110', 11000.00, 'Overdue', date '2026-01-01', 'SA_007'),
('INV_111', 5000.00, 'Pending', date '2026-02-10', 'SA_008');

INSERT INTO vessel VALUES 
('IMO_1234567', 'MSC Oscar', 'Container', 16.0, 'SA_002'),
('IMO_5556667', 'Hapag Berlin', 'Cargo', 12.0, 'SA_003'),
('IMO_9998887', 'CMA CGM Marco Polo', 'Container', 15.5, 'SA_004'),
('IMO_1112223', 'Ever Given', 'Container', 15.0, 'SA_005'),
('IMO_3334445', 'ONE Apus', 'Container', 14.8, 'SA_006'),
('IMO_6667778', 'YM Wellbeing', 'Bulk', 11.5, 'SA_007'),
('IMO_8889990', 'HMM Algeciras', 'Container', 16.5, 'SA_008'),
('IMO_2223334', 'ZIM Kingston', 'Container', 13.0, 'SA_009'),
('IMO_4445556', 'Wan Hai 312', 'Feeder', 9.5, 'SA_010'),
('IMO_7778889', 'Kota Pekarang', 'Cargo', 10.0, 'SA_011');

INSERT INTO voyage VALUES 
('IMO_1234567', 201, date '2026-02-01', date '2026-02-03', 'B4'),
('IMO_5556667', 305, date '2026-01-20', date '2026-01-21', 'B2'),
('IMO_9998887', 102, date '2026-02-10', null, 'B6'), -- Arriving soon
('IMO_1112223', 404, date '2026-01-25', date '2026-01-27', 'B8'),
('IMO_3334445', 501, date '2026-02-05', date '2026-02-06', 'B10'),
('IMO_6667778', 602, date '2026-01-18', date '2026-01-19', 'B3'),
('IMO_8889990', 701, date '2026-02-12', null, 'B12'),
('IMO_2223334', 803, date '2026-01-28', date '2026-01-29', 'B5'),
('IMO_4445556', 901, date '2026-02-08', date '2026-02-09', 'B9'),
('IMO_7778889', 111, date '2026-01-15', date '2026-01-16', 'B1');

INSERT INTO equipment_usage VALUES 
('IMO_1234567', 201, 'QC_02', 8.0),
('IMO_1234567', 201, 'TUG_02', 3.5),
('IMO_5556667', 305, 'RTG_01', 5.0),
('IMO_1112223', 404, 'QC_03', 10.5),
('IMO_1112223', 404, 'FORK_01', 2.0),
('IMO_3334445', 501, 'TRK_01', 15.0),
('IMO_6667778', 602, 'TUG_01', 4.0),
('IMO_9876543', 101, 'RTG_02', 6.5),
('IMO_4445556', 901, 'QC_02', 7.0),
('IMO_2223334', 803, 'FORK_02', 3.0);

INSERT INTO container VALUES 
('CNTR_003', 'Standard', 'Cleared', 'A', 2, 1, 'IMO_1234567', 201, 'CO_992'),
('CNTR_004', 'HazMat', 'Held', 'B', 1, 1, 'IMO_1234567', 201, null),
('CNTR_005', 'Reefer', 'Cleared', 'B', 1, 2, 'IMO_5556667', 305, 'CO_993'),
('CNTR_006', 'Standard', 'Cleared', 'C', 3, 1, 'IMO_1112223', 404, 'CO_991'),
('CNTR_007', 'FlatRack', 'Held', 'C', 3, 2, 'IMO_1112223', 404, null),
('CNTR_008', 'Tank', 'Cleared', 'D', 1, 1, 'IMO_3334445', 501, 'CO_995'),
('CNTR_009', 'Standard', 'Held', 'D', 1, 2, 'IMO_6667778', 602, null),
('CNTR_010', 'Reefer', 'Cleared', 'E', 2, 1, 'IMO_9876543', 101, 'CO_997'),
('CNTR_011', 'OpenTop', 'Held', 'E', 2, 2, 'IMO_2223334', 803, null),
('CNTR_012', 'Standard', 'Cleared', 'F', 1, 1, 'IMO_4445556', 901, 'CO_1001');

SELECT * FROM vessel;

SELECT * FROM customs_officer WHERE rank_title = 'Inspector';

-- TASK-4

-- to track where the damgerous goods are stores in the port
SELECT container_id, block, row_num, tier_num 
FROM container 
WHERE type = 'HazMat' and status = 'Held';

-- which equips need service 
SELECT equip_id, type, engine_hours 
FROM equipment 
WHERE status = 'Needs_Service';

-- to check agents whose email ends with @msc.com 
SELECT name, contact_email 
FROM shipping_agent 
WHERE contact_email LIKE '%@msc.com';

-- which officer cleared which container
SELECT co.name AS officer_name, c.container_id, c.type
FROM customs_officer co
JOIN container c ON co.badge_id = c.cleared_by_id
WHERE c.status = 'Cleared';

-- all invoice related info for an agent 
SELECT i.invoice_id, i.amount, i.payment_status, i.inv_date 
FROM invoice i
JOIN shipping_agent sa ON i.agent_license_no = sa.license_no 
WHERE sa.name = 'Maersk Line';

-- vessels w arrival date and berth id that are currently at the port 
SELECT v.name AS vessel_name, voy.arrival_date, b.berth_id 
FROM vessel v 
JOIN voyage voy ON v.imo_number = voy.imo_number 
JOIN berth b ON voy.berth_id = b.berth_id 
WHERE voy.departure_date IS NULL;

-- num of containers by each vessel on each trip 
SELECT imo_number, voyage_no, COUNT(container_id) AS total_containers 
FROM container 
GROUP BY imo_number, voyage_no;

-- agents having pending/overdue amount over 50k 
SELECT agent_license_no, SUM(amount) AS total_due 
FROM invoice 
WHERE payment_status IN ('Pending', 'Overdue') 
GROUP BY agent_license_no 
HAVING SUM(amount) > 50000;

-- avg turnaround time of the entire port 
SELECT AVG(DATEDIFF(departure_date, arrival_date)) AS avg_turnaround_days 
FROM voyage 
WHERE departure_date IS NOT NULL;

-- invoices w amt greater than avg 
SELECT invoice_id, amount, payment_status 
FROM invoice 
WHERE amount > (SELECT AVG(amount) FROM invoice);

-- vessels at b1 and b2 
SELECT name 
FROM vessel 
WHERE imo_number IN (
    SELECT imo_number 
    FROM voyage 
    WHERE berth_id IN ('B1', 'B2')
);

-- agents who have never brought bulk goods 
SELECT name 
FROM shipping_agent s 
WHERE NOT EXISTS (
    SELECT * FROM vessel v 
    WHERE v.agent_license_no = s.license_no AND v.type = 'Bulk'
);

-- assets of port that need service/help 
SELECT berth_id AS asset_id, 'Berth' AS asset_type, status 
FROM berth 
WHERE status = 'Maintenance'
UNION 
SELECT equip_id AS asset_id, type AS asset_type, status 
FROM equipment 
WHERE status = 'Needs_Service';

-- info of berths- if occupied, then vessel info, else null meaning empty 
SELECT b.berth_id, b.status, v.imo_number, v.voyage_no 
FROM berth b 
LEFT OUTER JOIN voyage v ON b.berth_id = v.berth_id AND v.departure_date IS NULL;

-- total equips used by a vessel for each voyage 
SELECT v.name AS vessel_name, SUM(eu.hours_used) AS total_equipment_hours 
FROM vessel v 
JOIN voyage voy ON v.imo_number = voy.imo_number 
JOIN equipment_usage eu ON voy.imo_number = eu.imo_number AND voy.voyage_no = eu.voyage_no 
WHERE v.name = 'MSC Oscar' 
GROUP BY v.name;

-- penalty for overdue 
SET SQL_SAFE_UPDATES = 0;
UPDATE invoice 
SET amount = amount * 1.10 
WHERE payment_status = 'Overdue';
SET SQL_SAFE_UPDATES = 1;

-- view for berth available 
CREATE VIEW available_berths AS
SELECT berth_id, length_cap
FROM berth
WHERE status = 'Available';

SELECT * 
FROM available_berths;

-- num of containers cleared by specific officer 
SELECT co.name, COUNT(c.container_id) AS total_cleared
FROM customs_officer co
JOIN container c ON co.badge_id = c.cleared_by_id
WHERE c.status = 'Cleared'
GROUP BY co.name;

-- agent name, total unique vessels managed and total amount  of invoices managed 
-- with constraints that vessels managed has equip usage more than avg and the vessel
-- has held some container rn in the port  
SELECT sa.name AS Agent_Name, COUNT(DISTINCT v.imo_number) AS Total_Vessels, SUM(i.amount) AS Total_Billed
FROM shipping_agent sa
JOIN invoice i ON sa.license_no = i.agent_license_no
JOIN vessel v ON sa.license_no = v.agent_license_no
WHERE sa.license_no IN (
    SELECT v2.agent_license_no
    FROM vessel v2
    JOIN voyage voy ON v2.imo_number = voy.imo_number
    JOIN container c ON voy.imo_number = c.imo_number AND voy.voyage_no = c.voyage_no
    JOIN equipment_usage eu ON voy.imo_number = eu.imo_number AND voy.voyage_no = eu.voyage_no
    WHERE c.status = 'Held'
    GROUP BY v2.agent_license_no
    HAVING SUM(eu.hours_used) > (
        SELECT AVG(hours_used) 
        FROM equipment_usage
    )
)
GROUP BY sa.name;
-- Trigger 1: After logging hours, add to engine_hours.
--            If total crosses 500h, flag equipment as Needs_Service.
DROP TRIGGER IF EXISTS after_equip_usage_insert;
DELIMITER //
CREATE TRIGGER after_equip_usage_insert
AFTER INSERT ON equipment_usage
FOR EACH ROW
BEGIN
    UPDATE equipment
    SET engine_hours = engine_hours + NEW.hours_used
    WHERE equip_id = NEW.equip_id;

    UPDATE equipment
    SET status = 'Needs_Service'
    WHERE equip_id = NEW.equip_id AND engine_hours >= 500;
END //
DELIMITER ;


-- Trigger 2: Before logging hours, block if equipment already Needs_Service.
DROP TRIGGER IF EXISTS before_equip_usage_insert;
DELIMITER //
CREATE TRIGGER before_equip_usage_insert
BEFORE INSERT ON equipment_usage
FOR EACH ROW
BEGIN
    DECLARE eq_status VARCHAR(20);
    SELECT status INTO eq_status FROM equipment WHERE equip_id = NEW.equip_id;
    IF eq_status = 'Needs_Service' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Blocked: This equipment needs servicing and cannot be used.';
    END IF;
END //
DELIMITER ;

-- Trigger 3: Before inserting a voyage, block if berth is
--            under Maintenance or Weather_Closed.
DROP TRIGGER IF EXISTS before_voyage_insert;
DELIMITER //
CREATE TRIGGER before_voyage_insert
BEFORE INSERT ON voyage
FOR EACH ROW
BEGIN
    DECLARE b_status VARCHAR(20);
    SELECT status INTO b_status FROM berth WHERE berth_id = NEW.berth_id;
    IF b_status IN ('Occupied','Maintenance', 'Weather_Closed') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Blocked: Berth is currently unavailable (Occupied or Maintenance or Weather_Closed).';
    END IF;
END //
DELIMITER ;


-- Trigger 4: After a voyage is inserted successfully,
--            auto-set the berth status to Occupied.
DROP TRIGGER IF EXISTS after_voyage_insert;
DELIMITER //
CREATE TRIGGER after_voyage_insert
AFTER INSERT ON voyage
FOR EACH ROW
BEGIN
    UPDATE berth
    SET status = 'Occupied'
    WHERE berth_id = NEW.berth_id;
END //
DELIMITER ;


-- Verify
SHOW TRIGGERS FROM sealink;

DROP TRIGGER IF EXISTS before_voyage_insert;
DELIMITER //
CREATE TRIGGER before_voyage_insert
BEFORE INSERT ON voyage
FOR EACH ROW
BEGIN
    DECLARE b_status VARCHAR(20);
    SELECT status INTO b_status FROM berth WHERE berth_id = NEW.berth_id;
    IF b_status IN ('Occupied','Maintenance', 'Weather_Closed') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Blocked: Berth is currently unavailable (Occupied or Maintenance or Weather_Closed).';
    END IF;
END //
DELIMITER ;

INSERT INTO shipping_agent VALUES
('SA_013', 'Pacific Carriers', 'ops@pacificcarriers.com'),
('SA_014', 'Atlantic Freight',  'contact@atlanticfreight.com');

INSERT INTO customs_officer VALUES
('CO_1002', 'Neha Sharma',  'Inspector'),
('CO_1003', 'Suresh Iyer',  'Chief Inspector');

INSERT INTO berth VALUES
('B13', 420.00, 'Available'),  
('B14', 380.00, 'Available');   

INSERT INTO equipment VALUES
('QC_04',  'Quay Crane',         460.00, 'Active'),    
('RTG_04', 'Rubber Tyre Gantry', 350.00, 'Active'),        
('TUG_04', 'Tug Boat',           510.00, 'Needs_Service'); 

INSERT INTO vessel VALUES
('IMO_1111111', 'Pacific Star',    'Container', 13.5, 'SA_013'),
('IMO_2222222', 'Atlantic Runner', 'Cargo',     11.0, 'SA_014');

INSERT INTO voyage VALUES
('IMO_1111111', 501, '2026-03-10', NULL, 'B13'),  
('IMO_2222222', 601, '2026-03-12', NULL, 'B14');  

INSERT INTO equipment_usage VALUES
('IMO_1111111', 501, 'QC_04',  5.00),   
('IMO_1111111', 501, 'RTG_04', 8.00),   
('IMO_2222222', 601, 'TUG_01', 3.00);   

INSERT INTO container VALUES
('CNTR_013', 'Standard', 'Cleared', 'G', 1, 1, 'IMO_1111111', 501, 'CO_1002'),
('CNTR_014', 'Reefer',   'Cleared', 'G', 1, 2, 'IMO_1111111', 501, 'CO_1003'),
('CNTR_015', 'HazMat',   'Cleared', 'H', 1, 1, 'IMO_2222222', 601, 'CO_1002'),
('CNTR_016', 'Standard', 'Cleared', 'H', 1, 2, 'IMO_2222222', 601, 'CO_1003');

INSERT INTO invoice VALUES
('INV_112', 30000.00, 'Pending', '2026-03-10', 'SA_013'),
('INV_113', 45000.00, 'Pending', '2026-03-12', 'SA_014');

SELECT equip_id, type, engine_hours, status FROM equipment ORDER BY engine_hours DESC;
SELECT berth_id, status FROM berth ORDER BY berth_id;
SELECT imo_number, voyage_no, arrival_date, departure_date, berth_id FROM voyage ORDER BY arrival_date DESC;

UPDATE berth SET status = 'Available' WHERE berth_id IN ('B13', 'B14');
DELETE FROM voyage WHERE imo_number IN ('IMO_1111111', 'IMO_2222222');
DELETE FROM equipment_usage WHERE imo_number IN ('IMO_1111111', 'IMO_2222222');

DROP TRIGGER IF EXISTS after_equip_usage_update;
DELIMITER //
CREATE TRIGGER after_equip_usage_update
AFTER UPDATE ON equipment_usage
FOR EACH ROW
BEGIN
    UPDATE equipment
    SET engine_hours = engine_hours + (NEW.hours_used - OLD.hours_used)
    WHERE equip_id = NEW.equip_id;

    UPDATE equipment
    SET status = 'Needs_Service'
    WHERE equip_id = NEW.equip_id AND engine_hours >= 500;
END //
DELIMITER ;

INSERT INTO berth VALUES
('B15', 320.00, 'Available'),
('B16', 410.00, 'Available'),
('B17', 550.00, 'Available'),
('B18', 290.00, 'Available'),
('B19', 480.00, 'Available');

UPDATE berth SET status = 'Available' WHERE berth_id IN ('B15', 'B16','B17','B18','B19'); 

SET autocommit = 0;

SELECT berth_id, status FROM berth WHERE berth_id = 'B15';

START TRANSACTION;

    INSERT INTO voyage (imo_number, voyage_no, arrival_date, berth_id)
    VALUES ('IMO_7778889', 999, '2026-04-10', 'B15');
    UPDATE berth SET status = 'Occupied' WHERE berth_id = 'B15';
    
COMMIT;

SELECT berth_id, status FROM berth WHERE berth_id = 'B15';
SELECT imo_number, voyage_no, berth_id FROM voyage WHERE voyage_no = 999;

UPDATE berth SET status = 'Available' WHERE berth_id = 'B15';
DELETE FROM voyage WHERE voyage_no = 999 AND imo_number = 'IMO_7778889';

SELECT invoice_id, amount, payment_status FROM invoice WHERE invoice_id = 'INV_104';

START TRANSACTION;

    UPDATE invoice
    SET amount = amount * 1.10
    WHERE invoice_id = 'INV_104' AND payment_status = 'Overdue';

    UPDATE invoice
    SET payment_status = 'Paid'
    WHERE invoice_id = 'INV_104';

COMMIT;

SELECT invoice_id, amount, payment_status FROM invoice WHERE invoice_id = 'INV_104';

UPDATE invoice SET amount = 4500.00, payment_status = 'Overdue' WHERE invoice_id = 'INV_104';

SELECT container_id, status, cleared_by_id FROM container WHERE container_id = 'CNTR_002';

START TRANSACTION;

    UPDATE container
    SET status = 'Cleared',
        cleared_by_id = 'CO_991'
    WHERE container_id = 'CNTR_002'
      AND status = 'Held';

COMMIT;

SELECT container_id, status, cleared_by_id FROM container WHERE container_id = 'CNTR_002';

UPDATE container SET status = 'Held', cleared_by_id = NULL WHERE container_id = 'CNTR_002';

UPDATE berth SET status = 'Available' WHERE berth_id = 'B16';

START TRANSACTION;

    INSERT INTO voyage (imo_number, voyage_no, arrival_date, berth_id)
    VALUES ('IMO_1234567', 888, '2026-04-11', 'B16');

    UPDATE berth SET status = 'Occupied' WHERE berth_id = 'B16';

COMMIT;

START TRANSACTION;

    SELECT @b_status := status FROM berth WHERE berth_id = 'B16' FOR UPDATE;

    SET @b_status = (SELECT status FROM berth WHERE berth_id = 'B16');

ROLLBACK;

SELECT imo_number, voyage_no, berth_id FROM voyage WHERE berth_id = 'B16';
SELECT berth_id, status FROM berth WHERE berth_id = 'B16';

DELETE FROM voyage WHERE voyage_no = 888;
UPDATE berth SET status = 'Available' WHERE berth_id = 'B16';

SELECT invoice_id, amount FROM invoice WHERE invoice_id = 'INV_102';

START TRANSACTION;
    UPDATE invoice SET amount = amount + 5000.00 WHERE invoice_id = 'INV_102';
COMMIT;

START TRANSACTION;
    UPDATE invoice SET amount = 75000.50 + 2000.00 WHERE invoice_id = 'INV_102';
COMMIT;

SELECT invoice_id, amount FROM invoice WHERE invoice_id = 'INV_102';

UPDATE invoice SET amount = 75000.50 WHERE invoice_id = 'INV_102'; 

START TRANSACTION;
    
    SELECT amount FROM invoice WHERE invoice_id = 'INV_102' FOR UPDATE;
    
    UPDATE invoice SET amount = amount + 5000.00 WHERE invoice_id = 'INV_102';
COMMIT;

UPDATE invoice SET amount = 75000.50, payment_status = 'Pending' WHERE invoice_id = 'INV_102';

SHOW TRIGGERS FROM sealink;

INSERT INTO voyage (imo_number, voyage_no, arrival_date, berth_id)
VALUES ('IMO_7778889', 9999, '2026-04-10', 'B2');

SELECT berth_id, status FROM berth WHERE berth_id = 'B2';

SET SQL_SAFE_UPDATES = 0;
DELETE FROM voyage WHERE voyage_no = 9999;
UPDATE berth SET status = 'Available' WHERE berth_id = 'B2';
SET SQL_SAFE_UPDATES = 1;

INSERT INTO berth (berth_id, length_cap, status) VALUES 
('B21', 350.00, 'Available'),
('B22', 400.00, 'Available'),
('B23', 450.00, 'Available'),
('B24', 500.00, 'Available'),
('B25', 300.00, 'Available'),
('B26', 350.00, 'Available'),
('B27', 400.00, 'Available'),
('B28', 550.00, 'Available'),
('B29', 600.00, 'Available'),
('B30', 450.00, 'Available');

INSERT INTO invoice (invoice_id, amount, payment_status, inv_date, agent_license_no) VALUES 
('INV_901', 10000.00, 'Overdue', '2026-02-01', 'SA_001'),
('INV_902', 20000.00, 'Overdue', '2026-02-10', 'SA_002'),
('INV_903', 50000.00, 'Overdue', '2026-03-05', 'SA_003');