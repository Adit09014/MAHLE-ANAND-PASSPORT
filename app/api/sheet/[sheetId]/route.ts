import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

function isEmployee(session: any) {
  if (!session) return false;
  return session.role === 'employee' || session.role === 'Shop Floor Employee' || session.exactRole === 'Shop Floor Employee';
}

function getEmpCode(session: any) {
  return session?.empCode || session?.id;
}

export async function GET(req: Request, { params }: { params: Promise<{ sheetId: string }> }) {
  const session = await getSession();
  if (!isEmployee(session)) return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { sheetId } = await params;
  const url = new URL(req.url);
  const cycle = url.searchParams.get('cycle') || url.searchParams.get('month') || '2026-10';
  const empCode = getEmpCode(session);
  const data = await store.getSheetData(empCode, sheetId, cycle);
  return NextResponse.json({ data, cycle });
}

export async function POST(req: Request, { params }: { params: Promise<{ sheetId: string }> }) {
  const session = await getSession();
  if (!isEmployee(session)) return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { sheetId } = await params;
  if (sheetId === 'supervisor') return NextResponse.json({ error: 'Locked.' }, { status: 403 });
  
  const empCode = getEmpCode(session);
  const data = await req.json();
  const url = new URL(req.url);
  const cycle = url.searchParams.get('cycle') || url.searchParams.get('month') || (data && (data.cycle || data.month)) || '2026-10';
  await store.setSheetData(empCode, sheetId, data, cycle);
  if (sheetId === 'frontpage' && data.name) {
    await store.setEmployeeName(empCode, data.name);
  }
  return NextResponse.json({ ok: true, cycle });
}