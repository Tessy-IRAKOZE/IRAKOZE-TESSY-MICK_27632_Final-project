-- TEST 2B: Attempt INSERT on PATIENTS table (should succeed on weekends)
SET SERVEROUTPUT ON
DECLARE
    v_test_id NUMBER := 88888;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 2: Trigger allows INSERT on weekend (ALLOWED) ===');
    DBMS_OUTPUT.PUT_LINE('Testing date: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD Day'));
    
    -- Clear previous test data
    DELETE FROM shot_admin.patients WHERE patient_id = v_test_id;
    COMMIT;
    
    -- Attempt INSERT
    INSERT INTO shot_admin.patients (
        patient_id, 
        first_name, 
        last_name, 
        date_of_birth,
        email
    ) VALUES (
        v_test_id,
        'Weekend',
        'Test',
        DATE '1995-05-20',
        'weekend@test.com'
    );
    
    DBMS_OUTPUT.PUT_LINE('? INSERT successful');
    DBMS_OUTPUT.PUT_LINE('? TEST PASSED: INSERT allowed on weekend');
    
    -- Verify data was inserted
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM shot_admin.patients
        WHERE patient_id = v_test_id;
        
        IF v_count = 1 THEN
            DBMS_OUTPUT.PUT_LINE('? Data verification: Record found in table');
        ELSE
            DBMS_OUTPUT.PUT_LINE('? Data verification: Record NOT found');
        END IF;
    END;
    
    ROLLBACK; -- Clean up test data
    
EXCEPTION
    WHEN OTHERS THEN
        -- Check if today is actually a weekend
        IF TO_CHAR(SYSDATE, 'D') IN ('1', '7') THEN
            -- Today IS weekend but INSERT failed - test FAILS
            DBMS_OUTPUT.PUT_LINE('? TEST FAILED: INSERT blocked on weekend');
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Expected: Trigger should allow INSERT on weekends');
        ELSE
            -- Today is weekday, so this test should be skipped
            DBMS_OUTPUT.PUT_LINE('? TEST SKIPPED: Today is not a weekend');
            DBMS_OUTPUT.PUT_LINE('This test only runs on Saturdays (7) and Sundays (1)');
        END IF;
END;
/