--QUITTER APEX
-- Enable server output to display the farewell message
SET SERVEROUTPUT ON;

-- Display the farewell message
BEGIN
    DBMS_OUTPUT.PUT_LINE('MERCI, AU RE-VOIR');
END;
/

-- Exit the SQL*Plus session
EXIT;
