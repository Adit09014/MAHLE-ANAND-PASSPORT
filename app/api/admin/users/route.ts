import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getPool, sql } from '@/lib/mssql';
import { getSession } from '@/lib/session';
import bcrypt from 'bcryptjs';

// GET /api/admin/users
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
  const roleFilter = url.searchParams.get('role') || 'all';
  const statusFilter = url.searchParams.get('status') || 'all';
  const month = url.searchParams.get('month') || '2026-10';

  // Unit Admin is strictly locked to their assigned unit
  if (isUnitAdmin) {
    unitFilter = session.unitId || 'all';
  }

  const users = await store.getAllUsersForAdmin({
    unit: unitFilter,
    role: roleFilter,
    status: statusFilter,
    month,
  });

  return NextResponse.json({
    ok: true,
    count: users.length,
    users,
  });
}

// POST /api/admin/users - Create or Update User
export async function POST(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
  }

  const exact = session.exactRole || session.role;
  const isSuperAdmin = exact === 'Super Admin' || exact === 'HR Head';
  const isUnitAdmin = exact === 'Unit Admin';

  if (!isSuperAdmin && !isUnitAdmin) {
    return NextResponse.json({ error: 'Unauthorized. Admin privilege required.' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const empCode = body.empCode || body.id;
    const name = body.name;
    const roleName = body.roleName || body.role;
    const unitInput = body.unitId !== undefined && body.unitId !== '' ? String(body.unitId).trim() : null;
    const deptInput = body.departmentId || body.department;
    const tlInput = body.tlId !== undefined && body.tlId !== '' ? String(body.tlId).trim() : (body.teamLeaderId ? String(body.teamLeaderId).trim() : null);
    const sglInput = body.sglId !== undefined && body.sglId !== '' ? String(body.sglId).trim() : (body.seniorGroupLeaderId ? String(body.seniorGroupLeaderId).trim() : null);
    const password = body.password;
    const isActive = body.isActive;

    if (!empCode || !name || !roleName) {
      return NextResponse.json({ error: 'Employee Code, Full Name, and Role are required.' }, { status: 400 });
    }

    const codeUpper = String(empCode).trim().toUpperCase();
    const pool = await getPool();

    // Resolve Role ID
    const roleRes = await pool.request()
      .input('name', sql.NVarChar, String(roleName).trim())
      .query('SELECT TOP 1 id FROM [Role] WHERE name = @name OR name LIKE @name + \'%\'');

    if (roleRes.recordset.length === 0) {
      return NextResponse.json({ error: `Role '${roleName}' not found.` }, { status: 400 });
    }
    const roleId = roleRes.recordset[0].id;

    // Resolve Unit ID
    let targetUnitId: string | null = null;
    if (isUnitAdmin) {
      if (roleName === 'Super Admin' || roleName === 'HR Head' || roleName === 'Unit Admin') {
        return NextResponse.json({ error: 'Unit Admins cannot provision executive roles.' }, { status: 403 });
      }
      targetUnitId = session.unitId;
    } else if (unitInput) {
      const unitRes = await pool.request()
        .input('unitInput', sql.NVarChar, unitInput)
        .query('SELECT TOP 1 id FROM [Unit] WHERE id = @unitInput OR code = @unitInput OR name = @unitInput');
      targetUnitId = unitRes.recordset.length > 0 ? unitRes.recordset[0].id : unitInput;
    }

    // Resolve Department ID
    let targetDeptId: string | null = null;
    if (deptInput) {
      const deptStr = String(deptInput).trim();
      const deptRes = await pool.request()
        .input('deptStr', sql.NVarChar, deptStr)
        .query('SELECT TOP 1 id FROM [Department] WHERE id = @deptStr OR name = @deptStr');
      targetDeptId = deptRes.recordset.length > 0 ? deptRes.recordset[0].id : null;
    }

    // Resolve TL ID
    let targetTlId: string | null = null;
    if (tlInput) {
      const tlRes = await pool.request()
        .input('tlInput', sql.NVarChar, tlInput)
        .query('SELECT TOP 1 id FROM [User] WHERE id = @tlInput OR empCode = @tlInput');
      targetTlId = tlRes.recordset.length > 0 ? tlRes.recordset[0].id : null;
    }

    // Resolve SGL ID
    let targetSglId: string | null = null;
    if (sglInput) {
      const sglRes = await pool.request()
        .input('sglInput', sql.NVarChar, sglInput)
        .query('SELECT TOP 1 id FROM [User] WHERE id = @sglInput OR empCode = @sglInput');
      targetSglId = sglRes.recordset.length > 0 ? sglRes.recordset[0].id : null;
    }

    // Hash password if supplied
    let passwordHash: string | null = null;
    if (password && String(password).trim().length > 0) {
      passwordHash = bcrypt.hashSync(String(password).trim(), 10);
    }

    const existing = await pool.request()
      .input('empCode', sql.NVarChar, codeUpper)
      .query('SELECT id, passwordHash FROM [User] WHERE empCode = @empCode');

    const activeBit = isActive === false || isActive === 0 ? 0 : 1;

    if (existing.recordset.length > 0) {
      // If no new password given, retain existing hash
      const finalHash = passwordHash || existing.recordset[0].passwordHash;

      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('name', sql.NVarChar, name.trim())
        .input('roleId', sql.NVarChar, roleId)
        .input('unitId', sql.NVarChar, targetUnitId || null)
        .input('departmentId', sql.NVarChar, targetDeptId || null)
        .input('tlId', sql.NVarChar, targetTlId || null)
        .input('sglId', sql.NVarChar, targetSglId || null)
        .input('passwordHash', sql.NVarChar, finalHash)
        .input('isActive', sql.Bit, activeBit)
        .query(`
          UPDATE [User]
          SET name = @name,
              roleId = @roleId,
              unitId = @unitId,
              departmentId = @departmentId,
              tlId = @tlId,
              sglId = @sglId,
              passwordHash = @passwordHash,
              isActive = @isActive,
              updatedAt = SYSUTCDATETIME()
          WHERE empCode = @empCode
        `);

      return NextResponse.json({ ok: true, message: `Account ${codeUpper} updated successfully.`, empCode: codeUpper });
    } else {
      // Default password to empCode or 'Mahle@123' if not specified
      const finalHash = passwordHash || bcrypt.hashSync(codeUpper, 10);

      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('name', sql.NVarChar, name.trim())
        .input('roleId', sql.NVarChar, roleId)
        .input('unitId', sql.NVarChar, targetUnitId || null)
        .input('departmentId', sql.NVarChar, targetDeptId || null)
        .input('tlId', sql.NVarChar, targetTlId || null)
        .input('sglId', sql.NVarChar, targetSglId || null)
        .input('passwordHash', sql.NVarChar, finalHash)
        .input('isActive', sql.Bit, activeBit)
        .query(`
          INSERT INTO [User] (id, empCode, name, roleId, unitId, departmentId, tlId, sglId, passwordHash, isActive, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), @empCode, @name, @roleId, @unitId, @departmentId, @tlId, @sglId, @passwordHash, @isActive, SYSUTCDATETIME(), SYSUTCDATETIME())
        `);

      return NextResponse.json({ ok: true, message: `Account ${codeUpper} created successfully.`, empCode: codeUpper });
    }
  } catch (err: any) {
    console.error('Error in /api/admin/users:', err);
    return NextResponse.json({ error: err.message || 'Internal server error.' }, { status: 500 });
  }
}

// PATCH /api/admin/users - Quick Actions (Toggle Status, Quick Reassign)
export async function PATCH(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
  }

  const exact = session.exactRole || session.role;
  const isSuperAdmin = exact === 'Super Admin' || exact === 'HR Head';
  const isUnitAdmin = exact === 'Unit Admin';

  if (!isSuperAdmin && !isUnitAdmin) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const { empCode, action, newPassword, unitId, departmentId, tlId, sglId } = body;

    if (!empCode) {
      return NextResponse.json({ error: 'empCode is required.' }, { status: 400 });
    }

    const codeUpper = String(empCode).trim().toUpperCase();

    // Action 1: Toggle active status
    if (action === 'toggle-status') {
      const updated = await store.toggleUserActive(codeUpper);
      if (!updated) {
        return NextResponse.json({ error: 'User not found.' }, { status: 404 });
      }
      return NextResponse.json({
        ok: true,
        empCode: codeUpper,
        isActive: updated.isActive,
        message: `Account ${codeUpper} is now ${updated.isActive ? 'Active' : 'Deactivated'}.`,
      });
    }

    // Action 2: Reset password
    if (action === 'reset-password' && newPassword) {
      const pool = await getPool();
      const hash = bcrypt.hashSync(String(newPassword).trim(), 10);
      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('hash', sql.NVarChar, hash)
        .query('UPDATE [User] SET passwordHash = @hash, updatedAt = SYSUTCDATETIME() WHERE empCode = @empCode');

      return NextResponse.json({ ok: true, message: `Password for ${codeUpper} has been updated.` });
    }

    // Action 3: Quick reassign Unit/TL/SGL
    if (action === 'reassign') {
      const pool = await getPool();
      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('unitId', sql.NVarChar, unitId || null)
        .input('departmentId', sql.NVarChar, departmentId || null)
        .input('tlId', sql.NVarChar, tlId || null)
        .input('sglId', sql.NVarChar, sglId || null)
        .query(`
          UPDATE [User]
          SET unitId = COALESCE(@unitId, unitId),
              departmentId = COALESCE(@departmentId, departmentId),
              tlId = COALESCE(@tlId, tlId),
              sglId = COALESCE(@sglId, sglId),
              updatedAt = SYSUTCDATETIME()
          WHERE empCode = @empCode
        `);

      return NextResponse.json({ ok: true, message: `Assignments updated for ${codeUpper}.` });
    }

    return NextResponse.json({ error: 'Unknown action.' }, { status: 400 });
  } catch (err: any) {
    console.error('Error in PATCH /api/admin/users:', err);
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}

// DELETE /api/admin/users - Deactivate user
export async function DELETE(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
  }

  const exact = session.exactRole || session.role;
  if (exact !== 'Super Admin' && exact !== 'HR Head') {
    return NextResponse.json({ error: 'Only Super Admins can deactivate users.' }, { status: 403 });
  }

  try {
    const url = new URL(req.url);
    const empCode = url.searchParams.get('empCode');
    if (!empCode) return NextResponse.json({ error: 'empCode is required.' }, { status: 400 });

    const codeUpper = empCode.trim().toUpperCase();
    const pool = await getPool();
    await pool.request()
      .input('empCode', sql.NVarChar, codeUpper)
      .query('UPDATE [User] SET isActive = 0, updatedAt = SYSUTCDATETIME() WHERE empCode = @empCode');

    return NextResponse.json({ ok: true, message: `Account ${codeUpper} has been deactivated.` });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}
