-- ============================================================================
-- MAHLE ANAND PASSPORT - ALL ADMIN TYPES SEED SCRIPT (SQL FORMAT)
-- Database: GrowthPortal
-- ============================================================================
-- Seeds all types of Admin, Supervisory, and Test Accounts:
--   1. Super Admin (Central - All Plants, Full Access)
--   2. HR Head (Central - Corporate HR, Multi-Unit Analytics & Compliance)
--   3. Unit Admin (Plant Level - Gurugram, Unit 2, Unit 3, Unit 4)
--   4. Senior Group Leader (SGL) (Plant/Department Evaluator)
--   5. Team Leader (TL) (Shop Floor 1-10 Evaluator)
--   6. Shop Floor Employees (Test Accounts with Submissions & Reviews)
-- ============================================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'GrowthPortal')
BEGIN
    CREATE DATABASE [GrowthPortal];
END
GO

USE [GrowthPortal];
GO

-- ============================================================================
-- 1. TABLE CREATION & SCHEMA MIGRATION DDL (TABLE MAKING FORMAT)
-- ============================================================================

-- 1.1 Unit Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Unit')
CREATE TABLE [dbo].[Unit] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [Unit_pkey] PRIMARY KEY CLUSTERED,
    [name] NVARCHAR(1000) NOT NULL CONSTRAINT [Unit_name_key] UNIQUE NONCLUSTERED,
    [code] NVARCHAR(50),
    [isActive] BIT NOT NULL CONSTRAINT [Unit_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [Unit_createdAt_df] DEFAULT CURRENT_TIMESTAMP
);
GO

-- Ensure columns exist on Unit
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Unit]') AND name = 'code')
    ALTER TABLE [dbo].[Unit] ADD [code] NVARCHAR(50);
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Unit]') AND name = 'isActive')
    ALTER TABLE [dbo].[Unit] ADD [isActive] BIT NOT NULL CONSTRAINT [Unit_isActive_df] DEFAULT 1;
GO
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Unit]') AND name = 'createdAt')
    ALTER TABLE [dbo].[Unit] ADD [createdAt] DATETIME2 NOT NULL CONSTRAINT [Unit_createdAt_df] DEFAULT CURRENT_TIMESTAMP;
GO

-- 1.2 Department Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Department')
CREATE TABLE [dbo].[Department] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [Department_pkey] PRIMARY KEY CLUSTERED,
    [name] NVARCHAR(1000) NOT NULL,
    [unitId] NVARCHAR(1000) NOT NULL
);
GO

-- 1.3 Role Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Role')
CREATE TABLE [dbo].[Role] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [Role_pkey] PRIMARY KEY CLUSTERED,
    [name] NVARCHAR(1000) NOT NULL CONSTRAINT [Role_name_key] UNIQUE NONCLUSTERED
);
GO

-- 1.4 AssessmentCycle Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentCycle')
CREATE TABLE [dbo].[AssessmentCycle] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [AssessmentCycle_pkey] PRIMARY KEY CLUSTERED,
    [month] NVARCHAR(20) NOT NULL CONSTRAINT [AssessmentCycle_month_key] UNIQUE NONCLUSTERED,
    [title] NVARCHAR(100) NOT NULL,
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [AssessmentCycle_status_df] DEFAULT 'open',
    [startDate] DATETIME2,
    [endDate] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentCycle_createdAt_df] DEFAULT CURRENT_TIMESTAMP
);
GO

-- 1.5 User Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'User')
CREATE TABLE [dbo].[User] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED,
    [empCode] NVARCHAR(1000) NOT NULL CONSTRAINT [User_empCode_key] UNIQUE NONCLUSTERED,
    [name] NVARCHAR(1000),
    [passwordHash] NVARCHAR(1000),
    [isActive] BIT NOT NULL CONSTRAINT [User_isActive_df] DEFAULT 1,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [User_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    [roleId] NVARCHAR(1000),
    [unitId] NVARCHAR(1000),
    [departmentId] NVARCHAR(1000),
    [tlId] NVARCHAR(1000),
    [sglId] NVARCHAR(1000)
);
GO

-- 1.6 MonthlySubmission Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MonthlySubmission')
CREATE TABLE [dbo].[MonthlySubmission] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [MonthlySubmission_pkey] PRIMARY KEY CLUSTERED,
    [empId] NVARCHAR(1000) NOT NULL,
    [month] NVARCHAR(1000) NOT NULL,
    [status] NVARCHAR(1000) NOT NULL CONSTRAINT [MonthlySubmission_status_df] DEFAULT 'pending',
    [selfScore] DECIMAL(4,2),
    [submittedAt] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [MonthlySubmission_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [MonthlySubmission_empId_month_key] UNIQUE NONCLUSTERED ([empId],[month])
);
GO

-- Ensure selfScore column exists on MonthlySubmission (with GO separation)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[MonthlySubmission]') AND name = 'selfScore')
BEGIN
    ALTER TABLE [dbo].[MonthlySubmission] ADD [selfScore] DECIMAL(4,2);
END
GO

-- 1.7 AssessmentReview Table (1 - 10 Evaluation Scale)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentReview')
CREATE TABLE [dbo].[AssessmentReview] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [AssessmentReview_pkey] PRIMARY KEY CLUSTERED,
    [submissionId] NVARCHAR(1000) NOT NULL CONSTRAINT [AssessmentReview_submissionId_key] UNIQUE NONCLUSTERED,
    [evaluatorId] NVARCHAR(1000) NOT NULL,
    [score] DECIMAL(4,2) NOT NULL,
    [ratingGrade] NVARCHAR(50),
    [criteriaScores] VARCHAR(MAX),
    [tlComments] NVARCHAR(MAX),
    [sglRemarks] NVARCHAR(MAX),
    [status] NVARCHAR(50) NOT NULL CONSTRAINT [AssessmentReview_status_df] DEFAULT 'completed',
    [reviewedAt] DATETIME2 NOT NULL CONSTRAINT [AssessmentReview_reviewedAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL
);
GO

-- 1.8 SheetData Table (10 Growth Passport Sections)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'SheetData')
CREATE TABLE [dbo].[SheetData] (
    [id] NVARCHAR(1000) NOT NULL CONSTRAINT [SheetData_pkey] PRIMARY KEY CLUSTERED,
    [empId] NVARCHAR(1000) NOT NULL,
    [sheetId] NVARCHAR(1000) NOT NULL,
    [data] VARCHAR(MAX) NOT NULL,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [SheetData_empId_sheetId_key] UNIQUE NONCLUSTERED ([empId],[sheetId])
);
GO

-- 1.9 Foreign Keys (Safely Created)
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'Department_unitId_fkey')
    ALTER TABLE [dbo].[Department] ADD CONSTRAINT [Department_unitId_fkey] FOREIGN KEY ([unitId]) REFERENCES [dbo].[Unit]([id]) ON DELETE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_roleId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_roleId_fkey] FOREIGN KEY ([roleId]) REFERENCES [dbo].[Role]([id]) ON DELETE SET NULL;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_unitId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_unitId_fkey] FOREIGN KEY ([unitId]) REFERENCES [dbo].[Unit]([id]) ON DELETE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'User_departmentId_fkey')
    ALTER TABLE [dbo].[User] ADD CONSTRAINT [User_departmentId_fkey] FOREIGN KEY ([departmentId]) REFERENCES [dbo].[Department]([id]) ON DELETE NO ACTION;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'MonthlySubmission_empId_fkey')
    ALTER TABLE [dbo].[MonthlySubmission] ADD CONSTRAINT [MonthlySubmission_empId_fkey] FOREIGN KEY ([empId]) REFERENCES [dbo].[User]([id]) ON DELETE CASCADE;

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'AssessmentReview_submissionId_fkey')
    ALTER TABLE [dbo].[AssessmentReview] ADD CONSTRAINT [AssessmentReview_submissionId_fkey] FOREIGN KEY ([submissionId]) REFERENCES [dbo].[MonthlySubmission]([id]) ON DELETE CASCADE;
GO

-- ============================================================================
-- 2. SEED TRANSACTION: ALL TYPES OF ADMIN & SUPERVISORY ACCOUNTS
-- ============================================================================

BEGIN TRY
BEGIN TRAN;

-- 2.1 Master Roles
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

-- 2.2 Master Units (4 State Units)
IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'Gurugram')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Gurugram', 'GGN');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'GGN' WHERE [name] = 'Gurugram';

IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'State Unit 2')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'State Unit 2', 'U02');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'U02' WHERE [name] = 'State Unit 2';

IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'State Unit 3')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'State Unit 3', 'U03');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'U03' WHERE [name] = 'State Unit 3';

IF NOT EXISTS (SELECT * FROM [dbo].[Unit] WHERE [name] = 'State Unit 4')
    INSERT INTO [dbo].[Unit] ([id], [name], [code]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'State Unit 4', 'U04');
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'U04' WHERE [name] = 'State Unit 4';

DECLARE @u1Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Gurugram');
DECLARE @u2Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 2');
DECLARE @u3Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 3');
DECLARE @u4Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 4');

-- 2.3 Departments
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

IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u3Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u3Id);
IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u3Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u3Id);

IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u4Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @u4Id);
IF NOT EXISTS (SELECT * FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u4Id)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @u4Id);

DECLARE @u1DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u1Id);
DECLARE @u2DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u2Id);
DECLARE @u3DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u3Id);
DECLARE @u4DeptId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u4Id);

-- 2.4 Active Assessment Cycle
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentCycle] WHERE [month] = '2026-10')
    INSERT INTO [dbo].[AssessmentCycle] ([id], [month], [title], [status], [startDate], [endDate])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), '2026-10', 'October 2026 Assessment Cycle', 'open', '2026-10-01', '2026-10-31');

-- Cache Role IDs
DECLARE @superAdminRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Super Admin');
DECLARE @hrHeadRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'HR Head');
DECLARE @unitAdminRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Unit Admin');
DECLARE @sglRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');
DECLARE @tlRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');
DECLARE @empRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Shop Floor Employee');

-- Verified Bcrypt Hash for 'Mahle@123'
DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';

-- 2.5 Seed Super Admins (Central / All Plants)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'ADMIN01')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'ADMIN01', 'Super Admin Central', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @superAdminRoleId, NULL, NULL);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @superAdminRoleId WHERE [empCode] = 'ADMIN01';

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'SA_TEST01')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'SA_TEST01', 'Vikramaditya (Super Admin QA)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @superAdminRoleId, NULL, NULL);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @superAdminRoleId WHERE [empCode] = 'SA_TEST01';

-- 2.6 Seed HR Heads (Corporate HR Oversight)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'HR001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR001', 'Pooja Nair (HR Head Central)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @hrHeadRoleId, NULL, NULL);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @hrHeadRoleId WHERE [empCode] = 'HR001';

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'HR_TEST01')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR_TEST01', 'Ananya Roy (HR Auditor Test)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @hrHeadRoleId, NULL, NULL);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @hrHeadRoleId WHERE [empCode] = 'HR_TEST01';

-- 2.7 Seed Unit Admins (Plant Scoped)
-- Gurugram (GGN)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'UA1001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA1001', 'Ankit Mehra (Admin Gurugram)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @unitAdminRoleId, @u1Id, @u1DeptId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @unitAdminRoleId, [unitId] = @u1Id WHERE [empCode] = 'UA1001';

-- State Unit 2 (U02)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'UA2001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA2001', 'Sunil Deshmukh (Admin Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @unitAdminRoleId, @u2Id, @u2DeptId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @unitAdminRoleId, [unitId] = @u2Id WHERE [empCode] = 'UA2001';

-- State Unit 3 (U03)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'UA3001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA3001', 'Ramesh Iyer (Admin Unit 3)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @unitAdminRoleId, @u3Id, @u3DeptId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @unitAdminRoleId, [unitId] = @u3Id WHERE [empCode] = 'UA3001';

-- State Unit 4 (U04)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'UA4001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'UA4001', 'Vikram Rawat (Admin Unit 4)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @unitAdminRoleId, @u4Id, @u4DeptId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @unitAdminRoleId, [unitId] = @u4Id WHERE [empCode] = 'UA4001';

-- 2.8 Seed SGLs (Senior Group Leaders)
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02001', 'Vikram Verma (SGL Gurugram)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u1Id, @u1DeptId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @sglRoleId, [unitId] = @u1Id WHERE [empCode] = 'K02001';

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02002', 'Anil Gupta (SGL Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u2Id, @u2DeptId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @sglRoleId, [unitId] = @u2Id WHERE [empCode] = 'K02002';

-- 2.9 Seed TLs (Team Leaders)
DECLARE @u1SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02001');
DECLARE @u2SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02002');

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01001', 'Rajesh Sharma (TL Gurugram)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u1Id, @u1DeptId, @u1SglId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @tlRoleId, [unitId] = @u1Id, [sglId] = @u1SglId WHERE [empCode] = 'K01001';

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01002', 'Manoj Singh (TL Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u2Id, @u2DeptId, @u2SglId);
ELSE
    UPDATE [dbo].[User] SET [passwordHash] = @defaultHash, [roleId] = @tlRoleId, [unitId] = @u2Id, [sglId] = @u2SglId WHERE [empCode] = 'K01002';

-- 2.10 Seed Test Employees
DECLARE @u1TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01001');
DECLARE @u2TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01002');

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA1042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA1042', 'Amit Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptId, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK1042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK1042', 'Suresh Patel', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptId, @u1TlId, @u1SglId);

-- 2.11 Seed Monthly Assessment Submissions & 1-10 Scale Evaluations
DECLARE @ka1Guid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA1042');
DECLARE @ntk1Guid NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'NTK1042');

-- KA1042: Evaluated (Score 8.70 / 10.0, Grade A Outstanding)
DECLARE @sub1Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @ka1Guid AND [month] = '2026-10');
IF @sub1Id IS NULL
BEGIN
    SET @sub1Id = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@sub1Id, @ka1Guid, '2026-10', 'evaluated', 8.50, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END

IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @sub1Id)
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @sub1Id, @u1TlId, 8.70, 'Grade A (Outstanding)', '{"safety":9.0,"quality":8.5,"5s":8.5,"productivity":9.0,"attendance":9.0}', 'Exceptional 5S discipline and zero defects on the shop floor this cycle.', 'Reviewed and verified by SGL.', 'completed', SYSUTCDATETIME(), SYSUTCDATETIME());

-- NTK1042: Submitted, awaiting review
IF NOT EXISTS (SELECT * FROM [dbo].[MonthlySubmission] WHERE [empId] = @ntk1Guid AND [month] = '2026-10')
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @ntk1Guid, '2026-10', 'submitted', 7.80, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());

COMMIT TRAN;
PRINT '========================================================================';
PRINT 'All types of Admin, Supervisory, and Test Accounts seeded successfully!';
PRINT '========================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO

-- ============================================================================
-- 3. FORMATTED OUTPUT TABLES (TABLE MAKING FORMAT)
-- ============================================================================

-- Table 1: All Admin & Supervisory Accounts
SELECT 
    r.name AS [Admin Role Type],
    u.empCode AS [Login ID / Emp Code],
    u.name AS [Full Name],
    COALESCE(un.name, 'Central / All Plants') AS [Assigned Plant Unit],
    COALESCE(un.code, 'ALL') AS [Unit Code],
    COALESCE(d.name, 'General Management') AS [Department],
    'Mahle@123' AS [Password],
    CASE 
        WHEN r.name = 'Super Admin' THEN 'Full Central Cross-Plant Access & User Management'
        WHEN r.name = 'HR Head' THEN 'Corporate HR Oversight & Multi-Unit Analytics'
        WHEN r.name = 'Unit Admin' THEN 'Scoped Strictly to Assigned Plant Operations'
        WHEN r.name = 'Senior Group Leader (SGL)' THEN 'Audits TL Evaluations & Reviews Team Submissions'
        WHEN r.name = 'Team Leader (TL)' THEN 'Evaluates Assigned Shop Floor Operators (1-10 Scale)'
        ELSE 'Shop Floor Operations'
    END AS [Authority Scope]
FROM [GrowthPortal].[dbo].[User] u
INNER JOIN [GrowthPortal].[dbo].[Role] r ON u.roleId = r.id
LEFT JOIN [GrowthPortal].[dbo].[Unit] un ON u.unitId = un.id
LEFT JOIN [GrowthPortal].[dbo].[Department] d ON u.departmentId = d.id
WHERE r.name IN ('Super Admin', 'HR Head', 'Unit Admin', 'Senior Group Leader (SGL)', 'Team Leader (TL)')
ORDER BY 
    CASE r.name
        WHEN 'Super Admin' THEN 1
        WHEN 'HR Head' THEN 2
        WHEN 'Unit Admin' THEN 3
        WHEN 'Senior Group Leader (SGL)' THEN 4
        WHEN 'Team Leader (TL)' THEN 5
        ELSE 6
    END,
    un.name, u.empCode;
GO

-- Table 2: Shop Floor Test Records & Evaluation Status
SELECT 
    u.empCode AS [Emp Code],
    u.name AS [Employee Name],
    un.name AS [Plant Unit],
    d.name AS [Department],
    tl.name AS [Assigned Team Leader],
    ISNULL(m.status, 'pending') AS [Oct 2026 Status],
    m.selfScore AS [Self Score],
    ar.score AS [1-10 TL Score],
    ar.ratingGrade AS [Rating Grade],
    'Mahle@123 / Emp Code' AS [Password]
FROM [GrowthPortal].[dbo].[User] u
INNER JOIN [GrowthPortal].[dbo].[Role] r ON u.roleId = r.id AND r.name = 'Shop Floor Employee'
LEFT JOIN [GrowthPortal].[dbo].[Unit] un ON u.unitId = un.id
LEFT JOIN [GrowthPortal].[dbo].[Department] d ON u.departmentId = d.id
LEFT JOIN [GrowthPortal].[dbo].[User] tl ON u.tlId = tl.id
LEFT JOIN [GrowthPortal].[dbo].[MonthlySubmission] m ON u.id = m.empId AND m.month = '2026-10'
LEFT JOIN [GrowthPortal].[dbo].[AssessmentReview] ar ON m.id = ar.submissionId
ORDER BY un.name, u.empCode;
GO
