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
  let targetSglId = url.searchParams.get('sglId') || session.userId || session.id;
  if (targetSglId && !targetSglId.includes('-')) {
    const sglUser = await store.getUserByEmpCode(targetSglId);
    if (sglUser?.id) targetSglId = sglUser.id;
  }

  const team = await store.getTeamForSGL(targetSglId, month);

  return NextResponse.json({
    ok: true,
    month,
    teamSize: team.length,
    team,
  });
}
