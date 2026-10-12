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
  const empCode = getEmpCode(session);
  const data = await store.getSheetData(empCode, sheetId);
  return NextResponse.json({ data });
}

export async function POST(req: Request, { params }: { params: Promise<{ sheetId: string }> }) {
  const session = await getSession();
  if (!isEmployee(session)) return NextResponse.json({ error: 'Not signed in as employee.' }, { status: 401 });
  const { sheetId } = await params;
  if (sheetId === 'supervisor') return NextResponse.json({ error: 'Locked.' }, { status: 403 });
  
  const empCode = getEmpCode(session);
  const data = await req.json();
  await store.setSheetData(empCode, sheetId, data);
  if (sheetId === 'frontpage' && data.name) {
    await store.setEmployeeName(empCode, data.name);
  }
  return NextResponse.json({ ok: true });
}