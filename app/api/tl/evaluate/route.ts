import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function POST(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  const isTL = session.role === 'Team Leader (TL)';
  const isSuperAdmin = session.role === 'Super Admin';

  if (!isTL && !isSuperAdmin) {
    return NextResponse.json({ error: 'Access restricted to Team Leaders.' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const { submissionId, score, ratingGrade, criteriaScores, tlComments } = body;

    if (!submissionId || score === undefined || score === null) {
      return NextResponse.json({ error: 'Missing submissionId or evaluation score.' }, { status: 400 });
    }

    const numScore = parseFloat(score);
    if (isNaN(numScore) || numScore < 1.0 || numScore > 10.0) {
      return NextResponse.json({ error: 'Score must be a number between 1.0 and 10.0.' }, { status: 400 });
    }

    await store.upsertReview({
      submissionId,
      evaluatorId: session.id,
      score: numScore,
      ratingGrade,
      criteriaScores,
      tlComments: tlComments || '',
    });

    return NextResponse.json({
      ok: true,
      message: 'Assessment submitted successfully.',
      score: numScore,
    });
  } catch (err: any) {
    console.error('Error submitting TL review:', err);
    return NextResponse.json({ error: err.message || 'Internal server error.' }, { status: 500 });
  }
}
