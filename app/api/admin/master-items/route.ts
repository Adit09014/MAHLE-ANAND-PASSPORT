import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

// GET /api/admin/master-items - Fetch all master items for admin console
export async function GET() {
  try {
    const session = await getSession();
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
    }

    const exact = session.exactRole || session.role;
    const isSuperOrHr = exact === 'Super Admin' || exact === 'HR Head';
    if (!isSuperOrHr) {
      return NextResponse.json({ error: 'Forbidden. Super Admin or HR Head access required.' }, { status: 403 });
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

// POST /api/admin/master-items - Add or Delete master training programs and activities
export async function POST(req: Request) {
  try {
    const session = await getSession();
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
    }

    const exact = session.exactRole || session.role;
    if (exact !== 'Super Admin') {
      return NextResponse.json(
        { error: 'Forbidden. Only Super Admin can modify Training Matrix and Activities catalogs.' },
        { status: 403 }
      );
    }

    const body = await req.json();
    const action = String(body.action || '').trim().toLowerCase();
    const type = String(body.type || '').trim().toLowerCase() as 'training' | 'activity';

    if (action === 'add') {
      const title = String(body.title || body.name || '').trim();
      const category = body.category ? String(body.category).trim() : undefined;

      if (!type || (type !== 'training' && type !== 'activity')) {
        return NextResponse.json({ error: 'Type must be either "training" or "activity".' }, { status: 400 });
      }
      if (!title) {
        return NextResponse.json({ error: 'Title / name is required.' }, { status: 400 });
      }

      const res = await store.addMasterItem(type, title, category);
      return NextResponse.json(res);
    }

    if (action === 'delete') {
      const id = String(body.id || '').trim();
      const title = (body.title || body.name) ? String(body.title || body.name).trim() : undefined;

      if (!id && !title) {
        return NextResponse.json({ error: 'Item ID or title is required to delete.' }, { status: 400 });
      }

      const res = await store.deleteMasterItem(id, type || undefined, title);
      return NextResponse.json(res);
    }

    return NextResponse.json({ error: `Unknown action "${action}". Valid actions: 'add', 'delete'.` }, { status: 400 });
  } catch (err: any) {
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}
