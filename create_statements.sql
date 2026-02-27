/* ============================================================ */
/* 1. CLEANUP (Optional - Drops tables if they exist to reset)  */
/* ============================================================ */

USE DATABASE project2;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS SUB_EVENT, ACADEMIC_EVENT, RELIGIOUS_EVENT, SOCIAL_EVENT, SPORTS_EVENT, EVENT;
DROP TABLE IF EXISTS PUBLIC_SPACE, CONFERENCE_HALL, LECTURE_HALL, SPORTS_AREA, VENUE;
DROP TABLE IF EXISTS DEPENDENT, STUDENT, STAFF, FACULTY, PERSON, ACADEMIC_DEPARTMENT;
DROP TABLE IF EXISTS EMAIL_LOG;
DROP VIEW IF EXISTS Public_Event_Calendar;
SET FOREIGN_KEY_CHECKS = 1;

/* ============================================================ */
/* 2. CREATE STRONG ENTITIES                                    */
/* ============================================================ */

CREATE TABLE ACADEMIC_DEPARTMENT (
    DeptCode VARCHAR(10) PRIMARY KEY,
    DeptName VARCHAR(100) NOT NULL
);

CREATE TABLE VENUE (
    VenueID INT PRIMARY KEY,
    Location VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL
);

CREATE TABLE PERSON (
    PersonID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE
);

/* ============================================================ */
/* 3. PERSON SUBCLASSES                                         */
/* ============================================================ */

CREATE TABLE FACULTY (
    PersonID INT PRIMARY KEY,
    Rank VARCHAR(50) NOT NULL,
    OfficeHours VARCHAR(100),
    FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
);

CREATE TABLE STAFF (
    PersonID INT PRIMARY KEY,
    JobTitle VARCHAR(50) NOT NULL,
    ExtensionNumber VARCHAR(20),
    FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
);

CREATE TABLE STUDENT (
    PersonID INT PRIMARY KEY,
    Major VARCHAR(50) NOT NULL,
    StudentLevel VARCHAR(20),
    FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
);

CREATE TABLE DEPENDENT (
    PersonID INT PRIMARY KEY,
    RelationType VARCHAR(50) NOT NULL,
    EmergencyContactPhone VARCHAR(20) NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES PERSON(PersonID) ON DELETE CASCADE
);

/* ============================================================ */
/* 4. VENUE SUBCLASSES                                          */
/* ============================================================ */

CREATE TABLE SPORTS_AREA (
    VenueID INT PRIMARY KEY,
    SurfaceType VARCHAR(50) NOT NULL,
    IsOutdoor CHAR(1) CHECK (IsOutdoor IN ('Y', 'N')), 
    FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
);

CREATE TABLE LECTURE_HALL (
    VenueID INT PRIMARY KEY,
    ProjectorType VARCHAR(50) NOT NULL,
    SeatCount INT NOT NULL,
    FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
);

CREATE TABLE CONFERENCE_HALL (
    VenueID INT PRIMARY KEY,
    CateringFacilities CHAR(1) CHECK (CateringFacilities IN ('Y', 'N')),
    MicrophoneCount INT NOT NULL,
    FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
);

CREATE TABLE PUBLIC_SPACE (
    VenueID INT PRIMARY KEY,
    IsCovered CHAR(1) CHECK (IsCovered IN ('Y', 'N')),
    PermitRequired CHAR(1) CHECK (PermitRequired IN ('Y', 'N')),
    FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID) ON DELETE CASCADE
);

/* ============================================================ */
/* 5. MAIN EVENT TABLE (With MySQL Constraints)                 */
/* ============================================================ */

CREATE TABLE EVENT (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(150) NOT NULL,
    StartDateTime DATETIME NOT NULL,
    EndDateTime DATETIME NOT NULL,
    ApprovalStatus VARCHAR(20) DEFAULT 'Pending' 
        CHECK (ApprovalStatus IN ('Pending', 'Approved', 'Rejected')),
    RejectionJustification VARCHAR(255),
    VenueID INT NOT NULL,
    DeptCode VARCHAR(10) NOT NULL,
    OrganizerPersonID INT NOT NULL,
    
    FOREIGN KEY (VenueID) REFERENCES VENUE(VenueID),
    FOREIGN KEY (DeptCode) REFERENCES ACADEMIC_DEPARTMENT(DeptCode),
    FOREIGN KEY (OrganizerPersonID) REFERENCES PERSON(PersonID),

    /* REQ 9: Max duration 3 days. MySQL Syntax: DATEDIFF(end, start) */
    CONSTRAINT Chk_Duration CHECK (DATEDIFF(EndDateTime, StartDateTime) <= 3),

    /* REQ 9: Between 8 AM and Midnight */
    CONSTRAINT Chk_StartTime CHECK (CAST(StartDateTime AS TIME) >= '08:00:00'),
    CONSTRAINT Chk_EndTime CHECK (CAST(EndDateTime AS TIME) <= '23:59:59')
);

/* ============================================================ */
/* 6. EVENT SUBCLASSES                                          */
/* ============================================================ */

CREATE TABLE SPORTS_EVENT (
    EventID INT PRIMARY KEY,
    SportType VARCHAR(50) NOT NULL,
    LeagueName VARCHAR(100),
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
);

CREATE TABLE SOCIAL_EVENT (
    EventID INT PRIMARY KEY,
    FoodProvided CHAR(1) CHECK (FoodProvided IN ('Y', 'N')),
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
);

CREATE TABLE RELIGIOUS_EVENT (
    EventID INT PRIMARY KEY,
    Denomination VARCHAR(50) NOT NULL,
    OfficiantName VARCHAR(100),
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
);

CREATE TABLE ACADEMIC_EVENT (
    EventID INT PRIMARY KEY,
    KeynoteSpeaker VARCHAR(100),
    PaperSubmissionDeadline DATETIME,
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE
);

/* ============================================================ */
/* 7. WEAK ENTITY: SUB_EVENT                                    */
/* ============================================================ */

CREATE TABLE SUB_EVENT (
    EventID INT,
    SubEventID INT,
    SubEventName VARCHAR(100) NOT NULL,
    StartTime DATETIME NOT NULL,
    AllocatedTime INT NOT NULL, -- Duration in minutes
    InChargePersonID INT NOT NULL,
    
    PRIMARY KEY (EventID, SubEventID),
    FOREIGN KEY (EventID) REFERENCES EVENT(EventID) ON DELETE CASCADE,
    FOREIGN KEY (InChargePersonID) REFERENCES PERSON(PersonID)
);

/* ============================================================ */
/* 8. CREATE VIEW (Req c)                                       */
/* ============================================================ */

CREATE VIEW Public_Event_Calendar AS
SELECT 
    E.EventName,
    E.StartDateTime,
    E.EndDateTime,
    V.Location AS VenueName,
    D.DeptName AS SponsorDepartment,
    P.FullName AS Organizer
FROM EVENT E
JOIN VENUE V ON E.VenueID = V.VenueID
JOIN ACADEMIC_DEPARTMENT D ON E.DeptCode = D.DeptCode
JOIN PERSON P ON E.OrganizerPersonID = P.PersonID
WHERE E.ApprovalStatus = 'Approved';

/* ============================================================ */
/* 9. TRIGGER (Req 8 - MySQL Syntax)                            */
/* ============================================================ */

-- 9a. Create the dummy email table
CREATE TABLE EMAIL_LOG (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    EventID INT,
    Message VARCHAR(255),
    SentDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 9b. Create the Trigger
DELIMITER //

CREATE TRIGGER trg_EventApproved
AFTER UPDATE ON EVENT
FOR EACH ROW
BEGIN
    -- Check if ApprovalStatus changed from NOT 'Approved' to 'Approved'
    IF NEW.ApprovalStatus = 'Approved' AND OLD.ApprovalStatus != 'Approved' THEN
        INSERT INTO EMAIL_LOG (EventID, Message)
        VALUES (NEW.EventID, 'Email sent to Maintenance, Office Services, Security: Event Approved.');
    END IF;
END //

DELIMITER ;