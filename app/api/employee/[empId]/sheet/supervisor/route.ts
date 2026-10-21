import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

function isSupervisor(session: any) {
  if (!session) return false;
  return session.role === 'supervisor' || (session.role !== 'employee' && session.exactRole !== 'Employee' && session.exactRole !== 'Shop Floor Employee');
}

export async function GET(req: Request, { params }: { params: Promise<{ empId: string }> }) {
  const session = await getSession();
  if (!isSupervisor(session)) return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId } = await params;
  const url = new URL(req.url);
  const cycle = url.searchParams.get('cycle') || url.searchParams.get('month') || '2026-10';
  const data = await store.getSheetData(empId.toUpperCase(), 'supervisor', cycle);
  return NextResponse.json({ data, cycle });
}

export async function POST(req: Request, { params }: { params: Promise<{ empId: string }> }) {
  const session = await getSession();
  if (!isSupervisor(session)) return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId } = await params;
  const data = await req.json();
  const url = new URL(req.url);
  const cycle = url.searchParams.get('cycle') || url.searchParams.get('month') || (data && (data.cycle || data.month)) || '2026-10';

  const METRIC_SPECS = [
    { key: 'Performance on the Job', label: 'Performance on the Job', max: 20, min60: 12 },
    { key: 'Attendance', label: 'Attendance', max: 10, min60: 6 },
    { key: 'Work Performance', label: 'Work Performance', max: 20, min60: 12 },
    { key: 'Line Performance', label: 'Line Performance', max: 20, min60: 12 },
    { key: 'Recognition', label: 'Recognition', max: 10, min60: 6 },
    { key: 'Documentation (Growth File)', label: 'Documentation (Growth File)', max: 10, min60: 6 },
    { key: 'AHPS / LEAN Participation', label: 'AHPS / LEAN Participation', max: 10, min60: 6 },
  ];

  // Enforce minimum 60% marks rule across all evaluated criteria
  if (data && data.scores && typeof data.scores === 'object') {
    for (const m of METRIC_SPECS) {
      const arr = data.scores[m.key];
      if (Array.isArray(arr)) {
        for (let mi = 0; mi < 12; mi++) {
          const raw = arr[mi];
          if (raw !== '' && raw !== null && raw !== undefined) {
            const val = parseFloat(raw);
            if (!isNaN(val)) {
              if (val < m.min60) {
                return NextResponse.json({
                  error: `Minimum 60% marks required: '${m.label}' cannot be scored less than ${m.min60} / ${m.max} marks (received ${val}).`
                }, { status: 400 });
              }
              if (val > m.max) {
                return NextResponse.json({
                  error: `'${m.label}' cannot exceed maximum marks of ${m.max} (received ${val}).`
                }, { status: 400 });
              }
            }
          }
        }
      }
    }
  }

  await store.setSheetData(empId.toUpperCase(), 'supervisor', data, cycle);
  return NextResponse.json({ ok: true, cycle });
}