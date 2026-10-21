import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

function isEmployee(session: any) {
  if (!session) return false;
  return session.role === 'employee' || session.role === 'Employee' || session.role === 'Shop Floor Employee' || session.exactRole === 'Employee' || session.exactRole === 'Shop Floor Employee';
}

export async function POST(req: Request) {
  const session = await getSession();
  if (!isEmployee(session)) return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { month } = await req.json();
  if (!month) return NextResponse.json({ error: 'Missing month.' }, { status: 400 });
  const empCode = session?.empCode || session?.id;
  await store.upsertSubmission(empCode, month);
  return NextResponse.json({ ok: true });
}