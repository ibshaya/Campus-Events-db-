# Campus Events Database System

A comprehensive database management system for university campus events, handling event scheduling, venue allocation, sponsorship, and automated approval workflows.

## Project Overview

This project provides a complete relational database solution for managing a university event calendar. It tracks various event types (sports, social, religious, and academic), venue specifications, and diverse organizer groups including faculty, staff, and students. The system enforces business rules regarding event duration, operating hours, and automated notifications upon event approval.

## Features

Categorized Event Management: Specialized storage for Sports, Social, Religious, and Academic events.

Diverse Venue Tracking: Handles specific requirements for Sports Areas, Lecture Halls, Conference Halls, and Public Spaces.

Approval Workflow: Integrated system for event status tracking (Pending, Approved, Rejected) including rejection justifications.

Automated Trigger System: Automatically logs notifications for Maintenance, Security, and Office Services when an event is approved.

Business Rule Enforcement: SQL constraints ensure events do not exceed 3 days and stay within the 8 AM to Midnight window.

BCNF Normalized Schema: Database designed through 1NF, 2NF, and BCNF steps to ensure data integrity and reduce redundancy.

## Project Structure

CampusEventsDB/
├── SQL/
│ ├── partC.sql # DDL: Table creation, views, and triggers [cite: 144]
│ ├── partD.sql # DML: Sample data population script [cite: 302]
│ ├── partE.sql # Stored Procedure: Database reset and setup [cite: 411]
│ └── partF.sql # Testing: Verification queries and test cases [cite: 590]
├── create_statements.sql # Core schema definition script
├── Report.pdf # Comprehensive project documentation [cite: 1]
├── Reqs.pdf # Original project requirements [cite: 756]
└── .vscode/settings.json # SQLTools connection configurations

## Technology Stack

Database: MySQL

Modeling: EER Diagramming

## Database Schema

### Main Entities

PERSON: Superclass for Faculty, Staff, Students, and Dependents who organize events.

VENUE: Superclass for campus locations with specific attributes like Capacity and Surface Type.

EVENT: Central entity tracking event times, approval status, and organizers.

ACADEMIC_DEPARTMENT: Sponsors for campus events.

### Weak Entities & Components

SUB_EVENT: Individual segments of a main event with assigned in-charge personnel.

EMAIL_LOG: Automated log table populated by triggers for approved events.

ApprovedEventDetails: A view that joins Events, Venues, Departments, and Organizers for public display.

## File Descriptions

partC.sql: Contains the complete schema definition including constraints for duration and timing.

partD.sql: Provides sample data for at least 5 rows per table to facilitate testing.

partE.sql: Defines a stored procedure that drops existing tables, recreates the schema, and re-populates data in one call.

partF.sql: Includes "Negative Testing" to prove the database rejects invalid data (e.g., events starting before 8 AM).

### By Ibrahim Alshayea & Abdulaziz Alkathiri
