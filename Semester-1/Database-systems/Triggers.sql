-- TRIGGER 1 Validation for Crew Table
CREATE OR REPLACE TRIGGER trg_crew_standardization
BEFORE INSERT OR UPDATE ON Crew
FOR EACH ROW
BEGIN
    -- Data standardization
    -- Firstname first letter always capital, and lastname upper case
    :NEW.first_name := INITCAP(TRIM(:NEW.first_name));
    :NEW.last_name  := UPPER(TRIM(:NEW.last_name));
    :NEW.country    := UPPER(TRIM(:NEW.country));

    -- Data completion
    -- If role not set, use default
    IF :NEW.role IS NULL THEN
        :NEW.role := 'Mission Specialist';
    END IF;

    -- Data validation
    -- Verification if crew is at least 18 years old
    IF :NEW.date_of_birth IS NOT NULL THEN
        IF :NEW.date_of_birth > ADD_MONTHS(SYSDATE, -18 * 12) THEN
            RAISE_APPLICATION_ERROR(-20010, 'Validation Error: Crew member must be at least 18 years old.');
        END IF;
    END IF;
END;
/


-- TRIGGER 2 Delete
-- If a crew member is removed from the experiment
-- the trigger automatically removes them from all tasks connected with it.
CREATE OR REPLACE TRIGGER trg_propagate_crew_removal
AFTER DELETE ON Experiment_Crew
FOR EACH ROW
BEGIN
    -- Update task table, deleting assigment for crew but leaving the task
    UPDATE Task
    SET assigned_to = NULL
    WHERE experiment_id = :OLD.experiment_id
      AND assigned_to = :OLD.crew_id;
      
    -- logs
    DBMS_OUTPUT.PUT_LINE('Trigger fired: Removed crew ID ' || :OLD.crew_id || ' from tasks in experiment ' || :OLD.experiment_id);
END;
/

-- testing trigers
SET SERVEROUTPUT ON;

-- Triger 1 test 1
INSERT INTO Crew (first_name, last_name, role, country, date_of_birth)  VALUES ('jOhN', 'doErs', 'Pilot', 'usa', TO_DATE('1985-05-15', 'YYYY-MM-DD'));

SELECT first_name, last_name, role, country FROM Crew WHERE last_name = 'DOERS';

-- Triger 1 test 2
BEGIN
    INSERT INTO Crew (first_name, last_name, role, country, date_of_birth) 
    VALUES ('Timmy', 'Test', 'Pilot', 'Canada', TO_DATE('2016-01-01', 'YYYY-MM-DD'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
END;
/


-- Triger 2 TESTS
DECLARE
    v_crew_id NUMBER;
BEGIN
    SELECT crew_id INTO v_crew_id FROM Crew WHERE last_name = 'DOERS' FETCH FIRST 1 ROWS ONLY;

    INSERT INTO Experiment (experiment_id, name, agency_id, category_id, start_date) 
    VALUES (99, 'Lunar Soil Analysis', 1, 1, SYSDATE);

    INSERT INTO Experiment_Crew (experiment_id, crew_id) 
    VALUES (99, v_crew_id);

    INSERT INTO Task (task_id, name, experiment_id, assigned_to) 
    VALUES (99, 'Collect Samples', 99, v_crew_id);
    
    COMMIT;
END;
/

SELECT task_id, name, assigned_to FROM Task WHERE task_id = 99;

-- TEST DELETING DOERS 
DELETE FROM Experiment_Crew WHERE experiment_id = 99 AND crew_id = (SELECT crew_id FROM Crew WHERE last_name = 'DOERS' FETCH FIRST 1 ROWS ONLY);

SELECT task_id, name, assigned_to FROM Task WHERE task_id = 99;


-- Sprzątanie po testach
ROLLBACK;




