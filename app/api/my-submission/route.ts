import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (session?.role !== 'employee') return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const url = new URL(req.url);
  const month = url.searchParams.get('month');
  const row = month ? await store.getSubmission(session.id, month) : null;
  return NextResponse.json({ submitted: !!row, submittedAt: row ? row.submittedAt : null });
}