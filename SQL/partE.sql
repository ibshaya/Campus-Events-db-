USE UniversityEventsDB;


DROP PROCEDURE IF EXISTS Project2_Reset_and_Populate;

-- DEFINE THE PROCEDURE
DELIMITER //

CREATE PROCEDURE Project2_Reset_and_Populate()
BEGIN
    -- DISABLE FOREIGN KEYS (To allow dropping tables freely)
    SET FOREIGN_KEY_CHECKS = 0;

    DROP TABLE IF EXISTS SUB_EVENT, ACADEMIC_EVENT, RELIGIOUS_EVENT, SOCIAL_EVENT, SPORTS_EVENT, EVENT;
    DROP TABLE IF EXISTS PUBLIC_SPACE, CONFERENCE_HALL, LECTURE_HALL, SPORTS_AREA, VENUE;
    DROP TABLE IF EXISTS DEPENDENT, STUDENT, STAFF, FACULTY, PERSON, ACADEMIC_DEPARTMENT;
    DROP TABLE IF EXISTS EMAIL_LOG;

    -- C. CREATE TABLES 
    
    CREATE TABLE ACADEMIC_DEPARTMENT (
        DeptCode VARCHAR(10) PRIMARY KEY,
        DeptName VARCHAR(100) NOT NULL
    );

    CREATE TABLE VENUE (
        VenueID INT PRIMARY KEY AUTO_INCREMENT,
        Location VARCHAR(255) NOT NULL,
        Capacity INT 
    );

    CREATE TABLE PERSON (
        PersonID INT PRIMARY KEY AUTO_INCREMENT,
        FullName VARCHAR(255) NOT NULL,
        Email VARCHAR(255) UNIQUE NOT NULL
    );

    CREATE TABLE FACULTY (
        PersonID INT PRIMARY KEY, RankTitle VARCHAR(50), OfficeHours VARCHAR(100),
        FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
    );

    CREATE TABLE STAFF (
        PersonID INT PRIMARY KEY, JobTitle VARCHAR(100), ExtensionNumber VARCHAR(20),
        FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
    );

    CREATE TABLE STUDENT (
        PersonID INT PRIMARY KEY, Major VARCHAR(50), StudentLevel VARCHAR(20), 
        FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
    );

    CREATE TABLE DEPENDENT (
        PersonID INT PRIMARY KEY, RelationType VARCHAR(50), EmergencyContactPhone VARCHAR(20),
        FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
    );

    CREATE TABLE SPORTS_AREA (
        VenueID INT PRIMARY KEY, SurfaceType VARCHAR(50), IsOutdoor BOOLEAN,
        FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
    );

    CREATE TABLE LECTURE_HALL (
        VenueID INT PRIMARY KEY, ProjectorType VARCHAR(50), SeatCount INT,
        FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
    );

    CREATE TABLE CONFERENCE_HALL (
        VenueID INT PRIMARY KEY, CateringFacilities BOOLEAN, MicrophoneCount INT,
        FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
    );

    CREATE TABLE PUBLIC_SPACE (
        VenueID INT PRIMARY KEY, IsCovered BOOLEAN, PermitRequired BOOLEAN,
        FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
    );

    CREATE TABLE EVENT (
        EventID INT PRIMARY KEY AUTO_INCREMENT,
        EventName VARCHAR(200) NOT NULL,
        StartDateTime DATETIME NOT NULL,
        EndDateTime DATETIME NOT NULL,
        ApprovalStatus ENUM('Pending', 'Approved', 'Rejected', 'Cancelled') DEFAULT 'Pending',
        RejectionJustification VARCHAR(255), 
        VenueID INT, DeptCode VARCHAR(10), OrganizerPersonID INT,
        FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID),
        FOREIGN KEY (DeptCode) REFERENCES ACADEMIC_DEPARTMENT(DeptCode),
        FOREIGN KEY (OrganizerPersonID) REFERENCES PERSON(PersonID),
        CONSTRAINT Chk_Duration CHECK (DATEDIFF(EndDateTime, StartDateTime) <= 3),
        CONSTRAINT Chk_StartTime CHECK (CAST(StartDateTime AS TIME) >= '08:00:00'),
        CONSTRAINT Chk_EndTime CHECK (CAST(EndDateTime AS TIME) <= '23:59:59')
    );

    CREATE TABLE SPORTS_EVENT (
        EventID INT PRIMARY KEY, SportType VARCHAR(50), LeagueName VARCHAR(100),
        FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
    );

    CREATE TABLE SOCIAL_EVENT (
        EventID INT PRIMARY KEY, FoodProvided BOOLEAN,
        FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
    );

    CREATE TABLE RELIGIOUS_EVENT (
        EventID INT PRIMARY KEY, Denomination VARCHAR(50), OfficiantName VARCHAR(100),
        FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
    );

    CREATE TABLE ACADEMIC_EVENT (
        EventID INT PRIMARY KEY, KeynoteSpeaker VARCHAR(100), PaperSubmissionDeadline DATETIME,
        FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
    );

    CREATE TABLE SUB_EVENT (
        EventID INT, SubEventID INT, SubEventName VARCHAR(150), StartTime DATETIME, AllocatedTime VARCHAR(50), InChargePersonID INT,
        PRIMARY KEY (EventID, SubEventID),
        FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE,
        FOREIGN KEY (InChargePersonID) REFERENCES PERSON(PersonID)
    );

    CREATE TABLE EMAIL_LOG (
        LogID INT AUTO_INCREMENT PRIMARY KEY, EventID INT, Message VARCHAR(255), SentDate DATETIME DEFAULT CURRENT_TIMESTAMP
    );

    -- D. POPULATE DATA (Using data from Part D)
    INSERT INTO ACADEMIC_DEPARTMENT VALUES 
    ('CS', 'Computer Science'), ('MATH', 'Mathematics'), ('PHYS', 'Physics'), ('ENG', 'English Literature'), ('BIO', 'Biology');

    INSERT INTO VENUE VALUES 
    (101, 'North Field', 5000), (102, 'East Gym', 200), (103, 'Tennis Court A', 50), (104, 'Swimming Pool', 100), (105, 'Soccer Pitch', 3000),
    (201, 'Science Hall A', 300), (202, 'Main Auditorium', 1000), (203, 'Math Room 101', 50), (204, 'Bio Lab 3', 40), (205, 'Eng Room 202', 60),
    (301, 'Grand Conference', 500), (302, 'Meeting Room A', 20), (303, 'Meeting Room B', 20), (304, 'Board Room', 15), (305, 'Banquet Hall', 200),
    (401, 'Central Plaza', 10000), (402, 'Library Lawn', 500), (403, 'Student Center Lobby', 100), (404, 'Main Gate', 50), (405, 'Rooftop Garden', 80);

    INSERT INTO PERSON VALUES 
    (1, 'Dr. Alice Smith', 'alice@uni.edu'), (2, 'Prof. Bob Jones', 'bob@uni.edu'), (3, 'Dr. Carol White', 'carol@uni.edu'), (4, 'Prof. Dave Black', 'dave@uni.edu'), (5, 'Dr. Eve Green', 'eve@uni.edu'),
    (6, 'Frank Admin', 'frank@uni.edu'), (7, 'Grace Sec', 'grace@uni.edu'), (8, 'Hank Tech', 'hank@uni.edu'), (9, 'Ivy Maintenance', 'ivy@uni.edu'), (10, 'Jack Janitor', 'jack@uni.edu'),
    (11, 'Kevin Kid', 'kevin@student.edu'), (12, 'Laura Learner', 'laura@student.edu'), (13, 'Mike Major', 'mike@student.edu'), (14, 'Nancy New', 'nancy@student.edu'), (15, 'Oscar Old', 'oscar@student.edu'),
    (16, 'Penny Smith', 'penny@gmail.com'), (17, 'Quinn Jones', 'quinn@gmail.com'), (18, 'Randy White', 'randy@gmail.com'), (19, 'Sarah Black', 'sarah@gmail.com'), (20, 'Tim Green', 'tim@gmail.com');

    INSERT INTO FACULTY VALUES (1, 'Professor', 'Mon 10-12'), (2, 'Associate Prof', 'Tue 2-4'), (3, 'Lecturer', 'Wed 9-11'), (4, 'Professor', 'Thu 1-3'), (5, 'Assistant Prof', 'Fri 10-12');
    INSERT INTO STAFF VALUES (6, 'Administrator', 'x101'), (7, 'Secretary', 'x102'), (8, 'Technician', 'x103'), (9, 'Manager', 'x104'), (10, 'Coordinator', 'x105');
    INSERT INTO STUDENT VALUES (11, 'CS', 'Senior'), (12, 'Math', 'Junior'), (13, 'Physics', 'Sophomore'), (14, 'Biology', 'Freshman'), (15, 'English', 'Senior');
    INSERT INTO DEPENDENT VALUES (16, 'Daughter', '555-0101'), (17, 'Son', '555-0102'), (18, 'Spouse', '555-0103'), (19, 'Child', '555-0104'), (20, 'Spouse', '555-0105');

    INSERT INTO SPORTS_AREA VALUES (101, 'Grass', TRUE), (102, 'Hardwood', FALSE), (103, 'Clay', TRUE), (104, 'Water', FALSE), (105, 'Turf', TRUE);
    INSERT INTO LECTURE_HALL VALUES (201, '4K Laser', 300), (202, 'Standard', 1000), (203, 'None', 50), (204, 'SmartBoard', 40), (205, 'Standard', 60);
    INSERT INTO CONFERENCE_HALL VALUES (301, TRUE, 10), (302, FALSE, 1), (303, FALSE, 1), (304, TRUE, 5), (305, TRUE, 4);
    INSERT INTO PUBLIC_SPACE VALUES (401, FALSE, TRUE), (402, FALSE, FALSE), (403, TRUE, FALSE), (404, FALSE, TRUE), (405, TRUE, TRUE);

    INSERT INTO EVENT VALUES
    (1, 'Varsity Soccer Game', '2023-11-01 14:00:00', '2023-11-01 16:00:00', 'Approved', NULL, 101, 'BIO', 1),
    (2, 'Swim Meet', '2023-11-02 09:00:00', '2023-11-02 12:00:00', 'Pending', NULL, 104, 'BIO', 2),
    (3, 'Tennis Finals', '2023-11-03 10:00:00', '2023-11-03 13:00:00', 'Approved', NULL, 103, 'MATH', 11),
    (4, 'Basketball Practice', '2023-11-04 18:00:00', '2023-11-04 20:00:00', 'Rejected', 'Conflicting Schedule', 102, 'CS', 12),
    (5, 'Charity Run', '2023-11-05 08:00:00', '2023-11-05 11:00:00', 'Approved', NULL, 401, 'PHYS', 6),
    (6, 'Welcome Picnic', '2023-12-01 12:00:00', '2023-12-01 15:00:00', 'Approved', NULL, 402, 'ENG', 13),
    (7, 'Movie Night', '2023-12-02 19:00:00', '2023-12-02 22:00:00', 'Approved', NULL, 201, 'CS', 14),
    (8, 'Staff Dinner', '2023-12-03 18:00:00', '2023-12-03 21:00:00', 'Pending', NULL, 305, 'MATH', 7),
    (9, 'Alumni Mixer', '2023-12-04 17:00:00', '2023-12-04 19:00:00', 'Approved', NULL, 301, 'BIO', 3),
    (10, 'Coffee Hour', '2023-12-05 10:00:00', '2023-12-05 11:00:00', 'Approved', NULL, 403, 'ENG', 15),
    (11, 'Morning Prayer', '2023-10-10 08:00:00', '2023-10-10 09:00:00', 'Approved', NULL, 405, 'ENG', 4),
    (12, 'Holiday Service', '2023-10-11 18:00:00', '2023-10-11 20:00:00', 'Approved', NULL, 202, 'PHYS', 5),
    (13, 'Meditation', '2023-10-12 12:00:00', '2023-10-12 13:00:00', 'Pending', NULL, 402, 'BIO', 8),
    (14, 'Study Circle', '2023-10-13 14:00:00', '2023-10-13 16:00:00', 'Approved', NULL, 302, 'MATH', 9),
    (15, 'Choir Practice', '2023-10-14 17:00:00', '2023-10-14 19:00:00', 'Rejected', 'Noise complaints', 205, 'CS', 10),
    (16, 'Guest Lecture: AI', '2023-09-01 14:00:00', '2023-09-01 16:00:00', 'Approved', NULL, 201, 'CS', 1),
    (17, 'Math Symposium', '2023-09-02 09:00:00', '2023-09-02 17:00:00', 'Approved', NULL, 301, 'MATH', 2),
    (18, 'Physics Workshop', '2023-09-03 10:00:00', '2023-09-03 12:00:00', 'Pending', NULL, 203, 'PHYS', 3),
    (19, 'Bio Research Fair', '2023-09-04 11:00:00', '2023-09-04 15:00:00', 'Approved', NULL, 403, 'BIO', 4),
    (20, 'Literature Debate', '2023-09-05 15:00:00', '2023-09-05 17:00:00', 'Approved', NULL, 205, 'ENG', 5);

    INSERT INTO SPORTS_EVENT VALUES (1, 'Soccer', 'Varsity League'), (2, 'Swimming', 'Regional'), (3, 'Tennis', 'Intramural'), (4, 'Basketball', 'Training'), (5, 'Running', 'Charity');
    INSERT INTO SOCIAL_EVENT VALUES (6, TRUE), (7, TRUE), (8, TRUE), (9, TRUE), (10, FALSE);
    INSERT INTO RELIGIOUS_EVENT VALUES (11, 'Interfaith', 'Rev. Green'), (12, 'Christian', 'Pastor Brown'), (13, 'Buddhist', 'Monk Li'), (14, 'Muslim', 'Imam Ahmed'), (15, 'Catholic', 'Father John');
    INSERT INTO ACADEMIC_EVENT VALUES (16, 'Elon Musk', '2023-08-01 23:59:59'), (17, 'Terence Tao', '2023-08-02 23:59:59'), (18, 'Neil deGrasse Tyson', NULL), (19, 'Jane Goodall', '2023-08-04 23:59:59'), (20, 'Margaret Atwood', NULL);

    INSERT INTO SUB_EVENT VALUES 
    (16, 1, 'Introduction', '2023-09-01 14:00:00', '15 mins', 11),
    (16, 2, 'Main Talk', '2023-09-01 14:15:00', '60 mins', 11),
    (16, 3, 'Q&A Session', '2023-09-01 15:15:00', '30 mins', 12),
    (16, 4, 'Networking', '2023-09-01 15:45:00', '15 mins', 13),
    (16, 5, 'Closing', '2023-09-01 16:00:00', '10 mins', 14);

    -- E. RE-ENABLE FOREIGN KEYS
    SET FOREIGN_KEY_CHECKS = 1;
END //
DELIMITER ;


-- EXECUTE PROCEDURE 
CALL Project2_Reset_and_Populate();


-- RE-CREATE TRIGGERS AND VIEWS 
DROP VIEW IF EXISTS ApprovedEventDetails;
CREATE VIEW ApprovedEventDetails AS
SELECT E.EventName, E.StartDateTime, V.Location, P.FullName AS Organizer, D.DeptName
FROM EVENT E
JOIN VENUE V ON E.VenueID = V.VenueID
JOIN PERSON P ON E.OrganizerPersonID = P.PersonID
JOIN ACADEMIC_DEPARTMENT D ON E.DeptCode = D.DeptCode
WHERE E.ApprovalStatus = 'Approved';

DROP TRIGGER IF EXISTS trg_EventApproved;
DELIMITER //
CREATE TRIGGER trg_EventApproved
AFTER UPDATE ON EVENT
FOR EACH ROW
BEGIN
    IF NEW.ApprovalStatus = 'Approved' AND OLD.ApprovalStatus != 'Approved' THEN
        INSERT INTO EMAIL_LOG (EventID, Message)
        VALUES (NEW.EventID, 'Email sent to Maintenance, Office Services, Security: Event Approved.');
    END IF;
END //
DELIMITER ;