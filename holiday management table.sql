-- Create holiday table for upcoming month
CREATE TABLE holiday_calendar (
    holiday_id NUMBER PRIMARY KEY,
    holiday_date DATE NOT NULL,
    holiday_name VARCHAR2(100) NOT NULL,
    holiday_type VARCHAR2(50) CHECK (holiday_type IN ('PUBLIC', 'BANK', 'LOCAL')),
    is_active CHAR(1) DEFAULT 'Y' CHECK (is_active IN ('Y', 'N')),
    created_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    created_by VARCHAR2(50) DEFAULT USER
) TABLESPACE SHOT_DATA;

-- Create sequence for holiday IDs
CREATE SEQUENCE seq_holiday_id START WITH 1 INCREMENT BY 1;

-- Create index for date lookups
CREATE INDEX idx_holiday_date ON holiday_calendar(holiday_date) TABLESPACE SHOT_INDEX;

-- Insert some sample holidays for testing (next 30 days)
BEGIN
    -- Insert public holidays for testing
    INSERT INTO holiday_calendar (holiday_id, holiday_date, holiday_name, holiday_type) 
    VALUES (seq_holiday_id.NEXTVAL, SYSDATE + 5, 'Test Public Holiday', 'PUBLIC');
    
    INSERT INTO holiday_calendar (holiday_id, holiday_date, holiday_name, holiday_type) 
    VALUES (seq_holiday_id.NEXTVAL, SYSDATE + 12, 'Bank Holiday', 'BANK');
    
    INSERT INTO holiday_calendar (holiday_id, holiday_date, holiday_name, holiday_type) 
    VALUES (seq_holiday_id.NEXTVAL, SYSDATE + 19, 'Local Festival', 'LOCAL');
    
    COMMIT;
END;
/

-- Verify holidays inserted
SELECT holiday_id, holiday_date, holiday_name, holiday_type 
FROM holiday_calendar 
ORDER BY holiday_date;