import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  const url = new URL(req.url);
  let unitFilter = url.searchParams.get('unit') || 'all';
  const month = url.searchParams.get('month') || '2026-10';

  const exact = session?.exactRole || session?.role;
  // If session is Unit Admin, strictly restrict unitFilter to their assigned unit
  if (session && exact === 'Unit Admin' && session.unitId) {
    unitFilter = session.unitId;
  }

  const [analytics, units] = await Promise.all([
    store.getDashboardAnalytics(unitFilter, month),
    store.listUnits(),
  ]);

  return NextResponse.json({
    ok: true,
    filter: { unit: unitFilter, month },
    ...analytics,
    availableUnits: units,
  });
}
