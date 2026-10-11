import { getPool, sql } from './mssql';

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
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, id)
      .query('SELECT name FROM [User] WHERE empCode = @empCode');

    if (res.recordset.length > 0 && res.recordset[0].name) {
      return res.recordset[0].name;
    }
    return id;
  },

  /* ---------------- supervisors ---------------- */
  async getSupervisor(id: string) {
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, id)
      .query('SELECT passwordHash, createdAt FROM [User] WHERE empCode = @empCode');

    if (res.recordset.length === 0) return null;
    return {
      passwordHash: res.recordset[0].passwordHash,
      createdAt: res.recordset[0].createdAt,
    };
  },

  async upsertSupervisor(id: string, passwordHash: string) {
    const pool = await getPool();
    const roleId = await getRoleId('Team Leader (TL)');

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

  /* ---------------- sheet data ---------------- */
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
  async upsertSubmission(empCode: string, month: string) {
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
        .query(`
          UPDATE [MonthlySubmission] 
          SET status = 'submitted', submittedAt = SYSUTCDATETIME(), updatedAt = SYSUTCDATETIME() 
          WHERE empId = @empId AND month = @month
        `);
    } else {
      await pool.request()
        .input('empId', sql.NVarChar, userId)
        .input('month', sql.NVarChar, month)
        .query(`
          INSERT INTO [MonthlySubmission] (id, empId, month, status, submittedAt, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empId, @month, 'submitted', SYSUTCDATETIME(), SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
    }
  },

  async getSubmission(empCode: string, month: string) {
    const pool = await getPool();
    const res = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .input('month', sql.NVarChar, month)
      .query(`
        SELECT m.month, m.status, m.submittedAt, u.empCode
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        WHERE u.empCode = @empCode AND m.month = @month
      `);

    if (res.recordset.length === 0) return null;
    const row = res.recordset[0];
    return {
      empId: row.empCode,
      month: row.month,
      status: row.status,
      submittedAt: row.submittedAt,
    };
  },

  async listSubmissions() {
    const pool = await getPool();
    const res = await pool.request().query(`
      SELECT m.month, m.status, m.submittedAt, u.empCode
      FROM [MonthlySubmission] m
      JOIN [User] u ON m.empId = u.id
      ORDER BY m.submittedAt DESC
    `);

    return res.recordset.map((row: any) => ({
      empId: row.empCode,
      month: row.month,
      status: row.status,
      submittedAt: row.submittedAt,
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
      SELECT u.empCode, u.name, u.createdAt, r.name as roleName
      FROM [User] u
      LEFT JOIN [Role] r ON u.roleId = r.id
    `);

    const sheetsRes = await pool.request().query(`
      SELECT u.empCode, s.sheetId, s.data
      FROM [SheetData] s
      JOIN [User] u ON s.empId = u.id
    `);

    const subsRes = await pool.request().query(`
      SELECT u.empCode, m.month, m.status, m.submittedAt
      FROM [MonthlySubmission] m
      JOIN [User] u ON m.empId = u.id
    `);

    const employees: any = {};
    const supervisors: any = {};

    usersRes.recordset.forEach((u: any) => {
      if (u.roleName === 'Shop Floor Employee') {
        employees[u.empCode] = { name: u.name, createdAt: u.createdAt };
      } else {
        supervisors[u.empCode] = { createdAt: u.createdAt };
      }
    });

    const sheetData: any = {};
    sheetsRes.recordset.forEach((s: any) => {
      if (!sheetData[s.empCode]) sheetData[s.empCode] = {};
      try {
        sheetData[s.empCode][s.sheetId] = JSON.parse(s.data);
      } catch {
        sheetData[s.empCode][s.sheetId] = null;
      }
    });

    const subs: any = {};
    subsRes.recordset.forEach((s: any) => {
      subs[`${s.empCode}::${s.month}`] = {
        empId: s.empCode,
        month: s.month,
        status: s.status,
        submittedAt: s.submittedAt,
      };
    });

    return { employees, supervisors, sheetData, submissions: subs };
  },
};

export default store;
