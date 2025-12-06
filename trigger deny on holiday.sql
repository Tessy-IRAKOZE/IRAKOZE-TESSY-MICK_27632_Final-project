-- TEST 3C: Attempt INSERT on holiday (should fail even if it's a weekend)
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 3: Trigger blocks INSERT on holiday (DENIED) ===');
    DBMS_OUTPUT.PUT_LINE('Testing date: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD Day'));
    DBMS_OUTPUT.PUT_LINE('Today is marked as a holiday');
    
    -- Clear previous test data
    DELETE FROM shot_admin.patients WHERE patient_id = 77777;
    COMMIT;
    
    -- Attempt INSERT
    INSERT INTO shot_admin.patients (
        patient_id, 
        first_name, 
        last_name, 
        date_of_birth,
        email
    ) VALUES (
        77777,
        'Holiday',
        'Test',
        DATE '2000-12-25',
        'holiday@test.com'
    );
    
    -- If we reach here, the test FAILS (should be blocked)
    DBMS_OUTPUT.PUT_LINE('? TEST FAILED: INSERT was allowed on holiday');
    DBMS_OUTPUT.PUT_LINE('Expected: Trigger should block INSERT on holidays');
    ROLLBACK;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Check if error contains "DENIED" or "holiday"
        IF SQLERRM LIKE '%DENIED%' OR SQLERRM LIKE '%holiday%' OR SQLERRM LIKE '%HOLIDAY%' THEN
            DBMS_OUTPUT.PUT_LINE('? TEST PASSED: INSERT blocked on holiday');
            DBMS_OUTPUT.PUT_LINE('Error message: ' || SUBSTR(SQLERRM, 1, 150));
        ELSE
            DBMS_OUTPUT.PUT_LINE('? UNEXPECTED ERROR: ' || SQLERRM);
        END IF;
END;
/