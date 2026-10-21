import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

// GET /api/master-items - Fetch active master training programs and activities
export async function GET() {
  try {
    const session = await getSession();
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
    }

    const data = await store.listMasterItems();
    return NextResponse.json({
      ok: true,
      trainings: data.trainings,
      activities: data.activities,
    });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}
