-- ============================================
-- 2. AUDIT LOG TABLE
-- ============================================
CREATE TABLE shot_admin.audit_trail (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation_type VARCHAR2(10) NOT NULL CHECK (operation_type IN ('INSERT', 'UPDATE', 'DELETE')),
    record_id VARCHAR2(100), -- Can store primary key or other identifier
    old_values CLOB, -- JSON or formatted string of old values
    new_values CLOB, -- JSON or formatted string of new values
    attempt_status VARCHAR2(10) NOT NULL CHECK (attempt_status IN ('ALLOWED', 'DENIED', 'ERROR')),
    error_message VARCHAR2(4000),
    attempt_timestamp TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    username VARCHAR2(50) DEFAULT USER NOT NULL,
    session_id NUMBER,
    ip_address VARCHAR2(45),
    business_rule_violated VARCHAR2(100)
);

COMMENT ON TABLE shot_admin.audit_trail IS 'Comprehensive audit log for all database operations';
COMMENT ON COLUMN shot_admin.audit_trail.attempt_status IS 'ALLOWED=Operation permitted, DENIED=Blocked by rule, ERROR=System error';

-- Create indexes for performance
CREATE INDEX shot_admin.idx_audit_table_op ON shot_admin.audit_trail(table_name, operation_type);
CREATE INDEX shot_admin.idx_audit_timestamp ON shot_admin.audit_trail(attempt_timestamp);
CREATE INDEX shot_admin.idx_audit_user_status ON shot_admin.audit_trail(username, attempt_status);

-- Create a view for easy querying
CREATE OR REPLACE VIEW shot_admin.vw_audit_summary AS
SELECT 
    TRUNC(attempt_timestamp) AS audit_date,
    table_name,
    operation_type,
    attempt_status,
    COUNT(*) AS attempt_count,
    MIN(attempt_timestamp) AS first_attempt,
    MAX(attempt_timestamp) AS last_attempt
FROM shot_admin.audit_trail
GROUP BY TRUNC(attempt_timestamp), table_name, operation_type, attempt_status;