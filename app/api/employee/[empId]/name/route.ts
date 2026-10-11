import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request, { params }: { params: Promise<{ empId: string }> }) {
  const session = await getSession();
  if (!session?.role) return NextResponse.json({ error: 'Not signed in.' }, { status: 401 });
  const { empId } = await params;
  const name = await store.getEmployeeName(empId.toUpperCase());
  return NextResponse.json({ name });
}