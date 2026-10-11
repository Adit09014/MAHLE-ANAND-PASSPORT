import { NextResponse } from 'next/server';
import store from '@/lib/db';
import bcrypt from 'bcryptjs';

export async function GET(req: Request) {
  const ADMIN_KEY = process.env.ADMIN_KEY;
  const url = new URL(req.url);
  const key = url.searchParams.get('key');
  if (!ADMIN_KEY || key !== ADMIN_KEY) return new NextResponse('Invalid or missing admin key.', { status: 403 });
  
  const id = url.searchParams.get('id');
  const password = url.searchParams.get('password');
  if (!id || !password) return new NextResponse('Missing id or password.', { status: 400 });
  
  const idUpper = String(id).trim().toUpperCase();
  if (!/^K0/i.test(idUpper)) return new NextResponse('Supervisor ID must start with "K0".', { status: 400 });
  if (String(password).length < 6) return new NextResponse('Password must be at least 6 characters.', { status: 400 });
  
  const supervisor = await store.getSupervisor(idUpper);
  const existed = !!supervisor;
  const hash = bcrypt.hashSync(password, 10);
  await store.upsertSupervisor(idUpper, hash);
  return new NextResponse(existed ? `Password reset for existing supervisor ${idUpper}.` : `Supervisor account ${idUpper} created. You can log in now.`);
}