import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request, { params }: { params: Promise<{ sheetId: string }> }) {
  const session = await getSession();
  if (session?.role !== 'employee') return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { sheetId } = await params;
  const data = await store.getSheetData(session.id, sheetId);
  return NextResponse.json({ data });
}

export async function POST(req: Request, { params }: { params: Promise<{ sheetId: string }> }) {
  const session = await getSession();
  if (session?.role !== 'employee') return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { sheetId } = await params;
  if (sheetId === 'supervisor') return NextResponse.json({ error: 'Locked.' }, { status: 403 });
  
  const data = await req.json();
  await store.setSheetData(session.id, sheetId, data);
  if (sheetId === 'frontpage' && data.name) {
    await store.setEmployeeName(session.id, data.name);
  }
  return NextResponse.json({ ok: true });
}