-- TEST 1B: Attempt INSERT on PATIENTS table (should fail on weekdays)
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 1: Trigger blocks INSERT on weekday (DENIED) ===');
    DBMS_OUTPUT.PUT_LINE('Testing date: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD Day'));
    
    -- Clear previous test data
    DELETE FROM shot_admin.patients WHERE patient_id = 99999;
    COMMIT;
    
    -- Attempt INSERT
    INSERT INTO shot_admin.patients (
        patient_id, 
        first_name, 
        last_name, 
        date_of_birth,
        email
    ) VALUES (
        99999,
        'Weekday',
        'Test',
        DATE '1990-01-01',
        'test@email.com'
    );
    
    -- If we reach here on a weekday, the test FAILS
    DBMS_OUTPUT.PUT_LINE('? TEST FAILED: INSERT was allowed on weekday');
    DBMS_OUTPUT.PUT_LINE('Expected: Trigger should block INSERT on weekdays');
    ROLLBACK;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Check if error contains "DENIED" or "restricted"
        IF SQLERRM LIKE '%DENIED%' OR SQLERRM LIKE '%restricted%' OR SQLERRM LIKE '%weekday%' THEN
            DBMS_OUTPUT.PUT_LINE('? TEST PASSED: INSERT blocked on weekday');
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SUBSTR(SQLERRM, 1, 150));
        ELSE
            DBMS_OUTPUT.PUT_LINE('? UNEXPECTED ERROR: ' || SQLERRM);
        END IF;
END;
/