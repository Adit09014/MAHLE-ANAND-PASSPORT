-- ============================================================================
-- MAHLE ANAND GROWTH PASSPORT - 3 PLANTS DATA SEED SCRIPT (SSMS)
-- Plants: Gurugram, Parwanoo, Pune
-- Total Personnel Seeded: 537 records
-- Target Database: GrowthPortal
-- Compatible with: SQL Server 2017 / 2019 / 2022 / Azure SQL
-- Date Generated: 2026-10-21 14:21:26
-- ============================================================================
SET NOCOUNT ON;
GO

USE [GrowthPortal];
GO

BEGIN TRY
BEGIN TRANSACTION;

-- ----------------------------------------------------------------------------
-- 1. ENSURE SYSTEM ROLES EXIST
-- ----------------------------------------------------------------------------
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
BEGIN
    IF EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Shop Floor Employee')
        UPDATE [dbo].[Role] SET [name] = 'Employee' WHERE [name] = 'Shop Floor Employee';
    ELSE
        INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Employee');
END

-- ----------------------------------------------------------------------------
-- 2. ENSURE 3 PLANT UNITS EXIST (GURUGRAM, PARWANOO, PUNE)
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Gurugram')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Gurugram', 'GGN', 1);
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'GGN', [isActive] = 1 WHERE [name] = 'Gurugram';

IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Parwanoo')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Parwanoo', 'PRW', 1);
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'PRW', [isActive] = 1 WHERE [name] = 'Parwanoo';

IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Pune')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Pune', 'PUN', 1);
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'PUN', [isActive] = 1 WHERE [name] = 'Pune';

-- Resolve Unit IDs
DECLARE @unitGurugram NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Gurugram');
DECLARE @unitParwanoo NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Parwanoo');
DECLARE @unitPune     NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Pune');

-- ----------------------------------------------------------------------------
-- 3. ENSURE STANDARD DEPARTMENTS EXIST FOR ALL 3 PLANTS
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitGurugram)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @unitGurugram);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitParwanoo)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @unitParwanoo);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitPune)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @unitPune);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @unitGurugram)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @unitGurugram);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @unitParwanoo)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @unitParwanoo);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @unitPune)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @unitPune);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @unitGurugram)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Assembly Line', @unitGurugram);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @unitParwanoo)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Assembly Line', @unitParwanoo);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @unitPune)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Assembly Line', @unitPune);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @unitGurugram)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @unitGurugram);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @unitParwanoo)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @unitParwanoo);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @unitPune)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @unitPune);

-- Resolve Primary Manufacturing Departments for each plant
DECLARE @deptGgn NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitGurugram);
DECLARE @deptPrw NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitParwanoo);
DECLARE @deptPun NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitPune);

-- Resolve Role IDs
DECLARE @rSuperAdmin NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Super Admin');
DECLARE @rHrHead     NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'HR Head');
DECLARE @rUnitAdmin  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Unit Admin');
DECLARE @rSGL        NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');
DECLARE @rTL         NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');
DECLARE @rEmployee   NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Employee');

-- Default password hash for initial user access: 'Mahle@123'
DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';

-- ============================================================================
-- SEEDING PLANT: GURUGRAM (267 Total Records)
-- ============================================================================

IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001826')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001826', N'Singh Sukhveer', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'8859176705', N'ssukhveer04@gmail.com', N'2013-04-09', N'1991-07-01', N'Jr. Engineer', N'2013-04-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Singh Sukhveer', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'8859176705', [mobile]),
        [email] = ISNULL(N'ssukhveer04@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-04-09', [joiningDate]),
        [dob] = ISNULL(N'1991-07-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-04-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001826';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001901')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001901', N'Krishna Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'893371326', NULL, N'2014-10-06', N'1994-05-15', N'Jr. Engineer', N'2014-10-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Krishna Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'893371326', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-10-06', [joiningDate]),
        [dob] = ISNULL(N'1994-05-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-10-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001901';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001989')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001989', N'Sachin Vinod Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Kumar', N'7038988315', N'SachinKumar98120@gmail.com', N'2015-06-27', N'1994-02-12', N'Jr. Engineer', N'2015-06-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sachin Vinod Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Kumar', [fatherName]),
        [mobile] = ISNULL(N'7038988315', [mobile]),
        [email] = ISNULL(N'SachinKumar98120@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-06-27', [joiningDate]),
        [dob] = ISNULL(N'1994-02-12', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-06-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001989';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001999')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001999', N'Rishikesh Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'7391902454', N'singhrishikesh94@gmail.com', N'2015-06-27', N'1995-08-19', N'Jr. Engineer', N'2015-06-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rishikesh Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'7391902454', [mobile]),
        [email] = ISNULL(N'singhrishikesh94@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-06-27', [joiningDate]),
        [dob] = ISNULL(N'1995-08-19', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-06-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001999';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002017')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002017', N'Chhathu Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Baharan Yadav', N'7654086774', N'chhathu900@gmail.com', N'2016-01-01', N'1995-03-17', N'Jr. Engineer', N'2016-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chhathu Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Baharan Yadav', [fatherName]),
        [mobile] = ISNULL(N'7654086774', [mobile]),
        [email] = ISNULL(N'chhathu900@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-01-01', [joiningDate]),
        [dob] = ISNULL(N'1995-03-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002017';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002059')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002059', N'Lopamudra Majhi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        NULL, N'7448239934', N'majhilopamudra@gmail.com', N'2016-05-24', N'1993-07-09', N'Jr. Engineer', N'2016-05-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lopamudra Majhi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'7448239934', [mobile]),
        [email] = ISNULL(N'majhilopamudra@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-05-24', [joiningDate]),
        [dob] = ISNULL(N'1993-07-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-05-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002059';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002096')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002096', N'Surendra Kumar Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'7321024925', N'surendraverma846@gmail.com', N'2016-06-27', N'1997-05-01', N'Jr. Engineer', N'2016-06-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Surendra Kumar Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'7321024925', [mobile]),
        [email] = ISNULL(N'surendraverma846@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-06-27', [joiningDate]),
        [dob] = ISNULL(N'1997-05-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-06-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002096';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002128')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002128', N'Deepak Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Swadesh Kumar', N'9814415692', N'vatsd48@gmail.com', N'2017-03-20', N'1996-07-07', N'Jr. Engineer', N'2017-03-20', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Swadesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'9814415692', [mobile]),
        [email] = ISNULL(N'vatsd48@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-03-20', [joiningDate]),
        [dob] = ISNULL(N'1996-07-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-03-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002128';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002143')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002143', N'Radheshyam singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Harpalsingh', N'9720544358', N'radheshyamking55@gmail.com', N'2017-04-18', N'1996-08-01', N'Jr. Engineer', N'2017-04-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Radheshyam singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Harpalsingh', [fatherName]),
        [mobile] = ISNULL(N'9720544358', [mobile]),
        [email] = ISNULL(N'radheshyamking55@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-04-18', [joiningDate]),
        [dob] = ISNULL(N'1996-08-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-04-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002143';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002145')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002145', N'MD Shakir', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MD Yasin', N'9627625979', N'mdshakirtyagi784@gmail.com', N'2017-04-18', N'1996-03-04', N'Jr. Engineer', N'2017-04-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MD Shakir', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MD Yasin', [fatherName]),
        [mobile] = ISNULL(N'9627625979', [mobile]),
        [email] = ISNULL(N'mdshakirtyagi784@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-04-18', [joiningDate]),
        [dob] = ISNULL(N'1996-03-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-04-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002145';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1033')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1033', N'Sunil KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitGurugram, @deptGgn,
        N'VeerSingh', N'8939721389', N'sunilkumar90ngn@gmail.com', N'2013-12-20', N'1990-01-01', N'Asst. Manager', N'2013-12-20', N'5'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunil KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'VeerSingh', [fatherName]),
        [mobile] = ISNULL(N'8939721389', [mobile]),
        [email] = ISNULL(N'sunilkumar90ngn@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-12-20', [joiningDate]),
        [dob] = ISNULL(N'1990-01-01', [dob]),
        [designation] = ISNULL(N'Asst. Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-12-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'5', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1033';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40062')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40062', N'Mohit Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajan Verma', N'9816565915', N'verma.mohit08@gmail.com', N'2010-06-02', N'1988-06-28', N'Jr. Engineer', N'2010-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohit Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajan Verma', [fatherName]),
        [mobile] = ISNULL(N'9816565915', [mobile]),
        [email] = ISNULL(N'verma.mohit08@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2010-06-02', [joiningDate]),
        [dob] = ISNULL(N'1988-06-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40062';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40332')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40332', N'SURTEGH SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Mukhtiar Singh', N'8146525653', N'surteghnoor101@gmail.com', N'2014-10-10', N'1995-11-29', N'Jr. Engineer', N'2014-10-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SURTEGH SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Mukhtiar Singh', [fatherName]),
        [mobile] = ISNULL(N'8146525653', [mobile]),
        [email] = ISNULL(N'surteghnoor101@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-10-10', [joiningDate]),
        [dob] = ISNULL(N'1995-11-29', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-10-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40332';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40335')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40335', N'Alok Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Badhu Yadav', N'8808198683', NULL, N'2014-11-05', N'1995-01-21', N'Jr. Engineer', N'2014-11-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Alok Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Badhu Yadav', [fatherName]),
        [mobile] = ISNULL(N'8808198683', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-05', [joiningDate]),
        [dob] = ISNULL(N'1995-01-21', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40335';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40336')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40336', N'Wajid Ali', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shafiullah', N'9576040407', NULL, N'2014-11-05', N'1994-05-16', N'Jr. Engineer', N'2014-11-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Wajid Ali', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shafiullah', [fatherName]),
        [mobile] = ISNULL(N'9576040407', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-05', [joiningDate]),
        [dob] = ISNULL(N'1994-05-16', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40336';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40338')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40338', N'Haidar Ali', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Reyajuddin Miya', N'9857273592', NULL, N'2014-11-05', N'1995-02-05', N'Jr. Engineer', N'2014-11-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Haidar Ali', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Reyajuddin Miya', [fatherName]),
        [mobile] = ISNULL(N'9857273592', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-05', [joiningDate]),
        [dob] = ISNULL(N'1995-02-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40338';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50039')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50039', N'Puneet Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitGurugram, @deptGgn,
        N'Dinesh Choudhary', N'9816835995', N'pk.choudhary1432@gmail.com', N'2010-03-08', N'1989-03-15', N'Sr. Engineer', N'2010-03-08', N'4'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Puneet Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dinesh Choudhary', [fatherName]),
        [mobile] = ISNULL(N'9816835995', [mobile]),
        [email] = ISNULL(N'pk.choudhary1432@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2010-03-08', [joiningDate]),
        [dob] = ISNULL(N'1989-03-15', [dob]),
        [designation] = ISNULL(N'Sr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-03-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'4', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50039';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50072')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50072', N'Nitish Goyat', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'Dharmvir Singh', N'9817745333', N'Nitishgoyat68@gmail.com', N'2013-02-04', N'1991-12-30', N'Jr. Engineer', N'2013-02-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitish Goyat', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dharmvir Singh', [fatherName]),
        [mobile] = ISNULL(N'9817745333', [mobile]),
        [email] = ISNULL(N'Nitishgoyat68@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-02-04', [joiningDate]),
        [dob] = ISNULL(N'1991-12-30', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-02-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50072';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50074')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50074', N'Bhim Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Om Chand', N'8988334002', N'Bhim137@', N'2013-03-14', N'1990-12-02', N'Jr. Engineer', N'2013-03-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhim Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Om Chand', [fatherName]),
        [mobile] = ISNULL(N'8988334002', [mobile]),
        [email] = ISNULL(N'Bhim137@', [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1990-12-02', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50074';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50083')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50083', N'Bhanu Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Baldev Singh', N'9418141482', NULL, N'2013-03-14', N'1992-11-10', N'Jr. Engineer', N'2013-03-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhanu Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Baldev Singh', [fatherName]),
        [mobile] = ISNULL(N'9418141482', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1992-11-10', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50083';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50136')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50136', N'Nitin Guleria', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Yashpal Singh', N'8988022895', N'nitinguleria20@gmail.com', N'2014-07-10', N'1995-05-09', N'Jr. Engineer', N'2014-07-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitin Guleria', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Yashpal Singh', [fatherName]),
        [mobile] = ISNULL(N'8988022895', [mobile]),
        [email] = ISNULL(N'nitinguleria20@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-07-10', [joiningDate]),
        [dob] = ISNULL(N'1995-05-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-07-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50136';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50144')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50144', N'Vikas Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ram Pravesh Pandit', N'8894763724', N'vkvikky.94@gmail.com', N'2014-07-10', N'1994-05-03', N'Jr. Engineer', N'2014-07-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vikas Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ram Pravesh Pandit', [fatherName]),
        [mobile] = ISNULL(N'8894763724', [mobile]),
        [email] = ISNULL(N'vkvikky.94@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-07-10', [joiningDate]),
        [dob] = ISNULL(N'1994-05-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-07-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50144';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50254')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50254', N'Abinash Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajinder Kumar', N'8679960633', N'abithakur254@gmail.com', N'2015-07-08', N'1993-08-19', N'Jr. Engineer', N'2015-07-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abinash Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajinder Kumar', [fatherName]),
        [mobile] = ISNULL(N'8679960633', [mobile]),
        [email] = ISNULL(N'abithakur254@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-07-08', [joiningDate]),
        [dob] = ISNULL(N'1993-08-19', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50254';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50278')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50278', N'Anil Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'Lekh Raj Sharma', N'7018414143', NULL, N'2015-07-01', N'1993-12-26', N'Engineer', N'2015-07-01', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anil Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Lekh Raj Sharma', [fatherName]),
        [mobile] = ISNULL(N'7018414143', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-07-01', [joiningDate]),
        [dob] = ISNULL(N'1993-12-26', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50278';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50283')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50283', N'Hunny Kapoor', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vijay Kapoor', N'9996699816', N'hunnykapoor173.com@gmail.com', N'2015-07-01', N'1996-07-11', N'Jr. Engineer', N'2015-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Hunny Kapoor', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vijay Kapoor', [fatherName]),
        [mobile] = ISNULL(N'9996699816', [mobile]),
        [email] = ISNULL(N'hunnykapoor173.com@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-07-01', [joiningDate]),
        [dob] = ISNULL(N'1996-07-11', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50283';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50322')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50322', N'Sudhir Rai', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'Dhanpat Rai', N'8894919394', N'sudhir18981rai@gmail.com', N'2016-02-15', N'1995-08-31', N'Engineer', N'2016-02-15', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sudhir Rai', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dhanpat Rai', [fatherName]),
        [mobile] = ISNULL(N'8894919394', [mobile]),
        [email] = ISNULL(N'sudhir18981rai@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-02-15', [joiningDate]),
        [dob] = ISNULL(N'1995-08-31', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-02-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50322';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50335')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50335', N'Abhishek Sonkar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Yogesh Sonkar', N'9729609825', N'abhisonkar27@gmail.com', N'2016-04-13', N'1994-06-22', N'Jr. Engineer', N'2016-04-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhishek Sonkar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Yogesh Sonkar', [fatherName]),
        [mobile] = ISNULL(N'9729609825', [mobile]),
        [email] = ISNULL(N'abhisonkar27@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-04-13', [joiningDate]),
        [dob] = ISNULL(N'1994-06-22', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-04-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50335';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50427')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50427', N'Suraj Bhan Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dinesh Singh', N'9546547809', NULL, N'2018-02-02', N'1997-08-09', N'Jr. Engineer', N'2018-02-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suraj Bhan Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dinesh Singh', [fatherName]),
        [mobile] = ISNULL(N'9546547809', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2018-02-02', [joiningDate]),
        [dob] = ISNULL(N'1997-08-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-02-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50427';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50429')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50429', N'Ramesh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Pradip Kumar', N'7903660816', NULL, N'2018-02-02', N'1998-11-20', N'Jr. Engineer', N'2018-02-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ramesh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pradip Kumar', [fatherName]),
        [mobile] = ISNULL(N'7903660816', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2018-02-02', [joiningDate]),
        [dob] = ISNULL(N'1998-11-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-02-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50429';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01001')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01001', N'RAVINDER SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'BIRBAL SINGH', N'9991900537', NULL, N'2015-03-02', N'1993-07-04', N'Jr. Engineer', N'2015-03-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RAVINDER SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'BIRBAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'9991900537', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-03-02', [joiningDate]),
        [dob] = ISNULL(N'1993-07-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-03-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01001';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01002')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01002', N'Baljeet Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'KRISHAN KUMAR', N'8059809685', NULL, N'2015-03-02', N'1996-01-16', N'Jr. Engineer', N'2015-03-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Baljeet Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'KRISHAN KUMAR', [fatherName]),
        [mobile] = ISNULL(N'8059809685', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-03-02', [joiningDate]),
        [dob] = ISNULL(N'1996-01-16', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-03-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01002';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01008')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01008', N'AKASH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMBADAN', N'8901216909', NULL, N'2015-04-13', N'1996-08-16', N'Jr. Engineer', N'2015-04-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AKASH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMBADAN', [fatherName]),
        [mobile] = ISNULL(N'8901216909', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-04-13', [joiningDate]),
        [dob] = ISNULL(N'1996-08-16', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-04-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01008';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01012')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01012', N'PREETI', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'BHASKAR GHILDIYAL', N'8130707996', NULL, N'2015-05-07', N'1993-03-12', N'Jr. Engineer', N'2015-05-07', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'PREETI', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'BHASKAR GHILDIYAL', [fatherName]),
        [mobile] = ISNULL(N'8130707996', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-05-07', [joiningDate]),
        [dob] = ISNULL(N'1993-03-12', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-05-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01012';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01013')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01013', N'NARESH KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'OM PRAKASH', N'8527491565', NULL, N'2015-05-06', N'1996-06-01', N'Engineer', N'2015-05-06', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'NARESH KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'OM PRAKASH', [fatherName]),
        [mobile] = ISNULL(N'8527491565', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-05-06', [joiningDate]),
        [dob] = ISNULL(N'1996-06-01', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-05-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01013';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01015')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01015', N'INDERJEET', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'NARASH KUMAR', N'9540744020', NULL, N'2015-05-06', N'1993-10-05', N'Jr. Engineer', N'2015-05-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'INDERJEET', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'NARASH KUMAR', [fatherName]),
        [mobile] = ISNULL(N'9540744020', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-05-06', [joiningDate]),
        [dob] = ISNULL(N'1993-10-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-05-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01015';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01016')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01016', N'MUKESH KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SHARWAN KUMAR', N'9416305866', NULL, N'2015-05-06', N'1993-01-25', N'Jr. Engineer', N'2015-05-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MUKESH KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SHARWAN KUMAR', [fatherName]),
        [mobile] = ISNULL(N'9416305866', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-05-06', [joiningDate]),
        [dob] = ISNULL(N'1993-01-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-05-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01016';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01018')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01018', N'ASHISH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'DIGPAL SINGH', N'9560374029', NULL, N'2015-05-07', N'1992-09-15', N'Jr. Engineer', N'2015-05-07', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ASHISH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'DIGPAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'9560374029', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-05-07', [joiningDate]),
        [dob] = ISNULL(N'1992-09-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-05-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01018';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01023')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01023', N'MANORAMA DAS', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'9583542443', NULL, N'2015-06-18', N'1994-04-09', N'Jr. Engineer', N'2015-06-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MANORAMA DAS', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'9583542443', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-06-18', [joiningDate]),
        [dob] = ISNULL(N'1994-04-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-06-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01023';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01034')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01034', N'VIKAS TIWARI', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'7503799966', NULL, N'2015-09-23', N'1995-07-14', N'Jr. Engineer', N'2015-09-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'VIKAS TIWARI', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'7503799966', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-09-23', [joiningDate]),
        [dob] = ISNULL(N'1995-07-14', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-09-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01034';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01036')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01036', N'SANJAY', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'8802539440', N'SANJAYSHARMA4040@GMAIL.COM', N'2015-09-23', N'1996-09-13', N'Jr. Engineer', N'2015-09-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SANJAY', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'8802539440', [mobile]),
        [email] = ISNULL(N'SANJAYSHARMA4040@GMAIL.COM', [email]),
        [joiningDate] = ISNULL(N'2015-09-23', [joiningDate]),
        [dob] = ISNULL(N'1996-09-13', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-09-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01036';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01053')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01053', N'DEVENDRA PARMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MANOHAR LAL', N'8818953411', NULL, N'2015-12-29', N'1993-01-15', N'Jr. Engineer', N'2015-12-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'DEVENDRA PARMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MANOHAR LAL', [fatherName]),
        [mobile] = ISNULL(N'8818953411', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-12-29', [joiningDate]),
        [dob] = ISNULL(N'1993-01-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-12-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01053';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01058')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01058', N'PRINCE BHUSHAN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MUNSHI RAM', N'8988218530', NULL, N'2015-12-29', N'1993-04-28', N'Jr. Engineer', N'2015-12-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'PRINCE BHUSHAN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MUNSHI RAM', [fatherName]),
        [mobile] = ISNULL(N'8988218530', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-12-29', [joiningDate]),
        [dob] = ISNULL(N'1993-04-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-12-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01058';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01061')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01061', N'KM ANJU', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SOVRAN SINGH GAUTAM', N'9084571725', NULL, N'2015-12-29', N'1996-09-02', N'Jr. Engineer', N'2015-12-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'KM ANJU', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SOVRAN SINGH GAUTAM', [fatherName]),
        [mobile] = ISNULL(N'9084571725', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-12-29', [joiningDate]),
        [dob] = ISNULL(N'1996-09-02', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-12-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01061';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01081')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01081', N'Munish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Gulzari Lal', N'8077902834', NULL, N'2016-06-24', N'1994-04-30', N'Jr. Engineer', N'2016-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Munish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Gulzari Lal', [fatherName]),
        [mobile] = ISNULL(N'8077902834', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2016-06-24', [joiningDate]),
        [dob] = ISNULL(N'1994-04-30', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01081';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01084')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01084', N'Lalit', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sardhanand', N'8689012140', NULL, N'2016-06-24', N'1994-12-25', N'Jr. Engineer', N'2016-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lalit', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sardhanand', [fatherName]),
        [mobile] = ISNULL(N'8689012140', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2016-06-24', [joiningDate]),
        [dob] = ISNULL(N'1994-12-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01084';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01093')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01093', N'Neeraj Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Pannu Ram', N'9888256199', NULL, N'2017-03-27', N'1995-09-07', N'Jr. Engineer', N'2017-03-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Neeraj Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pannu Ram', [fatherName]),
        [mobile] = ISNULL(N'9888256199', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2017-03-27', [joiningDate]),
        [dob] = ISNULL(N'1995-09-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-03-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01093';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01096')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01096', N'Hariom Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ramakant Singh', N'8924902990', N'hharriom2@gmail.com', N'2017-03-27', N'1995-02-09', N'Jr. Engineer', N'2017-03-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Hariom Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ramakant Singh', [fatherName]),
        [mobile] = ISNULL(N'8924902990', [mobile]),
        [email] = ISNULL(N'hharriom2@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-03-27', [joiningDate]),
        [dob] = ISNULL(N'1995-02-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-03-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01096';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01122')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01122', N'Vaibhav Soni', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vishnu Soni', N'8109769276', N'vs173100@gmail.com', N'2017-08-30', N'1996-12-06', N'Jr. Engineer', N'2017-08-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vaibhav Soni', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vishnu Soni', [fatherName]),
        [mobile] = ISNULL(N'8109769276', [mobile]),
        [email] = ISNULL(N'vs173100@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-08-30', [joiningDate]),
        [dob] = ISNULL(N'1996-12-06', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-08-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01122';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01132')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01132', N'Mohd Nadeem', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vakeel Ahmad', N'9259018689', N'nadeemansari678@gmail.com', N'2017-10-12', N'1995-07-15', N'Jr. Engineer', N'2017-10-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohd Nadeem', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vakeel Ahmad', [fatherName]),
        [mobile] = ISNULL(N'9259018689', [mobile]),
        [email] = ISNULL(N'nadeemansari678@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-10-12', [joiningDate]),
        [dob] = ISNULL(N'1995-07-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-10-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01132';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01137')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01137', N'Jay Prakash Ray', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Pradip Ray', N'7004433923', N'Jayprakashray820@gmail.com', N'2018-01-05', N'1996-06-28', N'Jr. Engineer', N'2018-01-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jay Prakash Ray', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pradip Ray', [fatherName]),
        [mobile] = ISNULL(N'7004433923', [mobile]),
        [email] = ISNULL(N'Jayprakashray820@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-01-05', [joiningDate]),
        [dob] = ISNULL(N'1996-06-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-01-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01137';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01138')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01138', N'Mohan Kumar Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Mahendra Prasad', N'8840097756', N'Vermamohan103@gmail.com', N'2018-01-05', N'1997-07-18', N'Jr. Engineer', N'2018-01-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohan Kumar Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Mahendra Prasad', [fatherName]),
        [mobile] = ISNULL(N'8840097756', [mobile]),
        [email] = ISNULL(N'Vermamohan103@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-01-05', [joiningDate]),
        [dob] = ISNULL(N'1997-07-18', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-01-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01138';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01175')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01175', N'Vikas Beniwal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitGurugram, @deptGgn,
        N'Jaiprakash Beniwal', N'9971068886', N'vikasbeniwal@yahoo.com', N'2026-08-12', N'1986-10-20', N'Senior Manager', N'2026-08-12', N'7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vikas Beniwal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jaiprakash Beniwal', [fatherName]),
        [mobile] = ISNULL(N'9971068886', [mobile]),
        [email] = ISNULL(N'vikasbeniwal@yahoo.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-12', [joiningDate]),
        [dob] = ISNULL(N'1986-10-20', [dob]),
        [designation] = ISNULL(N'Senior Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01175';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0635')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0635', N'SUNIL KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMPAL SINGH', N'9711489560', NULL, N'2010-01-18', N'1974-01-02', N'Technician', N'2010-01-18', N'A'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SUNIL KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMPAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'9711489560', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2010-01-18', [joiningDate]),
        [dob] = ISNULL(N'1974-01-02', [dob]),
        [designation] = ISNULL(N'Technician', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-01-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'A', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0635';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0676')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0676', N'RAKESH KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitGurugram, @deptGgn,
        N'SURAM SINGH', N'9971160153', N'rakesh.chotu99@gmail.com', N'2009-10-20', N'1988-12-11', N'Assistant Manager', N'2009-10-20', N'5'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RAKESH KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SURAM SINGH', [fatherName]),
        [mobile] = ISNULL(N'9971160153', [mobile]),
        [email] = ISNULL(N'rakesh.chotu99@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2009-10-20', [joiningDate]),
        [dob] = ISNULL(N'1988-12-11', [dob]),
        [designation] = ISNULL(N'Assistant Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2009-10-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'5', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0676';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0704')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0704', N'BISHAN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAJ PAL SINGH', N'8826211367', NULL, N'2010-11-24', N'1991-11-10', N'Jr. Engineer', N'2010-11-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'BISHAN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAJ PAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'8826211367', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2010-11-24', [joiningDate]),
        [dob] = ISNULL(N'1991-11-10', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-11-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0704';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0713')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0713', N'RISHI KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'JAI NARYAN', N'8802224955', NULL, N'2010-11-25', N'1989-01-02', N'Engineer', N'2010-11-25', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RISHI KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'JAI NARYAN', [fatherName]),
        [mobile] = ISNULL(N'8802224955', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2010-11-25', [joiningDate]),
        [dob] = ISNULL(N'1989-01-02', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-11-25', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0713';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0723')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0723', N'SANDEEP KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'Pale Ram', N'9468452437', NULL, N'2010-12-01', N'1988-12-22', N'Engineer', N'2010-12-01', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SANDEEP KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pale Ram', [fatherName]),
        [mobile] = ISNULL(N'9468452437', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2010-12-01', [joiningDate]),
        [dob] = ISNULL(N'1988-12-22', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0723';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0729')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0729', N'PAWAN KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'SHRI CHAND', N'9034757082', NULL, N'2010-12-01', N'1988-06-17', N'Engineer', N'2010-12-01', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'PAWAN KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SHRI CHAND', [fatherName]),
        [mobile] = ISNULL(N'9034757082', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2010-12-01', [joiningDate]),
        [dob] = ISNULL(N'1988-06-17', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0729';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0751')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0751', N'LEENA KUMARI', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'BHAGAT RAM', N'9354122071', NULL, N'2012-02-15', N'1992-07-20', N'Jr. Engineer', N'2012-02-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'LEENA KUMARI', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'BHAGAT RAM', [fatherName]),
        [mobile] = ISNULL(N'9354122071', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2012-02-15', [joiningDate]),
        [dob] = ISNULL(N'1992-07-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-02-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0751';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0755')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0755', N'SUNIL SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'TEK SINGH', N'8010677630', NULL, N'2012-02-15', N'1992-06-22', N'Jr. Engineer', N'2012-02-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SUNIL SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'TEK SINGH', [fatherName]),
        [mobile] = ISNULL(N'8010677630', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2012-02-15', [joiningDate]),
        [dob] = ISNULL(N'1992-06-22', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-02-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0755';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0781')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0781', N'SUMIT KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SATYAPAL', N'9540107852', NULL, N'2012-05-10', N'1989-04-08', N'Jr. Engineer', N'2012-05-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SUMIT KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SATYAPAL', [fatherName]),
        [mobile] = ISNULL(N'9540107852', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2012-05-10', [joiningDate]),
        [dob] = ISNULL(N'1989-04-08', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-05-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0781';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0822')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0822', N'JASBIR SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'BAHAL SINGH', N'9815981208', NULL, N'2012-11-03', N'1991-12-01', N'Engineer', N'2012-11-03', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'JASBIR SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'BAHAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'9815981208', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2012-11-03', [joiningDate]),
        [dob] = ISNULL(N'1991-12-01', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-11-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0822';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0826')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0826', N'GURMEET SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'AMARJEET SINGH', N'8092247882', NULL, N'2013-02-04', N'1990-09-23', N'Engineer', N'2013-02-04', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'GURMEET SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'AMARJEET SINGH', [fatherName]),
        [mobile] = ISNULL(N'8092247882', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2013-02-04', [joiningDate]),
        [dob] = ISNULL(N'1990-09-23', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-02-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0826';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0867')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0867', N'AVINASH SINGH MEHRA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'SURENDER SINGH MEHRA', N'7500907077', NULL, N'2014-08-06', N'1992-03-01', N'Engineer', N'2014-08-06', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AVINASH SINGH MEHRA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SURENDER SINGH MEHRA', [fatherName]),
        [mobile] = ISNULL(N'7500907077', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-08-06', [joiningDate]),
        [dob] = ISNULL(N'1992-03-01', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0867';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0908')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0908', N'NASEEM AHMAD', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MOHD.YASEEN', N'9756880131', NULL, N'2014-09-22', N'1993-06-17', N'Jr. Engineer', N'2014-09-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'NASEEM AHMAD', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MOHD.YASEEN', [fatherName]),
        [mobile] = ISNULL(N'9756880131', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-09-22', [joiningDate]),
        [dob] = ISNULL(N'1993-06-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0908';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0913')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0913', N'MAHENDRA KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'VILOCHAN PRASAD', N'8766295869', NULL, N'2014-09-22', N'1994-11-09', N'Jr. Engineer', N'2014-09-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MAHENDRA KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'VILOCHAN PRASAD', [fatherName]),
        [mobile] = ISNULL(N'8766295869', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-09-22', [joiningDate]),
        [dob] = ISNULL(N'1994-11-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0913';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0927')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0927', N'AMIT KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'SURENDER KUMAR', N'9991679044', NULL, N'2014-10-13', N'1995-07-12', N'Engineer', N'2014-10-13', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AMIT KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SURENDER KUMAR', [fatherName]),
        [mobile] = ISNULL(N'9991679044', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-10-13', [joiningDate]),
        [dob] = ISNULL(N'1995-07-12', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-10-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0927';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0930')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0930', N'DEVENDRA KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMESH CHAND', N'9654564738', NULL, N'2014-10-13', N'1992-02-16', N'Jr. Engineer', N'2014-10-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'DEVENDRA KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMESH CHAND', [fatherName]),
        [mobile] = ISNULL(N'9654564738', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-10-13', [joiningDate]),
        [dob] = ISNULL(N'1992-02-16', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-10-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0930';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0936')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0936', N'SANDEEP KUMAR GUPTA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'BUDHAN SAW', N'9835197395', NULL, N'2014-11-10', N'1993-10-07', N'Jr. Engineer', N'2014-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SANDEEP KUMAR GUPTA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'BUDHAN SAW', [fatherName]),
        [mobile] = ISNULL(N'9835197395', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-10', [joiningDate]),
        [dob] = ISNULL(N'1993-10-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0936';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0937')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0937', N'AKHILESH KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMNAYAN RAJBHAR', N'7417880823', NULL, N'2014-11-10', N'1993-09-09', N'Jr. Engineer', N'2014-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AKHILESH KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMNAYAN RAJBHAR', [fatherName]),
        [mobile] = ISNULL(N'7417880823', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-10', [joiningDate]),
        [dob] = ISNULL(N'1993-09-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0937';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0938')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0938', N'KUSHAL PAL SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SHREEPAL SINGH', N'8899313661', N'kushalpalsingh757@gmail.com', N'2014-11-10', N'1992-08-04', N'Jr. Engineer', N'2014-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'KUSHAL PAL SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SHREEPAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'8899313661', [mobile]),
        [email] = ISNULL(N'kushalpalsingh757@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-11-10', [joiningDate]),
        [dob] = ISNULL(N'1992-08-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0938';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0939')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0939', N'MD AFJAL ALAM', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MD MOJIBUL HAQUE', N'9771693062', NULL, N'2014-11-10', N'1994-11-11', N'Jr. Engineer', N'2014-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MD AFJAL ALAM', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MD MOJIBUL HAQUE', [fatherName]),
        [mobile] = ISNULL(N'9771693062', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-10', [joiningDate]),
        [dob] = ISNULL(N'1994-11-11', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0939';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0942')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0942', N'KULDEEP MISHRA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'JAYDEV PALIT', N'8759090154', NULL, N'2014-11-10', N'1992-07-01', N'Jr. Engineer', N'2014-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'KULDEEP MISHRA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'JAYDEV PALIT', [fatherName]),
        [mobile] = ISNULL(N'8759090154', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-10', [joiningDate]),
        [dob] = ISNULL(N'1992-07-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0942';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0944')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0944', N'VIKRANT  TOMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SATYAPAL SINGH', N'9012679778', NULL, N'2014-11-10', N'1993-06-15', N'Jr. Engineer', N'2014-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'VIKRANT  TOMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SATYAPAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'9012679778', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-10', [joiningDate]),
        [dob] = ISNULL(N'1993-06-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0944';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0952')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0952', N'SHAKEEL  AHAMAD', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MANGA AHAMAD', N'8791698352', NULL, N'2014-11-24', N'1995-07-09', N'Jr. Engineer', N'2014-11-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SHAKEEL  AHAMAD', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MANGA AHAMAD', [fatherName]),
        [mobile] = ISNULL(N'8791698352', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-24', [joiningDate]),
        [dob] = ISNULL(N'1995-07-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0952';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0954')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0954', N'KANHAIYA  SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'NAVAL SINGH', N'7834963409', NULL, N'2014-11-24', N'1994-07-02', N'Jr. Engineer', N'2014-11-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'KANHAIYA  SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'NAVAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'7834963409', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-24', [joiningDate]),
        [dob] = ISNULL(N'1994-07-02', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0954';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0956')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0956', N'RAKESH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMDHARI', N'9416177639', NULL, N'2014-11-24', N'1992-08-05', N'Jr. Engineer', N'2014-11-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RAKESH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMDHARI', [fatherName]),
        [mobile] = ISNULL(N'9416177639', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2014-11-24', [joiningDate]),
        [dob] = ISNULL(N'1992-08-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-11-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0956';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0959')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0959', N'KULDEEP SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'HARI SINGH', N'9540804308', NULL, N'2015-01-02', N'1993-08-23', N'Jr. Engineer', N'2015-01-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'KULDEEP SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'HARI SINGH', [fatherName]),
        [mobile] = ISNULL(N'9540804308', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-02', [joiningDate]),
        [dob] = ISNULL(N'1993-08-23', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0959';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0961')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0961', N'ROHIT PAHWA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'R. K. PAHWA', N'9810423968', NULL, N'2015-01-02', N'1995-05-04', N'Jr. Engineer', N'2015-01-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ROHIT PAHWA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'R. K. PAHWA', [fatherName]),
        [mobile] = ISNULL(N'9810423968', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-02', [joiningDate]),
        [dob] = ISNULL(N'1995-05-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0961';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0964')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0964', N'MONU MALIK', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMPAL MALIK', N'9990665262', NULL, N'2015-01-02', N'1994-05-19', N'Jr. Engineer', N'2015-01-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MONU MALIK', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMPAL MALIK', [fatherName]),
        [mobile] = ISNULL(N'9990665262', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-02', [joiningDate]),
        [dob] = ISNULL(N'1994-05-19', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0964';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0967')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0967', N'VIJAY', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMPHAL', N'9050564847', NULL, N'2015-01-02', N'1994-07-28', N'Jr. Engineer', N'2015-01-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'VIJAY', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMPHAL', [fatherName]),
        [mobile] = ISNULL(N'9050564847', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-02', [joiningDate]),
        [dob] = ISNULL(N'1994-07-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0967';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0972')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0972', N'PRASHANT KUMAR RAI', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'HRIDAY NARAYAN RAI', N'9450954100', NULL, N'2015-01-28', N'1994-01-25', N'Jr. Engineer', N'2015-01-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'PRASHANT KUMAR RAI', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'HRIDAY NARAYAN RAI', [fatherName]),
        [mobile] = ISNULL(N'9450954100', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-28', [joiningDate]),
        [dob] = ISNULL(N'1994-01-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0972';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0974')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0974', N'MOHIT', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'DHARMBIR', N'8053014707', NULL, N'2015-01-27', N'1992-12-25', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MOHIT', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'DHARMBIR', [fatherName]),
        [mobile] = ISNULL(N'8053014707', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1992-12-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0974';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0975')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0975', N'Rohit', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'PRAMOD', N'9467727459', NULL, N'2015-01-27', N'1995-11-04', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rohit', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'PRAMOD', [fatherName]),
        [mobile] = ISNULL(N'9467727459', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1995-11-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0975';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0977')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0977', N'SANDEEP KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'VED PAL', N'7206157404', NULL, N'2015-01-27', N'1994-02-08', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SANDEEP KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'VED PAL', [fatherName]),
        [mobile] = ISNULL(N'7206157404', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1994-02-08', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0977';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0978')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0978', N'ANUBHAV PANDEY', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'JINTENDRA PANDEY', N'9136672715', N'pandeyanu281@gmail.com', N'2015-01-27', N'1996-08-03', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ANUBHAV PANDEY', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'JINTENDRA PANDEY', [fatherName]),
        [mobile] = ISNULL(N'9136672715', [mobile]),
        [email] = ISNULL(N'pandeyanu281@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1996-08-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0978';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0979')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0979', N'RAMESHWAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MOHAN SHYAM', N'7838584173', NULL, N'2015-01-27', N'1993-05-15', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RAMESHWAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MOHAN SHYAM', [fatherName]),
        [mobile] = ISNULL(N'7838584173', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1993-05-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0979';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0982')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0982', N'DEEPAK KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SURESH CHANDRA SINGH', N'7830758661', NULL, N'2015-01-27', N'1995-12-07', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'DEEPAK KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SURESH CHANDRA SINGH', [fatherName]),
        [mobile] = ISNULL(N'7830758661', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1995-12-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0982';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0986')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0986', N'VIKAS KUMAR GAUR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'DINANATH GAUR', N'9936339528', NULL, N'2015-01-27', N'1996-07-20', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'VIKAS KUMAR GAUR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'DINANATH GAUR', [fatherName]),
        [mobile] = ISNULL(N'9936339528', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1996-07-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0986';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0987')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0987', N'MANOJ', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MAHENDER SINGH', N'9050277576', N'manojsharma4400@gmail.com', N'2015-01-27', N'1992-07-05', N'Jr. Engineer', N'2015-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MANOJ', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MAHENDER SINGH', [fatherName]),
        [mobile] = ISNULL(N'9050277576', [mobile]),
        [email] = ISNULL(N'manojsharma4400@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-01-27', [joiningDate]),
        [dob] = ISNULL(N'1992-07-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0987';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0993')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0993', N'SAGUFI', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'MD. MANSOOR ALAM ANSARI', N'8802144607', NULL, N'2015-03-02', N'1995-04-12', N'Jr. Engineer', N'2015-03-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SAGUFI', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'MD. MANSOOR ALAM ANSARI', [fatherName]),
        [mobile] = ISNULL(N'8802144607', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-03-02', [joiningDate]),
        [dob] = ISNULL(N'1995-04-12', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-03-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0993';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0995')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0995', N'SHAKTI DEEP', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'SATPAL SINGH', N'9812777725', NULL, N'2015-03-02', N'1991-06-25', N'Jr. Engineer', N'2015-03-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SHAKTI DEEP', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'SATPAL SINGH', [fatherName]),
        [mobile] = ISNULL(N'9812777725', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-03-02', [joiningDate]),
        [dob] = ISNULL(N'1991-06-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-03-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0995';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0996')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0996', N'SACHIN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'KRISHAN SHARMA', N'8901293483', NULL, N'2015-03-02', N'1995-01-17', N'Jr. Engineer', N'2015-03-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SACHIN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'KRISHAN SHARMA', [fatherName]),
        [mobile] = ISNULL(N'8901293483', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2015-03-02', [joiningDate]),
        [dob] = ISNULL(N'1995-01-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-03-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0996';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1004')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1004', N'Mukesh Kumar Pradhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Gopal Krishna Pradhan', N'9776200975', N'mukeshpradhan1400@gmail.com', N'2018-06-26', N'2000-04-01', N'Jr. Engineer', N'2018-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mukesh Kumar Pradhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Gopal Krishna Pradhan', [fatherName]),
        [mobile] = ISNULL(N'9776200975', [mobile]),
        [email] = ISNULL(N'mukeshpradhan1400@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-06-26', [joiningDate]),
        [dob] = ISNULL(N'2000-04-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1004';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1005')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1005', N'Ankit Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sompal Singh', N'8868024971', N'ankitsainisaini100@gmail.com', N'2018-06-26', N'1996-02-05', N'Jr. Engineer', N'2018-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankit Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sompal Singh', [fatherName]),
        [mobile] = ISNULL(N'8868024971', [mobile]),
        [email] = ISNULL(N'ankitsainisaini100@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-06-26', [joiningDate]),
        [dob] = ISNULL(N'1996-02-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1005';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1008')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1008', N'Lalu Prasad Sahu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Parshuram Sahu', N'7377129852', N'sahulaluprasad9861@gmail.com', N'2018-06-26', N'2000-01-01', N'Jr. Engineer', N'2018-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lalu Prasad Sahu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Parshuram Sahu', [fatherName]),
        [mobile] = ISNULL(N'7377129852', [mobile]),
        [email] = ISNULL(N'sahulaluprasad9861@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-06-26', [joiningDate]),
        [dob] = ISNULL(N'2000-01-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1008';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1009')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1009', N'Rinkel Kumar Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Trilochan Behera', N'9114177082', N'rinkelkumarbehera322@gmail.com', N'2018-06-26', N'2000-03-08', N'Jr. Engineer', N'2018-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rinkel Kumar Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Trilochan Behera', [fatherName]),
        [mobile] = ISNULL(N'9114177082', [mobile]),
        [email] = ISNULL(N'rinkelkumarbehera322@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-06-26', [joiningDate]),
        [dob] = ISNULL(N'2000-03-08', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1009';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1015')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1015', N'Badal Kumar Bhola', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Panchanan Bhola', N'7440170625', N'badalbhola111@gmail.com', N'2018-06-26', N'1998-05-04', N'Jr. Engineer', N'2018-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Badal Kumar Bhola', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Panchanan Bhola', [fatherName]),
        [mobile] = ISNULL(N'7440170625', [mobile]),
        [email] = ISNULL(N'badalbhola111@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-06-26', [joiningDate]),
        [dob] = ISNULL(N'1998-05-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1015';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1045')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1045', N'K. Chinna Rao', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'K. Raju', N'8789910750', N'K.Chinnarao26@gmail.com', N'2018-12-28', N'1998-01-26', N'Jr. Engineer', N'2018-12-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'K. Chinna Rao', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'K. Raju', [fatherName]),
        [mobile] = ISNULL(N'8789910750', [mobile]),
        [email] = ISNULL(N'K.Chinnarao26@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-12-28', [joiningDate]),
        [dob] = ISNULL(N'1998-01-26', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-12-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1045';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1056')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1056', N'Ruchika', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Balwan Singh', N'7428688954', N'thakurruchika876@gmail.com', N'2019-01-29', N'1998-08-09', N'Jr. Engineer', N'2019-01-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ruchika', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Balwan Singh', [fatherName]),
        [mobile] = ISNULL(N'7428688954', [mobile]),
        [email] = ISNULL(N'thakurruchika876@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2019-01-29', [joiningDate]),
        [dob] = ISNULL(N'1998-08-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2019-01-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1056';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1088')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1088', N'Shivam Saini', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sanjay Saini', N'7500917672', N'sainisk176@gmail.com', N'2020-02-26', N'2000-01-24', N'Jr. Engineer', N'2020-02-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivam Saini', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sanjay Saini', [fatherName]),
        [mobile] = ISNULL(N'7500917672', [mobile]),
        [email] = ISNULL(N'sainisk176@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-02-26', [joiningDate]),
        [dob] = ISNULL(N'2000-01-24', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-02-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1088';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1092')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1092', N'Manju', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitGurugram, @deptGgn,
        N'Narendra Kumar', N'8628089146', N'thakurmanju71998@gmail.com', N'2020-02-26', N'1999-01-07', N'Engineer', N'2020-02-26', N'M3-D'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manju', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Narendra Kumar', [fatherName]),
        [mobile] = ISNULL(N'8628089146', [mobile]),
        [email] = ISNULL(N'thakurmanju71998@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-02-26', [joiningDate]),
        [dob] = ISNULL(N'1999-01-07', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-02-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-D', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1092';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1102')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1102', N'Ragni Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dharminder Rawat', N'8448342776', N'sona01011999@gmail.com', N'2020-11-06', N'1999-01-01', N'Jr. Engineer', N'2020-11-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ragni Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dharminder Rawat', [fatherName]),
        [mobile] = ISNULL(N'8448342776', [mobile]),
        [email] = ISNULL(N'sona01011999@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-11-06', [joiningDate]),
        [dob] = ISNULL(N'1999-01-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-11-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1102';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1108')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1108', N'Shubham Pandey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Chandra Bhushan Pandey', N'7234065158', N'ap53068@gmail.com', N'2020-11-06', N'2000-07-12', N'Jr. Engineer', N'2020-11-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubham Pandey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Chandra Bhushan Pandey', [fatherName]),
        [mobile] = ISNULL(N'7234065158', [mobile]),
        [email] = ISNULL(N'ap53068@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-11-06', [joiningDate]),
        [dob] = ISNULL(N'2000-07-12', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-11-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1108';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1109')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1109', N'Shubham Ranaut', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sunil Kumar', N'9877332698', N'sranaut55@gmail.com', N'2020-11-06', N'1999-10-20', N'Jr. Engineer', N'2020-11-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubham Ranaut', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sunil Kumar', [fatherName]),
        [mobile] = ISNULL(N'9877332698', [mobile]),
        [email] = ISNULL(N'sranaut55@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-11-06', [joiningDate]),
        [dob] = ISNULL(N'1999-10-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-11-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1109';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1115')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1115', N'Anjali Devi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Kashmir Singh', N'9857551320', N'saklanianjali10@gmail.com', N'2021-04-12', N'2000-05-10', N'Jr. Engineer', N'2021-04-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anjali Devi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Kashmir Singh', [fatherName]),
        [mobile] = ISNULL(N'9857551320', [mobile]),
        [email] = ISNULL(N'saklanianjali10@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-04-12', [joiningDate]),
        [dob] = ISNULL(N'2000-05-10', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-04-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1115';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1118')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1118', N'ANKIT SAHU', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Madan Sahu', N'9801795255', N'ankitsahu0172@gmail.com', N'2021-06-26', N'2002-07-17', N'Jr. Engineer', N'2021-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ANKIT SAHU', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Madan Sahu', [fatherName]),
        [mobile] = ISNULL(N'9801795255', [mobile]),
        [email] = ISNULL(N'ankitsahu0172@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-06-26', [joiningDate]),
        [dob] = ISNULL(N'2002-07-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1118';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1119')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1119', N'BIRENDRA MAHTO', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Narayan Mahto', N'6206926889', N'rajbiru739@gmail.com', N'2021-06-26', N'2002-02-05', N'Jr. Engineer', N'2021-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'BIRENDRA MAHTO', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Narayan Mahto', [fatherName]),
        [mobile] = ISNULL(N'6206926889', [mobile]),
        [email] = ISNULL(N'rajbiru739@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-06-26', [joiningDate]),
        [dob] = ISNULL(N'2002-02-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1119';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1134')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1134', N'Manish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Bhagwan Singh', N'8219290802', N'manish7832076056@gmail.com', N'2021-12-18', N'2000-08-18', N'Jr. Engineer', N'2021-12-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Bhagwan Singh', [fatherName]),
        [mobile] = ISNULL(N'8219290802', [mobile]),
        [email] = ISNULL(N'manish7832076056@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-12-18', [joiningDate]),
        [dob] = ISNULL(N'2000-08-18', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-12-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1134';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1136')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1136', N'Satabdi Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sanjay Thakur', N'6207701379', N'satabditha050@gmail.com', N'2021-12-18', N'2003-01-01', N'Jr. Engineer', N'2021-12-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Satabdi Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sanjay Thakur', [fatherName]),
        [mobile] = ISNULL(N'6207701379', [mobile]),
        [email] = ISNULL(N'satabditha050@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-12-18', [joiningDate]),
        [dob] = ISNULL(N'2003-01-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-12-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1136';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1138')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1138', N'Shivangi Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shambhu Yadav', N'9651065040', N'khusbhuyadav5002@gmail.com', N'2021-12-18', N'2002-05-10', N'Jr. Engineer', N'2021-12-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivangi Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shambhu Yadav', [fatherName]),
        [mobile] = ISNULL(N'9651065040', [mobile]),
        [email] = ISNULL(N'khusbhuyadav5002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-12-18', [joiningDate]),
        [dob] = ISNULL(N'2002-05-10', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-12-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1138';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1140')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1140', N'SONIYA Bidaliya', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ramesh Chandra', N'9084079724', N'soniyabidaliya123@gmail.com', N'2021-12-15', N'2000-02-05', N'Jr. Engineer', N'2021-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SONIYA Bidaliya', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ramesh Chandra', [fatherName]),
        [mobile] = ISNULL(N'9084079724', [mobile]),
        [email] = ISNULL(N'soniyabidaliya123@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-12-15', [joiningDate]),
        [dob] = ISNULL(N'2000-02-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1140';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1141')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1141', N'Jagriti Prajapati', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dharmendra Prajapati', N'6388022298', N'jagriti2298@gmail.com', N'2021-12-15', N'2001-10-09', N'Jr. Engineer', N'2021-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jagriti Prajapati', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dharmendra Prajapati', [fatherName]),
        [mobile] = ISNULL(N'6388022298', [mobile]),
        [email] = ISNULL(N'jagriti2298@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-12-15', [joiningDate]),
        [dob] = ISNULL(N'2001-10-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1141';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1147')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1147', N'Usha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Saravan Mahato', N'7091446249', N'ushavs1523@gmail.com', N'2022-01-28', N'2003-02-15', N'Jr. Engineer', N'2022-01-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Usha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Saravan Mahato', [fatherName]),
        [mobile] = ISNULL(N'7091446249', [mobile]),
        [email] = ISNULL(N'ushavs1523@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-01-28', [joiningDate]),
        [dob] = ISNULL(N'2003-02-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-01-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1147';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1148')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1148', N'Jyoti Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Munna Das', N'9643491229', N'jyotii0607@gmail.com', N'2022-01-24', N'2000-07-06', N'Jr. Engineer', N'2022-01-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jyoti Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Munna Das', [fatherName]),
        [mobile] = ISNULL(N'9643491229', [mobile]),
        [email] = ISNULL(N'jyotii0607@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-01-24', [joiningDate]),
        [dob] = ISNULL(N'2000-07-06', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-01-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1148';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1149')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1149', N'Reetu Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajesh Kumar', N'9026103536', N'reetukumari.iert@gmail.com', N'2022-01-24', N'2002-06-25', N'Jr. Engineer', N'2022-01-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Reetu Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'9026103536', [mobile]),
        [email] = ISNULL(N'reetukumari.iert@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-01-24', [joiningDate]),
        [dob] = ISNULL(N'2002-06-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-01-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1149';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1152')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1152', N'Nidhi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Nemisharan', N'7668509684', N'nidhidhiman142@gmail.com', N'2022-02-14', N'2001-02-14', N'Jr. Engineer', N'2022-02-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nidhi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Nemisharan', [fatherName]),
        [mobile] = ISNULL(N'7668509684', [mobile]),
        [email] = ISNULL(N'nidhidhiman142@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2001-02-14', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1152';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1153')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1153', N'Raunak Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Kedar Pandit', N'9123147623', N'raunakraj318@gmail.com', N'2022-02-14', N'2001-02-20', N'Jr. Engineer', N'2022-02-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raunak Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Kedar Pandit', [fatherName]),
        [mobile] = ISNULL(N'9123147623', [mobile]),
        [email] = ISNULL(N'raunakraj318@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2001-02-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1153';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1155')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1155', N'Shivam Kumar Upadhyay', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ashok Kumar Upadhyay', N'8340387206', N'shivamkumarupadhyay001@gmail.com', N'2022-02-14', N'2002-01-25', N'Jr. Engineer', N'2022-02-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivam Kumar Upadhyay', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ashok Kumar Upadhyay', [fatherName]),
        [mobile] = ISNULL(N'8340387206', [mobile]),
        [email] = ISNULL(N'shivamkumarupadhyay001@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2002-01-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1155';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1157')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1157', N'Piyush Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dinesh Kumar', N'8171586899', N'piyushkumartmu.68@gmail.com', N'2022-02-14', N'2001-12-12', N'Jr. Engineer', N'2022-02-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Piyush Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dinesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'8171586899', [mobile]),
        [email] = ISNULL(N'piyushkumartmu.68@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2001-12-12', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1157';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1160')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1160', N'Kanchan Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jhunilal Nayak', N'7903833998', N'kanchankumari.orla@gmail.com', N'2022-03-05', N'2003-01-13', N'Jr. Engineer', N'2022-03-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kanchan Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jhunilal Nayak', [fatherName]),
        [mobile] = ISNULL(N'7903833998', [mobile]),
        [email] = ISNULL(N'kanchankumari.orla@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-03-05', [joiningDate]),
        [dob] = ISNULL(N'2003-01-13', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1160';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1161')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1161', N'Kiran Munda', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jagrnath Munda', N'7654013049', N'kiran2542003@gmail.com', N'2022-03-05', N'2003-01-01', N'Jr. Engineer', N'2022-03-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kiran Munda', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jagrnath Munda', [fatherName]),
        [mobile] = ISNULL(N'7654013049', [mobile]),
        [email] = ISNULL(N'kiran2542003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-03-05', [joiningDate]),
        [dob] = ISNULL(N'2003-01-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1161';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1163')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1163', N'Anil Pal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Babu Lal Pal', N'6393612540', N'anilpal274204@gmail.com', N'2022-03-05', N'2000-08-05', N'Jr. Engineer', N'2022-03-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anil Pal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Babu Lal Pal', [fatherName]),
        [mobile] = ISNULL(N'6393612540', [mobile]),
        [email] = ISNULL(N'anilpal274204@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-03-05', [joiningDate]),
        [dob] = ISNULL(N'2000-08-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1163';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1171')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1171', N'Deepak Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Surjeet', N'8605776303', N'aadyand83@gmail.com', N'2022-11-01', N'2002-10-07', N'OE', N'2022-11-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Surjeet', [fatherName]),
        [mobile] = ISNULL(N'8605776303', [mobile]),
        [email] = ISNULL(N'aadyand83@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-01', [joiningDate]),
        [dob] = ISNULL(N'2002-10-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1171';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1175')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1175', N'Ajeet Pandey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Awadhesh Pandey', N'6387012681', N'ajeetpandeyji96@gmail.com', N'2022-11-04', N'2001-09-01', N'OE', N'2022-11-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ajeet Pandey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Awadhesh Pandey', [fatherName]),
        [mobile] = ISNULL(N'6387012681', [mobile]),
        [email] = ISNULL(N'ajeetpandeyji96@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-04', [joiningDate]),
        [dob] = ISNULL(N'2001-09-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1175';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1177')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1177', N'Nitesh Kushwaha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Surender singh', N'8726602549', N'niteshkushwaha53@gmail.com', N'2022-11-10', N'2001-05-07', N'OE', N'2022-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitesh Kushwaha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Surender singh', [fatherName]),
        [mobile] = ISNULL(N'8726602549', [mobile]),
        [email] = ISNULL(N'niteshkushwaha53@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-10', [joiningDate]),
        [dob] = ISNULL(N'2001-05-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1177';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1181')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1181', N'Nitish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sachinder Nath', N'9875754688', N'nksingh987575@gmail.com', N'2022-11-10', N'2002-04-13', N'OE', N'2022-11-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sachinder Nath', [fatherName]),
        [mobile] = ISNULL(N'9875754688', [mobile]),
        [email] = ISNULL(N'nksingh987575@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-10', [joiningDate]),
        [dob] = ISNULL(N'2002-04-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1181';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1184')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1184', N'Anshu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        NULL, N'8979714219', N'anshurajput036@gmail.com', N'2023-01-16', N'2001-06-15', N'OE', N'2023-01-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anshu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'8979714219', [mobile]),
        [email] = ISNULL(N'anshurajput036@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-01-16', [joiningDate]),
        [dob] = ISNULL(N'2001-06-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-01-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1184';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1185')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1185', N'Yogendra Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ram Veer Singh', N'8287003500', N'sachin9005403852@gmail.com', N'2023-07-07', N'2002-10-11', N'OE', N'2023-07-07', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Yogendra Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ram Veer Singh', [fatherName]),
        [mobile] = ISNULL(N'8287003500', [mobile]),
        [email] = ISNULL(N'sachin9005403852@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-07-07', [joiningDate]),
        [dob] = ISNULL(N'2002-10-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-07-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1185';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1187')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1187', N'Roshni Mishra', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Anil Kumar Mishra', N'8130367517', N'mishraroshni8130@gmail.com', N'2023-07-17', N'2004-02-20', N'Jr. Engineer', N'2022-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Roshni Mishra', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Anil Kumar Mishra', [fatherName]),
        [mobile] = ISNULL(N'8130367517', [mobile]),
        [email] = ISNULL(N'mishraroshni8130@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-07-17', [joiningDate]),
        [dob] = ISNULL(N'2004-02-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1187';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1188')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1188', N'Km Sheetal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Keshar Dev', N'7409955856', N'sheetalsingh567543@gmail.com', N'2023-07-17', N'2002-07-04', N'Jr. Engineer', N'2022-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Km Sheetal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Keshar Dev', [fatherName]),
        [mobile] = ISNULL(N'7409955856', [mobile]),
        [email] = ISNULL(N'sheetalsingh567543@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-07-17', [joiningDate]),
        [dob] = ISNULL(N'2002-07-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1188';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1189')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1189', N'Dolly Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Anil Singh', N'9507294665', N'dollysingh4009@gmail.com', N'2023-05-01', N'2004-12-21', N'OE', N'2023-05-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dolly Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Anil Singh', [fatherName]),
        [mobile] = ISNULL(N'9507294665', [mobile]),
        [email] = ISNULL(N'dollysingh4009@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-01', [joiningDate]),
        [dob] = ISNULL(N'2004-12-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1189';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1190')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1190', N'Rahul Prajapati', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Radheshyam', N'8957199497', N'rahulp16102002@gmail.com', N'2023-10-05', N'2002-10-16', N'OE', N'2023-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul Prajapati', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Radheshyam', [fatherName]),
        [mobile] = ISNULL(N'8957199497', [mobile]),
        [email] = ISNULL(N'rahulp16102002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-05', [joiningDate]),
        [dob] = ISNULL(N'2002-10-16', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1190';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1192')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1192', N'Sakshi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Raju Sharma', N'9305612743', N'sakshi28032020@gmail.com', N'2023-10-05', N'2002-09-07', N'OE', N'2023-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sakshi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Raju Sharma', [fatherName]),
        [mobile] = ISNULL(N'9305612743', [mobile]),
        [email] = ISNULL(N'sakshi28032020@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-05', [joiningDate]),
        [dob] = ISNULL(N'2002-09-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1192';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1193')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1193', N'Kajal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Santlal', N'6392615721', N'kumars02891@gmail.com', N'2023-10-05', N'2004-07-23', N'OE', N'2023-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kajal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Santlal', [fatherName]),
        [mobile] = ISNULL(N'6392615721', [mobile]),
        [email] = ISNULL(N'kumars02891@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-05', [joiningDate]),
        [dob] = ISNULL(N'2004-07-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1193';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1196')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1196', N'Vaishnavi Sahu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sateesh Chandra Sahu', N'9076720490', N'vaishnavi.sahu2003@gmail.com', N'2023-10-05', N'2003-12-08', N'OE', N'2023-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vaishnavi Sahu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sateesh Chandra Sahu', [fatherName]),
        [mobile] = ISNULL(N'9076720490', [mobile]),
        [email] = ISNULL(N'vaishnavi.sahu2003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-05', [joiningDate]),
        [dob] = ISNULL(N'2003-12-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1196';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1197')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1197', N'Shivansh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajiv Gupta', N'9988000514', N'shivanshgupta6284@gmail.com', N'2023-10-05', N'2005-08-26', N'OE', N'2023-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivansh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajiv Gupta', [fatherName]),
        [mobile] = ISNULL(N'9988000514', [mobile]),
        [email] = ISNULL(N'shivanshgupta6284@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-05', [joiningDate]),
        [dob] = ISNULL(N'2005-08-26', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1197';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1198')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1198', N'Shivani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'BHAGAT SINGH', N'9696092347', N'shivanishivani85844@gmail.com', N'2023-12-01', N'2004-06-06', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'BHAGAT SINGH', [fatherName]),
        [mobile] = ISNULL(N'9696092347', [mobile]),
        [email] = ISNULL(N'shivanishivani85844@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2004-06-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1198';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1199')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1199', N'Sonam Kewat', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Hardayal Kewat', N'9569494638', N'sonamkewat929@gmail.com', N'2023-12-01', N'2004-04-21', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sonam Kewat', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Hardayal Kewat', [fatherName]),
        [mobile] = ISNULL(N'9569494638', [mobile]),
        [email] = ISNULL(N'sonamkewat929@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2004-04-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1199';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1200')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1200', N'ANSHIKA RANA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'jagmohan singh Rana', N'8393033792', N'anshikarana511@gmail.com', N'2023-12-01', N'2004-01-05', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ANSHIKA RANA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'jagmohan singh Rana', [fatherName]),
        [mobile] = ISNULL(N'8393033792', [mobile]),
        [email] = ISNULL(N'anshikarana511@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2004-01-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1200';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1201')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1201', N'ANMOL SINGH GURIYAL', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Purushottam singh Guriyal', N'7088372030', N'anmolguriyal123456@gmail.com', N'2023-12-01', N'2003-02-25', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ANMOL SINGH GURIYAL', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Purushottam singh Guriyal', [fatherName]),
        [mobile] = ISNULL(N'7088372030', [mobile]),
        [email] = ISNULL(N'anmolguriyal123456@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2003-02-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1201';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1203')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1203', N'CHANDANI ARYA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Praveen Ram', N'8057565825', NULL, N'2023-12-01', N'2002-08-07', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'CHANDANI ARYA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Praveen Ram', [fatherName]),
        [mobile] = ISNULL(N'8057565825', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2002-08-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1203';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1205')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1205', N'ANUJ KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shiv kumar', N'7217430512', NULL, N'2023-12-01', N'2003-05-05', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ANUJ KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shiv kumar', [fatherName]),
        [mobile] = ISNULL(N'7217430512', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2003-05-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1205';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1206')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1206', N'RAJ KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'VEER SINGH', N'9105735054', N'rajsaini9105735054@gmail.com', N'2023-12-01', N'2003-07-13', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RAJ KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'VEER SINGH', [fatherName]),
        [mobile] = ISNULL(N'9105735054', [mobile]),
        [email] = ISNULL(N'rajsaini9105735054@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2003-07-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1206';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1207')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1207', N'AAKASH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'LALJI', N'9115343816', NULL, N'2023-12-01', N'2003-02-06', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AAKASH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'LALJI', [fatherName]),
        [mobile] = ISNULL(N'9115343816', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2003-02-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1207';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1209')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1209', N'AKHILESH SINGH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Nagina Singh', N'9198969995', NULL, N'2023-12-01', N'2002-04-02', N'OE', N'2023-12-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AKHILESH SINGH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Nagina Singh', [fatherName]),
        [mobile] = ISNULL(N'9198969995', [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2023-12-01', [joiningDate]),
        [dob] = ISNULL(N'2002-04-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1209';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1210')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1210', N'BHAWNA VERMA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Tularam', N'9569860658', N'bhawnaverma0703@gmail.com', N'2024-01-01', N'2003-07-12', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'BHAWNA VERMA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Tularam', [fatherName]),
        [mobile] = ISNULL(N'9569860658', [mobile]),
        [email] = ISNULL(N'bhawnaverma0703@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2003-07-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1210';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1211')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1211', N'JAGDISH BISHT', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Devndra Singh Bisht', N'8218254674', N'jagdishbisht213@gmail.com', N'2024-01-01', N'2003-06-17', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'JAGDISH BISHT', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Devndra Singh Bisht', [fatherName]),
        [mobile] = ISNULL(N'8218254674', [mobile]),
        [email] = ISNULL(N'jagdishbisht213@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2003-06-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1211';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1213')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1213', N'ARPITA YADAV', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Lakhan Yadav', N'6387273739', N'yarpita971@gmail.com', N'2024-01-01', N'2004-07-02', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ARPITA YADAV', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Lakhan Yadav', [fatherName]),
        [mobile] = ISNULL(N'6387273739', [mobile]),
        [email] = ISNULL(N'yarpita971@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2004-07-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1213';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1214')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1214', N'DIVYA CHAUHAN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Raju Chauhan', N'8077522730', N'dchauhan6406@gmail.com', N'2024-01-01', N'2002-04-30', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'DIVYA CHAUHAN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Raju Chauhan', [fatherName]),
        [mobile] = ISNULL(N'8077522730', [mobile]),
        [email] = ISNULL(N'dchauhan6406@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2002-04-30', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1214';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1215')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1215', N'NEERAJ CHAUDHARY', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ram Parkash', N'8004590711', N'neerajpatalpatal@gmail.com', N'2024-01-01', N'2003-03-10', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'NEERAJ CHAUDHARY', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ram Parkash', [fatherName]),
        [mobile] = ISNULL(N'8004590711', [mobile]),
        [email] = ISNULL(N'neerajpatalpatal@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2003-03-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1215';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1216')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1216', N'AAYUSH SHARMA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sunil Sharma', N'9795020690', N'aayushsharma6391@gmail.com', N'2024-01-01', N'2005-04-11', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AAYUSH SHARMA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sunil Sharma', [fatherName]),
        [mobile] = ISNULL(N'9795020690', [mobile]),
        [email] = ISNULL(N'aayushsharma6391@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2005-04-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1216';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1219')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1219', N'BARHAM KUMAR', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Umesh mochi', N'7635098218', N'barhanfatuha976@gmail.com', N'2024-01-01', N'2004-04-13', N'OE', N'2024-01-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'BARHAM KUMAR', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Umesh mochi', [fatherName]),
        [mobile] = ISNULL(N'7635098218', [mobile]),
        [email] = ISNULL(N'barhanfatuha976@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-01', [joiningDate]),
        [dob] = ISNULL(N'2004-04-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1219';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1220')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1220', N'Rahul Pal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sahab Singh', NULL, NULL, N'2024-02-01', N'2003-08-17', N'Operating Engineer', N'2024-02-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul Pal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sahab Singh', [fatherName]),
        [mobile] = ISNULL(NULL, [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(N'2024-02-01', [joiningDate]),
        [dob] = ISNULL(N'2003-08-17', [dob]),
        [designation] = ISNULL(N'Operating Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-02-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1220';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1222')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1222', N'Nitish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ramesh Kumar', N'7351088768', N'nk3713392@gmail.com', N'2024-03-01', N'2002-10-09', N'OE', N'2024-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ramesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'7351088768', [mobile]),
        [email] = ISNULL(N'nk3713392@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-03-01', [joiningDate]),
        [dob] = ISNULL(N'2002-10-09', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1222';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1224')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1224', N'Raushan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Parmanand Chaurasia', N'6283301877', N'rk2913030@gmail.com', N'2024-03-01', N'2003-01-14', N'OE', N'2024-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raushan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Parmanand Chaurasia', [fatherName]),
        [mobile] = ISNULL(N'6283301877', [mobile]),
        [email] = ISNULL(N'rk2913030@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-03-01', [joiningDate]),
        [dob] = ISNULL(N'2003-01-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1224';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1225')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1225', N'Aditya Dubey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Anil Kumar Dubey', N'7398773507', N'ad701777@gmail.com', N'2024-03-01', N'2002-08-12', N'OE', N'2024-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aditya Dubey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Anil Kumar Dubey', [fatherName]),
        [mobile] = ISNULL(N'7398773507', [mobile]),
        [email] = ISNULL(N'ad701777@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-03-01', [joiningDate]),
        [dob] = ISNULL(N'2002-08-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1225';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1226')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1226', N'Richa', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Arun Kumar', N'7300891043', N'Richakushwaha7520@gmail.com', N'2024-03-01', N'2003-03-10', N'OE', N'2024-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Richa', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Arun Kumar', [fatherName]),
        [mobile] = ISNULL(N'7300891043', [mobile]),
        [email] = ISNULL(N'Richakushwaha7520@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-03-01', [joiningDate]),
        [dob] = ISNULL(N'2003-03-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1226';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1230')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1230', N'Badal Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Degnarayan Mahto', N'9508889199', N'badalkumar6336@gmail.com', N'2024-03-01', N'2003-10-08', N'OE', N'2024-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Badal Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Degnarayan Mahto', [fatherName]),
        [mobile] = ISNULL(N'9508889199', [mobile]),
        [email] = ISNULL(N'badalkumar6336@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-03-01', [joiningDate]),
        [dob] = ISNULL(N'2003-10-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1230';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1231')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1231', N'Nidhi Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Indrajit Singh', N'9094946127', N'nidhisingh19685@gmail.com', N'2024-04-08', N'2005-07-11', N'OE', N'2024-04-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nidhi Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Indrajit Singh', [fatherName]),
        [mobile] = ISNULL(N'9094946127', [mobile]),
        [email] = ISNULL(N'nidhisingh19685@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-04-08', [joiningDate]),
        [dob] = ISNULL(N'2005-07-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-04-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1231';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1232')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1232', N'Amandeep Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sultan Singh', N'7248747298', N'ad6309951@gmail.com', N'2024-04-08', N'2002-06-21', N'OE', N'2024-04-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Amandeep Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sultan Singh', [fatherName]),
        [mobile] = ISNULL(N'7248747298', [mobile]),
        [email] = ISNULL(N'ad6309951@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-04-08', [joiningDate]),
        [dob] = ISNULL(N'2002-06-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-04-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1232';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1233')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1233', N'Nikesh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jagdamba Prasad', N'9198698103', N'nkmzp2132@gmail.com', N'2024-04-08', N'2002-12-13', N'OE', N'2024-04-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nikesh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jagdamba Prasad', [fatherName]),
        [mobile] = ISNULL(N'9198698103', [mobile]),
        [email] = ISNULL(N'nkmzp2132@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-04-08', [joiningDate]),
        [dob] = ISNULL(N'2002-12-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-04-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1233';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1234')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1234', N'Muskan Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Prabhu Dayal Baitha', N'8092688828', N'muskankumari84924@gmail.com', N'2024-04-08', N'2005-03-23', N'OE', N'2024-04-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muskan Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Prabhu Dayal Baitha', [fatherName]),
        [mobile] = ISNULL(N'8092688828', [mobile]),
        [email] = ISNULL(N'muskankumari84924@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-04-08', [joiningDate]),
        [dob] = ISNULL(N'2005-03-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-04-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1234';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1236')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1236', N'Naveen Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajbir', N'9350607921', N'naveenpanchal033@gmail.com', N'2024-07-08', N'2004-01-08', N'OE', N'2024-07-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Naveen Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajbir', [fatherName]),
        [mobile] = ISNULL(N'9350607921', [mobile]),
        [email] = ISNULL(N'naveenpanchal033@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-08', [joiningDate]),
        [dob] = ISNULL(N'2004-01-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1236';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1237')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1237', N'AshrafGaddi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Anil gaddi', N'9569619721', N'gaddiashraf0194@gmail.com', N'2024-07-08', N'2001-09-05', N'OE', N'2024-07-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'AshrafGaddi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Anil gaddi', [fatherName]),
        [mobile] = ISNULL(N'9569619721', [mobile]),
        [email] = ISNULL(N'gaddiashraf0194@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-08', [joiningDate]),
        [dob] = ISNULL(N'2001-09-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1237';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1239')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1239', N'Simran Kumari Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Lt. Shashi Bhusan Kumar Singh', N'6203061877', N'bebid235@gmail.com', N'2024-08-27', N'2006-01-01', N'OE', N'2024-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Simran Kumari Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Lt. Shashi Bhusan Kumar Singh', [fatherName]),
        [mobile] = ISNULL(N'6203061877', [mobile]),
        [email] = ISNULL(N'bebid235@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-27', [joiningDate]),
        [dob] = ISNULL(N'2006-01-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1239';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1240')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1240', N'Annu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shankar', N'7015790673', N'jangraannu96@gmail.com', N'2024-08-27', N'2004-12-23', N'OE', N'2024-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Annu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shankar', [fatherName]),
        [mobile] = ISNULL(N'7015790673', [mobile]),
        [email] = ISNULL(N'jangraannu96@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-27', [joiningDate]),
        [dob] = ISNULL(N'2004-12-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1240';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1242')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1242', N'Nitin', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jagdish', N'8307278528', N'r43707275@gmail.com', N'2024-08-27', N'2003-08-30', N'OE', N'2024-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitin', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jagdish', [fatherName]),
        [mobile] = ISNULL(N'8307278528', [mobile]),
        [email] = ISNULL(N'r43707275@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-27', [joiningDate]),
        [dob] = ISNULL(N'2003-08-30', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1242';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1243')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1243', N'Muskan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Amit prasad', N'7209051977', N'kyayaarmuskan@gmail.com', N'2024-08-27', N'2004-03-17', N'OE', N'2024-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muskan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Amit prasad', [fatherName]),
        [mobile] = ISNULL(N'7209051977', [mobile]),
        [email] = ISNULL(N'kyayaarmuskan@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-27', [joiningDate]),
        [dob] = ISNULL(N'2004-03-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1243';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1245')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1245', N'Puja Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Birendra Mahto', N'6299729950', N'pujakumari792003@gmail.com', N'2024-08-27', N'2005-07-05', N'OE', N'2024-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Puja Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Birendra Mahto', [fatherName]),
        [mobile] = ISNULL(N'6299729950', [mobile]),
        [email] = ISNULL(N'pujakumari792003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-27', [joiningDate]),
        [dob] = ISNULL(N'2005-07-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1245';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1247')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1247', N'Mohan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Netram Singh', N'9528905704', N'Mohansingh61522@gmail.com', N'2024-09-03', N'2003-08-15', N'OE', N'2024-09-03', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Netram Singh', [fatherName]),
        [mobile] = ISNULL(N'9528905704', [mobile]),
        [email] = ISNULL(N'Mohansingh61522@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-09-03', [joiningDate]),
        [dob] = ISNULL(N'2003-08-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-09-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1247';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1250')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1250', N'Nikita Sahani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ravindra Kumar', N'8318607978', N'sahaninikita500@gmail.com', N'2024-10-07', N'2006-07-21', N'OE', N'2024-10-07', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nikita Sahani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ravindra Kumar', [fatherName]),
        [mobile] = ISNULL(N'8318607978', [mobile]),
        [email] = ISNULL(N'sahaninikita500@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-10-07', [joiningDate]),
        [dob] = ISNULL(N'2006-07-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-10-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1250';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1251')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1251', N'Piyush Tiwari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Govind Tiwari', N'9752706134', N'piyushtiwari099p@gmail.com', N'2024-11-04', N'2004-04-05', N'OE', N'2024-11-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Piyush Tiwari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Govind Tiwari', [fatherName]),
        [mobile] = ISNULL(N'9752706134', [mobile]),
        [email] = ISNULL(N'piyushtiwari099p@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-11-04', [joiningDate]),
        [dob] = ISNULL(N'2004-04-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-11-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1251';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1252')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1252', N'Nandani Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Prem Chand Bharti', N'6203779857', N'Nanndinibharti@gmail.com', N'2024-11-23', N'2003-08-29', N'OE', N'2024-11-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nandani Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Prem Chand Bharti', [fatherName]),
        [mobile] = ISNULL(N'6203779857', [mobile]),
        [email] = ISNULL(N'Nanndinibharti@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-11-23', [joiningDate]),
        [dob] = ISNULL(N'2003-08-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-11-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1252';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1254')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1254', N'Anuradha Gupta', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vijay Kumar Gupta', N'8874638903', N'guptaanu8874@gmail.com', N'2025-01-27', N'2005-10-27', N'OE', N'2025-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anuradha Gupta', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vijay Kumar Gupta', [fatherName]),
        [mobile] = ISNULL(N'8874638903', [mobile]),
        [email] = ISNULL(N'guptaanu8874@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-01-27', [joiningDate]),
        [dob] = ISNULL(N'2005-10-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1254';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1255')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1255', N'Kalpna Gangwar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jay dev', N'9045195943', N'kalpanagangwar9045@gmail.com', N'2025-01-27', N'2003-05-10', N'OE', N'2025-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kalpna Gangwar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jay dev', [fatherName]),
        [mobile] = ISNULL(N'9045195943', [mobile]),
        [email] = ISNULL(N'kalpanagangwar9045@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-01-27', [joiningDate]),
        [dob] = ISNULL(N'2003-05-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1255';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1256')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1256', N'Shivani Ray', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ramendra Kumar', N'9236991012', N'shivaniray207@gmail.com', N'2025-01-27', N'2006-05-23', N'OE', N'2025-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivani Ray', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ramendra Kumar', [fatherName]),
        [mobile] = ISNULL(N'9236991012', [mobile]),
        [email] = ISNULL(N'shivaniray207@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-01-27', [joiningDate]),
        [dob] = ISNULL(N'2006-05-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1256';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1257')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1257', N'Sapna Rani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shri Satwal Singh', N'6398962410', N'satyapal.5656singh@gmail.com', N'2025-01-27', N'2006-05-08', N'OE', N'2025-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sapna Rani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shri Satwal Singh', [fatherName]),
        [mobile] = ISNULL(N'6398962410', [mobile]),
        [email] = ISNULL(N'satyapal.5656singh@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-01-27', [joiningDate]),
        [dob] = ISNULL(N'2006-05-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1257';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1258')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1258', N'Akanksha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Chandan Lal', N'7217304660', N'akanshaa500@gmail.com', N'2025-01-27', N'2001-08-29', N'OE', N'2025-01-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Akanksha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Chandan Lal', [fatherName]),
        [mobile] = ISNULL(N'7217304660', [mobile]),
        [email] = ISNULL(N'akanshaa500@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-01-27', [joiningDate]),
        [dob] = ISNULL(N'2001-08-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-01-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1258';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1259')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1259', N'Neeraj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Satyawan', N'9729599268', N'Neerajahlawat343@gmail.com', N'2025-02-23', N'2003-05-09', N'OE', N'2025-02-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Neeraj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Satyawan', [fatherName]),
        [mobile] = ISNULL(N'9729599268', [mobile]),
        [email] = ISNULL(N'Neerajahlawat343@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-02-23', [joiningDate]),
        [dob] = ISNULL(N'2003-05-09', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-02-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1259';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1260')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1260', N'Priyanka', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Satbir', N'7206707980', N'pinkadmuwal@gmail.com', N'2025-03-01', N'2002-03-13', N'OE', N'2023-05-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priyanka', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Satbir', [fatherName]),
        [mobile] = ISNULL(N'7206707980', [mobile]),
        [email] = ISNULL(N'pinkadmuwal@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2002-03-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1260';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1261')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1261', N'Suraj Bediya', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dinesh Bediya', N'8709362070', N'seemaku7870@gmail.com', N'2025-03-01', N'2004-02-06', N'OE', N'2023-06-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suraj Bediya', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dinesh Bediya', [fatherName]),
        [mobile] = ISNULL(N'8709362070', [mobile]),
        [email] = ISNULL(N'seemaku7870@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2004-02-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1261';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1262')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1262', N'Hemwati', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rukam Singh', N'7060532582', N'hembati9@gmail.com', N'2025-03-01', N'2003-07-06', N'OE', N'2023-08-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Hemwati', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rukam Singh', [fatherName]),
        [mobile] = ISNULL(N'7060532582', [mobile]),
        [email] = ISNULL(N'hembati9@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2003-07-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-08-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1262';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1263')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1263', N'Sangita Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Pramod Rajak', N'7061440792', N'kumarisangita1275@gmail.com', N'2025-03-01', N'2005-07-12', N'OE', N'2023-08-07', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sangita Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pramod Rajak', [fatherName]),
        [mobile] = ISNULL(N'7061440792', [mobile]),
        [email] = ISNULL(N'kumarisangita1275@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2005-07-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-08-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1263';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1265')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1265', N'Raksha Parihar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajendra Parihar', N'6263001201', N'rakshaparihar75@gmail.com', N'2025-03-01', N'2002-08-25', N'OE', N'2023-09-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raksha Parihar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajendra Parihar', [fatherName]),
        [mobile] = ISNULL(N'6263001201', [mobile]),
        [email] = ISNULL(N'rakshaparihar75@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2002-08-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1265';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1266')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1266', N'Manjula Gangwar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ganga Prasad', N'9720682624', N'gangwarmanjula@gmail.com', N'2025-03-01', N'2004-03-01', N'OE', N'2023-09-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manjula Gangwar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ganga Prasad', [fatherName]),
        [mobile] = ISNULL(N'9720682624', [mobile]),
        [email] = ISNULL(N'gangwarmanjula@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2004-03-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1266';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1267')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1267', N'Manish Kumar Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vijay Kumar Singh', N'8102680736', N'mks808343@gmail.com', N'2025-03-01', N'2002-04-13', N'OE', N'2023-10-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manish Kumar Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vijay Kumar Singh', [fatherName]),
        [mobile] = ISNULL(N'8102680736', [mobile]),
        [email] = ISNULL(N'mks808343@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2002-04-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1267';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1268')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1268', N'Radha Rani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Bhola Prasad', N'7903359647', N'radhakumaripaplo@gmail.com', N'2025-03-01', N'2003-04-10', N'OE', N'2023-10-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Radha Rani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Bhola Prasad', [fatherName]),
        [mobile] = ISNULL(N'7903359647', [mobile]),
        [email] = ISNULL(N'radhakumaripaplo@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2003-04-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1268';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1269')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1269', N'Suman Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Umesh Bhagat', N'9113781723', N'suman200520kumari@gmail.com', N'2025-03-01', N'2005-03-15', N'OE', N'2024-02-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suman Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Umesh Bhagat', [fatherName]),
        [mobile] = ISNULL(N'9113781723', [mobile]),
        [email] = ISNULL(N'suman200520kumari@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-01', [joiningDate]),
        [dob] = ISNULL(N'2005-03-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-02-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1269';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1271')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1271', N'Shubhi Tiwari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Abhay Kumar Tiwari', N'9125489029', N'shubhitiwari238@gmail.com', N'2025-04-28', N'2004-07-22', N'OE', N'2025-04-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubhi Tiwari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Abhay Kumar Tiwari', [fatherName]),
        [mobile] = ISNULL(N'9125489029', [mobile]),
        [email] = ISNULL(N'shubhitiwari238@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-04-28', [joiningDate]),
        [dob] = ISNULL(N'2004-07-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-04-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1271';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1276')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1276', N'Manish Saini', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dayaram Saini', N'6397301324', N'manishsaini0808311@gmail.com', N'2025-05-31', N'2004-07-02', N'OE', N'2025-05-31', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manish Saini', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dayaram Saini', [fatherName]),
        [mobile] = ISNULL(N'6397301324', [mobile]),
        [email] = ISNULL(N'manishsaini0808311@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-31', [joiningDate]),
        [dob] = ISNULL(N'2004-07-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-31', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1276';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1277')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1277', N'Joginder .', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Manish', N'9991849095', N'jogidhaterwal12@gmail.com', N'2025-05-31', N'2004-04-24', N'OE', N'2025-05-31', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Joginder .', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Manish', [fatherName]),
        [mobile] = ISNULL(N'9991849095', [mobile]),
        [email] = ISNULL(N'jogidhaterwal12@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-31', [joiningDate]),
        [dob] = ISNULL(N'2004-04-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-31', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1277';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1279')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1279', N'Priyanka Kuwarbi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Chandan Singh Kuwarbi', N'8273502155', N'priyankakuwarbi48@gmail.com', N'2025-06-23', N'2007-04-29', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priyanka Kuwarbi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Chandan Singh Kuwarbi', [fatherName]),
        [mobile] = ISNULL(N'8273502155', [mobile]),
        [email] = ISNULL(N'priyankakuwarbi48@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2007-04-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1279';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1281')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1281', N'Himanshu Bisht', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dungar Singh Bisht', N'8279728706', N'himanshubisht4244@gmail.com', N'2025-06-23', N'2005-02-06', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Himanshu Bisht', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dungar Singh Bisht', [fatherName]),
        [mobile] = ISNULL(N'8279728706', [mobile]),
        [email] = ISNULL(N'himanshubisht4244@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-02-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1281';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1283')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1283', N'Ajay Singh Bora', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shiv Singh Bora', N'8394060289', N'ajays308693@gmail.com', N'2025-06-23', N'2004-01-04', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ajay Singh Bora', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shiv Singh Bora', [fatherName]),
        [mobile] = ISNULL(N'8394060289', [mobile]),
        [email] = ISNULL(N'ajays308693@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2004-01-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1283';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1285')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1285', N'Nisha Mehata', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Harish Chandra Singh', N'9045096129', N'nishamehata1234567899@gmail.com', N'2025-06-23', N'2005-07-17', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nisha Mehata', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Harish Chandra Singh', [fatherName]),
        [mobile] = ISNULL(N'9045096129', [mobile]),
        [email] = ISNULL(N'nishamehata1234567899@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-07-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1285';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1286')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1286', N'Kiran Mehara', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dhan Singh Mehara', N'7409892404', N'meharakiran150@gmail.com', N'2025-06-23', N'2005-09-27', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kiran Mehara', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dhan Singh Mehara', [fatherName]),
        [mobile] = ISNULL(N'7409892404', [mobile]),
        [email] = ISNULL(N'meharakiran150@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-09-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1286';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1287')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1287', N'Tanuja Gangola', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Bhagwati Devi', N'7088651946', N'tanujagangola629@gmail.com', N'2025-06-23', N'2005-07-05', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tanuja Gangola', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Bhagwati Devi', [fatherName]),
        [mobile] = ISNULL(N'7088651946', [mobile]),
        [email] = ISNULL(N'tanujagangola629@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-07-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1287';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1288')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1288', N'Priyanshi Bora', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ranjeet Singh Bora', N'8273296889', N'priyanshibora345@gmail.com', N'2025-06-23', N'2005-07-12', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priyanshi Bora', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ranjeet Singh Bora', [fatherName]),
        [mobile] = ISNULL(N'8273296889', [mobile]),
        [email] = ISNULL(N'priyanshibora345@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-07-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1288';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1289')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1289', N'Meenakshi Tiwari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Anand Tiwari', N'8445341036', N'tiwarimeenakshi683@gmail.com', N'2025-06-23', N'2005-08-21', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Meenakshi Tiwari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Anand Tiwari', [fatherName]),
        [mobile] = ISNULL(N'8445341036', [mobile]),
        [email] = ISNULL(N'tiwarimeenakshi683@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-08-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1289';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1290')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1290', N'Priyanka Negi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Puran Singh Negi', N'7534863645', N'priyankanegi8979@gmail.com', N'2025-06-23', N'2005-11-03', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priyanka Negi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Puran Singh Negi', [fatherName]),
        [mobile] = ISNULL(N'7534863645', [mobile]),
        [email] = ISNULL(N'priyankanegi8979@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-11-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1290';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1292')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1292', N'Sagar Sarkar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Pralay Sarkar', N'7505977143', N'sarkarg1410@gmail.com', N'2025-06-23', N'2003-10-24', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sagar Sarkar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pralay Sarkar', [fatherName]),
        [mobile] = ISNULL(N'7505977143', [mobile]),
        [email] = ISNULL(N'sarkarg1410@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2003-10-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1292';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1293')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1293', N'Mukesh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Chhote Lal', N'9758727122', N'mukeshmourya18863@gmail.com', N'2025-06-23', N'2006-02-12', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mukesh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Chhote Lal', [fatherName]),
        [mobile] = ISNULL(N'9758727122', [mobile]),
        [email] = ISNULL(N'mukeshmourya18863@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2006-02-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1293';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1294')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1294', N'Aman Mourya', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ramsudhar Mourya', N'7252023970', N'amanmourya262308@gmail.com', N'2025-06-23', N'2006-09-22', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aman Mourya', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ramsudhar Mourya', [fatherName]),
        [mobile] = ISNULL(N'7252023970', [mobile]),
        [email] = ISNULL(N'amanmourya262308@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2006-09-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1294';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1295')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1295', N'Aradhana Upadhyay', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Anju Upadhyay', N'7456838917', N'upadhyayaradhana31@gmail.com', N'2025-06-23', N'2004-08-08', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aradhana Upadhyay', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Anju Upadhyay', [fatherName]),
        [mobile] = ISNULL(N'7456838917', [mobile]),
        [email] = ISNULL(N'upadhyayaradhana31@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2004-08-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1295';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1296')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1296', N'Anjana Nagarkoti', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Kundan Singh', N'7505552438', N'anjananagarkoti002@gmail.com', N'2025-06-23', N'2005-04-10', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anjana Nagarkoti', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Kundan Singh', [fatherName]),
        [mobile] = ISNULL(N'7505552438', [mobile]),
        [email] = ISNULL(N'anjananagarkoti002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-04-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1296';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1298')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1298', N'Lata Negi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Heera Singh', N'7454944362', N'latanegi1219@gmail.com', N'2025-06-23', N'2005-02-25', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lata Negi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Heera Singh', [fatherName]),
        [mobile] = ISNULL(N'7454944362', [mobile]),
        [email] = ISNULL(N'latanegi1219@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-02-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1298';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1300')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1300', N'Pawan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Bindra Prasad Yadav', N'7830641826', N'py368352@gmail.com', N'2025-06-24', N'2004-12-14', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pawan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Bindra Prasad Yadav', [fatherName]),
        [mobile] = ISNULL(N'7830641826', [mobile]),
        [email] = ISNULL(N'py368352@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-12-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1300';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1302')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1302', N'Vishwajeet Kumar Dubey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vijay Prakash Dubey', N'6287349609', N'vk6689782@gmail.com', N'2025-06-24', N'2005-12-14', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vishwajeet Kumar Dubey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vijay Prakash Dubey', [fatherName]),
        [mobile] = ISNULL(N'6287349609', [mobile]),
        [email] = ISNULL(N'vk6689782@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2005-12-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1302';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1303')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1303', N'Arpana Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shailesh Kumar Mishra', N'6204071680', N'arpanamrh@gmail.com', N'2025-06-24', N'2005-04-20', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arpana Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shailesh Kumar Mishra', [fatherName]),
        [mobile] = ISNULL(N'6204071680', [mobile]),
        [email] = ISNULL(N'arpanamrh@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2005-04-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1303';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1304')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1304', N'Kunti Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shailendra Sah', N'9065124031', N'kumarikunti255@gmail.com', N'2025-06-24', N'2004-02-25', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kunti Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shailendra Sah', [fatherName]),
        [mobile] = ISNULL(N'9065124031', [mobile]),
        [email] = ISNULL(N'kumarikunti255@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-02-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1304';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1310')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1310', N'Sonalika Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Prakash Chandra Verma', N'8235620075', N'sonalikaverma32@gmail.com', N'2025-06-24', N'2005-08-22', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sonalika Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Prakash Chandra Verma', [fatherName]),
        [mobile] = ISNULL(N'8235620075', [mobile]),
        [email] = ISNULL(N'sonalikaverma32@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2005-08-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1310';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1312')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1312', N'Kaushal Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Akhilesh Rajak', N'7250923794', N'kaushalkumar736896@gmail.com', N'2025-06-24', N'2005-05-13', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kaushal Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Akhilesh Rajak', [fatherName]),
        [mobile] = ISNULL(N'7250923794', [mobile]),
        [email] = ISNULL(N'kaushalkumar736896@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2005-05-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1312';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1313')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1313', N'Vishal Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dharampal', N'6397100948', N'vickychauhan12935@gmail.com', N'2025-06-23', N'2005-09-26', N'OE', N'2025-06-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vishal Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dharampal', [fatherName]),
        [mobile] = ISNULL(N'6397100948', [mobile]),
        [email] = ISNULL(N'vickychauhan12935@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'2005-09-26', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1313';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1316')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1316', N'Gulshan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Lt. Shankar Singh', N'8102058485', N'gulshankumar8102058@gmail.com', N'2025-06-24', N'2004-01-22', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gulshan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Lt. Shankar Singh', [fatherName]),
        [mobile] = ISNULL(N'8102058485', [mobile]),
        [email] = ISNULL(N'gulshankumar8102058@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-01-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1316';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1318')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1318', N'Shivani Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Gopal Kumar Yadav', N'9262235891', N'shivaniraj655@gmail.com', N'2025-06-24', N'2007-01-18', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivani Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Gopal Kumar Yadav', [fatherName]),
        [mobile] = ISNULL(N'9262235891', [mobile]),
        [email] = ISNULL(N'shivaniraj655@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2007-01-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1318';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1320')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1320', N'Aman Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sarifan Pandit', N'8789082132', N'amankrr247@gmail.com', N'2025-06-24', N'2004-01-01', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aman Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sarifan Pandit', [fatherName]),
        [mobile] = ISNULL(N'8789082132', [mobile]),
        [email] = ISNULL(N'amankrr247@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-01-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1320';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1321')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1321', N'Vishal Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rampravesh Yadav', N'6207274916', N'vishalaur825599@gmail.com', N'2025-06-24', N'2004-05-10', N'OE', N'2025-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vishal Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rampravesh Yadav', [fatherName]),
        [mobile] = ISNULL(N'6207274916', [mobile]),
        [email] = ISNULL(N'vishalaur825599@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-05-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1321';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1322')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1322', N'Sharda Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dhananjay Kumar', N'7700842831', N'shardakumari5905@gmail.com', N'2025-07-23', N'2006-09-05', N'OE', N'2025-07-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sharda Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dhananjay Kumar', [fatherName]),
        [mobile] = ISNULL(N'7700842831', [mobile]),
        [email] = ISNULL(N'shardakumari5905@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-23', [joiningDate]),
        [dob] = ISNULL(N'2006-09-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1322';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1324')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1324', N'Karandeep Malia', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jyoti Malia', N'9821898163', N'karanmalia971@gmail.com', N'2025-07-24', N'2007-01-05', N'OE', N'2025-07-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Karandeep Malia', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jyoti Malia', [fatherName]),
        [mobile] = ISNULL(N'9821898163', [mobile]),
        [email] = ISNULL(N'karanmalia971@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-24', [joiningDate]),
        [dob] = ISNULL(N'2007-01-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1324';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1325')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1325', N'Shweta Kala', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Naresh Chandra kala', N'9557253661', N'shwetakala9882@gmail.com', N'2025-10-03', N'2002-08-08', N'OE', N'2023-07-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shweta Kala', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Naresh Chandra kala', [fatherName]),
        [mobile] = ISNULL(N'9557253661', [mobile]),
        [email] = ISNULL(N'shwetakala9882@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-03', [joiningDate]),
        [dob] = ISNULL(N'2002-08-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-07-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1325';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1326')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1326', N'Shalini Gangwal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rakesh Gangwal', N'9784630966', N'Shalinigangwal8696@gmail.com', N'2025-10-27', N'2006-02-01', N'OET', N'2025-10-27', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shalini Gangwal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rakesh Gangwal', [fatherName]),
        [mobile] = ISNULL(N'9784630966', [mobile]),
        [email] = ISNULL(N'Shalinigangwal8696@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-27', [joiningDate]),
        [dob] = ISNULL(N'2006-02-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1326';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1328')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1328', N'Sonee Fartyal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Daleep singh Fartyal', N'7505355223', N'soneefartyal123@gmail.com', N'2025-10-27', N'2005-03-25', N'OET', N'2025-10-27', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sonee Fartyal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Daleep singh Fartyal', [fatherName]),
        [mobile] = ISNULL(N'7505355223', [mobile]),
        [email] = ISNULL(N'soneefartyal123@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-27', [joiningDate]),
        [dob] = ISNULL(N'2005-03-25', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1328';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1329')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1329', N'Ankit', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Surender', N'7357825787', N'ankitkumar5664hloo@gmail.com', N'2025-12-01', N'2002-01-20', N'OET', N'2025-12-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankit', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Surender', [fatherName]),
        [mobile] = ISNULL(N'7357825787', [mobile]),
        [email] = ISNULL(N'ankitkumar5664hloo@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-01', [joiningDate]),
        [dob] = ISNULL(N'2002-01-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1329';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1330')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1330', N'Shruti', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vijay Shah Gond', N'7033550861', N'shruti004shah@gmail.com', N'2025-12-01', N'2004-08-17', N'OET', N'2025-12-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shruti', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vijay Shah Gond', [fatherName]),
        [mobile] = ISNULL(N'7033550861', [mobile]),
        [email] = ISNULL(N'shruti004shah@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-01', [joiningDate]),
        [dob] = ISNULL(N'2004-08-17', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1330';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1331')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1331', N'Vishal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Veerbhan', N'9729283287', N'duggalvishal160061@gmail.com', N'2025-12-01', N'2003-10-10', N'OET', N'2025-12-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vishal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Veerbhan', [fatherName]),
        [mobile] = ISNULL(N'9729283287', [mobile]),
        [email] = ISNULL(N'duggalvishal160061@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-01', [joiningDate]),
        [dob] = ISNULL(N'2003-10-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1331';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1335')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1335', N'Sunil Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Umesh Paswan', N'9546696562', N'sunilkumar2004pa@gmail.com', N'2025-12-13', N'2004-03-10', N'OET', N'2025-12-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunil Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Umesh Paswan', [fatherName]),
        [mobile] = ISNULL(N'9546696562', [mobile]),
        [email] = ISNULL(N'sunilkumar2004pa@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-13', [joiningDate]),
        [dob] = ISNULL(N'2004-03-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1335';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1336')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1336', N'Sachin Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Suresh Kumar', N'8791921449', N'kumarsachim53@gmail.com', N'2025-12-13', N'2006-08-23', N'OET', N'2025-12-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sachin Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Suresh Kumar', [fatherName]),
        [mobile] = ISNULL(N'8791921449', [mobile]),
        [email] = ISNULL(N'kumarsachim53@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-13', [joiningDate]),
        [dob] = ISNULL(N'2006-08-23', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1336';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1337')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1337', N'Pintu Kumar Ravidas', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Mohan Ravidas', N'9060392472', N'pinturavi052@gmail.com', N'2025-12-13', N'2005-11-11', N'OET', N'2025-12-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pintu Kumar Ravidas', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Mohan Ravidas', [fatherName]),
        [mobile] = ISNULL(N'9060392472', [mobile]),
        [email] = ISNULL(N'pinturavi052@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-13', [joiningDate]),
        [dob] = ISNULL(N'2005-11-11', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1337';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1338')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1338', N'Sachin', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Surender', N'8683877552', N'sy17161980@gmail.com', N'2025-12-13', N'2004-05-08', N'OET', N'2025-12-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sachin', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Surender', [fatherName]),
        [mobile] = ISNULL(N'8683877552', [mobile]),
        [email] = ISNULL(N'sy17161980@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-13', [joiningDate]),
        [dob] = ISNULL(N'2004-05-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1338';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1339')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1339', N'Suhani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ajay Pal Singh', N'6398858547', N'suhanikumari9892@gmail.com', N'2025-12-13', N'2006-12-05', N'OET', N'2025-12-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suhani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ajay Pal Singh', [fatherName]),
        [mobile] = ISNULL(N'6398858547', [mobile]),
        [email] = ISNULL(N'suhanikumari9892@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-13', [joiningDate]),
        [dob] = ISNULL(N'2006-12-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1339';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1340')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1340', N'Divya Bisht', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Gambhir Singh Bisht', N'6396695223', N'divyabisht183@gmail.com', N'2026-03-16', N'2003-01-09', N'OE', N'2023-07-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Divya Bisht', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Gambhir Singh Bisht', [fatherName]),
        [mobile] = ISNULL(N'6396695223', [mobile]),
        [email] = ISNULL(N'divyabisht183@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-03-16', [joiningDate]),
        [dob] = ISNULL(N'2003-01-09', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-07-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1340';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1342')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1342', N'Anish', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ranbir Singh', N'9812658379', N'anishkhokhar860@gmail.com', N'2026-06-02', N'2004-12-03', N'OET', N'2026-06-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anish', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ranbir Singh', [fatherName]),
        [mobile] = ISNULL(N'9812658379', [mobile]),
        [email] = ISNULL(N'anishkhokhar860@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-02', [joiningDate]),
        [dob] = ISNULL(N'2004-12-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1342';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1343')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1343', N'LUCKY', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'KARMVEER', N'8689058523', N'KARMBEERSAARSAR@GMAIL.COM', N'2026-06-08', N'2005-06-29', N'OET', N'2026-06-08', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'LUCKY', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'KARMVEER', [fatherName]),
        [mobile] = ISNULL(N'8689058523', [mobile]),
        [email] = ISNULL(N'KARMBEERSAARSAR@GMAIL.COM', [email]),
        [joiningDate] = ISNULL(N'2026-06-08', [joiningDate]),
        [dob] = ISNULL(N'2005-06-29', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1343';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1344')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1344', N'Gulam Rabbani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'AZAZ AHMAD', N'9234015148', N'Laadlakhan701@gmail.com', N'2026-06-25', N'2005-01-12', N'OET', N'2026-06-25', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gulam Rabbani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'AZAZ AHMAD', [fatherName]),
        [mobile] = ISNULL(N'9234015148', [mobile]),
        [email] = ISNULL(N'Laadlakhan701@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-25', [joiningDate]),
        [dob] = ISNULL(N'2005-01-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-25', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1344';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1345')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1345', N'Veer Sinha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Vijay Kumar Sinha', N'6206477622', N'sinhaveer30@gmail.com', N'2026-06-25', N'2005-01-01', N'OET', N'2026-06-25', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Veer Sinha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Vijay Kumar Sinha', [fatherName]),
        [mobile] = ISNULL(N'6206477622', [mobile]),
        [email] = ISNULL(N'sinhaveer30@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-25', [joiningDate]),
        [dob] = ISNULL(N'2005-01-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-25', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1345';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1346')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1346', N'Srishti Rana', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shelendra Singh Rana', N'7060326354', N'srishtirana2810@gmail.com', N'2026-07-01', N'2006-10-28', N'OET', N'2026-07-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Srishti Rana', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shelendra Singh Rana', [fatherName]),
        [mobile] = ISNULL(N'7060326354', [mobile]),
        [email] = ISNULL(N'srishtirana2810@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-01', [joiningDate]),
        [dob] = ISNULL(N'2006-10-28', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1346';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1347')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1347', N'Narayan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sanjay Kumar Singh', N'9153599230', N'narayankumar7294@gmail.com', N'2026-07-06', N'2008-07-07', N'OET', N'2026-07-06', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Narayan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sanjay Kumar Singh', [fatherName]),
        [mobile] = ISNULL(N'9153599230', [mobile]),
        [email] = ISNULL(N'narayankumar7294@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-06', [joiningDate]),
        [dob] = ISNULL(N'2008-07-07', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1347';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1348')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1348', N'Ritik Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Gulab Chandra Yadav', N'9661582596', N'ritikk25498@gmail.com', N'2026-07-06', N'2007-01-01', N'OET', N'2026-07-06', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ritik Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Gulab Chandra Yadav', [fatherName]),
        [mobile] = ISNULL(N'9661582596', [mobile]),
        [email] = ISNULL(N'ritikk25498@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-06', [joiningDate]),
        [dob] = ISNULL(N'2007-01-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1348';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1349')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1349', N'Shiva Kanaujia', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ram Kripa', N'9696814587', N'shivakanaujia7072@gmail.com', N'2026-07-06', N'2006-01-09', N'OET', N'2026-07-06', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shiva Kanaujia', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ram Kripa', [fatherName]),
        [mobile] = ISNULL(N'9696814587', [mobile]),
        [email] = ISNULL(N'shivakanaujia7072@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-06', [joiningDate]),
        [dob] = ISNULL(N'2006-01-09', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1349';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1350')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1350', N'Nandini Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Janta Ram', N'8210520224', N'kumarinandani3212@gmail.com', N'2026-07-13', N'2006-04-01', N'OET', N'2026-07-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nandini Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Janta Ram', [fatherName]),
        [mobile] = ISNULL(N'8210520224', [mobile]),
        [email] = ISNULL(N'kumarinandani3212@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-13', [joiningDate]),
        [dob] = ISNULL(N'2006-04-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1350';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1351')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1351', N'Sabita Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Mahendra Uranv', N'9771815656', N'sabita5656kumari@gmail.com', N'2026-07-13', N'2005-03-30', N'OET', N'2026-07-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sabita Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Mahendra Uranv', [fatherName]),
        [mobile] = ISNULL(N'9771815656', [mobile]),
        [email] = ISNULL(N'sabita5656kumari@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-13', [joiningDate]),
        [dob] = ISNULL(N'2005-03-30', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1351';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1352')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1352', N'Sonali Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ravi Shankar Ram', N'9508041694', N'sonalikumaripoly006@gmail.com', N'2026-07-13', N'2006-10-15', N'OET', N'2026-07-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sonali Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ravi Shankar Ram', [fatherName]),
        [mobile] = ISNULL(N'9508041694', [mobile]),
        [email] = ISNULL(N'sonalikumaripoly006@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-13', [joiningDate]),
        [dob] = ISNULL(N'2006-10-15', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1352';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1353')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1353', N'Deepak Kumar Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sitaram Prasad Verma', N'9631928348', N'dipv1210@gmail.com', N'2026-07-13', N'2007-10-12', N'OET', N'2026-07-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak Kumar Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sitaram Prasad Verma', [fatherName]),
        [mobile] = ISNULL(N'9631928348', [mobile]),
        [email] = ISNULL(N'dipv1210@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-13', [joiningDate]),
        [dob] = ISNULL(N'2007-10-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1353';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1354')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1354', N'Anannya Nath', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Dilip Kumar Nath', N'7644901970', N'anannya0981@gmail.com', N'2026-07-13', N'2006-08-12', N'OET', N'2026-07-13', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anannya Nath', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Dilip Kumar Nath', [fatherName]),
        [mobile] = ISNULL(N'7644901970', [mobile]),
        [email] = ISNULL(N'anannya0981@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-13', [joiningDate]),
        [dob] = ISNULL(N'2006-08-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1354';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1355')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1355', N'Anirban Mallick', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Amit Kumar Mallick', N'9142995281', N'anirbanmallick49@gmail.com', N'2026-07-29', N'2006-02-18', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anirban Mallick', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Amit Kumar Mallick', [fatherName]),
        [mobile] = ISNULL(N'9142995281', [mobile]),
        [email] = ISNULL(N'anirbanmallick49@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2006-02-18', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1355';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1357')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1357', N'Pratik Kumar Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Jagat Narayan Singh', N'9709252882', N'singhpratik0104@gmail.com', N'2026-07-29', N'2005-06-20', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pratik Kumar Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Jagat Narayan Singh', [fatherName]),
        [mobile] = ISNULL(N'9709252882', [mobile]),
        [email] = ISNULL(N'singhpratik0104@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2005-06-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1357';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1358')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1358', N'Rohit Singh Rawat', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'HarshPal Singh Rawat', N'7618114557', N'ronak1907rawat@gmail.com', N'2026-07-29', N'2007-07-19', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rohit Singh Rawat', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'HarshPal Singh Rawat', [fatherName]),
        [mobile] = ISNULL(N'7618114557', [mobile]),
        [email] = ISNULL(N'ronak1907rawat@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2007-07-19', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1358';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1359')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1359', N'Parth Chadda', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rishipal Chadda', N'9518694849', N'parthchadhachadha@gmail.com', N'2026-07-29', N'2007-10-11', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Parth Chadda', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rishipal Chadda', [fatherName]),
        [mobile] = ISNULL(N'9518694849', [mobile]),
        [email] = ISNULL(N'parthchadhachadha@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2007-10-11', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1359';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1360')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1360', N'Parth Saini', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rahul Deep Saini', N'8168363301', N'parthsaini008@gmail.com', N'2026-07-29', N'2008-04-19', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Parth Saini', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rahul Deep Saini', [fatherName]),
        [mobile] = ISNULL(N'8168363301', [mobile]),
        [email] = ISNULL(N'parthsaini008@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2008-04-19', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1360';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1361')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1361', N'Ajay Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Sunil Kumar', N'7206297157', N'kumarajayhdhu@gmail.com', N'2026-07-29', N'2008-02-11', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ajay Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Sunil Kumar', [fatherName]),
        [mobile] = ISNULL(N'7206297157', [mobile]),
        [email] = ISNULL(N'kumarajayhdhu@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2008-02-11', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1361';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1362')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1362', N'Neelam', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Hari Chand', N'9253634272', N'neelam12062023@gmail.com', N'2026-07-29', N'2005-09-10', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Neelam', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Hari Chand', [fatherName]),
        [mobile] = ISNULL(N'9253634272', [mobile]),
        [email] = ISNULL(N'neelam12062023@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2005-09-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1362';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1363')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1363', N'Suhani Chauhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Harsh Singh Chauhan', N'9319461361', N'suhanichauhan122@gmail.com', N'2026-07-29', N'2006-03-14', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suhani Chauhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Harsh Singh Chauhan', [fatherName]),
        [mobile] = ISNULL(N'9319461361', [mobile]),
        [email] = ISNULL(N'suhanichauhan122@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2006-03-14', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1363';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1364')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1364', N'Keerti', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Kamlesh Prasad', N'8218971789', N'keertilakhera07610761@gmail.com', N'2026-07-29', N'2006-02-08', N'OET', N'2026-07-29', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Keerti', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Kamlesh Prasad', [fatherName]),
        [mobile] = ISNULL(N'8218971789', [mobile]),
        [email] = ISNULL(N'keertilakhera07610761@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-29', [joiningDate]),
        [dob] = ISNULL(N'2006-02-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1364';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1365')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1365', N'Yuval Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Rajeev Sharma', N'9311328014', N'yuvalsharma09@gmail.com', N'2026-08-10', N'2006-09-29', N'OET', N'2026-08-10', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Yuval Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Rajeev Sharma', [fatherName]),
        [mobile] = ISNULL(N'9311328014', [mobile]),
        [email] = ISNULL(N'yuvalsharma09@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-10', [joiningDate]),
        [dob] = ISNULL(N'2006-09-29', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1365';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1367')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1367', N'Adyasha Aradhana', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Gopabandhu Sahoo', N'9348029392', N'adyasha.aradhana08@gmail.com', N'2026-08-10', N'2008-06-21', N'OET', N'2026-08-10', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Adyasha Aradhana', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Gopabandhu Sahoo', [fatherName]),
        [mobile] = ISNULL(N'9348029392', [mobile]),
        [email] = ISNULL(N'adyasha.aradhana08@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-10', [joiningDate]),
        [dob] = ISNULL(N'2008-06-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1367';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1368')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1368', N'Shubham Jha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Pankaj Kumar Jha', N'8825328143', N'jhashubham122004@gmail.com', N'2026-08-10', N'2004-12-03', N'OET', N'2026-08-10', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubham Jha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Pankaj Kumar Jha', [fatherName]),
        [mobile] = ISNULL(N'8825328143', [mobile]),
        [email] = ISNULL(N'jhashubham122004@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-10', [joiningDate]),
        [dob] = ISNULL(N'2004-12-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1368';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1369')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1369', N'Harshit Jangid', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Hukum Chand', N'6377092245', N'jangidharshit432@gmail.com', N'2026-09-01', N'2008-04-14', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Harshit Jangid', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Hukum Chand', [fatherName]),
        [mobile] = ISNULL(N'6377092245', [mobile]),
        [email] = ISNULL(N'jangidharshit432@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2008-04-14', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1369';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1370')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1370', N'Gaurav Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Radha Ballabh Sharma', N'9911272057', N'gs2701897@gmail.com', N'2026-09-01', N'2006-10-04', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gaurav Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Radha Ballabh Sharma', [fatherName]),
        [mobile] = ISNULL(N'9911272057', [mobile]),
        [email] = ISNULL(N'gs2701897@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2006-10-04', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1370';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1371')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1371', N'Deepanshu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Chander Pal', N'8882513218', N'dk6346457@gmail.com', N'2026-09-01', N'2004-02-12', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepanshu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Chander Pal', [fatherName]),
        [mobile] = ISNULL(N'8882513218', [mobile]),
        [email] = ISNULL(N'dk6346457@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2004-02-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1371';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1372')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1372', N'Nitesh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Satishpal', N'7042496634', N'PALMANISH4078@GMAIL.COM', N'2026-09-01', N'2005-09-10', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitesh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Satishpal', [fatherName]),
        [mobile] = ISNULL(N'7042496634', [mobile]),
        [email] = ISNULL(N'PALMANISH4078@GMAIL.COM', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2005-09-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1372';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1373')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1373', N'Devender Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Shyam Singh', N'8800787847', N'2006SINGHDEVENDER@GMAIL.COM', N'2026-09-01', N'2006-10-07', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Devender Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Shyam Singh', [fatherName]),
        [mobile] = ISNULL(N'8800787847', [mobile]),
        [email] = ISNULL(N'2006SINGHDEVENDER@GMAIL.COM', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2006-10-07', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1373';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1374')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1374', N'Palak Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Ganesh Singh', N'8091764034', N'p07904449@gmail.com', N'2026-09-01', N'2005-05-05', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Palak Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Ganesh Singh', [fatherName]),
        [mobile] = ISNULL(N'8091764034', [mobile]),
        [email] = ISNULL(N'p07904449@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2005-05-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1374';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1375')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1375', N'Nikhil Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'Yogesh Kumar Singh', N'9102221912', N'nikhil86493@gmail.com', N'2026-09-01', N'2005-10-08', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nikhil Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'Yogesh Kumar Singh', [fatherName]),
        [mobile] = ISNULL(N'9102221912', [mobile]),
        [email] = ISNULL(N'nikhil86493@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2005-10-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1375';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'KA1376')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'KA1376', N'ROHIT VERMA', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitGurugram, @deptGgn,
        N'RAMAYAN VERMA', N'9311481626', N'vermarohit90799@gmail.com', N'2026-09-01', N'2007-11-05', N'OET', N'2026-09-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ROHIT VERMA', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(N'RAMAYAN VERMA', [fatherName]),
        [mobile] = ISNULL(N'9311481626', [mobile]),
        [email] = ISNULL(N'vermarohit90799@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-01', [joiningDate]),
        [dob] = ISNULL(N'2007-11-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'KA1376';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01163')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01163', N'Divya Akhouri', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSuperAdmin, @unitGurugram, @deptGgn,
        NULL, N'9582224860', N'akhouri.divya@gmail.com', N'2025-04-21', N'1980-02-01', N'Senior Manager', N'2024-11-10', N'7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Divya Akhouri', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSuperAdmin,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'9582224860', [mobile]),
        [email] = ISNULL(N'akhouri.divya@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-04-21', [joiningDate]),
        [dob] = ISNULL(N'1980-02-01', [dob]),
        [designation] = ISNULL(N'Senior Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-11-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01163';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'ADMINGGN')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'ADMINGGN', N'Admin GGN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitGurugram, @deptGgn,
        NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Admin GGN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitGurugram,
        [departmentId] = ISNULL([departmentId], @deptGgn),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(NULL, [mobile]),
        [email] = ISNULL(NULL, [email]),
        [joiningDate] = ISNULL(NULL, [joiningDate]),
        [dob] = ISNULL(NULL, [dob]),
        [designation] = ISNULL(NULL, [designation]),
        [groupJoiningDate] = ISNULL(NULL, [groupJoiningDate]),
        [gradeCode] = ISNULL(NULL, [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'ADMINGGN';
END

-- ============================================================================
-- SEEDING PLANT: PARWANOO (101 Total Records)
-- ============================================================================

IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50459')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50459', N'Sabra', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mohammad Vakil Ahamad', N'9350528355', N'itssaraynr@gmail.com', N'2026-07-20', N'2006-03-03', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sabra', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mohammad Vakil Ahamad', [fatherName]),
        [mobile] = ISNULL(N'9350528355', [mobile]),
        [email] = ISNULL(N'itssaraynr@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2006-03-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50459';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50461')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50461', N'Akankasha Parida', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Gouranga Parida', N'7735865473', N'paridaakankasha@gmail.com', N'2026-07-20', N'2007-11-20', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Akankasha Parida', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Gouranga Parida', [fatherName]),
        [mobile] = ISNULL(N'7735865473', [mobile]),
        [email] = ISNULL(N'paridaakankasha@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2007-11-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50461';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50463')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50463', N'Dipanjali Otta', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Bhagaban Otta', N'8260043441', N'ottaumamani@gmail.com', N'2026-07-20', N'2006-06-27', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dipanjali Otta', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Bhagaban Otta', [fatherName]),
        [mobile] = ISNULL(N'8260043441', [mobile]),
        [email] = ISNULL(N'ottaumamani@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2006-06-27', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50463';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50462')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50462', N'Anjali Ekka', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Chunua Ekka', N'7608859371', N'ekkaanjali79@gmail.com', N'2026-07-20', N'2006-08-23', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anjali Ekka', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Chunua Ekka', [fatherName]),
        [mobile] = ISNULL(N'7608859371', [mobile]),
        [email] = ISNULL(N'ekkaanjali79@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2006-08-23', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50462';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50464')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50464', N'Nilakshi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Rajesh Kumar', N'9253174624', N'gurjarnilu011@gmail.com', N'2026-07-20', N'2005-11-12', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nilakshi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Rajesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'9253174624', [mobile]),
        [email] = ISNULL(N'gurjarnilu011@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2005-11-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50464';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50465')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50465', N'Jiya', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Daya Shanker', N'9306840314', N'jiya24682468@gmail.com', N'2026-07-20', N'2005-06-09', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jiya', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Daya Shanker', [fatherName]),
        [mobile] = ISNULL(N'9306840314', [mobile]),
        [email] = ISNULL(N'jiya24682468@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2005-06-09', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50465';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50466')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50466', N'Sneha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Bhai Chand', N'9468032923', N'snehabhardwaj554@gmail.com', N'2026-07-20', N'2005-07-30', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sneha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Bhai Chand', [fatherName]),
        [mobile] = ISNULL(N'9468032923', [mobile]),
        [email] = ISNULL(N'snehabhardwaj554@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2005-07-30', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50466';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50467')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50467', N'Sushmita', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sanjay Sahni', N'8607166567', N'sushmitasahni835@gmail.com', N'2026-07-20', N'2006-07-08', N'OET', N'2026-07-20', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sushmita', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sanjay Sahni', [fatherName]),
        [mobile] = ISNULL(N'8607166567', [mobile]),
        [email] = ISNULL(N'sushmitasahni835@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-20', [joiningDate]),
        [dob] = ISNULL(N'2006-07-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50467';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50436')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50436', N'Geetu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Bhupinder Kumar', N'9588188860', N'geeturani.2004@gmail.com', N'2024-12-30', N'2004-02-29', N'OE', N'2024-12-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Geetu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Bhupinder Kumar', [fatherName]),
        [mobile] = ISNULL(N'9588188860', [mobile]),
        [email] = ISNULL(N'geeturani.2004@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-12-30', [joiningDate]),
        [dob] = ISNULL(N'2004-02-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-12-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50436';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50437')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50437', N'Urvashi Devi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Pardeep kumar', N'6230317583', N'urvashisharma62303@gmail.com', N'2024-12-30', N'2003-04-04', N'OE', N'2024-12-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Urvashi Devi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Pardeep kumar', [fatherName]),
        [mobile] = ISNULL(N'6230317583', [mobile]),
        [email] = ISNULL(N'urvashisharma62303@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-12-30', [joiningDate]),
        [dob] = ISNULL(N'2003-04-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-12-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50437';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50446')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50446', N'Komal Garcha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Lt. Mr. Anil Kumar', N'9817022914', N'Garchakomal79@gmail.com', N'2025-07-18', N'2004-08-12', N'OE', N'2025-07-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Komal Garcha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Lt. Mr. Anil Kumar', [fatherName]),
        [mobile] = ISNULL(N'9817022914', [mobile]),
        [email] = ISNULL(N'Garchakomal79@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-18', [joiningDate]),
        [dob] = ISNULL(N'2004-08-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50446';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50449')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50449', N'Ankita Mahato', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mr. Subhash Chandra Mahato', N'7091470599', N'mahatoankita51@gmail.com', N'2025-07-18', N'2004-11-23', N'OE', N'2025-07-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankita Mahato', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mr. Subhash Chandra Mahato', [fatherName]),
        [mobile] = ISNULL(N'7091470599', [mobile]),
        [email] = ISNULL(N'mahatoankita51@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-18', [joiningDate]),
        [dob] = ISNULL(N'2004-11-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50449';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50450')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50450', N'Rajeshwari Wahi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mr. Sanjeev Kumar Wahi', N'7015012479', N'rimjimwahi@gmail.com', N'2025-07-18', N'2006-03-17', N'OE', N'2025-07-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rajeshwari Wahi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mr. Sanjeev Kumar Wahi', [fatherName]),
        [mobile] = ISNULL(N'7015012479', [mobile]),
        [email] = ISNULL(N'rimjimwahi@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-18', [joiningDate]),
        [dob] = ISNULL(N'2006-03-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50450';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50453')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50453', N'Bhumika Upadhyay', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Shivshankar Upadhyay', N'8630368541', N'bhumikaupdhya660@gmail.com', N'2025-07-21', N'2005-09-07', N'OE', N'2025-07-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhumika Upadhyay', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Shivshankar Upadhyay', [fatherName]),
        [mobile] = ISNULL(N'8630368541', [mobile]),
        [email] = ISNULL(N'bhumikaupdhya660@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-21', [joiningDate]),
        [dob] = ISNULL(N'2005-09-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50453';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50454')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50454', N'Sunami', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mr. Angrej Singh', N'7988595958', N'sunami4105@gmail.com', N'2025-07-31', N'2005-01-04', N'OE', N'2025-07-31', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunami', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mr. Angrej Singh', [fatherName]),
        [mobile] = ISNULL(N'7988595958', [mobile]),
        [email] = ISNULL(N'sunami4105@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-31', [joiningDate]),
        [dob] = ISNULL(N'2005-01-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-31', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50454';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50455')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50455', N'Kanchan Devi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mr. Gurcharan Singh', N'7988633876', N'Kanchandavi134@gmail.com', N'2025-07-31', N'2004-12-09', N'OE', N'2025-07-31', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kanchan Devi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mr. Gurcharan Singh', [fatherName]),
        [mobile] = ISNULL(N'7988633876', [mobile]),
        [email] = ISNULL(N'Kanchandavi134@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-31', [joiningDate]),
        [dob] = ISNULL(N'2004-12-09', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-31', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50455';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50456')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50456', N'Bhavana', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mr. Arjun', N'9138319049', N'Bhavanachandla@gmail.com', N'2025-07-31', N'2005-04-28', N'OE', N'2025-07-31', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhavana', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mr. Arjun', [fatherName]),
        [mobile] = ISNULL(N'9138319049', [mobile]),
        [email] = ISNULL(N'Bhavanachandla@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-31', [joiningDate]),
        [dob] = ISNULL(N'2005-04-28', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-31', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50456';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50458')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50458', N'Muskan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mr. Sanjay Kumar', N'8580503644', N'thakurmuskan1818@gmail.com', N'2025-07-31', N'2007-06-24', N'OE', N'2025-07-31', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muskan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mr. Sanjay Kumar', [fatherName]),
        [mobile] = ISNULL(N'8580503644', [mobile]),
        [email] = ISNULL(N'thakurmuskan1818@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-31', [joiningDate]),
        [dob] = ISNULL(N'2007-06-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-31', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50458';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40397')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40397', N'Pawna Devi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Gumat Ram', N'8091044406', N'pawance20@gmail.com', N'2023-09-11', N'2003-09-20', N'OE', N'2023-09-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pawna Devi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Gumat Ram', [fatherName]),
        [mobile] = ISNULL(N'8091044406', [mobile]),
        [email] = ISNULL(N'pawance20@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-09-11', [joiningDate]),
        [dob] = ISNULL(N'2003-09-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40397';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40398')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40398', N'Chandni', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Ashok Kumar', N'7495016795', N'chandni7495@gmail.com', N'2023-09-11', N'2003-12-08', N'OE', N'2023-09-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandni', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Ashok Kumar', [fatherName]),
        [mobile] = ISNULL(N'7495016795', [mobile]),
        [email] = ISNULL(N'chandni7495@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-09-11', [joiningDate]),
        [dob] = ISNULL(N'2003-12-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40398';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40400')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40400', N'Sunaina Devi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Surender singh', N'7807885031', N'Sunainakaundal76@gmail.com', N'2023-09-11', N'2002-10-10', N'OE', N'2023-09-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunaina Devi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Surender singh', [fatherName]),
        [mobile] = ISNULL(N'7807885031', [mobile]),
        [email] = ISNULL(N'Sunainakaundal76@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-09-11', [joiningDate]),
        [dob] = ISNULL(N'2002-10-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40400';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E20171')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E20171', N'Chandra Prakash Bharti', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sh:Ratan Prakash Bharti', N'9467876510', N'cpb986@gmail.com', N'2011-05-16', N'1986-12-10', N'Jr.Engineer', N'2011-05-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandra Prakash Bharti', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sh:Ratan Prakash Bharti', [fatherName]),
        [mobile] = ISNULL(N'9467876510', [mobile]),
        [email] = ISNULL(N'cpb986@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2011-05-16', [joiningDate]),
        [dob] = ISNULL(N'1986-12-10', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2011-05-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E20171';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40031')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40031', N'Deepak Pandey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sh.Dharam Raj Pandey', N'9459696600', N'Pandeydeepak43173@gmail.com', N'2010-11-23', N'1986-01-11', N'Jr.Engineer', N'2010-11-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak Pandey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sh.Dharam Raj Pandey', [fatherName]),
        [mobile] = ISNULL(N'9459696600', [mobile]),
        [email] = ISNULL(N'Pandeydeepak43173@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2010-11-23', [joiningDate]),
        [dob] = ISNULL(N'1986-01-11', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-11-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40031';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40056')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40056', N'Mahesh Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sh Jagdish  Chander', N'9816352844', N'Mahesh.bhargava86@gmail.com', N'2009-06-11', N'1986-04-21', N'Jr.Engineer', N'2009-06-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mahesh Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sh Jagdish  Chander', [fatherName]),
        [mobile] = ISNULL(N'9816352844', [mobile]),
        [email] = ISNULL(N'Mahesh.bhargava86@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2009-06-11', [joiningDate]),
        [dob] = ISNULL(N'1986-04-21', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2009-06-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40056';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40062')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40062', N'Mohit Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Rajan Verma', N'9816565915', N'verma.mohit08@gmail.com', N'2010-06-02', N'1988-06-28', N'Jr.Engineer', N'2010-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohit Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Rajan Verma', [fatherName]),
        [mobile] = ISNULL(N'9816565915', [mobile]),
        [email] = ISNULL(N'verma.mohit08@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2010-06-02', [joiningDate]),
        [dob] = ISNULL(N'1988-06-28', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40062';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40097')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40097', N'Satinder Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sh.Sudesh Kumar', N'9805249620', N'Satinder12kumar@gmail.com', N'2010-06-04', N'1988-10-25', N'Jr.Engineer', N'2010-06-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Satinder Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sh.Sudesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'9805249620', [mobile]),
        [email] = ISNULL(N'Satinder12kumar@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2010-06-04', [joiningDate]),
        [dob] = ISNULL(N'1988-10-25', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-06-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40097';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40217')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40217', N'Rajeev Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mohar Singh', N'9459064135', N'Rajeev98573@gmail.com', N'2012-05-14', N'1989-09-12', N'Jr.Engineer', N'2012-05-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rajeev Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mohar Singh', [fatherName]),
        [mobile] = ISNULL(N'9459064135', [mobile]),
        [email] = ISNULL(N'Rajeev98573@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2012-05-14', [joiningDate]),
        [dob] = ISNULL(N'1989-09-12', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-05-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40217';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40229')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40229', N'Abhishek Soharu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sh.Kulwant Singh Soharu', N'9816065917', N'abhishekthakur4328@gmail.com', N'2012-08-17', N'1991-08-08', N'Jr.Engineer', N'2012-08-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhishek Soharu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sh.Kulwant Singh Soharu', [fatherName]),
        [mobile] = ISNULL(N'9816065917', [mobile]),
        [email] = ISNULL(N'abhishekthakur4328@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2012-08-17', [joiningDate]),
        [dob] = ISNULL(N'1991-08-08', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40229';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40237')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40237', N'Deepak', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Mohan Lal', N'9805171018', N'deepakkumar6may@gmail.com', N'2013-02-18', N'1991-05-06', N'Jr.Engineer', N'2013-02-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Mohan Lal', [fatherName]),
        [mobile] = ISNULL(N'9805171018', [mobile]),
        [email] = ISNULL(N'deepakkumar6may@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-02-18', [joiningDate]),
        [dob] = ISNULL(N'1991-05-06', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-02-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40237';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40317')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40317', N'Raksha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Dhram Singh', N'9459771873', N'Raksharao903@gmail.com', N'2014-09-11', N'1993-09-24', N'Jr.Engineer', N'2014-09-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raksha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Dhram Singh', [fatherName]),
        [mobile] = ISNULL(N'9459771873', [mobile]),
        [email] = ISNULL(N'Raksharao903@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-09-11', [joiningDate]),
        [dob] = ISNULL(N'1993-09-24', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40317';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40330')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40330', N'Amardeep Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Kishan Chand', N'9034869830', N'amardeepd03@gmail.com', N'2014-09-11', N'1993-10-17', N'Jr.Engineer', N'2014-09-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Amardeep Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Kishan Chand', [fatherName]),
        [mobile] = ISNULL(N'9034869830', [mobile]),
        [email] = ISNULL(N'amardeepd03@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-09-11', [joiningDate]),
        [dob] = ISNULL(N'1993-10-17', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40330';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40343')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40343', N'Nitesh Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jai Bhagwan', N'8708497592', N'ns6724577@gmail.com', N'2015-08-25', N'1994-03-02', N'Jr.Engineer', N'2015-08-25', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitesh Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jai Bhagwan', [fatherName]),
        [mobile] = ISNULL(N'8708497592', [mobile]),
        [email] = ISNULL(N'ns6724577@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-08-25', [joiningDate]),
        [dob] = ISNULL(N'1994-03-02', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-08-25', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40343';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40348')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40348', N'Ashu Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Gurucharan Verma', N'9896445897', N'ashuverma0804@gmail.com', N'2015-09-17', N'1996-08-22', N'Jr.Engineer', N'2015-09-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ashu Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Gurucharan Verma', [fatherName]),
        [mobile] = ISNULL(N'9896445897', [mobile]),
        [email] = ISNULL(N'ashuverma0804@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-09-17', [joiningDate]),
        [dob] = ISNULL(N'1996-08-22', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-09-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40348';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40363')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40363', N'Charu Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Madan lal', N'8219962299', N'charu9459616385@gmail.com', N'2017-04-24', N'1994-11-08', N'Jr.Engineer', N'2017-04-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Charu Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Madan lal', [fatherName]),
        [mobile] = ISNULL(N'8219962299', [mobile]),
        [email] = ISNULL(N'charu9459616385@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-04-24', [joiningDate]),
        [dob] = ISNULL(N'1994-11-08', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-04-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40363';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40373')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40373', N'Kajal Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Vijay Singh', N'9459534287', N'thakurkajal94598.kt@gmail.com', N'2017-06-26', N'1995-12-29', N'Jr.Engineer', N'2017-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kajal Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Vijay Singh', [fatherName]),
        [mobile] = ISNULL(N'9459534287', [mobile]),
        [email] = ISNULL(N'thakurkajal94598.kt@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-06-26', [joiningDate]),
        [dob] = ISNULL(N'1995-12-29', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40373';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50064')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50064', N'Vinod Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Lekh Ram', N'9816428806', N'vinod.shail2@gmail.com', N'2011-01-17', N'1990-05-24', N'Jr.Engineer', N'2011-01-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vinod Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Lekh Ram', [fatherName]),
        [mobile] = ISNULL(N'9816428806', [mobile]),
        [email] = ISNULL(N'vinod.shail2@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2011-01-17', [joiningDate]),
        [dob] = ISNULL(N'1990-05-24', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2011-01-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50064';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50068')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50068', N'Rajesh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Bhader Singh', N'9459251416', N'ankurana420@gmail.com', N'2013-01-16', N'1992-06-11', N'Jr.Engineer', N'2013-01-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rajesh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Bhader Singh', [fatherName]),
        [mobile] = ISNULL(N'9459251416', [mobile]),
        [email] = ISNULL(N'ankurana420@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-01-16', [joiningDate]),
        [dob] = ISNULL(N'1992-06-11', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-01-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50068';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50074')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50074', N'Bhim Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Om Chand', N'8988334002', N'bhim15253@gmail.com', N'2013-03-14', N'1990-12-02', N'Jr.Engineer', N'2013-03-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhim Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Om Chand', [fatherName]),
        [mobile] = ISNULL(N'8988334002', [mobile]),
        [email] = ISNULL(N'bhim15253@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1990-12-02', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50074';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50078')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50078', N'Munish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Hem Sankar', N'9857632781', N'monushandil@gmail.com', N'2013-03-14', N'1991-03-01', N'Jr.Engineer', N'2013-03-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Munish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Hem Sankar', [fatherName]),
        [mobile] = ISNULL(N'9857632781', [mobile]),
        [email] = ISNULL(N'monushandil@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1991-03-01', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50078';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50079')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50079', N'Sanjeev Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sh.Gurbaksh Singh', N'9017118916', N'bunty.dhiman6540@gmail.com', N'2013-03-14', N'1990-12-25', N'Jr.Engineer', N'2013-03-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sanjeev Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sh.Gurbaksh Singh', [fatherName]),
        [mobile] = ISNULL(N'9017118916', [mobile]),
        [email] = ISNULL(N'bunty.dhiman6540@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1990-12-25', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50079';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50083')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50083', N'Bhanu Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Baldev Singh', N'9418141482', N'thakurbhanu82@gmail.com', N'2013-03-14', N'1992-11-10', N'Jr.Engineer', N'2013-03-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhanu Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Baldev Singh', [fatherName]),
        [mobile] = ISNULL(N'9418141482', [mobile]),
        [email] = ISNULL(N'thakurbhanu82@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1992-11-10', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50083';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50084')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50084', N'Anu Devi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Premu Ram', N'9625577419', N'anuheer710@gmail.com', N'2012-08-17', N'1990-07-02', N'Jr.Engineer', N'2012-08-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anu Devi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Premu Ram', [fatherName]),
        [mobile] = ISNULL(N'9625577419', [mobile]),
        [email] = ISNULL(N'anuheer710@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2012-08-17', [joiningDate]),
        [dob] = ISNULL(N'1990-07-02', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50084';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50095')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50095', N'Desh Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Inder Singh', N'8679891863', N'deshr3583@gmail.com', N'2012-03-01', N'1991-03-18', N'Jr.Engineer', N'2012-03-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Desh Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Inder Singh', [fatherName]),
        [mobile] = ISNULL(N'8679891863', [mobile]),
        [email] = ISNULL(N'deshr3583@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2012-03-01', [joiningDate]),
        [dob] = ISNULL(N'1991-03-18', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-03-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50095';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50107')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50107', N'Hemant Kumar Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Nand Lal Sharma', N'7018509966', N'h.k.s05061992@gmail.com', N'2013-09-02', N'1992-10-14', N'Jr.Engineer', N'2013-09-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Hemant Kumar Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Nand Lal Sharma', [fatherName]),
        [mobile] = ISNULL(N'7018509966', [mobile]),
        [email] = ISNULL(N'h.k.s05061992@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2013-09-02', [joiningDate]),
        [dob] = ISNULL(N'1992-10-14', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-09-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50107';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50118')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50118', N'Aarti Bhardwaj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Ganga Ram Bhardwaj', N'8894958614', N'aartibhardwaj209@gmail.com', N'2014-07-01', N'1992-12-10', N'Jr.Engineer', N'2014-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aarti Bhardwaj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Ganga Ram Bhardwaj', [fatherName]),
        [mobile] = ISNULL(N'8894958614', [mobile]),
        [email] = ISNULL(N'aartibhardwaj209@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-07-01', [joiningDate]),
        [dob] = ISNULL(N'1992-12-10', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50118';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50137')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50137', N'Sunil Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sikandar Singh', N'9736863502', N'sunilrajpoot003@gmail.com', N'2014-07-10', N'1990-05-03', N'Jr.Engineer', N'2014-07-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunil Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sikandar Singh', [fatherName]),
        [mobile] = ISNULL(N'9736863502', [mobile]),
        [email] = ISNULL(N'sunilrajpoot003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-07-10', [joiningDate]),
        [dob] = ISNULL(N'1990-05-03', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-07-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50137';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50142')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50142', N'Gurdeep Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Balbir Singh', N'9466881243', N'gurdeepr13@gmail.com', N'2014-07-10', N'1991-01-06', N'Jr.Engineer', N'2014-07-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gurdeep Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Balbir Singh', [fatherName]),
        [mobile] = ISNULL(N'9466881243', [mobile]),
        [email] = ISNULL(N'gurdeepr13@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-07-10', [joiningDate]),
        [dob] = ISNULL(N'1991-01-06', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-07-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50142';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50173')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50173', N'Lalit', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Satish Kumar', N'9805754825', N'lalitbhanyari@gmail.com', N'2014-08-27', N'1995-05-11', N'Jr.Engineer', N'2014-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lalit', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Satish Kumar', [fatherName]),
        [mobile] = ISNULL(N'9805754825', [mobile]),
        [email] = ISNULL(N'lalitbhanyari@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-08-27', [joiningDate]),
        [dob] = ISNULL(N'1995-05-11', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50173';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50174')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50174', N'Vishal Chaudhary', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Tilak Raj', N'9816536239', N'vishal32023@gmail.com', N'2014-08-27', N'1994-10-31', N'Jr.Engineer', N'2014-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vishal Chaudhary', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Tilak Raj', [fatherName]),
        [mobile] = ISNULL(N'9816536239', [mobile]),
        [email] = ISNULL(N'vishal32023@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-08-27', [joiningDate]),
        [dob] = ISNULL(N'1994-10-31', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50174';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50175')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50175', N'Atul Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Joginder Singh', N'8628819756', N'atulkumar.ak378@gmail.com', N'2014-08-27', N'1995-05-01', N'Jr.Engineer', N'2014-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Atul Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Joginder Singh', [fatherName]),
        [mobile] = ISNULL(N'8628819756', [mobile]),
        [email] = ISNULL(N'atulkumar.ak378@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-08-27', [joiningDate]),
        [dob] = ISNULL(N'1995-05-01', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50175';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50185')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50185', N'Vaneet Angaria', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Dandu Ram', N'9459001205', N'vaneetangria333@gmail.com', N'2014-08-27', N'1992-07-20', N'Jr.Engineer', N'2014-08-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vaneet Angaria', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Dandu Ram', [fatherName]),
        [mobile] = ISNULL(N'9459001205', [mobile]),
        [email] = ISNULL(N'vaneetangria333@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-08-27', [joiningDate]),
        [dob] = ISNULL(N'1992-07-20', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50185';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50215')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50215', N'Gagan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jai Pal', N'9459764585', N'kgagan023@gmail.com', N'2014-10-14', N'1993-05-24', N'Jr.Engineer', N'2014-10-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gagan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jai Pal', [fatherName]),
        [mobile] = ISNULL(N'9459764585', [mobile]),
        [email] = ISNULL(N'kgagan023@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-10-14', [joiningDate]),
        [dob] = ISNULL(N'1993-05-24', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-10-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50215';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50220')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50220', N'Mohan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Nanak Chand', N'8263804296', N'mohanrajput0008@gmail.com', N'2015-02-09', N'1993-03-07', N'Jr.Engineer', N'2015-02-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Nanak Chand', [fatherName]),
        [mobile] = ISNULL(N'8263804296', [mobile]),
        [email] = ISNULL(N'mohanrajput0008@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-02-09', [joiningDate]),
        [dob] = ISNULL(N'1993-03-07', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-02-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50220';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50222')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50222', N'Sushant Dhiman', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Ramesh Kumar', N'9459954218', N'sushant.dhiman34@gmail.com', N'2015-02-09', N'1993-07-14', N'Jr.Engineer', N'2015-02-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sushant Dhiman', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Ramesh Kumar', [fatherName]),
        [mobile] = ISNULL(N'9459954218', [mobile]),
        [email] = ISNULL(N'sushant.dhiman34@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-02-09', [joiningDate]),
        [dob] = ISNULL(N'1993-07-14', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-02-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50222';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50224')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50224', N'Puneet Ondial', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Joginder Singh', N'8219813605', N'puneetthakur922@gmail.com', N'2015-02-09', N'1994-07-29', N'Jr.Engineer', N'2015-02-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Puneet Ondial', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Joginder Singh', [fatherName]),
        [mobile] = ISNULL(N'8219813605', [mobile]),
        [email] = ISNULL(N'puneetthakur922@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-02-09', [joiningDate]),
        [dob] = ISNULL(N'1994-07-29', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-02-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50224';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50225')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50225', N'Rajesh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Govind Lal', N'9418871688', N'kashyapraaj225@gmail.com', N'2015-02-10', N'1988-05-21', N'Jr.Engineer', N'2015-02-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rajesh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Govind Lal', [fatherName]),
        [mobile] = ISNULL(N'9418871688', [mobile]),
        [email] = ISNULL(N'kashyapraaj225@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-02-10', [joiningDate]),
        [dob] = ISNULL(N'1988-05-21', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-02-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50225';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50230')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50230', N'Vineet Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jeet Ram', N'9816424499', N'kshekhar558@gmail.com', N'2015-02-09', N'1992-06-03', N'Jr.Engineer', N'2015-02-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vineet Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jeet Ram', [fatherName]),
        [mobile] = ISNULL(N'9816424499', [mobile]),
        [email] = ISNULL(N'kshekhar558@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-02-09', [joiningDate]),
        [dob] = ISNULL(N'1992-06-03', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-02-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50230';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50231')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50231', N'Vinay Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Barfi Ram', N'9857726280', N'vermavinay140@gmail.com', N'2015-02-09', N'1992-03-27', N'Jr.Engineer', N'2015-02-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vinay Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Barfi Ram', [fatherName]),
        [mobile] = ISNULL(N'9857726280', [mobile]),
        [email] = ISNULL(N'vermavinay140@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-02-09', [joiningDate]),
        [dob] = ISNULL(N'1992-03-27', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-02-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50231';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50240')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50240', N'Arun Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Lal Chand', N'9805128157', N'arun75020@gmail.com', N'2015-04-20', N'1993-04-26', N'Jr.Engineer', N'2015-04-20', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arun Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Lal Chand', [fatherName]),
        [mobile] = ISNULL(N'9805128157', [mobile]),
        [email] = ISNULL(N'arun75020@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-04-20', [joiningDate]),
        [dob] = ISNULL(N'1993-04-26', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-04-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50240';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50242')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50242', N'Vikas Choudhary', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Satpal Choudhary', N'9816565698', N'vikaschoudhary22.vc@gmail.com', N'2015-04-20', N'1992-08-22', N'Jr.Engineer', N'2015-04-20', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vikas Choudhary', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Satpal Choudhary', [fatherName]),
        [mobile] = ISNULL(N'9816565698', [mobile]),
        [email] = ISNULL(N'vikaschoudhary22.vc@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-04-20', [joiningDate]),
        [dob] = ISNULL(N'1992-08-22', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-04-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50242';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50254')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50254', N'Abinash Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Rajinder Kumar', N'8679960633', N'abithakur254@gmail.com', N'2015-07-08', N'1993-08-19', N'Jr.Engineer', N'2015-07-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abinash Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Rajinder Kumar', [fatherName]),
        [mobile] = ISNULL(N'8679960633', [mobile]),
        [email] = ISNULL(N'abithakur254@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-07-08', [joiningDate]),
        [dob] = ISNULL(N'1993-08-19', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50254';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50277')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50277', N'Arpit Sood', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Shashi Pal', N'8894687428', N'arpitsood030@gmail.com', N'2015-07-01', N'1993-03-31', N'Jr.Engineer', N'2015-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arpit Sood', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Shashi Pal', [fatherName]),
        [mobile] = ISNULL(N'8894687428', [mobile]),
        [email] = ISNULL(N'arpitsood030@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-07-01', [joiningDate]),
        [dob] = ISNULL(N'1993-03-31', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50277';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50279')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50279', N'Lakhwinder Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Yashwant Singh', N'9459250621', N'lakhwindersingh858@gmail.com', N'2015-07-01', N'1990-08-12', N'Jr.Engineer', N'2015-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lakhwinder Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Yashwant Singh', [fatherName]),
        [mobile] = ISNULL(N'9459250621', [mobile]),
        [email] = ISNULL(N'lakhwindersingh858@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-07-01', [joiningDate]),
        [dob] = ISNULL(N'1990-08-12', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50279';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50282')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50282', N'Manjeet Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Raghuvir Singh', N'9805629763', N'manjeetkanwar777@gmail.com', N'2015-07-01', N'1993-06-24', N'Jr.Engineer', N'2015-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manjeet Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Raghuvir Singh', [fatherName]),
        [mobile] = ISNULL(N'9805629763', [mobile]),
        [email] = ISNULL(N'manjeetkanwar777@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-07-01', [joiningDate]),
        [dob] = ISNULL(N'1993-06-24', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50282';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50285')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50285', N'Rahul Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Chaman Lal', N'9318666157', N'jisharmaji93@gmail.com', N'2015-08-25', N'1993-04-04', N'Jr.Engineer', N'2015-08-25', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Chaman Lal', [fatherName]),
        [mobile] = ISNULL(N'9318666157', [mobile]),
        [email] = ISNULL(N'jisharmaji93@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-08-25', [joiningDate]),
        [dob] = ISNULL(N'1993-04-04', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-08-25', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50285';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50299')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50299', N'Om Prakash', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Babu Ram', N'9816052565', N'jaryalomi666@gmail.com', N'2015-09-17', N'1992-02-08', N'Jr.Engineer', N'2015-09-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Om Prakash', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Babu Ram', [fatherName]),
        [mobile] = ISNULL(N'9816052565', [mobile]),
        [email] = ISNULL(N'jaryalomi666@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-09-17', [joiningDate]),
        [dob] = ISNULL(N'1992-02-08', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-09-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50299';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50300')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50300', N'Vinod Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jai Lal', N'9882226431', N'vs127753@gmail.com', N'2015-09-17', N'1993-03-02', N'Jr.Engineer', N'2015-09-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vinod Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jai Lal', [fatherName]),
        [mobile] = ISNULL(N'9882226431', [mobile]),
        [email] = ISNULL(N'vs127753@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2015-09-17', [joiningDate]),
        [dob] = ISNULL(N'1993-03-02', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-09-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50300';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50315')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50315', N'Sunil Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jeet Singh', N'9816733866', N'sunilthakur56496@gmail.com', N'2016-02-15', N'1995-01-04', N'Jr.Engineer', N'2016-02-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunil Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jeet Singh', [fatherName]),
        [mobile] = ISNULL(N'9816733866', [mobile]),
        [email] = ISNULL(N'sunilthakur56496@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-02-15', [joiningDate]),
        [dob] = ISNULL(N'1995-01-04', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-02-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50315';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50319')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50319', N'Ankit Vashisht', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Kulbhushan Kumar', N'8950661283', N'ankitvashisht0997@icloud.com', N'2016-02-15', N'1995-07-10', N'Jr.Engineer', N'2016-02-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankit Vashisht', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Kulbhushan Kumar', [fatherName]),
        [mobile] = ISNULL(N'8950661283', [mobile]),
        [email] = ISNULL(N'ankitvashisht0997@icloud.com', [email]),
        [joiningDate] = ISNULL(N'2016-02-15', [joiningDate]),
        [dob] = ISNULL(N'1995-07-10', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-02-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50319';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50335')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50335', N'Abhishek Sonkar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Yogesh Sonkar', N'7988550537', N'abhisonkar27@gmail.com', N'2016-04-13', N'1994-06-22', N'Jr.Engineer', N'2016-04-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhishek Sonkar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Yogesh Sonkar', [fatherName]),
        [mobile] = ISNULL(N'7988550537', [mobile]),
        [email] = ISNULL(N'abhisonkar27@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-04-13', [joiningDate]),
        [dob] = ISNULL(N'1994-06-22', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-04-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50335';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50337')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50337', N'Ajay Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Parkesh Chand', N'8627976704', N'kumarajay94025@gmail.com', N'2016-04-13', N'1994-08-23', N'Jr.Engineer', N'2016-04-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ajay Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Parkesh Chand', [fatherName]),
        [mobile] = ISNULL(N'8627976704', [mobile]),
        [email] = ISNULL(N'kumarajay94025@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-04-13', [joiningDate]),
        [dob] = ISNULL(N'1994-08-23', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-04-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50337';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50338')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50338', N'Madhu Bala', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Nathu Ram', N'8988650599', N'balabhardwajmadhu62@gmail.com', N'2016-04-13', N'1994-08-03', N'Jr.Engineer', N'2016-04-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Madhu Bala', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Nathu Ram', [fatherName]),
        [mobile] = ISNULL(N'8988650599', [mobile]),
        [email] = ISNULL(N'balabhardwajmadhu62@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-04-13', [joiningDate]),
        [dob] = ISNULL(N'1994-08-03', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-04-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50338';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50372')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50372', N'Amit Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Dhruv Dev', N'9816405503', N'mituchoudhary721@gmail.com', N'2016-07-12', N'1994-02-21', N'Jr.Engineer', N'2016-07-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Amit Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Dhruv Dev', [fatherName]),
        [mobile] = ISNULL(N'9816405503', [mobile]),
        [email] = ISNULL(N'mituchoudhary721@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-07-12', [joiningDate]),
        [dob] = ISNULL(N'1994-02-21', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-07-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50372';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50386')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50386', N'Sanjeev Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Harbans lal', N'9882173594', N'sanjeevcho188@gmail.com', N'2017-02-27', N'1996-10-28', N'Jr.Engineer', N'2017-02-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sanjeev Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Harbans lal', [fatherName]),
        [mobile] = ISNULL(N'9882173594', [mobile]),
        [email] = ISNULL(N'sanjeevcho188@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-02-27', [joiningDate]),
        [dob] = ISNULL(N'1996-10-28', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-02-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50386';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50388')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50388', N'Kuldeep Thakur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Tilak raj', N'9459782058', N'kuldeep.thakur8013@gmail.com', N'2017-02-27', N'1994-12-31', N'Jr.Engineer', N'2017-02-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kuldeep Thakur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Tilak raj', [fatherName]),
        [mobile] = ISNULL(N'9459782058', [mobile]),
        [email] = ISNULL(N'kuldeep.thakur8013@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-02-27', [joiningDate]),
        [dob] = ISNULL(N'1994-12-31', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-02-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50388';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50390')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50390', N'Santosh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jaikant', N'8930426155', N'santoshkamat1996@gmail.com', N'2017-02-27', N'1996-05-05', N'Jr.Engineer', N'2017-02-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Santosh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jaikant', [fatherName]),
        [mobile] = ISNULL(N'8930426155', [mobile]),
        [email] = ISNULL(N'santoshkamat1996@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-02-27', [joiningDate]),
        [dob] = ISNULL(N'1996-05-05', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-02-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50390';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50413')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50413', N'Jitender Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Dola Ram', N'7018589382', N'jitenderthakur650@gmail.com', N'2017-11-20', N'1997-11-08', N'Jr.Engineer', N'2017-11-20', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jitender Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Dola Ram', [fatherName]),
        [mobile] = ISNULL(N'7018589382', [mobile]),
        [email] = ISNULL(N'jitenderthakur650@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-11-20', [joiningDate]),
        [dob] = ISNULL(N'1997-11-08', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-11-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50413';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50416')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50416', N'Akshay Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Prakash Vir', N'9817498473', N'akshaysharma98473@gmail.com', N'2017-11-20', N'1997-01-09', N'Jr.Engineer', N'2017-11-20', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Akshay Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Prakash Vir', [fatherName]),
        [mobile] = ISNULL(N'9817498473', [mobile]),
        [email] = ISNULL(N'akshaysharma98473@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-11-20', [joiningDate]),
        [dob] = ISNULL(N'1997-01-09', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-11-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50416';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50428')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50428', N'Rohit Bhardwaj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Ashok kumar', N'9816055045', N'iamrohitbhardwaj789@gmail.com', N'2018-02-02', N'1996-02-28', N'Jr.Engineer', N'2018-02-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rohit Bhardwaj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Ashok kumar', [fatherName]),
        [mobile] = ISNULL(N'9816055045', [mobile]),
        [email] = ISNULL(N'iamrohitbhardwaj789@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-02-02', [joiningDate]),
        [dob] = ISNULL(N'1996-02-28', [dob]),
        [designation] = ISNULL(N'Jr.Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-02-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50428';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50482')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50482', N'Yashika', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Inder Singh', N'8287448104', N'yashikabangari7@gmail.com', N'2026-10-05', N'2007-06-01', N'OET', N'2026-10-05', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Yashika', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Inder Singh', [fatherName]),
        [mobile] = ISNULL(N'8287448104', [mobile]),
        [email] = ISNULL(N'yashikabangari7@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-05', [joiningDate]),
        [dob] = ISNULL(N'2007-06-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50482';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50481')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50481', N'Deepika', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Suresh Chaudhary', N'9258675531', N'kcgchaudhary1985@gmail.com', N'2026-10-05', N'2006-04-09', N'OET', N'2026-10-05', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepika', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Suresh Chaudhary', [fatherName]),
        [mobile] = ISNULL(N'9258675531', [mobile]),
        [email] = ISNULL(N'kcgchaudhary1985@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-05', [joiningDate]),
        [dob] = ISNULL(N'2006-04-09', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50481';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50480')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50480', N'Kajal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Rajeev', N'9411288342', N'kajalpal6500646@gmail.com', N'2026-10-05', N'2006-01-08', N'OET', N'2026-10-05', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kajal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Rajeev', [fatherName]),
        [mobile] = ISNULL(N'9411288342', [mobile]),
        [email] = ISNULL(N'kajalpal6500646@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-05', [joiningDate]),
        [dob] = ISNULL(N'2006-01-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50480';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50470')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50470', N'Muskan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Jarnail singh', N'8683007590', N'muskankalpana66@gmail.com', N'2026-09-26', N'2006-03-14', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muskan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Jarnail singh', [fatherName]),
        [mobile] = ISNULL(N'8683007590', [mobile]),
        [email] = ISNULL(N'muskankalpana66@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2006-03-14', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50470';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50471')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50471', N'Anuradha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Girjashankar yadav', N'8299393010', N'yadavanuradh595@gmail.com', N'2026-09-26', N'2004-07-05', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anuradha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Girjashankar yadav', [fatherName]),
        [mobile] = ISNULL(N'8299393010', [mobile]),
        [email] = ISNULL(N'yadavanuradh595@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2004-07-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50471';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50472')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50472', N'Khushi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sunil Kumar', N'9317930577', N'khushichugain2006@gmail.com', N'2026-09-26', N'2006-12-20', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Khushi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sunil Kumar', [fatherName]),
        [mobile] = ISNULL(N'9317930577', [mobile]),
        [email] = ISNULL(N'khushichugain2006@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2006-12-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50472';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50473')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50473', N'Shali', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Sukhinder Singh', N'8899320212', N'shalidevi8899@gmail.com', N'2026-09-26', N'2007-01-05', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shali', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Sukhinder Singh', [fatherName]),
        [mobile] = ISNULL(N'8899320212', [mobile]),
        [email] = ISNULL(N'shalidevi8899@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2007-01-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50473';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50474')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50474', N'Jatin', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Gorkh Singh', N'8803706051', N'Js95968248@gmail.com', N'2026-09-26', N'2005-10-18', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jatin', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Gorkh Singh', [fatherName]),
        [mobile] = ISNULL(N'8803706051', [mobile]),
        [email] = ISNULL(N'Js95968248@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2005-10-18', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50474';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50475')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50475', N'Rahul', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Ashok Kumar', N'9541715861', N'Rsharma18363@gmail.com', N'2026-09-26', N'2006-07-03', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Ashok Kumar', [fatherName]),
        [mobile] = ISNULL(N'9541715861', [mobile]),
        [email] = ISNULL(N'Rsharma18363@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2006-07-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50475';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50476')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50476', N'Pranav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Surinder Kumar', N'6006814291', N'Pranavkumar600681429@gmail.com', N'2026-09-26', N'2005-08-10', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pranav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Surinder Kumar', [fatherName]),
        [mobile] = ISNULL(N'6006814291', [mobile]),
        [email] = ISNULL(N'Pranavkumar600681429@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2005-08-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50476';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50477')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50477', N'Malik', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'manzoor ahmad malik', N'9149463603', N'omaismalik01@gmail.com', N'2026-09-26', N'2006-03-03', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Malik', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'manzoor ahmad malik', [fatherName]),
        [mobile] = ISNULL(N'9149463603', [mobile]),
        [email] = ISNULL(N'omaismalik01@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2006-03-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50477';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50478')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50478', N'Muskan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Kuldeep Singh', N'8295683665', N'muskansimre24@gmail.com', N'2026-09-26', N'2006-06-24', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muskan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Kuldeep Singh', [fatherName]),
        [mobile] = ISNULL(N'8295683665', [mobile]),
        [email] = ISNULL(N'muskansimre24@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'2006-06-24', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50478';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50479')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50479', N'Simran', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitParwanoo, @deptPrw,
        N'Vijaypal', N'7988757434', N'simransimrankabir@gmail.com', N'2026-09-26', N'19/11/2005', N'OET', N'2026-09-26', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Simran', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Vijaypal', [fatherName]),
        [mobile] = ISNULL(N'7988757434', [mobile]),
        [email] = ISNULL(N'simransimrankabir@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-26', [joiningDate]),
        [dob] = ISNULL(N'19/11/2005', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50479';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40022')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40022', N'Banita Chaudhary', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitParwanoo, @deptPrw,
        NULL, N'9459715924', N'banita.chaudhary@mahle.com', N'2010-11-23', N'1989-07-20', N'TL', N'2010-11-23', N'M3-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Banita Chaudhary', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'9459715924', [mobile]),
        [email] = ISNULL(N'banita.chaudhary@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2010-11-23', [joiningDate]),
        [dob] = ISNULL(N'1989-07-20', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-11-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40022';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E40101')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E40101', N'Sanjesh Chauhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitParwanoo, @deptPrw,
        N'Rattan Singh', N'9805940444', N'sanjesh.chauhan@mahle.com', N'2012-05-01', N'1987-06-29', N'Production Head', N'2012-05-01', N'6'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sanjesh Chauhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Rattan Singh', [fatherName]),
        [mobile] = ISNULL(N'9805940444', [mobile]),
        [email] = ISNULL(N'sanjesh.chauhan@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2012-05-01', [joiningDate]),
        [dob] = ISNULL(N'1987-06-29', [dob]),
        [designation] = ISNULL(N'Production Head', [designation]),
        [groupJoiningDate] = ISNULL(N'2012-05-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'6', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E40101';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50045')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50045', N'Satish Kumar Bhardwaj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitParwanoo, @deptPrw,
        N'Madan Lal', N'9882940793', N'satish.bhardwaj@mahle.com', N'2010-05-13', N'1988-01-06', N'VSL', N'2010-05-13', N'4'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Satish Kumar Bhardwaj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Madan Lal', [fatherName]),
        [mobile] = ISNULL(N'9882940793', [mobile]),
        [email] = ISNULL(N'satish.bhardwaj@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2010-05-13', [joiningDate]),
        [dob] = ISNULL(N'1988-01-06', [dob]),
        [designation] = ISNULL(N'VSL', [designation]),
        [groupJoiningDate] = ISNULL(N'2010-05-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'4', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50045';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50076')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50076', N'Arun Chauhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitParwanoo, @deptPrw,
        N'Bheem Singh Chauhan', N'9817801783', N'arun.chauhan@mahle.com', N'2013-03-14', N'1991-01-07', N'VSL', N'2013-03-14', N'4'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arun Chauhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Bheem Singh Chauhan', [fatherName]),
        [mobile] = ISNULL(N'9817801783', [mobile]),
        [email] = ISNULL(N'arun.chauhan@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2013-03-14', [joiningDate]),
        [dob] = ISNULL(N'1991-01-07', [dob]),
        [designation] = ISNULL(N'VSL', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-03-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'4', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50076';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50135')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50135', N'Puneet Bhardwaj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitParwanoo, @deptPrw,
        N'Shiv Dutt Bhardwaj', N'9812887789', N'puneet.bhardwaj@mahle.com', N'2014-07-10', N'1993-01-14', N'TL', N'2014-07-10', N'M3-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Puneet Bhardwaj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Shiv Dutt Bhardwaj', [fatherName]),
        [mobile] = ISNULL(N'9812887789', [mobile]),
        [email] = ISNULL(N'puneet.bhardwaj@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2014-07-10', [joiningDate]),
        [dob] = ISNULL(N'1993-01-14', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-07-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50135';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50162')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50162', N'Shashi Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitParwanoo, @deptPrw,
        N'Nand Lal', N'8544703767', N'shashikumargreenhills@gmail.com', N'2014-08-27', N'1994-08-29', N'TL', N'2014-08-27', N'M3-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shashi Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Nand Lal', [fatherName]),
        [mobile] = ISNULL(N'8544703767', [mobile]),
        [email] = ISNULL(N'shashikumargreenhills@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-08-27', [joiningDate]),
        [dob] = ISNULL(N'1994-08-29', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50162';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50432')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50432', N'Ankur', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitParwanoo, @deptPrw,
        N'Het Ram', N'9034827107', N'Ankur.b.kumar@mahle.com', N'2023-04-01', N'1990-03-09', N'OE lead', N'2023-04-01', N'5'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankur', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'Het Ram', [fatherName]),
        [mobile] = ISNULL(N'9034827107', [mobile]),
        [email] = ISNULL(N'Ankur.b.kumar@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2023-04-01', [joiningDate]),
        [dob] = ISNULL(N'1990-03-09', [dob]),
        [designation] = ISNULL(N'OE lead', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-04-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'5', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50432';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'E50438')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'E50438', N'Parul Walia', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rHrHead, @unitParwanoo, @deptPrw,
        NULL, N'8100000658', N'Parul.walia@mahle.com', N'2025-06-23', N'1990-09-02', N'HR head', N'2025-06-23', N'6'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Parul Walia', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rHrHead,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(NULL, [fatherName]),
        [mobile] = ISNULL(N'8100000658', [mobile]),
        [email] = ISNULL(N'Parul.walia@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-23', [joiningDate]),
        [dob] = ISNULL(N'1990-09-02', [dob]),
        [designation] = ISNULL(N'HR head', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'6', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'E50438';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K01069')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K01069', N'SAHIL', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitParwanoo, @deptPrw,
        N'MANOHAR LAL SHARMA', N'8899320212', N'sahil.a.sharma@mahle.com', N'2016-02-22', N'1994-08-20', N'TL', N'2016-02-22', N'M3-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SAHIL', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitParwanoo,
        [departmentId] = ISNULL([departmentId], @deptPrw),
        [fatherName] = ISNULL(N'MANOHAR LAL SHARMA', [fatherName]),
        [mobile] = ISNULL(N'8899320212', [mobile]),
        [email] = ISNULL(N'sahil.a.sharma@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2016-02-22', [joiningDate]),
        [dob] = ISNULL(N'1994-08-20', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-02-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K01069';
END

-- ============================================================================
-- SEEDING PLANT: PUNE (169 Total Records)
-- ============================================================================

IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001234')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001234', N'Dattatray Baban Shelar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Baban', N'9822859908', N'dattatrayshelar3600@gmail.com', N'1988-06-01', N'1967-06-01', N'Worker', N'1988-06-01', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dattatray Baban Shelar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Baban', [fatherName]),
        [mobile] = ISNULL(N'9822859908', [mobile]),
        [email] = ISNULL(N'dattatrayshelar3600@gmail.com', [email]),
        [joiningDate] = ISNULL(N'1988-06-01', [joiningDate]),
        [dob] = ISNULL(N'1967-06-01', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'1988-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001234';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001239')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001239', N'Hiraman Balasaheb Gaikwad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Balasaheb', N'9767174371', N'hiramangaikwad9374@gmail.com', N'1988-06-01', N'1967-06-01', N'Worker', N'1988-06-01', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Hiraman Balasaheb Gaikwad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Balasaheb', [fatherName]),
        [mobile] = ISNULL(N'9767174371', [mobile]),
        [email] = ISNULL(N'hiramangaikwad9374@gmail.com', [email]),
        [joiningDate] = ISNULL(N'1988-06-01', [joiningDate]),
        [dob] = ISNULL(N'1967-06-01', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'1988-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001239';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001267')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001267', N'Pansare A S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Shankar Panasare', N'9604527808', N'anantapanasare29@gmail.com', N'1996-02-02', N'1968-05-29', N'Worker', N'1996-02-02', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pansare A S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Shankar Panasare', [fatherName]),
        [mobile] = ISNULL(N'9604527808', [mobile]),
        [email] = ISNULL(N'anantapanasare29@gmail.com', [email]),
        [joiningDate] = ISNULL(N'1996-02-02', [joiningDate]),
        [dob] = ISNULL(N'1968-05-29', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'1996-02-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001267';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001276')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001276', N'Ramdas Dinkar Gade', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dinkar', N'9881045071', N'gaderamdas5@gmail.com', N'1997-07-01', N'1968-06-01', N'Worker', N'1997-07-01', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ramdas Dinkar Gade', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dinkar', [fatherName]),
        [mobile] = ISNULL(N'9881045071', [mobile]),
        [email] = ISNULL(N'gaderamdas5@gmail.com', [email]),
        [joiningDate] = ISNULL(N'1997-07-01', [joiningDate]),
        [dob] = ISNULL(N'1968-06-01', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'1997-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001276';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001288')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001288', N'Deepak Chandrakant Patole', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Chandrakant', N'9822334145', N'deepakpatole4145@gmail.com', N'1998-05-20', N'1980-08-06', N'Worker', N'1998-05-20', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak Chandrakant Patole', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Chandrakant', [fatherName]),
        [mobile] = ISNULL(N'9822334145', [mobile]),
        [email] = ISNULL(N'deepakpatole4145@gmail.com', [email]),
        [joiningDate] = ISNULL(N'1998-05-20', [joiningDate]),
        [dob] = ISNULL(N'1980-08-06', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'1998-05-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001288';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001298')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001298', N'Rohidas Shamrao Khalate', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Shamrao', N'9890532931', N'Rohidaskhalate613@gmail.com', N'1999-10-08', N'1975-11-29', N'Worker', N'1999-10-08', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rohidas Shamrao Khalate', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Shamrao', [fatherName]),
        [mobile] = ISNULL(N'9890532931', [mobile]),
        [email] = ISNULL(N'Rohidaskhalate613@gmail.com', [email]),
        [joiningDate] = ISNULL(N'1999-10-08', [joiningDate]),
        [dob] = ISNULL(N'1975-11-29', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'1999-10-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001298';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001299')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001299', N'Nagpure Kalicharan Balkrishna', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kalicharan', N'9850287716', N'kalicharan.nagpure360@gmail.com', N'2000-06-01', N'1978-12-24', N'Worker', N'2000-06-01', N'W-7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nagpure Kalicharan Balkrishna', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kalicharan', [fatherName]),
        [mobile] = ISNULL(N'9850287716', [mobile]),
        [email] = ISNULL(N'kalicharan.nagpure360@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2000-06-01', [joiningDate]),
        [dob] = ISNULL(N'1978-12-24', [dob]),
        [designation] = ISNULL(N'Worker', [designation]),
        [groupJoiningDate] = ISNULL(N'2000-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'W-7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001299';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001316')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001316', N'Chougule Vishwas M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Vishwas', N'9527027707', N'vishwaschougule1316@gmail.com', N'2003-07-01', N'1974-07-06', N'Jr. Engineer', N'2003-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chougule Vishwas M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Vishwas', [fatherName]),
        [mobile] = ISNULL(N'9527027707', [mobile]),
        [email] = ISNULL(N'vishwaschougule1316@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2003-07-01', [joiningDate]),
        [dob] = ISNULL(N'1974-07-06', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2003-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001316';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001317')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001317', N'Dhumal Ananda Sitaram', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ananda', N'9689094141', N'anandadhumal457@gmail.com', N'2003-07-01', N'1982-10-18', N'Jr. Engineer', N'2003-07-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dhumal Ananda Sitaram', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ananda', [fatherName]),
        [mobile] = ISNULL(N'9689094141', [mobile]),
        [email] = ISNULL(N'anandadhumal457@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2003-07-01', [joiningDate]),
        [dob] = ISNULL(N'1982-10-18', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2003-07-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001317';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001334')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001334', N'More Samadhan D', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dnyandeo', N'9822448648', N'samadhanmore1334@gmail.com', N'2004-03-22', N'1981-08-18', N'Jr. Engineer', N'2004-03-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'More Samadhan D', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dnyandeo', [fatherName]),
        [mobile] = ISNULL(N'9822448648', [mobile]),
        [email] = ISNULL(N'samadhanmore1334@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2004-03-22', [joiningDate]),
        [dob] = ISNULL(N'1981-08-18', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2004-03-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001334';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002064')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002064', N'Gyani kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kailash Ray', N'8668709031', N'Gyaniyadavnit@gmail.com', N'2016-05-24', N'1997-04-05', N'Jr. Engineer', N'2016-05-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gyani kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kailash Ray', [fatherName]),
        [mobile] = ISNULL(N'8668709031', [mobile]),
        [email] = ISNULL(N'Gyaniyadavnit@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-05-24', [joiningDate]),
        [dob] = ISNULL(N'1997-04-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-05-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002064';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002171')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002171', N'Ravi Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Suresh Ray', N'7056340234', N'mr.raviray420@gmail.com', N'2017-06-06', N'1998-08-05', N'Jr. Engineer', N'2017-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ravi Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Suresh Ray', [fatherName]),
        [mobile] = ISNULL(N'7056340234', [mobile]),
        [email] = ISNULL(N'mr.raviray420@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-06-06', [joiningDate]),
        [dob] = ISNULL(N'1998-08-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002171';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002172')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002172', N'Dipanjan Mondal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ranjan Kumar Mondal', N'9609460546', N'dm980436@gmail.com', N'2017-12-12', N'1996-02-29', N'Jr. Engineer', N'2017-12-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dipanjan Mondal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ranjan Kumar Mondal', [fatherName]),
        [mobile] = ISNULL(N'9609460546', [mobile]),
        [email] = ISNULL(N'dm980436@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-12-12', [joiningDate]),
        [dob] = ISNULL(N'1996-02-29', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-12-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002172';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002231')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002231', N'Saheb Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Madan Mahto', N'8340239708', N'sahebkr62047@gmail.com', N'2018-05-09', N'1997-12-28', N'Jr. Engineer', N'2018-05-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Saheb Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Madan Mahto', [fatherName]),
        [mobile] = ISNULL(N'8340239708', [mobile]),
        [email] = ISNULL(N'sahebkr62047@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-05-09', [joiningDate]),
        [dob] = ISNULL(N'1997-12-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-05-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002231';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002240')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002240', N'Nitesh Dhurve', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kishnu', N'8602880626', N'niteshd797@gmail.com', N'2018-07-09', N'1997-07-03', N'Jr. Engineer', N'2018-07-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitesh Dhurve', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kishnu', [fatherName]),
        [mobile] = ISNULL(N'8602880626', [mobile]),
        [email] = ISNULL(N'niteshd797@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2018-07-09', [joiningDate]),
        [dob] = ISNULL(N'1997-07-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2018-07-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002240';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002268')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002268', N'Priyanka sanjay Khabade', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sanjay Sakharam Khabade', N'7666435046', N'priyakhabde07@gmail.com', N'2020-02-13', N'1999-09-11', N'Jr. Engineer', N'2020-02-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priyanka sanjay Khabade', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sanjay Sakharam Khabade', [fatherName]),
        [mobile] = ISNULL(N'7666435046', [mobile]),
        [email] = ISNULL(N'priyakhabde07@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-02-13', [joiningDate]),
        [dob] = ISNULL(N'1999-09-11', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-02-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002268';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002281')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002281', N'Biplab Paul', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Shyama Pada Paul', N'9304019674', N'paulbiplab630@gmail.com', N'2020-10-01', N'2002-06-02', N'Jr. Engineer', N'2020-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Biplab Paul', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Shyama Pada Paul', [fatherName]),
        [mobile] = ISNULL(N'9304019674', [mobile]),
        [email] = ISNULL(N'paulbiplab630@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-10-01', [joiningDate]),
        [dob] = ISNULL(N'2002-06-02', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002281';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002284')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002284', N'Prabal Sohgaura', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dayashankar Tiwari', N'6265020239', N'prabaltiwari1432@gmail.com', N'2020-10-01', N'2000-03-04', N'Jr. Engineer', N'2020-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Prabal Sohgaura', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dayashankar Tiwari', [fatherName]),
        [mobile] = ISNULL(N'6265020239', [mobile]),
        [email] = ISNULL(N'prabaltiwari1432@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-10-01', [joiningDate]),
        [dob] = ISNULL(N'2000-03-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002284';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002287')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002287', N'Soumyaranjan Khamari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mrutyunjay Khamari', N'6370467678', N'soumyaranjankhamari1@gmail.com', N'2020-10-01', N'2000-04-26', N'Jr. Engineer', N'2020-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Soumyaranjan Khamari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mrutyunjay Khamari', [fatherName]),
        [mobile] = ISNULL(N'6370467678', [mobile]),
        [email] = ISNULL(N'soumyaranjankhamari1@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-10-01', [joiningDate]),
        [dob] = ISNULL(N'2000-04-26', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002287';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002298')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002298', N'Yogesh Kumar Dwivedi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Jivesh Dwivedi', N'7610186765', N'yogeshkumardwivedi779@gmail.com', N'2020-10-28', N'1998-12-30', N'Jr. Engineer', N'2020-10-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Yogesh Kumar Dwivedi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Jivesh Dwivedi', [fatherName]),
        [mobile] = ISNULL(N'7610186765', [mobile]),
        [email] = ISNULL(N'yogeshkumardwivedi779@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-10-28', [joiningDate]),
        [dob] = ISNULL(N'1998-12-30', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-10-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002298';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002309')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002309', N'Arati Nilesh Thorat', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Nilesh Raghunath Thorat', N'7756931335', N'aaratithorat31@gmail.com', N'2020-12-02', N'2001-01-23', N'Jr. Engineer', N'2020-12-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arati Nilesh Thorat', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Nilesh Raghunath Thorat', [fatherName]),
        [mobile] = ISNULL(N'7756931335', [mobile]),
        [email] = ISNULL(N'aaratithorat31@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-12-02', [joiningDate]),
        [dob] = ISNULL(N'2001-01-23', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-12-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002309';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002349')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002349', N'Arun Kumar Chaurasiya', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rishimuni Chaurasiya', N'9198484171', N'akumar62489@gmail.com', N'2022-04-15', N'2001-10-13', N'Jr. Engineer', N'2022-04-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arun Kumar Chaurasiya', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rishimuni Chaurasiya', [fatherName]),
        [mobile] = ISNULL(N'9198484171', [mobile]),
        [email] = ISNULL(N'akumar62489@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-04-15', [joiningDate]),
        [dob] = ISNULL(N'2001-10-13', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-04-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002349';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002344')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002344', N'Sukanta Sahoo', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Basanta Sahoo', N'9668495239', N'sukantasahoo9668@gmail.com', N'2022-03-28', N'2001-02-01', N'Jr. Engineer', N'2022-03-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sukanta Sahoo', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Basanta Sahoo', [fatherName]),
        [mobile] = ISNULL(N'9668495239', [mobile]),
        [email] = ISNULL(N'sukantasahoo9668@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-03-28', [joiningDate]),
        [dob] = ISNULL(N'2001-02-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002344';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002348')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002348', N'Riju Nandi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dibendu Nandi', N'8609385445', N'rijunandi9134@gmail.com', N'2022-03-28', N'2001-05-14', N'Jr. Engineer', N'2022-03-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Riju Nandi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dibendu Nandi', [fatherName]),
        [mobile] = ISNULL(N'8609385445', [mobile]),
        [email] = ISNULL(N'rijunandi9134@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-03-28', [joiningDate]),
        [dob] = ISNULL(N'2001-05-14', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-03-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002348';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002331')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002331', N'Biswajit Barik', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Amulya Kumar barik', N'8144959644', N'barik.biswajitrop2001@gmail.com', N'2021-11-30', N'2001-03-25', N'Jr. Engineer', N'2021-11-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Biswajit Barik', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Amulya Kumar barik', [fatherName]),
        [mobile] = ISNULL(N'8144959644', [mobile]),
        [email] = ISNULL(N'barik.biswajitrop2001@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-11-30', [joiningDate]),
        [dob] = ISNULL(N'2001-03-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-11-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002331';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002338')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002338', N'Satya Ranjan Pradhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Hrudananda pradhan', N'9337662812', N'satyaranjanpradhan321@gmail.com', N'2021-11-30', N'2000-06-23', N'Jr. Engineer', N'2021-11-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Satya Ranjan Pradhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Hrudananda pradhan', [fatherName]),
        [mobile] = ISNULL(N'9337662812', [mobile]),
        [email] = ISNULL(N'satyaranjanpradhan321@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-11-30', [joiningDate]),
        [dob] = ISNULL(N'2000-06-23', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-11-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002338';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002340')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002340', N'Rasmiranjan Das', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ajay kumar das', N'8763395323', N'rasmiranjandas7817@gmail.com', N'2021-11-30', N'2000-06-20', N'Jr. Engineer', N'2021-11-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rasmiranjan Das', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ajay kumar das', [fatherName]),
        [mobile] = ISNULL(N'8763395323', [mobile]),
        [email] = ISNULL(N'rasmiranjandas7817@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-11-30', [joiningDate]),
        [dob] = ISNULL(N'2000-06-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-11-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002340';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002342')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002342', N'Jitendra Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bipin bihari Behera', N'9078721757', N'jitendrabeheramantu@gmail.com', N'2021-11-30', N'2003-04-08', N'Jr. Engineer', N'2021-11-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jitendra Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bipin bihari Behera', [fatherName]),
        [mobile] = ISNULL(N'9078721757', [mobile]),
        [email] = ISNULL(N'jitendrabeheramantu@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-11-30', [joiningDate]),
        [dob] = ISNULL(N'2003-04-08', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-11-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002342';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002343')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002343', N'Sonu Vishwakarma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Satyanarayan Vishwakarma', N'9554720018', N'sonuvishwakarma961667@gmail.com', N'2021-11-30', N'2001-09-18', N'Jr. Engineer', N'2021-11-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sonu Vishwakarma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Satyanarayan Vishwakarma', [fatherName]),
        [mobile] = ISNULL(N'9554720018', [mobile]),
        [email] = ISNULL(N'sonuvishwakarma961667@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-11-30', [joiningDate]),
        [dob] = ISNULL(N'2001-09-18', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-11-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002343';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002323')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002323', N'Srushti Rajaram Bhosale', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rajaram Dhondiram Bhosale', N'9673346937', N'srushtibhosale69@gmail.com', N'2021-10-19', N'2001-11-09', N'Jr. Engineer', N'2021-10-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Srushti Rajaram Bhosale', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rajaram Dhondiram Bhosale', [fatherName]),
        [mobile] = ISNULL(N'9673346937', [mobile]),
        [email] = ISNULL(N'srushtibhosale69@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-19', [joiningDate]),
        [dob] = ISNULL(N'2001-11-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002323';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002329')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002329', N'Kiran Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bajarangi Jasiwara', N'6206071268', N'kirankumarijmd2003@gmail.com', N'2021-10-19', N'2003-02-04', N'Jr. Engineer', N'2021-10-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kiran Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bajarangi Jasiwara', [fatherName]),
        [mobile] = ISNULL(N'6206071268', [mobile]),
        [email] = ISNULL(N'kirankumarijmd2003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-19', [joiningDate]),
        [dob] = ISNULL(N'2003-02-04', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002329';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002314')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002314', N'Durga Hanumant Vasav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Hanumant Vasav', N'9146379195', N'durgavasav2001@gmail.com', N'2021-10-08', N'2001-12-19', N'Jr. Engineer', N'2021-10-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Durga Hanumant Vasav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Hanumant Vasav', [fatherName]),
        [mobile] = ISNULL(N'9146379195', [mobile]),
        [email] = ISNULL(N'durgavasav2001@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-08', [joiningDate]),
        [dob] = ISNULL(N'2001-12-19', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002314';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002317')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002317', N'Chandana Chandravanshi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rajkumar Chandravanshi', N'8462893564', N'thakurmuskan531@gmail.com', N'2021-10-08', N'2000-05-20', N'Jr. Engineer', N'2021-10-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandana Chandravanshi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rajkumar Chandravanshi', [fatherName]),
        [mobile] = ISNULL(N'8462893564', [mobile]),
        [email] = ISNULL(N'thakurmuskan531@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-08', [joiningDate]),
        [dob] = ISNULL(N'2000-05-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002317';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002319')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002319', N'Km  Prity', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ramdin Rao', N'8273989685', N'pritykm44@gmail.com', N'2021-10-08', N'2002-08-07', N'Jr. Engineer', N'2021-10-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Km  Prity', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ramdin Rao', [fatherName]),
        [mobile] = ISNULL(N'8273989685', [mobile]),
        [email] = ISNULL(N'pritykm44@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-08', [joiningDate]),
        [dob] = ISNULL(N'2002-08-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002319';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002320')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002320', N'Neha Vishwanath more', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bishawanath More', N'8149235771', N'moreneha0932@gmail.com', N'2021-10-08', N'2002-06-09', N'Jr. Engineer', N'2021-10-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Neha Vishwanath more', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bishawanath More', [fatherName]),
        [mobile] = ISNULL(N'8149235771', [mobile]),
        [email] = ISNULL(N'moreneha0932@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-08', [joiningDate]),
        [dob] = ISNULL(N'2002-06-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002320';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002362')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002362', N'Varsha Tirkey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Chhunu', N'8102138929', N'tirkeyworld2019@gmail.com', N'2022-06-06', N'2004-02-06', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Varsha Tirkey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Chhunu', [fatherName]),
        [mobile] = ISNULL(N'8102138929', [mobile]),
        [email] = ISNULL(N'tirkeyworld2019@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2004-02-06', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002362';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002364')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002364', N'Jhantu Rajwar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Jagan', N'9546724870', N'jhanturajwar9546@gmail.com', N'2022-06-06', N'2002-01-15', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jhantu Rajwar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Jagan', [fatherName]),
        [mobile] = ISNULL(N'9546724870', [mobile]),
        [email] = ISNULL(N'jhanturajwar9546@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2002-01-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002364';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002368')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002368', N'Anju Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Jai Nath Mahto', N'8292434429', N'anjuk4976@gmail.com', N'2022-06-06', N'2003-04-17', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anju Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Jai Nath Mahto', [fatherName]),
        [mobile] = ISNULL(N'8292434429', [mobile]),
        [email] = ISNULL(N'anjuk4976@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2003-04-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002368';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002371')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002371', N'Juli Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Raman Mahto', N'6299226122', N'julimahto02@gmail.com', N'2022-06-06', N'2003-01-01', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Juli Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Raman Mahto', [fatherName]),
        [mobile] = ISNULL(N'6299226122', [mobile]),
        [email] = ISNULL(N'julimahto02@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2003-01-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002371';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002372')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002372', N'Kalpana Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Karmchand', N'8709136033', N'kalpukumari870.pro@gmail.com', N'2022-06-06', N'2003-10-28', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kalpana Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Karmchand', [fatherName]),
        [mobile] = ISNULL(N'8709136033', [mobile]),
        [email] = ISNULL(N'kalpukumari870.pro@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2003-10-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002372';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002373')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002373', N'Manisha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ramdev Ram', N'8102337134', N'manisharam442@gmail.com', N'2022-06-06', N'2003-07-31', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manisha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ramdev Ram', [fatherName]),
        [mobile] = ISNULL(N'8102337134', [mobile]),
        [email] = ISNULL(N'manisharam442@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2003-07-31', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002373';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002377')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002377', N'Bharti Deogam', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Arjun', N'8102126177', N'bhartideogam03@gmail.com', N'2022-06-06', N'2003-01-03', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bharti Deogam', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Arjun', [fatherName]),
        [mobile] = ISNULL(N'8102126177', [mobile]),
        [email] = ISNULL(N'bhartideogam03@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2003-01-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002377';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002380')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002380', N'Sabita Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Meghnath Mahto', N'9709269459', N'sabitakumari1542004@gmail.com', N'2022-06-06', N'2004-04-15', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sabita Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Meghnath Mahto', [fatherName]),
        [mobile] = ISNULL(N'9709269459', [mobile]),
        [email] = ISNULL(N'sabitakumari1542004@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2004-04-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002380';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002381')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002381', N'Usha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rajendra Mahto', N'6203323807', N'usha123kri890@gmail.com', N'2022-06-06', N'2002-01-15', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Usha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rajendra Mahto', [fatherName]),
        [mobile] = ISNULL(N'6203323807', [mobile]),
        [email] = ISNULL(N'usha123kri890@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2002-01-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002381';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002382')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002382', N'Govind Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Lallan Yadav', N'9565347846', N'ggovindyadav479@gmail.com', N'2022-06-06', N'2003-02-15', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Govind Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Lallan Yadav', [fatherName]),
        [mobile] = ISNULL(N'9565347846', [mobile]),
        [email] = ISNULL(N'ggovindyadav479@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2003-02-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002382';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002383')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002383', N'Anil Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Amarjeet', N'7267043832', N'aky273301@gmail.com', N'2022-06-06', N'2002-07-05', N'Jr. Engineer', N'2022-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anil Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Amarjeet', [fatherName]),
        [mobile] = ISNULL(N'7267043832', [mobile]),
        [email] = ISNULL(N'aky273301@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-06', [joiningDate]),
        [dob] = ISNULL(N'2002-07-05', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002383';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002394')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002394', N'Sandeep Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dillip Behera', N'7606954022', N'beherasandeep257@gmail.com', N'2022-10-11', N'2003-07-07', N'Jr. Engineer', N'2022-10-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sandeep Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dillip Behera', [fatherName]),
        [mobile] = ISNULL(N'7606954022', [mobile]),
        [email] = ISNULL(N'beherasandeep257@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-10-11', [joiningDate]),
        [dob] = ISNULL(N'2003-07-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-10-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002394';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002399')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002399', N'Pintu Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ramji Yadav', N'7281951258', N'pintooydv96@gmail.com', N'2022-11-21', N'2002-07-19', N'Jr. Engineer', N'2022-11-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pintu Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ramji Yadav', [fatherName]),
        [mobile] = ISNULL(N'7281951258', [mobile]),
        [email] = ISNULL(N'pintooydv96@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-21', [joiningDate]),
        [dob] = ISNULL(N'2002-07-19', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002399';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002401')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002401', N'Mohammad Amaan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mohammad Manowar Alam', N'6209624389', N'mdamaanraza786@gmail.com', N'2023-04-27', N'2002-12-28', N'Jr. Engineer', N'2023-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohammad Amaan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mohammad Manowar Alam', [fatherName]),
        [mobile] = ISNULL(N'6209624389', [mobile]),
        [email] = ISNULL(N'mdamaanraza786@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-04-27', [joiningDate]),
        [dob] = ISNULL(N'2002-12-28', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002401';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002402')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002402', N'Kisun Tudu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Masang Tudu', N'9937914631', N'tudukisan736@gmail.com', N'2023-04-27', N'2003-02-08', N'Jr. Engineer', N'2023-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kisun Tudu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Masang Tudu', [fatherName]),
        [mobile] = ISNULL(N'9937914631', [mobile]),
        [email] = ISNULL(N'tudukisan736@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-04-27', [joiningDate]),
        [dob] = ISNULL(N'2003-02-08', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002402';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002403')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002403', N'Ankit Kumar Mishra', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dilip Mishra', N'9006158423', N'ankitmishra69291@gmail.com', N'2023-04-27', N'2005-01-21', N'Jr. Engineer', N'2023-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankit Kumar Mishra', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dilip Mishra', [fatherName]),
        [mobile] = ISNULL(N'9006158423', [mobile]),
        [email] = ISNULL(N'ankitmishra69291@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-04-27', [joiningDate]),
        [dob] = ISNULL(N'2005-01-21', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002403';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002405')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002405', N'Mahfuz Ansari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Salim Ansari', N'6351510041', N'mahfuzansari1424@gmail.com', N'2023-04-27', N'2002-05-15', N'Jr. Engineer', N'2023-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mahfuz Ansari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Salim Ansari', [fatherName]),
        [mobile] = ISNULL(N'6351510041', [mobile]),
        [email] = ISNULL(N'mahfuzansari1424@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-04-27', [joiningDate]),
        [dob] = ISNULL(N'2002-05-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002405';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002407')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002407', N'Santosh Kumar Verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Nirmal Prasad Verma', N'7643861396', N'santosh76438@gmail.com', N'2023-05-06', N'2002-12-09', N'Jr. Engineer', N'2023-05-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Santosh Kumar Verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Nirmal Prasad Verma', [fatherName]),
        [mobile] = ISNULL(N'7643861396', [mobile]),
        [email] = ISNULL(N'santosh76438@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-06', [joiningDate]),
        [dob] = ISNULL(N'2002-12-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002407';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002408')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002408', N'Sanjeev kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dharmendra paswan', N'7050620445', N'sanjeevkumar851128@gmail.com', N'2023-05-23', N'2001-08-17', N'Jr. Engineer', N'2023-05-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sanjeev kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dharmendra paswan', [fatherName]),
        [mobile] = ISNULL(N'7050620445', [mobile]),
        [email] = ISNULL(N'sanjeevkumar851128@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-23', [joiningDate]),
        [dob] = ISNULL(N'2001-08-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002408';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002412')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002412', N'Barun Kumar Mandal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ram Swarup Mandal', N'6200387101', N'barunmandal1106@gmail.com', N'2023-06-01', N'2003-01-25', N'Jr. Engineer', N'2023-06-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Barun Kumar Mandal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ram Swarup Mandal', [fatherName]),
        [mobile] = ISNULL(N'6200387101', [mobile]),
        [email] = ISNULL(N'barunmandal1106@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-01', [joiningDate]),
        [dob] = ISNULL(N'2003-01-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002412';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002413')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002413', N'Amit Kumar Mahto', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Thakurdas Mahto', N'6200132583', N'mahtoamitkumar86@gmail.com', N'2023-06-01', N'2003-09-11', N'Jr. Engineer', N'2023-06-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Amit Kumar Mahto', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Thakurdas Mahto', [fatherName]),
        [mobile] = ISNULL(N'6200132583', [mobile]),
        [email] = ISNULL(N'mahtoamitkumar86@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-01', [joiningDate]),
        [dob] = ISNULL(N'2003-09-11', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002413';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002416')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002416', N'Manish Kumar Mahto', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Laloo Kumar Mahto', N'9142017959', N'manishkumarmahto5454@gmail.com', N'2023-06-03', N'2005-01-02', N'Jr. Engineer', N'2023-06-03', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manish Kumar Mahto', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Laloo Kumar Mahto', [fatherName]),
        [mobile] = ISNULL(N'9142017959', [mobile]),
        [email] = ISNULL(N'manishkumarmahto5454@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-03', [joiningDate]),
        [dob] = ISNULL(N'2005-01-02', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002416';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002421')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002421', N'Ishu bala', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Shivchand Mahto', N'7858932276', N'balaishu040@gmail.com', N'2023-06-05', N'2003-12-07', N'Jr. Engineer', N'2023-06-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ishu bala', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Shivchand Mahto', [fatherName]),
        [mobile] = ISNULL(N'7858932276', [mobile]),
        [email] = ISNULL(N'balaishu040@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-05', [joiningDate]),
        [dob] = ISNULL(N'2003-12-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002421';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002422')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002422', N'Gaurav kumar singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Vinod kumar singh', N'7061016670', N'singhgauravkumar762@gmail.com', N'2023-06-07', N'2004-05-25', N'Jr. Engineer', N'2023-06-07', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gaurav kumar singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Vinod kumar singh', [fatherName]),
        [mobile] = ISNULL(N'7061016670', [mobile]),
        [email] = ISNULL(N'singhgauravkumar762@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-07', [joiningDate]),
        [dob] = ISNULL(N'2004-05-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002422';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002423')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002423', N'Rimpu kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Samod prajapati', N'9835262328', N'rimpukumari007@gmail.com', N'2023-06-19', N'2003-09-15', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rimpu kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Samod prajapati', [fatherName]),
        [mobile] = ISNULL(N'9835262328', [mobile]),
        [email] = ISNULL(N'rimpukumari007@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-09-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002423';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002425')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002425', N'Tripti kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Nandan Mishra', N'9142966826', N'triptim367@gmail.com', N'2023-06-19', N'2002-03-17', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tripti kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Nandan Mishra', [fatherName]),
        [mobile] = ISNULL(N'9142966826', [mobile]),
        [email] = ISNULL(N'triptim367@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2002-03-17', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002425';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002430')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002430', N'Juli Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Devendra kumar mandal', N'6202865060', N'juli424146@gmail.com', N'2023-06-19', N'2002-03-15', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Juli Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Devendra kumar mandal', [fatherName]),
        [mobile] = ISNULL(N'6202865060', [mobile]),
        [email] = ISNULL(N'juli424146@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2002-03-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002430';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002433')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002433', N'Sudhanshu  Gautam', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sunil ram', N'7859097724', N'sudhanshubabu7859097724@gmail.com', N'2023-06-19', N'2003-05-03', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sudhanshu  Gautam', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sunil ram', [fatherName]),
        [mobile] = ISNULL(N'7859097724', [mobile]),
        [email] = ISNULL(N'sudhanshubabu7859097724@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-05-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002433';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002435')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002435', N'Rakesh kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Awadhesh rajak', N'6205376949', N'rani6205376949@gmail.com', N'2023-06-19', N'2004-04-20', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rakesh kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Awadhesh rajak', [fatherName]),
        [mobile] = ISNULL(N'6205376949', [mobile]),
        [email] = ISNULL(N'rani6205376949@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-04-20', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002435';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002436')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002436', N'Pappu paswan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'lalan paswan', N'9523527608', N'pk5909105@gmail.com', N'2023-06-19', N'2003-04-08', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pappu paswan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'lalan paswan', [fatherName]),
        [mobile] = ISNULL(N'9523527608', [mobile]),
        [email] = ISNULL(N'pk5909105@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-04-08', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002436';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002437')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002437', N'ravikant prajapati', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'sunil prajapati', N'7992306628', N'satish12rk@gmail.com', N'2023-06-19', N'2004-04-13', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'ravikant prajapati', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'sunil prajapati', [fatherName]),
        [mobile] = ISNULL(N'7992306628', [mobile]),
        [email] = ISNULL(N'satish12rk@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-04-13', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002437';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002438')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002438', N'Prince kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mahesh choudhary', N'7481814666', N'rdxprince8181@gmail.com', N'2023-06-19', N'2003-01-07', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Prince kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mahesh choudhary', [fatherName]),
        [mobile] = ISNULL(N'7481814666', [mobile]),
        [email] = ISNULL(N'rdxprince8181@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-01-07', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002438';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002439')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002439', N'Sunil Chaudhary', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ankul Chaudhary', N'8355834463', N'chaudharysunilkumar732@gmail.com', N'2023-06-19', N'2003-04-03', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sunil Chaudhary', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ankul Chaudhary', [fatherName]),
        [mobile] = ISNULL(N'8355834463', [mobile]),
        [email] = ISNULL(N'chaudharysunilkumar732@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-04-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002439';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002442')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002442', N'Manish kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Devraj mehta', N'8252921539', N'mkmanish030305@gmail.com', N'2023-06-19', N'2005-03-03', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manish kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Devraj mehta', [fatherName]),
        [mobile] = ISNULL(N'8252921539', [mobile]),
        [email] = ISNULL(N'mkmanish030305@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2005-03-03', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002442';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002443')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002443', N'Anuj kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ajay rajak', N'9835174080', N'ak6991285@gmail.com', N'2023-06-19', N'2003-09-13', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anuj kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ajay rajak', [fatherName]),
        [mobile] = ISNULL(N'9835174080', [mobile]),
        [email] = ISNULL(N'ak6991285@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-09-13', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002443';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002444')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002444', N'Kartik kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Prayag mahto', N'6200692426', N'kartikkumarmahto02@gmail.com', N'2023-06-19', N'2004-12-11', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kartik kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Prayag mahto', [fatherName]),
        [mobile] = ISNULL(N'6200692426', [mobile]),
        [email] = ISNULL(N'kartikkumarmahto02@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-12-11', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002444';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002445')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002445', N'Rahul mahto', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Narayan mahto', N'6299484512', N'rahulmahto12344sagar@gmail.com', N'2023-06-19', N'2005-01-01', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul mahto', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Narayan mahto', [fatherName]),
        [mobile] = ISNULL(N'6299484512', [mobile]),
        [email] = ISNULL(N'rahulmahto12344sagar@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2005-01-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002445';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002446')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002446', N'Md Zeya ahmad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Md irshad ansari', N'9939245604', N'mdzeyaahmad41@gmail.com', N'2023-06-19', N'2003-04-01', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Md Zeya ahmad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Md irshad ansari', [fatherName]),
        [mobile] = ISNULL(N'9939245604', [mobile]),
        [email] = ISNULL(N'mdzeyaahmad41@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-04-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002446';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002447')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002447', N'Md ali raza', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Md mahmood alam', N'9771264940', N'razaali2308@gmail.com', N'2023-06-19', N'2005-04-21', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Md ali raza', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Md mahmood alam', [fatherName]),
        [mobile] = ISNULL(N'9771264940', [mobile]),
        [email] = ISNULL(N'razaali2308@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2005-04-21', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002447';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002448')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002448', N'Gaurav kumar nishad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kalicharan nishad', N'7004403813', N'gk016836@gmail.com', N'2023-06-19', N'2002-03-02', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gaurav kumar nishad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kalicharan nishad', [fatherName]),
        [mobile] = ISNULL(N'7004403813', [mobile]),
        [email] = ISNULL(N'gk016836@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2002-03-02', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002448';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002449')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002449', N'Abhinav kumar roy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mantu kumar roy', N'9334562879', N'akraj961065@gmail.com', N'2023-06-19', N'2003-11-09', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhinav kumar roy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mantu kumar roy', [fatherName]),
        [mobile] = ISNULL(N'9334562879', [mobile]),
        [email] = ISNULL(N'akraj961065@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-11-09', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002449';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002450')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002450', N'Anand kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mithlesh prasad', N'9835594008', N'anandkumarguptamk@gmail.com', N'2023-06-19', N'2003-05-18', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anand kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mithlesh prasad', [fatherName]),
        [mobile] = ISNULL(N'9835594008', [mobile]),
        [email] = ISNULL(N'anandkumarguptamk@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2003-05-18', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002450';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002451')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002451', N'Prithvi raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ravindra kumar mehta', N'7061250254', N'prithviraz9835@gmail.com', N'2023-06-19', N'2004-05-15', N'Jr. Engineer', N'2023-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Prithvi raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ravindra kumar mehta', [fatherName]),
        [mobile] = ISNULL(N'7061250254', [mobile]),
        [email] = ISNULL(N'prithviraz9835@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-05-15', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002451';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002454')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002454', N'Anjika Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Jitendra kumar', N'9507967490', N'anjikasharma3@gmail.com', N'2023-06-27', N'2004-11-25', N'Jr. Engineer', N'2023-06-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anjika Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Jitendra kumar', [fatherName]),
        [mobile] = ISNULL(N'9507967490', [mobile]),
        [email] = ISNULL(N'anjikasharma3@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-27', [joiningDate]),
        [dob] = ISNULL(N'2004-11-25', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002454';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002456')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002456', N'Chandan Kumar Giri', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kalipada Giri', N'8144483704', N'girivicky30@gmail.com', N'2024-06-04', N'2005-05-26', N'OE', N'2024-06-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandan Kumar Giri', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kalipada Giri', [fatherName]),
        [mobile] = ISNULL(N'8144483704', [mobile]),
        [email] = ISNULL(N'girivicky30@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-04', [joiningDate]),
        [dob] = ISNULL(N'2005-05-26', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002456';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002457')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002457', N'Sachin Rout', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Subas Rout', N'7477745236', N'sachinrout699@gmail.com', N'2024-06-04', N'2005-11-20', N'OE', N'2024-06-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sachin Rout', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Subas Rout', [fatherName]),
        [mobile] = ISNULL(N'7477745236', [mobile]),
        [email] = ISNULL(N'sachinrout699@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-04', [joiningDate]),
        [dob] = ISNULL(N'2005-11-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002457';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002458')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002458', N'Chandan Paul', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Shyamapada Paul', N'9334098654', N'paulchandan020@gmail.com', N'2024-06-04', N'2004-05-19', N'OE', N'2024-06-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandan Paul', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Shyamapada Paul', [fatherName]),
        [mobile] = ISNULL(N'9334098654', [mobile]),
        [email] = ISNULL(N'paulchandan020@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-04', [joiningDate]),
        [dob] = ISNULL(N'2004-05-19', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002458';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002464')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002464', N'Tejal Tanaji Pisal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Tanaji Pisal', N'9699563537', N'tejalpisal6@gmail.com', N'2024-06-10', N'2005-08-24', N'OE', N'2024-06-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tejal Tanaji Pisal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Tanaji Pisal', [fatherName]),
        [mobile] = ISNULL(N'9699563537', [mobile]),
        [email] = ISNULL(N'tejalpisal6@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-10', [joiningDate]),
        [dob] = ISNULL(N'2005-08-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002464';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002466')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002466', N'Vaishnavi Sambhaji Anekar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sambhaji', N'7304837416', N'vaishuanekar2712@gmail.com', N'2024-06-24', N'2003-12-27', N'OE', N'2024-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vaishnavi Sambhaji Anekar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sambhaji', [fatherName]),
        [mobile] = ISNULL(N'7304837416', [mobile]),
        [email] = ISNULL(N'vaishuanekar2712@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-24', [joiningDate]),
        [dob] = ISNULL(N'2003-12-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002466';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002471')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002471', N'MD Sarfaraj Akhtar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Md Said', N'8541055106', N'mdsarfarajakhtar1532002@gmail.com', N'2024-06-24', N'2004-03-15', N'OE', N'2024-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MD Sarfaraj Akhtar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Md Said', [fatherName]),
        [mobile] = ISNULL(N'8541055106', [mobile]),
        [email] = ISNULL(N'mdsarfarajakhtar1532002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-03-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002471';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002472')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002472', N'Ranjit Prasad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Yogendra Prasad', N'8651786317', N'ranjitkumarr566@gmail.com', N'2024-06-24', N'2004-05-21', N'OE', N'2024-06-24', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ranjit Prasad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Yogendra Prasad', [fatherName]),
        [mobile] = ISNULL(N'8651786317', [mobile]),
        [email] = ISNULL(N'ranjitkumarr566@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-24', [joiningDate]),
        [dob] = ISNULL(N'2004-05-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002472';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002485')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002485', N'Aditya Biswas', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ananda Biswas', N'6001696647', N'ab4938758@gmail.com', N'2024-07-11', N'2003-01-01', N'OE', N'2024-07-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aditya Biswas', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ananda Biswas', [fatherName]),
        [mobile] = ISNULL(N'6001696647', [mobile]),
        [email] = ISNULL(N'ab4938758@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-11', [joiningDate]),
        [dob] = ISNULL(N'2003-01-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002485';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002492')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002492', N'Kajal Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Karu Yadav', N'6206400029', N'kajalkumariyadavk592@gmail.com', N'2024-07-16', N'2005-03-10', N'OE', N'2024-07-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kajal Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Karu Yadav', [fatherName]),
        [mobile] = ISNULL(N'6206400029', [mobile]),
        [email] = ISNULL(N'kajalkumariyadavk592@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-16', [joiningDate]),
        [dob] = ISNULL(N'2005-03-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002492';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002493')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002493', N'Prity Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ashok Ravidas', N'9693996703', N'pritykumaridas2003@gmail.com', N'2024-07-16', N'2003-06-02', N'OE', N'2024-07-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Prity Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ashok Ravidas', [fatherName]),
        [mobile] = ISNULL(N'9693996703', [mobile]),
        [email] = ISNULL(N'pritykumaridas2003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-16', [joiningDate]),
        [dob] = ISNULL(N'2003-06-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002493';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002495')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002495', N'Arti Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Yamuna Sagar sahu', N'9142615986', N'karti3126@gmail.com', N'2024-07-16', N'2004-04-23', N'OE', N'2024-07-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arti Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Yamuna Sagar sahu', [fatherName]),
        [mobile] = ISNULL(N'9142615986', [mobile]),
        [email] = ISNULL(N'karti3126@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-16', [joiningDate]),
        [dob] = ISNULL(N'2004-04-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002495';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002508')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002508', N'Nitish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Satish Singh', N'6290852982', N'nitishk90335@gmail.com', N'2024-07-23', N'2004-11-21', N'OE', N'2024-07-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Satish Singh', [fatherName]),
        [mobile] = ISNULL(N'6290852982', [mobile]),
        [email] = ISNULL(N'nitishk90335@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-23', [joiningDate]),
        [dob] = ISNULL(N'2004-11-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002508';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002509')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002509', N'Rahul Negi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Budhi Singh', N'7668082404', N'rahulnegi36931@gmail.com', N'2024-07-23', N'2005-03-17', N'OE', N'2024-07-23', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul Negi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Budhi Singh', [fatherName]),
        [mobile] = ISNULL(N'7668082404', [mobile]),
        [email] = ISNULL(N'rahulnegi36931@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-23', [joiningDate]),
        [dob] = ISNULL(N'2005-03-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-23', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002509';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002510')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002510', N'Shyama Rani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Naresh Kumar Sharma', N'9693899077', N'shyamarani96938990@gmail.com', N'2024-07-29', N'2004-08-12', N'OE', N'2024-07-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shyama Rani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Naresh Kumar Sharma', [fatherName]),
        [mobile] = ISNULL(N'9693899077', [mobile]),
        [email] = ISNULL(N'shyamarani96938990@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-29', [joiningDate]),
        [dob] = ISNULL(N'2004-08-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002510';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002520')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002520', N'Bhuvaneshwari Bhimagoud Patil', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bhimagouda Patil', N'8660308447', N'bhuvaneshwaripatil15@gmail.com', N'2025-05-19', N'2006-06-20', N'OE', N'2025-05-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhuvaneshwari Bhimagoud Patil', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bhimagouda Patil', [fatherName]),
        [mobile] = ISNULL(N'8660308447', [mobile]),
        [email] = ISNULL(N'bhuvaneshwaripatil15@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-19', [joiningDate]),
        [dob] = ISNULL(N'2006-06-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002520';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002522')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002522', N'Kunal Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sanjay Kumar', N'8851583547', N'kunalraj85400@gmail.com', N'2025-06-06', N'2006-09-23', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kunal Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sanjay Kumar', [fatherName]),
        [mobile] = ISNULL(N'8851583547', [mobile]),
        [email] = ISNULL(N'kunalraj85400@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-09-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002522';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002523')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002523', N'Aditya Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Than Singh', N'7428680218', N'adityasinghnjaps@gmail.com', N'2025-06-06', N'2006-12-19', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aditya Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Than Singh', [fatherName]),
        [mobile] = ISNULL(N'7428680218', [mobile]),
        [email] = ISNULL(N'adityasinghnjaps@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-12-19', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002523';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002528')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002528', N'Ritesh Bashveshwar Lagdive', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bashveshwar Lagdive', N'9356086544', N'riteshlagdive@gmail.com', N'2025-06-06', N'2006-05-25', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ritesh Bashveshwar Lagdive', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bashveshwar Lagdive', [fatherName]),
        [mobile] = ISNULL(N'9356086544', [mobile]),
        [email] = ISNULL(N'riteshlagdive@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-05-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002528';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002529')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002529', N'Pranav Vijaykumar Shelke', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Vijaykumar Shelke', N'9325530833', N'pranavshelke0543@gmail.com', N'2025-06-06', N'2005-04-05', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pranav Vijaykumar Shelke', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Vijaykumar Shelke', [fatherName]),
        [mobile] = ISNULL(N'9325530833', [mobile]),
        [email] = ISNULL(N'pranavshelke0543@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2005-04-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002529';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002530')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002530', N'Omkar Ganesh Dhagare', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ganesh Dhagare', N'9021518828', N'omkardhagare2@gmail.com', N'2025-06-06', N'2006-06-21', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Omkar Ganesh Dhagare', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ganesh Dhagare', [fatherName]),
        [mobile] = ISNULL(N'9021518828', [mobile]),
        [email] = ISNULL(N'omkardhagare2@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-06-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002530';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002531')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002531', N'Pratibha Mahadev Sura', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mahadev Sura', N'9370981537', N'surapratibha@gmail.com', N'2025-06-06', N'2007-08-01', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pratibha Mahadev Sura', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mahadev Sura', [fatherName]),
        [mobile] = ISNULL(N'9370981537', [mobile]),
        [email] = ISNULL(N'surapratibha@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2007-08-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002531';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002533')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002533', N'Dropadi Devidas Gaikwad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Devidas Gaikwad', N'8767700862', N'dropadigaikwad830@gmail.com', N'2025-06-06', N'2006-06-03', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dropadi Devidas Gaikwad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Devidas Gaikwad', [fatherName]),
        [mobile] = ISNULL(N'8767700862', [mobile]),
        [email] = ISNULL(N'dropadigaikwad830@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-06-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002533';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002534')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002534', N'Harshada Dhanaji Tandale', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dhanaji Tandale', N'8329941474', N'harshadatandle66@gmail.com', N'2025-06-06', N'2005-09-13', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Harshada Dhanaji Tandale', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dhanaji Tandale', [fatherName]),
        [mobile] = ISNULL(N'8329941474', [mobile]),
        [email] = ISNULL(N'harshadatandle66@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2005-09-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002534';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002535')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002535', N'Namrata Umesh Wadekar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Umesh Wadekar', N'7745842877', N'wadekarnamrata694@gmail.com', N'2025-06-06', N'2005-12-15', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Namrata Umesh Wadekar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Umesh Wadekar', [fatherName]),
        [mobile] = ISNULL(N'7745842877', [mobile]),
        [email] = ISNULL(N'wadekarnamrata694@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2005-12-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002535';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002536')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002536', N'Vaishnavi Krushanat Jadhav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Krushnath Jadhav', N'7517241150', N'vaishnavikjadhav142@gmail.com', N'2025-06-06', N'2004-09-14', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vaishnavi Krushanat Jadhav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Krushnath Jadhav', [fatherName]),
        [mobile] = ISNULL(N'7517241150', [mobile]),
        [email] = ISNULL(N'vaishnavikjadhav142@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2004-09-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002536';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002538')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002538', N'Kalpana Dyanand Telang', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dyanand Telang', N'9699978356', N'kalpanatelang14@gmail.com', N'2025-06-06', N'2006-04-17', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kalpana Dyanand Telang', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dyanand Telang', [fatherName]),
        [mobile] = ISNULL(N'9699978356', [mobile]),
        [email] = ISNULL(N'kalpanatelang14@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-04-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002538';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002540')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002540', N'Shweta Ganesh Tekale', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ganesh Takale', N'7020545171', N'shwetatekale633@gmail.com', N'2025-06-06', N'2007-02-27', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shweta Ganesh Tekale', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ganesh Takale', [fatherName]),
        [mobile] = ISNULL(N'7020545171', [mobile]),
        [email] = ISNULL(N'shwetatekale633@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2007-02-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002540';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002541')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002541', N'Pragati Balasaheb Talekar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Balasaheb Talekar', N'8468967473', N'pragatitalekar440@gmail.com', N'2025-06-06', N'2006-02-11', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pragati Balasaheb Talekar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Balasaheb Talekar', [fatherName]),
        [mobile] = ISNULL(N'8468967473', [mobile]),
        [email] = ISNULL(N'pragatitalekar440@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-02-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002541';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002543')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002543', N'Anuradha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sharanabasappa', N'8431061414', N'anuradhahadapad657@gmail.com', N'2025-06-06', N'2006-02-15', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anuradha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sharanabasappa', [fatherName]),
        [mobile] = ISNULL(N'8431061414', [mobile]),
        [email] = ISNULL(N'anuradhahadapad657@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-02-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002543';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002544')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002544', N'Rohini', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sunil', N'7899602495', N'sunilkkamble7@gmail.com', N'2025-06-06', N'2006-08-14', N'OE', N'2025-06-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rohini', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sunil', [fatherName]),
        [mobile] = ISNULL(N'7899602495', [mobile]),
        [email] = ISNULL(N'sunilkkamble7@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-06', [joiningDate]),
        [dob] = ISNULL(N'2006-08-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002544';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002545')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002545', N'Ankita Kumar Laitbar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kumar', N'9356401383', N'laitbarankita@gmail.com', N'2025-06-19', N'2006-04-29', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ankita Kumar Laitbar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kumar', [fatherName]),
        [mobile] = ISNULL(N'9356401383', [mobile]),
        [email] = ISNULL(N'laitbarankita@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2006-04-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002545';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002546')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002546', N'Sourav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ghana Ram', N'7703893606', N'souravbakna5@gmail.com', N'2025-06-19', N'2004-11-17', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sourav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ghana Ram', [fatherName]),
        [mobile] = ISNULL(N'7703893606', [mobile]),
        [email] = ISNULL(N'souravbakna5@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-11-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002546';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002547')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002547', N'Kundan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ramnath Bhagat', N'7079490435', N'kundan26350@gmail.com', N'2025-06-19', N'2004-01-16', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kundan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ramnath Bhagat', [fatherName]),
        [mobile] = ISNULL(N'7079490435', [mobile]),
        [email] = ISNULL(N'kundan26350@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-01-16', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002547';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002548')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002548', N'Suman Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mangal Ram', N'7061332411', N'sumankumar706132411@gmail.com', N'2025-06-19', N'2006-02-24', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suman Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mangal Ram', [fatherName]),
        [mobile] = ISNULL(N'7061332411', [mobile]),
        [email] = ISNULL(N'sumankumar706132411@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2006-02-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002548';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002549')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002549', N'Vijay Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Anil Mahto', N'9142930237', N'vijaykrinfo646@gmail.com', N'2025-06-19', N'2005-01-01', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vijay Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Anil Mahto', [fatherName]),
        [mobile] = ISNULL(N'9142930237', [mobile]),
        [email] = ISNULL(N'vijaykrinfo646@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2005-01-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002549';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002550')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002550', N'Shubham Kumar Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Lal Babu Yadav', N'8595125570', N'shubhamkumaryadav699@gmail.com', N'2025-06-19', N'2004-07-05', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubham Kumar Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Lal Babu Yadav', [fatherName]),
        [mobile] = ISNULL(N'8595125570', [mobile]),
        [email] = ISNULL(N'shubhamkumaryadav699@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2004-07-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002550';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002551')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002551', N'Sahil Singh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sandeep Singh', N'8630865557', N'slt5112006@gmail.com', N'2025-06-19', N'2006-11-05', N'OE', N'2025-06-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sahil Singh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sandeep Singh', [fatherName]),
        [mobile] = ISNULL(N'8630865557', [mobile]),
        [email] = ISNULL(N'slt5112006@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-19', [joiningDate]),
        [dob] = ISNULL(N'2006-11-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002551';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002554')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002554', N'Sampada Bera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Jawaharlal Behra', N'9508033343', N'sampadabera06@gmail.com', N'2025-06-21', N'2005-07-20', N'OE', N'2025-06-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sampada Bera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Jawaharlal Behra', [fatherName]),
        [mobile] = ISNULL(N'9508033343', [mobile]),
        [email] = ISNULL(N'sampadabera06@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-21', [joiningDate]),
        [dob] = ISNULL(N'2005-07-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002554';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002555')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002555', N'Sneha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Tarkeshwar Sharma', N'9334191576', N'snehasharma45772@gmail.com', N'2025-06-21', N'2006-08-21', N'OE', N'2025-06-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sneha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Tarkeshwar Sharma', [fatherName]),
        [mobile] = ISNULL(N'9334191576', [mobile]),
        [email] = ISNULL(N'snehasharma45772@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-21', [joiningDate]),
        [dob] = ISNULL(N'2006-08-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002555';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002563')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002563', N'Jay Krishna Pandey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Marut Nandan Pandey', N'7985438333', N'ijaypandit651@gmail.com', N'2025-07-29', N'2004-09-29', N'OE', N'2025-07-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jay Krishna Pandey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Marut Nandan Pandey', [fatherName]),
        [mobile] = ISNULL(N'7985438333', [mobile]),
        [email] = ISNULL(N'ijaypandit651@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-29', [joiningDate]),
        [dob] = ISNULL(N'2004-09-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002563';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002565')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002565', N'Ashish Dwivedi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rajneesh Dwivedi', N'7440689542', N'adwivedi39614@gmail.com', N'2025-07-29', N'2007-07-28', N'OE', N'2025-07-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ashish Dwivedi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rajneesh Dwivedi', [fatherName]),
        [mobile] = ISNULL(N'7440689542', [mobile]),
        [email] = ISNULL(N'adwivedi39614@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-29', [joiningDate]),
        [dob] = ISNULL(N'2007-07-28', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002565';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002566')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002566', N'Omkar Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Satyanarayan Yadav', N'8429347038', N'omkaryadavji777@gmail.com', N'2025-07-29', N'2005-03-12', N'OE', N'2025-07-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Omkar Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Satyanarayan Yadav', [fatherName]),
        [mobile] = ISNULL(N'8429347038', [mobile]),
        [email] = ISNULL(N'omkaryadavji777@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-29', [joiningDate]),
        [dob] = ISNULL(N'2005-03-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002566';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002567')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002567', N'Aakash Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Suresh Prasad', N'9696884413', N'aakashkumar3212gkp@gmail.com', N'2025-07-29', N'2006-01-09', N'OE', N'2025-07-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aakash Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Suresh Prasad', [fatherName]),
        [mobile] = ISNULL(N'9696884413', [mobile]),
        [email] = ISNULL(N'aakashkumar3212gkp@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-29', [joiningDate]),
        [dob] = ISNULL(N'2006-01-09', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002567';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002571')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002571', N'Agatya Pradip Nalawade', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Pradip Nalawade', N'7420809275', N'nalawadeagyatya@gmail.com', N'2026-06-01', N'2007-06-09', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Agatya Pradip Nalawade', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Pradip Nalawade', [fatherName]),
        [mobile] = ISNULL(N'7420809275', [mobile]),
        [email] = ISNULL(N'nalawadeagyatya@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-06-09', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002571';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002573')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002573', N'Akash Baliram Kadam', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Baliram Kadam', N'9730506415', N'akashkadam4566@gmail.com', N'2026-06-01', N'2007-02-22', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Akash Baliram Kadam', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Baliram Kadam', [fatherName]),
        [mobile] = ISNULL(N'9730506415', [mobile]),
        [email] = ISNULL(N'akashkadam4566@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-02-22', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002573';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002579')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002579', N'Rohit Sanjay Madne', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sanjay Madne', N'8830051832', N'madanerohit6377@gmail.com', N'2026-06-01', N'2007-07-15', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rohit Sanjay Madne', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sanjay Madne', [fatherName]),
        [mobile] = ISNULL(N'8830051832', [mobile]),
        [email] = ISNULL(N'madanerohit6377@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-07-15', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002579';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002581')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002581', N'Sumit Tanaji Bansode', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Tanaji Bansode', N'7038173817', N'bansodesumit104@gmail.com', N'2026-06-01', N'2007-11-27', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sumit Tanaji Bansode', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Tanaji Bansode', [fatherName]),
        [mobile] = ISNULL(N'7038173817', [mobile]),
        [email] = ISNULL(N'bansodesumit104@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-11-27', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002581';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002583')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002583', N'Balabanta Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Praveen Parkhe', N'8117914411', N'balabantab529@gmail.com', N'2026-06-01', N'2008-03-11', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Balabanta Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Praveen Parkhe', [fatherName]),
        [mobile] = ISNULL(N'8117914411', [mobile]),
        [email] = ISNULL(N'balabantab529@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2008-03-11', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002583';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002586')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002586', N'Biplab Nayak', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bijan Nayak', N'9040877705', N'bijannayak2000@gmail.com', N'2026-06-01', N'2008-04-20', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Biplab Nayak', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bijan Nayak', [fatherName]),
        [mobile] = ISNULL(N'9040877705', [mobile]),
        [email] = ISNULL(N'bijannayak2000@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2008-04-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002586';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002587')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002587', N'Amulya Rout', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Anirudha Rout', N'9337891781', N'amulyaroutamulya89@gmail.com', N'2026-06-01', N'2006-03-26', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Amulya Rout', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Anirudha Rout', [fatherName]),
        [mobile] = ISNULL(N'9337891781', [mobile]),
        [email] = ISNULL(N'amulyaroutamulya89@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-03-26', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002587';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002588')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002588', N'Raj Kumar Malik', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Malik Sahi', N'7849027580', N'rajkumarmalikraju2007@gmail.com', N'2026-06-01', N'2007-02-08', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raj Kumar Malik', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Malik Sahi', [fatherName]),
        [mobile] = ISNULL(N'7849027580', [mobile]),
        [email] = ISNULL(N'rajkumarmalikraju2007@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-02-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002588';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002589')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002589', N'Rahul Kumar Sahoo', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dillip Kumar Sahoo', N'6372646905', N'rahulkumarsahoo2006@gmail.com', N'2026-06-01', N'2006-01-20', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul Kumar Sahoo', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dillip Kumar Sahoo', [fatherName]),
        [mobile] = ISNULL(N'6372646905', [mobile]),
        [email] = ISNULL(N'rahulkumarsahoo2006@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-01-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002589';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002590')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002590', N'Jayaram Sethy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bichitra Sethy', N'9861066496', N'jayaramsethy20@gmail.com', N'2026-06-01', N'2005-10-03', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jayaram Sethy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bichitra Sethy', [fatherName]),
        [mobile] = ISNULL(N'9861066496', [mobile]),
        [email] = ISNULL(N'jayaramsethy20@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2005-10-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002590';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002591')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002591', N'Sidharth Ojha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Prabhat Ojha', N'9692886517', N'sidharthojha620@gmail.com', N'2026-06-01', N'2005-10-03', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sidharth Ojha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Prabhat Ojha', [fatherName]),
        [mobile] = ISNULL(N'9692886517', [mobile]),
        [email] = ISNULL(N'sidharthojha620@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2005-10-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002591';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002592')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002592', N'Debabrata Swain', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sanjay Swain', N'9776728622', N'debabrataswain763@gmail.com', N'2026-06-01', N'2005-02-16', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Debabrata Swain', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sanjay Swain', [fatherName]),
        [mobile] = ISNULL(N'9776728622', [mobile]),
        [email] = ISNULL(N'debabrataswain763@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2005-02-16', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002592';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002594')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002594', N'Jitendra Sutar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bishnuprasad Sutar', N'7978405141', N'jitendrasutar232@gmail.com', N'2026-06-01', N'2004-08-21', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jitendra Sutar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bishnuprasad Sutar', [fatherName]),
        [mobile] = ISNULL(N'7978405141', [mobile]),
        [email] = ISNULL(N'jitendrasutar232@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2004-08-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002594';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002596')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002596', N'Arup Avijit Sutar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sukadev Sutar', N'9692553152', N'kumarbchandan116@gmail.com', N'2026-06-01', N'2006-01-15', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arup Avijit Sutar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sukadev Sutar', [fatherName]),
        [mobile] = ISNULL(N'9692553152', [mobile]),
        [email] = ISNULL(N'kumarbchandan116@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-01-15', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002596';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002597')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002597', N'Sangram Swain', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sanjay Swain', N'8114968473', N'sangramlifestyles254@gmail.com', N'2026-06-01', N'2006-04-16', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sangram Swain', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sanjay Swain', [fatherName]),
        [mobile] = ISNULL(N'8114968473', [mobile]),
        [email] = ISNULL(N'sangramlifestyles254@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-04-16', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002597';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002598')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002598', N'Pritee Laxman Karande', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Laxman Karande', N'8669136348', N'priteekarande1363@gmail.com', N'2026-06-01', N'2006-05-30', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pritee Laxman Karande', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Laxman Karande', [fatherName]),
        [mobile] = ISNULL(N'8669136348', [mobile]),
        [email] = ISNULL(N'priteekarande1363@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-05-30', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002598';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002600')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002600', N'Vaibhavi Vishnu Patil', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Vishnu Patil', N'9325321472', N'vaibhavi1472@gmail.com', N'2026-06-01', N'2007-07-03', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vaibhavi Vishnu Patil', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Vishnu Patil', [fatherName]),
        [mobile] = ISNULL(N'9325321472', [mobile]),
        [email] = ISNULL(N'vaibhavi1472@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-07-03', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002600';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002602')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002602', N'Shreya Subhash Kale', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Subhash Shreerang Kale', N'9226721539', N'kaleshreya1812@gmail.com', N'2026-06-01', N'2006-12-18', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shreya Subhash Kale', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Subhash Shreerang Kale', [fatherName]),
        [mobile] = ISNULL(N'9226721539', [mobile]),
        [email] = ISNULL(N'kaleshreya1812@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-12-18', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002602';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002604')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002604', N'Pranita Rajaram Salunkhe', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rajaram Rangrao Salunkhe', N'8767132191', N'pranitasalunkhe6@gmail.com', N'2026-06-01', N'2006-06-25', N'OET', N'2026-06-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pranita Rajaram Salunkhe', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rajaram Rangrao Salunkhe', [fatherName]),
        [mobile] = ISNULL(N'8767132191', [mobile]),
        [email] = ISNULL(N'pranitasalunkhe6@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2006-06-25', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002604';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002606')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002606', N'Muskan Yadav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Birender', N'7206170341', N'muskanyadav3570@gmail.com', N'2026-06-02', N'2004-07-12', N'OET', N'2026-06-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muskan Yadav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Birender', [fatherName]),
        [mobile] = ISNULL(N'7206170341', [mobile]),
        [email] = ISNULL(N'muskanyadav3570@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-02', [joiningDate]),
        [dob] = ISNULL(N'2004-07-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002606';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002607')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002607', N'Durgasish Muduli', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Pitambar Muduli', N'6372824539', N'durgaishbabu@gmail.com', N'2026-06-02', N'2008-01-24', N'OET', N'2026-06-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Durgasish Muduli', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Pitambar Muduli', [fatherName]),
        [mobile] = ISNULL(N'6372824539', [mobile]),
        [email] = ISNULL(N'durgaishbabu@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-02', [joiningDate]),
        [dob] = ISNULL(N'2008-01-24', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002607';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002608')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002608', N'Chandrakanta Pati', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Suresh Kumar Pati', N'7815085489', N'chandrakantapati262@gmail.com', N'2026-06-02', N'2007-11-28', N'OET', N'2026-06-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandrakanta Pati', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Suresh Kumar Pati', [fatherName]),
        [mobile] = ISNULL(N'7815085489', [mobile]),
        [email] = ISNULL(N'chandrakantapati262@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-02', [joiningDate]),
        [dob] = ISNULL(N'2007-11-28', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002608';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002609')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002609', N'Biswa Ranjan Das', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Bhikari Charan Das', N'6371868831', N'dasbiswaranjan4321@gmail.com', N'2026-06-02', N'2008-03-14', N'OET', N'2026-06-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Biswa Ranjan Das', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bhikari Charan Das', [fatherName]),
        [mobile] = ISNULL(N'6371868831', [mobile]),
        [email] = ISNULL(N'dasbiswaranjan4321@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-02', [joiningDate]),
        [dob] = ISNULL(N'2008-03-14', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002609';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002612')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002612', N'Satyam Suresh Damame', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Suresh Damame', N'9309999328', N'satyamdamame2005@gmail.com', N'2026-06-02', N'2005-01-27', N'OET', N'2026-06-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Satyam Suresh Damame', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Suresh Damame', [fatherName]),
        [mobile] = ISNULL(N'9309999328', [mobile]),
        [email] = ISNULL(N'satyamdamame2005@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-02', [joiningDate]),
        [dob] = ISNULL(N'2005-01-27', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002612';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002613')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002613', N'Raja Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Ramanand Shah', N'7701883439', N'rajakumar770188@gmail.com', N'2026-06-03', N'2005-03-30', N'OET', N'2026-06-03', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raja Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ramanand Shah', [fatherName]),
        [mobile] = ISNULL(N'7701883439', [mobile]),
        [email] = ISNULL(N'rajakumar770188@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-03', [joiningDate]),
        [dob] = ISNULL(N'2005-03-30', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002613';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002614')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002614', N'Shivam Tomar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sandeep Kumar', N'8745926647', N'shivamtomarstar123@gmail.com', N'2026-06-03', N'2007-07-15', N'OET', N'2026-06-03', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivam Tomar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sandeep Kumar', [fatherName]),
        [mobile] = ISNULL(N'8745926647', [mobile]),
        [email] = ISNULL(N'shivamtomarstar123@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-03', [joiningDate]),
        [dob] = ISNULL(N'2007-07-15', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002614';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002615')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002615', N'Rishabh Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Virendra Singh', N'8527237663', N'rishabh07663@gmail.com', N'2026-06-03', N'2005-11-02', N'OET', N'2026-06-03', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rishabh Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Virendra Singh', [fatherName]),
        [mobile] = ISNULL(N'8527237663', [mobile]),
        [email] = ISNULL(N'rishabh07663@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-03', [joiningDate]),
        [dob] = ISNULL(N'2005-11-02', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002615';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002617')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002617', N'Prahlad Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Raj Kumar Pandit', N'8510990542', N'p.kumar125482@gmail.com', N'2026-06-03', N'2005-02-06', N'OET', N'2026-06-03', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Prahlad Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Raj Kumar Pandit', [fatherName]),
        [mobile] = ISNULL(N'8510990542', [mobile]),
        [email] = ISNULL(N'p.kumar125482@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-03', [joiningDate]),
        [dob] = ISNULL(N'2005-02-06', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002617';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002618')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002618', N'Jatin Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Vinay Sharma', N'7834826005', N'jatinsharma6005@gmail.com', N'2026-06-03', N'2007-11-16', N'OET', N'2026-06-03', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jatin Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Vinay Sharma', [fatherName]),
        [mobile] = ISNULL(N'7834826005', [mobile]),
        [email] = ISNULL(N'jatinsharma6005@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-03', [joiningDate]),
        [dob] = ISNULL(N'2007-11-16', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002618';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002619')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002619', N'Vansh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Pawan Kumar', N'8929565202', N'vanshsehewat2@gmail.com', N'2026-06-03', N'2007-04-20', N'OET', N'2026-06-03', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vansh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Pawan Kumar', [fatherName]),
        [mobile] = ISNULL(N'8929565202', [mobile]),
        [email] = ISNULL(N'vanshsehewat2@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-03', [joiningDate]),
        [dob] = ISNULL(N'2007-04-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002619';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002620')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002620', N'Digvijay Mayappa Maske', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Mayappa Maske', N'9313338378', N'masakesaksham218@gmail.com', N'2026-06-05', N'2008-01-31', N'OET', N'2026-06-05', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Digvijay Mayappa Maske', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Mayappa Maske', [fatherName]),
        [mobile] = ISNULL(N'9313338378', [mobile]),
        [email] = ISNULL(N'masakesaksham218@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-05', [joiningDate]),
        [dob] = ISNULL(N'2008-01-31', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002620';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002623')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002623', N'Priya Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Dinesh Kumar Singh', N'8809300551', N'priyakumarsingh5@gmail.com', N'2026-07-02', N'2005-11-28', N'OET', N'2026-07-02', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priya Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Dinesh Kumar Singh', [fatherName]),
        [mobile] = ISNULL(N'8809300551', [mobile]),
        [email] = ISNULL(N'priyakumarsingh5@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-02', [joiningDate]),
        [dob] = ISNULL(N'2005-11-28', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002623';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002624')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002624', N'Tanya Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kamakhya Narayan Jaiswal', N'8340786518', N'tanyaraj1604@gmail.com', N'2026-07-14', N'2006-09-13', N'OET', N'2026-07-14', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tanya Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kamakhya Narayan Jaiswal', [fatherName]),
        [mobile] = ISNULL(N'8340786518', [mobile]),
        [email] = ISNULL(N'tanyaraj1604@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-14', [joiningDate]),
        [dob] = ISNULL(N'2006-09-13', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002624';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002625')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002625', N'Ranu Kumari Ojha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Sandeep Kumar Ojha', N'6202897554', N'ranuojha871@gmail.com', N'2026-07-28', N'2007-10-04', N'OET', N'2026-07-28', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ranu Kumari Ojha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Sandeep Kumar Ojha', [fatherName]),
        [mobile] = ISNULL(N'6202897554', [mobile]),
        [email] = ISNULL(N'ranuojha871@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-28', [joiningDate]),
        [dob] = ISNULL(N'2007-10-04', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002625';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002626')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002626', N'Pooja Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Om Prakash Singh', N'9263448592', N'misspooja825411@gmail.com', N'2026-07-28', N'2005-02-24', N'OET', N'2026-07-28', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pooja Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Om Prakash Singh', [fatherName]),
        [mobile] = ISNULL(N'9263448592', [mobile]),
        [email] = ISNULL(N'misspooja825411@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-28', [joiningDate]),
        [dob] = ISNULL(N'2005-02-24', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002626';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002627')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002627', N'Khitija Mahato', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Kameshwar Mahato', N'6203438516', N'kshitijamahato25@gmail.com', N'2026-07-28', N'2005-05-26', N'OET', N'2026-07-28', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Khitija Mahato', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kameshwar Mahato', [fatherName]),
        [mobile] = ISNULL(N'6203438516', [mobile]),
        [email] = ISNULL(N'kshitijamahato25@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-28', [joiningDate]),
        [dob] = ISNULL(N'2005-05-26', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002627';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002628')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002628', N'Roshni Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitPune, @deptPun,
        N'Rukam Keshwari Prasad Singh', N'9661314147', N'rs1115769@gmail.com', N'2026-08-01', N'2005-09-01', N'OET', N'2026-08-01', N'1OET'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Roshni Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rukam Keshwari Prasad Singh', [fatherName]),
        [mobile] = ISNULL(N'9661314147', [mobile]),
        [email] = ISNULL(N'rs1115769@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-01', [joiningDate]),
        [dob] = ISNULL(N'2005-09-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1OET', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002628';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001332')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001332', N'Shekhar Kanifnath Khedekar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitPune, @deptPun,
        N'Kanifnath', N'9011051440', N'shekhar.khedekar@mahle.com', N'2004-02-16', N'1984-06-07', N'Asst. Manager', N'2004-02-16', N'5'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shekhar Kanifnath Khedekar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Kanifnath', [fatherName]),
        [mobile] = ISNULL(N'9011051440', [mobile]),
        [email] = ISNULL(N'shekhar.khedekar@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2004-02-16', [joiningDate]),
        [dob] = ISNULL(N'1984-06-07', [dob]),
        [designation] = ISNULL(N'Asst. Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2004-02-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'5', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001332';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'006707')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'006707', N'Tushar Santosh Pawar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitPune, @deptPun,
        N'Santosh Nathoba Pawar', N'9922912177', N'tushar.pawar@mahle.com', N'2025-07-07', N'1980-06-26', N'Sr. Manager', N'2025-07-07', N'7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tushar Santosh Pawar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Santosh Nathoba Pawar', [fatherName]),
        [mobile] = ISNULL(N'9922912177', [mobile]),
        [email] = ISNULL(N'tushar.pawar@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-07', [joiningDate]),
        [dob] = ISNULL(N'1980-06-26', [dob]),
        [designation] = ISNULL(N'Sr. Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'006707';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'006687')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'006687', N'Sandeep Uttam Shinde', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitPune, @deptPun,
        N'Uttam Shinde', N'9822829485', N'sandip.shinde@mahle.com', N'2023-09-09', N'1986-03-14', N'Sr. Executive', N'2023-09-09', N'4'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sandeep Uttam Shinde', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Uttam Shinde', [fatherName]),
        [mobile] = ISNULL(N'9822829485', [mobile]),
        [email] = ISNULL(N'sandip.shinde@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2023-09-09', [joiningDate]),
        [dob] = ISNULL(N'1986-03-14', [dob]),
        [designation] = ISNULL(N'Sr. Executive', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'4', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'006687';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'006714')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'006714', N'Asmita Sehgal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitPune, @deptPun,
        N'Ajay Anand Sehgal', N'7819976703', N'asmita.a.sehgal@mahle.com', N'2026-09-24', N'1999-06-05', N'Sr. Executive', N'2026-09-24', N'4'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Asmita Sehgal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Ajay Anand Sehgal', [fatherName]),
        [mobile] = ISNULL(N'7819976703', [mobile]),
        [email] = ISNULL(N'asmita.a.sehgal@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-24', [joiningDate]),
        [dob] = ISNULL(N'1999-06-05', [dob]),
        [designation] = ISNULL(N'Sr. Executive', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-24', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'4', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'006714';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002326')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002326', N'Bhagyashri Patil', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitPune, @deptPun,
        N'Rajendra ravasaheb Patil', N'8390202724', N'bhagyashree.patil@mahle.com', N'2021-10-19', N'2002-09-01', N'Asst. Engineer', N'2021-10-19', N'M2-Indirect'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhagyashri Patil', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Rajendra ravasaheb Patil', [fatherName]),
        [mobile] = ISNULL(N'8390202724', [mobile]),
        [email] = ISNULL(N'bhagyashree.patil@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-19', [joiningDate]),
        [dob] = ISNULL(N'2002-09-01', [dob]),
        [designation] = ISNULL(N'Asst. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M2-Indirect', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002326';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001351')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001351', N'Sandeep Baburao Malvi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitPune, @deptPun,
        N'Baburao Rau Malvi', N'7774019873', N'sandeep.malvi@mahle.com', N'2005-01-20', N'1982-05-09', N'Manager', N'2005-01-20', N'6'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sandeep Baburao Malvi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Baburao Rau Malvi', [fatherName]),
        [mobile] = ISNULL(N'7774019873', [mobile]),
        [email] = ISNULL(N'sandeep.malvi@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2005-01-20', [joiningDate]),
        [dob] = ISNULL(N'1982-05-09', [dob]),
        [designation] = ISNULL(N'Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2005-01-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'6', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001351';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001336')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001336', N'Chopade Bajirao Nana', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitPune, @deptPun,
        N'Nana', N'8805496561', N'bajirao.chaupade@mahle.com', N'2004-08-02', N'1981-05-10', N'Engineer', N'2004-08-02', N'M3-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chopade Bajirao Nana', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Nana', [fatherName]),
        [mobile] = ISNULL(N'8805496561', [mobile]),
        [email] = ISNULL(N'bajirao.chaupade@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2004-08-02', [joiningDate]),
        [dob] = ISNULL(N'1981-05-10', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2004-08-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001336';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001955')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001955', N'Chandan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitPune, @deptPun,
        N'Upendra kumar Sharma', N'7040664136', N'chandan.b.kumar@mahle.com', N'2015-01-16', N'1993-08-20', N'Asst. Engineer', N'2015-01-16', N'M2-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Upendra kumar Sharma', [fatherName]),
        [mobile] = ISNULL(N'7040664136', [mobile]),
        [email] = ISNULL(N'chandan.b.kumar@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2015-01-16', [joiningDate]),
        [dob] = ISNULL(N'1993-08-20', [dob]),
        [designation] = ISNULL(N'Asst. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2015-01-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M2-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001955';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'001825')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'001825', N'Jogdand Shuddhodhan Yashwant', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitPune, @deptPun,
        N'Yashwan', N'8308311977', N'shuddhodhan.jogdand@mahle.com', N'2013-04-09', N'1991-12-20', N'Engineer', N'2013-04-09', N'M3-Direct'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jogdand Shuddhodhan Yashwant', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Yashwan', [fatherName]),
        [mobile] = ISNULL(N'8308311977', [mobile]),
        [email] = ISNULL(N'shuddhodhan.jogdand@mahle.com', [email]),
        [joiningDate] = ISNULL(N'2013-04-09', [joiningDate]),
        [dob] = ISNULL(N'1991-12-20', [dob]),
        [designation] = ISNULL(N'Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2013-04-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'M3-Direct', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'001825';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'002272')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'002272', N'Shital Bhikaji Jadhav', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitPune, @deptPun,
        N'Bhikaji Ishwara Jadhav', N'9075408272', N'jshital69@gmail.com', N'2020-02-13', N'1998-11-01', N'Jr. Engineer', N'2020-02-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shital Bhikaji Jadhav', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitPune,
        [departmentId] = ISNULL([departmentId], @deptPun),
        [fatherName] = ISNULL(N'Bhikaji Ishwara Jadhav', [fatherName]),
        [mobile] = ISNULL(N'9075408272', [mobile]),
        [email] = ISNULL(N'jshital69@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-02-13', [joiningDate]),
        [dob] = ISNULL(N'1998-11-01', [dob]),
        [designation] = ISNULL(N'Jr. Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-02-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'002272';
END

-- ============================================================================
-- 4. ESTABLISH SUPERVISORY REPORTING HIERARCHY WITHIN EACH PLANT
-- ============================================================================
-- 4.1 Link Team Leaders (TL) to Senior Group Leaders (SGL) in the same plant

;WITH TlCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rTL AND isActive = 1
),
SglCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn,
           COUNT(*) OVER (PARTITION BY unitId) AS sglCount
    FROM [dbo].[User]
    WHERE roleId = @rSGL AND isActive = 1
)
UPDATE t
SET t.sglId = s.id
FROM [dbo].[User] t
JOIN TlCTE tc ON t.id = tc.id
JOIN SglCTE s ON tc.unitId = s.unitId AND ((tc.rn - 1) % s.sglCount) + 1 = s.rn;

-- 4.2 Link Employees to Team Leaders (TL) and SGLs in the same plant

;WITH EmpCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rEmployee AND isActive = 1
),
TlCTE AS (
    SELECT id, unitId, sglId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn,
           COUNT(*) OVER (PARTITION BY unitId) AS tlCount
    FROM [dbo].[User]
    WHERE roleId = @rTL AND isActive = 1
)
UPDATE e
SET e.tlId = t.id,
    e.sglId = t.sglId
FROM [dbo].[User] e
JOIN EmpCTE ec ON e.id = ec.id
JOIN TlCTE t ON ec.unitId = t.unitId AND ((ec.rn - 1) % t.tlCount) + 1 = t.rn;

COMMIT TRANSACTION;
PRINT '============================================================================';
PRINT 'Successfully seeded 3 plants (537 records) into GrowthPortal!';
PRINT '============================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Error during plant seeding: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO