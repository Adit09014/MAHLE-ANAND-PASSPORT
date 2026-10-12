import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

function isSupervisor(session: any) {
  if (!session) return false;
  return session.role === 'supervisor' || (session.role !== 'employee' && session.exactRole !== 'Shop Floor Employee');
}

export async function GET(req: Request, { params }: { params: Promise<{ empId: string, sheetId: string }> }) {
  const session = await getSession();
  if (!isSupervisor(session)) return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId, sheetId } = await params;
  const url = new URL(req.url);
  const cycle = url.searchParams.get('cycle') || url.searchParams.get('month') || '2026-10';
  const data = await store.getSheetData(empId.toUpperCase(), sheetId, cycle);
  return NextResponse.json({ data, cycle });
}