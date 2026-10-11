import { NextResponse } from 'next/server';
import store from '@/lib/db';

export async function GET(req: Request) {
  const ADMIN_KEY = process.env.ADMIN_KEY;
  const url = new URL(req.url);
  const key = url.searchParams.get('key');
  if (!ADMIN_KEY || key !== ADMIN_KEY) return NextResponse.json({ error: 'Invalid or missing admin key.' }, { status: 403 });
  const data = await store.exportAll();
  return NextResponse.json({ exportedAt: new Date().toISOString(), ...data });
}