
USE UniversityEventsDB;

   -- TEST 1: VERIFY DATA POPULATION
   -- Expected Result: We should see rows of event data.

SELECT * FROM EVENT LIMIT 10;


   -- TEST 2: VERIFY THE VIEW 
   -- Prove 'ApprovedEventDetails' correctly joins 4 tables and hides pending events.
   -- Expected Result: We should ONLY see events with 'Approved' status.

SELECT * FROM ApprovedEventDetails;


   -- TEST 3: VERIFY THE TRIGGER (Req 8)
   -- Prove that approving an event automatically logs an email.
 
-- Check the log:
SELECT * FROM EMAIL_LOG;

-- Change an event status from 'Pending' to 'Approved':
-- Event ID 2 is 'Swim Meet' which was Pending
UPDATE EVENT 
SET ApprovalStatus = 'Approved' 
WHERE EventID = 2;

-- Check the log again.
-- Expected Result: A NEW row should appear for EventID 2.
SELECT * FROM EMAIL_LOG;


   -- TEST 4: VERIFY TIME CONSTRAINTS (Req 9)
   -- Prove that the database REJECTS invalid data (Negative Testing).


-- Test A: Try to insert an event longer than 3 days.
-- Expected Result: Error Code "Check constraint 'Chk_Duration' violated"
INSERT INTO EVENT (EventName, StartDateTime, EndDateTime, VenueID, DeptCode, OrganizerPersonID)
VALUES ('Long Festival', '2023-12-01 10:00:00', '2023-12-06 10:00:00', 101, 'CS', 1);

-- Test B: Try to insert an event starting before 8 AM.
-- Expected Result: Error Code  "Check constraint 'Chk_StartTime' violated"
INSERT INTO EVENT (EventName, StartDateTime, EndDateTime, VenueID, DeptCode, OrganizerPersonID)
VALUES ('Early Riser', '2023-12-01 05:00:00', '2023-12-01 07:00:00', 101, 'CS', 1);


   -- TEST 5: VERIFY WEAK ENTITY & CASCADE DELETE
   -- Prove that deleting an Event automatically deletes its Sub-Events.

-- Verify sub-events exist for Event 16
SELECT * FROM SUB_EVENT WHERE EventID = 16;

-- Delete the main Event 16
DELETE FROM EVENT WHERE EventID = 16;

-- Check sub-events again.
-- Expected Result: Empty result set.
SELECT * FROM SUB_EVENT WHERE EventID = 16;