-- 3.1 Create the restriction check function (FIXED VERSION)
CREATE OR REPLACE FUNCTION shot_admin.fn_check_restriction(
    p_operation_type IN VARCHAR2
) RETURN VARCHAR2 IS
    v_restricted BOOLEAN;
    v_reason VARCHAR2(200);
    v_day_name VARCHAR2(20);
    v_today DATE := TRUNC(SYSDATE);
BEGIN
    -- Get day name
    SELECT TO_CHAR(SYSDATE, 'Day') INTO v_day_name FROM dual;
    
    -- Simple check for now - we'll enhance with package later
    DECLARE
        v_day_of_week VARCHAR2(10);
        v_holiday_count NUMBER := 0;
    BEGIN
        -- Check day of week (1=Sunday, 7=Saturday)
        SELECT TO_CHAR(SYSDATE, 'D') INTO v_day_of_week FROM dual;
        
        -- Check if holiday
        BEGIN
            SELECT COUNT(*) INTO v_holiday_count
            FROM shot_admin.holidays 
            WHERE TRUNC(holiday_date) = v_today;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_holiday_count := 0;
            WHEN OTHERS THEN
                v_holiday_count := 0;
        END;
        
        -- Determine restriction
        IF v_day_of_week BETWEEN '2' AND '6' THEN
            v_restricted := TRUE;
            v_reason := 'Operation restricted on weekdays (Monday-Friday)';
        ELSIF v_holiday_count > 0 THEN
            v_restricted := TRUE;
            v_reason := 'Operation restricted on public holiday';
        ELSE
            v_restricted := FALSE;
            v_reason := NULL;
        END IF;
    END;
    
    IF v_restricted THEN
        RETURN 'DENIED: ' || v_reason || 
               '. Today is ' || TRIM(v_day_name) || ', ' || 
               TO_CHAR(v_today, 'YYYY-MM-DD') ||
               '. ' || p_operation_type || ' operations are only allowed on weekends (non-holidays).';
    ELSE
        RETURN 'ALLOWED: Operation permitted on ' || TRIM(v_day_name) || 
               ', ' || TO_CHAR(v_today, 'YYYY-MM-DD');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: Unable to validate restriction - ' || SQLERRM;
END fn_check_restriction;
/