-- ============================================================================
-- SQL SCRIPT: REMOVE ALL ASSESSMENT CYCLES, SUBMISSIONS & REVIEW DATA
-- Database: GrowthPortal
-- Description: Completely resets all cycles, employee submissions, and reviews
--              Leaves all Users, Units, Departments, and Roles 100% intact!
-- ============================================================================
SET NOCOUNT ON;
GO

USE [GrowthPortal];
GO

BEGIN TRY
BEGIN TRANSACTION;

PRINT '1. Deleting all Assessment Reviews (Evaluations)...';
DELETE FROM [dbo].[AssessmentReview];

PRINT '2. Deleting all Monthly Submissions...';
DELETE FROM [dbo].[MonthlySubmission];

PRINT '3. Deleting all Assessment Cycles...';
DELETE FROM [dbo].[AssessmentCycle];

-- Optional: If you also want to clear draft passport sheet data entered by employees,
-- uncomment the line below:
-- DELETE FROM [dbo].[SheetData];

COMMIT TRANSACTION;
PRINT '============================================================================';
PRINT 'All assessment cycles, submissions, and evaluations removed successfully!';
PRINT '============================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Error clearing assessment cycles: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO
