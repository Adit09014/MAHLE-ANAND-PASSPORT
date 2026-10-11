import { NextResponse } from 'next/server';
import store from '@/lib/db';
import bcrypt from 'bcryptjs';
import { setSession } from '@/lib/session';

export async function POST(req: Request) {
  const { role, id, password } = await req.json();
  if (!role || !id || !password) return NextResponse.json({ error: 'Missing fields.' }, { status: 400 });
  const idUpper = String(id).trim().toUpperCase();

  if (role === 'supervisor') {
    if (!/^K0/i.test(idUpper)) return NextResponse.json({ error: 'Supervisor ID must start with "K0".' }, { status: 400 });
    const row = await store.getSupervisor(idUpper);
    if (!row) return NextResponse.json({ error: 'No supervisor account with that ID.' }, { status: 401 });
    if (!row.passwordHash || !bcrypt.compareSync(password, row.passwordHash)) return NextResponse.json({ error: 'Incorrect password.' }, { status: 401 });
    await setSession({ role: 'supervisor', id: idUpper });
    return NextResponse.json({ ok: true, role: 'supervisor', id: idUpper });
  }

  if (role === 'employee') {
    if (!/^(KA|NTK)/i.test(idUpper)) return NextResponse.json({ error: 'Employee ID must start with "KA" or "NTK".' }, { status: 400 });
    if (String(id).trim().toLowerCase() !== String(password).trim().toLowerCase()) return NextResponse.json({ error: 'Incorrect Employee ID or password.' }, { status: 401 });
    await store.upsertEmployeeIfMissing(idUpper);
    await setSession({ role: 'employee', id: idUpper });
    const name = await store.getEmployeeName(idUpper);
    return NextResponse.json({ ok: true, role: 'employee', id: idUpper, name });
  }
  return NextResponse.json({ error: 'Unknown role.' }, { status: 400 });
}