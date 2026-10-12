-- ============================================================================
-- MAHLE ANAND PASSPORT - SEED EMPLOYEES ACROSS ALL UNITS & DEPARTMENTS
-- Database: GrowthPortal
-- ============================================================================

USE [GrowthPortal];
GO

BEGIN TRY
BEGIN TRAN;

-- 1. Cache Roles & Units
DECLARE @empRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Shop Floor Employee');
DECLARE @tlRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');
DECLARE @sglRoleId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');

DECLARE @u1Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Gurugram');
DECLARE @u2Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 2');
DECLARE @u3Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 3');
DECLARE @u4Id NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'State Unit 4');

-- Departments
DECLARE @u1DeptMfg NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u1Id);
DECLARE @u1DeptQA NVARCHAR(1000)  = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u1Id);
DECLARE @u1DeptAs NVARCHAR(1000)  = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @u1Id);

DECLARE @u2DeptMfg NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u2Id);
DECLARE @u2DeptQA NVARCHAR(1000)  = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u2Id);

DECLARE @u3DeptMfg NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u3Id);
DECLARE @u3DeptQA NVARCHAR(1000)  = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u3Id);

DECLARE @u4DeptMfg NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @u4Id);
DECLARE @u4DeptQA NVARCHAR(1000)  = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @u4Id);

-- Default Password Hash ('Mahle@123')
DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';

-- 2. Ensure SGLs exist for all units
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02001', 'Vikram Verma (SGL Gurugram)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u1Id, @u1DeptMfg);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02002', 'Anil Gupta (SGL Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u2Id, @u2DeptMfg);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02003')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02003', 'Prakash Nair (SGL Unit 3)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u3Id, @u3DeptMfg);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K02004')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K02004', 'Devendra Joshi (SGL Unit 4)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @sglRoleId, @u4Id, @u4DeptMfg);

DECLARE @u1SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02001');
DECLARE @u2SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02002');
DECLARE @u3SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02003');
DECLARE @u4SglId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K02004');

-- 3. Ensure TLs exist for all units
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01001')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01001', 'Rajesh Sharma (TL Gurugram)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u1Id, @u1DeptMfg, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01002')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01002', 'Manoj Singh (TL Unit 2)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u2Id, @u2DeptMfg, @u2SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01003')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01003', 'Karthik Raja (TL Unit 3)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u3Id, @u3DeptMfg, @u3SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'K01004')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'K01004', 'Sanjay Negi (TL Unit 4)', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @tlRoleId, @u4Id, @u4DeptMfg, @u4SglId);

DECLARE @u1TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01001');
DECLARE @u2TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01002');
DECLARE @u3TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01003');
DECLARE @u4TlId NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'K01004');

-- ============================================================================
-- 4. SEED EMPLOYEES ACROSS ALL 4 UNITS
-- ============================================================================

-- 4.1 Unit 1: Gurugram Employees
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA1042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA1042', 'Amit Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptMfg, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK1042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK1042', 'Suresh Patel', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptMfg, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA1043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA1043', 'Rohit Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptAs, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK1043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK1043', 'Vikas Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptAs, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA1044')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA1044', 'Sandeep Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptQA, @u1TlId, @u1SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK1044')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK1044', 'Pankaj Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u1Id, @u1DeptMfg, @u1TlId, @u1SglId);

-- 4.2 Unit 2: State Unit 2 Employees
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA2042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA2042', 'Rahul Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u2Id, @u2DeptMfg, @u2TlId, @u2SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK2042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK2042', 'Deepak Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u2Id, @u2DeptMfg, @u2TlId, @u2SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA2043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA2043', 'Nitin Kulkarni', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u2Id, @u2DeptQA, @u2TlId, @u2SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK2043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK2043', 'Sachin Patil', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u2Id, @u2DeptMfg, @u2TlId, @u2SglId);

-- 4.3 Unit 3: State Unit 3 Employees
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA3042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA3042', 'Arun Murugan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u3Id, @u3DeptMfg, @u3TlId, @u3SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK3042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK3042', 'Vijay Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u3Id, @u3DeptQA, @u3TlId, @u3SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA3043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA3043', 'Saravanan Pillai', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u3Id, @u3DeptMfg, @u3TlId, @u3SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK3043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK3043', 'Dinesh Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u3Id, @u3DeptMfg, @u3TlId, @u3SglId);

-- 4.4 Unit 4: State Unit 4 Employees
IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA4042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA4042', 'Rohit Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u4Id, @u4DeptMfg, @u4TlId, @u4SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK4042')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK4042', 'Mohit Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u4Id, @u4DeptQA, @u4TlId, @u4SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'KA4043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'KA4043', 'Kuldeep Rana', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u4Id, @u4DeptMfg, @u4TlId, @u4SglId);

IF NOT EXISTS (SELECT * FROM [dbo].[User] WHERE [empCode] = 'NTK4043')
    INSERT INTO [dbo].[User] ([id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId], [tlId], [sglId])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'NTK4043', 'Abhishek Negi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @empRoleId, @u4Id, @u4DeptMfg, @u4TlId, @u4SglId);

-- ============================================================================
-- 5. SEED MONTHLY SUBMISSIONS & 1-10 ASSESSMENTS FOR OCTOBER 2026
-- ============================================================================

-- Helper Procedure-like Blocks using Variables
DECLARE @empGuid NVARCHAR(1000);
DECLARE @subId NVARCHAR(1000);

-- 5.1 Gurugram: KA1043 (Evaluated 9.10)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA1043');
SET @subId = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10');
IF @subId IS NULL
BEGIN
    SET @subId = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@subId, @empGuid, '2026-10', 'evaluated', 9.00, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @subId)
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @subId, @u1TlId, 9.10, 'Grade A+ (Distinction)', '{"safety":9.5,"quality":9.0,"5s":9.0,"productivity":9.5,"attendance":9.5}', 'Outstanding assembly discipline with zero rework.', 'Approved by SGL.', 'completed', SYSUTCDATETIME(), SYSUTCDATETIME());

-- 5.2 Gurugram: NTK1043 (Submitted)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'NTK1043');
IF NOT EXISTS (SELECT * FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10')
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empGuid, '2026-10', 'submitted', 8.00, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());

-- 5.3 Gurugram: KA1044 (Evaluated 8.40)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA1044');
SET @subId = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10');
IF @subId IS NULL
BEGIN
    SET @subId = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@subId, @empGuid, '2026-10', 'evaluated', 8.20, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @subId)
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @subId, @u1TlId, 8.40, 'Grade A (Outstanding)', '{"safety":8.5,"quality":8.5,"5s":8.5,"productivity":8.0,"attendance":9.0}', 'Great QA sampling accuracy.', 'Verified by SGL.', 'completed', SYSUTCDATETIME(), SYSUTCDATETIME());

-- 5.4 Unit 2: KA2043 (Evaluated 8.80)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA2043');
SET @subId = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10');
IF @subId IS NULL
BEGIN
    SET @subId = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@subId, @empGuid, '2026-10', 'evaluated', 8.60, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @subId)
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @subId, @u2TlId, 8.80, 'Grade A (Outstanding)', '{"safety":9.0,"quality":9.0,"5s":8.5,"productivity":8.5,"attendance":9.0}', 'Maintained tight inspection standards.', 'Approved by Unit 2 SGL.', 'completed', SYSUTCDATETIME(), SYSUTCDATETIME());

-- 5.5 Unit 2: NTK2043 (Evaluated 7.90)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'NTK2043');
SET @subId = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10');
IF @subId IS NULL
BEGIN
    SET @subId = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@subId, @empGuid, '2026-10', 'evaluated', 7.50, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @subId)
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @subId, @u2TlId, 7.90, 'Grade B+ (Good)', '{"safety":8.0,"quality":8.0,"5s":7.5,"productivity":8.0,"attendance":8.0}', 'Good productivity across the shift.', 'Verified by Unit 2 SGL.', 'completed', SYSUTCDATETIME(), SYSUTCDATETIME());

-- 5.6 Unit 3: KA3043 (Submitted)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA3043');
IF NOT EXISTS (SELECT * FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10')
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empGuid, '2026-10', 'submitted', 8.50, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());

-- 5.7 Unit 4: KA4043 (Evaluated 9.00)
SET @empGuid = (SELECT TOP 1 [id] FROM [dbo].[User] WHERE [empCode] = 'KA4043');
SET @subId = (SELECT TOP 1 [id] FROM [dbo].[MonthlySubmission] WHERE [empId] = @empGuid AND [month] = '2026-10');
IF @subId IS NULL
BEGIN
    SET @subId = CAST(NEWID() AS NVARCHAR(1000));
    INSERT INTO [dbo].[MonthlySubmission] ([id], [empId], [month], [status], [selfScore], [submittedAt], [createdAt], [updatedAt])
    VALUES (@subId, @empGuid, '2026-10', 'evaluated', 8.80, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
END
IF NOT EXISTS (SELECT * FROM [dbo].[AssessmentReview] WHERE [submissionId] = @subId)
    INSERT INTO [dbo].[AssessmentReview] ([id], [submissionId], [evaluatorId], [score], [ratingGrade], [criteriaScores], [tlComments], [sglRemarks], [status], [reviewedAt], [updatedAt])
    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @subId, @u4TlId, 9.00, 'Grade A+ (Distinction)', '{"safety":9.0,"quality":9.0,"5s":9.0,"productivity":9.0,"attendance":9.0}', 'Exceptional machine maintenance & safety compliance.', 'Approved by Unit 4 SGL.', 'completed', SYSUTCDATETIME(), SYSUTCDATETIME());

COMMIT TRAN;
PRINT '========================================================================';
PRINT 'Shop Floor Employees seeded successfully across all 4 plants!';
PRINT '========================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO

-- ============================================================================
-- FORMATTED RESULT TABLE OF ALL EMPLOYEES
-- ============================================================================

SELECT 
    un.name AS [Plant Unit],
    u.empCode AS [Emp Code / ID],
    u.name AS [Employee Name],
    d.name AS [Department],
    tl.name AS [Assigned TL],
    sgl.name AS [Assigned SGL],
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
LEFT JOIN [GrowthPortal].[dbo].[User] sgl ON u.sglId = sgl.id
LEFT JOIN [GrowthPortal].[dbo].[MonthlySubmission] m ON u.id = m.empId AND m.month = '2026-10'
LEFT JOIN [GrowthPortal].[dbo].[AssessmentReview] ar ON m.id = ar.submissionId
ORDER BY un.name, u.empCode;
GO
