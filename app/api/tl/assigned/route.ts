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
  let targetTlId = url.searchParams.get('tlId') || session.userId || session.id;
  if (targetTlId && !targetTlId.includes('-')) {
    const tlUser = await store.getUserByEmpCode(targetTlId);
    if (tlUser?.id) targetTlId = tlUser.id;
  }

  const employees = await store.getAssignedEmployeesForTL(targetTlId, month);

  return NextResponse.json({
    ok: true,
    month,
    count: employees.length,
    employees,
  });
}
