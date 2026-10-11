import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request, { params }: { params: Promise<{ empId: string, sheetId: string }> }) {
  const session = await getSession();
  if (session?.role !== 'supervisor') return NextResponse.json({ error: 'Not signed in as supervisor.' }, { status: 401 });
  const { empId, sheetId } = await params;
  const data = await store.getSheetData(empId.toUpperCase(), sheetId);
  return NextResponse.json({ data });
}