import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET() {
  const session = await getSession();
  if (session?.role !== 'supervisor') return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const rows = await store.listSubmissions();
  const result = await Promise.all(rows.map(async (r: any) => ({
    empId: r.empId,
    name: await store.getEmployeeName(r.empId),
    month: r.month,
    submittedAt: r.submittedAt,
    status: r.status,
  })));
  return NextResponse.json({ submissions: result });
}