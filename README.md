# IRAKOZE-TESSY-MICK_27632_Final-project

 ## 🏥 SMART HOSPITAL OPERATION TRACKER(SHOT) ##


 ****📌 Project Overview****
 
is a PL/SQL-based healthcare 
management system designed to streamline hospital operations by integrating three core 
functions: appointments, medication tracking, and billing. SHOT aims to reduce scheduling 
conflicts, medication shortages, and billing errors by introducing an intelligent, 
database-driven solution that ensures accuracy, transparency, and efficiency in hospital 
management. 

***🚩 Problem Definition***

1. Appointment clashes and long waiting queues
2 .Medication stockouts due to poor tracking
3. Manual billing errors & revenue discrepancies
4. Lack of operational insights for administrators

***🎯 Project Objectives***

• Automate hospital operations using PL/SQL procedures and triggers. 
• Track medication usage and stock levels in real time.
• Generate accurate and dynamic billing automatically.
• Produce performance reports using PL/SQL cursors and views. 
• Ensure data integrity through constraints, exceptions, and validations.

***🎯 Project Innovations***

1.Smart Scheduling: Automatically detects available time slots for doctors and prevents double bookings.
2.Live Medication Tracking: Triggers deduct prescribed medication from stock and notify the pharmacy when levels are low. 
3. Auto-Billing System:Stored procedures compute total bills and validate transactions. 
4. Operational Insights Dashboard: Cursors generate reports on patient visits, revenue,and doctor performance. 
5. Data Integrity & Security: Audit logs, triggers, and role-based access ensure secure data operations.

## PhaseII: Business Process Modeling (Related to Management Information Systems - MIS) ##

This BPMN diagram shows a healthcare workflow where a patient requests an appointment. If the doctor is unavailable, it's scheduled for later. If available, the patient is seen and a medical record is updated. The MIS system handles scheduling, consultations, and checks medication stock. If stock is available, the billing department generates a bill and processes payment. If not, the process ends. It involves patients, reception/nurses, the MIS system, and billing.
![bpmn](https://github.com/user-attachments/assets/db303e32-cc7e-4ce7-8e50-56f2a12223a7)

## PhaseIII: Logical Model Design ##

This diagram shows a hospital database structure with tables for Patients, Doctors, Appointments, consultation, Billing, Insurance, Medications, Prescriptions, Departments, and payment. Each patient can have insurance, appointments with doctors, consultation, bills, and prescriptions. Prescriptions link doctors, patients, and medications. Staff members belong to departments. The system is designed to track all hospital operations efficiently through these connected entities. it highly indication their relationship between entities and their dependency.
![er](https://github.com/user-attachments/assets/e1474083-0932-42dd-90f3-e6ac1c6e5ba9)

## PhaseIV: Database (Pluggable Database) Creation and Naming ##
***🗃️ Database Design and  💻 PL/SQL Implementation*** 

***DCL(Data Control Language)***

***Pluggable database***

![pl srs2](https://github.com/user-attachments/assets/096b3429-1e4d-4c1d-8dbf-e08a3589f008)
![JPG](https://github.com/user-attachments/assets/770e3b28-3b8c-4c45-a6e6-fbdbabd549e8)

```
CREATE PLUGGABLE DATABASE thur_27632_tessy_SHOT_DB
ADMIN USER shot_admin IDENTIFIED BY 12345
ROLES = (dba)
FILE_NAME_CONVERT = ('C:\APP\TESSY\PRODUCT\21C\ORADATA\XE\PDBSEED', 
                     'C:\APP\TESSY\PRODUCT\21C\ORADATA\XE\PDBSEED/thur_27632_tessy_SHOT_DB/')
                     
                     
CONNECT shot_admin/12345@localhost:1521/thur_27632_tessy_SHOT_DB                     
```

***Tablespace creation***
![pl srs3](https://github.com/user-attachments/assets/d1165949-fa03-4e61-b2b0-e649a18c9aca)

## PhaseV: Table Implementation and Data Insertion ##

***DML(Data Manipulation Language)***

***CREATE TABLES***
```
-- Create PATIENT table
CREATE TABLE PATIENT (
    patient_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F', 'O')),
    phone_number VARCHAR2(15),
    email VARCHAR2(100),
    address VARCHAR2(200),
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL
);

-- Create DEPARTMENT table (must be created before DOCTOR)
CREATE TABLE DEPARTMENT (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(100) NOT NULL,
    location VARCHAR2(200),
    phone_number VARCHAR2(15),
    head_doctor_id NUMBER
);

-- Create DOCTOR table
CREATE TABLE DOCTOR (
    doctor_id NUMBER PRIMARY KEY,
    department_id NUMBER,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    specialization VARCHAR2(100),
    license_number VARCHAR2(50) UNIQUE NOT NULL,
    phone_number VARCHAR2(15),
    email VARCHAR2(100),
    hire_date DATE,
    status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'ON_LEAVE')),
    CONSTRAINT fk_doctor_department FOREIGN KEY (department_id) 
        REFERENCES DEPARTMENT(department_id)
);

-- Now update DEPARTMENT foreign key constraint
ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_department_head_doctor FOREIGN KEY (head_doctor_id) 
    REFERENCES DOCTOR(doctor_id);

-- Create APPOINTMENT table
CREATE TABLE APPOINTMENT (
    appointment_id NUMBER PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    doctor_id NUMBER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(10) NOT NULL,
    status VARCHAR2(20) DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW')),
    notes VARCHAR2(500),
    created_by VARCHAR2(50),
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_appointment_patient FOREIGN KEY (patient_id) 
        REFERENCES PATIENT(patient_id),
    CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) 
        REFERENCES DOCTOR(doctor_id)
);

-- Create CONSULTATION table
CREATE TABLE CONSULTATION (
    consultation_id NUMBER PRIMARY KEY,
    appointment_id NUMBER UNIQUE NOT NULL,
    doctor_id NUMBER NOT NULL,
    diagnosis VARCHAR2(500),
    symptoms VARCHAR2(500),
    consultation_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    treatment_plan VARCHAR2(1000),
    follow_up_required CHAR(1) DEFAULT 'N' CHECK (follow_up_required IN ('Y', 'N')),
    consultation_cost NUMBER(10,2) DEFAULT 0,
    CONSTRAINT fk_consultation_appointment FOREIGN KEY (appointment_id) 
        REFERENCES APPOINTMENT(appointment_id),
    CONSTRAINT fk_consultation_doctor FOREIGN KEY (doctor_id) 
        REFERENCES DOCTOR(doctor_id)
);

-- Create BILL table
CREATE TABLE BILL (
    bill_id NUMBER PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    consultation_id NUMBER UNIQUE NOT NULL,
    bill_date DATE DEFAULT SYSDATE NOT NULL,
    total_amount NUMBER(10,2) NOT NULL CHECK (total_amount >= 0),
    paid_amount NUMBER(10,2) DEFAULT 0 CHECK (paid_amount >= 0),
    payment_status VARCHAR2(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PARTIAL', 'PAID', 'OVERDUE')),
    payment_date DATE,
    CONSTRAINT fk_bill_patient FOREIGN KEY (patient_id) 
        REFERENCES PATIENT(patient_id),
    CONSTRAINT fk_bill_consultation FOREIGN KEY (consultation_id) 
        REFERENCES CONSULTATION(consultation_id),
    CONSTRAINT check_paid_amount CHECK (paid_amount <= total_amount)
);

-- Create PRESCRIPTION table
CREATE TABLE PRESCRIPTION (
    prescription_id NUMBER PRIMARY KEY,
    consultation_id NUMBER NOT NULL,
    prescription_date DATE DEFAULT SYSDATE NOT NULL,
    instructions VARCHAR2(500),
    valid_until DATE,
    status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'EXPIRED', 'CANCELLED')),
    issued_by NUMBER NOT NULL,
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    CONSTRAINT fk_prescription_consultation FOREIGN KEY (consultation_id) 
        REFERENCES CONSULTATION(consultation_id),
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (issued_by) 
        REFERENCES DOCTOR(doctor_id)
);

-- Create MEDICATION table
CREATE TABLE MEDICATION (
    medication_id NUMBER PRIMARY KEY,
    medication_name VARCHAR2(100) NOT NULL,
    generic_name VARCHAR2(100),
    manufacturer VARCHAR2(100),
    unit_price NUMBER(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity NUMBER NOT NULL CHECK (stock_quantity >= 0),
    reorder_level NUMBER DEFAULT 10 CHECK (reorder_level >= 0),
    expiry_date DATE,
    CONSTRAINT uq_medication_name UNIQUE (medication_name)
);

-- Create PRESCRIPTION_DETAIL table
CREATE TABLE PRESCRIPTION_DETAIL (
    detail_id NUMBER PRIMARY KEY,
    prescription_id NUMBER NOT NULL,
    medication_id NUMBER NOT NULL,
    dosage VARCHAR2(50) NOT NULL,
    frequency VARCHAR2(100) NOT NULL,
    duration_days NUMBER NOT NULL CHECK (duration_days > 0),
    quantity NUMBER NOT NULL CHECK (quantity > 0),
    special_instructions VARCHAR2(200),
    CONSTRAINT fk_detail_prescription FOREIGN KEY (prescription_id) 
        REFERENCES PRESCRIPTION(prescription_id) ON DELETE CASCADE,
    CONSTRAINT fk_detail_medication FOREIGN KEY (medication_id) 
        REFERENCES MEDICATION(medication_id),
    CONSTRAINT uq_prescription_medication UNIQUE (prescription_id, medication_id)
);

-- Create PAYMENT table
CREATE TABLE PAYMENT (
    payment_id NUMBER PRIMARY KEY,
    bill_id NUMBER NOT NULL,
    payment_date TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    amount NUMBER(10,2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR2(30) CHECK (payment_method IN ('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'INSURANCE', 'ONLINE')),
    transaction_ref VARCHAR2(100),
    processed_by VARCHAR2(50),
    CONSTRAINT fk_payment_bill FOREIGN KEY (bill_id) 
        REFERENCES BILL(bill_id) ON DELETE CASCADE
);
```
And in this screenshot it indicates that the tables were created in sql developer as they are shown and we used the above sql codes



