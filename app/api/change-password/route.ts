import { NextResponse } from 'next/server';
import store from '@/lib/db';
import bcrypt from 'bcryptjs';
import { getSession } from '@/lib/session';

function isSupervisor(session: any) {
  if (!session) return false;
  return session.role === 'supervisor' || (session.role !== 'employee' && session.exactRole !== 'Shop Floor Employee');
}

export async function POST(req: Request) {
  const session = await getSession();
  if (!isSupervisor(session)) return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  
  const { currentPassword, newPassword } = await req.json();
  if (!currentPassword || !newPassword) return NextResponse.json({ error: 'Missing fields.' }, { status: 400 });
  if (String(newPassword).length < 6) return NextResponse.json({ error: 'New password must be at least 6 characters.' }, { status: 400 });
  
  const empCode = session.empCode || session.id;
  const row = await store.getSupervisor(empCode);
  if (!row || !row.passwordHash || !bcrypt.compareSync(currentPassword, row.passwordHash)) {
    return NextResponse.json({ error: 'Current password is incorrect.' }, { status: 401 });
  }
  
  const newHash = bcrypt.hashSync(newPassword, 10);
  await store.upsertSupervisor(empCode, newHash);
  return NextResponse.json({ ok: true });
}