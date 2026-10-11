import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET() {
  const session = await getSession();
  if (!session || !session.role) return NextResponse.json({ role: null });
  const name = session.role === 'employee' ? store.getEmployeeName(session.id) : null;
  return NextResponse.json({ role: session.role, id: session.id, name });
}