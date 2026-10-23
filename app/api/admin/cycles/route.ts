import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

// GET /api/admin/cycles - List all assessment cycles
export async function GET() {
  try {
    const rawCycles = await store.listAssessmentCycles();
    const cycles = (rawCycles || []).map((c: any) => ({
      ...c,
      cycleMonth: c.month,
      isOpen: c.status === 'open',
    }));
    return NextResponse.json({ ok: true, cycles });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}

// POST /api/admin/cycles - Create or Update assessment cycle
export async function POST(req: Request) {
  const session = await getSession();
  const exact = session?.exactRole || session?.role;
  if (exact !== 'Super Admin') {
    return NextResponse.json(
      { error: 'Access denied: Only Super Admin can configure assessment cycles.' },
      { status: 403 }
    );
  }

  try {
    const body = await req.json();
    const month = (body.month || body.cycleMonth || '').trim();
    const title = (body.title || `${month} Assessment Cycle`).trim();
    const status = (body.status !== undefined)
      ? body.status
      : (body.isOpen !== undefined ? (body.isOpen ? 'open' : 'closed') : 'open');
    const { startDate, endDate } = body;

    if (!month) {
      return NextResponse.json({ error: 'Month (YYYY-MM) is required.' }, { status: 400 });
    }

    const result = await store.upsertAssessmentCycle(
      month,
      title,
      status,
      startDate,
      endDate
    );

    return NextResponse.json(result);
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}
