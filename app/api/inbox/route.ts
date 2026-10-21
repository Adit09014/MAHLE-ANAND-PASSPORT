import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session || !session.empCode) {
    return NextResponse.json({ error: 'Not signed in.' }, { status: 401 });
  }

  const user = await store.getUserByEmpCode(session.empCode);
  if (!user || user.role === 'Employee' || user.role === 'Shop Floor Employee') {
    return NextResponse.json({ error: 'Not authorized for supervisor inbox.' }, { status: 403 });
  }

  const url = new URL(req.url);
  const month = url.searchParams.get('month');

  const rows = await store.listSubmissions({
    role: user.role,
    userId: user.id,
    empCode: user.empCode,
    unitId: user.unitId,
    month: month || undefined,
  });

  return NextResponse.json({ submissions: rows });
}