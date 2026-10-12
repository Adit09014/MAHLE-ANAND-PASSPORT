import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  // TL role check (Super Admin and HR Head can also inspect)
  const userRole = session.exactRole || session.role;
  const isTL = userRole === 'Team Leader (TL)';
  const isGlobalAdmin = userRole === 'Super Admin' || userRole === 'HR Head';

  if (!isTL && !isGlobalAdmin) {
    return NextResponse.json({ error: 'Access restricted to Team Leaders.' }, { status: 403 });
  }

  const url = new URL(req.url);
  const month = url.searchParams.get('month') || '2026-10';

  let targetTlId: string;
  let targetUnitId: string | null = null;
  let tlEmpCode: string | null = null;

  if (isTL) {
    // Team Leader is strictly locked to their own ID and unit from session
    targetTlId = session.userId || session.id;
    tlEmpCode = session.empCode || session.id;
    targetUnitId = session.unitId || null;

    // Resolve GUID if targetTlId was empCode
    if (targetTlId && !targetTlId.includes('-')) {
      const tlUser = await store.getUserByEmpCode(targetTlId);
      if (tlUser?.id) {
        targetTlId = tlUser.id;
        if (!targetUnitId && tlUser.unitId) targetUnitId = tlUser.unitId;
      }
    }
  } else {
    // Global admin inspecting
    let rawTl = url.searchParams.get('tlId') || session.userId || session.id;
    const tlUser = await store.getUserByEmpCode(rawTl);
    targetTlId = tlUser?.id || rawTl;
    tlEmpCode = tlUser?.empCode || rawTl;
    targetUnitId = url.searchParams.get('unitId') || tlUser?.unitId || null;
  }

  const employees = await store.getAssignedEmployeesForTL(targetTlId, month, targetUnitId, tlEmpCode);

  return NextResponse.json({
    ok: true,
    month,
    unitId: targetUnitId,
    count: employees.length,
    employees,
  });
}
