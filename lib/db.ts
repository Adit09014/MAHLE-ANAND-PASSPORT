import { getPool, sql } from './mssql';

export interface UserProfile {
  id: string;
  empCode: string;
  name: string;
  role: string;
  unitId?: string | null;
  unitName?: string | null;
  unitCode?: string | null;
  departmentId?: string | null;
  departmentName?: string | null;
  tlId?: string | null;
  tlName?: string | null;
  sglId?: string | null;
  sglName?: string | null;
  isActive: boolean;
  fatherName?: string | null;
  mobile?: string | null;
  email?: string | null;
  joiningDate?: string | null;
  dob?: string | null;
  designation?: string | null;
  groupJoiningDate?: string | null;
  gradeCode?: string | null;
}

export interface ReviewData {
  submissionId: string;
  evaluatorId: string;
  score: number; // 1.00 to 10.00
  ratingGrade?: string;
  criteriaScores?: Record<string, number>;
  tlComments?: string;
  sglRemarks?: string;
}

export interface MasterItem {
  id: string;
  type: 'training' | 'activity';
  title: string;
  category?: string | null;
  sortOrder: number;
  isActive: boolean;
  createdAt?: string;
  updatedAt?: string;
}

const DEFAULT_TRAINING_ITEMS = [
  'APS -4 Day',
  'APS Refresher',
  'TPM',
  'SPC',
  'PFEMA',
  'EMS',
  'Product Process Knowledge',
  'Sales',
  'Others',
];

const DEFAULT_ACTIVITY_ITEMS = [
  'Participation in Committees',
  'Sports',
  'First Aid',
  'Safety Committee',
  'Canteen Committee',
  'Cultural Activities',
  'Participation in CI-meet',
];

async function getRoleId(roleName: string): Promise<string> {
  const pool = await getPool();
  const searchName = roleName === 'Shop Floor Employee' ? 'Employee' : roleName;
  const res = await pool.request()
    .input('name', sql.NVarChar, searchName)
    .query('SELECT id FROM [Role] WHERE name = @name');

  if (res.recordset.length > 0) {
    return res.recordset[0].id;
  }

  if (searchName === 'Employee') {
    const sfeRes = await pool.request()
      .query("SELECT id FROM [Role] WHERE name = 'Shop Floor Employee'");
    if (sfeRes.recordset.length > 0) {
      try {
        await pool.request().query("UPDATE [Role] SET name = 'Employee' WHERE name = 'Shop Floor Employee'");
      } catch (e) {}
      return sfeRes.recordset[0].id;
    }
  }

  const insertRes = await pool.request()
    .input('name', sql.NVarChar, searchName)
    .query(`
      DECLARE @newId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
      INSERT INTO [Role] (id, name) VALUES (@newId, @name);
      SELECT @newId AS id;
    `);

  return insertRes.recordset[0].id;
}

async function getOrCreateUserId(empCode: string, defaultRole = 'Employee'): Promise<string> {
  const pool = await getPool();
  const res = await pool.request()
    .input('empCode', sql.NVarChar, empCode)
    .query('SELECT id FROM [User] WHERE empCode = @empCode');

  if (res.recordset.length > 0) {
    return res.recordset[0].id;
  }

  const roleId = await getRoleId(defaultRole);
  const insertRes = await pool.request()
    .input('empCode', sql.NVarChar, empCode)
    .input('roleId', sql.NVarChar, roleId)
    .query(`
      DECLARE @newId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
      INSERT INTO [User] (id, empCode, name, roleId, isActive, createdAt, updatedAt)
      VALUES (@newId, @empCode, @empCode, @roleId, 1, SYSUTCDATETIME(), SYSUTCDATETIME());
      SELECT @newId AS id;
    `);

  return insertRes.recordset[0].id;
}

const store = {
  /* ---------------- user & role resolution ---------------- */
  async ensureUserExtraColumns() {
    try {
      const pool = await getPool();
      await pool.request().query(`
        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Unit')
        BEGIN
          CREATE TABLE [dbo].[Unit] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [name] NVARCHAR(1000) NOT NULL UNIQUE,
            [code] NVARCHAR(50) NULL,
            [isActive] BIT NOT NULL DEFAULT 1,
            [createdAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Department')
        BEGIN
          CREATE TABLE [dbo].[Department] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [name] NVARCHAR(1000) NOT NULL,
            [unitId] NVARCHAR(1000) NOT NULL
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'Role')
        BEGIN
          CREATE TABLE [dbo].[Role] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [name] NVARCHAR(1000) NOT NULL UNIQUE
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentCycle')
        BEGIN
          CREATE TABLE [dbo].[AssessmentCycle] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [month] NVARCHAR(20) NOT NULL UNIQUE,
            [title] NVARCHAR(100) NOT NULL,
            [status] NVARCHAR(50) NOT NULL DEFAULT 'open',
            [startDate] DATETIME2 NULL,
            [endDate] DATETIME2 NULL,
            [createdAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'User')
        BEGIN
          CREATE TABLE [dbo].[User] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [empCode] NVARCHAR(1000) NOT NULL UNIQUE,
            [name] NVARCHAR(1000) NULL,
            [passwordHash] NVARCHAR(1000) NULL,
            [isActive] BIT NOT NULL DEFAULT 1,
            [createdAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            [updatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            [roleId] NVARCHAR(1000) NULL,
            [unitId] NVARCHAR(1000) NULL,
            [departmentId] NVARCHAR(1000) NULL,
            [tlId] NVARCHAR(1000) NULL,
            [sglId] NVARCHAR(1000) NULL,
            [fatherName] NVARCHAR(1000) NULL,
            [mobile] NVARCHAR(50) NULL,
            [email] NVARCHAR(255) NULL,
            [joiningDate] NVARCHAR(50) NULL,
            [dob] NVARCHAR(50) NULL,
            [designation] NVARCHAR(255) NULL,
            [groupJoiningDate] NVARCHAR(50) NULL,
            [gradeCode] NVARCHAR(50) NULL
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MonthlySubmission')
        BEGIN
          CREATE TABLE [dbo].[MonthlySubmission] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [empId] NVARCHAR(1000) NOT NULL,
            [month] NVARCHAR(1000) NOT NULL,
            [status] NVARCHAR(1000) NOT NULL DEFAULT 'pending',
            [selfScore] DECIMAL(4,2) NULL,
            [submittedAt] DATETIME2 NULL,
            [createdAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            [updatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            CONSTRAINT [MonthlySubmission_emp_m_uk] UNIQUE ([empId], [month])
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'AssessmentReview')
        BEGIN
          CREATE TABLE [dbo].[AssessmentReview] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [submissionId] NVARCHAR(1000) NOT NULL UNIQUE,
            [evaluatorId] NVARCHAR(1000) NOT NULL,
            [score] DECIMAL(4,2) NOT NULL,
            [ratingGrade] NVARCHAR(50) NULL,
            [criteriaScores] VARCHAR(MAX) NULL,
            [tlComments] NVARCHAR(MAX) NULL,
            [sglRemarks] NVARCHAR(MAX) NULL,
            [status] NVARCHAR(50) NOT NULL DEFAULT 'completed',
            [reviewedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            [updatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'SheetData')
        BEGIN
          CREATE TABLE [dbo].[SheetData] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [empId] NVARCHAR(1000) NOT NULL,
            [sheetId] NVARCHAR(1000) NOT NULL,
            [data] VARCHAR(MAX) NOT NULL,
            [updatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            CONSTRAINT [SheetData_emp_sheet_uk] UNIQUE ([empId], [sheetId])
          );
        END;

        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MasterItem')
        BEGIN
          CREATE TABLE [dbo].[MasterItem] (
            [id] NVARCHAR(1000) NOT NULL PRIMARY KEY,
            [type] NVARCHAR(50) NOT NULL,
            [title] NVARCHAR(500) NOT NULL,
            [category] NVARCHAR(100) NULL,
            [sortOrder] INT NOT NULL DEFAULT 0,
            [isActive] BIT NOT NULL DEFAULT 1,
            [createdAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
            [updatedAt] DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
          );
        END;

        -- Ensure extended columns if table existed without them
        IF EXISTS (SELECT * FROM sys.tables WHERE name = N'User')
        BEGIN
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'fatherName')
            ALTER TABLE [dbo].[User] ADD [fatherName] NVARCHAR(1000);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'mobile')
            ALTER TABLE [dbo].[User] ADD [mobile] NVARCHAR(50);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'email')
            ALTER TABLE [dbo].[User] ADD [email] NVARCHAR(255);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'joiningDate')
            ALTER TABLE [dbo].[User] ADD [joiningDate] NVARCHAR(50);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'dob')
            ALTER TABLE [dbo].[User] ADD [dob] NVARCHAR(50);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'designation')
            ALTER TABLE [dbo].[User] ADD [designation] NVARCHAR(255);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'groupJoiningDate')
            ALTER TABLE [dbo].[User] ADD [groupJoiningDate] NVARCHAR(50);
          IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND name = 'gradeCode')
            ALTER TABLE [dbo].[User] ADD [gradeCode] NVARCHAR(50);
        END;
      `);
    } catch (err) {
      console.warn('Notice in ensureUserExtraColumns:', err);
    }
  },

  async getUserByEmpCode(empCode: string): Promise<any | null> {
    await this.ensureUserExtraColumns();
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .query(`
        SELECT 
          u.id, 
          u.empCode, 
          u.name, 
          u.passwordHash,
          u.isActive,
          u.unitId,
          u.departmentId,
          u.tlId,
          u.sglId,
          u.fatherName,
          u.mobile,
          u.email,
          u.joiningDate,
          u.dob,
          u.designation,
          u.groupJoiningDate,
          u.gradeCode,
          r.name AS role,
          un.name AS unitName,
          un.code AS unitCode,
          d.name AS departmentName,
          tl.name AS tlName,
          sgl.name AS sglName
        FROM [User] u
        LEFT JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [Unit] un ON u.unitId = un.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [User] tl ON u.tlId = tl.id
        LEFT JOIN [User] sgl ON u.sglId = sgl.id
        WHERE u.empCode = @empCode
      `);

    if (res.recordset.length === 0) return null;
    const user = res.recordset[0];
    if (user.role === 'Shop Floor Employee') {
      user.role = 'Employee';
    }
    return user;
  },

  async upsertEmployeeIfMissing(id: string) {
    await getOrCreateUserId(id, 'Employee');
  },

  async setEmployeeName(id: string, name: string) {
    const pool = await getPool();
    const existing = await pool.request()
      .input('empCode', sql.NVarChar, id)
      .query('SELECT id FROM [User] WHERE empCode = @empCode');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('empCode', sql.NVarChar, id)
        .input('name', sql.NVarChar, name)
        .query('UPDATE [User] SET name = @name, updatedAt = SYSUTCDATETIME() WHERE empCode = @empCode');
    } else {
      const roleId = await getRoleId('Employee');
      await pool.request()
        .input('empCode', sql.NVarChar, id)
        .input('name', sql.NVarChar, name)
        .input('roleId', sql.NVarChar, roleId)
        .query(`
          INSERT INTO [User] (id, empCode, name, roleId, isActive, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empCode, @name, @roleId, 1, SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    }
  },

  async getEmployeeName(id: string) {
    const user = await this.getUserByEmpCode(id);
    return user?.name || id;
  },

  /* ---------------- supervisor / admin auth ---------------- */
  async getSupervisor(id: string) {
    const user = await this.getUserByEmpCode(id);
    if (!user) return null;
    return {
      passwordHash: user.passwordHash,
      role: user.role,
      unitId: user.unitId,
      name: user.name,
      createdAt: user.createdAt,
    };
  },

  async upsertSupervisor(id: string, passwordHash: string, roleName = 'Team Leader (TL)') {
    const pool = await getPool();
    const roleId = await getRoleId(roleName);

    const existing = await pool.request()
      .input('empCode', sql.NVarChar, id)
      .query('SELECT id FROM [User] WHERE empCode = @empCode');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('empCode', sql.NVarChar, id)
        .input('passwordHash', sql.NVarChar, passwordHash)
        .input('roleId', sql.NVarChar, roleId)
        .query('UPDATE [User] SET passwordHash = @passwordHash, roleId = @roleId, updatedAt = SYSUTCDATETIME() WHERE empCode = @empCode');
    } else {
      await pool.request()
        .input('empCode', sql.NVarChar, id)
        .input('passwordHash', sql.NVarChar, passwordHash)
        .input('roleId', sql.NVarChar, roleId)
        .query(`
          INSERT INTO [User] (id, empCode, passwordHash, roleId, isActive, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empCode, @passwordHash, @roleId, 1, SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    }
  },

  async listUnits() {
    const pool = await getPool();
    const res = await pool.request().query('SELECT id, name, code, isActive FROM [Unit] ORDER BY name');
    return res.recordset;
  },

  async updateUnit(id: string, name: string, code?: string) {
    const pool = await getPool();
    await pool.request()
      .input('id', sql.NVarChar, id)
      .input('name', sql.NVarChar, name.trim())
      .input('code', sql.NVarChar, code ? code.trim().toUpperCase() : null)
      .query(`
        UPDATE [Unit]
        SET name = @name,
            code = CASE WHEN @code IS NOT NULL AND LEN(@code) > 0 THEN @code ELSE code END
        WHERE id = @id
      `);
  },

  async listDepartments(unitId?: string) {
    const pool = await getPool();
    let query = 'SELECT d.id, d.name, d.unitId, u.name AS unitName FROM [Department] d JOIN [Unit] u ON d.unitId = u.id';
    if (unitId) {
      const res = await pool.request()
        .input('unitId', sql.NVarChar, unitId)
        .query(query + ' WHERE d.unitId = @unitId ORDER BY d.name');
      return res.recordset;
    }
    const res = await pool.request().query(query + ' ORDER BY u.name, d.name');
    return res.recordset;
  },

  /* ---------------- hierarchy & assigned employees ---------------- */
  async getAssignedEmployeesForTL(tlUserId: string, month = '2026-10', unitId?: string | null, tlEmpCode?: string | null) {
    const pool = await getPool();
    const request = pool.request()
      .input('tlId', sql.NVarChar, tlUserId)
      .input('tlEmpCode', sql.NVarChar, tlEmpCode || tlUserId)
      .input('month', sql.NVarChar, month);

    let query = `
      SELECT 
        u.id,
        u.empCode,
        u.name,
        u.unitId,
        un.name AS unitName,
        d.name AS departmentName,
        m.id AS submissionId,
        ISNULL(m.status, 'not_started') AS submissionStatus,
        m.selfScore,
        m.submittedAt,
        ar.score AS tlScore,
        ar.ratingGrade,
        ar.tlComments,
        ar.criteriaScores,
        ar.reviewedAt
      FROM [User] u
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE (u.tlId = @tlId OR u.tlId = @tlEmpCode) AND u.isActive = 1
    `;

    if (unitId) {
      request.input('unitId', sql.NVarChar, unitId);
      query += ` AND u.unitId = @unitId`;
    }

    query += ` ORDER BY u.empCode`;
    const res = await request.query(query);
    return res.recordset;
  },

  async getTeamForSGL(sglUserId: string, month = '2026-10', unitId?: string | null, sglEmpCode?: string | null, isAllForAdmin = false) {
    const pool = await getPool();
    const request = pool.request()
      .input('sglId', sql.NVarChar, sglUserId)
      .input('sglEmpCode', sql.NVarChar, sglEmpCode || sglUserId)
      .input('month', sql.NVarChar, month);

    let query = `
      SELECT 
        u.id,
        u.empCode,
        u.name,
        r.name AS roleName,
        tl.name AS tlName,
        un.name AS unitName,
        d.name AS departmentName,
        m.id AS submissionId,
        m.month,
        ISNULL(m.status, 'not_started') AS submissionStatus,
        m.selfScore,
        m.submittedAt,
        ar.score AS tlScore,
        ar.ratingGrade,
        ar.criteriaScores,
        ar.tlComments,
        ar.sglRemarks,
        ar.reviewedAt,
        evaluator.name AS evaluatorName
      FROM [User] u
      LEFT JOIN [Role] r ON u.roleId = r.id
      LEFT JOIN [User] tl ON u.tlId = tl.id
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      LEFT JOIN [User] evaluator ON ar.evaluatorId = evaluator.id
      WHERE u.isActive = 1 AND (r.name = 'Employee' OR r.name = 'Shop Floor Employee')
    `;

    if (!isAllForAdmin) {
      query += ` AND (u.sglId = @sglId OR u.sglId = @sglEmpCode)`;
    }

    if (unitId) {
      request.input('unitId', sql.NVarChar, unitId);
      query += ` AND u.unitId = @unitId`;
    }

    query += ` ORDER BY tl.name, u.empCode`;
    const res = await request.query(query);

    return res.recordset.map((row: any) => {
      let parsedCrit = null;
      if (row.criteriaScores) {
        try {
          parsedCrit = typeof row.criteriaScores === 'string' ? JSON.parse(row.criteriaScores) : row.criteriaScores;
        } catch (e) {
          parsedCrit = null;
        }
      }
      return {
        ...row,
        roleName: row.roleName === 'Shop Floor Employee' ? 'Employee' : row.roleName,
        criteriaScores: parsedCrit,
      };
    });
  },

  async getEmployeesByUnit(unitId: string, month = '2026-10') {
    const pool = await getPool();
    const res = await pool.request()
      .input('unitId', sql.NVarChar, unitId)
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT 
          u.id,
          u.empCode,
          u.name,
          u.unitId,
          u.tlId,
          u.sglId,
          u.departmentId,
          u.isActive,
          r.name AS roleName,
          tl.name AS tlName,
          sgl.name AS sglName,
          d.name AS departmentName,
          m.id AS submissionId,
          ISNULL(m.status, 'not_started') AS submissionStatus,
          m.selfScore,
          ar.score AS tlScore,
          ar.ratingGrade
        FROM [User] u
        LEFT JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [User] tl ON u.tlId = tl.id
        LEFT JOIN [User] sgl ON u.sglId = sgl.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        WHERE u.unitId = @unitId AND u.isActive = 1
        ORDER BY d.name, u.empCode
      `);
    return res.recordset;
  },

  async getAllEmployees(unitFilter?: string, month = '2026-10') {
    const pool = await getPool();
    const request = pool.request().input('month', sql.NVarChar, month);
    let query = `
      SELECT 
        u.id,
        u.empCode,
        u.name,
        r.name AS roleName,
        un.id AS unitId,
        un.name AS unitName,
        tl.name AS tlName,
        sgl.name AS sglName,
        d.name AS departmentName,
        m.id AS submissionId,
        ISNULL(m.status, 'not_started') AS submissionStatus,
        m.selfScore,
        ar.score AS tlScore,
        ar.ratingGrade,
        ar.tlComments
      FROM [User] u
      LEFT JOIN [Role] r ON u.roleId = r.id
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [User] tl ON u.tlId = tl.id
      LEFT JOIN [User] sgl ON u.sglId = sgl.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE u.isActive = 1 AND (r.name = 'Employee' OR r.name = 'Shop Floor Employee')
    `;

    if (unitFilter && unitFilter !== 'all') {
      request.input('unitFilter', sql.NVarChar, unitFilter);
      query += ` AND (u.unitId = @unitFilter OR un.name = @unitFilter)`;
    }

    query += ` ORDER BY un.name, d.name, u.empCode`;
    const res = await request.query(query);
    return res.recordset.map((row: any) => ({
      ...row,
      roleName: row.roleName === 'Shop Floor Employee' ? 'Employee' : row.roleName,
    }));
  },

  /* ---------------- assessment reviews (1 to 10 scale) ---------------- */
  async upsertReview(review: ReviewData) {
    const pool = await getPool();
    const criteriaJson = review.criteriaScores ? JSON.stringify(review.criteriaScores) : null;
    
    // Compute grade if not explicitly passed
    let grade = review.ratingGrade;
    if (!grade) {
      if (review.score >= 9.0) grade = 'Grade A+ (Distinction)';
      else if (review.score >= 8.0) grade = 'Grade A (Outstanding)';
      else if (review.score >= 6.5) grade = 'Grade B (Good)';
      else if (review.score >= 5.0) grade = 'Grade C (Meets Expectations)';
      else grade = 'Grade D (Needs Improvement)';
    }

    const existing = await pool.request()
      .input('submissionId', sql.NVarChar, review.submissionId)
      .query('SELECT id FROM [AssessmentReview] WHERE submissionId = @submissionId');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('submissionId', sql.NVarChar, review.submissionId)
        .input('evaluatorId', sql.NVarChar, review.evaluatorId)
        .input('score', sql.Decimal(4, 2), review.score)
        .input('ratingGrade', sql.NVarChar, grade)
        .input('criteriaScores', sql.VarChar(sql.MAX), criteriaJson)
        .input('tlComments', sql.NVarChar, review.tlComments || '')
        .input('sglRemarks', sql.NVarChar, review.sglRemarks || null)
        .query(`
          UPDATE [AssessmentReview]
          SET evaluatorId = @evaluatorId,
              score = @score,
              ratingGrade = @ratingGrade,
              criteriaScores = @criteriaScores,
              tlComments = @tlComments,
              sglRemarks = @sglRemarks,
              reviewedAt = SYSUTCDATETIME(),
              updatedAt = SYSUTCDATETIME()
          WHERE submissionId = @submissionId
        `);
    } else {
      await pool.request()
        .input('submissionId', sql.NVarChar, review.submissionId)
        .input('evaluatorId', sql.NVarChar, review.evaluatorId)
        .input('score', sql.Decimal(4, 2), review.score)
        .input('ratingGrade', sql.NVarChar, grade)
        .input('criteriaScores', sql.VarChar(sql.MAX), criteriaJson)
        .input('tlComments', sql.NVarChar, review.tlComments || '')
        .input('sglRemarks', sql.NVarChar, review.sglRemarks || null)
        .query(`
          INSERT INTO [AssessmentReview] (id, submissionId, evaluatorId, score, ratingGrade, criteriaScores, tlComments, sglRemarks, status, reviewedAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @submissionId, @evaluatorId, @score, @ratingGrade, @criteriaScores, @tlComments, @sglRemarks, 'completed', SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    }

    // Update parent submission status to evaluated
    await pool.request()
      .input('submissionId', sql.NVarChar, review.submissionId)
      .query(`
        UPDATE [MonthlySubmission]
        SET status = 'evaluated', updatedAt = SYSUTCDATETIME()
        WHERE id = @submissionId
      `);
  },

  async getReviewForEmployeeMonth(empCode: string, month = '2026-10') {
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT 
          m.id AS submissionId,
          m.month,
          m.status AS submissionStatus,
          m.selfScore,
          m.submittedAt,
          ar.score AS tlScore,
          ar.ratingGrade,
          ar.criteriaScores,
          ar.tlComments,
          ar.sglRemarks,
          ar.reviewedAt,
          eval.name AS evaluatorName
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        LEFT JOIN [User] eval ON ar.evaluatorId = eval.id
        WHERE u.empCode = @empCode AND m.month = @month
      `);

    if (res.recordset.length === 0) return null;
    const row = res.recordset[0];
    let parsedCriteria = null;
    if (row.criteriaScores) {
      try { parsedCriteria = JSON.parse(row.criteriaScores); } catch { /* ignore */ }
    }
    return {
      ...row,
      criteriaScores: parsedCriteria,
    };
  },

  /* ---------------- multi-unit dashboard analytics ---------------- */
  async getDashboardAnalytics(unitFilter?: string, month = '2026-10') {
    const pool = await getPool();
    const isGlobal = !unitFilter || unitFilter === 'all';

    // Summary KPIs
    const reqKpi = pool.request().input('month', sql.NVarChar, month);
    let kpiSql = `
      SELECT 
        COUNT(DISTINCT u.id) AS totalEmployees,
        COUNT(DISTINCT CASE WHEN m.status IN ('submitted', 'evaluated') THEN m.id END) AS submittedCount,
        COUNT(DISTINCT CASE WHEN m.status = 'evaluated' THEN m.id END) AS evaluatedCount,
        COUNT(DISTINCT CASE WHEN m.status = 'submitted' THEN m.id END) AS pendingReviewCount,
        ROUND(AVG(ar.score), 2) AS averageScore
      FROM [User] u
      JOIN [Role] r ON u.roleId = r.id AND (r.name = 'Employee' OR r.name = 'Shop Floor Employee')
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE u.isActive = 1
    `;

    if (!isGlobal) {
      reqKpi.input('unitFilter', sql.NVarChar, unitFilter.trim());
      kpiSql += ` AND (u.unitId = @unitFilter OR u.unitId IN (SELECT id FROM [Unit] WHERE LOWER(LTRIM(RTRIM(name))) = LOWER(LTRIM(RTRIM(@unitFilter))) OR id = @unitFilter))`;
    }

    const kpiRes = await reqKpi.query(kpiSql);
    const kpi = kpiRes.recordset[0] || {};

    // Unit-wise Breakdown
    const unitRes = await pool.request()
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT 
          un.id AS unitId,
          un.name AS unitName,
          un.code AS unitCode,
          COUNT(DISTINCT u.id) AS totalEmployees,
          COUNT(DISTINCT CASE WHEN m.status IN ('submitted', 'evaluated') THEN m.id END) AS submittedCount,
          COUNT(DISTINCT CASE WHEN m.status = 'evaluated' THEN m.id END) AS evaluatedCount,
          ROUND(AVG(ar.score), 2) AS avgScore
        FROM [Unit] un
        LEFT JOIN [User] u ON un.id = u.unitId AND u.isActive = 1 AND u.roleId IN (SELECT id FROM [Role] WHERE name IN ('Employee', 'Shop Floor Employee'))
        LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        GROUP BY un.id, un.name, un.code
        ORDER BY un.name
      `);

    // Department-wise Breakdown
    const deptReq = pool.request().input('month', sql.NVarChar, month);
    let deptSql = `
      SELECT 
        d.name AS departmentName,
        COUNT(DISTINCT u.id) AS totalEmployees,
        COUNT(DISTINCT CASE WHEN m.status IN ('submitted', 'evaluated') THEN m.id END) AS submittedCount,
        COUNT(DISTINCT CASE WHEN m.status = 'evaluated' THEN m.id END) AS evaluatedCount,
        ROUND(AVG(ar.score), 2) AS avgScore
      FROM [Department] d
      JOIN [User] u ON d.id = u.departmentId AND u.isActive = 1 AND u.roleId IN (SELECT id FROM [Role] WHERE name IN ('Employee', 'Shop Floor Employee'))
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
    `;
    if (!isGlobal) {
      deptReq.input('unitFilter', sql.NVarChar, unitFilter.trim());
      deptSql += ` WHERE d.unitId = @unitFilter OR d.unitId IN (SELECT id FROM [Unit] WHERE LOWER(LTRIM(RTRIM(name))) = LOWER(LTRIM(RTRIM(@unitFilter))) OR id = @unitFilter)`;
    }
    deptSql += ` GROUP BY d.name ORDER BY d.name`;
    const deptRes = await deptReq.query(deptSql);

    // SGL / Team Performance Breakdown
    const sglReq = pool.request().input('month', sql.NVarChar, month);
    let sglSql = `
      SELECT 
        sgl.id AS sglId,
        sgl.name AS sglName,
        sgl.empCode AS sglEmpCode,
        un.name AS unitName,
        COUNT(DISTINCT u.id) AS totalEmployees,
        COUNT(DISTINCT CASE WHEN m.status IN ('submitted', 'evaluated') THEN m.id END) AS submittedCount,
        COUNT(DISTINCT CASE WHEN m.status = 'evaluated' THEN m.id END) AS evaluatedCount,
        ROUND(AVG(ar.score), 2) AS avgScore
      FROM [User] sgl
      JOIN [Role] sr ON sgl.roleId = sr.id AND sr.name = 'Senior Group Leader (SGL)'
      LEFT JOIN [Unit] un ON sgl.unitId = un.id
      LEFT JOIN [User] u ON (u.sglId = sgl.id OR u.sglId = sgl.empCode) AND u.isActive = 1 AND u.roleId IN (SELECT id FROM [Role] WHERE name IN ('Employee', 'Shop Floor Employee'))
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE sgl.isActive = 1
    `;
    if (!isGlobal) {
      sglReq.input('unitFilter', sql.NVarChar, unitFilter.trim());
      sglSql += ` AND (sgl.unitId = @unitFilter OR sgl.unitId IN (SELECT id FROM [Unit] WHERE LOWER(LTRIM(RTRIM(name))) = LOWER(LTRIM(RTRIM(@unitFilter))) OR id = @unitFilter))`;
    }
    sglSql += ` GROUP BY sgl.id, sgl.name, sgl.empCode, un.name ORDER BY un.name, sgl.name`;
    const sglRes = await sglReq.query(sglSql);

    return {
      kpi: {
        totalEmployees: kpi.totalEmployees || 0,
        submittedCount: kpi.submittedCount || 0,
        pendingReviewCount: kpi.pendingReviewCount || 0,
        evaluatedCount: kpi.evaluatedCount || 0,
        averageScore: kpi.averageScore || 0,
        submissionRate: kpi.totalEmployees > 0 ? Math.round(((kpi.submittedCount || 0) / kpi.totalEmployees) * 100) : 0,
        evaluationRate: kpi.submittedCount > 0 ? Math.round(((kpi.evaluatedCount || 0) / kpi.submittedCount) * 100) : 0,
      },
      units: unitRes.recordset,
      departments: deptRes.recordset,
      teams: sglRes.recordset,
    };
  },

  /* ---------------- sheet data support (permanent, yearly, monthly lifecycle) ---------------- */
  resolveSheetStorageKey(sheetId: string, cycle: string = '2026-10'): { storageKey: string, fallbackKey?: string } {
    const parts = String(cycle || '2026-10').trim().split('-');
    const year = parts[0] || '2026';
    const month = parts[1] || '10';

    // 1. About Myself: Permanent master profile record across all months and years (never resets)
    if (sheetId === 'frontpage') {
      return { storageKey: 'frontpage' };
    }

    // 2. SWOT Analysis: Resets every month (must be filled every month)
    if (sheetId === 'swot') {
      const monthlyKey = `swot_${year}_${month}`;
      const fallback = (year === '2026' && month === '10') ? 'swot' : undefined;
      return { storageKey: monthlyKey, fallbackKey: fallback };
    }

    // 3. All other sheets (lineperf, attendance, iip, training, keylearning, activities, selfdev, supervisor):
    // Saved across every month of the given year, resets yearly on year change
    const yearlyKey = `${sheetId}_${year}`;
    const fallback = (year === '2026') ? sheetId : undefined;
    return { storageKey: yearlyKey, fallbackKey: fallback };
  },

  async getSheetData(empCode: string, sheetId: string, cycle: string = '2026-10') {
    const { storageKey, fallbackKey } = this.resolveSheetStorageKey(sheetId, cycle);
    const pool = await getPool();

    // 1. Try primary storageKey
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .input('sheetId', sql.NVarChar, storageKey)
      .query(`
        SELECT s.data 
        FROM [SheetData] s
        JOIN [User] u ON s.empId = u.id
        WHERE u.empCode = @empCode AND s.sheetId = @sheetId
      `);

    let parsed: any = null;
    if (res.recordset.length > 0) {
      try { parsed = JSON.parse(res.recordset[0].data); } catch { parsed = null; }
    }

    // 2. Fallback to legacy unadorned key if applicable for baseline
    if (!parsed && fallbackKey && fallbackKey !== storageKey) {
      const fbRes = await pool.request()
        .input('empCode', sql.NVarChar, empCode)
        .input('sheetId', sql.NVarChar, fallbackKey)
        .query(`
          SELECT s.data 
          FROM [SheetData] s
          JOIN [User] u ON s.empId = u.id
          WHERE u.empCode = @empCode AND s.sheetId = @sheetId
        `);

      if (fbRes.recordset.length > 0) {
        try { parsed = JSON.parse(fbRes.recordset[0].data); } catch { parsed = null; }
      }
    }

    // 3. Auto-populate About Myself (frontpage) from User Master profile
    if (sheetId === 'frontpage') {
      const user = await this.getUserByEmpCode(empCode);
      if (user) {
        if (!parsed) parsed = {};
        if (!parsed.name && user.name) parsed.name = user.name;
        if (!parsed.father && user.fatherName) parsed.father = user.fatherName;
        if (!parsed.dob && user.dob) parsed.dob = user.dob;
        if (!parsed.doj && user.joiningDate) parsed.doj = user.joiningDate;
        if (!parsed.mobile && user.mobile) parsed.mobile = user.mobile;
        if (!parsed.email && user.email) parsed.email = user.email;
        if (!parsed.designation && user.designation) parsed.designation = user.designation;
        if (!parsed.groupDoj && user.groupJoiningDate) parsed.groupDoj = user.groupJoiningDate;
        if (!parsed.gradeCode && user.gradeCode) parsed.gradeCode = user.gradeCode;
        if (!parsed.empCode) parsed.empCode = user.empCode;
      }
    }

    // 4. Auto-populate & Synchronize Supervisor Remarks (sheet 10) from AssessmentReview evaluations
    if (sheetId === 'supervisor') {
      const user = await this.getUserByEmpCode(empCode);
      if (!parsed) {
        parsed = {
          name: user?.name || empCode,
          area: user?.departmentName || 'Operations',
          scores: {},
          signature: ''
        };
      }
      if (!parsed.name && user?.name) parsed.name = user.name;
      if (!parsed.area && user?.departmentName) parsed.area = user.departmentName;
      if (!parsed.scores) parsed.scores = {};

      const SUP_KEYS = [
        'Performance on the Job',
        'Attendance',
        'Work Performance',
        'Line Performance',
        'Recognition',
        'Documentation (Growth File)',
        'AHPS / LEAN Participation'
      ];

      for (const k of SUP_KEYS) {
        if (!parsed.scores[k] || !Array.isArray(parsed.scores[k])) {
          parsed.scores[k] = Array(12).fill('');
        }
      }

      try {
        const year = (cycle || '2026').split('-')[0];
        const revRes = await pool.request()
          .input('empCode', sql.NVarChar, empCode)
          .input('yearPrefix', sql.NVarChar, `${year}-%`)
          .query(`
            SELECT m.month, r.score, r.ratingGrade, r.criteriaScores, r.tlComments, u.name AS evaluatorName
            FROM [AssessmentReview] r
            JOIN [MonthlySubmission] m ON r.submissionId = m.id
            JOIN [User] eu ON m.empId = eu.id
            LEFT JOIN [User] u ON r.evaluatorId = u.id
            WHERE eu.empCode = @empCode AND m.month LIKE @yearPrefix
          `);

        for (const row of revRes.recordset) {
          const parts = String(row.month || '').split('-');
          const mNum = parseInt(parts[1] || '0', 10);
          if (mNum >= 1 && mNum <= 12) {
            const mi = mNum - 1;
            if (row.evaluatorName && !parsed.signature) {
              parsed.signature = row.evaluatorName;
            }
            let crit: any = null;
            try {
              crit = row.criteriaScores ? JSON.parse(row.criteriaScores) : null;
            } catch {}

            if (crit && typeof crit === 'object') {
              for (const k of SUP_KEYS) {
                const val = crit[k] ?? crit[k.toLowerCase()];
                if (val !== undefined && val !== null && val !== '') {
                  parsed.scores[k][mi] = val;
                }
              }
            }
          }
        }
      } catch (err) {
        console.warn('Error syncing supervisor sheet with AssessmentReview in getSheetData:', err);
      }
    }

    return parsed;
  },

  async setSheetData(empCode: string, sheetId: string, sheetContent: any, cycle: string = '2026-10') {
    const { storageKey, fallbackKey } = this.resolveSheetStorageKey(sheetId, cycle);
    const userId = await getOrCreateUserId(empCode, 'Employee');
    const pool = await getPool();
    const dataStr = JSON.stringify(sheetContent);

    // Upsert primary storageKey
    const existing = await pool.request()
      .input('empId', sql.NVarChar, userId)
      .input('sheetId', sql.NVarChar, storageKey)
      .query('SELECT id FROM [SheetData] WHERE empId = @empId AND sheetId = @sheetId');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('sheetId', sql.NVarChar, storageKey)
        .input('data', sql.VarChar(sql.MAX), dataStr)
        .query('UPDATE [SheetData] SET data = @data, updatedAt = SYSUTCDATETIME() WHERE empId = @empId AND sheetId = @sheetId');
    } else {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('sheetId', sql.NVarChar, storageKey)
        .input('data', sql.VarChar(sql.MAX), dataStr)
        .query(`
          INSERT INTO [SheetData] (id, empId, sheetId, data, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empId, @sheetId, @data, SYSUTCDATETIME())
        `);
    }

    // If there is a fallbackKey for baseline, also synchronize it
    if (fallbackKey && fallbackKey !== storageKey) {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('sheetId', sql.NVarChar, fallbackKey)
        .input('data', sql.VarChar(sql.MAX), dataStr)
        .query(`
          IF EXISTS (SELECT id FROM [SheetData] WHERE empId = @empId AND sheetId = @sheetId)
            UPDATE [SheetData] SET data = @data, updatedAt = SYSUTCDATETIME() WHERE empId = @empId AND sheetId = @sheetId
          ELSE
            INSERT INTO [SheetData] (id, empId, sheetId, data, updatedAt)
            VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empId, @sheetId, @data, SYSUTCDATETIME())
        `);
    }

    // When frontpage (About Myself) is saved, sync profile fields back to [User]
    if (sheetId === 'frontpage' && sheetContent) {
      try {
        await this.ensureUserExtraColumns();
        await pool.request()
          .input('empCode', sql.NVarChar, empCode)
          .input('name', sql.NVarChar, sheetContent.name ? String(sheetContent.name).trim() : null)
          .input('fatherName', sql.NVarChar, sheetContent.father ? String(sheetContent.father).trim() : null)
          .input('dob', sql.NVarChar, sheetContent.dob ? String(sheetContent.dob).trim() : null)
          .input('joiningDate', sql.NVarChar, sheetContent.doj ? String(sheetContent.doj).trim() : null)
          .input('mobile', sql.NVarChar, sheetContent.mobile ? String(sheetContent.mobile).trim() : null)
          .input('email', sql.NVarChar, sheetContent.email ? String(sheetContent.email).trim() : null)
          .input('designation', sql.NVarChar, sheetContent.designation ? String(sheetContent.designation).trim() : null)
          .input('groupJoiningDate', sql.NVarChar, sheetContent.groupDoj ? String(sheetContent.groupDoj).trim() : null)
          .input('gradeCode', sql.NVarChar, sheetContent.gradeCode ? String(sheetContent.gradeCode).trim() : null)
          .query(`
            UPDATE [User]
            SET name = COALESCE(@name, name),
                fatherName = COALESCE(@fatherName, fatherName),
                dob = COALESCE(@dob, dob),
                joiningDate = COALESCE(@joiningDate, joiningDate),
                mobile = COALESCE(@mobile, mobile),
                email = COALESCE(@email, email),
                designation = COALESCE(@designation, designation),
                groupJoiningDate = COALESCE(@groupJoiningDate, groupJoiningDate),
                gradeCode = COALESCE(@gradeCode, gradeCode),
                updatedAt = SYSUTCDATETIME()
            WHERE empCode = @empCode
          `);
      } catch (err) {
        console.warn('Sync frontpage to User failed:', err);
      }
    }
  },

  /* ---------------- monthly submissions ---------------- */
  async upsertSubmission(empCode: string, month: string, selfScore?: number) {
    const userId = await getOrCreateUserId(empCode, 'Employee');
    const pool = await getPool();

    // Ensure cycle exists in AssessmentCycle
    try {
      await pool.request()
        .input('cycMonth', sql.NVarChar, month)
        .input('cycTitle', sql.NVarChar, `${month} Assessment Cycle`)
        .query(`
          IF NOT EXISTS (SELECT 1 FROM [AssessmentCycle] WHERE month = @cycMonth)
            INSERT INTO [AssessmentCycle] (id, month, title, status, startDate, endDate, createdAt)
            VALUES (CAST(NEWID() AS NVARCHAR(1000)), @cycMonth, @cycTitle, 'open', SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    } catch (e) {}

    const existing = await pool.request()
      .input('empId', sql.NVarChar, userId)
      .input('month', sql.NVarChar, month)
      .query('SELECT id FROM [MonthlySubmission] WHERE empId = @empId AND month = @month');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('month', sql.NVarChar, month)
        .input('selfScore', sql.Decimal(4, 2), selfScore ?? null)
        .query(`
          UPDATE [MonthlySubmission] 
          SET status = 'submitted', 
              selfScore = COALESCE(@selfScore, selfScore),
              submittedAt = SYSUTCDATETIME(), 
              updatedAt = SYSUTCDATETIME() 
          WHERE empId = @empId AND month = @month
        `);
    } else {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('month', sql.NVarChar, month)
        .input('selfScore', sql.Decimal(4, 2), selfScore ?? null)
        .query(`
          INSERT INTO [MonthlySubmission] (id, empId, month, status, selfScore, submittedAt, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empId, @month, 'submitted', @selfScore, SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    }
  },

  async getSubmission(empCode: string, month: string) {
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT m.id, m.month, m.status, m.selfScore, m.submittedAt, u.empCode
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        WHERE u.empCode = @empCode AND m.month = @month
      `);

    if (res.recordset.length === 0) return null;
    const row = res.recordset[0];
    return {
      id: row.id,
      empId: row.empCode,
      month: row.month,
      status: row.status,
      selfScore: row.selfScore,
      submittedAt: row.submittedAt,
    };
  },

  async listSubmissions(userContext?: { role: string; userId: string; empCode?: string | null; unitId?: string | null; month?: string | null }) {
    const pool = await getPool();
    const request = pool.request();
    let query = `
      SELECT 
        m.id, 
        m.month, 
        m.status, 
        m.selfScore, 
        m.submittedAt, 
        u.empCode, 
        u.name, 
        un.name AS unitName,
        d.name AS departmentName,
        ar.score AS tlScore,
        ar.ratingGrade,
        ar.tlComments
      FROM [MonthlySubmission] m
      JOIN [User] u ON m.empId = u.id
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE 1=1
    `;

    if (userContext) {
      if (userContext.role === 'Team Leader (TL)') {
        request.input('tlId', sql.NVarChar, userContext.userId);
        request.input('tlEmpCode', sql.NVarChar, (userContext as any).empCode || userContext.userId);
        query += ` AND (u.tlId = @tlId OR u.tlId = @tlEmpCode)`;
        if (userContext.unitId) {
          request.input('unitId', sql.NVarChar, userContext.unitId);
          query += ` AND u.unitId = @unitId`;
        }
      } else if (userContext.role === 'Senior Group Leader (SGL)') {
        request.input('sglId', sql.NVarChar, userContext.userId);
        request.input('sglEmpCode', sql.NVarChar, (userContext as any).empCode || userContext.userId);
        query += ` AND (u.sglId = @sglId OR u.sglId = @sglEmpCode)`;
        if (userContext.unitId) {
          request.input('unitId', sql.NVarChar, userContext.unitId);
          query += ` AND u.unitId = @unitId`;
        }
      } else if (userContext.role === 'Unit Admin' && userContext.unitId) {
        request.input('unitId', sql.NVarChar, userContext.unitId);
        query += ` AND u.unitId = @unitId`;
      }

      if ((userContext as any).month) {
        request.input('subMonth', sql.NVarChar, (userContext as any).month);
        query += ` AND m.month = @subMonth`;
      }
    }

    query += ` ORDER BY m.submittedAt DESC`;
    const res = await request.query(query);

    return res.recordset.map((row: any) => ({
      id: row.id,
      empId: row.empCode,
      name: row.name,
      unitName: row.unitName,
      departmentName: row.departmentName,
      month: row.month,
      status: row.status,
      selfScore: row.selfScore,
      submittedAt: row.submittedAt,
      tlScore: row.tlScore,
      ratingGrade: row.ratingGrade,
      tlComments: row.tlComments,
    }));
  },

  async markReviewed(empCode: string) {
    const pool = await getPool();
    await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .query(`
        UPDATE m
        SET m.status = 'reviewed', m.updatedAt = SYSUTCDATETIME()
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        WHERE u.empCode = @empCode AND m.status <> 'reviewed'
      `);
  },

  /* ---------------- admin export ---------------- */
  async exportAll() {
    const pool = await getPool();
    const usersRes = await pool.request().query(`
      SELECT u.empCode, u.name, u.createdAt, r.name as roleName, un.name as unitName, d.name as departmentName
      FROM [User] u
      LEFT JOIN [Role] r ON u.roleId = r.id
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
    `);

    const sheetsRes = await pool.request().query(`
      SELECT u.empCode, s.sheetId, s.data
      FROM [SheetData] s
      JOIN [User] u ON s.empId = u.id
    `);

    const subsRes = await pool.request().query(`
      SELECT u.empCode, m.month, m.status, m.selfScore, m.submittedAt, ar.score AS tlScore, ar.ratingGrade, ar.tlComments
      FROM [MonthlySubmission] m
      JOIN [User] u ON m.empId = u.id
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
    `);

    return {
      users: usersRes.recordset,
      sheets: sheetsRes.recordset,
      submissions: subsRes.recordset,
    };
  },

  /* ---------------- super admin management & audit ---------------- */
  async getAllUsersForAdmin(filters: { unit?: string; role?: string; status?: string; month?: string } = {}) {
    const pool = await getPool();
    const month = filters.month || '2026-10';
    const request = pool.request().input('month', sql.NVarChar, month);

    let query = `
      SELECT 
        u.id,
        u.empCode,
        u.name,
        u.isActive,
        u.createdAt,
        u.fatherName,
        u.mobile,
        u.email,
        u.joiningDate,
        u.dob,
        u.designation,
        u.groupJoiningDate,
        u.gradeCode,
        r.name AS roleName,
        r.id AS roleId,
        un.id AS unitId,
        un.name AS unitName,
        un.code AS unitCode,
        d.id AS departmentId,
        d.name AS departmentName,
        tl.id AS tlId,
        tl.name AS tlName,
        tl.empCode AS tlCode,
        sgl.id AS sglId,
        sgl.name AS sglName,
        sgl.empCode AS sglCode,
        m.id AS submissionId,
        ISNULL(m.status, 'not_started') AS submissionStatus,
        m.selfScore,
        m.submittedAt,
        ar.score AS tlScore,
        ar.ratingGrade,
        ar.tlComments,
        ar.sglRemarks,
        ar.reviewedAt,
        ar.criteriaScores
      FROM [User] u
      LEFT JOIN [Role] r ON u.roleId = r.id
      LEFT JOIN [Unit] un ON u.unitId = un.id
      LEFT JOIN [Department] d ON u.departmentId = d.id
      LEFT JOIN [User] tl ON u.tlId = tl.id
      LEFT JOIN [User] sgl ON u.sglId = sgl.id
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE 1=1
    `;

    if (filters.unit && filters.unit !== 'all') {
      request.input('unitFilter', sql.NVarChar, filters.unit);
      query += ` AND (u.unitId = @unitFilter OR un.name = @unitFilter)`;
    }

    if (filters.role && filters.role !== 'all') {
      if (filters.role === 'Employee' || filters.role === 'Shop Floor Employee') {
        query += ` AND (r.name = 'Employee' OR r.name = 'Shop Floor Employee')`;
      } else {
        request.input('roleFilter', sql.NVarChar, filters.role);
        query += ` AND (r.name = @roleFilter)`;
      }
    }

    if (filters.status === 'active') {
      query += ` AND u.isActive = 1`;
    } else if (filters.status === 'inactive') {
      query += ` AND u.isActive = 0`;
    }

    query += `
      ORDER BY 
        CASE r.name 
          WHEN 'Super Admin' THEN 1
          WHEN 'HR Head' THEN 2
          WHEN 'Unit Admin' THEN 3
          WHEN 'Senior Group Leader (SGL)' THEN 4
          WHEN 'Team Leader (TL)' THEN 5
          WHEN 'Employee' THEN 6
          WHEN 'Shop Floor Employee' THEN 6
          ELSE 7
        END,
        un.name, u.empCode
    `;

    const res = await request.query(query);
    return res.recordset.map((row: any) => ({
      ...row,
      roleName: row.roleName === 'Shop Floor Employee' ? 'Employee' : row.roleName,
    }));
  },

  async getAdminMetadata() {
    const pool = await getPool();
    const [units, depts, roles, tls, sgls] = await Promise.all([
      pool.request().query('SELECT id, name, code, isActive FROM [Unit] ORDER BY name'),
      pool.request().query('SELECT d.id, d.name, d.unitId, u.name AS unitName FROM [Department] d JOIN [Unit] u ON d.unitId = u.id ORDER BY u.name, d.name'),
      pool.request().query('SELECT id, name FROM [Role] ORDER BY name'),
      pool.request().query(`
        SELECT u.id, u.empCode, u.name, u.unitId, un.name AS unitName 
        FROM [User] u
        JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [Unit] un ON u.unitId = un.id
        WHERE r.name = 'Team Leader (TL)' AND u.isActive = 1
        ORDER BY u.name
      `),
      pool.request().query(`
        SELECT u.id, u.empCode, u.name, u.unitId, un.name AS unitName 
        FROM [User] u
        JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [Unit] un ON u.unitId = un.id
        WHERE r.name = 'Senior Group Leader (SGL)' AND u.isActive = 1
        ORDER BY u.name
      `),
    ]);

    return {
      units: units.recordset,
      departments: depts.recordset,
      roles: roles.recordset.map((r: any) => ({
        ...r,
        name: r.name === 'Shop Floor Employee' ? 'Employee' : r.name,
      })),
      teamLeaders: tls.recordset,
      seniorGroupLeaders: sgls.recordset,
    };
  },

  async toggleUserActive(empCode: string) {
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode.trim().toUpperCase())
      .query(`
        UPDATE [User]
        SET isActive = CASE WHEN isActive = 1 THEN 0 ELSE 1 END,
            updatedAt = SYSUTCDATETIME()
        OUTPUT inserted.isActive, inserted.empCode, inserted.name
        WHERE empCode = @empCode
      `);
    return res.recordset.length > 0 ? res.recordset[0] : null;
  },

  /* ---------------- assessment cycles ---------------- */
  async ensureAssessmentCycles() {
    try {
      const pool = await getPool();
      const res = await pool.request().query('SELECT month FROM [AssessmentCycle]');
      const existing = new Set(res.recordset.map((r: any) => r.month));

      const now = new Date();
      const currentYear = now.getFullYear();
      const monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];

      const startYear = Math.min(2025, currentYear - 1);
      const endYear = Math.max(2027, currentYear + 1);

      for (let y = startYear; y <= endYear; y++) {
        for (let m = 0; m < 12; m++) {
          const monthStr = `${y}-${String(m + 1).padStart(2, '0')}`;
          if (!existing.has(monthStr)) {
            const title = `${monthNames[m]} ${y} Assessment Cycle`;
            const lastDay = new Date(y, m + 1, 0).getDate();
            const startDate = `${monthStr}-01`;
            const endDate = `${monthStr}-${String(lastDay).padStart(2, '0')}`;
            try {
              await pool.request()
                .input('month', sql.NVarChar, monthStr)
                .input('title', sql.NVarChar, title)
                .input('status', sql.NVarChar, 'open')
                .input('start', sql.DateTime2, new Date(startDate))
                .input('end', sql.DateTime2, new Date(endDate))
                .query(`
                  IF NOT EXISTS (SELECT 1 FROM [AssessmentCycle] WHERE month = @month)
                    INSERT INTO [AssessmentCycle] (id, month, title, status, startDate, endDate, createdAt)
                    VALUES (CAST(NEWID() AS NVARCHAR(1000)), @month, @title, @status, @start, @end, SYSUTCDATETIME())
                `);
              existing.add(monthStr);
            } catch (e) {}
          }
        }
      }
    } catch (err) {
      console.warn('Error in ensureAssessmentCycles:', err);
    }
  },

  async listAssessmentCycles() {
    await this.ensureAssessmentCycles();
    const pool = await getPool();
    const res = await pool.request().query(`
      SELECT id, month, title, status, startDate, endDate, createdAt
      FROM [AssessmentCycle]
      ORDER BY month DESC
    `);
    return res.recordset;
  },

  async upsertAssessmentCycle(month: string, title: string, status = 'open', startDate?: string, endDate?: string) {
    const pool = await getPool();
    const existing = await pool.request()
      .input('month', sql.NVarChar, month)
      .query('SELECT id FROM [AssessmentCycle] WHERE month = @month');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('month', sql.NVarChar, month)
        .input('title', sql.NVarChar, title)
        .input('status', sql.NVarChar, status)
        .input('start', sql.DateTime2, startDate ? new Date(startDate) : null)
        .input('end', sql.DateTime2, endDate ? new Date(endDate) : null)
        .query(`
          UPDATE [AssessmentCycle]
          SET title = @title,
              status = @status,
              startDate = COALESCE(@start, startDate),
              endDate = COALESCE(@end, endDate)
          WHERE month = @month
        `);
      return { ok: true, action: 'updated', month };
    } else {
      await pool.request()
        .input('month', sql.NVarChar, month)
        .input('title', sql.NVarChar, title)
        .input('status', sql.NVarChar, status)
        .input('start', sql.DateTime2, startDate ? new Date(startDate) : null)
        .input('end', sql.DateTime2, endDate ? new Date(endDate) : null)
        .query(`
          INSERT INTO [AssessmentCycle] (id, month, title, status, startDate, endDate, createdAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @month, @title, @status, @start, @end, SYSUTCDATETIME())
        `);
      return { ok: true, action: 'created', month };
    }
  },

  /* ---------------- master training matrix & activities catalog ---------------- */
  async ensureMasterItemTable() {
    try {
      const pool = await getPool();
      await pool.request().query(`
        IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = N'MasterItem')
        BEGIN
          CREATE TABLE [dbo].[MasterItem] (
            [id] NVARCHAR(1000) NOT NULL,
            [type] NVARCHAR(50) NOT NULL,
            [title] NVARCHAR(500) NOT NULL,
            [category] NVARCHAR(100) NULL,
            [sortOrder] INT NOT NULL DEFAULT 0,
            [isActive] BIT NOT NULL DEFAULT 1,
            [createdAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
            [updatedAt] DATETIME2 NOT NULL DEFAULT CURRENT_TIMESTAMP,
            CONSTRAINT [MasterItem_pkey] PRIMARY KEY CLUSTERED ([id])
          );
        END
      `);

      const trCount = await pool.request().query("SELECT COUNT(*) AS cnt FROM [MasterItem] WHERE [type] = 'training'");
      if ((trCount.recordset[0]?.cnt || 0) === 0) {
        for (let i = 0; i < DEFAULT_TRAINING_ITEMS.length; i++) {
          const title = DEFAULT_TRAINING_ITEMS[i];
          await pool.request()
            .input('type', sql.NVarChar, 'training')
            .input('title', sql.NVarChar, title)
            .input('sortOrder', sql.Int, i + 1)
            .query(`
              INSERT INTO [MasterItem] (id, type, title, sortOrder, isActive, createdAt, updatedAt)
              VALUES (CAST(NEWID() AS NVARCHAR(1000)), @type, @title, @sortOrder, 1, SYSUTCDATETIME(), SYSUTCDATETIME())
            `);
        }
      }

      const acCount = await pool.request().query("SELECT COUNT(*) AS cnt FROM [MasterItem] WHERE [type] = 'activity'");
      if ((acCount.recordset[0]?.cnt || 0) === 0) {
        for (let i = 0; i < DEFAULT_ACTIVITY_ITEMS.length; i++) {
          const title = DEFAULT_ACTIVITY_ITEMS[i];
          await pool.request()
            .input('type', sql.NVarChar, 'activity')
            .input('title', sql.NVarChar, title)
            .input('sortOrder', sql.Int, i + 1)
            .query(`
              INSERT INTO [MasterItem] (id, type, title, sortOrder, isActive, createdAt, updatedAt)
              VALUES (CAST(NEWID() AS NVARCHAR(1000)), @type, @title, @sortOrder, 1, SYSUTCDATETIME(), SYSUTCDATETIME())
            `);
        }
      }
    } catch (err) {
      console.warn('Notice in ensureMasterItemTable:', err);
    }
  },

  async listMasterItems() {
    try {
      await this.ensureMasterItemTable();
      const pool = await getPool();
      const res = await pool.request().query(`
        SELECT id, type, title, category, sortOrder, isActive, createdAt, updatedAt
        FROM [MasterItem]
        WHERE isActive = 1
        ORDER BY sortOrder ASC, createdAt ASC
      `);

      const trainings = res.recordset.filter((r: any) => r.type === 'training');
      const activities = res.recordset.filter((r: any) => r.type === 'activity');

      return {
        trainings: trainings.length ? trainings : DEFAULT_TRAINING_ITEMS.map((t, i) => ({ id: `default-tr-${i}`, type: 'training', title: t, sortOrder: i + 1 })),
        activities: activities.length ? activities : DEFAULT_ACTIVITY_ITEMS.map((a, i) => ({ id: `default-ac-${i}`, type: 'activity', title: a, sortOrder: i + 1 })),
      };
    } catch (err) {
      console.warn('Fallback in listMasterItems:', err);
      return {
        trainings: DEFAULT_TRAINING_ITEMS.map((t, i) => ({ id: `default-tr-${i}`, type: 'training', title: t, sortOrder: i + 1 })),
        activities: DEFAULT_ACTIVITY_ITEMS.map((a, i) => ({ id: `default-ac-${i}`, type: 'activity', title: a, sortOrder: i + 1 })),
      };
    }
  },

  async addMasterItem(type: 'training' | 'activity', title: string, category?: string) {
    await this.ensureMasterItemTable();
    const cleanTitle = String(title).trim();
    if (!cleanTitle) throw new Error('Title cannot be empty.');

    const pool = await getPool();

    const existing = await pool.request()
      .input('type', sql.NVarChar, type)
      .input('title', sql.NVarChar, cleanTitle)
      .query('SELECT TOP 1 id, isActive FROM [MasterItem] WHERE type = @type AND title = @title');

    if (existing.recordset.length > 0) {
      const row = existing.recordset[0];
      if (!row.isActive) {
        await pool.request()
          .input('id', sql.NVarChar, row.id)
          .query('UPDATE [MasterItem] SET isActive = 1, updatedAt = SYSUTCDATETIME() WHERE id = @id');
        return { ok: true, action: 'reactivated', id: row.id, title: cleanTitle, type };
      }
      throw new Error(`"${cleanTitle}" already exists in ${type === 'training' ? 'Training Matrix' : 'Activities'}.`);
    }

    const sortRes = await pool.request()
      .input('type', sql.NVarChar, type)
      .query('SELECT COALESCE(MAX(sortOrder), 0) + 1 AS nextSort FROM [MasterItem] WHERE type = @type');
    const nextSort = sortRes.recordset[0]?.nextSort || 1;

    const insertRes = await pool.request()
      .input('type', sql.NVarChar, type)
      .input('title', sql.NVarChar, cleanTitle)
      .input('category', sql.NVarChar, category || null)
      .input('sortOrder', sql.Int, nextSort)
      .query(`
        DECLARE @newId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
        INSERT INTO [MasterItem] (id, type, title, category, sortOrder, isActive, createdAt, updatedAt)
        VALUES (@newId, @type, @title, @category, @sortOrder, 1, SYSUTCDATETIME(), SYSUTCDATETIME());
        SELECT @newId AS id;
      `);

    return {
      ok: true,
      success: true,
      action: 'created',
      id: insertRes.recordset[0].id,
      type,
      title: cleanTitle,
      sortOrder: nextSort,
    };
  },

  async deleteMasterItem(id: string, type?: string, title?: string) {
    await this.ensureMasterItemTable();
    const pool = await getPool();

    let query = 'DELETE FROM [MasterItem] WHERE id = @id';
    const req = pool.request().input('id', sql.NVarChar, id);

    if (type && title) {
      req.input('type', sql.NVarChar, type);
      req.input('title', sql.NVarChar, title);
      query += ' OR (type = @type AND title = @title)';
    }

    await req.query(query);
    return { ok: true, success: true, action: 'deleted', id };
  },
};

export default store;
