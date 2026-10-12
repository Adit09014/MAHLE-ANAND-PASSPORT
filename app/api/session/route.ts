import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET() {
  const session = await getSession();
  if (!session || !session.empCode) {
    return NextResponse.json({ ok: false, role: null, user: null });
  }

  // Refresh latest name and unit from DB if available
  const user = await store.getUserByEmpCode(session.empCode);

  const profile = user ? {
    id: user.id,
    empCode: user.empCode,
    name: user.name || user.empCode,
    role: user.role,
    unitId: user.unitId,
    unitName: user.unitName,
    unitCode: user.unitCode,
    departmentId: user.departmentId,
    departmentName: user.departmentName,
    tlId: user.tlId,
    tlName: user.tlName,
    sglId: user.sglId,
    sglName: user.sglName,
  } : session;

  return NextResponse.json({
    ok: true,
    user: profile,
    // Backwards-compatibility properties
    role: profile.role === 'Shop Floor Employee' ? 'employee' : 'supervisor',
    exactRole: profile.role,
    id: profile.empCode,
    name: profile.name,
    unitName: profile.unitName,
  });
}