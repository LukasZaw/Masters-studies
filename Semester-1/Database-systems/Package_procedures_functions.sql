CREATE OR REPLACE PACKAGE Mars_missions_package AS
-- Function
    -- Count workload in minutes for crew in active tasks
    FUNCTION get_crew_workload_minutes(p_crew_id NUMBER) RETURN NUMBER;

-- CURSORS
    -- Cursor for feching all open tesks for given experiment
    CURSOR c_pending_tasks(p_exp_id NUMBER) IS
        SELECT t.task_id, t.status_id, t.name
        FROM Task t
        JOIN Task_Status ts ON t.status_id = ts.status_id
        WHERE t.experiment_id = p_exp_id AND ts.name NOT IN ('Completed', 'Cancelled');

-- PROCEDURES
    -- Starting experiment
    PROCEDURE start_experiment(p_experiment_id NUMBER);
    
    -- Closing experiment and all of its not finished tasks
    PROCEDURE close_experiment(p_experiment_id NUMBER, p_closure_status VARCHAR2 DEFAULT 'Completed');
END Mars_missions_package;



-- PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY Mars_missions_package AS

    -- Count workload in minutes for crew in active tasks
    FUNCTION get_crew_workload_minutes(p_crew_id NUMBER) RETURN NUMBER IS
            v_total_minutes NUMBER := 0;
        BEGIN
            SELECT NVL(SUM(t.duration_minutes), 0)
            INTO v_total_minutes
            FROM Task t
            JOIN Task_Status ts ON t.status_id = ts.status_id
            WHERE t.assigned_to = p_crew_id AND ts.name NOT IN ('Completed', 'Cancelled');
    
            RETURN v_total_minutes;
        EXCEPTION
            WHEN OTHERS THEN
                RETURN 0; -- if err return 0
        END get_crew_workload_minutes;

    -- Procedure for starting existing experiment only if crew and task are assigned
    PROCEDURE start_experiment(p_experiment_id NUMBER) IS
        v_crew_count      NUMBER;
        v_task_count      NUMBER;
        v_start_date      DATE;
    BEGIN
        -- Check if experiment exists
        SELECT start_date INTO v_start_date FROM Experiment WHERE experiment_id = p_experiment_id;

        -- Check for crew members
        SELECT COUNT(*) INTO v_crew_count FROM Experiment_Crew WHERE experiment_id = p_experiment_id;

        IF v_crew_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cannot start experiment, no crew assigned, so cant be started.');
        END IF;

        -- Check tasks
        SELECT COUNT(*) INTO v_task_count FROM Task WHERE experiment_id = p_experiment_id;

        IF v_task_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Cannot start experiment, no tasks defined for this experiment, so cant be started.');
        END IF;

        -- Check if is not already started
        IF v_start_date IS NOT NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Experiment already started.');
        END IF;

        -- Set start date for NOW
        UPDATE Experiment SET start_date = SYSDATE WHERE experiment_id = p_experiment_id;

        -- Status Update
        UPDATE Task
        SET status_id = ( SELECT status_id FROM Task_Status WHERE name = 'In Progress')
        WHERE experiment_id = p_experiment_id AND status_id = ( SELECT status_id FROM Task_Status WHERE name = 'Planned');

        COMMIT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20000, 'Experiment does not exist.');
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END start_experiment;
    
    
    -- PROCEDURE 2
    
    PROCEDURE close_experiment(p_experiment_id NUMBER, p_closure_status VARCHAR2 DEFAULT 'Completed') IS
        v_target_status_id NUMBER;
    BEGIN
        -- exception for invalid argument
        BEGIN
            SELECT status_id INTO v_target_status_id
            FROM Task_Status
            WHERE name = p_closure_status;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20005, 'Invalid closure status provided.');
        END;

        -- Closing experiment
        UPDATE Experiment
        SET end_date = SYSDATE
        WHERE experiment_id = p_experiment_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Error - Experiment not found!!');
        END IF;

        -- Cursor for closing related tasks
        FOR rec IN c_pending_tasks(p_experiment_id) LOOP
            UPDATE Task
            SET status_id = v_target_status_id,
                completed_date = SYSDATE
            WHERE task_id = rec.task_id;
        END LOOP;

        COMMIT;
    END close_experiment;

END Mars_missions_package;




-- Aditional seed data for testing
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
VALUES ('Emergency Cooling Check',
        'Verify backup cooling loop performance under stress conditions.',
        1, 6, 4, 1, 
        TO_DATE('2024-05-05', 'YYYY-MM-DD'), 60);

SELECT name, status_id FROM Task WHERE experiment_id = 4;

INSERT INTO Experiment (name, agency_id, category_id)
VALUES ('Empty Experiment', 1, 1);
COMMIT;



-- Testing code
SET SERVEROUTPUT ON;

-- PROCEDURE 1
EXECUTE mars_missions_package.start_experiment(22);


DECLARE
    v_workload NUMBER;
BEGIN
    -- Funkcja
    v_workload := mars_missions_package.get_crew_workload_minutes(2);
    DBMS_OUTPUT.PUT_LINE('Workload for Alexander: ' || v_workload || ' minutes');

    -- Procedura 2
    mars_missions_package.close_experiment(22, 'Completed');
    DBMS_OUTPUT.PUT_LINE('Closing experiment number 22 and all of its tasks');
END;
/




