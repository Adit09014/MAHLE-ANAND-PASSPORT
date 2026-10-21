import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

function isSupervisor(session: any) {
  if (!session) return false;
  return session.role === 'supervisor' || (session.role !== 'employee' && session.exactRole !== 'Employee' && session.exactRole !== 'Shop Floor Employee');
}

export async function POST(req: Request) {
  const session = await getSession();
  if (!isSupervisor(session)) return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId } = await req.json();
  if (!empId) return NextResponse.json({ error: 'Missing empId.' }, { status: 400 });
  await store.markReviewed(empId.toUpperCase());
  return NextResponse.json({ ok: true });
}