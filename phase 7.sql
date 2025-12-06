-- 9.1 Verify all objects are valid
SELECT object_name, object_type, status
FROM all_objects
WHERE owner = 'SHOT_ADMIN'
  AND object_name IN (
      'PKG_AUDIT_UTILITIES', 
      'FN_CHECK_RESTRICTION',
      'TRG_PATIENTS_RESTRICT',
      'TRG_IMMUNIZATION_RESTRICT',
      'TRG_APPOINTMENTS_RESTRICT',
      'TRG_EMPLOYEES_RESTRICT'
  )
ORDER BY object_type, object_name;