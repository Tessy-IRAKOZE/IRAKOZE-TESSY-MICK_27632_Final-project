-- TEST 5B: Sample clear error messages test
SET SERVEROUTPUT ON
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 5: Error messages are clear ===');
    DBMS_OUTPUT.PUT_LINE('Checking recent denied attempts for clarity...');
    
    FOR rec IN (
        SELECT error_message
        FROM shot_admin.audit_trail
        WHERE attempt_status = 'DENIED'
          AND attempt_timestamp > SYSDATE - 1/24
          AND ROWNUM <= 3
        ORDER BY attempt_timestamp DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('---');
        DBMS_OUTPUT.PUT_LINE('Error message: ' || rec.error_message);
        
        -- Check for key clarity elements
        IF rec.error_message LIKE 'DENIED:%' THEN
            DBMS_OUTPUT.PUT_LINE('? Starts with "DENIED:" - Clear indication');
        END IF;
        
        IF rec.error_message LIKE '%Today is%' THEN
            DBMS_OUTPUT.PUT_LINE('? Includes day/date information');
        END IF;
        
        IF rec.error_message LIKE '%weekday%' OR rec.error_message LIKE '%holiday%' OR 
           rec.error_message LIKE '%restricted%' THEN
            DBMS_OUTPUT.PUT_LINE('? Specifies restriction reason');
        END IF;
        
        IF rec.error_message LIKE '%allowed on weekend%' OR rec.error_message LIKE '%only allowed%' THEN
            DBMS_OUTPUT.PUT_LINE('? Explains when operations ARE allowed');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Overall: CLEAR error message');
    END LOOP;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No denied attempts found in last hour.');
        DBMS_OUTPUT.PUT_LINE('To test: Run on a weekday or add a holiday first.');
    END IF;
END;
/