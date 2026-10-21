import { NextResponse } from 'next/server';
import store from '@/lib/db';
import bcrypt from 'bcryptjs';
import { setSession } from '@/lib/session';

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { id, password } = body;
    if (!id || !password) {
      return NextResponse.json({ error: 'Please enter both Employee ID and password.' }, { status: 400 });
    }

    const idUpper = String(id).trim().toUpperCase();
    const passwordStr = String(password).trim();

    // 1. Check if user exists in database
    const user = await store.getUserByEmpCode(idUpper);

    if (user) {
      if (!user.isActive) {
        return NextResponse.json({ error: 'This account is deactivated. Contact administrator.' }, { status: 403 });
      }

      // Check password according to role
      let isPasswordValid = false;
      const isEmployee = user.role === 'Employee' || user.role === 'Shop Floor Employee';
      if (isEmployee) {
        // Employee password defaults to employee code unless a custom password hash is set
        if (user.passwordHash) {
          isPasswordValid = bcrypt.compareSync(passwordStr, user.passwordHash) || (idUpper.toLowerCase() === passwordStr.toLowerCase());
        } else {
          isPasswordValid = idUpper.toLowerCase() === passwordStr.toLowerCase();
        }
      } else {
        // Administrative and supervisory roles require hashed password check
        if (user.passwordHash) {
          isPasswordValid = bcrypt.compareSync(passwordStr, user.passwordHash);
        }
      }

      if (!isPasswordValid) {
        return NextResponse.json({ error: 'Incorrect password.' }, { status: 401 });
      }

      const exactRole = isEmployee ? 'Employee' : user.role;
      const sessionPayload = {
        id: user.empCode,
        userId: user.id,
        empCode: user.empCode,
        name: user.name || user.empCode,
        role: isEmployee ? 'employee' : 'supervisor',
        exactRole,
        unitId: user.unitId || null,
        unitName: user.unitName || null,
        unitCode: user.unitCode || null,
        departmentId: user.departmentId || null,
        departmentName: user.departmentName || null,
        tlId: user.tlId || null,
        sglId: user.sglId || null,
      };

      await setSession(sessionPayload);

      return NextResponse.json({
        ok: true,
        user: sessionPayload,
        // Backwards compatibility fields for legacy frontend
        role: isEmployee ? 'employee' : 'supervisor',
        exactRole,
        id: user.empCode,
        name: user.name,
        unitName: user.unitName,
      });
    }

    // 2. Fallback: Auto-provision new Employee if ID starts with KA or NTK
    if (/^(KA|NTK)/i.test(idUpper)) {
      if (idUpper.toLowerCase() !== passwordStr.toLowerCase()) {
        return NextResponse.json({ error: 'Incorrect Employee ID or password.' }, { status: 401 });
      }

      await store.upsertEmployeeIfMissing(idUpper);
      const newUser = await store.getUserByEmpCode(idUpper);

      const sessionPayload = {
        id: newUser.empCode,
        userId: newUser.id,
        empCode: newUser.empCode,
        name: newUser.name || newUser.empCode,
        role: 'employee',
        exactRole: 'Employee',
        unitId: newUser.unitId || null,
        unitName: newUser.unitName || null,
        unitCode: newUser.unitCode || null,
        departmentId: newUser.departmentId || null,
        departmentName: newUser.departmentName || null,
        tlId: null,
        sglId: null,
      };

      await setSession(sessionPayload);

      return NextResponse.json({
        ok: true,
        user: sessionPayload,
        role: 'employee',
        exactRole: 'Employee',
        id: newUser.empCode,
        name: newUser.name,
      });
    }

    return NextResponse.json({ error: 'No account found with this ID.' }, { status: 401 });
  } catch (err: any) {
    console.error('Login error:', err);
    return NextResponse.json({ error: err.message || 'Internal server error during login.' }, { status: 500 });
  }
}