import { NextResponse } from 'next/server';
import store from '@/lib/db';
import bcrypt from 'bcryptjs';
import { getSession } from '@/lib/session';

export async function POST(req: Request) {
  const session = await getSession();
  if (session?.role !== 'supervisor') return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  
  const { currentPassword, newPassword } = await req.json();
  if (!currentPassword || !newPassword) return NextResponse.json({ error: 'Missing fields.' }, { status: 400 });
  if (String(newPassword).length < 6) return NextResponse.json({ error: 'New password must be at least 6 characters.' }, { status: 400 });
  
  const row = await store.getSupervisor(session.id);
  if (!row || !row.passwordHash || !bcrypt.compareSync(currentPassword, row.passwordHash)) {
    return NextResponse.json({ error: 'Current password is incorrect.' }, { status: 401 });
  }
  
  const newHash = bcrypt.hashSync(newPassword, 10);
  await store.upsertSupervisor(session.id, newHash);
  return NextResponse.json({ ok: true });
}