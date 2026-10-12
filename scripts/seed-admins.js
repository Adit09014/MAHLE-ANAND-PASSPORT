/**
 * ============================================================================
 * MAHLE ANAND PASSPORT - ALL ADMIN TYPES SEED SCRIPT
 * Database: GrowthPortal (MSSQL)
 * ============================================================================
 * Seeds all types of Admin, Supervisory, and Test Accounts:
 *   1. Super Admin (Central - All Plants, Full Access)
 *   2. HR Head (Central - Corporate HR, Multi-Unit Analytics & Compliance)
 *   3. Unit Admin (Plant Level - Gurugram, Unit 2, Unit 3, Unit 4)
 *   4. Senior Group Leader (SGL) (Plant/Department Evaluator)
 *   5. Team Leader (TL) (Shop Floor 1-10 Evaluator)
 *   6. Shop Floor Employees (Test Accounts with Submissions & Reviews)
 *
 * Usage:
 *   node --env-file=.env scripts/seed-admins.js
 *   npm run seed:admins
 * ============================================================================
 */

const bcrypt = require('bcryptjs');
const sql = require('mssql');

// 1. Connection configuration matching lib/mssql.ts
async function connectToDatabase() {
  const isTrusted = (process.env.MSSQL_TRUSTED_CONNECTION || 'true') === 'true';
  const rawServer = (process.env.MSSQL_SERVER || 'localhost\\MSSQLSERVER1').trim();
  const database = (process.env.MSSQL_DATABASE || 'GrowthPortal').trim();

  if (isTrusted) {
    const sqlNativeModule = await import('mssql/msnodesqlv8.js');
    const sqlNative = sqlNativeModule.default || sqlNativeModule;

    const odbcDrivers = [
      'ODBC Driver 18 for SQL Server',
      'ODBC Driver 17 for SQL Server',
      'SQL Server',
      'SQL Server Native Client 11.0',
    ];

    let lastErr = null;
    for (const driver of odbcDrivers) {
      try {
        const trustCert = driver.includes('18') ? 'TrustServerCertificate=yes;' : '';
        const config = {
          driver: 'msnodesqlv8',
          connectionString: `Driver={${driver}};Server=${rawServer};Database=${database};Trusted_Connection=yes;${trustCert}`,
          parseJSON: true,
        };
        const pool = new sqlNative.ConnectionPool(config);
        const connectedPool = await pool.connect();
        console.log(`[DB] Connected using Trusted Windows Auth via ${driver}`);
        return connectedPool;
      } catch (err) {
        lastErr = err;
      }
    }
    throw lastErr;
  } else {
    const normalizedServer = rawServer.replace(/\\+/g, '\\');
    let serverHost = normalizedServer;
    let instanceName = undefined;
    if (normalizedServer.includes('\\')) {
      const parts = normalizedServer.split('\\').filter(Boolean);
      serverHost = parts[0] || 'localhost';
      instanceName = parts[1] || undefined;
    }

    const config = {
      server: serverHost,
      database,
      user: (process.env.MSSQL_USER || '').trim(),
      password: (process.env.MSSQL_PASSWORD || '').trim(),
      port: process.env.MSSQL_PORT ? parseInt(process.env.MSSQL_PORT, 10) : undefined,
      options: {
        encrypt: process.env.MSSQL_ENCRYPT === 'true',
        trustServerCertificate: true,
        enableArithAbort: true,
        ...(instanceName ? { instanceName } : {}),
      },
    };

    const pool = new sql.ConnectionPool(config);
    const connectedPool = await pool.connect();
    console.log(`[DB] Connected using SQL Server Auth (${config.user}@${serverHost})`);
    return connectedPool;
  }
}

// 2. Table Creation DDL (Table Making Format)
async function ensureTables(pool) {
  console.log('\n[Schema] Step 1: Ensuring all database tables exist...');

  const ddlQueries = [
    // Unit Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Unit')
    CREATE TABLE [dbo].[Unit] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [name] NVARCHAR(1000) NOT NULL UNIQUE,
      [code] NVARCHAR(50),
      [isActive] BIT NOT NULL DEFAULT 1,
      [createdAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP
    );`,

    // Add code column if missing
    `IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Unit]') AND name = 'code')
    ALTER TABLE [dbo].[Unit] ADD [code] NVARCHAR(50);`,

    // Department Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Department')
    CREATE TABLE [dbo].[Department] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [name] NVARCHAR(1000) NOT NULL,
      [unitId] NVARCHAR(1000) NOT NULL
    );`,

    // Role Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Role')
    CREATE TABLE [dbo].[Role] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [name] NVARCHAR(1000) NOT NULL UNIQUE
    );`,

    // AssessmentCycle Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentCycle')
    CREATE TABLE [dbo].[AssessmentCycle] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [month] NVARCHAR(20) NOT NULL UNIQUE,
      [title] NVARCHAR(100) NOT NULL,
      [status] NVARCHAR(50) NOT NULL DEFAULT 'open',
      [startDate] DATETIME2,
      [endDate] DATETIME2,
      [createdAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP
    );`,

    // User Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'User')
    CREATE TABLE [dbo].[User] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [empCode] NVARCHAR(1000) NOT NULL UNIQUE,
      [name] NVARCHAR(1000),
      [passwordHash] NVARCHAR(1000),
      [isActive] BIT NOT NULL DEFAULT 1,
      [createdAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
      [updatedAt] DATETIME2 NOT NULL,
      [roleId] NVARCHAR(1000),
      [unitId] NVARCHAR(1000),
      [departmentId] NVARCHAR(1000),
      [tlId] NVARCHAR(1000),
      [sglId] NVARCHAR(1000)
    );`,

    // MonthlySubmission Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MonthlySubmission')
    CREATE TABLE [dbo].[MonthlySubmission] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [empId] NVARCHAR(1000) NOT NULL,
      [month] NVARCHAR(1000) NOT NULL,
      [status] NVARCHAR(1000) NOT NULL DEFAULT 'pending',
      [selfScore] DECIMAL(4,2),
      [submittedAt] DATETIME2,
      [createdAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
      [updatedAt] DATETIME2 NOT NULL,
      CONSTRAINT [MonthlySubmission_empId_month_key] UNIQUE ([empId],[month])
    );`,

    // Ensure selfScore column exists on existing MonthlySubmission table
    `IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[MonthlySubmission]') AND name = 'selfScore')
    ALTER TABLE [dbo].[MonthlySubmission] ADD [selfScore] DECIMAL(4,2);`,

    // AssessmentReview Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentReview')
    CREATE TABLE [dbo].[AssessmentReview] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [submissionId] NVARCHAR(1000) NOT NULL UNIQUE,
      [evaluatorId] NVARCHAR(1000) NOT NULL,
      [score] DECIMAL(4,2) NOT NULL,
      [ratingGrade] NVARCHAR(50),
      [criteriaScores] VARCHAR(MAX),
      [tlComments] NVARCHAR(MAX),
      [sglRemarks] NVARCHAR(MAX),
      [status] NVARCHAR(50) NOT NULL DEFAULT 'completed',
      [reviewedAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
      [updatedAt] DATETIME2 NOT NULL
    );`,

    // SheetData Table
    `IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'SheetData')
    CREATE TABLE [dbo].[SheetData] (
      [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
      [empId] NVARCHAR(1000) NOT NULL,
      [sheetId] NVARCHAR(1000) NOT NULL,
      [data] VARCHAR(MAX) NOT NULL,
      [updatedAt] DATETIME2 NOT NULL,
      CONSTRAINT [SheetData_empId_sheetId_key] UNIQUE ([empId],[sheetId])
    );`,
  ];

  for (const ddl of ddlQueries) {
    await pool.request().query(ddl);
  }
  console.log('[Schema] All core tables verified successfully.');
}

// Helper to upsert role
async function upsertRole(pool, roleName) {
  const res = await pool.request()
    .input('name', roleName)
    .query('SELECT id FROM [Role] WHERE name = @name');
  if (res.recordset.length > 0) return res.recordset[0].id;

  const insert = await pool.request()
    .input('name', roleName)
    .query(`
      DECLARE @id NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
      INSERT INTO [Role] (id, name) VALUES (@id, @name);
      SELECT @id AS id;
    `);
  return insert.recordset[0].id;
}

// Helper to upsert unit
async function upsertUnit(pool, name, code) {
  const res = await pool.request()
    .input('name', name)
    .query('SELECT id FROM [Unit] WHERE name = @name');
  if (res.recordset.length > 0) {
    await pool.request()
      .input('name', name)
      .input('code', code)
      .query('UPDATE [Unit] SET code = @code WHERE name = @name');
    return res.recordset[0].id;
  }

  const insert = await pool.request()
    .input('name', name)
    .input('code', code)
    .query(`
      DECLARE @id NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
      INSERT INTO [Unit] (id, name, code) VALUES (@id, @name, @code);
      SELECT @id AS id;
    `);
  return insert.recordset[0].id;
}

// Helper to upsert department
async function upsertDepartment(pool, name, unitId) {
  const res = await pool.request()
    .input('name', name)
    .input('unitId', unitId)
    .query('SELECT id FROM [Department] WHERE name = @name AND unitId = @unitId');
  if (res.recordset.length > 0) return res.recordset[0].id;

  const insert = await pool.request()
    .input('name', name)
    .input('unitId', unitId)
    .query(`
      DECLARE @id NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
      INSERT INTO [Department] (id, name, unitId) VALUES (@id, @name, @unitId);
      SELECT @id AS id;
    `);
  return insert.recordset[0].id;
}

// Helper to upsert user
async function upsertUser(pool, { empCode, name, roleId, unitId, departmentId, tlId, sglId, passwordHash }) {
  const codeUpper = empCode.trim().toUpperCase();
  const existing = await pool.request()
    .input('empCode', codeUpper)
    .query('SELECT id FROM [User] WHERE empCode = @empCode');

  if (existing.recordset.length > 0) {
    const id = existing.recordset[0].id;
    await pool.request()
      .input('id', id)
      .input('name', name)
      .input('roleId', roleId)
      .input('unitId', unitId || null)
      .input('departmentId', departmentId || null)
      .input('tlId', tlId || null)
      .input('sglId', sglId || null)
      .input('passwordHash', passwordHash)
      .query(`
        UPDATE [User]
        SET name = @name,
            roleId = @roleId,
            unitId = @unitId,
            departmentId = @departmentId,
            tlId = @tlId,
            sglId = @sglId,
            passwordHash = @passwordHash,
            isActive = 1,
            updatedAt = SYSUTCDATETIME()
        WHERE id = @id
      `);
    return id;
  } else {
    const insert = await pool.request()
      .input('empCode', codeUpper)
      .input('name', name)
      .input('roleId', roleId)
      .input('unitId', unitId || null)
      .input('departmentId', departmentId || null)
      .input('tlId', tlId || null)
      .input('sglId', sglId || null)
      .input('passwordHash', passwordHash)
      .query(`
        DECLARE @id NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
        INSERT INTO [User] (id, empCode, name, roleId, unitId, departmentId, tlId, sglId, passwordHash, isActive, createdAt, updatedAt)
        VALUES (@id, @empCode, @name, @roleId, @unitId, @departmentId, @tlId, @sglId, @passwordHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME());
        SELECT @id AS id;
      `);
    return insert.recordset[0].id;
  }
}

// Helper to upsert submission and evaluation
async function upsertSubmission(pool, { empGuid, month, status, selfScore, evalGuid, score, ratingGrade, comments, remarks, criteria }) {
  const existingSub = await pool.request()
    .input('empId', empGuid)
    .input('month', month)
    .query('SELECT id FROM [MonthlySubmission] WHERE empId = @empId AND month = @month');

  let subId;
  if (existingSub.recordset.length > 0) {
    subId = existingSub.recordset[0].id;
    await pool.request()
      .input('id', subId)
      .input('status', status)
      .input('selfScore', selfScore)
      .query(`
        UPDATE [MonthlySubmission]
        SET status = @status, selfScore = @selfScore, submittedAt = SYSUTCDATETIME(), updatedAt = SYSUTCDATETIME()
        WHERE id = @id
      `);
  } else {
    const insert = await pool.request()
      .input('empId', empGuid)
      .input('month', month)
      .input('status', status)
      .input('selfScore', selfScore)
      .query(`
        DECLARE @newId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
        INSERT INTO [MonthlySubmission] (id, empId, month, status, selfScore, submittedAt, createdAt, updatedAt)
        VALUES (@newId, @empId, @month, @status, @selfScore, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME());
        SELECT @newId AS id;
      `);
    subId = insert.recordset[0].id;
  }

  // If score provided, upsert AssessmentReview
  if (score && evalGuid) {
    const critJson = JSON.stringify(criteria || {
      safety: score >= 9 ? 9.5 : 8.5,
      quality: score >= 9 ? 9.0 : 8.0,
      '5s': score >= 9 ? 9.0 : 8.5,
      productivity: score,
      attendance: 9.0,
    });

    const existingRev = await pool.request()
      .input('subId', subId)
      .query('SELECT id FROM [AssessmentReview] WHERE submissionId = @subId');

    if (existingRev.recordset.length > 0) {
      await pool.request()
        .input('subId', subId)
        .input('evaluatorId', evalGuid)
        .input('score', score)
        .input('grade', ratingGrade)
        .input('crit', critJson)
        .input('tlComments', comments || 'Good overall performance.')
        .input('sglRemarks', remarks || 'Verified and approved.')
        .query(`
          UPDATE [AssessmentReview]
          SET evaluatorId = @evaluatorId,
              score = @score,
              ratingGrade = @grade,
              criteriaScores = @crit,
              tlComments = @tlComments,
              sglRemarks = @sglRemarks,
              status = 'completed',
              reviewedAt = SYSUTCDATETIME(),
              updatedAt = SYSUTCDATETIME()
          WHERE submissionId = @subId
        `);
    } else {
      await pool.request()
        .input('subId', subId)
        .input('evaluatorId', evalGuid)
        .input('score', score)
        .input('grade', ratingGrade)
        .input('crit', critJson)
        .input('tlComments', comments || 'Good overall performance.')
        .input('sglRemarks', remarks || 'Verified and approved.')
        .query(`
          INSERT INTO [AssessmentReview] (id, submissionId, evaluatorId, score, ratingGrade, criteriaScores, tlComments, sglRemarks, status, reviewedAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @subId, @evaluatorId, @score, @grade, @crit, @tlComments, @sglRemarks, 'completed', SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    }
  }
}

// 3. Main Seeding Runner
async function main() {
  console.log('================================================================================');
  console.log('       MAHLE ANAND PASSPORT - ALL ADMIN TYPES SEED SUITE (TESTING DATA)        ');
  console.log('================================================================================');

  let pool;
  try {
    pool = await connectToDatabase();

    // Step 1: Ensure Tables
    await ensureTables(pool);

    // Step 2: Ensure Master Roles
    console.log('\n[Roles] Step 2: Seeding Master Roles...');
    const roleMap = {
      superAdmin: await upsertRole(pool, 'Super Admin'),
      hrHead: await upsertRole(pool, 'HR Head'),
      unitAdmin: await upsertRole(pool, 'Unit Admin'),
      sgl: await upsertRole(pool, 'Senior Group Leader (SGL)'),
      tl: await upsertRole(pool, 'Team Leader (TL)'),
      emp: await upsertRole(pool, 'Shop Floor Employee'),
    };
    console.log('  ✓ 6 Master Roles active in database.');

    // Step 3: Ensure 4 State Units
    console.log('\n[Units] Step 3: Seeding 4 Manufacturing State Units...');
    const unitMap = {
      u1: await upsertUnit(pool, 'Gurugram', 'GGN'),
      u2: await upsertUnit(pool, 'State Unit 2', 'U02'),
      u3: await upsertUnit(pool, 'State Unit 3', 'U03'),
      u4: await upsertUnit(pool, 'State Unit 4', 'U04'),
    };
    console.log('  ✓ Units: Gurugram (GGN), State Unit 2 (U02), State Unit 3 (U03), State Unit 4 (U04)');

    // Step 4: Ensure Departments per Unit
    console.log('\n[Departments] Step 4: Seeding Production & Quality Departments...');
    const deptMap = {
      u1_mfg: await upsertDepartment(pool, 'Manufacturing / Production', unitMap.u1),
      u1_qa:  await upsertDepartment(pool, 'Quality Assurance', unitMap.u1),
      u1_as:  await upsertDepartment(pool, 'Assembly Line', unitMap.u1),

      u2_mfg: await upsertDepartment(pool, 'Manufacturing / Production', unitMap.u2),
      u2_qa:  await upsertDepartment(pool, 'Quality Assurance', unitMap.u2),

      u3_mfg: await upsertDepartment(pool, 'Manufacturing / Production', unitMap.u3),
      u3_qa:  await upsertDepartment(pool, 'Quality Assurance', unitMap.u3),

      u4_mfg: await upsertDepartment(pool, 'Manufacturing / Production', unitMap.u4),
      u4_qa:  await upsertDepartment(pool, 'Quality Assurance', unitMap.u4),
    };
    console.log('  ✓ Departments mapped to respective plants.');

    // Step 5: Ensure Active Assessment Cycle
    console.log('\n[Cycle] Step 5: Ensuring October 2026 Assessment Cycle...');
    const cycleRes = await pool.request().query("SELECT id FROM [AssessmentCycle] WHERE month = '2026-10'");
    if (cycleRes.recordset.length === 0) {
      await pool.request().query(`
        INSERT INTO [AssessmentCycle] (id, month, title, status, startDate, endDate)
        VALUES (CAST(NEWID() AS NVARCHAR(1000)), '2026-10', 'October 2026 Assessment Cycle', 'open', '2026-10-01', '2026-10-31')
      `);
    }
    console.log('  ✓ Active cycle 2026-10 open.');

    // Step 6: Generate Standard Bcrypt Hash
    const defaultPassword = 'Mahle@123';
    const defaultHash = bcrypt.hashSync(defaultPassword, 10);
    console.log(`\n[Auth] Step 6: Generated bcrypt hash for test password: "${defaultPassword}"`);

    // Step 7: Seed All Types of Admins
    console.log('\n[Admins] Step 7: Seeding All Types of Admin Accounts...');

    // 7.1 Central Super Admins
    const saGuid1 = await upsertUser(pool, {
      empCode: 'ADMIN01',
      name: 'Super Admin Central',
      roleId: roleMap.superAdmin,
      unitId: null,
      departmentId: null,
      passwordHash: defaultHash,
    });
    const saGuid2 = await upsertUser(pool, {
      empCode: 'SA_TEST01',
      name: 'Vikramaditya (Super Admin QA)',
      roleId: roleMap.superAdmin,
      unitId: null,
      departmentId: null,
      passwordHash: defaultHash,
    });

    // 7.2 Central HR Heads
    const hrGuid1 = await upsertUser(pool, {
      empCode: 'HR001',
      name: 'Pooja Nair (HR Head Central)',
      roleId: roleMap.hrHead,
      unitId: null,
      departmentId: null,
      passwordHash: defaultHash,
    });
    const hrGuid2 = await upsertUser(pool, {
      empCode: 'HR_TEST01',
      name: 'Ananya Roy (HR Auditor Test)',
      roleId: roleMap.hrHead,
      unitId: null,
      departmentId: null,
      passwordHash: defaultHash,
    });

    // 7.3 Plant Unit Admins (Every plant + test accounts)
    // Gurugram (Plant 1)
    const ua1Guid = await upsertUser(pool, {
      empCode: 'UA1001',
      name: 'Ankit Mehra (Admin Gurugram)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_mfg,
      passwordHash: defaultHash,
    });
    const ua1TestGuid = await upsertUser(pool, {
      empCode: 'UA_GGN_TEST',
      name: 'Gaurav Saxena (Gurugram Plant Admin)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_qa,
      passwordHash: defaultHash,
    });

    // State Unit 2
    const ua2Guid = await upsertUser(pool, {
      empCode: 'UA2001',
      name: 'Sunil Deshmukh (Admin Unit 2)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u2,
      departmentId: deptMap.u2_mfg,
      passwordHash: defaultHash,
    });
    const ua2TestGuid = await upsertUser(pool, {
      empCode: 'UA_U02_TEST',
      name: 'Pooja Kulkarni (Unit 2 Plant Admin)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u2,
      departmentId: deptMap.u2_qa,
      passwordHash: defaultHash,
    });

    // State Unit 3
    const ua3Guid = await upsertUser(pool, {
      empCode: 'UA3001',
      name: 'Ramesh Iyer (Admin Unit 3)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u3,
      departmentId: deptMap.u3_mfg,
      passwordHash: defaultHash,
    });
    const ua3TestGuid = await upsertUser(pool, {
      empCode: 'UA_U03_TEST',
      name: 'Meenakshi Sundaram (Unit 3 Plant Admin)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u3,
      departmentId: deptMap.u3_qa,
      passwordHash: defaultHash,
    });

    // State Unit 4
    const ua4Guid = await upsertUser(pool, {
      empCode: 'UA4001',
      name: 'Vikram Rawat (Admin Unit 4)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u4,
      departmentId: deptMap.u4_mfg,
      passwordHash: defaultHash,
    });
    const ua4TestGuid = await upsertUser(pool, {
      empCode: 'UA_U04_TEST',
      name: 'Siddharth Negi (Unit 4 Plant Admin)',
      roleId: roleMap.unitAdmin,
      unitId: unitMap.u4,
      departmentId: deptMap.u4_qa,
      passwordHash: defaultHash,
    });

    // Step 8: Seed SGLs (Senior Group Leaders)
    console.log('\n[Supervisors] Step 8: Seeding SGL (Senior Group Leaders) & TL (Team Leaders)...');
    const sgl1Guid = await upsertUser(pool, {
      empCode: 'K02001',
      name: 'Vikram Verma (SGL Gurugram)',
      roleId: roleMap.sgl,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_mfg,
      passwordHash: defaultHash,
    });
    const sgl2Guid = await upsertUser(pool, {
      empCode: 'K02002',
      name: 'Anil Gupta (SGL Unit 2)',
      roleId: roleMap.sgl,
      unitId: unitMap.u2,
      departmentId: deptMap.u2_mfg,
      passwordHash: defaultHash,
    });
    const sgl3Guid = await upsertUser(pool, {
      empCode: 'K02003',
      name: 'Prakash Nair (SGL Unit 3)',
      roleId: roleMap.sgl,
      unitId: unitMap.u3,
      departmentId: deptMap.u3_mfg,
      passwordHash: defaultHash,
    });
    const sgl4Guid = await upsertUser(pool, {
      empCode: 'K02004',
      name: 'Devendra Joshi (SGL Unit 4)',
      roleId: roleMap.sgl,
      unitId: unitMap.u4,
      departmentId: deptMap.u4_mfg,
      passwordHash: defaultHash,
    });

    // Step 9: Seed TLs (Team Leaders)
    const tl1Guid = await upsertUser(pool, {
      empCode: 'K01001',
      name: 'Rajesh Sharma (TL Gurugram)',
      roleId: roleMap.tl,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_mfg,
      sglId: sgl1Guid,
      passwordHash: defaultHash,
    });
    const tl2Guid = await upsertUser(pool, {
      empCode: 'K01002',
      name: 'Manoj Singh (TL Unit 2)',
      roleId: roleMap.tl,
      unitId: unitMap.u2,
      departmentId: deptMap.u2_mfg,
      sglId: sgl2Guid,
      passwordHash: defaultHash,
    });
    const tl3Guid = await upsertUser(pool, {
      empCode: 'K01003',
      name: 'Karthik Raja (TL Unit 3)',
      roleId: roleMap.tl,
      unitId: unitMap.u3,
      departmentId: deptMap.u3_mfg,
      sglId: sgl3Guid,
      passwordHash: defaultHash,
    });
    const tl4Guid = await upsertUser(pool, {
      empCode: 'K01004',
      name: 'Sanjay Negi (TL Unit 4)',
      roleId: roleMap.tl,
      unitId: unitMap.u4,
      departmentId: deptMap.u4_mfg,
      sglId: sgl4Guid,
      passwordHash: defaultHash,
    });

    // Step 10: Seed Shop Floor Employees & Assessments for testing
    console.log('\n[Employees] Step 10: Seeding Shop Floor Test Employees & Assessment Reviews...');

    // Unit 1 (Gurugram)
    const emp1_1 = await upsertUser(pool, {
      empCode: 'KA1042',
      name: 'Amit Kumar',
      roleId: roleMap.emp,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_mfg,
      tlId: tl1Guid,
      sglId: sgl1Guid,
      passwordHash: defaultHash,
    });
    const emp1_2 = await upsertUser(pool, {
      empCode: 'NTK1042',
      name: 'Suresh Patel',
      roleId: roleMap.emp,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_qa,
      tlId: tl1Guid,
      sglId: sgl1Guid,
      passwordHash: defaultHash,
    });
    const emp1_3 = await upsertUser(pool, {
      empCode: 'KA1043',
      name: 'Rohit Verma',
      roleId: roleMap.emp,
      unitId: unitMap.u1,
      departmentId: deptMap.u1_as,
      tlId: tl1Guid,
      sglId: sgl1Guid,
      passwordHash: defaultHash,
    });

    // Unit 2
    const emp2_1 = await upsertUser(pool, {
      empCode: 'KA2042',
      name: 'Rahul Sharma',
      roleId: roleMap.emp,
      unitId: unitMap.u2,
      departmentId: deptMap.u2_mfg,
      tlId: tl2Guid,
      sglId: sgl2Guid,
      passwordHash: defaultHash,
    });
    const emp2_2 = await upsertUser(pool, {
      empCode: 'NTK2042',
      name: 'Deepak Verma',
      roleId: roleMap.emp,
      unitId: unitMap.u2,
      departmentId: deptMap.u2_qa,
      tlId: tl2Guid,
      sglId: sgl2Guid,
      passwordHash: defaultHash,
    });

    // Unit 3
    const emp3_1 = await upsertUser(pool, {
      empCode: 'KA3042',
      name: 'Arun Murugan',
      roleId: roleMap.emp,
      unitId: unitMap.u3,
      departmentId: deptMap.u3_mfg,
      tlId: tl3Guid,
      sglId: sgl3Guid,
      passwordHash: defaultHash,
    });
    const emp3_2 = await upsertUser(pool, {
      empCode: 'NTK3042',
      name: 'Vijay Kumar',
      roleId: roleMap.emp,
      unitId: unitMap.u3,
      departmentId: deptMap.u3_qa,
      tlId: tl3Guid,
      sglId: sgl3Guid,
      passwordHash: defaultHash,
    });

    // Unit 4
    const emp4_1 = await upsertUser(pool, {
      empCode: 'KA4042',
      name: 'Rohit Thakur',
      roleId: roleMap.emp,
      unitId: unitMap.u4,
      departmentId: deptMap.u4_mfg,
      tlId: tl4Guid,
      sglId: sgl4Guid,
      passwordHash: defaultHash,
    });
    const emp4_2 = await upsertUser(pool, {
      empCode: 'NTK4042',
      name: 'Mohit Sharma',
      roleId: roleMap.emp,
      unitId: unitMap.u4,
      departmentId: deptMap.u4_qa,
      tlId: tl4Guid,
      sglId: sgl4Guid,
      passwordHash: defaultHash,
    });

    // Submissions & 1-10 Scale Evaluations
    // KA1042: Evaluated (Score 8.70 / 10, Grade A Outstanding)
    await upsertSubmission(pool, {
      empGuid: emp1_1,
      month: '2026-10',
      status: 'evaluated',
      selfScore: 8.50,
      evalGuid: tl1Guid,
      score: 8.70,
      ratingGrade: 'Grade A (Outstanding)',
      comments: 'Exceptional 5S discipline and zero defects on the shop floor this cycle.',
      remarks: 'Reviewed and verified by SGL.',
    });

    // NTK1042: Submitted, awaiting review
    await upsertSubmission(pool, {
      empGuid: emp1_2,
      month: '2026-10',
      status: 'submitted',
      selfScore: 7.80,
    });

    // KA2042 (Unit 2): Evaluated (Score 9.20 / 10, Grade A+ Distinction)
    await upsertSubmission(pool, {
      empGuid: emp2_1,
      month: '2026-10',
      status: 'evaluated',
      selfScore: 9.00,
      evalGuid: tl2Guid,
      score: 9.20,
      ratingGrade: 'Grade A+ (Distinction)',
      comments: 'Demonstrated stellar line leadership with zero downtime.',
      remarks: 'Approved by Unit 2 SGL.',
    });

    // NTK2042 (Unit 2): Submitted
    await upsertSubmission(pool, {
      empGuid: emp2_2,
      month: '2026-10',
      status: 'submitted',
      selfScore: 8.00,
    });

    // KA3042 (Unit 3): Evaluated (Score 8.40 / 10, Grade A)
    await upsertSubmission(pool, {
      empGuid: emp3_1,
      month: '2026-10',
      status: 'evaluated',
      selfScore: 8.20,
      evalGuid: tl3Guid,
      score: 8.40,
      ratingGrade: 'Grade A (Outstanding)',
      comments: 'Consistently met hourly takt times with high precision.',
      remarks: 'Verified by Unit 3 SGL.',
    });

    // NTK3042 (Unit 3): Evaluated (Score 7.80 / 10, Grade B+)
    await upsertSubmission(pool, {
      empGuid: emp3_2,
      month: '2026-10',
      status: 'evaluated',
      selfScore: 7.50,
      evalGuid: tl3Guid,
      score: 7.80,
      ratingGrade: 'Grade B+ (Good)',
      comments: 'Good adherence to work instructions.',
      remarks: 'Reviewed by Unit 3 SGL.',
    });

    // KA4042 (Unit 4): Evaluated (Score 8.90 / 10, Grade A)
    await upsertSubmission(pool, {
      empGuid: emp4_1,
      month: '2026-10',
      status: 'evaluated',
      selfScore: 8.70,
      evalGuid: tl4Guid,
      score: 8.90,
      ratingGrade: 'Grade A (Outstanding)',
      comments: 'Proactive participation in plant safety kaizens.',
      remarks: 'Verified by Unit 4 SGL.',
    });

    // NTK4042 (Unit 4): Submitted
    await upsertSubmission(pool, {
      empGuid: emp4_2,
      month: '2026-10',
      status: 'submitted',
      selfScore: 7.90,
    });

    // Seed Frontpage Sheet Data for KA1042
    await pool.request()
      .input('empId', emp1_1)
      .input('sheetId', 'frontpage')
      .input('data', JSON.stringify({
        empName: 'Amit Kumar',
        empCode: 'KA1042',
        unit: 'Gurugram',
        dept: 'Manufacturing / Production',
        role: 'Shop Floor Operator',
        dateOfJoining: '2022-04-15',
        education: 'Diploma in Mechanical Engineering',
        bloodGroup: 'B+',
      }))
      .query(`
        IF NOT EXISTS (SELECT * FROM [SheetData] WHERE empId = @empId AND sheetId = @sheetId)
          INSERT INTO [SheetData] (id, empId, sheetId, data, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empId, @sheetId, @data, SYSUTCDATETIME())
        ELSE
          UPDATE [SheetData] SET data = @data, updatedAt = SYSUTCDATETIME() WHERE empId = @empId AND sheetId = @sheetId
      `);

    console.log('  ✓ Employees and submissions seeded successfully.');

    // Step 11: Display Table Making Format Output
    console.log('\n================================================================================');
    console.log('              ALL TYPES OF ADMIN ACCOUNTS CREATED FOR TESTING                  ');
    console.log('================================================================================');

    const adminQuery = await pool.request().query(`
      SELECT 
        r.name AS [AdminRole],
        u.empCode AS [EmpCode],
        u.name AS [FullName],
        COALESCE(un.name, 'Central / All Plants') AS [AssignedUnit],
        COALESCE(un.code, 'ALL') AS [UnitCode],
        COALESCE(d.name, 'All Departments') AS [Department],
        'Mahle@123' AS [Password],
        CASE 
          WHEN r.name = 'Super Admin' THEN 'Full Central Cross-Plant Access & User Management'
          WHEN r.name = 'HR Head' THEN 'Corporate HR Oversight & Multi-Unit Analytics'
          WHEN r.name = 'Unit Admin' THEN 'Scoped Strictly to Assigned Plant Operations'
          WHEN r.name = 'Senior Group Leader (SGL)' THEN 'Audits TL Evaluations & Reviews Team Submissions'
          WHEN r.name = 'Team Leader (TL)' THEN 'Evaluates Assigned Shop Floor Operators (1-10 Scale)'
          ELSE 'Employee Record & Self-Assessment'
        END AS [AuthorityScope]
      FROM [User] u
      INNER JOIN [Role] r ON u.roleId = r.id
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
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
        un.name, u.empCode
    `);

    // ASCII Table Making Format
    console.table(adminQuery.recordset.map(row => ({
      'Admin Type': row.AdminRole,
      'Emp Code / Login ID': row.EmpCode,
      'Name': row.FullName,
      'Assigned Unit': row.AssignedUnit,
      'Test Password': row.Password,
      'Authority Scope': row.AuthorityScope,
    })));

    // Summary of Shop Floor Employees
    const empQuery = await pool.request().query(`
      SELECT 
        u.empCode AS [EmpCode],
        u.name AS [Name],
        un.name AS [Unit],
        ISNULL(m.status, 'pending') AS [SubmissionStatus],
        ar.score AS [TLScore],
        ar.ratingGrade AS [Grade]
      FROM [User] u
      INNER JOIN [Role] r ON u.roleId = r.id AND r.name = 'Shop Floor Employee'
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = '2026-10'
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      ORDER BY un.name, u.empCode
    `);

    console.log('\n================================================================================');
    console.log('               SHOP FLOOR TEST EMPLOYEES & ASSESSMENT STATUS                    ');
    console.log('================================================================================');
    console.table(empQuery.recordset.map(r => ({
      'Emp Code': r.EmpCode,
      'Employee Name': r.Name,
      'Unit / Plant': r.Unit,
      'Oct 2026 Status': r.SubmissionStatus,
      '1-10 TL Score': r.TLScore !== null ? Number(r.TLScore).toFixed(1) + ' / 10' : 'Pending',
      'Performance Grade': r.Grade || 'Pending Evaluation',
      'Password': `${r.EmpCode} or Mahle@123`,
    })));

    console.log('\n================================================================================');
    console.log('  TESTING CREDENTIALS SUMMARY (Copy & Paste for Testing):');
    console.log('================================================================================');
    console.log('  1. Super Admin:       ID: ADMIN01       Password: Mahle@123   (Central / All Units)');
    console.log('  2. Super Admin Test:  ID: SA_TEST01     Password: Mahle@123   (Central / All Units)');
    console.log('  3. HR Head:           ID: HR001         Password: Mahle@123   (Corporate HR Central)');
    console.log('  4. HR Head Test:      ID: HR_TEST01     Password: Mahle@123   (Corporate HR Audit)');
    console.log('  5. Unit Admin (GGN):  ID: UA1001        Password: Mahle@123   (Gurugram Plant)');
    console.log('  6. Unit Admin (U02):  ID: UA2001        Password: Mahle@123   (State Unit 2)');
    console.log('  7. Unit Admin (U03):  ID: UA3001        Password: Mahle@123   (State Unit 3)');
    console.log('  8. Unit Admin (U04):  ID: UA4001        Password: Mahle@123   (State Unit 4)');
    console.log('  9. SGL Supervisor:    ID: K02001        Password: Mahle@123   (Gurugram SGL)');
    console.log(' 10. TL Evaluator:      ID: K01001        Password: Mahle@123   (Gurugram Team Leader)');
    console.log(' 11. Shop Floor Emp:    ID: KA1042        Password: KA1042      (Shop Floor Operator)');
    console.log('================================================================================\n');

  } catch (err) {
    console.error('\n❌ Error executing seed script:', err);
    process.exitCode = 1;
  } finally {
    if (pool) {
      await pool.close();
      console.log('[DB] Connection closed.');
    }
  }
}

main();
