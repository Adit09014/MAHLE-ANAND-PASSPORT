-- ========================================================
-- MAHLE Growth Passport - Multi-Unit Assessment Setup Script
-- Database: GrowthPortal
-- Phase 1: Multi-Unit Schema & 1-10 Scoring Architecture
-- ========================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'GrowthPortal')
BEGIN
    CREATE DATABASE [GrowthPortal];
END
GO

USE [GrowthPortal];
GO

-- 1. Create Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'dbo') 
    EXEC sp_executesql N'CREATE SCHEMA [dbo];';
GO

-- 2. Create Unit Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Unit')
CREATE TABLE [dbo].[Unit] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [code] NVARCHAR(50),
    [isActive] BIT NOT NULL CONSTRAINT [Unit_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Unit_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [Unit_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Unit_name_key] UNIQUE NONCLUSTERED ([name])
);
GO

-- Ensure 'code' column exists on Unit
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Unit]') AND name = 'code')
BEGIN
    ALTER TABLE [dbo].[Unit] ADD [code] NVARCHAR(50);
END
GO

-- 3. Create Department Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Department')
CREATE TABLE [dbo].[Department] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [unitId] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Department_pkey] PRIMARY KEY CLUSTERED ([id])
);
GO

-- 4. Create Role Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Role')
CREATE TABLE [dbo].[Role] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Role_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Role_name_key] UNIQUE NONCLUSTERED ([name])
);
GO

-- 5. Create AssessmentCycle Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentCycle')
CREATE TABLE [dbo].[AssessmentCycle] (
    [id] NVARCHAR(1000) NOT NULL,
    [month] NVARCHAR(20) NOT NULL,
    [title] NVARCHAR(100) NOT NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [AssessmentCycle_status_df] DEFAULT 'open',
    [startDate] DATETIME2,
    [endDate] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentCycle_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [AssessmentCycle_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [AssessmentCycle_month_key] UNIQUE NONCLUSTERED ([month])
);
GO

-- 6. Create User Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'User')
CREATE TABLE [dbo].[User] (
    [id] NVARCHAR(1000) NOT NULL,
    [empCode] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000),
    [passwordHash] NVARCHAR(1000),
    [isActive] BIT NOT NULL CONSTRAINT [User_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [User_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [roleId] NVARCHAR(1000),
    [unitId] NVARCHAR(1000),
    [departmentId] NVARCHAR(1000),
    [tlId] NVARCHAR(1000),
    [sglId] NVARCHAR(1000),
    CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [User_empCode_key] UNIQUE NONCLUSTERED ([empCode])
);
GO

-- 7. Create MonthlySubmission Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MonthlySubmission')
CREATE TABLE [dbo].[MonthlySubmission] (
    [id] NVARCHAR(1000) NOT NULL,
    [empId] NVARCHAR(1000) NOT NULL,
    [month] NVARCHAR(1000) NOT NULL,
    [status] NVARCHAR(1000) NOT NULL CONSTRAINT [MonthlySubmission_status_df] DEFAULT 'pending',
    [selfScore] DECIMAL(4,2),
    [submittedAt] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [MonthlySubmission_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [MonthlySubmission_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [MonthlySubmission_empId_month_key] UNIQUE NONCLUSTERED ([empId],[month])
);
GO

-- Ensure 'selfScore' column exists on MonthlySubmission
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[MonthlySubmission]') AND name = 'selfScore')
BEGIN
    ALTER TABLE [dbo].[MonthlySubmission] ADD [selfScore] DECIMAL(4,2);
END
GO

-- 8. Create AssessmentReview Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentReview')
CREATE TABLE [dbo].[AssessmentReview] (
    [id] NVARCHAR(1000) NOT NULL,
    [submissionId] NVARCHAR(1000) NOT NULL,
    [evaluatorId] NVARCHAR(1000) NOT NULL,
    [score] DECIMAL(4,2) NOT NULL, -- 1.00 to 10.00 scale
    [ratingGrade] NVARCHAR(50),
    [criteriaScores] VARCHAR(MAX),
    [tlComments] NVARCHAR(MAX),
    [sglRemarks] NVARCHAR(MAX),
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [AssessmentReview_status_df] DEFAULT 'completed',
    [reviewedAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentReview_reviewedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [AssessmentReview_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [AssessmentReview_submissionId_key] UNIQUE NONCLUSTERED ([submissionId])
);
GO

-- 9. Create SheetData Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'SheetData')
CREATE TABLE [dbo].[SheetData] (
    [id] NVARCHAR(1000) NOT NULL,
    [empId] NVARCHAR(1000) NOT NULL,
    [sheetId] NVARCHAR(1000) NOT NULL,
    [data] VARCHAR(MAX) NOT NULL,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [SheetData_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [SheetData_empId_sheetId_key] UNIQUE NONCLUSTERED ([empId],[sheetId])
);
GO

-- 10. Add Foreign Keys
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'Department_unitId_fkey')
ALTER TABLE [dbo].[Department] ADD CONSTRAINT [Department_unitId_fkey] FOREIGN KEY ([unitId]) REFERENCES [dbo].[Unit]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_roleId_fkey')
ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_roleId_fkey] FOREIGN KEY ([roleId]) REFERENCES [dbo].[Role]([id]) ON DELETE SET NULL ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_unitId_fkey')
ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_unitId_fkey] FOREIGN KEY ([unitId]) REFERENCES [dbo].[Unit]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_departmentId_fkey')
ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_departmentId_fkey] FOREIGN KEY ([departmentId]) REFERENCES [dbo].[Department]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_tlId_fkey')
ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_tlId_fkey] FOREIGN KEY ([tlId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_sglId_fkey')
ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_sglId_fkey] FOREIGN KEY ([sglId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'MonthlySubmission_empId_fkey')
ALTER TABLE [dbo].[MonthlySubmission] ADD CONSTRAINT [MonthlySubmission_empId_fkey] FOREIGN KEY ([empId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'AssessmentReview_submissionId_fkey')
ALTER TABLE [dbo].[AssessmentReview] ADD CONSTRAINT [AssessmentReview_submissionId_fkey] FOREIGN KEY ([submissionId]) REFERENCES [dbo].[MonthlySubmission]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'AssessmentReview_evaluatorId_fkey')
ALTER TABLE [dbo].[AssessmentReview] ADD CONSTRAINT [AssessmentReview_evaluatorId_fkey] FOREIGN KEY ([evaluatorId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'SheetData_empId_fkey')
ALTER TABLE [dbo].[SheetData] ADD CONSTRAINT [SheetData_empId_fkey] FOREIGN KEY ([empId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;
GO

-- 11. Master Roles & Seed Data
BEGIN TRY
BEGIN TRAN;

-- 11.1 Master Roles
IF NOT EXISTS (SELECT * FROM [dbo].[Role] WHERE [name] = 'Super Admin')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Super Admin');
IF NOT EXISTS (SELECT * FROM [dbo].[Role] WHERE [name] = 'HR Head')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR Head');
IF NOT EXISTS (SELECT * FROM [dbo].[Role] WHERE [name] = 'Unit Admin')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Unit Admin');
IF NOT EXISTS (SELECT * FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Senior Group Leader (SGL)');
IF NOT EXISTS (SELECT * FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Team Leader (TL)');
IF NOT EXISTS (SELECT * FROM [dbo].[Role] WHERE [name] = 'Shop Floor Employee')
    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Shop Floor Employee');

-- 11.2 Master Units (4 State Units)
IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'Gurugram')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Gurugram', 'GGN');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'GGN' WHERE [name] = 'Gurugram' AND [code] IS NULL;

IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'State Unit 2')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'State Unit 2', 'U02');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'U02' WHERE [name] = 'State Unit 2' AND [code] IS NULL;

IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'State Unit 3')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'State Unit 3', 'U03');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'U03' WHERE [name] = 'State Unit 3' AND [code] IS NULL;

IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'State Unit 4')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'State Unit 4', 'U04');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'U04' WHERE [name] = 'State Unit 4' AND [code] IS NULL;

-- 11.3 Departments
DECLARE @u1Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Gurugram');
DECLARE @u2Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 2');

IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u1Id);
IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u1Id);
IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @u1Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Assembly Line', @u1Id);

IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u2Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u2Id);
IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u2Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u2Id);

-- 11.4 Active Assessment Cycle
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentCycle] WHERE [month] = '2026-10')
BEGIN
    INSERT INTO [dbo].[AssessmentCycle] ([id], [month], [title], [status], [startDate], [endDate])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), '2026-10', 'October 2026 Assessment Cycle', 'open', '2026-10-01', '2026-10-31');
END

-- 11.5 Seed Users for all 6 Roles
DECLARE @superAdminRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Super Admin');
DECLARE @hrHeadRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'HR Head');
DECLARE @unitAdminRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Unit Admin');
DECLARE @sglRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');
DECLARE @tlRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');
DECLARE @empRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Shop Floor Employee');

DECLARE @u1DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u1Id);
DECLARE @u2DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u2Id);

-- Default Password hash for 'Mahle@123'
DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';

-- Super Admin
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'ADMIN01')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'ADMIN01', 'Super Admin Central', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @superAdminRoleId, NULL, NULL);

-- HR Head
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'HR001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR001', 'Pooja Nair (HR Head)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @hrHeadRoleId, NULL, NULL);

-- Unit Admins
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'UA1001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA1001', 'Ankit Mehra (Admin Gurugram)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @unitAdminRoleId, @u1Id, @u1DeptId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'UA2001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA2001', 'Sunil Deshmukh (Admin Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @unitAdminRoleId, @u2Id, @u2DeptId);

-- SGLs
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02001', 'Vikram Verma (SGL)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u1Id, @u1DeptId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02002', 'Anil Gupta (SGL Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u2Id, @u2DeptId);

-- TLs
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01001', 'Rajesh Sharma (TL)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u1Id, @u1DeptId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01002', 'Manoj Singh (TL Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u2Id, @u2DeptId);

-- Fetch Hierarchical IDs
DECLARE @u1TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01001');
DECLARE @u1SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02001');
DECLARE @u2TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01002');
DECLARE @u2SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02002');

-- Employees for Unit 1
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA1042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA1042', 'Amit Kumar', NULL, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptId, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK1042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK1042', 'Suresh Patel', NULL, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptId, @u1TlId, @u1SglId);

-- Employees for Unit 2
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA2042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA2042', 'Rahul Sharma', NULL, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u2Id, @u2DeptId, @u2TlId, @u2SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK2042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK2042', 'Deepak Verma', NULL, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u2Id, @u2DeptId, @u2TlId, @u2SglId);

-- Submissions & 1-10 TL Evaluations
DECLARE @ka1Guid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA1042');
DECLARE @ntk1Guid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'NTK1042');
DECLARE @ka2Guid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA2042');

-- Submission 1: KA1042 Evaluated (8.70 / 10)
DECLARE @sub1Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @ka1Guid AND [month] = '2026-10');
IF @sub1Id IS NULL
BEGIN
    SET @sub1Id = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@sub1Id, @ka1Guid, '2026-10', 'evaluated', 8.50, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END
ELSE
BEGIN
    UPDATE [dbo].[MonthlySubmission] SET [status] = 'evaluated', [selfScore] = 8.50 WHERE [id] = @sub1Id;
END

IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @sub1Id)
BEGIN
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (
        CAST(NEWID() AS NVARCHAR(1000)),
        @sub1Id,
        @u1TlId,
        8.70, -- 1-10 Scale
        'Grade A (Outstanding)',
        '{"safety":9.0,"quality":8.5,"5s":8.0,"productivity":9.0,"attendance":9.0}',
        'Exceptional 5S discipline and zero defects on the shop floor this cycle. Keep it up!',
        'Reviewed and verified by SGL.',
        'completed',
        SYSUTCDATETIME(),
        SYSUTCDATETIME()
    );
END

-- Submission 2: NTK1042 Submitted, awaiting review
IF NOT EXISTS (SELECT * FROM [dbo].[MonthlySubmission] WHERE [empId] = @ntk1Guid AND [month] = '2026-10')
BEGIN
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @ntk1Guid, '2026-10', 'submitted', 7.80, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END

-- Submission 3: KA2042 (Unit 2) Evaluated (9.20 / 10)
DECLARE @sub3Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @ka2Guid AND [month] = '2026-10');
IF @sub3Id IS NULL
BEGIN
    SET @sub3Id = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@sub3Id, @ka2Guid, '2026-10', 'evaluated', 9.00, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END

IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @sub3Id)
BEGIN
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (
        CAST(NEWID() AS NVARCHAR(1000)),
        @sub3Id,
        @u2TlId,
        9.20, -- 1-10 Scale
        'Grade A+ (Distinction)',
        '{"safety":9.5,"quality":9.0,"5s":9.0,"productivity":9.5,"attendance":9.0}',
        'Demonstrated stellar line leadership with zero downtime.',
        'Approved by SGL.',
        'completed',
        SYSUTCDATETIME(),
        SYSUTCDATETIME()
    );
END

COMMIT TRAN;
PRINT '========================================================================';
PRINT 'Phase 1 Database migration & Multi-Unit Seed Data completed successfully!';
PRINT '========================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO
