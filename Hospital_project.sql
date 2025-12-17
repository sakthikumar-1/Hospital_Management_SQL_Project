CREATE DATABASE hospital_db;
USE hospital_db;
CREATE TABLE doctor_details (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    experience_years INT CHECK (experience_years >= 0),
    shift_timing VARCHAR(20) DEFAULT 'Morning',
    email VARCHAR(100) UNIQUE,
    is_available BOOLEAN DEFAULT TRUE,
    hire_date DATE NOT NULL
);
CREATE TABLE patient_details (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    age INT CHECK (age BETWEEN 1 AND 120),
    gender VARCHAR(10) CHECK (gender IN ('Male','Female','Other')),
    city VARCHAR(50),
    contact_number VARCHAR(15) UNIQUE,
    registration_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);
CREATE TABLE appointment_details (
    appointment_id INT PRIMARY KEY,
    doctor_id INT,
    patient_id INT,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(20) DEFAULT 'Scheduled',
    FOREIGN KEY (doctor_id) REFERENCES doctor_details(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES patient_details(patient_id)
);
INSERT INTO doctor_details VALUES
(1,'Dr. Kumar','Cardiology','9876543210',10,'Morning','kumar@hospital.com',TRUE,'2015-06-12'),
(2,'Dr. Swathi','Dermatology','9876501234',5,'Evening','swathi@hospital.com',TRUE,'2018-01-10'),
(3,'Dr. Ravi','Orthopedics','9867543210',12,'Night','ravi@hospital.com',FALSE,'2012-03-22'),
(4,'Dr. Priya','Neurology','9845123456',8,'Morning','priya@hospital.com',TRUE,'2017-02-18'),
(5,'Dr. John','Physician','9823456710',6,'Evening','john@hospital.com',TRUE,'2020-04-04'),
(6,'Dr. Meena','ENT','9123456701',4,'Morning','meena@hospital.com',TRUE,'2021-03-15'),
(7,'Dr. Arjun','Cardiology','9898765432',14,'Night','arjun@hospital.com',FALSE,'2010-09-11'),
(8,'Dr. Stella','Gynecology','9001234567',9,'Morning','stella@hospital.com',TRUE,'2016-01-25'),
(9,'Dr. Akash','Pediatrics','9090123456',7,'Evening','akash@hospital.com',TRUE,'2019-07-07'),
(10,'Dr. Divya','Oncology','9887766554',11,'Night','divya@hospital.com',TRUE,'2013-10-10');

INSERT INTO patient_details VALUES
(1,'Sarath',21,'Male','Madurai','9876543000','2024-01-01',TRUE),
(2,'Yasvindhini',20,'Female','Madurai','9876543001','2024-01-10',TRUE),
(3,'Murugan',45,'Male','Chennai','9876543002','2024-02-05',TRUE),
(4,'Priya',35,'Female','Coimbatore','9876543003','2024-02-20',TRUE),
(5,'Anitha',29,'Female','Salem','9876543004','2024-03-01',TRUE),
(6,'Arun',40,'Male','Chennai','9876543005','2024-03-15',TRUE),
(7,'Vijay',31,'Male','Madurai','9876543006','2024-03-22',TRUE),
(8,'Divya',26,'Female','Trichy','9876543007','2024-04-10',TRUE),
(9,'Karthik',30,'Male','Erode','9876543008','2024-04-21',TRUE),
(10,'Meera',33,'Female','Madurai','9876543009','2024-05-01',TRUE);

INSERT INTO appointment_details VALUES
(1,1,1,'2025-01-01','10:00:00','Completed'),
(2,2,2,'2025-01-02','11:00:00','Scheduled'),
(3,3,3,'2025-01-03','12:00:00','Cancelled'),
(4,4,4,'2025-01-04','14:00:00','Completed'),
(5,5,5,'2025-01-05','15:00:00','Scheduled'),
(6,6,6,'2025-01-06','16:00:00','Completed'),
(7,7,7,'2025-01-07','17:00:00','Scheduled'),
(8,8,8,'2025-01-08','09:30:00','Completed'),
(9,9,9,'2025-01-09','10:45:00','Scheduled'),
(10,10,10,'2025-01-10','11:30:00','Completed');

SELECT DISTINCT specialization FROM doctor_details;

UPDATE patient_details SET city='Madurai' WHERE patient_id=3;

ALTER TABLE doctor_details ADD COLUMN consultation_fee INT DEFAULT 500;

RENAME TABLE appointment_details TO appointments;
SELECT * FROM doctor_details
WHERE specialization='Cardiology' AND experience_years > 10;

SELECT * FROM patient_details WHERE city IN ('Madurai','Chennai');

SELECT * FROM patient_details WHERE age BETWEEN 20 AND 40;

SELECT * FROM doctor_details WHERE doctor_name LIKE '%a%';

SELECT * FROM doctor_details WHERE NOT is_available;

SELECT * FROM patient_details ORDER BY age DESC LIMIT 5;

SELECT specialization, COUNT(*) AS total_doctors
FROM doctor_details
GROUP BY specialization
HAVING COUNT(*) > 1;
SELECT d.doctor_name, p.patient_name, a.status
FROM appointments a
INNER JOIN doctor_details d ON a.doctor_id=d.doctor_id
INNER JOIN patient_details p ON a.patient_id=p.patient_id;

SELECT d.doctor_name, a.status
FROM doctor_details d
LEFT JOIN appointments a ON d.doctor_id=a.doctor_id;

SELECT d.doctor_name, a.status
FROM doctor_details d
LEFT JOIN appointments a ON d.doctor_id=a.doctor_id
UNION
SELECT d.doctor_name, a.status
FROM doctor_details d
RIGHT JOIN appointments a ON d.doctor_id=a.doctor_id;

SELECT doctor_name FROM doctor_details
UNION
SELECT patient_name FROM patient_details
SELECT * FROM doctor_details
WHERE experience_years = (SELECT MAX(experience_years) FROM doctor_details);

SELECT * FROM patient_details
WHERE city IN (SELECT city FROM patient_details WHERE age < 30);

SELECT doctor_name
FROM doctor_details d
WHERE EXISTS (
    SELECT 1 FROM appointments a
    WHERE a.doctor_id = d.doctor_id AND a.status='Scheduled'
);

SELECT doctor_name, experience_years*12 AS months FROM doctor_details;

SELECT patient_name, DATEDIFF(CURDATE(), registration_date) AS days_since_registered
FROM patient_details;

CREATE VIEW doctor_appointments AS
SELECT d.doctor_name, a.appointment_date, a.status
FROM appointments a
JOIN doctor_details d ON a.doctor_id=d.doctor_id;

CREATE INDEX idx_city ON patient_details(city);

DELIMITER $$

CREATE PROCEDURE GetDoctorAppointments(IN docid INT)
BEGIN
    SELECT * FROM appointments WHERE doctor_id = docid;
END $$

DELIMITER ;