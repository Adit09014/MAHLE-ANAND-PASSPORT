import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function POST(req: Request) {
  const session = await getSession();
  if (session?.role !== 'supervisor') return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId } = await req.json();
  if (!empId) return NextResponse.json({ error: 'Missing empId.' }, { status: 400 });
  await store.markReviewed(empId.toUpperCase());
  return NextResponse.json({ ok: true });
}