-- ============================================================================
-- MAHLE ANAND GROWTH PASSPORT - CHENNAI PLANT DATA SEED SCRIPT
-- Plant: Chennai (Code: CHN) | Total Personnel Seeded: 211 records
-- Target Database: GrowthPortal
-- Compatible with: SQL Server 2017 / 2019 / 2022 / Azure SQL
-- Date Generated: 2026-10-23 17:52:42
-- ============================================================================
SET NOCOUNT ON;
GO

USE [GrowthPortal];
GO

BEGIN TRY
BEGIN TRANSACTION;

-- ----------------------------------------------------------------------------
-- 1. ENSURE CHENNAI UNIT EXISTS
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Chennai')
    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Chennai', 'CHN', 1);
ELSE
    UPDATE [dbo].[Unit] SET [code] = 'CHN', [isActive] = 1 WHERE [name] = 'Chennai';

DECLARE @unitChennai NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Chennai');

-- ----------------------------------------------------------------------------
-- 2. ENSURE STANDARD DEPARTMENTS EXIST FOR CHENNAI
-- ----------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitChennai)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Manufacturing / Production', @unitChennai);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Quality Assurance' AND [unitId] = @unitChennai)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Quality Assurance', @unitChennai);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Assembly Line' AND [unitId] = @unitChennai)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Assembly Line', @unitChennai);
IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = 'Operations' AND [unitId] = @unitChennai)
    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Operations', @unitChennai);

DECLARE @deptChennai NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitChennai);

-- ----------------------------------------------------------------------------
-- 3. RESOLVE SYSTEM ROLES
-- ----------------------------------------------------------------------------
DECLARE @rSuperAdmin NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Super Admin');
DECLARE @rHrHead     NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'HR Head');
DECLARE @rUnitAdmin  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Unit Admin');
DECLARE @rSGL        NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');
DECLARE @rTL         NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');
DECLARE @rEmployee   NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Employee');

-- Default password hash for initial user access: 'Mahle@123'
DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';

-- ============================================================================
-- 4. INSERT OR UPDATE 211 CHENNAI PERSONNEL
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'K0894')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'K0894', N'PRAMOD SWAIN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Umakanta Swain', N'7988721906', N'swainpramod57@gmail.com', N'2014-08-18', N'1996-07-12', N'OE', N'2014-08-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'PRAMOD SWAIN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Umakanta Swain', [fatherName]),
        [mobile] = ISNULL(N'7988721906', [mobile]),
        [email] = ISNULL(N'swainpramod57@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-08-18', [joiningDate]),
        [dob] = ISNULL(N'1996-07-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-08-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'K0894';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1918')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1918', N'Aman Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dhirendra singh', N'9284877141', N'amankumar65066@gmail.com', N'2014-10-27', N'1995-02-03', N'OE', N'2014-10-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aman Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dhirendra singh', [fatherName]),
        [mobile] = ISNULL(N'9284877141', [mobile]),
        [email] = ISNULL(N'amankumar65066@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2014-10-27', [joiningDate]),
        [dob] = ISNULL(N'1995-02-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2014-10-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1918';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1048')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1048', N'Raja R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitChennai, @deptChennai,
        N'V Rajaraman', N'8939720451', N'pratheeshseetha@gmail.com', N'2016-02-15', N'1986-06-01', N'Manager', N'2016-02-15', N'6'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raja R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'V Rajaraman', [fatherName]),
        [mobile] = ISNULL(N'8939720451', [mobile]),
        [email] = ISNULL(N'pratheeshseetha@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-02-15', [joiningDate]),
        [dob] = ISNULL(N'1986-06-01', [dob]),
        [designation] = ISNULL(N'Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-02-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'6', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1048';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6139')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6139', N'Subramani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitChennai, @deptChennai,
        N'Shanmugavel', N'9965241021', N'smani2985@gmail.com', N'2016-11-22', N'1996-05-26', N'Senior Engineer', N'2016-11-22', N'4'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Subramani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Shanmugavel', [fatherName]),
        [mobile] = ISNULL(N'9965241021', [mobile]),
        [email] = ISNULL(N'smani2985@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2016-11-22', [joiningDate]),
        [dob] = ISNULL(N'1996-05-26', [dob]),
        [designation] = ISNULL(N'Senior Engineer', [designation]),
        [groupJoiningDate] = ISNULL(N'2016-11-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'4', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6139';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6165')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6165', N'M.Rathinavel', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'L.Manickam', N'9551015906', N'mrathinavel.1997@gmail.com', N'2017-08-17', N'1997-06-23', N'TL', N'2017-08-17', N'3'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'M.Rathinavel', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'L.Manickam', [fatherName]),
        [mobile] = ISNULL(N'9551015906', [mobile]),
        [email] = ISNULL(N'mrathinavel.1997@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2017-08-17', [joiningDate]),
        [dob] = ISNULL(N'1997-06-23', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2017-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'3', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6165';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6256')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6256', N'E Dharani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'R Elangovan', N'7395862186', N'dharanideee123@gmail.com', N'2020-03-05', N'2000-06-13', N'TL', N'2020-03-05', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'E Dharani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'R Elangovan', [fatherName]),
        [mobile] = ISNULL(N'7395862186', [mobile]),
        [email] = ISNULL(N'dharanideee123@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-03-05', [joiningDate]),
        [dob] = ISNULL(N'2000-06-13', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-03-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6256';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6261')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6261', N'Bijaya Kumar Roul', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Nandakishor roul', N'8658439476', N'bijayaroul@gmail.com', N'2020-03-18', N'2000-02-04', N'OE', N'2020-03-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bijaya Kumar Roul', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Nandakishor roul', [fatherName]),
        [mobile] = ISNULL(N'8658439476', [mobile]),
        [email] = ISNULL(N'bijayaroul@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-03-18', [joiningDate]),
        [dob] = ISNULL(N'2000-02-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-03-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6261';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6297')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6297', N'T Deepa', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'N Tamilselvan', N'9677609812', N'deepatdeepa2002@gmail.com', N'2020-10-12', N'2002-10-21', N'OE', N'2020-10-12', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'T Deepa', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'N Tamilselvan', [fatherName]),
        [mobile] = ISNULL(N'9677609812', [mobile]),
        [email] = ISNULL(N'deepatdeepa2002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-10-12', [joiningDate]),
        [dob] = ISNULL(N'2002-10-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-10-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6297';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6311')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6311', N'Mathivanan M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Mohan', N'9344221545', N'mathi2775@gmail.com', N'2020-10-12', N'2000-07-03', N'TL', N'2020-10-12', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mathivanan M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mohan', [fatherName]),
        [mobile] = ISNULL(N'9344221545', [mobile]),
        [email] = ISNULL(N'mathi2775@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-10-12', [joiningDate]),
        [dob] = ISNULL(N'2000-07-03', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-10-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6311';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8024')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8024', N'Vijay Shankar PV', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Venugopal', N'9074552215', N'vgvijay804@gmail.com', N'2021-01-20', N'1998-05-02', N'TL', N'2021-01-20', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vijay Shankar PV', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Venugopal', [fatherName]),
        [mobile] = ISNULL(N'9074552215', [mobile]),
        [email] = ISNULL(N'vgvijay804@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-01-20', [joiningDate]),
        [dob] = ISNULL(N'1998-05-02', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-01-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8024';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8027')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8027', N'S Vijaya Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Suruli Vel', N'9384239131', N'vijayrd0707@gmail.com', N'2021-01-20', N'2000-07-18', N'TL', N'2021-01-20', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'S Vijaya Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Suruli Vel', [fatherName]),
        [mobile] = ISNULL(N'9384239131', [mobile]),
        [email] = ISNULL(N'vijayrd0707@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-01-20', [joiningDate]),
        [dob] = ISNULL(N'2000-07-18', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-01-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8027';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8053')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8053', N'Anish Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ashok Mahto', N'9631706188', N'kumaranish7821@gmail.com', N'2021-08-17', N'2003-03-16', N'OE', N'2021-08-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anish Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ashok Mahto', [fatherName]),
        [mobile] = ISNULL(N'9631706188', [mobile]),
        [email] = ISNULL(N'kumaranish7821@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2003-03-16', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8053';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8056')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8056', N'Bijan Paul', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bibhishan', N'7247055050', N'paulbijan2001@gmail.com', N'2021-08-17', N'2001-01-25', N'OE', N'2021-08-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bijan Paul', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bibhishan', [fatherName]),
        [mobile] = ISNULL(N'7247055050', [mobile]),
        [email] = ISNULL(N'paulbijan2001@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2001-01-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8056';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8063')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8063', N'MANOJ RANJITH', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'E.Ranjith', N'9345718420', N'ranjithmanoj20021234@gmail.com', N'2021-08-17', N'2002-01-13', N'TL', N'2021-08-17', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'MANOJ RANJITH', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'E.Ranjith', [fatherName]),
        [mobile] = ISNULL(N'9345718420', [mobile]),
        [email] = ISNULL(N'ranjithmanoj20021234@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2002-01-13', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8063';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8066')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8066', N'PARTHIBAN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'N.Arumugam', N'8667383206', N'parthibanakash2187@gmail.com', N'2021-08-17', N'2001-03-19', N'TL', N'2021-08-17', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'PARTHIBAN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'N.Arumugam', [fatherName]),
        [mobile] = ISNULL(N'8667383206', [mobile]),
        [email] = ISNULL(N'parthibanakash2187@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2001-03-19', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8066';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8070')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8070', N'RAMACHANDIRAN U', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Umasankar.C', N'9344655223', N'ramachandiranram706@gmail.com', N'2021-08-17', N'2001-07-27', N'OE', N'2021-08-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RAMACHANDIRAN U', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Umasankar.C', [fatherName]),
        [mobile] = ISNULL(N'9344655223', [mobile]),
        [email] = ISNULL(N'ramachandiranram706@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2001-07-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8070';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8072')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8072', N'SARAVANAN AZHAGESAN', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'K.Azhagesan', N'7305752509', N'asaravananccc2002@gmail.com', N'2021-08-17', N'2002-06-07', N'OE', N'2021-08-17', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SARAVANAN AZHAGESAN', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'K.Azhagesan', [fatherName]),
        [mobile] = ISNULL(N'7305752509', [mobile]),
        [email] = ISNULL(N'asaravananccc2002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2002-06-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8072';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8073')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8073', N'SARAVANAN SELVARAJ', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'R.Selvaraj', N'6382850623', N'cksaravanan256@gmail.com', N'2021-08-17', N'2002-09-08', N'TL', N'2021-08-17', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SARAVANAN SELVARAJ', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'R.Selvaraj', [fatherName]),
        [mobile] = ISNULL(N'6382850623', [mobile]),
        [email] = ISNULL(N'cksaravanan256@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-17', [joiningDate]),
        [dob] = ISNULL(N'2002-09-08', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-17', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8073';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8083')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8083', N'Namrata Rout', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Laxmikanta Rout', N'9337209599', N'namratarout93610@gmail.com', N'2021-08-20', N'2002-03-22', N'OE', N'2021-08-20', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Namrata Rout', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Laxmikanta Rout', [fatherName]),
        [mobile] = ISNULL(N'9337209599', [mobile]),
        [email] = ISNULL(N'namratarout93610@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-08-20', [joiningDate]),
        [dob] = ISNULL(N'2002-03-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-08-20', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8083';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8093')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8093', N'Mugeshwaran A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Arvindhar Munusamy', N'6374803089', N'mugesh031199@gmail.com', N'2021-09-02', N'1999-03-11', N'OE', N'2021-09-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mugeshwaran A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Arvindhar Munusamy', [fatherName]),
        [mobile] = ISNULL(N'6374803089', [mobile]),
        [email] = ISNULL(N'mugesh031199@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-09-02', [joiningDate]),
        [dob] = ISNULL(N'1999-03-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-09-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8093';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8094')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8094', N'Dinesh Periyasamy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Periyasamy', N'7010455255', N'dhinesh667788@gmail.com', N'2021-09-02', N'2000-05-12', N'OE', N'2021-09-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dinesh Periyasamy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Periyasamy', [fatherName]),
        [mobile] = ISNULL(N'7010455255', [mobile]),
        [email] = ISNULL(N'dhinesh667788@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-09-02', [joiningDate]),
        [dob] = ISNULL(N'2000-05-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-09-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8094';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8096')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8096', N'Muruganandham Kolanjinathan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kolanjinathan', N'9659105948', N'muruganandhamkolanjinathan@gmail.com', N'2021-09-02', N'2002-11-27', N'OE', N'2021-09-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muruganandham Kolanjinathan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kolanjinathan', [fatherName]),
        [mobile] = ISNULL(N'9659105948', [mobile]),
        [email] = ISNULL(N'muruganandhamkolanjinathan@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-09-02', [joiningDate]),
        [dob] = ISNULL(N'2002-11-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-09-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8096';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8114')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8114', N'Subrata koley', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sujit koley', N'9732905277', N'kosubrata2003@gmail.com', N'2021-10-01', N'2003-04-22', N'OE', N'2021-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Subrata koley', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sujit koley', [fatherName]),
        [mobile] = ISNULL(N'9732905277', [mobile]),
        [email] = ISNULL(N'kosubrata2003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-01', [joiningDate]),
        [dob] = ISNULL(N'2003-04-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8114';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8121')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8121', N'Ruma Ruidas', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Mahadeb Ruidas', N'9382222802', N'rumaruidas340@gmail.com', N'2021-10-01', N'2001-08-24', N'OE', N'2021-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ruma Ruidas', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mahadeb Ruidas', [fatherName]),
        [mobile] = ISNULL(N'9382222802', [mobile]),
        [email] = ISNULL(N'rumaruidas340@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-01', [joiningDate]),
        [dob] = ISNULL(N'2001-08-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8121';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8129')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8129', N'Arindam Ghosh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bikash Ghosh', N'8001751120', N'arindam4040gosh@gmail.com', N'2021-10-01', N'2001-07-12', N'OE', N'2021-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arindam Ghosh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bikash Ghosh', [fatherName]),
        [mobile] = ISNULL(N'8001751120', [mobile]),
        [email] = ISNULL(N'arindam4040gosh@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-01', [joiningDate]),
        [dob] = ISNULL(N'2001-07-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8129';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8130')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8130', N'Subhanath Soo', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kartick Soo', N'9382699234', N'soosubhanath@gmail.com', N'2021-10-01', N'2000-07-21', N'OE', N'2021-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Subhanath Soo', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kartick Soo', [fatherName]),
        [mobile] = ISNULL(N'9382699234', [mobile]),
        [email] = ISNULL(N'soosubhanath@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-01', [joiningDate]),
        [dob] = ISNULL(N'2000-07-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8130';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8127')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8127', N'Shreya Roy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitChennai, @deptChennai,
        N'Dipak Roy', N'8910293261', N'shreya22609@gmail.com', N'2021-10-01', N'2000-07-08', N'OES', N'2021-10-01', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shreya Roy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dipak Roy', [fatherName]),
        [mobile] = ISNULL(N'8910293261', [mobile]),
        [email] = ISNULL(N'shreya22609@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2021-10-01', [joiningDate]),
        [dob] = ISNULL(N'2000-07-08', [dob]),
        [designation] = ISNULL(N'OES', [designation]),
        [groupJoiningDate] = ISNULL(N'2021-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8127';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8152')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8152', N'Harish R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sarat Chandra Behera', N'6382181978', N'harish9790102493@gmail.com', N'2022-01-03', N'2003-06-03', N'OE', N'2022-01-03', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Harish R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sarat Chandra Behera', [fatherName]),
        [mobile] = ISNULL(N'6382181978', [mobile]),
        [email] = ISNULL(N'harish9790102493@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-01-03', [joiningDate]),
        [dob] = ISNULL(N'2003-06-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-01-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8152';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8161')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8161', N'Akash Bala Krishnan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Bala Krishnan', N'9384256379', N'akash32bala@gmail.com', N'2022-02-14', N'2003-06-04', N'TL', N'2022-02-14', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Akash Bala Krishnan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bala Krishnan', [fatherName]),
        [mobile] = ISNULL(N'9384256379', [mobile]),
        [email] = ISNULL(N'akash32bala@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2003-06-04', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8161';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8162')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8162', N'Logesh Murugan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Murugan K', N'9360215856', N'logeshmurugan018@gmail.com', N'2022-02-14', N'2001-03-02', N'OE', N'2022-02-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Logesh Murugan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Murugan K', [fatherName]),
        [mobile] = ISNULL(N'9360215856', [mobile]),
        [email] = ISNULL(N'logeshmurugan018@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2001-03-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8162';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8164')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8164', N'Pasupathi R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ravindiran K', N'9360717522', N'pasupathipasupathi969@gmail.com', N'2022-02-14', N'2002-01-06', N'OE', N'2022-02-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pasupathi R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ravindiran K', [fatherName]),
        [mobile] = ISNULL(N'9360717522', [mobile]),
        [email] = ISNULL(N'pasupathipasupathi969@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-14', [joiningDate]),
        [dob] = ISNULL(N'2002-01-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8164';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8171')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8171', N'Tripti Shil', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Tapan Sil', N'6294968046', N'triptishil2000@gmail.com', N'2022-02-21', N'2000-02-09', N'TL', N'2022-02-21', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tripti Shil', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Tapan Sil', [fatherName]),
        [mobile] = ISNULL(N'6294968046', [mobile]),
        [email] = ISNULL(N'triptishil2000@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-02-21', [joiningDate]),
        [dob] = ISNULL(N'2000-02-09', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-02-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8171';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8183')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8183', N'Darapu Dhamodhara Rao', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Darapu Lakshminarayana', N'6383574005', N'darapudhamodhararao@gmail.com', N'2022-06-14', N'2003-08-23', N'OE', N'2022-06-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Darapu Dhamodhara Rao', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Darapu Lakshminarayana', [fatherName]),
        [mobile] = ISNULL(N'6383574005', [mobile]),
        [email] = ISNULL(N'darapudhamodhararao@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-06-14', [joiningDate]),
        [dob] = ISNULL(N'2003-08-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-06-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8183';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8197')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8197', N'Subalakshmi D', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Devakumar', N'9790452669', N'dsuba1003@gmail.com', N'2022-07-12', N'2000-12-10', N'OE', N'2022-07-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Subalakshmi D', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Devakumar', [fatherName]),
        [mobile] = ISNULL(N'9790452669', [mobile]),
        [email] = ISNULL(N'dsuba1003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-07-12', [joiningDate]),
        [dob] = ISNULL(N'2000-12-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-07-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8197';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8207')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8207', N'Poornima B', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Babu K', N'6380114293', N'poornimasunil25@gmail.com', N'2022-07-15', N'2000-10-25', N'OE', N'2022-07-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Poornima B', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Babu K', [fatherName]),
        [mobile] = ISNULL(N'6380114293', [mobile]),
        [email] = ISNULL(N'poornimasunil25@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-07-15', [joiningDate]),
        [dob] = ISNULL(N'2000-10-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-07-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8207';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8210')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8210', N'Sivanathi A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Andi Anuman A', N'6369473830', N'sivanathi1503@gmail.com', N'2022-07-15', N'2004-03-15', N'OE', N'2022-07-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sivanathi A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Andi Anuman A', [fatherName]),
        [mobile] = ISNULL(N'6369473830', [mobile]),
        [email] = ISNULL(N'sivanathi1503@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-07-15', [joiningDate]),
        [dob] = ISNULL(N'2004-03-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-07-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8210';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8213')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8213', N'JiJo V', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Vaigunda Rajan', N'9345985396', N'jijoj2849@gmail.com', N'2022-07-26', N'2003-09-14', N'OE', N'2022-07-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'JiJo V', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Vaigunda Rajan', [fatherName]),
        [mobile] = ISNULL(N'9345985396', [mobile]),
        [email] = ISNULL(N'jijoj2849@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-07-26', [joiningDate]),
        [dob] = ISNULL(N'2003-09-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-07-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8213';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8221')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8221', N'Balaji S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Selvam', N'9360076683', N'balaji18selvam@gmail.com', N'2022-08-09', N'2001-12-29', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Balaji S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Selvam', [fatherName]),
        [mobile] = ISNULL(N'9360076683', [mobile]),
        [email] = ISNULL(N'balaji18selvam@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2001-12-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8221';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8223')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8223', N'Elumalai G', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Govindharaji', N'7339579848', N'20211785ge@gmail.com', N'2022-08-09', N'2002-10-05', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Elumalai G', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Govindharaji', [fatherName]),
        [mobile] = ISNULL(N'7339579848', [mobile]),
        [email] = ISNULL(N'20211785ge@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2002-10-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8223';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8225')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8225', N'Kannan N', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Nagarajan N', N'8825761755', N'20mle13n.kannan@gmail.com', N'2022-08-09', N'2003-07-06', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kannan N', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Nagarajan N', [fatherName]),
        [mobile] = ISNULL(N'8825761755', [mobile]),
        [email] = ISNULL(N'20mle13n.kannan@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2003-07-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8225';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8226')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8226', N'Madhankumar T', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Thangavelu', N'9345294229', N'madhanmk770817@gmail.com', N'2022-08-09', N'2002-07-13', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Madhankumar T', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Thangavelu', [fatherName]),
        [mobile] = ISNULL(N'9345294229', [mobile]),
        [email] = ISNULL(N'madhanmk770817@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2002-07-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8226';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8230')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8230', N'NaveenKumar R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Raja', N'6374253525', N'20211851kpc@gmail.com', N'2022-08-09', N'2002-05-15', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'NaveenKumar R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Raja', [fatherName]),
        [mobile] = ISNULL(N'6374253525', [mobile]),
        [email] = ISNULL(N'20211851kpc@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2002-05-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8230';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8234')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8234', N'Stephen Felix Raj S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Swaminathan', N'6379973272', N'stephenfelixraj637@gmail.com', N'2022-08-09', N'2003-11-30', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Stephen Felix Raj S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Swaminathan', [fatherName]),
        [mobile] = ISNULL(N'6379973272', [mobile]),
        [email] = ISNULL(N'stephenfelixraj637@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2003-11-30', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8234';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8222')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8222', N'Balamurugan P', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ponnaiyan', N'87782 40862', N'balamarivalavumurugan@gmail.com', N'2022-08-09', N'2002-12-25', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Balamurugan P', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ponnaiyan', [fatherName]),
        [mobile] = ISNULL(N'87782 40862', [mobile]),
        [email] = ISNULL(N'balamarivalavumurugan@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2002-12-25', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8222';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8227')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8227', N'Manikandan P', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ponnuvel', N'9360702687', N'manimd9965@gmail.com', N'2022-08-09', N'2002-02-01', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Manikandan P', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ponnuvel', [fatherName]),
        [mobile] = ISNULL(N'9360702687', [mobile]),
        [email] = ISNULL(N'manimd9965@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2002-02-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8227';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8235')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8235', N'vasanth K', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kailasam', N'6369832804', N'k.vasanthkailashm@gmail.com', N'2022-08-09', N'2001-12-18', N'OE', N'2022-08-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'vasanth K', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kailasam', [fatherName]),
        [mobile] = ISNULL(N'6369832804', [mobile]),
        [email] = ISNULL(N'k.vasanthkailashm@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-09', [joiningDate]),
        [dob] = ISNULL(N'2001-12-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8235';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8238')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8238', N'Kirubakaran K', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Krishnan G', N'9597060021', N'kirubakl2004@gmail.com', N'2022-08-29', N'2004-05-14', N'OE', N'2022-08-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kirubakaran K', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Krishnan G', [fatherName]),
        [mobile] = ISNULL(N'9597060021', [mobile]),
        [email] = ISNULL(N'kirubakl2004@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-29', [joiningDate]),
        [dob] = ISNULL(N'2004-05-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8238';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8241')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8241', N'Nanthakumar M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Murukesan K', N'8637414418', N'nanthakumarnanthakumar428@gmail.com', N'2022-08-29', N'2004-02-06', N'OE', N'2022-08-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nanthakumar M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Murukesan K', [fatherName]),
        [mobile] = ISNULL(N'8637414418', [mobile]),
        [email] = ISNULL(N'nanthakumarnanthakumar428@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-29', [joiningDate]),
        [dob] = ISNULL(N'2004-02-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8241';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8242')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8242', N'Sivan G', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Govindaraj G', N'6369895860', N'sivasivaindia16@gmail.com', N'2022-08-29', N'2002-09-14', N'OE', N'2022-08-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sivan G', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Govindaraj G', [fatherName]),
        [mobile] = ISNULL(N'6369895860', [mobile]),
        [email] = ISNULL(N'sivasivaindia16@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-29', [joiningDate]),
        [dob] = ISNULL(N'2002-09-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8242';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8243')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8243', N'Srinath K', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kumar K', N'8056541770', N'srinathsri410@gmail.com', N'2022-08-29', N'2004-05-06', N'OE', N'2022-08-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Srinath K', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kumar K', [fatherName]),
        [mobile] = ISNULL(N'8056541770', [mobile]),
        [email] = ISNULL(N'srinathsri410@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-08-29', [joiningDate]),
        [dob] = ISNULL(N'2004-05-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-08-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8243';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8247')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8247', N'Surajit Kumar Bag', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Arup Kumar Bag', N'9679975618', N'mrsurajitbag@gmail.com', N'2022-10-01', N'2001-06-29', N'OE', N'2022-10-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Surajit Kumar Bag', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Arup Kumar Bag', [fatherName]),
        [mobile] = ISNULL(N'9679975618', [mobile]),
        [email] = ISNULL(N'mrsurajitbag@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-10-01', [joiningDate]),
        [dob] = ISNULL(N'2001-06-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-10-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8247';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8251')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8251', N'Anandharaj A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Anbarasan', N'9842780393', N'anantanantharaj793@gmail.com', N'2022-11-08', N'2003-09-04', N'OE', N'2022-11-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anandharaj A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Anbarasan', [fatherName]),
        [mobile] = ISNULL(N'9842780393', [mobile]),
        [email] = ISNULL(N'anantanantharaj793@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-08', [joiningDate]),
        [dob] = ISNULL(N'2003-09-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8251';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8252')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8252', N'Arunkumar R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rajamariappan', N'8300403415', N'arunkumar298r@gmail.com', N'2022-11-08', N'2001-01-11', N'OE', N'2022-11-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arunkumar R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rajamariappan', [fatherName]),
        [mobile] = ISNULL(N'8300403415', [mobile]),
        [email] = ISNULL(N'arunkumar298r@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-11-08', [joiningDate]),
        [dob] = ISNULL(N'2001-01-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-11-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8252';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8255')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8255', N'Kamal Lochan Aich', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Goura Gopal Aich', N'8114797526', N'kamallochanaich5540@gmail.com', N'2022-12-13', N'2002-02-02', N'OE', N'2022-12-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kamal Lochan Aich', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Goura Gopal Aich', [fatherName]),
        [mobile] = ISNULL(N'8114797526', [mobile]),
        [email] = ISNULL(N'kamallochanaich5540@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2022-12-13', [joiningDate]),
        [dob] = ISNULL(N'2002-02-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2022-12-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8255';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1092')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1092', N'Sridhar K', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitChennai, @deptChennai,
        N'Kannan', N'7825837057', N'sridhar_kgk@yahoo.com', N'2023-01-18', N'1981-03-08', N'Manager', N'2023-01-18', N'7'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sridhar K', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kannan', [fatherName]),
        [mobile] = ISNULL(N'7825837057', [mobile]),
        [email] = ISNULL(N'sridhar_kgk@yahoo.com', [email]),
        [joiningDate] = ISNULL(N'2023-01-18', [joiningDate]),
        [dob] = ISNULL(N'1981-03-08', [dob]),
        [designation] = ISNULL(N'Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-01-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'7', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1092';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8259')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8259', N'Chakkaravarthi Devendiran', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Devendiran', N'8807991170', N'chakkaravarthi.dme148@gmail.com', N'2023-05-26', N'2003-08-14', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chakkaravarthi Devendiran', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Devendiran', [fatherName]),
        [mobile] = ISNULL(N'8807991170', [mobile]),
        [email] = ISNULL(N'chakkaravarthi.dme148@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2003-08-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8259';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8260')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8260', N'Deepak Senthil Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Senthil Kumar', N'8870297171', N'deepaksenthilkumar0@gmail.com', N'2023-05-26', N'2004-04-01', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Deepak Senthil Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Senthil Kumar', [fatherName]),
        [mobile] = ISNULL(N'8870297171', [mobile]),
        [email] = ISNULL(N'deepaksenthilkumar0@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2004-04-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8260';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8262')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8262', N'Gokulakrishnan K', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kuppusamy', N'9585141827', N'ggokulakrishnan737@gmail.com', N'2023-05-26', N'2003-06-19', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gokulakrishnan K', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kuppusamy', [fatherName]),
        [mobile] = ISNULL(N'9585141827', [mobile]),
        [email] = ISNULL(N'ggokulakrishnan737@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2003-06-19', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8262';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8263')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8263', N'Gowtham M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Murugan T', N'9080054667', N'mgowthamkumar55@gmail.com', N'2023-05-26', N'2004-04-08', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gowtham M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Murugan T', [fatherName]),
        [mobile] = ISNULL(N'9080054667', [mobile]),
        [email] = ISNULL(N'mgowthamkumar55@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2004-04-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8263';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8268')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8268', N'Sivakumar Kamaraj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kamaraj S', N'9344498153', N'sivak047499@gmail.com', N'2023-05-26', N'2004-06-23', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sivakumar Kamaraj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kamaraj S', [fatherName]),
        [mobile] = ISNULL(N'9344498153', [mobile]),
        [email] = ISNULL(N'sivak047499@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2004-06-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8268';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8269')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8269', N'Swayanprakash Khuntia', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sashanka Sekhar  Khuntia', N'8917564582', N'spkhuntia20@gmail.com', N'2023-05-26', N'2004-01-31', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Swayanprakash Khuntia', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sashanka Sekhar  Khuntia', [fatherName]),
        [mobile] = ISNULL(N'8917564582', [mobile]),
        [email] = ISNULL(N'spkhuntia20@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2004-01-31', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8269';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8280')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8280', N'Seema Mahato', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dinu mahato', N'8102853527', N'seemamahato4444@gmail.com', N'2023-06-26', N'2003-12-30', N'OE', N'2023-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Seema Mahato', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dinu mahato', [fatherName]),
        [mobile] = ISNULL(N'8102853527', [mobile]),
        [email] = ISNULL(N'seemamahato4444@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-26', [joiningDate]),
        [dob] = ISNULL(N'2003-12-30', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8280';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8281')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8281', N'Vinitha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sudama Vishwakarma', N'7480919739', N'vinita22035@gmail.com', N'2023-06-26', N'2005-03-12', N'OE', N'2023-06-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vinitha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sudama Vishwakarma', [fatherName]),
        [mobile] = ISNULL(N'7480919739', [mobile]),
        [email] = ISNULL(N'vinita22035@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-06-26', [joiningDate]),
        [dob] = ISNULL(N'2005-03-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-06-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8281';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8282')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8282', N'Gudiya Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Jageshwar mahto', N'9771541659', N'anamikamahto9@gmail.com', N'2023-07-04', N'2005-07-04', N'OE', N'2023-07-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gudiya Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Jageshwar mahto', [fatherName]),
        [mobile] = ISNULL(N'9771541659', [mobile]),
        [email] = ISNULL(N'anamikamahto9@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-07-04', [joiningDate]),
        [dob] = ISNULL(N'2005-07-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-07-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8282';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8283')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8283', N'Laxmi Kisku', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dubraj Kisku', N'6200703258', N'laxmikisku29@gmail.com', N'2023-07-22', N'2003-09-06', N'OE', N'2023-07-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Laxmi Kisku', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dubraj Kisku', [fatherName]),
        [mobile] = ISNULL(N'6200703258', [mobile]),
        [email] = ISNULL(N'laxmikisku29@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-07-22', [joiningDate]),
        [dob] = ISNULL(N'2003-09-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-07-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8283';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8284')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8284', N'Shruti Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Arun kumar', N'9341216057', N'sk2587182@gmail.com', N'2023-07-22', N'2004-01-13', N'OE', N'2023-07-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shruti Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Arun kumar', [fatherName]),
        [mobile] = ISNULL(N'9341216057', [mobile]),
        [email] = ISNULL(N'sk2587182@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-07-22', [joiningDate]),
        [dob] = ISNULL(N'2004-01-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-07-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8284';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8286')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8286', N'Neha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sunil Kumar', N'6207828104', N'nehak78813@gmail.com', N'2023-08-14', N'2002-06-16', N'OE', N'2023-08-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Neha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sunil Kumar', [fatherName]),
        [mobile] = ISNULL(N'6207828104', [mobile]),
        [email] = ISNULL(N'nehak78813@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-08-14', [joiningDate]),
        [dob] = ISNULL(N'2002-06-16', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-08-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8286';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8293')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8293', N'Inban T', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Thillaiyappan', N'7402020207', N'inbanthillai@gmail.com', N'2023-09-01', N'2004-11-14', N'OE', N'2023-09-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Inban T', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Thillaiyappan', [fatherName]),
        [mobile] = ISNULL(N'7402020207', [mobile]),
        [email] = ISNULL(N'inbanthillai@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-09-01', [joiningDate]),
        [dob] = ISNULL(N'2004-11-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8293';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1098')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1098', N'Kumaravel Ranganathan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rSGL, @unitChennai, @deptChennai,
        N'T Ranganathan', N'9840427733', N'kumar2mech89@gmail.com', N'2023-10-04', N'1989-04-11', N'Assistant Manager', N'2023-10-04', N'5'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kumaravel Ranganathan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rSGL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'T Ranganathan', [fatherName]),
        [mobile] = ISNULL(N'9840427733', [mobile]),
        [email] = ISNULL(N'kumar2mech89@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-04', [joiningDate]),
        [dob] = ISNULL(N'1989-04-11', [dob]),
        [designation] = ISNULL(N'Assistant Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'5', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1098';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8300')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8300', N'Sowmya Ranjan Sethi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rinku Sethi', N'7205159687', N'somyasethi5658@gmail.com', N'2023-10-09', N'2005-03-07', N'OE', N'2023-10-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sowmya Ranjan Sethi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rinku Sethi', [fatherName]),
        [mobile] = ISNULL(N'7205159687', [mobile]),
        [email] = ISNULL(N'somyasethi5658@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-09', [joiningDate]),
        [dob] = ISNULL(N'2005-03-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8300';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8302')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8302', N'Subham Mandal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rabindra mandal', N'7894160191', N'subhanmandal951@gmail.com', N'2023-10-09', N'2002-12-29', N'OE', N'2023-10-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Subham Mandal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rabindra mandal', [fatherName]),
        [mobile] = ISNULL(N'7894160191', [mobile]),
        [email] = ISNULL(N'subhanmandal951@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-09', [joiningDate]),
        [dob] = ISNULL(N'2002-12-29', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8302';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8304')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8304', N'Shiba tarai', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Buddhadev Tarai', N'8984389336', N'shibatarai62@gmail.com', N'2023-10-09', N'2004-10-23', N'OE', N'2023-10-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shiba tarai', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Buddhadev Tarai', [fatherName]),
        [mobile] = ISNULL(N'8984389336', [mobile]),
        [email] = ISNULL(N'shibatarai62@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-09', [joiningDate]),
        [dob] = ISNULL(N'2004-10-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8304';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8307')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8307', N'Abhay Marndi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Chandra Mohan Marndi', N'8895395337', N'abhaymarndi86@gmail.com', N'2023-10-09', N'2005-03-11', N'OE', N'2023-10-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhay Marndi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Chandra Mohan Marndi', [fatherName]),
        [mobile] = ISNULL(N'8895395337', [mobile]),
        [email] = ISNULL(N'abhaymarndi86@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-09', [joiningDate]),
        [dob] = ISNULL(N'2005-03-11', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8307';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8299')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8299', N'Aditya Sahu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Udhayanath Sahu', N'6370733606', N'adityasahu6370733606@gmail.com', N'2023-10-09', N'2002-06-15', N'OE', N'2023-10-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aditya Sahu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Udhayanath Sahu', [fatherName]),
        [mobile] = ISNULL(N'6370733606', [mobile]),
        [email] = ISNULL(N'adityasahu6370733606@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-10-09', [joiningDate]),
        [dob] = ISNULL(N'2002-06-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-10-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8299';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8309')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8309', N'Raja Pradhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Debaraj Pradhan', N'9265397104', N'radhapradhan550@gmail.com', N'2023-12-05', N'2004-11-08', N'OE', N'2023-12-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raja Pradhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Debaraj Pradhan', [fatherName]),
        [mobile] = ISNULL(N'9265397104', [mobile]),
        [email] = ISNULL(N'radhapradhan550@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-05', [joiningDate]),
        [dob] = ISNULL(N'2004-11-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8309';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8317')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8317', N'Sujit Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Manohar Prasad Verma', N'8651039012', N'sujitkumargrd07@gmail.com', N'2023-12-15', N'2004-05-04', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sujit Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Manohar Prasad Verma', [fatherName]),
        [mobile] = ISNULL(N'8651039012', [mobile]),
        [email] = ISNULL(N'sujitkumargrd07@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2004-05-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8317';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8319')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8319', N'Aniket Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pankaj Roy', N'7739099534', N'aniketrajjokia@gmail.com', N'2023-12-15', N'2003-03-19', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aniket Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pankaj Roy', [fatherName]),
        [mobile] = ISNULL(N'7739099534', [mobile]),
        [email] = ISNULL(N'aniketrajjokia@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2003-03-19', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8319';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8321')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8321', N'Suman Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Samdarshi Ray', N'8877045534', N'sumankumarrana5@gmail.com', N'2023-12-15', N'2002-12-01', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suman Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Samdarshi Ray', [fatherName]),
        [mobile] = ISNULL(N'8877045534', [mobile]),
        [email] = ISNULL(N'sumankumarrana5@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2002-12-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8321';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8324')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8324', N'Ashish Bhagat', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bishnu Bhagat', N'7480985084', N'ashishbhagat4362@gmail.com', N'2023-12-15', N'2004-03-03', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ashish Bhagat', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bishnu Bhagat', [fatherName]),
        [mobile] = ISNULL(N'7480985084', [mobile]),
        [email] = ISNULL(N'ashishbhagat4362@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2004-03-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8324';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8325')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8325', N'Madhu Priya', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Nagendra Sharma', N'9031691935', N'madhutoall@gmail.com', N'2023-12-15', N'2004-10-12', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Madhu Priya', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Nagendra Sharma', [fatherName]),
        [mobile] = ISNULL(N'9031691935', [mobile]),
        [email] = ISNULL(N'madhutoall@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2004-10-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8325';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8326')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8326', N'Biru Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Nagendra Ray', N'9570591457', N'birukumar04052004@gmail.com', N'2023-12-15', N'2004-05-04', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Biru Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Nagendra Ray', [fatherName]),
        [mobile] = ISNULL(N'9570591457', [mobile]),
        [email] = ISNULL(N'birukumar04052004@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2004-05-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8326';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8327')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8327', N'Ranjan Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dinesh Kumar Singh', N'8789523067', N'ranjanyadavbxr180@gmail.com', N'2023-12-15', N'2003-01-02', N'OE', N'2023-12-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ranjan Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dinesh Kumar Singh', [fatherName]),
        [mobile] = ISNULL(N'8789523067', [mobile]),
        [email] = ISNULL(N'ranjanyadavbxr180@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-12-15', [joiningDate]),
        [dob] = ISNULL(N'2003-01-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-12-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8327';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8329')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8329', N'Soni Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Jay Ram Choudhary', N'9934730148', N'soni.kumari9934730148@gmail.com', N'2024-01-02', N'2002-11-14', N'OE', N'2024-01-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Soni Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Jay Ram Choudhary', [fatherName]),
        [mobile] = ISNULL(N'9934730148', [mobile]),
        [email] = ISNULL(N'soni.kumari9934730148@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-01-02', [joiningDate]),
        [dob] = ISNULL(N'2002-11-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-01-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8329';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8331')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8331', N'Santosh Kumar Nayak', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bharat Chandra Nayak', N'6353388491', N'sn936377@gmail.com', N'2024-03-08', N'2002-08-02', N'OE', N'2024-03-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Santosh Kumar Nayak', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bharat Chandra Nayak', [fatherName]),
        [mobile] = ISNULL(N'6353388491', [mobile]),
        [email] = ISNULL(N'sn936377@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-03-08', [joiningDate]),
        [dob] = ISNULL(N'2002-08-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-03-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8331';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8332')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8332', N'Keerthana V', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Venkatraj V', N'9087113450', N'keerthana3450@gmail.com', N'2024-05-08', N'2004-05-21', N'OE', N'2024-05-08', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Keerthana V', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Venkatraj V', [fatherName]),
        [mobile] = ISNULL(N'9087113450', [mobile]),
        [email] = ISNULL(N'keerthana3450@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-08', [joiningDate]),
        [dob] = ISNULL(N'2004-05-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-08', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8332';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8334')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8334', N'Aaron Raja David P', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Peter', N'7339092240', N'01aaronraja@gmail.com', N'2024-05-30', N'2004-11-01', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aaron Raja David P', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Peter', [fatherName]),
        [mobile] = ISNULL(N'7339092240', [mobile]),
        [email] = ISNULL(N'01aaronraja@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2004-11-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8334';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8335')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8335', N'Akash D', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Davidson', N'6369159401', N'akashdavia@gmail.com', N'2024-05-30', N'2003-04-12', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Akash D', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Davidson', [fatherName]),
        [mobile] = ISNULL(N'6369159401', [mobile]),
        [email] = ISNULL(N'akashdavia@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2003-04-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8335';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8336')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8336', N'Antony Jesudass A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Antony Jesubalan D', N'7339638420', N'antonyjesudass5612@gmail.com', N'2024-05-30', N'2004-05-28', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Antony Jesudass A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Antony Jesubalan D', [fatherName]),
        [mobile] = ISNULL(N'7339638420', [mobile]),
        [email] = ISNULL(N'antonyjesudass5612@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2004-05-28', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8336';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8337')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8337', N'Arun K S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kamalasanan T', N'7708136125', N'arunksz246810@gmail.com', N'2024-05-30', N'2005-06-21', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Arun K S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kamalasanan T', [fatherName]),
        [mobile] = ISNULL(N'7708136125', [mobile]),
        [email] = ISNULL(N'arunksz246810@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-06-21', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8337';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8338')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8338', N'Babula Sethi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dillip Sethi', N'9106555792', N'sethibabul725@gmail.com', N'2024-05-30', N'2003-03-16', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Babula Sethi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dillip Sethi', [fatherName]),
        [mobile] = ISNULL(N'9106555792', [mobile]),
        [email] = ISNULL(N'sethibabul725@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2003-03-16', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8338';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8340')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8340', N'Bishnupada Dhal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Shiba Charana Dhal', N'7735565066', N'bishnupadadhal328@gmail.com', N'2024-05-30', N'2003-04-15', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bishnupada Dhal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Shiba Charana Dhal', [fatherName]),
        [mobile] = ISNULL(N'7735565066', [mobile]),
        [email] = ISNULL(N'bishnupadadhal328@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2003-04-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8340';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8341')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8341', N'Chandrumon M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Manuvel', N'8778939650', N'chandrumonmanuvel@gmail.com', N'2024-05-30', N'2005-08-04', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandrumon M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Manuvel', [fatherName]),
        [mobile] = ISNULL(N'8778939650', [mobile]),
        [email] = ISNULL(N'chandrumonmanuvel@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-08-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8341';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8342')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8342', N'Dashin S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Selvaraj', N'8148033859', N'dashindashin3@gmail.com', N'2024-05-30', N'2003-11-09', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dashin S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Selvaraj', [fatherName]),
        [mobile] = ISNULL(N'8148033859', [mobile]),
        [email] = ISNULL(N'dashindashin3@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2003-11-09', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8342';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8343')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8343', N'Dhaneesh M A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Mani', N'9363470232', N'dhaneeshdhanu434@gmail.com', N'2024-05-30', N'2005-03-04', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dhaneesh M A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mani', [fatherName]),
        [mobile] = ISNULL(N'9363470232', [mobile]),
        [email] = ISNULL(N'dhaneeshdhanu434@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-03-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8343';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8346')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8346', N'John Vetamuthu V', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Veera Singham', N'9342241688', N'johnveer71180@gmail.com', N'2024-05-30', N'2006-01-18', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'John Vetamuthu V', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Veera Singham', [fatherName]),
        [mobile] = ISNULL(N'9342241688', [mobile]),
        [email] = ISNULL(N'johnveer71180@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2006-01-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8346';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8348')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8348', N'Kisan Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Jagabandhu Behera', N'7847985499', N'kisanbehera579@gmail.com', N'2024-05-30', N'2006-04-07', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Kisan Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Jagabandhu Behera', [fatherName]),
        [mobile] = ISNULL(N'7847985499', [mobile]),
        [email] = ISNULL(N'kisanbehera579@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2006-04-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8348';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8349')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8349', N'Laba Pradhan', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Balaram Pradhan', N'9040887635', N'pradanlaba38@gmail.com', N'2024-05-30', N'2005-02-01', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Laba Pradhan', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Balaram Pradhan', [fatherName]),
        [mobile] = ISNULL(N'9040887635', [mobile]),
        [email] = ISNULL(N'pradanlaba38@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-02-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8349';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8350')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8350', N'Lakshmanan V', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Veerabahu L', N'8778649625', N'lakshmanav2005@gmail.com', N'2024-05-30', N'2005-07-26', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lakshmanan V', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Veerabahu L', [fatherName]),
        [mobile] = ISNULL(N'8778649625', [mobile]),
        [email] = ISNULL(N'lakshmanav2005@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-07-26', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8350';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8352')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8352', N'Muthazhagan S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Selvaraj', N'6382373761', N'muthazhaganmuthalagan@gmail.com', N'2024-05-30', N'2004-03-30', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muthazhagan S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Selvaraj', [fatherName]),
        [mobile] = ISNULL(N'6382373761', [mobile]),
        [email] = ISNULL(N'muthazhaganmuthalagan@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2004-03-30', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8352';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8353')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8353', N'Prathap Kochumany', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kochumany', N'9345718995', N'pp5387345@gmail.com', N'2024-05-30', N'2004-06-18', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Prathap Kochumany', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kochumany', [fatherName]),
        [mobile] = ISNULL(N'9345718995', [mobile]),
        [email] = ISNULL(N'pp5387345@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2004-06-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8353';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8354')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8354', N'Rakesh Sethy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bauribandhu Sethy', N'9692164024', N'rakeshsethy6050@gmail.com', N'2024-05-30', N'2005-01-10', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rakesh Sethy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bauribandhu Sethy', [fatherName]),
        [mobile] = ISNULL(N'9692164024', [mobile]),
        [email] = ISNULL(N'rakeshsethy6050@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-01-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8354';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8355')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8355', N'Siva Sundar B', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Balakrishnan S', N'8072849106', N'sundarsiva37533@gmail.com', N'2024-05-30', N'2004-03-15', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Siva Sundar B', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Balakrishnan S', [fatherName]),
        [mobile] = ISNULL(N'8072849106', [mobile]),
        [email] = ISNULL(N'sundarsiva37533@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2004-03-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8355';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8356')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8356', N'Sujith Raja', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Raja', N'7871627816', N'sujithsujith12134@gmail.com', N'2024-05-30', N'2005-04-27', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sujith Raja', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Raja', [fatherName]),
        [mobile] = ISNULL(N'7871627816', [mobile]),
        [email] = ISNULL(N'sujithsujith12134@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-04-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8356';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8357')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8357', N'Vengadesh A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ayyappan', N'6379011757', N'vengadeshas143@gmail.com', N'2024-05-30', N'2005-03-14', N'OE', N'2024-05-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Vengadesh A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ayyappan', [fatherName]),
        [mobile] = ISNULL(N'6379011757', [mobile]),
        [email] = ISNULL(N'vengadeshas143@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-05-30', [joiningDate]),
        [dob] = ISNULL(N'2005-03-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-05-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8357';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8362')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8362', N'Rajkumar Das', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bisikeshan Das', N'9040194976', N'rajkumar9092450@gmail.com', N'2024-06-05', N'2005-07-10', N'OE', N'2024-06-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rajkumar Das', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bisikeshan Das', [fatherName]),
        [mobile] = ISNULL(N'9040194976', [mobile]),
        [email] = ISNULL(N'rajkumar9092450@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-05', [joiningDate]),
        [dob] = ISNULL(N'2005-07-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8362';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8363')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8363', N'Rukmani Priyadarshini Sethi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pramod Kumar Sethi', N'7749802857', N'rupalipriyadarshini91@gmail.com', N'2024-06-05', N'2003-11-23', N'OE', N'2024-06-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rukmani Priyadarshini Sethi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pramod Kumar Sethi', [fatherName]),
        [mobile] = ISNULL(N'7749802857', [mobile]),
        [email] = ISNULL(N'rupalipriyadarshini91@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-05', [joiningDate]),
        [dob] = ISNULL(N'2003-11-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8363';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8372')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8372', N'Sowmiya.R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ramasamy', N'8754863991', N'smiya311@gmail.com', N'2024-06-14', N'2003-10-08', N'OE', N'2024-06-14', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sowmiya.R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ramasamy', [fatherName]),
        [mobile] = ISNULL(N'8754863991', [mobile]),
        [email] = ISNULL(N'smiya311@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-06-14', [joiningDate]),
        [dob] = ISNULL(N'2003-10-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-06-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8372';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8388')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8388', N'Dushmanta Tandi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Basudeb Tandi', N'7854957670', N'dushmantatandi751@gmail.com', N'2024-07-11', N'2005-08-07', N'OE', N'2024-07-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dushmanta Tandi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Basudeb Tandi', [fatherName]),
        [mobile] = ISNULL(N'7854957670', [mobile]),
        [email] = ISNULL(N'dushmantatandi751@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-11', [joiningDate]),
        [dob] = ISNULL(N'2005-08-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8388';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8389')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8389', N'Jiunarayan Dutta', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Anil Dutta', N'7873042155', N'jiunarayandutta9@gmail.com', N'2024-07-11', N'2003-09-28', N'OE', N'2024-07-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jiunarayan Dutta', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Anil Dutta', [fatherName]),
        [mobile] = ISNULL(N'7873042155', [mobile]),
        [email] = ISNULL(N'jiunarayandutta9@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-11', [joiningDate]),
        [dob] = ISNULL(N'2003-09-28', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8389';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8393')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8393', N'Pravat Jena', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rabindra Jena', N'7849063936', N'rabindraj995@gmail.com', N'2024-07-11', N'2006-03-15', N'OE', N'2024-07-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pravat Jena', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rabindra Jena', [fatherName]),
        [mobile] = ISNULL(N'7849063936', [mobile]),
        [email] = ISNULL(N'rabindraj995@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-11', [joiningDate]),
        [dob] = ISNULL(N'2006-03-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8393';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8394')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8394', N'Ramesh Majhi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Maheswar Majhi', N'9692219481', N'rameshmajhi9692@gmail.com', N'2024-07-11', N'2005-07-20', N'OE', N'2024-07-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ramesh Majhi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Maheswar Majhi', [fatherName]),
        [mobile] = ISNULL(N'9692219481', [mobile]),
        [email] = ISNULL(N'rameshmajhi9692@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-11', [joiningDate]),
        [dob] = ISNULL(N'2005-07-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8394';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8384')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8384', N'Ajit Dhal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Gadadhar Dhal', N'9382609714', N'ajitdhal90@gmail.com', N'2024-07-11', N'2004-03-13', N'OE', N'2024-07-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ajit Dhal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Gadadhar Dhal', [fatherName]),
        [mobile] = ISNULL(N'9382609714', [mobile]),
        [email] = ISNULL(N'ajitdhal90@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-11', [joiningDate]),
        [dob] = ISNULL(N'2004-03-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8384';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8396')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8396', N'Abinash Barik', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Harihar Barik', N'9827213952', N'barikabinash182@gmail.com', N'2024-07-26', N'2006-09-03', N'OE', N'2024-07-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abinash Barik', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Harihar Barik', [fatherName]),
        [mobile] = ISNULL(N'9827213952', [mobile]),
        [email] = ISNULL(N'barikabinash182@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-26', [joiningDate]),
        [dob] = ISNULL(N'2006-09-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8396';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8399')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8399', N'Shubhrajyoti Swain', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ramakanta swain', N'6371596053', N'swains1001@gamil.com', N'2024-07-26', N'2003-08-03', N'OE', N'2024-07-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubhrajyoti Swain', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ramakanta swain', [fatherName]),
        [mobile] = ISNULL(N'6371596053', [mobile]),
        [email] = ISNULL(N'swains1001@gamil.com', [email]),
        [joiningDate] = ISNULL(N'2024-07-26', [joiningDate]),
        [dob] = ISNULL(N'2003-08-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-07-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8399';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8400')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8400', N'Afroz Quraishi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sultan Chik', N'7439086401', N'afrozquraishi2003@gmail.com', N'2024-08-02', N'2003-09-02', N'OE', N'2024-08-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Afroz Quraishi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sultan Chik', [fatherName]),
        [mobile] = ISNULL(N'7439086401', [mobile]),
        [email] = ISNULL(N'afrozquraishi2003@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-02', [joiningDate]),
        [dob] = ISNULL(N'2003-09-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8400';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8409')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8409', N'Sivaperumal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Saravanaperumal', N'7218767721', N'sssivaperumal97@gmail.com', N'2024-08-14', N'1997-07-31', N'TL', N'2024-08-14', N'3'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sivaperumal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Saravanaperumal', [fatherName]),
        [mobile] = ISNULL(N'7218767721', [mobile]),
        [email] = ISNULL(N'sssivaperumal97@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-14', [joiningDate]),
        [dob] = ISNULL(N'1997-07-31', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-14', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'3', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8409';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8410')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8410', N'Sukiran Patra', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sunirmal Patra', N'7501189971', N'sukiranpatra2@gmail.com', N'2024-08-26', N'2004-12-22', N'OE', N'2024-08-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sukiran Patra', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sunirmal Patra', [fatherName]),
        [mobile] = ISNULL(N'7501189971', [mobile]),
        [email] = ISNULL(N'sukiranpatra2@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-08-26', [joiningDate]),
        [dob] = ISNULL(N'2004-12-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-08-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8410';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8411')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8411', N'Gokulakrishnan Sankar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Sankar', N'6374718500', N'sankargokul20@gmail.com', N'2024-09-11', N'2000-06-20', N'TL', N'2024-09-11', N'3'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gokulakrishnan Sankar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sankar', [fatherName]),
        [mobile] = ISNULL(N'6374718500', [mobile]),
        [email] = ISNULL(N'sankargokul20@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-09-11', [joiningDate]),
        [dob] = ISNULL(N'2000-06-20', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'3', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8411';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8412')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8412', N'R Vignesh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Raju Kumar', N'8220193703', N'vigneshkeerthika2823@gmail.com', N'2024-09-11', N'1997-10-23', N'TL', N'2024-09-11', N'3'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'R Vignesh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Raju Kumar', [fatherName]),
        [mobile] = ISNULL(N'8220193703', [mobile]),
        [email] = ISNULL(N'vigneshkeerthika2823@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-09-11', [joiningDate]),
        [dob] = ISNULL(N'1997-10-23', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'3', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8412';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8413')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8413', N'Shubhadip Jana', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Gourhari Jana', N'9933589299', N'shubhadipjo@gmail.com', N'2024-09-11', N'1998-07-10', N'TL', N'2024-09-11', N'3'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shubhadip Jana', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Gourhari Jana', [fatherName]),
        [mobile] = ISNULL(N'9933589299', [mobile]),
        [email] = ISNULL(N'shubhadipjo@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-09-11', [joiningDate]),
        [dob] = ISNULL(N'1998-07-10', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-09-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'3', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8413';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8416')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8416', N'Narashia Muli', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Nilanchala Muli', N'7788809445', N'nikeshmuli@gmail.com', N'2024-11-03', N'2004-01-10', N'OE', N'2024-11-03', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Narashia Muli', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Nilanchala Muli', [fatherName]),
        [mobile] = ISNULL(N'7788809445', [mobile]),
        [email] = ISNULL(N'nikeshmuli@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2024-11-03', [joiningDate]),
        [dob] = ISNULL(N'2004-01-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2024-11-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8416';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8421')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8421', N'Anshul Choudhary', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Lucky Ram', N'8091752241', N'anshulch570@gmail.com', N'2025-02-26', N'2004-08-15', N'OE', N'2025-02-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anshul Choudhary', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Lucky Ram', [fatherName]),
        [mobile] = ISNULL(N'8091752241', [mobile]),
        [email] = ISNULL(N'anshulch570@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-02-26', [joiningDate]),
        [dob] = ISNULL(N'2004-08-15', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-02-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8421';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8422')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8422', N'Sourav Sharma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Hare Ram', N'7876421107', N'pandit.sourav787@gmail.com', N'2025-02-26', N'2002-06-10', N'OE', N'2025-02-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sourav Sharma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Hare Ram', [fatherName]),
        [mobile] = ISNULL(N'7876421107', [mobile]),
        [email] = ISNULL(N'pandit.sourav787@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-02-26', [joiningDate]),
        [dob] = ISNULL(N'2002-06-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-02-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8422';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8424')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8424', N'Neha Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Naresh Yadav', N'9341032683', N'nehakumariyadav1428@gmail.com', N'2025-03-03', N'2005-06-06', N'OE', N'2025-03-03', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Neha Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Naresh Yadav', [fatherName]),
        [mobile] = ISNULL(N'9341032683', [mobile]),
        [email] = ISNULL(N'nehakumariyadav1428@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-03', [joiningDate]),
        [dob] = ISNULL(N'2005-06-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-03-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8424';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8425')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8425', N'SidhiShree', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bijendra Kumar Gupta', N'7481034069', N'siddhishree6200@gmail.com', N'2025-03-03', N'2006-03-20', N'OE', N'2025-03-03', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'SidhiShree', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bijendra Kumar Gupta', [fatherName]),
        [mobile] = ISNULL(N'7481034069', [mobile]),
        [email] = ISNULL(N'siddhishree6200@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-03-03', [joiningDate]),
        [dob] = ISNULL(N'2006-03-20', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-03-03', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8425';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1109')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1109', N'Mareeswaran T', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitChennai, @deptChennai,
        N'Thannasi', N'9080008839', N'mareeswaran14@gmail.com', N'2025-04-02', N'1989-04-01', N'Manager', N'2025-04-02', N'6'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mareeswaran T', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Thannasi', [fatherName]),
        [mobile] = ISNULL(N'9080008839', [mobile]),
        [email] = ISNULL(N'mareeswaran14@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-04-02', [joiningDate]),
        [dob] = ISNULL(N'1989-04-01', [dob]),
        [designation] = ISNULL(N'Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-04-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'6', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1109';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8434')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8434', N'Chinthakayala Prasad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Naganna Dora', N'8008827939', N'prasadchinthakayala97@gmail.com', N'2025-05-12', N'2004-09-18', N'OE', N'2025-05-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chinthakayala Prasad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Naganna Dora', [fatherName]),
        [mobile] = ISNULL(N'8008827939', [mobile]),
        [email] = ISNULL(N'prasadchinthakayala97@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-12', [joiningDate]),
        [dob] = ISNULL(N'2004-09-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8434';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8441')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8441', N'Morampudi Ashritha', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Morampudi Srinivasarao', N'7337246167', N'morampudiashritha@gmail.com', N'2025-05-26', N'2005-12-17', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Morampudi Ashritha', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Morampudi Srinivasarao', [fatherName]),
        [mobile] = ISNULL(N'7337246167', [mobile]),
        [email] = ISNULL(N'morampudiashritha@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2005-12-17', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8441';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8443')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8443', N'Pabbineedi Sai Vivek', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pabbineedi Sairam', N'7842422325', N'saivivekpabbineedi44@gmail.com', N'2025-05-26', N'2005-10-22', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pabbineedi Sai Vivek', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pabbineedi Sairam', [fatherName]),
        [mobile] = ISNULL(N'7842422325', [mobile]),
        [email] = ISNULL(N'saivivekpabbineedi44@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2005-10-22', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8443';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8444')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8444', N'Tankala Prameela', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Tankala Rambabu', N'9701397257', N'prameelatankala7@gmail.com', N'2025-05-26', N'2006-12-18', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tankala Prameela', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Tankala Rambabu', [fatherName]),
        [mobile] = ISNULL(N'9701397257', [mobile]),
        [email] = ISNULL(N'prameelatankala7@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2006-12-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8444';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8445')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8445', N'Palisetti Sravanthi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pallisetti Vasudevarao', N'9392969303', N'palisettisravanthi9@gmail.com', N'2025-05-26', N'2006-12-02', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Palisetti Sravanthi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pallisetti Vasudevarao', [fatherName]),
        [mobile] = ISNULL(N'9392969303', [mobile]),
        [email] = ISNULL(N'palisettisravanthi9@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2006-12-02', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8445';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8447')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8447', N'Raghumudra Vasanta Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Raghumudra Satyam', N'9652211201', N'raghumudravasavi@gmail.com', N'2025-05-26', N'2006-11-07', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Raghumudra Vasanta Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Raghumudra Satyam', [fatherName]),
        [mobile] = ISNULL(N'9652211201', [mobile]),
        [email] = ISNULL(N'raghumudravasavi@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2006-11-07', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8447';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8449')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8449', N'Potnuru Chinnammadu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Potnuru Srinuvasarao', N'8919872484', N'srinupotnuru21@gmail.com', N'2025-05-26', N'2006-12-01', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Potnuru Chinnammadu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Potnuru Srinuvasarao', [fatherName]),
        [mobile] = ISNULL(N'8919872484', [mobile]),
        [email] = ISNULL(N'srinupotnuru21@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2006-12-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8449';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8451')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8451', N'Jakkula Rohith', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Jukkula Suresh Babu', N'7207141790', N'jakkularohith4@gmail.com', N'2025-05-26', N'2007-05-14', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Jakkula Rohith', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Jukkula Suresh Babu', [fatherName]),
        [mobile] = ISNULL(N'7207141790', [mobile]),
        [email] = ISNULL(N'jakkularohith4@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2007-05-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8451';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8459')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8459', N'kundrapu Kanaka Jyothi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Kundrapu Srinu', N'8520973251', N'jyothikundrapu2006@gmail.com', N'2025-05-26', N'2005-01-19', N'OE', N'2025-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'kundrapu Kanaka Jyothi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Kundrapu Srinu', [fatherName]),
        [mobile] = ISNULL(N'8520973251', [mobile]),
        [email] = ISNULL(N'jyothikundrapu2006@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-05-26', [joiningDate]),
        [dob] = ISNULL(N'2005-01-19', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8459';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8461')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8461', N'Navas Muhammed P', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ashraf P', N'8075711713', N'asrafkkv847@gmail.com', N'2025-06-02', N'2005-01-14', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Navas Muhammed P', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ashraf P', [fatherName]),
        [mobile] = ISNULL(N'8075711713', [mobile]),
        [email] = ISNULL(N'asrafkkv847@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2005-01-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8461';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8462')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8462', N'Abhijith A R', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ramachandran', N'8590058784', N'abhijithar382@gmail.com', N'2025-06-02', N'2003-07-03', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhijith A R', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ramachandran', [fatherName]),
        [mobile] = ISNULL(N'8590058784', [mobile]),
        [email] = ISNULL(N'abhijithar382@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2003-07-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8462';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8463')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8463', N'Muhammed Mishab P', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Muhammedali', N'7593965708', N'clzmizhab@gmail.com', N'2025-06-02', N'2005-05-19', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muhammed Mishab P', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Muhammedali', [fatherName]),
        [mobile] = ISNULL(N'7593965708', [mobile]),
        [email] = ISNULL(N'clzmizhab@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2005-05-19', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8463';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8465')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8465', N'Gowtham C', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Chakkaravarthi', N'6369792267', N'gowtham512007c@gmail.com', N'2025-06-02', N'2007-01-05', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Gowtham C', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Chakkaravarthi', [fatherName]),
        [mobile] = ISNULL(N'6369792267', [mobile]),
        [email] = ISNULL(N'gowtham512007c@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2007-01-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8465';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8468')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8468', N'Isham Ahamed A', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Abdul Rahim', N'9043254176', N'ishamahamed14122006@gmail.com', N'2025-06-02', N'2006-12-14', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Isham Ahamed A', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Abdul Rahim', [fatherName]),
        [mobile] = ISNULL(N'9043254176', [mobile]),
        [email] = ISNULL(N'ishamahamed14122006@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2006-12-14', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8468';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8470')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8470', N'Pandiyaraj V', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Vadivelmurugan', N'8610546236', N'vpandiyaraj466@gmail.com', N'2025-06-02', N'2007-05-05', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pandiyaraj V', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Vadivelmurugan', [fatherName]),
        [mobile] = ISNULL(N'8610546236', [mobile]),
        [email] = ISNULL(N'vpandiyaraj466@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2007-05-05', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8470';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8472')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8472', N'Monishkumar D', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Duraisamy', N'6379955279', N'monishkumar2006da@gmail.com', N'2025-06-02', N'2006-12-13', N'OE', N'2025-06-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Monishkumar D', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Duraisamy', [fatherName]),
        [mobile] = ISNULL(N'6379955279', [mobile]),
        [email] = ISNULL(N'monishkumar2006da@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-02', [joiningDate]),
        [dob] = ISNULL(N'2006-12-13', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8472';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8487')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8487', N'Rajid Alam', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Alamgir mallik', N'8509503266', N'rajid.alam2002@gmail.com', N'2025-07-28', N'2005-01-08', N'OE', N'2025-07-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rajid Alam', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Alamgir mallik', [fatherName]),
        [mobile] = ISNULL(N'8509503266', [mobile]),
        [email] = ISNULL(N'rajid.alam2002@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-28', [joiningDate]),
        [dob] = ISNULL(N'2005-01-08', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8487';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8488')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8488', N'Egireddi Syam Durga Rao', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Adinarayan', N'7993442848', N'syams7940@gmail.com', N'2025-07-28', N'2004-01-01', N'OE', N'2025-07-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Egireddi Syam Durga Rao', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Adinarayan', [fatherName]),
        [mobile] = ISNULL(N'7993442848', [mobile]),
        [email] = ISNULL(N'syams7940@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-28', [joiningDate]),
        [dob] = ISNULL(N'2004-01-01', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8488';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8489')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8489', N'Sibaprasad Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Umesha chandra behera', N'8249503496', N'sibaprasadb097@gmail.com', N'2025-07-28', N'2006-09-12', N'OE', N'2025-07-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sibaprasad Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Umesha chandra behera', [fatherName]),
        [mobile] = ISNULL(N'8249503496', [mobile]),
        [email] = ISNULL(N'sibaprasadb097@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-28', [joiningDate]),
        [dob] = ISNULL(N'2006-09-12', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8489';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8491')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8491', N'Reaj Ahamed', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dajimuddin mia', N'7797272183', N'reajmondol6@gmail.com', N'2025-07-28', N'2004-05-28', N'OE', N'2025-07-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Reaj Ahamed', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dajimuddin mia', [fatherName]),
        [mobile] = ISNULL(N'7797272183', [mobile]),
        [email] = ISNULL(N'reajmondol6@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-28', [joiningDate]),
        [dob] = ISNULL(N'2004-05-28', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8491';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8492')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8492', N'RESTEEN FRANCIS', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'A Francis Xavier', N'9961260528', N'resteenf@gmail.com', N'2025-07-28', N'2004-10-27', N'OE', N'2025-07-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'RESTEEN FRANCIS', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'A Francis Xavier', [fatherName]),
        [mobile] = ISNULL(N'9961260528', [mobile]),
        [email] = ISNULL(N'resteenf@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-28', [joiningDate]),
        [dob] = ISNULL(N'2004-10-27', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8492';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8494')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8494', N'Shoaib Aktar Hossain Mondal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Tozammal Hossain Mondal', N'7407489681', N'shoaibaktarhossainmondal@gmail.com', N'2025-07-28', N'2003-12-06', N'OE', N'2025-07-28', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shoaib Aktar Hossain Mondal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Tozammal Hossain Mondal', [fatherName]),
        [mobile] = ISNULL(N'7407489681', [mobile]),
        [email] = ISNULL(N'shoaibaktarhossainmondal@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-07-28', [joiningDate]),
        [dob] = ISNULL(N'2003-12-06', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-07-28', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8494';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8500')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8500', N'Chaithanya K S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Subramaniyan', N'8330061805', N'kschaithanya84@gmail.com', N'2025-08-26', N'2004-06-03', N'OE', N'2025-08-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chaithanya K S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Subramaniyan', [fatherName]),
        [mobile] = ISNULL(N'8330061805', [mobile]),
        [email] = ISNULL(N'kschaithanya84@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-08-26', [joiningDate]),
        [dob] = ISNULL(N'2004-06-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-08-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8500';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8501')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8501', N'Navya V S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Suresh Kumar V V', N'7736765816', N'navyavs005@gmail.com', N'2025-08-26', N'2005-07-23', N'OE', N'2025-08-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Navya V S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Suresh Kumar V V', [fatherName]),
        [mobile] = ISNULL(N'7736765816', [mobile]),
        [email] = ISNULL(N'navyavs005@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-08-26', [joiningDate]),
        [dob] = ISNULL(N'2005-07-23', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-08-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8501';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8502')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8502', N'Nitu Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Mantu Saw', N'6299162846', N'nitukumari7545938914@gmail.com', N'2025-08-26', N'2007-08-10', N'OE', N'2025-08-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nitu Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mantu Saw', [fatherName]),
        [mobile] = ISNULL(N'6299162846', [mobile]),
        [email] = ISNULL(N'nitukumari7545938914@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-08-26', [joiningDate]),
        [dob] = ISNULL(N'2007-08-10', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-08-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8502';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8503')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8503', N'Alajangi Madhavi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Mahesh', N'6309878874', N'alajangimadhavi630@gmail.com', N'2025-08-26', N'2007-02-03', N'OE', N'2025-08-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Alajangi Madhavi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mahesh', [fatherName]),
        [mobile] = ISNULL(N'6309878874', [mobile]),
        [email] = ISNULL(N'alajangimadhavi630@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-08-26', [joiningDate]),
        [dob] = ISNULL(N'2007-02-03', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-08-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8503';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8504')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8504', N'Suryasara K M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pavithran', N'9188264057', N'suryasara7273@gmail.com', N'2025-09-01', N'2004-03-26', N'OE', N'2025-09-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Suryasara K M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pavithran', [fatherName]),
        [mobile] = ISNULL(N'9188264057', [mobile]),
        [email] = ISNULL(N'suryasara7273@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-09-01', [joiningDate]),
        [dob] = ISNULL(N'2004-03-26', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8504';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8505')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8505', N'Sneha K', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Dharamarajan', N'6238733019', N'dharmarajsneha769@gmail.com', N'2025-09-01', N'2004-10-26', N'OE', N'2025-09-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sneha K', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Dharamarajan', [fatherName]),
        [mobile] = ISNULL(N'6238733019', [mobile]),
        [email] = ISNULL(N'dharmarajsneha769@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-09-01', [joiningDate]),
        [dob] = ISNULL(N'2004-10-26', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8505';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8506')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8506', N'Anjalidev S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sunilkumar C', N'9747672625', N'ad9494297@gmail.com', N'2025-09-01', N'2005-05-18', N'OE', N'2025-09-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anjalidev S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sunilkumar C', [fatherName]),
        [mobile] = ISNULL(N'9747672625', [mobile]),
        [email] = ISNULL(N'ad9494297@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-09-01', [joiningDate]),
        [dob] = ISNULL(N'2005-05-18', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-09-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8506';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8509')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8509', N'Ritu Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bindhu Lal', N'8340778690', N'ritukumari70161@gmail.com', N'2025-09-29', N'2006-07-04', N'OE', N'2025-09-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ritu Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bindhu Lal', [fatherName]),
        [mobile] = ISNULL(N'8340778690', [mobile]),
        [email] = ISNULL(N'ritukumari70161@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-09-29', [joiningDate]),
        [dob] = ISNULL(N'2006-07-04', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-09-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8509';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8511')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8511', N'Durairaj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Annadurai', N'6382567125', N'thalaraju62@gmail.com', N'2025-10-06', N'2006-06-09', N'OET', N'2025-10-06', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Durairaj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Annadurai', [fatherName]),
        [mobile] = ISNULL(N'6382567125', [mobile]),
        [email] = ISNULL(N'thalaraju62@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-06', [joiningDate]),
        [dob] = ISNULL(N'2006-06-09', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-06', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8511';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'1114')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'1114', N'Nancy Y', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rUnitAdmin, @unitChennai, @deptChennai,
        N'S Yogaraj', N'7871726322', N'nancyoga777@gmail.com', N'2025-10-07', N'1992-11-24', N'Assistant Manager', N'2025-10-07', N'5'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nancy Y', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rUnitAdmin,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'S Yogaraj', [fatherName]),
        [mobile] = ISNULL(N'7871726322', [mobile]),
        [email] = ISNULL(N'nancyoga777@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-07', [joiningDate]),
        [dob] = ISNULL(N'1992-11-24', [dob]),
        [designation] = ISNULL(N'Assistant Manager', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-07', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'5', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'1114';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8513')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8513', N'Bipin Bihari Khuntia', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rabindra khuntia', N'9827786867', N'rbipinbiharikhuntia19@gmailcom', N'2025-10-10', N'2005-06-01', N'OET', N'2025-10-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bipin Bihari Khuntia', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rabindra khuntia', [fatherName]),
        [mobile] = ISNULL(N'9827786867', [mobile]),
        [email] = ISNULL(N'rbipinbiharikhuntia19@gmailcom', [email]),
        [joiningDate] = ISNULL(N'2025-10-10', [joiningDate]),
        [dob] = ISNULL(N'2005-06-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8513';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8514')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8514', N'Murshid Raza', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Khurshid Alam', N'9693717212', N'murshidraza412@gmail.com', N'2025-10-13', N'2005-01-01', N'OET', N'2025-10-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Murshid Raza', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Khurshid Alam', [fatherName]),
        [mobile] = ISNULL(N'9693717212', [mobile]),
        [email] = ISNULL(N'murshidraza412@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-13', [joiningDate]),
        [dob] = ISNULL(N'2005-01-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8514';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8517')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8517', N'Badal Kumar Nayak', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sanjay Nayak', N'7735791762', N'badalkumar8@gmail.com', N'2025-10-15', N'2004-03-02', N'OET', N'2025-10-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Badal Kumar Nayak', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sanjay Nayak', [fatherName]),
        [mobile] = ISNULL(N'7735791762', [mobile]),
        [email] = ISNULL(N'badalkumar8@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-15', [joiningDate]),
        [dob] = ISNULL(N'2004-03-02', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8517';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8518')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8518', N'Rahul Basu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Samriam Basu', N'9337341653', N'rahulbasu815@gmail.com', N'2025-10-15', N'2006-07-10', N'OET', N'2025-10-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rahul Basu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Samriam Basu', [fatherName]),
        [mobile] = ISNULL(N'9337341653', [mobile]),
        [email] = ISNULL(N'rahulbasu815@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-10-15', [joiningDate]),
        [dob] = ISNULL(N'2006-07-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-10-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8518';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8521')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8521', N'Bikki Bar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Yudhisthir Bar', N'8017499387', N'barbikki7@gmail.com', N'2025-11-05', N'2004-04-13', N'OET', N'2025-11-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bikki Bar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Yudhisthir Bar', [fatherName]),
        [mobile] = ISNULL(N'8017499387', [mobile]),
        [email] = ISNULL(N'barbikki7@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-11-05', [joiningDate]),
        [dob] = ISNULL(N'2004-04-13', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-11-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8521';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8522')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8522', N'Binit Kerketta', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'George Kerketta', N'7091991447', N'kerkettabinit99@gmail.com', N'2025-11-11', N'2006-04-08', N'OET', N'2025-11-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Binit Kerketta', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'George Kerketta', [fatherName]),
        [mobile] = ISNULL(N'7091991447', [mobile]),
        [email] = ISNULL(N'kerkettabinit99@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-11-11', [joiningDate]),
        [dob] = ISNULL(N'2006-04-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-11-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8522';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8524')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8524', N'Ritesh Bara', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Domnik Bara', N'8102082342', N'bararitesh620@gmail.com', N'2025-11-11', N'2005-12-18', N'OET', N'2025-11-11', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ritesh Bara', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Domnik Bara', [fatherName]),
        [mobile] = ISNULL(N'8102082342', [mobile]),
        [email] = ISNULL(N'bararitesh620@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-11-11', [joiningDate]),
        [dob] = ISNULL(N'2005-12-18', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-11-11', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8524';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8526')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8526', N'Amjuri Hanok', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Amjuri Bujji Babu', N'9123167816', N'hanokamjuri@gmail.com', N'2025-11-21', N'2005-05-31', N'OET', N'2025-11-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Amjuri Hanok', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Amjuri Bujji Babu', [fatherName]),
        [mobile] = ISNULL(N'9123167816', [mobile]),
        [email] = ISNULL(N'hanokamjuri@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-11-21', [joiningDate]),
        [dob] = ISNULL(N'2005-05-31', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-11-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8526';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8527')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8527', N'Shivani Hansda', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ugar Hansda', N'7296070666', N'shivanihansda073@gmail.com', N'2025-12-29', N'2004-03-12', N'OET', N'2025-12-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shivani Hansda', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ugar Hansda', [fatherName]),
        [mobile] = ISNULL(N'7296070666', [mobile]),
        [email] = ISNULL(N'shivanihansda073@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-29', [joiningDate]),
        [dob] = ISNULL(N'2004-03-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8527';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8528')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8528', N'Balaram Sethi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pitabash Sethi', N'8280805336', N'ms6291205@gmail.com', N'2025-12-29', N'2007-03-31', N'OET', N'2025-12-29', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Balaram Sethi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pitabash Sethi', [fatherName]),
        [mobile] = ISNULL(N'8280805336', [mobile]),
        [email] = ISNULL(N'ms6291205@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-12-29', [joiningDate]),
        [dob] = ISNULL(N'2007-03-31', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-12-29', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8528';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8529')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8529', N'Pradyumna Behera', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Prasanta Behera', N'8926061109', N'beherapradyumna037@gmail.com', N'2026-03-19', N'2005-11-19', N'OET', N'2026-03-19', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pradyumna Behera', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Prasanta Behera', [fatherName]),
        [mobile] = ISNULL(N'8926061109', [mobile]),
        [email] = ISNULL(N'beherapradyumna037@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-03-19', [joiningDate]),
        [dob] = ISNULL(N'2005-11-19', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-03-19', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8529';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8530')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8530', N'Sibaprasad Samal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sunakar Samal', N'7381368059', N'samalsibaprasad11@gmail.com', N'2026-03-26', N'2005-12-29', N'OET', N'2026-03-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sibaprasad Samal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sunakar Samal', [fatherName]),
        [mobile] = ISNULL(N'7381368059', [mobile]),
        [email] = ISNULL(N'samalsibaprasad11@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-03-26', [joiningDate]),
        [dob] = ISNULL(N'2005-12-29', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-03-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8530';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8532')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8532', N'Mohamed Yasin Cholakkal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Muhammed Basheer', N'7306728502', N'yasinyasinyaaz@gmail.com', N'2026-03-30', N'2004-10-21', N'OET', N'2026-03-30', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohamed Yasin Cholakkal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Muhammed Basheer', [fatherName]),
        [mobile] = ISNULL(N'7306728502', [mobile]),
        [email] = ISNULL(N'yasinyasinyaaz@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-03-30', [joiningDate]),
        [dob] = ISNULL(N'2004-10-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-03-30', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8532';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8533')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8533', N'Lipu Swain', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sankar', N'6374850604', N'lipuswain647@gmail.com', N'2026-04-13', N'2006-03-10', N'OET', N'2026-04-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Lipu Swain', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sankar', [fatherName]),
        [mobile] = ISNULL(N'6374850604', [mobile]),
        [email] = ISNULL(N'lipuswain647@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-04-13', [joiningDate]),
        [dob] = ISNULL(N'2006-03-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-04-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8533';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8534')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8534', N'Praveen Kumar M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Muthukumar', N'6238257498', N'kumarpraveen85935@gmail.com', N'2026-04-27', N'2006-10-27', N'OET', N'2026-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Praveen Kumar M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Muthukumar', [fatherName]),
        [mobile] = ISNULL(N'6238257498', [mobile]),
        [email] = ISNULL(N'kumarpraveen85935@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-04-27', [joiningDate]),
        [dob] = ISNULL(N'2006-10-27', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8534';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8535')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8535', N'Aswin S', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Stalin', N'8122071950', N'aswin24012008@gmail.com', N'2026-04-27', N'2008-01-24', N'OET', N'2026-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Aswin S', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Stalin', [fatherName]),
        [mobile] = ISNULL(N'8122071950', [mobile]),
        [email] = ISNULL(N'aswin24012008@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-04-27', [joiningDate]),
        [dob] = ISNULL(N'2008-01-24', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8535';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8536')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8536', N'M James', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Murugananthan', N'9342365198', N'jamesjohnm2005@gmail.com', N'2026-04-27', N'2005-04-24', N'OET', N'2026-04-27', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'M James', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Murugananthan', [fatherName]),
        [mobile] = ISNULL(N'9342365198', [mobile]),
        [email] = ISNULL(N'jamesjohnm2005@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-04-27', [joiningDate]),
        [dob] = ISNULL(N'2005-04-24', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-04-27', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8536';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8537')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8537', N'Athul P Raju', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Raju P K', N'7907592586', N'athulop69@gmail.com', N'2026-05-04', N'2005-06-07', N'OET', N'2026-05-04', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Athul P Raju', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Raju P K', [fatherName]),
        [mobile] = ISNULL(N'7907592586', [mobile]),
        [email] = ISNULL(N'athulop69@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-05-04', [joiningDate]),
        [dob] = ISNULL(N'2005-06-07', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-05-04', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8537';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8548')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8548', N'Priyanka Lakra', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Binod Lakra', N'9827626535', N'lakrapriyanka231@gmail.com', N'2026-06-01', N'2007-03-31', N'OET', N'2026-06-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Priyanka Lakra', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Binod Lakra', [fatherName]),
        [mobile] = ISNULL(N'9827626535', [mobile]),
        [email] = ISNULL(N'lakrapriyanka231@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2007-03-31', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8548';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8549')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8549', N'Banaja Priyadarshini Lenka', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Hemant Kumar Lenka', N'9337194411', N'lenkapriyadarshini09@gmail.com', N'2026-06-01', N'2008-01-21', N'OET', N'2026-06-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Banaja Priyadarshini Lenka', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Hemant Kumar Lenka', [fatherName]),
        [mobile] = ISNULL(N'9337194411', [mobile]),
        [email] = ISNULL(N'lenkapriyadarshini09@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2008-01-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8549';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8550')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8550', N'Basanta Sahu', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Gada sahu', N'9337323271', N'basantasahu9337323271@gmail.com', N'2026-06-01', N'2005-02-05', N'OET', N'2026-06-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Basanta Sahu', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Gada sahu', [fatherName]),
        [mobile] = ISNULL(N'9337323271', [mobile]),
        [email] = ISNULL(N'basantasahu9337323271@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-01', [joiningDate]),
        [dob] = ISNULL(N'2005-02-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8550';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8554')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8554', N'Pawan verma', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rajkumar Verma', N'9958716681', N'pv7053l52@gmail.com', N'2026-06-05', N'2005-06-04', N'OET', N'2026-06-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Pawan verma', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rajkumar Verma', [fatherName]),
        [mobile] = ISNULL(N'9958716681', [mobile]),
        [email] = ISNULL(N'pv7053l52@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-05', [joiningDate]),
        [dob] = ISNULL(N'2005-06-04', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8554';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8558')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8558', N'Puneet Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Omkar Singh', N'9811447273', N'puneetkumar1535@gmail.com', N'2026-06-05', N'2005-06-17', N'OET', N'2026-06-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Puneet Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Omkar Singh', [fatherName]),
        [mobile] = ISNULL(N'9811447273', [mobile]),
        [email] = ISNULL(N'puneetkumar1535@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-05', [joiningDate]),
        [dob] = ISNULL(N'2005-06-17', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8558';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8559')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8559', N'Shrishant Kumar', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sanjay Kumar', N'7518767990', N'shrishantk299@gmail.com', N'2026-06-05', N'2008-04-21', N'OET', N'2026-06-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Shrishant Kumar', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sanjay Kumar', [fatherName]),
        [mobile] = ISNULL(N'7518767990', [mobile]),
        [email] = ISNULL(N'shrishantk299@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-05', [joiningDate]),
        [dob] = ISNULL(N'2008-04-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8559';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8564')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8564', N'Zulfiquar Ahmed Choudhury', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Mashuque Ahmed Choudhury', N'7896012415', N'zulfiquarchoudhury325@gmail.com', N'2026-06-25', N'2005-03-05', N'OET', N'2026-06-25', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Zulfiquar Ahmed Choudhury', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mashuque Ahmed Choudhury', [fatherName]),
        [mobile] = ISNULL(N'7896012415', [mobile]),
        [email] = ISNULL(N'zulfiquarchoudhury325@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-06-25', [joiningDate]),
        [dob] = ISNULL(N'2005-03-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-06-25', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8564';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8566')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8566', N'Nishu Kumari', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sunil Rajak', N'7541949137', N'nishunishu33976@gmail.com', N'2026-07-09', N'2006-01-01', N'OET', N'2026-07-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nishu Kumari', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sunil Rajak', [fatherName]),
        [mobile] = ISNULL(N'7541949137', [mobile]),
        [email] = ISNULL(N'nishunishu33976@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-09', [joiningDate]),
        [dob] = ISNULL(N'2006-01-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8566';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8567')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8567', N'Satyam Raj', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Uma Shankar Sharma', N'9304008256', N'sharmajinkp1597@gmail.com', N'2026-07-09', N'2007-09-25', N'OET', N'2026-07-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Satyam Raj', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Uma Shankar Sharma', [fatherName]),
        [mobile] = ISNULL(N'9304008256', [mobile]),
        [email] = ISNULL(N'sharmajinkp1597@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-09', [joiningDate]),
        [dob] = ISNULL(N'2007-09-25', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8567';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8568')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8568', N'Sayantan Pramanick', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Samir Pramanick', N'7439075646', N'sayantanpramanick12@gmail.com', N'2026-07-09', N'2003-11-04', N'OET', N'2026-07-09', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sayantan Pramanick', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Samir Pramanick', [fatherName]),
        [mobile] = ISNULL(N'7439075646', [mobile]),
        [email] = ISNULL(N'sayantanpramanick12@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-09', [joiningDate]),
        [dob] = ISNULL(N'2003-11-04', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-09', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8568';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8569')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8569', N'Riju Dey', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Sankar Kumar Dey', N'7810811844', N'rijud0206@gmail.com', N'2026-07-21', N'2003-10-21', N'OET', N'2026-07-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Riju Dey', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Sankar Kumar Dey', [fatherName]),
        [mobile] = ISNULL(N'7810811844', [mobile]),
        [email] = ISNULL(N'rijud0206@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-21', [joiningDate]),
        [dob] = ISNULL(N'2003-10-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8569';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8571')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8571', N'Tirtha Sundar Mallick', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Tushar Kanti Mallick', N'8016995078', N'tirthamullick10@gmail.com', N'2026-07-21', N'2004-12-06', N'OET', N'2026-07-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tirtha Sundar Mallick', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Tushar Kanti Mallick', [fatherName]),
        [mobile] = ISNULL(N'8016995078', [mobile]),
        [email] = ISNULL(N'tirthamullick10@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-21', [joiningDate]),
        [dob] = ISNULL(N'2004-12-06', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8571';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8577')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8577', N'Sudarshan Dash', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Jagannath Dash', N'7735398243', N'sudarshandash@gmail.com', N'2026-08-01', N'2007-09-17', N'OET', N'2026-08-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sudarshan Dash', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Jagannath Dash', [fatherName]),
        [mobile] = ISNULL(N'7735398243', [mobile]),
        [email] = ISNULL(N'sudarshandash@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-01', [joiningDate]),
        [dob] = ISNULL(N'2007-09-17', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8577';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8578')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8578', N'Chandrakant Sethy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Prakash Sethy', N'7751031391', N'tt683205@gmail.com', N'2026-08-01', N'2007-07-05', N'OET', N'2026-08-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandrakant Sethy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Prakash Sethy', [fatherName]),
        [mobile] = ISNULL(N'7751031391', [mobile]),
        [email] = ISNULL(N'tt683205@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-01', [joiningDate]),
        [dob] = ISNULL(N'2007-07-05', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8578';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8579')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8579', N'Tanmoy Santra', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Amit Kumar Santra', N'8670338896', N'sansantra3@gmail.com', N'2026-08-10', N'2006-03-18', N'OET', N'2026-08-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Tanmoy Santra', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Amit Kumar Santra', [fatherName]),
        [mobile] = ISNULL(N'8670338896', [mobile]),
        [email] = ISNULL(N'sansantra3@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-10', [joiningDate]),
        [dob] = ISNULL(N'2006-03-18', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8579';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8580')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8580', N'Ritwick Pal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Khudiram Pal', N'9476407660', N'akashpal.kumurul@gmail.com', N'2026-08-10', N'2006-02-11', N'OET', N'2026-08-10', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ritwick Pal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Khudiram Pal', [fatherName]),
        [mobile] = ISNULL(N'9476407660', [mobile]),
        [email] = ISNULL(N'akashpal.kumurul@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-10', [joiningDate]),
        [dob] = ISNULL(N'2006-02-11', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-10', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8580';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8581')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8581', N'Abbana Rajesh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Abbana Srinu', N'9014799903', N'abbanarajesh@gmail.com', N'2026-09-02', N'2006-06-06', N'OET', N'2026-09-02', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abbana Rajesh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Abbana Srinu', [fatherName]),
        [mobile] = ISNULL(N'9014799903', [mobile]),
        [email] = ISNULL(N'abbanarajesh@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-02', [joiningDate]),
        [dob] = ISNULL(N'2006-06-06', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-02', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8581';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8586')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8586', N'Mainak Maity', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Manas Maity', N'9830335179', N'mainakmaity35@gmail.com', N'2026-09-12', N'2005-10-02', N'OET', N'2026-09-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mainak Maity', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Manas Maity', [fatherName]),
        [mobile] = ISNULL(N'9830335179', [mobile]),
        [email] = ISNULL(N'mainakmaity35@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-12', [joiningDate]),
        [dob] = ISNULL(N'2005-10-02', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8586';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8587')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8587', N'Nityananda Ghosh', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rabindranath Ghosh', N'8001357639', N'nityanandag71@gmail.com', N'2026-09-12', N'2004-12-13', N'OET', N'2026-09-12', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nityananda Ghosh', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rabindranath Ghosh', [fatherName]),
        [mobile] = ISNULL(N'8001357639', [mobile]),
        [email] = ISNULL(N'nityanandag71@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-12', [joiningDate]),
        [dob] = ISNULL(N'2004-12-13', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-12', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8587';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8588')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8588', N'Nipun Sethy', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Bulu Sethy', N'7735011520', N'nipunsethy3@gmail.com', N'2026-09-15', N'2003-03-10', N'OET', N'2026-09-15', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Nipun Sethy', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Bulu Sethy', [fatherName]),
        [mobile] = ISNULL(N'7735011520', [mobile]),
        [email] = ISNULL(N'nipunsethy3@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-15', [joiningDate]),
        [dob] = ISNULL(N'2003-03-10', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-15', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8588';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8589')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8589', N'Chandan Nahak', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Purnachandra Nahak', N'7750007445', N'chandannahak545@gmail.com', N'2026-09-18', N'2006-01-01', N'OET', N'2026-09-18', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chandan Nahak', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Purnachandra Nahak', [fatherName]),
        [mobile] = ISNULL(N'7750007445', [mobile]),
        [email] = ISNULL(N'chandannahak545@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-18', [joiningDate]),
        [dob] = ISNULL(N'2006-01-01', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-18', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8589';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8590')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8590', N'Insaf Ahmad', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Vakil Miya', N'9523857573', N'mrinsafahmad07@gmail.com', N'2026-09-22', N'2007-09-25', N'OET', N'2026-09-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Insaf Ahmad', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Vakil Miya', [fatherName]),
        [mobile] = ISNULL(N'9523857573', [mobile]),
        [email] = ISNULL(N'mrinsafahmad07@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-22', [joiningDate]),
        [dob] = ISNULL(N'2007-09-25', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8590';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8591')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8591', N'Ajeet', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Lalman', N'8595263461', N'ajeet88740@gmail.com', N'2026-09-22', N'2006-03-20', N'OET', N'2026-09-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ajeet', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Lalman', [fatherName]),
        [mobile] = ISNULL(N'8595263461', [mobile]),
        [email] = ISNULL(N'ajeet88740@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-22', [joiningDate]),
        [dob] = ISNULL(N'2006-03-20', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8591';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8592')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8592', N'Sarita Nahak', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ashok Kumar Nahak', N'7438814418', N'nahaksarita3@gmail.com', N'2026-09-22', N'2002-06-08', N'OET', N'2026-09-22', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Sarita Nahak', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ashok Kumar Nahak', [fatherName]),
        [mobile] = ISNULL(N'7438814418', [mobile]),
        [email] = ISNULL(N'nahaksarita3@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-09-22', [joiningDate]),
        [dob] = ISNULL(N'2002-06-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8592';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8593')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8593', N'Dharitri Pantanty', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Suresh Pantanty', N'8018036595', N'dpantanty@gmail.com', N'2026-10-05', N'2004-09-21', N'OET', N'2026-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Dharitri Pantanty', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Suresh Pantanty', [fatherName]),
        [mobile] = ISNULL(N'8018036595', [mobile]),
        [email] = ISNULL(N'dpantanty@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-05', [joiningDate]),
        [dob] = ISNULL(N'2004-09-21', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8593';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8594')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8594', N'Bishnupriya Mahato', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Nakul Chandra Mahato', N'7815027509', N'bishnupriyamahato09@gmail.com', N'2026-10-05', N'2006-03-11', N'OET', N'2026-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bishnupriya Mahato', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Nakul Chandra Mahato', [fatherName]),
        [mobile] = ISNULL(N'7815027509', [mobile]),
        [email] = ISNULL(N'bishnupriyamahato09@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-05', [joiningDate]),
        [dob] = ISNULL(N'2006-03-11', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8594';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8595')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8595', N'Anand Kumar Mallik', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Prahallad Chandra Mallik', N'9040814239', N'anandkumarmallik16@gmail.com', N'2026-10-05', N'2006-03-12', N'OET', N'2026-10-05', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Anand Kumar Mallik', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Prahallad Chandra Mallik', [fatherName]),
        [mobile] = ISNULL(N'9040814239', [mobile]),
        [email] = ISNULL(N'anandkumarmallik16@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-05', [joiningDate]),
        [dob] = ISNULL(N'2006-03-12', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-05', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8595';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8596')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8596', N'Abhishek Tigga', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Pradip Tigga', N'8260011893', N'abhishektigga8845@gmail.com', N'2026-10-13', N'2005-11-06', N'OET', N'2026-10-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Abhishek Tigga', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Pradip Tigga', [fatherName]),
        [mobile] = ISNULL(N'8260011893', [mobile]),
        [email] = ISNULL(N'abhishektigga8845@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-13', [joiningDate]),
        [dob] = ISNULL(N'2005-11-06', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8596';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8597')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8597', N'Reshma Patel', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rabindra Kumar Patel', N'7846800260', N'reshmapatel24042004@gmail.com', N'2026-10-13', N'2004-04-28', N'OET', N'2026-10-13', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Reshma Patel', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rabindra Kumar Patel', [fatherName]),
        [mobile] = ISNULL(N'7846800260', [mobile]),
        [email] = ISNULL(N'reshmapatel24042004@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-10-13', [joiningDate]),
        [dob] = ISNULL(N'2004-04-28', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-10-13', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8597';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'6286')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'6286', N'Ambili M', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rTL, @unitChennai, @deptChennai,
        N'Gireesh', N'9497604173', N'girigireesh113@gmail.com', N'2020-09-22', N'2000-08-30', N'TL', N'2020-09-22', N'2'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Ambili M', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rTL,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Gireesh', [fatherName]),
        [mobile] = ISNULL(N'9497604173', [mobile]),
        [email] = ISNULL(N'girigireesh113@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2020-09-22', [joiningDate]),
        [dob] = ISNULL(N'2000-08-30', [dob]),
        [designation] = ISNULL(N'TL', [designation]),
        [groupJoiningDate] = ISNULL(N'2020-09-22', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'2', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'6286';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8474')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8474', N'Muhammed Shihab U', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Ubaid', N'9744084886', N'muhammedshihab226688@gmail.com', N'2025-06-16', N'2004-01-24', N'OE', N'2025-06-16', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Muhammed Shihab U', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Ubaid', [fatherName]),
        [mobile] = ISNULL(N'9744084886', [mobile]),
        [email] = ISNULL(N'muhammedshihab226688@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2025-06-16', [joiningDate]),
        [dob] = ISNULL(N'2004-01-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2025-06-16', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8474';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8265')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8265', N'Mohan Mani', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Mani S', N'8248016914', N'msdmohanmani@gmail.com', N'2023-05-26', N'2004-06-24', N'OE', N'2023-05-26', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Mohan Mani', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Mani S', [fatherName]),
        [mobile] = ISNULL(N'8248016914', [mobile]),
        [email] = ISNULL(N'msdmohanmani@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2023-05-26', [joiningDate]),
        [dob] = ISNULL(N'2004-06-24', [dob]),
        [designation] = ISNULL(N'OE', [designation]),
        [groupJoiningDate] = ISNULL(N'2023-05-26', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8265';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8570')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8570', N'Chiranton Rajbanshi', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Chittaranjan Rajbanshi', N'8100170634', N'chrantanrajbanshi@gmail.com', N'2026-07-21', N'2005-06-08', N'OET', N'2026-07-21', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Chiranton Rajbanshi', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Chittaranjan Rajbanshi', [fatherName]),
        [mobile] = ISNULL(N'8100170634', [mobile]),
        [email] = ISNULL(N'chrantanrajbanshi@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-07-21', [joiningDate]),
        [dob] = ISNULL(N'2005-06-08', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-07-21', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8570';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8575')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8575', N'Rudra Prakash Rout', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Rabindra Nath Rout', N'7978758278', N'rudraprakashrout7978@gmail.com', N'2026-08-01', N'2007-08-13', N'OET', N'2026-08-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Rudra Prakash Rout', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Rabindra Nath Rout', [fatherName]),
        [mobile] = ISNULL(N'7978758278', [mobile]),
        [email] = ISNULL(N'rudraprakashrout7978@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-01', [joiningDate]),
        [dob] = ISNULL(N'2007-08-13', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8575';
END
IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = N'8576')
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), N'8576', N'Bhabagrahi Samal', @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), @rEmployee, @unitChennai, @deptChennai,
        N'Hrushikesh Samal', N'6370960767', N'bhabagrahisamal585@gmail.com', N'2026-08-01', N'2007-06-02', N'OET', N'2026-08-01', N'1'
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL(N'Bhabagrahi Samal', [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = @rEmployee,
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL(N'Hrushikesh Samal', [fatherName]),
        [mobile] = ISNULL(N'6370960767', [mobile]),
        [email] = ISNULL(N'bhabagrahisamal585@gmail.com', [email]),
        [joiningDate] = ISNULL(N'2026-08-01', [joiningDate]),
        [dob] = ISNULL(N'2007-06-02', [dob]),
        [designation] = ISNULL(N'OET', [designation]),
        [groupJoiningDate] = ISNULL(N'2026-08-01', [groupJoiningDate]),
        [gradeCode] = ISNULL(N'1', [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = N'8576';
END

-- ============================================================================
-- 5. ESTABLISH SUPERVISORY REPORTING HIERARCHY WITHIN CHENNAI
-- ============================================================================
-- 5.1 Link Team Leaders (TL) to Senior Group Leaders (SGL) in Chennai

;WITH TlCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rTL AND unitId = @unitChennai AND isActive = 1
),
SglCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn,
           COUNT(*) OVER () AS sglCount
    FROM [dbo].[User]
    WHERE roleId = @rSGL AND unitId = @unitChennai AND isActive = 1
)
UPDATE t
SET t.sglId = s.id
FROM [dbo].[User] t
JOIN TlCTE tc ON t.id = tc.id
JOIN SglCTE s ON ((tc.rn - 1) % s.sglCount) + 1 = s.rn;

-- 5.2 Link Employees to Team Leaders (TL) and SGLs in Chennai

;WITH EmpCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rEmployee AND unitId = @unitChennai AND isActive = 1
),
TlCTE AS (
    SELECT id, unitId, sglId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn,
           COUNT(*) OVER () AS tlCount
    FROM [dbo].[User]
    WHERE roleId = @rTL AND unitId = @unitChennai AND isActive = 1
)
UPDATE e
SET e.tlId = t.id,
    e.sglId = t.sglId
FROM [dbo].[User] e
JOIN EmpCTE ec ON e.id = ec.id
JOIN TlCTE t ON ((ec.rn - 1) % t.tlCount) + 1 = t.rn;

COMMIT TRANSACTION;
PRINT '============================================================================';
PRINT 'Successfully seeded Chennai plant (211 records) into GrowthPortal!';
PRINT '============================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Error during Chennai seeding: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO