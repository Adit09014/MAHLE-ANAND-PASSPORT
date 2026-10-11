import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function POST(req: Request, { params }: { params: Promise<{ empId: string }> }) {
  const session = await getSession();
  if (session?.role !== 'supervisor') return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId } = await params;
  const data = await req.json();
  await store.setSheetData(empId.toUpperCase(), 'supervisor', data);
  return NextResponse.json({ ok: true });
}