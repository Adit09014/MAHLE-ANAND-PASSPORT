import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

function isEmployee(session: any) {
  if (!session) return false;
  return session.role === 'employee' || session.role === 'Employee' || session.role === 'Shop Floor Employee' || session.exactRole === 'Employee' || session.exactRole === 'Shop Floor Employee';
}

export async function GET(req: Request) {
  const session = await getSession();
  if (!isEmployee(session)) return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const url = new URL(req.url);
  const month = url.searchParams.get('month');
  const empCode = session?.empCode || session?.id;
  const row = month ? await store.getSubmission(empCode, month) : null;
  return NextResponse.json({ submitted: !!row, submittedAt: row ? row.submittedAt : null });
}