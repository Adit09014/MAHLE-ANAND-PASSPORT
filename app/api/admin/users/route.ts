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
  const isSuperAdmin = exact === 'Super Admin';
  const isUnitAdmin = exact === 'Unit Admin';

  if (!isSuperAdmin && !isUnitAdmin) {
    return NextResponse.json(
      { error: 'Forbidden. HR Head has read-only audit access. User creation and role management are strictly restricted to Super Admin.' },
      { status: 403 }
    );
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

    // Personnel & Service Profile Fields
    const fatherName = body.fatherName !== undefined && body.fatherName !== null ? String(body.fatherName).trim() : null;
    const mobile = body.mobile !== undefined && body.mobile !== null ? String(body.mobile).trim() : null;
    const email = body.email !== undefined && body.email !== null ? String(body.email).trim() : null;
    const joiningDate = body.joiningDate !== undefined && body.joiningDate !== null ? String(body.joiningDate).trim() : null;
    const dob = body.dob !== undefined && body.dob !== null ? String(body.dob).trim() : null;
    const designation = body.designation !== undefined && body.designation !== null ? String(body.designation).trim() : null;
    const groupJoiningDate = body.groupJoiningDate !== undefined && body.groupJoiningDate !== null ? String(body.groupJoiningDate).trim() : null;
    const gradeCode = body.gradeCode !== undefined && body.gradeCode !== null ? String(body.gradeCode).trim() : null;

    if (!empCode || !name || !roleName) {
      return NextResponse.json({ error: 'Employee Code, Full Name, and Role are required.' }, { status: 400 });
    }

    if (!joiningDate) {
      return NextResponse.json({ error: 'Date of Joining (Joined On) is required.' }, { status: 400 });
    }

    const codeUpper = String(empCode).trim().toUpperCase();
    await store.ensureUserExtraColumns();
    const pool = await getPool();

    // Resolve Role ID
    let roleId: string | null = null;
    let resolvedRoleName: string = String(roleName).trim();
    const roleRes = await pool.request()
      .input('name', sql.NVarChar, resolvedRoleName)
      .query(`
        SELECT TOP 1 id, name FROM [Role] 
        WHERE name = @name 
           OR (@name = 'Employee' AND name = 'Shop Floor Employee')
           OR (@name = 'Shop Floor Employee' AND name = 'Employee')
           OR name LIKE @name + '%'
      `);

    if (roleRes.recordset.length === 0) {
      if (resolvedRoleName === 'Employee') {
        const insertRes = await pool.request()
          .input('name', sql.NVarChar, 'Employee')
          .query(`
            DECLARE @newId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
            INSERT INTO [Role] (id, name) VALUES (@newId, @name);
            SELECT @newId AS id, @name AS name;
          `);
        roleId = insertRes.recordset[0].id;
        resolvedRoleName = 'Employee';
      } else {
        return NextResponse.json({ error: `Role '${roleName}' not found.` }, { status: 400 });
      }
    } else {
      roleId = roleRes.recordset[0].id;
      resolvedRoleName = roleRes.recordset[0].name === 'Shop Floor Employee' ? 'Employee' : roleRes.recordset[0].name;
    }

    // Resolve Unit ID
    let targetUnitId: string | null = null;
    if (isUnitAdmin) {
      if (roleName === 'Super Admin' || roleName === 'HR Head' || roleName === 'Unit Admin') {
        return NextResponse.json({ error: 'Unit Admins cannot provision executive roles.' }, { status: 403 });
      }
      targetUnitId = session.unitId || null;
      if (!targetUnitId) {
        const uAdminRes = await pool.request()
          .input('empCode', sql.NVarChar, session.empCode || session.id)
          .query('SELECT unitId FROM [User] WHERE empCode = @empCode');
        targetUnitId = uAdminRes.recordset[0]?.unitId || null;
      }
    } else if (unitInput) {
      const unitRes = await pool.request()
        .input('unitInput', sql.NVarChar, unitInput)
        .query('SELECT TOP 1 id FROM [Unit] WHERE id = @unitInput OR code = @unitInput OR name = @unitInput');
      if (unitRes.recordset.length > 0) {
        targetUnitId = unitRes.recordset[0].id;
      } else {
        return NextResponse.json({ error: `Selected Plant / Unit '${unitInput}' was not found.` }, { status: 400 });
      }
    }

    const isExecutiveRole = resolvedRoleName === 'Super Admin' || resolvedRoleName === 'HR Head';
    if (!targetUnitId && !isExecutiveRole) {
      return NextResponse.json({ error: 'Please select a Plant / Unit for this user.' }, { status: 400 });
    }

    // Resolve Department ID
    let targetDeptId: string | null = null;
    if (deptInput) {
      const deptStr = String(deptInput).trim();
      const deptRes = await pool.request()
        .input('deptStr', sql.NVarChar, deptStr)
        .query('SELECT TOP 1 id FROM [Department] WHERE id = @deptStr OR name = @deptStr OR name LIKE @deptStr + \'%\'');
      if (deptRes.recordset.length > 0) {
        targetDeptId = deptRes.recordset[0].id;
      } else if (targetUnitId) {
        const newDept = await pool.request()
          .input('name', sql.NVarChar, deptStr)
          .input('unitId', sql.NVarChar, targetUnitId)
          .query(`
            DECLARE @newDeptId NVARCHAR(1000) = CAST(NEWID() AS NVARCHAR(1000));
            INSERT INTO [Department] (id, name, unitId) VALUES (@newDeptId, @name, @unitId);
            SELECT @newDeptId AS id;
          `);
        targetDeptId = newDept.recordset[0]?.id || null;
      }
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

    // Unit Admin restrictions
    if (isUnitAdmin) {
      if (resolvedRoleName === 'Super Admin' || resolvedRoleName === 'HR Head' || resolvedRoleName === 'Unit Admin') {
        return NextResponse.json({ error: 'Unit Admin cannot assign executive or administrative roles.' }, { status: 403 });
      }
    }

    const existing = await pool.request()
      .input('empCode', sql.NVarChar, codeUpper)
      .query('SELECT id, passwordHash FROM [User] WHERE empCode = @empCode');

    const activeBit = isActive === false || isActive === 0 ? 0 : 1;

    if (existing.recordset.length > 0) {
      // Protect Super Admin account from demotion or deactivation
      const targetUserRes = await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .query('SELECT u.id, r.name AS roleName FROM [User] u JOIN [Role] r ON u.roleId = r.id WHERE u.empCode = @empCode');
      const targetRoleName = targetUserRes.recordset[0]?.roleName;

      if (targetRoleName === 'Super Admin') {
        if (!isSuperAdmin) {
          return NextResponse.json({ error: 'Super Admin accounts can only be managed by Super Admin.' }, { status: 403 });
        }
        if (resolvedRoleName !== 'Super Admin') {
          return NextResponse.json({ error: 'The Super Admin role cannot be demoted or changed.' }, { status: 400 });
        }
        if (activeBit === 0) {
          return NextResponse.json({ error: 'The Super Admin account cannot be deactivated.' }, { status: 400 });
        }
      }
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
        .input('fatherName', sql.NVarChar, fatherName)
        .input('mobile', sql.NVarChar, mobile)
        .input('email', sql.NVarChar, email)
        .input('joiningDate', sql.NVarChar, joiningDate)
        .input('dob', sql.NVarChar, dob)
        .input('designation', sql.NVarChar, designation)
        .input('groupJoiningDate', sql.NVarChar, groupJoiningDate)
        .input('gradeCode', sql.NVarChar, gradeCode)
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
              fatherName = @fatherName,
              mobile = @mobile,
              email = @email,
              joiningDate = @joiningDate,
              dob = @dob,
              designation = @designation,
              groupJoiningDate = @groupJoiningDate,
              gradeCode = @gradeCode,
              updatedAt = SYSUTCDATETIME()
          WHERE empCode = @empCode
        `);

      // Auto-populate / Synchronize Sheet 01 ("About Myself" - frontpage)
      try {
        const existingFront = await store.getSheetData(codeUpper, 'frontpage');
        const frontData = Object.assign({}, existingFront || {}, {
          empCode: codeUpper,
          name: name.trim(),
          father: fatherName || existingFront?.father || '',
          dob: dob || existingFront?.dob || '',
          doj: joiningDate || existingFront?.doj || '',
          mobile: mobile || existingFront?.mobile || '',
          email: email || existingFront?.email || '',
          designation: designation || existingFront?.designation || '',
          gradeCode: gradeCode || existingFront?.gradeCode || '',
          groupDoj: groupJoiningDate || existingFront?.groupDoj || '',
          permAddr: existingFront?.permAddr || '',
          corrAddr: existingFront?.corrAddr || '',
          phone1: existingFront?.phone1 || '',
          phone2: existingFront?.phone2 || '',
        });
        await store.setSheetData(codeUpper, 'frontpage', frontData);
      } catch (fErr) {
        console.warn('Auto-fill frontpage failed:', fErr);
      }

      return NextResponse.json({ ok: true, message: `Account ${codeUpper} updated successfully.`, empCode: codeUpper });
    } else {
      // Default password to 'Mahle@123' if not specified
      const finalHash = passwordHash || bcrypt.hashSync('Mahle@123', 10);

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
        .input('fatherName', sql.NVarChar, fatherName)
        .input('mobile', sql.NVarChar, mobile)
        .input('email', sql.NVarChar, email)
        .input('joiningDate', sql.NVarChar, joiningDate)
        .input('dob', sql.NVarChar, dob)
        .input('designation', sql.NVarChar, designation)
        .input('groupJoiningDate', sql.NVarChar, groupJoiningDate)
        .input('gradeCode', sql.NVarChar, gradeCode)
        .query(`
          INSERT INTO [User] (
            id, empCode, name, roleId, unitId, departmentId, tlId, sglId, 
            passwordHash, isActive, fatherName, mobile, email, joiningDate, 
            dob, designation, groupJoiningDate, gradeCode, createdAt, updatedAt
          )
          VALUES (
            CAST(NEWID() AS NVARCHAR(1000)), @empCode, @name, @roleId, @unitId, @departmentId, @tlId, @sglId, 
            @passwordHash, @isActive, @fatherName, @mobile, @email, @joiningDate, 
            @dob, @designation, @groupJoiningDate, @gradeCode, SYSUTCDATETIME(), SYSUTCDATETIME()
          )
        `);

      // Auto-populate / Synchronize Sheet 01 ("About Myself" - frontpage) for new member
      try {
        const frontData = {
          empCode: codeUpper,
          name: name.trim(),
          father: fatherName || '',
          dob: dob || '',
          doj: joiningDate || '',
          mobile: mobile || '',
          email: email || '',
          designation: designation || '',
          gradeCode: gradeCode || '',
          groupDoj: groupJoiningDate || '',
          permAddr: '',
          corrAddr: '',
          phone1: '',
          phone2: '',
        };
        await store.setSheetData(codeUpper, 'frontpage', frontData);
      } catch (fErr) {
        console.warn('Auto-fill frontpage failed:', fErr);
      }

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
  const isSuperAdmin = exact === 'Super Admin';

  if (!isSuperAdmin) {
    return NextResponse.json(
      { error: 'Forbidden. HR Head has read-only audit access. Account status changes are restricted to Super Admin.' },
      { status: 403 }
    );
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
      const pool = await getPool();
      const targetUser = await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .query('SELECT u.id, r.name AS roleName FROM [User] u JOIN [Role] r ON u.roleId = r.id WHERE u.empCode = @empCode');
      if (targetUser.recordset[0]?.roleName === 'Super Admin') {
        return NextResponse.json({ error: 'The Super Admin account cannot be deactivated.' }, { status: 400 });
      }

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
      let resolvedUnitId: string | null = null;
      if (unitId) {
        const uRes = await pool.request()
          .input('unitInput', sql.NVarChar, String(unitId).trim())
          .query('SELECT TOP 1 id FROM [Unit] WHERE id = @unitInput OR code = @unitInput OR name = @unitInput');
        if (uRes.recordset.length > 0) resolvedUnitId = uRes.recordset[0].id;
      }

      let resolvedDeptId: string | null = null;
      if (departmentId) {
        const dRes = await pool.request()
          .input('deptInput', sql.NVarChar, String(departmentId).trim())
          .query('SELECT TOP 1 id FROM [Department] WHERE id = @deptInput OR name = @deptInput');
        if (dRes.recordset.length > 0) resolvedDeptId = dRes.recordset[0].id;
      }

      let resolvedTlId: string | null = null;
      if (tlId) {
        const tlRes = await pool.request()
          .input('tlInput', sql.NVarChar, String(tlId).trim())
          .query('SELECT TOP 1 id FROM [User] WHERE id = @tlInput OR empCode = @tlInput');
        if (tlRes.recordset.length > 0) resolvedTlId = tlRes.recordset[0].id;
      }

      let resolvedSglId: string | null = null;
      if (sglId) {
        const sglRes = await pool.request()
          .input('sglInput', sql.NVarChar, String(sglId).trim())
          .query('SELECT TOP 1 id FROM [User] WHERE id = @sglInput OR empCode = @sglInput');
        if (sglRes.recordset.length > 0) resolvedSglId = sglRes.recordset[0].id;
      }

      await pool.request()
        .input('empCode', sql.NVarChar, codeUpper)
        .input('unitId', sql.NVarChar, resolvedUnitId)
        .input('departmentId', sql.NVarChar, resolvedDeptId)
        .input('tlId', sql.NVarChar, resolvedTlId)
        .input('sglId', sql.NVarChar, resolvedSglId)
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
