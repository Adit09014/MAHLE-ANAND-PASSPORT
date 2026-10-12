import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET() {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
  }

  const exact = session.exactRole || session.role;
  const isSuperAdmin = exact === 'Super Admin' || exact === 'HR Head';
  const isUnitAdmin = exact === 'Unit Admin';

  if (!isSuperAdmin && !isUnitAdmin) {
    return NextResponse.json({ error: 'Access restricted to administrators.' }, { status: 403 });
  }

  try {
    const meta = await store.getAdminMetadata();
    return NextResponse.json({ ok: true, metadata: meta, ...meta });
  } catch (err: any) {
    console.error('Error in /api/admin/metadata:', err);
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}
