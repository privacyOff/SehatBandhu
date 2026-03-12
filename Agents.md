Purpose
This file provides instructions for AI coding agents working in this repository. Agents must follow the architecture, coding standards, and workflows defined here when generating or modifying code.

Primary Goals
Maintain clean architecture
Preserve offline-first capability
Ensure Supabase security rules remain intact
Avoid unnecessary dependencies
Produce readable and maintainable Flutter code

Project Overview
This project is a rural telemedicine platform designed for low-bandwidth environments. The system allows patients to consult doctors remotely, book appointments, access prescriptions, and view medical records. The application must function reliably even in areas with unstable or slow internet connectivity.

Technology Stack
Frontend: Flutter
Backend: Supabase (PostgreSQL, Auth, Storage, Edge Functions)
State Management: Riverpod
Video Consultation: Jitsi Meet
Local Storage: Hive or SQLite

System Architecture
The system follows clean architecture with a feature-first structure.

Layers
UI Layer: Flutter widgets, screens, and user interactions
Domain Layer: business logic, entities, and use cases
Data Layer: repositories, Supabase integration, local caching

High Level Architecture
Flutter App
UI Layer
Domain Layer
Data Layer
Supabase Auth
PostgreSQL Database
Supabase Storage
Edge Functions
Jitsi Meet Video SDK

Core Entities
User
Doctor
Patient
Appointment
MedicalRecord
Prescription

Relationships
Patients book appointments with doctors
Doctors create prescriptions and medical records
Appointments connect patients and doctors

Project Directory Structure

lib
core
network
errors
themes
local_storage

features
auth
appointments
consultation
medical_records

shared
widgets
models

supabase
edge_functions
rls_policies

Directory Rules
Each feature must contain models, repositories, providers, and screens.
Reusable widgets and shared models belong in shared.
Networking utilities and error handling belong in core.

Development Commands

Install dependencies
flutter pub get

Run application
flutter run

Analyze code
flutter analyze

Run tests
flutter test

Supabase Commands

Start local Supabase
supabase start

Create migration
supabase migration new migration_name

Deploy edge functions
supabase functions deploy

Coding Guidelines

Architecture Rules
Use clean architecture principles.
Organize code using feature-first structure.
Avoid mixing UI logic with business logic.
Prefer repository pattern for data access.

Flutter Guidelines
UI logic belongs in screens or widgets.
Business logic belongs in services or repositories.
State management should use Riverpod providers.
Models should be immutable whenever possible.

Naming Conventions
user_model.dart
appointment_repository.dart
book_appointment_screen.dart
doctor_profile_provider.dart

Offline First Design

The system must support unstable connectivity.

Requirements
Cache appointments locally.
Cache medical records locally.
Queue write operations when offline.
Sync automatically when internet becomes available.
Display an Offline Mode indicator in the UI.

Local Storage Options
Hive for simple key-value storage.
SQLite for relational offline storage.

User Interface Guidelines

The application targets rural users with low digital literacy.

UI Requirements
Large buttons with minimum height of 60 pixels.
High contrast colors.
Minimal steps for critical actions.
Use icons together with text labels.

Example Actions
Book Appointment
Call Doctor
View Prescription
Start Consultation

Language Support
English
Hindi
Marathi
Gujarati

Video Consultation

Video calls are implemented using Jitsi Meet.

Flutter package
jitsi_meet_flutter_sdk

Network Handling Rule
If poor network conditions are detected the system should disable video and prioritize audio stability.

Security Model

Access control is enforced using Supabase Row Level Security policies.

Patients
Can view their own appointments.
Can view their own medical records.

Doctors
Can view appointments assigned to them.
Can access records of patients linked to their appointments.

Admins
Have full system access.

Edge Functions

Important backend operations run through Supabase Edge Functions.

Example responsibilities
Doctor license verification
Appointment notifications
Medical record processing
User onboarding workflows

Agent Development Rules

Agents modifying this repository must follow these rules.

Always follow the feature-first architecture.
Prefer modifying existing modules instead of creating duplicate code.
Avoid introducing new dependencies unless absolutely necessary.
Ensure generated code compiles without missing imports.
Keep functions small and modular.
Maintain compatibility with offline-first design.
Follow existing naming conventions.

End Goal

The final system should support three main applications.

Patient App
Doctor App
Admin Panel

The platform must be optimized for low bandwidth environments, simple smartphones, and rural healthcare accessibility.
