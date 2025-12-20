CREATE OR REPLACE FUNCTION check_operation_allowed(
    p_operation_type IN VARCHAR2
) RETURN VARCHAR2 IS
    v_current_day VARCHAR2(20);
    v_is_holiday NUMBER;
    v_is_weekday BOOLEAN;
    v_is_public_holiday BOOLEAN;
    v_error_message VARCHAR2(500);
BEGIN
    -- Get current day of week
    v_current_day := TO_CHAR(SYSDATE, 'DAY');
    
    -- Check if it's a weekday (Monday-Friday)
    v_is_weekday := UPPER(TRIM(v_current_day)) IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY');
    
    -- Check if today is a public holiday (active holidays only)
    SELECT COUNT(*) INTO v_is_holiday
    FROM holiday_calendar
    WHERE holiday_date = TRUNC(SYSDATE)
      AND is_active = 'Y'
      AND holiday_type = 'PUBLIC';
    
    v_is_public_holiday := (v_is_holiday > 0);
    
    -- Business Rule: NO operations on weekdays or public holidays
    IF v_is_weekday THEN
        v_error_message := 'Operation ' || p_operation_type || ' DENIED: Weekday restriction (Monday-Friday). Current day: ' || v_current_day;
        RETURN v_error_message;
    ELSIF v_is_public_holiday THEN
        v_error_message := 'Operation ' || p_operation_type || ' DENIED: Public holiday restriction.';
        RETURN v_error_message;
    ELSE
        RETURN 'ALLOWED'; -- Weekend and not a public holiday
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR checking restrictions: ' || SQLERRM;
END check_operation_allowed;
/