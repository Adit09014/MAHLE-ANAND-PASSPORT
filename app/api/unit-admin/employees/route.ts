import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  const userRole = session.exactRole || session.role;
  const isUnitAdmin = userRole === 'Unit Admin';
  const isSuperAdmin = userRole === 'Super Admin' || userRole === 'HR Head';

  if (!isUnitAdmin && !isSuperAdmin) {
    return NextResponse.json({ error: 'Access restricted to Unit Admins.' }, { status: 403 });
  }

  const url = new URL(req.url);
  const month = url.searchParams.get('month') || '2026-10';

  // Strict tenant boundary: Unit Admin can only view their own unit
  let targetUnitId = session.unitId;
  if (isSuperAdmin && url.searchParams.get('unitId')) {
    targetUnitId = url.searchParams.get('unitId');
  }

  if (!targetUnitId) {
    return NextResponse.json({ error: 'No unit assigned to this administrator.' }, { status: 400 });
  }

  const employees = await store.getEmployeesByUnit(targetUnitId, month);

  return NextResponse.json({
    ok: true,
    unitId: targetUnitId,
    month,
    count: employees.length,
    employees,
  });
}
