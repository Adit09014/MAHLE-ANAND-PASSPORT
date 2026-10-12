import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  const url = new URL(req.url);
  const month = url.searchParams.get('month') || '2026-10';

  // An employee can view their own; supervisors/admins can view requested empCode
  let targetEmpCode = session.empCode;
  const requestedEmpCode = url.searchParams.get('empCode');

  if (requestedEmpCode && session.role !== 'Shop Floor Employee') {
    targetEmpCode = requestedEmpCode.trim().toUpperCase();
  }

  const assessment = await store.getReviewForEmployeeMonth(targetEmpCode, month);

  return NextResponse.json({
    ok: true,
    empCode: targetEmpCode,
    month,
    assessment: assessment || {
      submissionStatus: 'not_started',
      month,
      selfScore: null,
      tlScore: null,
      ratingGrade: null,
      criteriaScores: null,
      tlComments: null,
      evaluatorName: null,
    },
  });
}
