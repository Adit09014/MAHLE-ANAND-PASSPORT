-- ============================================================================
-- MAHLE ANAND GROWTH PASSPORT - COMPLETE DATABASE SETUP & SEED SCRIPT (SSMS)
-- Database: GrowthPortal
-- Compatible with: Microsoft SQL Server 2017, 2019, 2022 / Azure SQL
-- Target Tool: SQL Server Management Studio (SSMS)
-- ============================================================================
-- Instructions:
-- 1. Open SQL Server Management Studio (SSMS).
-- 2. Connect to your SQL Server instance.
-- 3. Open this script and press Execute (F5).
-- 4. The script will create the GrowthPortal database, all tables, constraints,
--    indexes, master roles, plants, departments, training catalog, activities,
--    and default administrator / leader / employee credentials.
-- ============================================================================

SET NOCOUNT ON;
GO

-- ============================================================================
-- 1. DATABASE CREATION
-- ============================================================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'GrowthPortal')
BEGIN
    PRINT 'Creating database [GrowthPortal]...';
    CREATE DATABASE [GrowthPortal];
END
GO

USE [GrowthPortal];
GO

-- ============================================================================
-- 2. DDL: CORE TABLES CREATION
-- ============================================================================

-- 2.1 Plant / State Unit Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Unit')
BEGIN
    CREATE TABLE [dbo].[Unit] (
        [id] NVARCHAR(1000) NOT NULL,
        [name] NVARCHAR(1000) NOT NULL,
        [code] NVARCHAR(50) NULL,
        [isActive] BIT NOT NULL CONSTRAINT [Unit_isActive_df] DEFAULT 1,
        [createdAt] DATETIME2 NOT NULL CONSTRAINT [Unit_createdAt_df] DEFAULT SYSUTCDATETIME(),
        CONSTRAINT [Unit_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [Unit_name_key] UNIQUE NONCLUSTERED ([name])
    );
    PRINT 'Created table [Unit].';
END
GO

-- 2.2 Department Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Department')
BEGIN
    CREATE TABLE [dbo].[Department] (
        [id] NVARCHAR(1000) NOT NULL,
        [name] NVARCHAR(1000) NOT NULL,
        [unitId] NVARCHAR(1000) NOT NULL,
        CONSTRAINT [Department_pkey] PRIMARY KEY CLUSTERED ([id])
    );
    PRINT 'Created table [Department].';
END
GO

-- 2.3 System Roles Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Role')
BEGIN
    CREATE TABLE [dbo].[Role] (
        [id] NVARCHAR(1000) NOT NULL,
        [name] NVARCHAR(1000) NOT NULL,
        CONSTRAINT [Role_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [Role_name_key] UNIQUE NONCLUSTERED ([name])
    );
    PRINT 'Created table [Role].';
END
GO

-- 2.4 Assessment Cycles Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentCycle')
BEGIN
    CREATE TABLE [dbo].[AssessmentCycle] (
        [id] NVARCHAR(1000) NOT NULL,
        [month] NVARCHAR(20) NOT NULL,
        [title] NVARCHAR(100) NOT NULL,
        [status] NVARCHAR(50) NOT NULL CONSTRAINT [AssessmentCycle_status_df] DEFAULT 'open',
        [startDate] DATETIME2 NULL,
        [endDate] DATETIME2 NULL,
        [createdAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentCycle_createdAt_df] DEFAULT SYSUTCDATETIME(),
        CONSTRAINT [AssessmentCycle_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [AssessmentCycle_month_key] UNIQUE NONCLUSTERED ([month])
    );
    PRINT 'Created table [AssessmentCycle].';
END
GO

-- 2.5 User Master Table (Employees, Leaders, Admins)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'User')
BEGIN
    CREATE TABLE [dbo].[User] (
        [id] NVARCHAR(1000) NOT NULL,
        [empCode] NVARCHAR(1000) NOT NULL,
        [name] NVARCHAR(1000) NULL,
        [passwordHash] NVARCHAR(1000) NULL,
        [isActive] BIT NOT NULL CONSTRAINT [User_isActive_df] DEFAULT 1,
        [createdAt] DATETIME2 NOT NULL CONSTRAINT [User_createdAt_df] DEFAULT SYSUTCDATETIME(),
        [updatedAt] DATETIME2 NOT NULL CONSTRAINT [User_updatedAt_df] DEFAULT SYSUTCDATETIME(),
        [roleId] NVARCHAR(1000) NULL,
        [unitId] NVARCHAR(1000) NULL,
        [departmentId] NVARCHAR(1000) NULL,
        [tlId] NVARCHAR(1000) NULL,
        [sglId] NVARCHAR(1000) NULL,
        -- Extended Company Dataset Fields (auto-populates About Myself Sheet 01)
        [fatherName] NVARCHAR(1000) NULL,
        [mobile] NVARCHAR(50) NULL,
        [email] NVARCHAR(255) NULL,
        [joiningDate] NVARCHAR(50) NULL,
        [dob] NVARCHAR(50) NULL,
        [designation] NVARCHAR(255) NULL,
        [groupJoiningDate] NVARCHAR(50) NULL,
        [gradeCode] NVARCHAR(50) NULL,
        CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [User_empCode_key] UNIQUE NONCLUSTERED ([empCode])
    );
    PRINT 'Created table [User].';
END
GO

-- 2.6 Monthly Submission Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MonthlySubmission')
BEGIN
    CREATE TABLE [dbo].[MonthlySubmission] (
        [id] NVARCHAR(1000) NOT NULL,
        [empId] NVARCHAR(1000) NOT NULL,
        [month] NVARCHAR(1000) NOT NULL,
        [status] NVARCHAR(1000) NOT NULL CONSTRAINT [MonthlySubmission_status_df] DEFAULT 'pending',
        [selfScore] DECIMAL(4,2) NULL,
        [submittedAt] DATETIME2 NULL,
        [createdAt] DATETIME2 NOT NULL CONSTRAINT [MonthlySubmission_createdAt_df] DEFAULT SYSUTCDATETIME(),
        [updatedAt] DATETIME2 NOT NULL CONSTRAINT [MonthlySubmission_updatedAt_df] DEFAULT SYSUTCDATETIME(),
        CONSTRAINT [MonthlySubmission_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [MonthlySubmission_empId_month_key] UNIQUE NONCLUSTERED ([empId], [month])
    );
    PRINT 'Created table [MonthlySubmission].';
END
GO

-- 2.7 Assessment Reviews Table (1.0 to 10.0 Scale + 7 Metrics Marking Scheme)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentReview')
BEGIN
    CREATE TABLE [dbo].[AssessmentReview] (
        [id] NVARCHAR(1000) NOT NULL,
        [submissionId] NVARCHAR(1000) NOT NULL,
        [evaluatorId] NVARCHAR(1000) NOT NULL,
        [score] DECIMAL(4,2) NOT NULL, -- Scale 1.0 to 10.0 (Min 6.00 for 60%)
        [ratingGrade] NVARCHAR(50) NULL,
        [criteriaScores] VARCHAR(MAX) NULL, -- JSON formatted 7 metrics
        [tlComments] NVARCHAR(MAX) NULL,
        [sglRemarks] NVARCHAR(MAX) NULL,
        [status] NVARCHAR(50) NOT NULL CONSTRAINT [AssessmentReview_status_df] DEFAULT 'completed',
        [reviewedAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentReview_reviewedAt_df] DEFAULT SYSUTCDATETIME(),
        [updatedAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentReview_updatedAt_df] DEFAULT SYSUTCDATETIME(),
        CONSTRAINT [AssessmentReview_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [AssessmentReview_submissionId_key] UNIQUE NONCLUSTERED ([submissionId])
    );
    PRINT 'Created table [AssessmentReview].';
END
GO

-- 2.8 Sheet Data Table (Dynamic Passport Sections Storage)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'SheetData')
BEGIN
    CREATE TABLE [dbo].[SheetData] (
        [id] NVARCHAR(1000) NOT NULL,
        [empId] NVARCHAR(1000) NOT NULL,
        [sheetId] NVARCHAR(1000) NOT NULL,
        [data] VARCHAR(MAX) NOT NULL,
        [updatedAt] DATETIME2 NOT NULL CONSTRAINT [SheetData_updatedAt_df] DEFAULT SYSUTCDATETIME(),
        CONSTRAINT [SheetData_pkey] PRIMARY KEY CLUSTERED ([id]),
        CONSTRAINT [SheetData_empId_sheetId_key] UNIQUE NONCLUSTERED ([empId], [sheetId])
    );
    PRINT 'Created table [SheetData].';
END
GO

-- 2.9 Master Item Catalog Table (Admin Training Matrix & Plant Activities)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MasterItem')
BEGIN
    CREATE TABLE [dbo].[MasterItem] (
        [id] NVARCHAR(1000) NOT NULL,
        [type] NVARCHAR(50) NOT NULL, -- 'training' | 'activity'
        [title] NVARCHAR(500) NOT NULL,
        [category] NVARCHAR(100) NULL,
        [sortOrder] INT NOT NULL CONSTRAINT [MasterItem_sortOrder_df] DEFAULT 0,
        [isActive] BIT NOT NULL CONSTRAINT [MasterItem_isActive_df] DEFAULT 1,
        [createdAt] DATETIME2 NOT NULL CONSTRAINT [MasterItem_createdAt_df] DEFAULT SYSUTCDATETIME(),
        [updatedAt] DATETIME2 NOT NULL CONSTRAINT [MasterItem_updatedAt_df] DEFAULT SYSUTCDATETIME(),
        CONSTRAINT [MasterItem_pkey] PRIMARY KEY CLUSTERED ([id])
    );
    PRINT 'Created table [MasterItem].';
END
GO

-- ============================================================================
-- 3. FOREIGN KEY CONSTRAINTS
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'Department_unitId_fkey')
    ALTER TABLE [dbo].[Department] ADD CONSTRAINT [Department_unitId_fkey] 
    FOREIGN KEY ([unitId]) REFERENCES [dbo].[Unit]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_roleId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_roleId_fkey] 
    FOREIGN KEY ([roleId]) REFERENCES [dbo].[Role]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_unitId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_unitId_fkey] 
    FOREIGN KEY ([unitId]) REFERENCES [dbo].[Unit]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_departmentId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_departmentId_fkey] 
    FOREIGN KEY ([departmentId]) REFERENCES [dbo].[Department]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_tlId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_tlId_fkey] 
    FOREIGN KEY ([tlId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_sglId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_sglId_fkey] 
    FOREIGN KEY ([sglId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'MonthlySubmission_empId_fkey')
    ALTER TABLE [dbo].[MonthlySubmission] ADD CONSTRAINT [MonthlySubmission_empId_fkey] 
    FOREIGN KEY ([empId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'AssessmentReview_submissionId_fkey')
    ALTER TABLE [dbo].[AssessmentReview] ADD CONSTRAINT [AssessmentReview_submissionId_fkey] 
    FOREIGN KEY ([submissionId]) REFERENCES [dbo].[MonthlySubmission]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'AssessmentReview_evaluatorId_fkey')
    ALTER TABLE [dbo].[AssessmentReview] ADD CONSTRAINT [AssessmentReview_evaluatorId_fkey] 
    FOREIGN KEY ([evaluatorId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'SheetData_empId_fkey')
    ALTER TABLE [dbo].[SheetData] ADD CONSTRAINT [SheetData_empId_fkey] 
    FOREIGN KEY ([empId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;
GO

-- ============================================================================
-- 4. PERFORMANCE INDEXES
-- ============================================================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_User_roleId')
    CREATE NONCLUSTERED INDEX [IX_User_roleId] ON [dbo].[User]([roleId]);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_User_unitId')
    CREATE NONCLUSTERED INDEX [IX_User_unitId] ON [dbo].[User]([unitId]);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_User_tlId')
    CREATE NONCLUSTERED INDEX [IX_User_tlId] ON [dbo].[User]([tlId]);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_User_sglId')
    CREATE NONCLUSTERED INDEX [IX_User_sglId] ON [dbo].[User]([sglId]);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = N'IX_MasterItem_type_isActive')
    CREATE NONCLUSTERED INDEX [IX_MasterItem_type_isActive] ON [dbo].[MasterItem]([type], [isActive]);
GO

-- ============================================================================
-- 5. MASTER SEED DATA (ROLES, UNITS, DEPARTMENTS, CATALOG & SEED ACCOUNTS)
-- ============================================================================

BEGIN TRY
BEGIN TRANSACTION;

-- 5.1 System Roles
IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Super Admin')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Super Admin');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'HR Head')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR Head');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Unit Admin')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Unit Admin');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Senior Group Leader (SGL)');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Team Leader (TL)');

IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Employee')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Employee');

-- 5.2 Plant / State Units (Primary Manufacturing Facilities)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Gurugram')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Gurugram', 'GGN', 1);

IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Parwanoo')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Parwanoo', 'PRW', 1);

IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Pune')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Pune', 'PUN', 1);

-- 5.3 Plant Departments
DECLARE @u1Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Gurugram');
DECLARE @u2Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Parwanoo');
DECLARE @u3Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Pune');

-- Gurugram Departments
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u1Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u1Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Assembly Line', @u1Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @u1Id);

-- Parwanoo Departments
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u2Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u2Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @u2Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @u2Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u2Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u2Id);

-- Pune Departments
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u3Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u3Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @u3Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @u3Id);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u3Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u3Id);

-- 5.4 Active Assessment Cycles
IF NOT EXISTS (SELECT 1 FROM [dbo].[AssessmentCycle] WHERE [month] = '2026-10')
    INSERT INTO [dbo].[AssessmentCycle] ([id], [month], [title], [status], [startDate], [endDate])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), '2026-10', 'October 2026 Assessment Cycle', 'open', '2026-10-01', '2026-10-31');

IF NOT EXISTS (SELECT 1 FROM [dbo].[AssessmentCycle] WHERE [month] = '2026-11')
    INSERT INTO [dbo].[AssessmentCycle] ([id], [month], [title], [status], [startDate], [endDate])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), '2026-11', 'November 2026 Assessment Cycle', 'open', '2026-11-01', '2026-11-30');

-- 5.5 Master Catalog: Standard Training Matrix Programs (Sheet 05)
DECLARE @trainings TABLE (title NVARCHAR(500), category NVARCHAR(100), sortOrder INT);
INSERT INTO @trainings VALUES 
-- 1. Generic Training Programme
('Advance Product Knowledge', 'Generic Training Programme', 1),
('NC Handling', 'Generic Training Programme', 2),
('BBS', 'Generic Training Programme', 3),
('SPC', 'Generic Training Programme', 4),
('7QC Tools', 'Generic Training Programme', 5),
('Poka-Yoka', 'Generic Training Programme', 6),
('Control Plan', 'Generic Training Programme', 7),
('8D Analysis', 'Generic Training Programme', 8),
('MSA', 'Generic Training Programme', 9),
('Awareness of Process', 'Generic Training Programme', 10),
('Metrology', 'Generic Training Programme', 11),
('AM', 'Generic Training Programme', 12),
('PFMEA', 'Generic Training Programme', 13),
('Production MIS', 'Generic Training Programme', 14),
('Good Communication Skill', 'Generic Training Programme', 15),
('SAP Knowledge', 'Generic Training Programme', 16),
('Soft Skill / BBQ Training', 'Generic Training Programme', 17),
-- 2. Mandatory Training Plan
('Induction', 'Mandatory Training Plan', 18),
('CST(Creative Skill Training)', 'Mandatory Training Plan', 19),
('ASTEr(Advanced Skill Training for Engineers)', 'Mandatory Training Plan', 20),
('DISHA', 'Mandatory Training Plan', 21),
-- 3. STOE Training Programs
('Safety', 'STOE Training Programs', 22),
('Quality', 'STOE Training Programs', 23),
('SCM', 'STOE Training Programs', 24),
('Design', 'STOE Training Programs', 25),
('Production', 'STOE Training Programs', 26),
('Maintenance', 'STOE Training Programs', 27),
('After Market', 'STOE Training Programs', 28),
('Tooling', 'STOE Training Programs', 29),
('PTT', 'STOE Training Programs', 30),
-- 4. Process Mastery Certification Programs
('Water Leak Testing', 'Process Mastery Certification Programs', 31),
('ALT -Oil Filter', 'Process Mastery Certification Programs', 32),
('Vibration Welding', 'Process Mastery Certification Programs', 33),
('ALT-Air Filter/EP', 'Process Mastery Certification Programs', 34),
('Seaming', 'Process Mastery Certification Programs', 35),
('Clipping', 'Process Mastery Certification Programs', 36),
('Paper Pleating', 'Process Mastery Certification Programs', 37),
('Heat Nut', 'Process Mastery Certification Programs', 38),
('Dispencing & Dipping', 'Process Mastery Certification Programs', 39),
('Injection Moulding', 'Process Mastery Certification Programs', 40),
('PU - Dosing', 'Process Mastery Certification Programs', 41),
('Coilling', 'Process Mastery Certification Programs', 42),
('Stamping', 'Process Mastery Certification Programs', 43),
('Ultrasonic', 'Process Mastery Certification Programs', 44);

INSERT INTO [dbo].[MasterItem] ([id], [type], [title], [category], [sortOrder], [isActive])
SELECT CAST(NEWID() AS NVARCHAR(1000)), 'training', t.title, t.category, t.sortOrder, 1
FROM @trainings t
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[MasterItem] WHERE [type] = 'training' AND [title] = t.title);

-- 5.6 Master Catalog: Standard Plant Activities (Sheet 06)
DECLARE @activities TABLE (title NVARCHAR(500), sortOrder INT);
INSERT INTO @activities VALUES 
('Participation in Committees', 1), ('Sports', 2), ('First Aid', 3),
('Safety Committee', 4), ('Canteen Committee', 5), ('Cultural Activities', 6),
('Participation in CI-meet', 7);

INSERT INTO [dbo].[MasterItem] ([id], [type], [title], [sortOrder], [isActive])
SELECT CAST(NEWID() AS NVARCHAR(1000)), 'activity', a.title, a.sortOrder, 1
FROM @activities a
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[MasterItem] WHERE [type] = 'activity' AND [title] = a.title);

-- 5.7 Seed Users For All 6 Roles (Bcrypt hash for password: 'Mahle@123')
DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';

DECLARE @roleSuperAdmin NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Super Admin');
DECLARE @roleHrHead     NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'HR Head');
DECLARE @roleUnitAdmin  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Unit Admin');
DECLARE @roleSGL        NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');
DECLARE @roleTL         NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');
DECLARE @roleEmployee   NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Employee');

DECLARE @u1DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u1Id);
DECLARE @u2DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u2Id);

-- 1. Super Admin Account (Global Cross-Plant Access)
-- Login ID: ADMIN01 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'ADMIN01')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'ADMIN01', 'Super Admin Central', @defaultHash, 1, @roleSuperAdmin, NULL, NULL, 'System Administrator');

-- 2. Corporate HR Head Account (Global Multi-Unit Analytics)
-- Login ID: HR001 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'HR001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR001', 'Pooja Nair (HR Head)', @defaultHash, 1, @roleHrHead, NULL, NULL, 'Head of Human Resources');

-- 3. Plant Unit Admin Accounts
-- Login ID: UA1001 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'UA1001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA1001', 'Ankit Mehra (Admin Gurugram)', @defaultHash, 1, @roleUnitAdmin, @u1Id, @u1DeptId, 'Plant Unit Administrator');

-- Login ID: UA2001 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'UA2001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA2001', 'Sunil Deshmukh (Admin Unit 2)', @defaultHash, 1, @roleUnitAdmin, @u2Id, @u2DeptId, 'Plant Unit Administrator');

-- 4. Senior Group Leader (SGL) Accounts
-- Login ID: K02001 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'K02001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02001', 'Vikram Verma (SGL)', @defaultHash, 1, @roleSGL, @u1Id, @u1DeptId, 'Senior Group Leader');

-- Login ID: K02002 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'K02002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02002', 'Anil Gupta (SGL Unit 2)', @defaultHash, 1, @roleSGL, @u2Id, @u2DeptId, 'Senior Group Leader');

-- 5. Team Leader (TL) Accounts (Evaluates 1-10 Scale & 7 Metrics)
-- Login ID: K01001 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'K01001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01001', 'Rajesh Sharma (TL)', @defaultHash, 1, @roleTL, @u1Id, @u1DeptId, 'Team Leader');

-- Login ID: K01002 / Passcode: Mahle@123
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'K01002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [designation])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01002', 'Manoj Singh (TL Unit 2)', @defaultHash, 1, @roleTL, @u2Id, @u2DeptId, 'Team Leader');

-- Hierarchical Foreign Keys
DECLARE @u1TlGuid  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01001');
DECLARE @u1SglGuid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02001');
DECLARE @u2TlGuid  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01002');
DECLARE @u2SglGuid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02002');

-- 6. Employees With Complete Company Master Profile Fields
-- Login ID: KA1042 / Password: Password@123 (or Mahle@123)
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'KA1042')
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [tlId], [sglId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    )
    VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), 'KA1042', 'Amit Kumar', @defaultHash, 1, @roleEmployee, @u1Id, @u1DeptId, @u1TlGuid, @u1SglGuid,
        'Shri Ram Kumar', '9811234567', 'amit.kumar@mahle.com', '2023-04-10', '1996-05-14', 'Line Technician', '2021-08-01', 'GR-3'
    );

-- Login ID: NTK1042 / Password: Password@123 (or Mahle@123)
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'NTK1042')
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [tlId], [sglId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    )
    VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), 'NTK1042', 'Suresh Patel', @defaultHash, 1, @roleEmployee, @u1Id, @u1DeptId, @u1TlGuid, @u1SglGuid,
        'Shri Harish Patel', '9822345678', 'suresh.patel@mahle.com', '2024-01-15', '1998-11-20', 'Assembly Operator', '2024-01-15', 'GR-2'
    );

-- Login ID: KA2042 (Unit 2)
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = 'KA2042')
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [roleId], [unitId], [departmentId], [tlId], [sglId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    )
    VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), 'KA2042', 'Rahul Sharma', @defaultHash, 1, @roleEmployee, @u2Id, @u2DeptId, @u2TlGuid, @u2SglGuid,
        'Shri Ramesh Sharma', '9833456789', 'rahul.sharma@mahle.com', '2023-06-01', '1997-09-18', 'Senior Operator', '2022-03-10', 'GR-4'
    );

-- 5.8 Initial Sample Assessment Submissions & 7-Metric Evaluations (October 2026)
DECLARE @ka1Guid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA1042');
DECLARE @sub1Id  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @ka1Guid AND [month] = '2026-10');

IF @sub1Id IS NULL
BEGIN
    SET @sub1Id = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt])
    VALUES (@sub1Id, @ka1Guid, '2026-10', 'evaluated', 8.50, SYSUTCDATETIME());

    INSERT INTO [dbo].[AssessmentReview] (
        [id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status]
    )
    VALUES (
        CAST(NEWID() AS NVARCHAR(1000)),
        @sub1Id,
        @u1TlGuid,
        8.60, -- Scale 8.6 / 10.0 (86 / 100 Marks, >= 60% on all sections)
        'Grade A (Outstanding)',
        '{"Performance on the Job":18,"Attendance":9,"Work Performance":17,"Line Performance":17,"Recognition":8,"Documentation (Growth File)":8,"AHPS / LEAN Participation":9}',
        'Exceptional workstation discipline and strong adherence to 5S safety standards.',
        'Reviewed and verified by Senior Group Leader.',
        'completed'
    );
END

COMMIT TRANSACTION;
PRINT '============================================================================';
PRINT 'GrowthPortal Database setup & master seeds created successfully!';
PRINT '============================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Error occurred during database setup: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO
