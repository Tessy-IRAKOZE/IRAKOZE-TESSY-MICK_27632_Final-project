-- Test 7: Cursor and Window Function Demonstrations
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 7: Cursor and Window Functions');
    DBMS_OUTPUT.PUT_LINE('====================================');
    
    -- Test generate_doctor_report (explicit cursor)
    DBMS_OUTPUT.PUT_LINE('Doctor Report Demonstration:');
    SHOT_OPERATIONS_PKG.generate_doctor_report(2001);
    
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Test generate_hospital_statistics (window functions)
    DBMS_OUTPUT.PUT_LINE('Hospital Statistics Demonstration:');
    SHOT_OPERATIONS_PKG.generate_hospital_statistics;
    
    DBMS_OUTPUT.PUT_LINE('');
END;
/