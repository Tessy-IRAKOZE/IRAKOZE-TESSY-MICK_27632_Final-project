DECLARE
    TYPE dept_array IS VARRAY(15) OF VARCHAR2(100);
    departments dept_array := dept_array(
        'Cardiology', 'Neurology', 'Pediatrics', 'Oncology', 'Orthopedics',
        'Dermatology', 'Psychiatry', 'Radiology', 'Surgery', 'Gynecology',
        'Emergency', 'ICU', 'Laboratory', 'Pharmacy', 'Administration'
    );
    
    TYPE loc_array IS VARRAY(5) OF VARCHAR2(200);
    locations loc_array := loc_array(
        'Main Building - Floor 1',
        'Main Building - Floor 2', 
        'East Wing - Floor 1',
        'West Wing - Floor 3',
        'Central Block - Floor 2'
    );
BEGIN
    FOR i IN 1..15 LOOP
        INSERT INTO DEPARTMENT (
            DEPARTMENT_ID,
            DEPARTMENT_NAME,
            LOCATION,
            PHONE_NUMBER
        ) VALUES (
            seq_department_id.NEXTVAL,
            departments(i),
            locations(MOD(i, 5) + 1),
            '(' || LPAD(MOD(i*7, 999), 3, '0') || ') ' || 
            LPAD(MOD(i*13, 999), 3, '0') || '-' || 
            LPAD(MOD(i*17, 9999), 4, '0')
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('? 15 departments inserted successfully');
END;
/

DECLARE
    TYPE first_name_array IS VARRAY(25) OF VARCHAR2(50);
    first_names first_name_array := first_name_array(
        'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
        'William', 'Elizabeth', 'David', 'Susan', 'Richard', 'Jessica', 'Joseph', 'Sarah',
        'Thomas', 'Karen', 'Charles', 'Nancy', 'Christopher', 'Lisa', 'Daniel', 'Margaret',
        'Matthew'
    );
    
    TYPE last_name_array IS VARRAY(25) OF VARCHAR2(50);
    last_names last_name_array := last_name_array(
        'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis',
        'Rodriguez', 'Martinez', 'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson',
        'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin', 'Lee', 'Perez', 'Thompson',
        'White', 'Harris'
    );
    
    TYPE spec_array IS VARRAY(15) OF VARCHAR2(100);
    specializations spec_array := spec_array(
        'Cardiologist', 'Neurologist', 'Pediatrician', 'Oncologist', 'Orthopedic Surgeon',
        'Dermatologist', 'Psychiatrist', 'Radiologist', 'General Surgeon', 'Gynecologist',
        'Emergency Physician', 'Intensivist', 'Pathologist', 'Pharmacist', 'Administrator'
    );
    
    TYPE status_array IS VARRAY(4) OF VARCHAR2(20);
    statuses status_array := status_array('ACTIVE', 'ON_LEAVE', 'RETIRED', 'INACTIVE');
BEGIN
    FOR i IN 1..60 LOOP
        INSERT INTO DOCTOR (
            DOCTOR_ID,
            DEPARTMENT_ID,
            FIRST_NAME,
            LAST_NAME,
            SPECIALIZATION,
            LICENSE_NUMBER,
            PHONE_NUMBER,
            EMAIL,
            HIRE_DATE,
            STATUS
        ) VALUES (
            seq_doctor_id.NEXTVAL,
            (SELECT DEPARTMENT_ID FROM (SELECT DEPARTMENT_ID FROM DEPARTMENT ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1),
            first_names(MOD(i, 25) + 1),
            last_names(MOD(i, 25) + 1),
            specializations(MOD(i, 15) + 1),
            'LIC' || LPAD(i, 6, '0') || 'MD',
            '(' || LPAD(MOD(i*11, 999), 3, '0') || ') ' || 
            LPAD(MOD(i*13, 999), 3, '0') || '-' || 
            LPAD(MOD(i*17, 9999), 4, '0'),
            LOWER(first_names(MOD(i, 25) + 1)) || '.' || 
            LOWER(last_names(MOD(i, 25) + 1)) || '@hospital.com',
            ADD_MONTHS(SYSDATE, - (MOD(i, 120) + 12)),
            statuses(MOD(i, 4) + 1)
        );
    END LOOP;
    
    -- Update department head doctors
    FOR dept_rec IN (SELECT DEPARTMENT_ID FROM DEPARTMENT) LOOP
        UPDATE DEPARTMENT 
        SET HEAD_DOCTOR_ID = (
            SELECT DOCTOR_ID FROM DOCTOR 
            WHERE DEPARTMENT_ID = dept_rec.DEPARTMENT_ID 
            AND STATUS = 'ACTIVE'
            AND ROWNUM = 1
        )
        WHERE DEPARTMENT_ID = dept_rec.DEPARTMENT_ID;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('? 60 doctors inserted successfully');
    DBMS_OUTPUT.PUT_LINE('? Department head doctors assigned');
END;
/

DECLARE
    TYPE first_name_array IS VARRAY(30) OF VARCHAR2(50);
    patient_first_names first_name_array := first_name_array(
        'Emma', 'Liam', 'Olivia', 'Noah', 'Ava', 'Elijah', 'Sophia', 'Lucas',
        'Mia', 'Mason', 'Isabella', 'Logan', 'Amelia', 'Ethan', 'Harper',
        'Jacob', 'Evelyn', 'Michael', 'Abigail', 'Daniel', 'Emily', 'Henry',
        'Elizabeth', 'Jackson', 'Mila', 'Sebastian', 'Ella', 'Aiden', 'Scarlett',
        'Matthew'
    );
    
    TYPE last_name_array IS VARRAY(25) OF VARCHAR2(50);
    patient_last_names last_name_array := last_name_array(
        'Johnson', 'Smith', 'Brown', 'Davis', 'Wilson', 'Miller', 'Moore',
        'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin',
        'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez',
        'Lewis', 'Lee', 'Walker', 'Hall', 'Allen'
    );
    
    TYPE street_array IS VARRAY(20) OF VARCHAR2(100);
    streets street_array := street_array(
        'Main St', 'Oak Ave', 'Maple Dr', 'Cedar Ln', 'Pine St',
        'Elm St', 'Washington Ave', 'Lakeview Dr', 'Hill St', 'Park Ave',
        'Broadway', 'River Rd', 'Sunset Blvd', 'Forest Ave', 'Meadow Ln',
        'Highland Dr', 'Valley View', 'Mountain Rd', 'Ocean Dr', 'Spring St'
    );
    
    TYPE city_array IS VARRAY(10) OF VARCHAR2(50);
    cities city_array := city_array(
        'New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix',
        'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'
    );
BEGIN
    FOR i IN 1..250 LOOP
        INSERT INTO PATIENT (
            PATIENT_ID,
            FIRST_NAME,
            LAST_NAME,
            DATE_OF_BIRTH,
            GENDER,
            PHONE_NUMBER,
            EMAIL,
            ADDRESS,
            CREATED_DATE
        ) VALUES (
            seq_patient_id.NEXTVAL,
            patient_first_names(MOD(i, 30) + 1),
            patient_last_names(MOD(i, 25) + 1),
            ADD_MONTHS(SYSDATE, - (12 * (20 + MOD(i, 60)))),
            CASE MOD(i, 3) 
                WHEN 0 THEN 'M' 
                WHEN 1 THEN 'F' 
                ELSE 'O' 
            END,
            CASE 
                WHEN MOD(i, 20) = 0 THEN NULL
                ELSE '(' || LPAD(MOD(i*7, 999), 3, '0') || ') ' || 
                     LPAD(MOD(i*13, 999), 3, '0') || '-' || 
                     LPAD(MOD(i*17, 9999), 4, '0')
            END,
            CASE 
                WHEN MOD(i, 15) = 0 THEN NULL
                ELSE LOWER(patient_first_names(MOD(i, 30) + 1)) || '.' || 
                     LOWER(patient_last_names(MOD(i, 25) + 1)) || '@email.com'
            END,
            (MOD(i, 1000) + 1) || ' ' || streets(MOD(i, 20) + 1) || ', ' || 
            cities(MOD(i, 10) + 1) || ', ' || 
            CASE MOD(i, 4) 
                WHEN 0 THEN 'NY' 
                WHEN 1 THEN 'CA' 
                WHEN 2 THEN 'TX' 
                ELSE 'FL' 
            END || ' ' || LPAD(MOD(i, 99999), 5, '0'),
            SYSDATE - MOD(i, 365)
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('? 250 patients inserted successfully');
END;
/

BEGIN
    FOR i IN 1..120 LOOP
        INSERT INTO MEDICATION (
            MEDICATION_ID,
            MEDICATION_NAME,
            GENERIC_NAME,
            MANUFACTURER,
            UNIT_PRICE,
            STOCK_QUANTITY,
            REORDER_LEVEL,
            EXPIRY_DATE
        ) VALUES (
            seq_medication_id.NEXTVAL,
            'Medicine_' || i,
            'Generic_' || i,
            CASE MOD(i, 10)
                WHEN 0 THEN 'Pfizer'
                WHEN 1 THEN 'Novartis'
                WHEN 2 THEN 'Merck'
                WHEN 3 THEN 'Roche'
                WHEN 4 THEN 'GSK'
                WHEN 5 THEN 'Sanofi'
                WHEN 6 THEN 'AbbVie'
                WHEN 7 THEN 'Bayer'
                WHEN 8 THEN 'AstraZeneca'
                WHEN 9 THEN 'Johnson and Johnson'
                ELSE 'Generic Pharma'
            END,
            ROUND(DBMS_RANDOM.VALUE(1, 250), 2),
            TRUNC(DBMS_RANDOM.VALUE(0, 1000)),
            TRUNC(DBMS_RANDOM.VALUE(10, 200)),
            SYSDATE + TRUNC(DBMS_RANDOM.VALUE(180, 720))
        );
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('120 medications inserted successfully');
END;
/

DECLARE
    TYPE time_array IS VARRAY(8) OF VARCHAR2(10);
    appointment_times time_array := time_array(
        '09:00 AM', '10:30 AM', '11:00 AM', '01:30 PM', 
        '02:00 PM', '03:30 PM', '04:00 PM', '05:00 PM'
    );
    
    TYPE status_array IS VARRAY(5) OF VARCHAR2(20);
    appt_statuses status_array := status_array(
        'SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW', 'RESCHEDULED'
    );
BEGIN
    FOR i IN 1..450 LOOP
        INSERT INTO APPOINTMENT (
            APPOINTMENT_ID,
            PATIENT_ID,
            DOCTOR_ID,
            APPOINTMENT_DATE,
            APPOINTMENT_TIME,
            STATUS,
            NOTES,
            CREATED_BY,
            CREATED_DATE
        ) VALUES (
            seq_appointment_id.NEXTVAL,
            (SELECT PATIENT_ID FROM (SELECT PATIENT_ID FROM PATIENT ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1),
            (SELECT DOCTOR_ID FROM (SELECT DOCTOR_ID FROM DOCTOR WHERE STATUS = 'ACTIVE' ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1),
            CASE 
                WHEN MOD(i, 5) = 0 THEN SYSDATE + MOD(i, 30)  -- Future appointments
                ELSE SYSDATE - MOD(i, 180)  -- Past appointments
            END,
            appointment_times(MOD(i, 8) + 1),
            appt_statuses(MOD(i, 5) + 1),
            CASE 
                WHEN MOD(i, 10) = 0 THEN 'Follow-up appointment'
                WHEN MOD(i, 7) = 0 THEN 'Initial consultation'
                WHEN MOD(i, 5) = 0 THEN 'Routine checkup'
                WHEN MOD(i, 3) = 0 THEN 'Emergency follow-up'
                ELSE 'Regular appointment'
            END,
            'SYSTEM',
            SYSDATE - MOD(i, 30)
        );
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('? 450 appointments inserted successfully');
END;
/

DECLARE
    TYPE diagnosis_array IS VARRAY(20) OF VARCHAR2(500);
    diagnoses diagnosis_array := diagnosis_array(
        'Hypertension Stage 2', 'Type 2 Diabetes', 'Major Depressive Disorder',
        'Rheumatoid Arthritis', 'Asthma', 'Chronic Kidney Disease Stage 3',
        'Osteoarthritis', 'Hyperlipidemia', 'GERD', 'Migraine',
        'Anxiety Disorder', 'Hypothyroidism', 'COPD', 'Coronary Artery Disease',
        'Bronchitis', 'Pneumonia', 'UTI', 'Sinusitis', 'Influenza', 'Conjunctivitis'
    );
    
    TYPE symptom_array IS VARRAY(15) OF VARCHAR2(500);
    symptoms symptom_array := symptom_array(
        'Fever and chills', 'Chest pain', 'Shortness of breath', 
        'Persistent cough', 'Headache', 'Fatigue', 'Joint pain',
        'Nausea and vomiting', 'Dizziness', 'Abdominal pain',
        'Back pain', 'Sore throat', 'Runny nose', 'Muscle aches',
        'Loss of appetite'
    );
    
    v_counter NUMBER := 0;
BEGIN
    FOR appt_rec IN (SELECT a.APPOINTMENT_ID, a.DOCTOR_ID, a.APPOINTMENT_DATE
                     FROM APPOINTMENT a
                     WHERE a.STATUS = 'COMPLETED') LOOP
        EXIT WHEN v_counter >= 350;
        
        INSERT INTO CONSULTATION (
            CONSULTATION_ID,
            APPOINTMENT_ID,
            DOCTOR_ID,
            DIAGNOSIS,
            SYMPTOMS,
            CONSULTATION_DATE,
            TREATMENT_PLAN,
            FOLLOW_UP_REQUIRED,
            CONSULTATION_COST
        ) VALUES (
            seq_consultation_id.NEXTVAL,
            appt_rec.APPOINTMENT_ID,
            appt_rec.DOCTOR_ID,
            diagnoses(MOD(v_counter, 20) + 1),
            symptoms(MOD(v_counter, 15) + 1),
            appt_rec.APPOINTMENT_DATE + INTERVAL '1' HOUR,
            CASE 
                WHEN MOD(v_counter, 10) = 0 THEN 'Medication and lifestyle changes'
                WHEN MOD(v_counter, 7) = 0 THEN 'Physical therapy recommended'
                WHEN MOD(v_counter, 5) = 0 THEN 'Surgical intervention needed'
                WHEN MOD(v_counter, 3) = 0 THEN 'Regular monitoring required'
                ELSE 'Prescription medication'
            END,
            CASE 
                WHEN MOD(v_counter, 4) = 0 THEN 'N'
                ELSE 'Y'
            END,
            CASE 
                WHEN MOD(v_counter, 20) = 0 THEN 0
                ELSE 100 + (MOD(v_counter, 200) * 5)
            END
        );
        
        v_counter := v_counter + 1;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('? ' || v_counter || ' consultations inserted successfully');
END;
/

BEGIN
    DECLARE
        v_counter NUMBER := 0;
    BEGIN
        FOR cons_rec IN (
            SELECT c.CONSULTATION_ID, c.DOCTOR_ID, c.CONSULTATION_DATE
            FROM CONSULTATION c
            WHERE c.FOLLOW_UP_REQUIRED = 'Y'
        ) LOOP
            EXIT WHEN v_counter >= 300;
            
            INSERT INTO PRESCRIPTION (
                PRESCRIPTION_ID,
                CONSULTATION_ID,
                PRESCRIPTION_DATE,
                INSTRUCTIONS,
                VALID_UNTIL,
                STATUS,
                ISSUED_BY,
                CREATED_DATE
            ) VALUES (
                seq_prescription_id.NEXTVAL,
                cons_rec.CONSULTATION_ID,
                TRUNC(cons_rec.CONSULTATION_DATE),
                CASE 
                    WHEN MOD(v_counter, 10) = 0 THEN 'Take with food'
                    WHEN MOD(v_counter, 7) = 0 THEN 'Take on empty stomach'
                    WHEN MOD(v_counter, 5) = 0 THEN 'Avoid alcohol'
                    WHEN MOD(v_counter, 3) = 0 THEN 'Take at bedtime'
                    ELSE 'Take as needed'
                END,
                ADD_MONTHS(TRUNC(cons_rec.CONSULTATION_DATE), 6),
                CASE MOD(v_counter, 10)
                    WHEN 0 THEN 'CANCELLED'
                    WHEN 1 THEN 'EXPIRED'
                    ELSE 'ACTIVE'
                END,
                cons_rec.DOCTOR_ID,
                cons_rec.CONSULTATION_DATE + INTERVAL '30' MINUTE
            );
            
            v_counter := v_counter + 1;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('? ' || v_counter || ' prescriptions inserted successfully');
    END;
END;
/

BEGIN
    DECLARE
        TYPE dosage_array IS VARRAY(10) OF VARCHAR2(50);
        dosages dosage_array := dosage_array(
            '10mg', '20mg', '50mg', '100mg', '250mg',
            '500mg', '5mg', '25mg', '75mg', '150mg'
        );
        
        TYPE frequency_array IS VARRAY(8) OF VARCHAR2(100);
        frequencies frequency_array := frequency_array(
            'Once daily', 'Twice daily', 'Three times daily',
            'Every 6 hours', 'Every 8 hours', 'Every 12 hours',
            'Once weekly', 'As needed'
        );
        
        v_detail_counter NUMBER := 0;
    BEGIN
        FOR pres_rec IN (SELECT p.PRESCRIPTION_ID FROM PRESCRIPTION p WHERE p.STATUS = 'ACTIVE') LOOP
            -- Each prescription gets 1-3 medications
            FOR j IN 1..(MOD(ABS(DBMS_RANDOM.RANDOM), 3) + 1) LOOP
                EXIT WHEN v_detail_counter >= 500;
                
                INSERT INTO PRESCRIPTION_DETAIL (
                    DETAIL_ID,
                    PRESCRIPTION_ID,
                    MEDICATION_ID,
                    DOSAGE,
                    FREQUENCY,
                    DURATION_DAYS,
                    QUANTITY,
                    SPECIAL_INSTRUCTIONS
                ) VALUES (
                    seq_detail_id.NEXTVAL,
                    pres_rec.PRESCRIPTION_ID,
                    (SELECT MEDICATION_ID FROM (
                        SELECT MEDICATION_ID FROM MEDICATION 
                        WHERE STOCK_QUANTITY > 0
                        ORDER BY DBMS_RANDOM.VALUE
                    ) WHERE ROWNUM = 1),
                    dosages(MOD(v_detail_counter, 10) + 1),
                    frequencies(MOD(v_detail_counter, 8) + 1),
                    CASE 
                        WHEN MOD(v_detail_counter, 20) = 0 THEN 7
                        WHEN MOD(v_detail_counter, 15) = 0 THEN 30
                        ELSE 14
                    END,
                    MOD(v_detail_counter, 90) + 10,
                    CASE 
                        WHEN MOD(v_detail_counter, 10) = 0 THEN 'Take with plenty of water'
                        WHEN MOD(v_detail_counter, 7) = 0 THEN 'Avoid driving'
                        WHEN MOD(v_detail_counter, 5) = 0 THEN 'May cause drowsiness'
                        ELSE NULL
                    END
                );
                
                v_detail_counter := v_detail_counter + 1;
            END LOOP;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('? ' || v_detail_counter || ' prescription details inserted successfully');
    END;
END;
/

BEGIN
    DECLARE
        TYPE status_array IS VARRAY(4) OF VARCHAR2(20);
        payment_statuses status_array := status_array('PAID', 'PARTIAL', 'PENDING', 'CANCELLED');
        
        v_counter NUMBER := 0;
    BEGIN
        FOR cons_rec IN (
            SELECT c.CONSULTATION_ID, c.CONSULTATION_COST, a.PATIENT_ID
            FROM CONSULTATION c
            JOIN APPOINTMENT a ON c.APPOINTMENT_ID = a.APPOINTMENT_ID
            WHERE c.CONSULTATION_COST > 0
        ) LOOP
            EXIT WHEN v_counter >= 300;
            
            INSERT INTO BILL (
                BILL_ID,
                PATIENT_ID,
                CONSULTATION_ID,
                BILL_DATE,
                TOTAL_AMOUNT,
                PAID_AMOUNT,
                PAYMENT_STATUS,
                PAYMENT_DATE
            ) VALUES (
                seq_bill_id.NEXTVAL,
                cons_rec.PATIENT_ID,
                cons_rec.CONSULTATION_ID,
                TRUNC(SYSDATE - MOD(v_counter, 60)),
                cons_rec.CONSULTATION_COST,
                CASE 
                    WHEN MOD(v_counter, 4) = 0 THEN cons_rec.CONSULTATION_COST * 0.5
                    WHEN MOD(v_counter, 3) = 0 THEN cons_rec.CONSULTATION_COST
                    WHEN MOD(v_counter, 2) = 0 THEN 0
                    ELSE NULL
                END,
                payment_statuses(MOD(v_counter, 4) + 1),
                CASE 
                    WHEN MOD(v_counter, 3) = 0 THEN TRUNC(SYSDATE - MOD(v_counter, 30))
                    ELSE NULL
                END
            );
            
            v_counter := v_counter + 1;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('? ' || v_counter || ' bills inserted successfully');
    END;
END;
/

BEGIN
    DECLARE
        TYPE method_array IS VARRAY(6) OF VARCHAR2(30);
        payment_methods method_array := method_array(
            'CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'INSURANCE', 'BANK_TRANSFER', 'MOBILE_PAYMENT'
        );
        
        v_counter NUMBER := 0;
    BEGIN
        FOR bill_rec IN (
            SELECT b.BILL_ID, b.TOTAL_AMOUNT, b.PAID_AMOUNT
            FROM BILL b
            WHERE b.PAYMENT_STATUS IN ('PAID', 'PARTIAL')
            AND b.PAID_AMOUNT > 0
        ) LOOP
            EXIT WHEN v_counter >= 200;
            
            INSERT INTO PAYMENT (
                PAYMENT_ID,
                BILL_ID,
                PAYMENT_DATE,
                AMOUNT,
                PAYMENT_METHOD,
                TRANSACTION_REF,
                PROCESSED_BY
            ) VALUES (
                seq_payment_id.NEXTVAL,
                bill_rec.BILL_ID,
                SYSTIMESTAMP - (v_counter * INTERVAL '1' HOUR),
                bill_rec.PAID_AMOUNT,
                payment_methods(MOD(v_counter, 6) + 1),
                'TXN' || LPAD(v_counter, 8, '0'),
                'ADMIN_' || TO_CHAR(MOD(v_counter, 5) + 1)
            );
            
            v_counter := v_counter + 1;
        END LOOP;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('? ' || v_counter || ' payments inserted successfully');
    END;
END;
/