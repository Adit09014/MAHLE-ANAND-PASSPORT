import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request, { params }: { params: Promise<{ empId: string }> }) {
  const session = await getSession();
  if (!session?.role) return NextResponse.json({ error: 'Not signed in.' }, { status: 401 });
  const { empId } = await params;
  const user = await store.getUserByEmpCode(empId.toUpperCase());
  return NextResponse.json({
    name: user?.name || empId,
    user: user ? {
      empCode: user.empCode,
      name: user.name,
      role: user.role,
      unitName: user.unitName,
      departmentName: user.departmentName,
      tlName: user.tlName
    } : null
  });
}