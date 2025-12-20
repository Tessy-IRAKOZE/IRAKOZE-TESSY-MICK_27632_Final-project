-- 4.1 Create PATIENTS trigger (BASIC VERSION - without audit logging yet)
CREATE OR REPLACE TRIGGER shot_admin.trg_patients_restrict
BEFORE INSERT OR UPDATE OR DELETE ON shot_admin.patients
FOR EACH ROW
DECLARE
    v_message VARCHAR2(400);
    v_operation VARCHAR2(10);
BEGIN
    -- Determine operation type
    IF INSERTING THEN
        v_operation := 'INSERT';
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
    ELSE
        v_operation := 'DELETE';
    END IF;
    
    -- Check restriction using the function
    v_message := shot_admin.fn_check_restriction(v_operation);
    
    -- Handle based on result
    IF v_message LIKE 'DENIED:%' THEN
        RAISE_APPLICATION_ERROR(-20001, 'TRG_PATIENTS_RESTRICT: ' || v_message);
    END IF;
    
END trg_patients_restrict;
/