import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getPool, sql } from '@/lib/mssql';
import { getSession } from '@/lib/session';
import bcrypt from 'bcryptjs';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
  }

  const exact = session.exactRole || session.role;
  const isSuperAdmin = exact === 'Super Admin' || exact === 'HR Head';
  const isUnitAdmin = exact === 'Unit Admin';

  if (!isSuperAdmin && !isUnitAdmin) {
    return NextResponse.json({ error: 'Access restricted to administrators.' }, { status: 403 });
  }

  const url = new URL(req.url);
  let unitFilter = url.searchParams.get('unit') || 'all';
  const month = url.searchParams.get('month') || '2026-10';

  // Unit Admin is strictly locked to their assigned unit
  if (isUnitAdmin) {
    unitFilter = session.unitId || 'all';
  }

  const employees = await store.getAllEmployees(unitFilter, month);
  return NextResponse.json({ ok: true, count: employees.length, users: employees });
}

export async function POST(req: Request) {
  const session = await getSession();
  if (!session || (session.role !== 'Super Admin' && session.role !== 'Unit Admin')) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const { empCode, name, roleName, unitId, departmentId, tlId, sglId, password } = body;

    if (!empCode || !name || !roleName) {
      return NextResponse.json({ error: 'empCode, name, and roleName are required.' }, { status: 400 });
    }

    const codeUpper = String(empCode).trim().toUpperCase();

    // Unit Admin can only create users in their own unit
    let targetUnitId = unitId;
    if (session.role === 'Unit Admin') {
      targetUnitId = session.unitId;
    }

    const pool = await getPool();

    // Get role id
    const roleRes = await pool.request()
      .input('name', sql.NVarChar, roleName)
      .query('SELECT id FROM [Role] WHERE name = @name');

    if (roleRes.recordset.length === 0) {
      return NextResponse.json({ error: `Role '${roleName}' not found.` }, { status: 400 });
    }
    const roleId = roleRes.recordset[0].id;

    // Password hash if password provided
    let passwordHash = null;
    if (password) {
      passwordHash = bcrypt.hashSync(String(password).trim(), 10);
    }

    // Upsert user
    const existing = await pool.request()
      .input('empCode', sql.NVarChar, codeUpper)
      .query('SELECT id FROM [User] WHERE empCode = @empCode');

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('name', sql.NVarChar, name)
        .input('roleId', sql.NVarChar, roleId)
        .input('unitId', sql.NVarChar, targetUnitId || null)
        .input('departmentId', sql.NVarChar, departmentId || null)
        .input('tlId', sql.NVarChar, tlId || null)
        .input('sglId', sql.NVarChar, sglId || null)
        .input('passwordHash', sql.NVarChar, passwordHash)
        .query(`
          UPDATE [User]
          SET name = @name,
              roleId = @roleId,
              unitId = @unitId,
              departmentId = @departmentId,
              tlId = @tlId,
              sglId = @sglId,
              passwordHash = COALESCE(@passwordHash, passwordHash),
              updatedAt = SYSUTCDATETIME()
          WHERE empCode = @empCode
        `);
      return NextResponse.json({ ok: true, message: 'User updated successfully.', empCode: codeUpper });
    } else {
      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('name', sql.NVarChar, name)
        .input('roleId', sql.NVarChar, roleId)
        .input('unitId', sql.NVarChar, targetUnitId || null)
        .input('departmentId', sql.NVarChar, departmentId || null)
        .input('tlId', sql.NVarChar, tlId || null)
        .input('sglId', sql.NVarChar, sglId || null)
        .input('passwordHash', sql.NVarChar, passwordHash)
        .query(`
          INSERT INTO [User] (id, empCode, name, roleId, unitId, departmentId, tlId, sglId, passwordHash, isActive, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empCode, @name, @roleId, @unitId, @departmentId, @tlId, @sglId, @passwordHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
      return NextResponse.json({ ok: true, message: 'User created successfully.', empCode: codeUpper });
    }
  } catch (err: any) {
    console.error('Error in /api/admin/users:', err);
    return NextResponse.json({ error: err.message || 'Internal server error.' }, { status: 500 });
  }
}
