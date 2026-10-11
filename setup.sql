-- ========================================================
-- MAHLE Assessment Portal - Complete SSMS Setup Script
-- Database: GrowthPortal
-- ========================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'GrowthPortal')
BEGIN
    CREATE DATABASE [GrowthPortal];
END
GO

USE [GrowthPortal];
GO

BEGIN TRY
BEGIN TRAN;

-- 1. Create Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'dbo') 
    EXEC sp_executesql N'CREATE SCHEMA [dbo];';

-- 2. Create Unit Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Unit')
CREATE TABLE [dbo].[Unit] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Unit_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Unit_name_key] UNIQUE NONCLUSTERED ([name])
);

-- 3. Create Department Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Department')
CREATE TABLE [dbo].[Department] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [unitId] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Department_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- 4. Create Role Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Role')
CREATE TABLE [dbo].[Role] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Role_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Role_name_key] UNIQUE NONCLUSTERED ([name])
);

-- 5. Create User Table (Hierarchical Mapping: TL, SGL, Unit, Department)
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

-- 6. Create MonthlySubmission Table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MonthlySubmission')
CREATE TABLE [dbo].[MonthlySubmission] (
    [id] NVARCHAR(1000) NOT NULL,
    [empId] NVARCHAR(1000) NOT NULL,
    [month] NVARCHAR(1000) NOT NULL,
    [status] NVARCHAR(1000) NOT NULL CONSTRAINT [MonthlySubmission_status_df] DEFAULT 'pending',
    [submittedAt] DATETIME2,
    [createdAt] DATETIME2 NOT NULL CONSTRAINT [MonthlySubmission_createdAt_df] DEFAULT CURRENT_TIMESTAMP,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [MonthlySubmission_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [MonthlySubmission_empId_month_key] UNIQUE NONCLUSTERED ([empId],[month])
);

-- 7. Create SheetData Table (Stores JSON for all 10 frontend sheets)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'SheetData')
CREATE TABLE [dbo].[SheetData] (
    [id] NVARCHAR(1000) NOT NULL,
    [empId] NVARCHAR(1000) NOT NULL,
    [sheetId] NVARCHAR(1000) NOT NULL,
    [data] VARCHAR(max) NOT NULL,
    [updatedAt] DATETIME2 NOT NULL,
    CONSTRAINT [SheetData_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [SheetData_empId_sheetId_key] UNIQUE NONCLUSTERED ([empId],[sheetId])
);

-- 8. Add Foreign Keys
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

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'SheetData_empId_fkey')
ALTER TABLE [dbo].[SheetData] ADD CONSTRAINT [SheetData_empId_fkey] FOREIGN KEY ([empId]) REFERENCES [dbo].[User]([id]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- 9. Insert Predefined Roles
IF NOT EXISTS (SELECT * FROM [dbo].[Role])
BEGIN
    INSERT INTO [dbo].[Role] ([id], [name])
    VALUES 
        (NEWID(), 'Super Admin'),
        (NEWID(), 'Unit Admin'),
        (NEWID(), 'Shop Floor Employee'),
        (NEWID(), 'Team Leader (TL)'),
        (NEWID(), 'Senior Group Leader (SGL)'),
        (NEWID(), 'HR Head');
END

-- 10. Insert Initial Units
IF NOT EXISTS (SELECT * FROM [dbo].[Unit])
BEGIN
    INSERT INTO [dbo].[Unit] ([id], [name])
    VALUES 
        (NEWID(), 'Gurugram'),
        (NEWID(), 'State Unit 2'),
        (NEWID(), 'State Unit 3'),
        (NEWID(), 'State Unit 4');
END

COMMIT TRAN;
PRINT 'Database, tables, relations, and initial seed data created successfully!';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    PRINT 'Error occurred: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO
