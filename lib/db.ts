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

async function getRoleId(roleName: string): Promise<string> {
  const pool = await getPool();
  const res = await pool.request()
    .input('name', sql.NVarChar, roleName)
    .query('SELECT id FROM [Role] WHERE name = @name');

  if (res.recordset.length > 0) {
    return res.recordset[0].id;
  }

  const insertRes = await pool.request()
    .input('name', sql.NVarChar, roleName)
    .query(`
      DECLARE @newId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
      INSERT INTO [Role] (id, name) VALUES (@newId, @name);
      SELECT @newId AS id;
    `);

  return insertRes.recordset[0].id;
}

async function getOrCreateUserId(empCode: string, defaultRole = 'Shop Floor Employee'): Promise<string> {
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
  async getUserByEmpCode(empCode: string): Promise<any | null> {
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

    return res.recordset.length > 0 ? res.recordset[0] : null;
  },

  async upsertEmployeeIfMissing(id: string) {
    await getOrCreateUserId(id, 'Shop Floor Employee');
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
      const roleId = await getRoleId('Shop Floor Employee');
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

  /* ---------------- units & departments ---------------- */
  async listUnits() {
    const pool = await getPool();
    const res = await pool.request().query('SELECT id, name, code, isActive FROM [Unit] ORDER BY name');
    return res.recordset;
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
  async getAssignedEmployeesForTL(tlUserId: string, month = '2026-10') {
    const pool = await getPool();
    const res = await pool.request()
      .input('tlId', sql.NVarChar, tlUserId)
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT 
          u.id,
          u.empCode,
          u.name,
          un.name AS unitName,
          d.name AS departmentName,
          m.id AS submissionId,
          ISNULL(m.status, 'not_started') AS submissionStatus,
          m.selfScore,
          m.submittedAt,
          ar.score AS tlScore,
          ar.ratingGrade,
          ar.tlComments,
          ar.reviewedAt
        FROM [User] u
        LEFT JOIN [Unit] un ON u.unitId = un.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        WHERE u.tlId = @tlId AND u.isActive = 1
        ORDER BY u.empCode
      `);
    return res.recordset;
  },

  async getTeamForSGL(sglUserId: string, month = '2026-10') {
    const pool = await getPool();
    const res = await pool.request()
      .input('sglId', sql.NVarChar, sglUserId)
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT 
          u.id,
          u.empCode,
          u.name,
          tl.name AS tlName,
          un.name AS unitName,
          d.name AS departmentName,
          m.id AS submissionId,
          ISNULL(m.status, 'not_started') AS submissionStatus,
          m.selfScore,
          ar.score AS tlScore,
          ar.ratingGrade,
          ar.tlComments,
          ar.sglRemarks,
          ar.reviewedAt
        FROM [User] u
        LEFT JOIN [User] tl ON u.tlId = tl.id
        LEFT JOIN [Unit] un ON u.unitId = un.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        WHERE u.sglId = @sglId AND u.isActive = 1
        ORDER BY tl.name, u.empCode
      `);
    return res.recordset;
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
      WHERE u.isActive = 1 AND r.name = 'Shop Floor Employee'
    `;

    if (unitFilter && unitFilter !== 'all') {
      request.input('unitFilter', sql.NVarChar, unitFilter);
      query += ` AND (u.unitId = @unitFilter OR un.name = @unitFilter)`;
    }

    query += ` ORDER BY un.name, d.name, u.empCode`;
    const res = await request.query(query);
    return res.recordset;
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
      JOIN [Role] r ON u.roleId = r.id AND r.name = 'Shop Floor Employee'
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
      WHERE u.isActive = 1
    `;

    if (!isGlobal) {
      reqKpi.input('unitFilter', sql.NVarChar, unitFilter);
      kpiSql += ` AND (u.unitId = @unitFilter OR u.unitId IN (SELECT id FROM [Unit] WHERE name = @unitFilter))`;
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
        LEFT JOIN [User] u ON un.id = u.unitId AND u.isActive = 1 AND u.roleId IN (SELECT id FROM [Role] WHERE name = 'Shop Floor Employee')
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
      JOIN [User] u ON d.id = u.departmentId AND u.isActive = 1 AND u.roleId IN (SELECT id FROM [Role] WHERE name = 'Shop Floor Employee')
      LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
      LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
    `;
    if (!isGlobal) {
      deptReq.input('unitFilter', sql.NVarChar, unitFilter);
      deptSql += ` WHERE d.unitId = @unitFilter OR d.unitId IN (SELECT id FROM [Unit] WHERE name = @unitFilter)`;
    }
    deptSql += ` GROUP BY d.name ORDER BY d.name`;
    const deptRes = await deptReq.query(deptSql);

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
    };
  },

  /* ---------------- legacy sheet data support ---------------- */
  async getSheetData(empCode: string, sheetId: string) {
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .input('sheetId', sql.NVarChar, sheetId)
      .query(`
        SELECT s.data 
        FROM [SheetData] s
        JOIN [User] u ON s.empId = u.id
        WHERE u.empCode = @empCode AND s.sheetId = @sheetId
      `);

    if (res.recordset.length === 0) return null;
    try {
      return JSON.parse(res.recordset[0].data);
    } catch {
      return null;
    }
  },

  async setSheetData(empCode: string, sheetId: string, sheetContent: any) {
    const userId = await getOrCreateUserId(empCode, 'Shop Floor Employee');
    const pool = await getPool();
    const dataStr = JSON.stringify(sheetContent);

    const existing = await pool.request()
      .input('empId', sql.NVarChar, userId)
      .input('sheetId', sql.NVarChar, sheetId)
      .query('SELECT id FROM [SheetData] WHERE empId = @empId AND sheetId = @sheetId');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('sheetId', sql.NVarChar, sheetId)
        .input('data', sql.VarChar(sql.MAX), dataStr)
        .query('UPDATE [SheetData] SET data = @data, updatedAt = SYSUTCDATETIME() WHERE empId = @empId AND sheetId = @sheetId');
    } else {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('sheetId', sql.NVarChar, sheetId)
        .input('data', sql.VarChar(sql.MAX), dataStr)
        .query(`
          INSERT INTO [SheetData] (id, empId, sheetId, data, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empId, @sheetId, @data, SYSUTCDATETIME())
        `);
    }
  },

  /* ---------------- monthly submissions ---------------- */
  async upsertSubmission(empCode: string, month: string, selfScore?: number) {
    const userId = await getOrCreateUserId(empCode, 'Shop Floor Employee');
    const pool = await getPool();

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

  async listSubmissions(userContext?: { role: string; userId: string; unitId?: string | null }) {
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
        query += ` AND u.tlId = @tlId`;
      } else if (userContext.role === 'Senior Group Leader (SGL)') {
        request.input('sglId', sql.NVarChar, userContext.userId);
        query += ` AND u.sglId = @sglId`;
      } else if (userContext.role === 'Unit Admin' && userContext.unitId) {
        request.input('unitId', sql.NVarChar, userContext.unitId);
        query += ` AND u.unitId = @unitId`;
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
};

export default store;
