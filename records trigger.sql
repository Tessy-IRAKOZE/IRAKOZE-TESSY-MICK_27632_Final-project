-- 4.2 Create IMMUNIZATION_RECORDS trigger
CREATE OR REPLACE TRIGGER shot_admin.trg_immunization_restrict
BEFORE INSERT OR UPDATE OR DELETE ON shot_admin.immunization_records
FOR EACH ROW
DECLARE
    v_message VARCHAR2(400);
    v_operation VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_operation := 'INSERT';
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
    ELSE
        v_operation := 'DELETE';
    END IF;
    
    v_message := shot_admin.fn_check_restriction(v_operation);
    
    IF v_message LIKE 'DENIED:%' THEN
        RAISE_APPLICATION_ERROR(-20002, 'TRG_IMMUNIZATION_RESTRICT: ' || v_message);
    END IF;
    
END trg_immunization_restrict;
/