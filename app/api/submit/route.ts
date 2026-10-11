import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function POST(req: Request) {
  const session = await getSession();
  if (session?.role !== 'employee') return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { month } = await req.json();
  if (!month) return NextResponse.json({ error: 'Missing month.' }, { status: 400 });
  await store.upsertSubmission(session.id, month);
  return NextResponse.json({ ok: true });
}