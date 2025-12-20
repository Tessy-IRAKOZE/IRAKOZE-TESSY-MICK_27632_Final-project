-- TEST 4A: Generate multiple test attempts
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 4: Audit log captures all attempts ===');
    DBMS_OUTPUT.PUT_LINE('Generating test operations...');
    
    -- Clear test data
    DELETE FROM shot_admin.patients WHERE patient_id IN (11111, 22222, 33333);
    DELETE FROM shot_admin.audit_trail WHERE table_name = 'PATIENTS' 
        AND attempt_timestamp > SYSDATE - 1/24;
    COMMIT;
    
    -- Test 1: Attempt INSERT (may succeed or fail based on day/holiday)
    BEGIN
        INSERT INTO shot_admin.patients (patient_id, first_name, last_name)
        VALUES (11111, 'Audit', 'Test1');
        DBMS_OUTPUT.PUT_LINE('? Attempt 1: INSERT completed');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('? Attempt 1: INSERT blocked - ' || SUBSTR(SQLERRM, 1, 80));
    END;
    
    -- Test 2: Attempt UPDATE (if data exists)
    BEGIN
        -- First insert if not exists
        INSERT INTO shot_admin.patients (patient_id, first_name, last_name)
        VALUES (22222, 'Update', 'Test');
        
        UPDATE shot_admin.patients 
        SET first_name = 'Updated'
        WHERE patient_id = 22222;
        
        DBMS_OUTPUT.PUT_LINE('? Attempt 2: UPDATE completed');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('? Attempt 2: UPDATE blocked - ' || SUBSTR(SQLERRM, 1, 80));
            ROLLBACK;
    END;
    
    -- Test 3: Attempt DELETE (if data exists)
    BEGIN
        -- First insert if not exists
        INSERT INTO shot_admin.patients (patient_id, first_name, last_name)
        VALUES (33333, 'Delete', 'Test');
        
        DELETE FROM shot_admin.patients WHERE patient_id = 33333;
        
        DBMS_OUTPUT.PUT_LINE('? Attempt 3: DELETE completed');
        ROLLBACK;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('? Attempt 3: DELETE blocked - ' || SUBSTR(SQLERRM, 1, 80));
            ROLLBACK;
    END;
    
    DBMS_OUTPUT.PUT_LINE('All test operations attempted');
END;
/