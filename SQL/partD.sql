
USE UniversityEventsDB;

-- CLEAR OLD DATA 
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE SUB_EVENT;
TRUNCATE TABLE ACADEMIC_EVENT;
TRUNCATE TABLE RELIGIOUS_EVENT;
TRUNCATE TABLE SOCIAL_EVENT;
TRUNCATE TABLE SPORTS_EVENT;
TRUNCATE TABLE EVENT;
TRUNCATE TABLE PUBLIC_SPACE;
TRUNCATE TABLE CONFERENCE_HALL;
TRUNCATE TABLE LECTURE_HALL;
TRUNCATE TABLE SPORTS_AREA;
TRUNCATE TABLE DEPENDENT;
TRUNCATE TABLE STUDENT;
TRUNCATE TABLE STAFF;
TRUNCATE TABLE FACULTY;
TRUNCATE TABLE PERSON;
TRUNCATE TABLE VENUE;
TRUNCATE TABLE ACADEMIC_DEPARTMENT;
TRUNCATE TABLE EMAIL_LOG;
SET FOREIGN_KEY_CHECKS = 1;


-- INSERT STRONG ENTITIES 

-- ACADEMIC_DEPARTMENT 
INSERT INTO ACADEMIC_DEPARTMENT (DeptCode, DeptName) VALUES
('CS', 'Computer Science'),
('MATH', 'Mathematics'),
('PHYS', 'Physics'),
('ENG', 'English Literature'),
('BIO', 'Biology');

-- VENUE 
INSERT INTO VENUE (VenueID, Location, Capacity) VALUES
(101, 'North Field', 5000), (102, 'East Gym', 200), (103, 'Tennis Court A', 50), (104, 'Swimming Pool', 100), (105, 'Soccer Pitch', 3000),
(201, 'Science Hall A', 300), (202, 'Main Auditorium', 1000), (203, 'Math Room 101', 50), (204, 'Bio Lab 3', 40), (205, 'Eng Room 202', 60),
(301, 'Grand Conference', 500), (302, 'Meeting Room A', 20), (303, 'Meeting Room B', 20), (304, 'Board Room', 15), (305, 'Banquet Hall', 200),
(401, 'Central Plaza', 10000), (402, 'Library Lawn', 500), (403, 'Student Center Lobby', 100), (404, 'Main Gate', 50), (405, 'Rooftop Garden', 80);

-- PERSON 
INSERT INTO PERSON (PersonID, FullName, Email) VALUES
-- Faculty
(1, 'Dr. Alice Smith', 'alice@uni.edu'), (2, 'Prof. Bob Jones', 'bob@uni.edu'), (3, 'Dr. Carol White', 'carol@uni.edu'), (4, 'Prof. Dave Black', 'dave@uni.edu'), (5, 'Dr. Eve Green', 'eve@uni.edu'),
-- Staff
(6, 'Frank Admin', 'frank@uni.edu'), (7, 'Grace Sec', 'grace@uni.edu'), (8, 'Hank Tech', 'hank@uni.edu'), (9, 'Ivy Maintenance', 'ivy@uni.edu'), (10, 'Jack Janitor', 'jack@uni.edu'),
-- Students
(11, 'Kevin Kid', 'kevin@student.edu'), (12, 'Laura Learner', 'laura@student.edu'), (13, 'Mike Major', 'mike@student.edu'), (14, 'Nancy New', 'nancy@student.edu'), (15, 'Oscar Old', 'oscar@student.edu'),
-- Dependents
(16, 'Penny Smith', 'penny@gmail.com'), (17, 'Quinn Jones', 'quinn@gmail.com'), (18, 'Randy White', 'randy@gmail.com'), (19, 'Sarah Black', 'sarah@gmail.com'), (20, 'Tim Green', 'tim@gmail.com');

-- INSERT SUBCLASS DATA                                      


-- FACULTY 
INSERT INTO FACULTY (PersonID, RankTitle, OfficeHours) VALUES
(1, 'Professor', 'Mon 10-12'), (2, 'Associate Prof', 'Tue 2-4'), (3, 'Lecturer', 'Wed 9-11'), (4, 'Professor', 'Thu 1-3'), (5, 'Assistant Prof', 'Fri 10-12');

-- STAFF 
INSERT INTO STAFF (PersonID, JobTitle, ExtensionNumber) VALUES
(6, 'Administrator', 'x101'), (7, 'Secretary', 'x102'), (8, 'Technician', 'x103'), (9, 'Manager', 'x104'), (10, 'Coordinator', 'x105');

-- STUDENT 
INSERT INTO STUDENT (PersonID, Major, StudentLevel) VALUES
(11, 'CS', 'Senior'), (12, 'Math', 'Junior'), (13, 'Physics', 'Sophomore'), (14, 'Biology', 'Freshman'), (15, 'English', 'Senior');

-- DEPENDENT 
INSERT INTO DEPENDENT (PersonID, RelationType, EmergencyContactPhone) VALUES
(16, 'Daughter', '555-0101'), (17, 'Son', '555-0102'), (18, 'Spouse', '555-0103'), (19, 'Child', '555-0104'), (20, 'Spouse', '555-0105');

-- INSERT VENUE SUBCLASS DATA                              
INSERT INTO SPORTS_AREA (VenueID, SurfaceType, IsOutdoor) VALUES
(101, 'Grass', TRUE), (102, 'Hardwood', FALSE), (103, 'Clay', TRUE), (104, 'Water', FALSE), (105, 'Turf', TRUE);

INSERT INTO LECTURE_HALL (VenueID, ProjectorType, SeatCount) VALUES
(201, '4K Laser', 300), (202, 'Standard', 1000), (203, 'None', 50), (204, 'SmartBoard', 40), (205, 'Standard', 60);

INSERT INTO CONFERENCE_HALL (VenueID, CateringFacilities, MicrophoneCount) VALUES
(301, TRUE, 10), (302, FALSE, 1), (303, FALSE, 1), (304, TRUE, 5), (305, TRUE, 4);

INSERT INTO PUBLIC_SPACE (VenueID, IsCovered, PermitRequired) VALUES
(401, FALSE, TRUE), (402, FALSE, FALSE), (403, TRUE, FALSE), (404, FALSE, TRUE), (405, TRUE, TRUE);

-- INSERT MAIN EVENTS 
INSERT INTO EVENT (EventID, EventName, StartDateTime, EndDateTime, ApprovalStatus, RejectionJustification, VenueID, DeptCode, OrganizerPersonID) VALUES
-- Sports Events
(1, 'Varsity Soccer Game', '2023-11-01 14:00:00', '2023-11-01 16:00:00', 'Approved', NULL, 101, 'BIO', 1),
(2, 'Swim Meet', '2023-11-02 09:00:00', '2023-11-02 12:00:00', 'Pending', NULL, 104, 'BIO', 2),
(3, 'Tennis Finals', '2023-11-03 10:00:00', '2023-11-03 13:00:00', 'Approved', NULL, 103, 'MATH', 11),
(4, 'Basketball Practice', '2023-11-04 18:00:00', '2023-11-04 20:00:00', 'Rejected', 'Conflicting Schedule', 102, 'CS', 12),
(5, 'Charity Run', '2023-11-05 08:00:00', '2023-11-05 11:00:00', 'Approved', NULL, 401, 'PHYS', 6),

-- Social Events
(6, 'Welcome Picnic', '2023-12-01 12:00:00', '2023-12-01 15:00:00', 'Approved', NULL, 402, 'ENG', 13),
(7, 'Movie Night', '2023-12-02 19:00:00', '2023-12-02 22:00:00', 'Approved', NULL, 201, 'CS', 14),
(8, 'Staff Dinner', '2023-12-03 18:00:00', '2023-12-03 21:00:00', 'Pending', NULL, 305, 'MATH', 7),
(9, 'Alumni Mixer', '2023-12-04 17:00:00', '2023-12-04 19:00:00', 'Approved', NULL, 301, 'BIO', 3),
(10, 'Coffee Hour', '2023-12-05 10:00:00', '2023-12-05 11:00:00', 'Approved', NULL, 403, 'ENG', 15),

-- Religious Events
(11, 'Morning Prayer', '2023-10-10 08:00:00', '2023-10-10 09:00:00', 'Approved', NULL, 405, 'ENG', 4),
(12, 'Holiday Service', '2023-10-11 18:00:00', '2023-10-11 20:00:00', 'Approved', NULL, 202, 'PHYS', 5),
(13, 'Meditation', '2023-10-12 12:00:00', '2023-10-12 13:00:00', 'Pending', NULL, 402, 'BIO', 8),
(14, 'Study Circle', '2023-10-13 14:00:00', '2023-10-13 16:00:00', 'Approved', NULL, 302, 'MATH', 9),
(15, 'Choir Practice', '2023-10-14 17:00:00', '2023-10-14 19:00:00', 'Rejected', 'Noise complaints', 205, 'CS', 10),

-- Academic Events
(16, 'Guest Lecture: AI', '2023-09-01 14:00:00', '2023-09-01 16:00:00', 'Approved', NULL, 201, 'CS', 1),
(17, 'Math Symposium', '2023-09-02 09:00:00', '2023-09-02 17:00:00', 'Approved', NULL, 301, 'MATH', 2),
(18, 'Physics Workshop', '2023-09-03 10:00:00', '2023-09-03 12:00:00', 'Pending', NULL, 203, 'PHYS', 3),
(19, 'Bio Research Fair', '2023-09-04 11:00:00', '2023-09-04 15:00:00', 'Approved', NULL, 403, 'BIO', 4),
(20, 'Literature Debate', '2023-09-05 15:00:00', '2023-09-05 17:00:00', 'Approved', NULL, 205, 'ENG', 5);


-- INSERT EVENT SUBCLASSES                               
INSERT INTO SPORTS_EVENT (EventID, SportType, LeagueName) VALUES
(1, 'Soccer', 'Varsity League'), (2, 'Swimming', 'Regional'), (3, 'Tennis', 'Intramural'), (4, 'Basketball', 'Training'), (5, 'Running', 'Charity');

INSERT INTO SOCIAL_EVENT (EventID, FoodProvided) VALUES
(6, TRUE), (7, TRUE), (8, TRUE), (9, TRUE), (10, FALSE);

INSERT INTO RELIGIOUS_EVENT (EventID, Denomination, OfficiantName) VALUES
(11, 'Interfaith', 'Rev. Green'), (12, 'Christian', 'Pastor Brown'), (13, 'Buddhist', 'Monk Li'), (14, 'Muslim', 'Imam Ahmed'), (15, 'Catholic', 'Father John');

INSERT INTO ACADEMIC_EVENT (EventID, KeynoteSpeaker, PaperSubmissionDeadline) VALUES
(16, 'Elon Musk', '2023-08-01 23:59:59'), (17, 'Terence Tao', '2023-08-02 23:59:59'), (18, 'Neil deGrasse Tyson', NULL), (19, 'Jane Goodall', '2023-08-04 23:59:59'), (20, 'Margaret Atwood', NULL);


-- INSERT WEAK ENTITY (Sub-Events)

-- Event 16  has sub-events 
INSERT INTO SUB_EVENT (EventID, SubEventID, SubEventName, StartTime, AllocatedTime, InChargePersonID) VALUES
(16, 1, 'Introduction', '2023-09-01 14:00:00', '15 mins', 11),
(16, 2, 'Main Talk', '2023-09-01 14:15:00', '60 mins', 11),
(16, 3, 'Q&A Session', '2023-09-01 15:15:00', '30 mins', 12),
(16, 4, 'Networking', '2023-09-01 15:45:00', '15 mins', 13),
(16, 5, 'Closing', '2023-09-01 16:00:00', '10 mins', 14);