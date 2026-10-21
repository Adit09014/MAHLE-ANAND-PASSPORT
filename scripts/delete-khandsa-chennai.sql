-- ============================================================================
-- SQL SCRIPT: CLEANLY REMOVE KHANDSA AND CHENNAI UNITS & ASSOCIATED DATA
-- Database: GrowthPortal
-- Description: Safely deletes Khandsa and Chennai with all foreign key dependencies
--              (Reviews -> Submissions -> SheetData -> Users -> Departments -> Units)
-- ============================================================================
SET NOCOUNT ON;
GO

USE [GrowthPortal];
GO

BEGIN TRY
BEGIN TRANSACTION;

-- 1. Identify Target Units to Remove
DECLARE @targetUnits TABLE (id NVARCHAR(1000), name NVARCHAR(1000));
INSERT INTO @targetUnits (id, name)
SELECT id, name FROM [dbo].[Unit] WHERE [name] IN ('Khandsa', 'Chennai');

IF NOT EXISTS (SELECT 1 FROM @targetUnits)
BEGIN
    PRINT 'No matching units found (Khandsa and Chennai are already deleted).';
END
ELSE
BEGIN
    PRINT 'Identified units to remove:';
    SELECT id, name FROM @targetUnits;

    -- 2. Identify Target Users belonging strictly to these units
    DECLARE @targetUsers TABLE (id NVARCHAR(1000), empCode NVARCHAR(1000));
    INSERT INTO @targetUsers (id, empCode)
    SELECT id, empCode FROM [dbo].[User] WHERE unitId IN (SELECT id FROM @targetUnits);

    -- 3. Re-assign any users outside these units who point to Khandsa/Chennai departments
    -- (e.g. Gurugram employees that may have had legacy pointers)
    PRINT 'Re-assigning cross-unit department references to their own plant...';
    UPDATE u
    SET u.departmentId = d.id
    FROM [dbo].[User] u
    JOIN [dbo].[Department] curD ON u.departmentId = curD.id
    LEFT JOIN [dbo].[Department] d ON d.unitId = u.unitId AND d.name = 'Manufacturing / Production'
    WHERE curD.unitId IN (SELECT id FROM @targetUnits)
      AND (u.unitId IS NULL OR u.unitId NOT IN (SELECT id FROM @targetUnits));

    -- 4. Unlink any supervisor references (tlId, sglId) across the entire system
    PRINT 'Unlinking supervisor references (tlId, sglId)...';
    UPDATE [dbo].[User]
    SET [tlId] = NULL
    WHERE [tlId] IN (SELECT id FROM @targetUsers);

    UPDATE [dbo].[User]
    SET [sglId] = NULL
    WHERE [sglId] IN (SELECT id FROM @targetUsers);

    UPDATE [dbo].[User]
    SET [tlId] = NULL, [sglId] = NULL
    WHERE [id] IN (SELECT id FROM @targetUsers);

    -- 5. Delete Assessment Reviews linked to Submissions from these users or evaluated by these users
    PRINT 'Deleting Assessment Reviews...';
    DELETE ar
    FROM [dbo].[AssessmentReview] ar
    WHERE ar.evaluatorId IN (SELECT id FROM @targetUsers)
       OR ar.submissionId IN (
           SELECT ms.id 
           FROM [dbo].[MonthlySubmission] ms 
           WHERE ms.empId IN (SELECT id FROM @targetUsers)
       );

    -- 6. Delete Monthly Submissions of these users
    PRINT 'Deleting Monthly Submissions...';
    DELETE ms
    FROM [dbo].[MonthlySubmission] ms
    WHERE ms.empId IN (SELECT id FROM @targetUsers);

    -- 7. Delete Sheet Data of these users
    PRINT 'Deleting Sheet Data...';
    DELETE sd
    FROM [dbo].[SheetData] sd
    WHERE sd.empId IN (SELECT id FROM @targetUsers);

    -- 8. Delete Users belonging to Khandsa and Chennai
    PRINT 'Deleting Users...';
    DELETE FROM [dbo].[User]
    WHERE [id] IN (SELECT id FROM @targetUsers);

    -- 9. Delete Departments belonging to Khandsa and Chennai
    PRINT 'Deleting Departments...';
    DELETE FROM [dbo].[Department]
    WHERE [unitId] IN (SELECT id FROM @targetUnits);

    -- 10. Delete the Units themselves
    PRINT 'Deleting Units...';
    DELETE FROM [dbo].[Unit]
    WHERE [id] IN (SELECT id FROM @targetUnits);

    PRINT 'Successfully removed Khandsa and Chennai from GrowthPortal!';
END

COMMIT TRANSACTION;
PRINT '============================================================================';
PRINT 'Units and associated data cleaned up successfully!';
PRINT '============================================================================';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Error during deletion: ' + ERROR_MESSAGE();
    THROW;
END CATCH;
GO
