CREATE OR REPLACE FUNCTION log_audit_trail(
    p_table_name IN VARCHAR2,
    p_operation_type IN VARCHAR2,
    p_record_id IN NUMBER DEFAULT NULL,
    p_old_values IN CLOB DEFAULT NULL,
    p_new_values IN CLOB DEFAULT NULL,
    p_operation_status IN VARCHAR2,
    p_error_message IN VARCHAR2 DEFAULT NULL,
    p_business_rule IN VARCHAR2 DEFAULT NULL,
    p_weekend_override IN CHAR DEFAULT 'N'
) RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_audit_id NUMBER;
    v_session_id NUMBER;
    v_os_user VARCHAR2(100);
    v_machine VARCHAR2(100);
    v_ip_address VARCHAR2(50);
BEGIN
    -- Get session information
    v_session_id := SYS_CONTEXT('USERENV', 'SESSIONID');
    v_os_user := SYS_CONTEXT('USERENV', 'OS_USER');
    v_machine := SYS_CONTEXT('USERENV', 'HOST');
    v_ip_address := SYS_CONTEXT('USERENV', 'IP_ADDRESS');
    
    -- Insert into audit log
    v_audit_id := seq_audit_id.NEXTVAL;
    
    INSERT INTO audit_log (
        audit_id,
        table_name,
        operation_type,
        operation_date,
        user_name,
        session_id,
        os_user,
        machine_name,
        ip_address,
        record_id,
        old_values,
        new_values,
        operation_status,
        error_message,
        business_rule_applied,
        weekend_override
    ) VALUES (
        v_audit_id,
        p_table_name,
        p_operation_type,
        SYSTIMESTAMP,
        USER,
        v_session_id,
        v_os_user,
        v_machine,
        v_ip_address,
        p_record_id,
        p_old_values,
        p_new_values,
        p_operation_status,
        p_error_message,
        p_business_rule,
        p_weekend_override
    );
    
    COMMIT;
    
    RETURN v_audit_id;
    
EXCEPTION
    WHEN OTHERS THEN
        -- If audit logging fails, try minimal logging
        BEGIN
            INSERT INTO system_audit_trail (
                system_audit_id,
                table_name,
                operation_type,
                user_name,
                error_message,
                trigger_name
            ) VALUES (
                seq_system_audit.NEXTVAL,
                'AUDIT_LOG',
                'ERROR',
                USER,
                'Audit logging failed: ' || SQLERRM,
                'log_audit_trail'
            );
            COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
                NULL; -- Last resort: ignore
        END;
        RETURN -1;
END log_audit_trail;
/