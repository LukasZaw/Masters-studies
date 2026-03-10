-- =============================================================
-- System: Mission Task & Execution Management Database
-- Plik: Dane początkowe (INSERT)
-- =============================================================
-- Kolejność insertów odpowiada zależnościom kluczy obcych:
-- Słownikowe → Crew → Experiment → Task → Powiązania
-- =============================================================


-- =============================================================
-- 1. PRIORITY (poziomy priorytetów)
-- =============================================================

INSERT INTO Priority (name, sort_order) VALUES ('Low',      1);
INSERT INTO Priority (name, sort_order) VALUES ('Medium',   2);
INSERT INTO Priority (name, sort_order) VALUES ('High',     3);
INSERT INTO Priority (name, sort_order) VALUES ('Critical', 4);


-- =============================================================
-- 2. TASK_STATUS (statusy zadań)
-- =============================================================

INSERT INTO Task_Status (name, description, sort_order) VALUES ('Planned',     'Zadanie utworzone, oczekuje na rozpoczęcie',   1);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('In Progress', 'Zadanie jest aktualnie realizowane',           2);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('On Hold',     'Zadanie tymczasowo wstrzymane',               3);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('Completed',   'Zadanie zakończone pomyślnie',                4);
INSERT INTO Task_Status (name, description, sort_order) VALUES ('Cancelled',   'Zadanie anulowane, nie będzie realizowane',    5);


-- =============================================================
-- 3. CATEGORY (kategorie eksperymentów)
-- =============================================================

INSERT INTO Category (name, description) VALUES ('Biology',         'Badania nad organizmami żywymi w warunkach mikrograwitacji.');
INSERT INTO Category (name, description) VALUES ('Physics',         'Badania materii, energii i sił fundamentalnych w środowisku kosmicznym.');
INSERT INTO Category (name, description) VALUES ('Earth Science',   'Obserwacja i badanie systemów Ziemi z perspektywy orbitalnej.');
INSERT INTO Category (name, description) VALUES ('Human Research',  'Badania wpływu lotu kosmicznego na organizm i psychikę człowieka.');
INSERT INTO Category (name, description) VALUES ('Technology Demo', 'Testowanie nowych technologii dla przyszłych misji kosmicznych.');


-- =============================================================
-- 4. AGENCY (agencje kosmiczne)
-- =============================================================

INSERT INTO Agency (name, full_name, country) VALUES ('NASA',      'National Aeronautics and Space Administration',  'USA');
INSERT INTO Agency (name, full_name, country) VALUES ('ESA',       'European Space Agency',                          'Europe');
INSERT INTO Agency (name, full_name, country) VALUES ('JAXA',      'Japan Aerospace Exploration Agency',             'Japan');
INSERT INTO Agency (name, full_name, country) VALUES ('CSA',       'Canadian Space Agency',                          'Canada');
INSERT INTO Agency (name, full_name, country) VALUES ('ROSCOSMOS', 'State Space Corporation Roscosmos',              'Russia');


-- =============================================================
-- 5. CREW (członkowie załogi)
-- =============================================================

-- Source: https://www.nasa.gov/people/tracy-caldwell-dyson-2/
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Tracy',    'Dyson',      'Flight Engineer',    TO_DATE('1969-08-14', 'YYYY-MM-DD'), 'USA');
-- Source: https://www.esa.int/Science_Exploration/Human_and_Robotic_Exploration/Astronauts/Alexander_Gerst
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Alexander','Gerst',      'Commander',          TO_DATE('1976-05-03', 'YYYY-MM-DD'), 'Germany');
-- Source: https://www.nasa.gov/people/sunita-williams/
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Sunita',   'Williams',   'Flight Engineer',    TO_DATE('1965-09-19', 'YYYY-MM-DD'), 'USA');
-- Source: https://global.jaxa.jp/projects/iss/furukawa/
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Satoshi',  'Furukawa',   'Mission Specialist', TO_DATE('1964-04-04', 'YYYY-MM-DD'), 'Japan');
-- Source: https://www.asc-csa.gc.ca/eng/astronauts/canadian/active/bio-david-saint-jacques.asp
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('David',    'Saint-Jacques','Flight Engineer',  TO_DATE('1970-01-06', 'YYYY-MM-DD'), 'Canada');
-- Source: https://en.wikipedia.org/wiki/Oleg_Kononenko
INSERT INTO Crew (first_name, last_name, role, date_of_birth, country)
    VALUES ('Oleg',     'Kononenko',  'Commander',          TO_DATE('1964-06-21', 'YYYY-MM-DD'), 'Russia');


-- =============================================================
-- 6. EXPERIMENT (eksperymenty naukowe)
-- =============================================================

-- agency_id: 1=NASA, 2=ESA, 3=JAXA, 4=CSA, 5=ROSCOSMOS
-- category_id: 1=Biology, 2=Physics, 3=Earth Science, 4=Human Research, 5=Technology Demo
-- facility_manager → crew_id

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date, end_date)
    VALUES ('Fluid Dynamics in Microgravity',
            'Badanie zachowania płynów w warunkach mikrograwitacji w celu poprawy systemów chłodzenia statków.',
            1, 2, 1,
            TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Plant Growth Under UV Radiation',
            'Hodowla roślin w warunkach kosmicznych — analiza wpływu promieniowania UV na wzrost korzeni i łodyg.',
            1, 1, 4,
            TO_DATE('2024-04-15', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Bone Density Loss Monitoring',
            'Monitorowanie utraty gęstości kości u członków załogi podczas długotrwałego pobytu na orbicie.',
            2, 4, 2,
            TO_DATE('2024-03-20', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Robotic Arm Precision Test',
            'Testy precyzji ramienia robotycznego Canadarm3 w warunkach mikrograwitacji.',
            4, 5, 5,
            TO_DATE('2024-05-10', 'YYYY-MM-DD'));

INSERT INTO Experiment (name, description, agency_id, category_id, facility_manager, start_date)
    VALUES ('Atmospheric CO2 Mapping',
            'Obserwacja i mapowanie stężenia CO2 w atmosferze Ziemi z wykorzystaniem spektrometru orbitalnego.',
            3, 3, 4,
            TO_DATE('2024-06-01', 'YYYY-MM-DD'));


-- =============================================================
-- 7. TASK (zadania w ramach eksperymentów)
-- =============================================================

-- experiment_id: 1=Fluid, 2=Plant, 3=Bone, 4=Robotic, 5=CO2
-- assigned_to → crew_id: 1=Dyson, 2=Gerst, 3=Williams, 4=Furukawa, 5=Saint-Jacques, 6=Kononenko
-- priority_id: 1=Low, 2=Medium, 3=High, 4=Critical
-- status_id: 1=Planned, 2=In Progress, 3=On Hold, 4=Completed, 5=Cancelled

-- Experiment 1: Fluid Dynamics
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, completed_date, duration_minutes)
    VALUES ('Kalibracja czujników ciśnienia',
            'Kalibracja czujników ciśnienia i temperatury przed rozpoczęciem eksperymentu z dynamiką płynów.',
            1, 1, 3, 4,
            TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-01', 'YYYY-MM-DD'), 120);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, completed_date, duration_minutes)
    VALUES ('Uruchomienie pompy próżniowej',
            'Aktywacja systemu pompowania i weryfikacja szczelności obiegu płynów.',
            1, 3, 3, 4,
            TO_DATE('2024-04-02', 'YYYY-MM-DD'), TO_DATE('2024-04-02', 'YYYY-MM-DD'), 90);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Analiza wyników fazy 1',
            'Zebranie danych z pierwszej fazy i przesłanie do centrum kontroli w Houston.',
            1, 1, 4, 1,
            TO_DATE('2024-05-01', 'YYYY-MM-DD'), 180);

-- Experiment 2: Plant Growth
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Przygotowanie podłoża',
            'Nasączenie substratu roztworem odżywczym i umieszczenie w komorze wzrostowej.',
            2, 4, 2, 2,
            TO_DATE('2024-04-15', 'YYYY-MM-DD'), 90);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Codzienny pomiar wzrostu roślin',
            'Fotografowanie i pomiar wysokości sadzonek co 24h przez 30 dni.',
            2, 4, 2, 2,
            TO_DATE('2024-04-16', 'YYYY-MM-DD'), 30);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Wymiana lampy UV',
            'Wymiana uszkodzonej lampy UV-C w komorze wzrostowej na zapasową.',
            2, 3, 4, 3,
            TO_DATE('2024-04-20', 'YYYY-MM-DD'), 45);

-- Experiment 3: Bone Density
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Skan DEXA załogi',
            'Wykonanie skanu densytometrycznego kości u wszystkich członków załogi.',
            3, 2, 3, 4,
            TO_DATE('2024-03-25', 'YYYY-MM-DD'), 240);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Pobranie próbek krwi',
            'Pobranie próbek krwi do analizy poziomu wapnia i witaminy D.',
            3, 2, 2, 2,
            TO_DATE('2024-04-25', 'YYYY-MM-DD'), 60);

-- Experiment 4: Robotic Arm
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Test chwytaka precyzyjnego',
            'Seria 50 prób chwytania obiektów o różnej masie i kształcie ramieniem Canadarm3.',
            4, 5, 3, 2,
            TO_DATE('2024-05-12', 'YYYY-MM-DD'), 300);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Aktualizacja firmware kontrolera',
            'Wgranie nowej wersji oprogramowania sterującego ramieniem robotycznym.',
            4, 5, 4, 1,
            TO_DATE('2024-05-20', 'YYYY-MM-DD'), 60);

-- Experiment 5: CO2 Mapping
INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Kalibracja spektrometru',
            'Kalibracja spektrometru orbitalnego przed rozpoczęciem serii pomiarów atmosferycznych.',
            5, 4, 3, 1,
            TO_DATE('2024-06-01', 'YYYY-MM-DD'), 150);

INSERT INTO Task (name, description, experiment_id, assigned_to, priority_id, status_id, planned_date, duration_minutes)
    VALUES ('Pierwsza seria pomiarów CO2',
            'Zebranie danych spektralnych nad regionem Amazonii i Sahary podczas 12 orbit.',
            5, 6, 2, 1,
            TO_DATE('2024-06-05', 'YYYY-MM-DD'), 360);


-- =============================================================
-- 8. EXPERIMENT_CREW (powiązania załoga ↔ eksperyment)
-- =============================================================

-- Experiment 1: Fluid Dynamics — Dyson (manager), Williams, Kononenko
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (1, 1);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (1, 3);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (1, 6);

-- Experiment 2: Plant Growth — Furukawa (manager), Dyson
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (2, 4);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (2, 1);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (2, 3);

-- Experiment 3: Bone Density — Gerst (manager), Williams, Kononenko
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (3, 2);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (3, 3);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (3, 6);

-- Experiment 4: Robotic Arm — Saint-Jacques (manager), Gerst
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (4, 5);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (4, 2);

-- Experiment 5: CO2 Mapping — Furukawa (manager), Kononenko
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (5, 4);
INSERT INTO Experiment_Crew (experiment_id, crew_id) VALUES (5, 6);

COMMIT;