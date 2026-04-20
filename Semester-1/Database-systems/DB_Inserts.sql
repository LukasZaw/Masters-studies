-- System: Mission Task & Execution Management Database
-- File: Initial data (INSERT)

-- 1. PRIORITY

INSERT INTO Priority (name, sort_order) VALUES ('Low',      1);
INSERT INTO Priority (name, sort_order) VALUES ('Medium',   2);
INSERT INTO Priority (name, sort_order) VALUES ('High',     3);
INSERT INTO Priority (name, sort_order) VALUES ('Critical', 4);


-- 2. TASK_STATUS

INSERT INTO Task_Status (name, description, sort_order) VALUES ('Planned',     'Task created; awaiting start.',             1);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('In Progress', 'Task is currently being executed.',         2);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('On Hold',     'Task temporarily paused.',                  3);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('Completed',   'Task completed successfully.',              4);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('Cancelled',   'Task cancelled; it will not be executed.',  5);


-- 3. CATEGORY

INSERT INTO Category (name, description) VALUES ('Biology',         'Research on living organisms in microgravity conditions.');
INSERT INTO Category (name, description) VALUES ('Physics',         'Research on matter, energy, and fundamental forces in the space environment.');
INSERT INTO Category (name, description) VALUES ('Earth Science',   'Observation and study of Earth systems from an orbital perspective.');
INSERT INTO Category (name, description) VALUES ('Human Research',  'Research on the impact of spaceflight on the human body and mind.');
INSERT INTO Category (name, description) VALUES ('Technology Demo', 'Testing new technologies for future space missions.');


-- 4. AGENCY

INSERT INTO Agency (name, full_name, country) VALUES ('NASA',      'National Aeronautics and Space Administration',  'USA');
INSERT INTO Agency (name, full_name, country) VALUES ('ESA',       'European Space Agency',                          'Europe');
INSERT INTO Agency (name, full_name, country) VALUES ('JAXA',      'Japan Aerospace Exploration Agency',             'Japan');
INSERT INTO Agency (name, full_name, country) VALUES ('CSA',       'Canadian Space Agency',                          'Canada');
INSERT INTO Agency (name, full_name, country) VALUES ('ROSCOSMOS', 'State Space Corporation Roscosmos',              'Russia');


-- 5. CREW

INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Tracy',     'Dyson',         'Flight Engineer',     TO_DATE('1969-08-14', 'YYYY-MM-DD'), 'USA');
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Alexander', 'Gerst',         'Commander',           TO_DATE('1976-05-03', 'YYYY-MM-DD'), 'Germany');
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Sunita',    'Williams',      'Flight Engineer',     TO_DATE('1965-09-19', 'YYYY-MM-DD'), 'USA');
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Satoshi',   'Furukawa',      'Mission Specialist',  TO_DATE('1964-04-04', 'YYYY-MM-DD'), 'Japan');
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('David',     'Saint-Jacques', 'Flight Engineer',     TO_DATE('1970-01-06', 'YYYY-MM-DD'), 'Canada');
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Oleg',      'Kononenko',     'Commander',           TO_DATE('1964-06-21', 'YYYY-MM-DD'), 'Russia');


-- 6. EXPERIMENT

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date, end_date)
    VALUES ('Fluid Dynamics in Microgravity',
            'Study of fluid behavior in microgravity to improve spacecraft cooling systems.',
            1, 2, 1,
            TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Plant Growth Under UV Radiation',
            'Growing plants in space conditions—analysis of UV radiation impact on root and stem growth.',
            1, 1, 4,
            TO_DATE('2024-04-15', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Bone Density Loss Monitoring',
            'Monitoring bone density loss in crew members during long-duration orbital missions.',
            2, 4, 2,
            TO_DATE('2024-03-20', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Robotic Arm Precision Test',
            'Precision testing of the Canadarm3 robotic arm in microgravity conditions.',
            4, 5, 5,
            TO_DATE('2024-05-10', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Atmospheric CO2 Mapping',
            'Observation and mapping of atmospheric CO2 concentration using an orbital spectrometer.',
            3, 3, 4,
            TO_DATE('2024-06-01', 'YYYY-MM-DD'));


-- 7. TASK

-- Experiment 1
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, completed_date, duration_minutes)
    VALUES ('Pressure Sensor Calibration',
            'Calibration of pressure and temperature sensors before starting the fluid dynamics experiment.',
            1, 1, 3, 4,
            TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 120);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, completed_date, duration_minutes)
    VALUES ('Vacuum Pump Startup',
            'Activate the pumping system and verify the fluid loop is leak-tight.',
            1, 3, 3, 4,
            TO_DATE('2024-04-02', 'YYYY-MM-DD'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 90);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Phase 1 Results Analysis',
            'Collect data from the first phase and send it to Mission Control in Houston.',
            1, 1, 4, 1,
            TO_DATE('2024-05-01', 'YYYY-MM-DD'), 180);

-- Experiment 2
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Growth Medium Preparation',
            'Soak the substrate with nutrient solution and place it in the growth chamber.',
            2, 4, 2, 2,
            TO_DATE('2024-04-15', 'YYYY-MM-DD'), 90);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Daily Plant Growth Measurement',
            'Photograph and measure seedling height every 24 hours for 30 days.',
            2, 4, 2, 2,
            TO_DATE('2024-04-16', 'YYYY-MM-DD'), 30);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('UV Lamp Replacement',
            'Replace the damaged UV-C lamp in the growth chamber with a spare unit.',
            2, 3, 4, 3,
            TO_DATE('2024-04-20', 'YYYY-MM-DD'), 45);

-- Experiment 3
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Crew DEXA Scan',
            'Perform a DEXA bone densitometry scan for all crew members.',
            3, 2, 3, 4,
            TO_DATE('2024-03-25', 'YYYY-MM-DD'), 240);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Blood Sample Collection',
            'Collect blood samples to analyze calcium and vitamin D levels.',
            3, 2, 2, 2,
            TO_DATE('2024-04-25', 'YYYY-MM-DD'), 60);

-- Experiment 4
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Precision Gripper Test',
            'Conduct 50 trials of grasping objects with different masses and shapes using the Canadarm3 arm.',
            4, 5, 3, 2,
            TO_DATE('2024-05-12', 'YYYY-MM-DD'), 300);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Controller Firmware Update',
            'Upload a new version of the robotic arm controller firmware.',
            4, 5, 4, 1,
            TO_DATE('2024-05-20', 'YYYY-MM-DD'), 60);

-- Experiment 5
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Spectrometer Calibration',
            'Calibrate the orbital spectrometer before starting the atmospheric measurement campaign.',
            5, 4, 3, 1,
            TO_DATE('2024-06-01', 'YYYY-MM-DD'), 150);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('First CO2 Measurement Series',
            'Collect spectral data over the Amazon and Sahara regions during 12 orbits.',
            5, 6, 2, 1,
            TO_DATE('2024-06-05', 'YYYY-MM-DD'), 360);


-- 8. EXPERIMENT_CREW

-- Experiment 1
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (1, 1);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (1, 3);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (1, 6);

-- Experiment 2
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (2, 4);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (2, 1);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (2, 3);

-- Experiment 3
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (3, 2);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (3, 3);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (3, 6);

-- Experiment 4
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (4, 5);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (4, 2);

-- Experiment 5
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (5, 4);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (5, 6);

COMMIT;