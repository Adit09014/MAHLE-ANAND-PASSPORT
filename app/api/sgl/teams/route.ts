import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  const userRole = session.exactRole || session.role;
  const isSGL = userRole === 'Senior Group Leader (SGL)';
  const isGlobalAdmin = userRole === 'Super Admin' || userRole === 'HR Head';

  if (!isSGL && !isGlobalAdmin) {
    return NextResponse.json({ error: 'Access restricted to Senior Group Leaders.' }, { status: 403 });
  }

  const url = new URL(req.url);
  const month = url.searchParams.get('month') || '2026-10';

  // SGL can only access employees/teams under their respective group and unit.
  let targetSglId = session.userId || session.id;
  let targetSglEmpCode = session.empCode || session.id;
  let targetUnitId = session.unitId || null;

  if (isGlobalAdmin) {
    const qSgl = url.searchParams.get('sglId');
    if (qSgl) {
      targetSglId = qSgl;
      targetSglEmpCode = qSgl;
      if (!targetSglId.includes('-')) {
        const sglUser = await store.getUserByEmpCode(targetSglId);
        if (sglUser?.id) targetSglId = sglUser.id;
      }
    }
    if (url.searchParams.has('unitId')) {
      targetUnitId = url.searchParams.get('unitId') || null;
    }
  }

  const isAllForAdmin = isGlobalAdmin && !url.searchParams.get('sglId');
  const team = await store.getTeamForSGL(targetSglId, month, targetUnitId, targetSglEmpCode, isAllForAdmin);

  return NextResponse.json({
    ok: true,
    month,
    unitId: targetUnitId,
    unitName: session.unitName || null,
    teamSize: team.length,
    team,
  });
}
