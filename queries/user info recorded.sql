-- TEST 6B: Verify current user info is captured
SET SERVEROUTPUT ON
DECLARE
    v_current_user VARCHAR2(50);
    v_session_id NUMBER;
    v_ip_address VARCHAR2(45);
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== TEST 6: User info properly recorded ===');
    
    -- Get current user info
    SELECT USER INTO v_current_user FROM dual;
    
    SELECT sys_context('USERENV', 'SESSIONID'),
           sys_context('USERENV', 'IP_ADDRESS')
    INTO v_session_id, v_ip_address
    FROM dual;
    
    DBMS_OUTPUT.PUT_LINE('Current User: ' || v_current_user);
    DBMS_OUTPUT.PUT_LINE('Session ID: ' || v_session_id);
    DBMS_OUTPUT.PUT_LINE('IP Address: ' || v_ip_address);
    
    -- Check if this info appears in audit trail
    DECLARE
        v_audit_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_audit_count
        FROM shot_admin.audit_trail
        WHERE username = v_current_user
          AND session_id = v_session_id
          AND attempt_timestamp > SYSDATE - 5/1440;
        
        IF v_audit_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('? User info found in audit trail (' || v_audit_count || ' records)');
            
            -- Show sample
            FOR rec IN (
                SELECT table_name, operation_type, attempt_status,
                       TO_CHAR(attempt_timestamp, 'HH24:MI:SS') as time
                FROM shot_admin.audit_trail
                WHERE username = v_current_user
                  AND session_id = v_session_id
                  AND ROWNUM <= 3
                ORDER BY attempt_timestamp DESC
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('  - ' || rec.table_name || ' ' || rec.operation_type || 
                                    ' (' || rec.attempt_status || ') at ' || rec.time);
            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE('? No recent audit records for current user/session');
            DBMS_OUTPUT.PUT_LINE('  Run a test INSERT to generate audit record');
        END IF;
    END;
END;
/