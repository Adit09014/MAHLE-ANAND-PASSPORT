import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getPool, sql } from '@/lib/mssql';
import { getSession } from '@/lib/session';

export async function POST(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  const exactRole = session.exactRole || session.role;
  const isTL = exactRole === 'Team Leader (TL)';
  const isSuperAdmin = exactRole === 'Super Admin' || exactRole === 'HR Head';

  if (!isTL && !isSuperAdmin) {
    return NextResponse.json({ error: 'Access restricted to Team Leaders. Senior Group Leaders (SGL) cannot modify submitted TL ratings unless specifically authorized.' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const { submissionId, employeeId, score, ratingGrade, criteriaScores, tlComments, comments, month } = body;

    if (score === undefined || score === null) {
      return NextResponse.json({ error: 'Evaluation score is required.' }, { status: 400 });
    }

    const numScore = parseFloat(score);
    if (isNaN(numScore) || numScore < 1.0 || numScore > 10.0) {
      return NextResponse.json({ error: 'Score must be a number between 1.0 and 10.0.' }, { status: 400 });
    }

    const targetMonth = month || '2026-10';
    let targetSubId = submissionId;
    const targetEmpCode = employeeId ? String(employeeId).trim().toUpperCase() : null;

    // Resolve submission if submissionId is missing but employeeId is provided
    if (!targetSubId && targetEmpCode) {
      let sub = await store.getSubmission(targetEmpCode, targetMonth);
      if (!sub) {
        await store.upsertSubmission(targetEmpCode, targetMonth);
        sub = await store.getSubmission(targetEmpCode, targetMonth);
      }
      targetSubId = sub?.id;
    }

    if (!targetSubId) {
      return NextResponse.json({ error: 'Monthly submission or Employee record could not be resolved.' }, { status: 400 });
    }

    // If Team Leader, verify the employee is mapped under this TL and in their assigned unit
    const pool = await getPool();
    const subCheck = await pool.request()
      .input('subId', sql.NVarChar, targetSubId)
      .query(`
        SELECT m.id, m.empId, u.empCode, u.name, u.tlId, u.unitId
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        WHERE m.id = @subId
      `);

    if (subCheck.recordset.length === 0) {
      return NextResponse.json({ error: 'Assessment submission not found in database.' }, { status: 404 });
    }

    const empUser = subCheck.recordset[0];
    const tlUserId = session.userId || session.id;
    const tlEmpCode = session.empCode || session.id;

    if (isTL) {
      const isMapped = (empUser.tlId === tlUserId || empUser.tlId === tlEmpCode);
      const isSameUnit = (!session.unitId || !empUser.unitId || empUser.unitId === session.unitId);

      if (!isMapped || !isSameUnit) {
        return NextResponse.json({
          error: 'Access denied: You can only evaluate employees mapped under your supervision within your plant unit.'
        }, { status: 403 });
      }
    }

    // Determine evaluator ID
    const evaluatorUser = await store.getUserByEmpCode(tlEmpCode);
    const evaluatorGuid = evaluatorUser?.id || tlUserId;

    // Determine rating tier
    let computedGrade = ratingGrade;
    if (!computedGrade) {
      if (numScore >= 9.0) computedGrade = 'Grade A+ (Distinction)';
      else if (numScore >= 8.0) computedGrade = 'Grade A (Outstanding)';
      else if (numScore >= 7.0) computedGrade = 'Grade B+ (Good)';
      else if (numScore >= 6.0) computedGrade = 'Grade B (Satisfactory)';
      else computedGrade = 'Grade C (Needs Improvement)';
    }

    const finalComments = (tlComments || comments || '').trim();

    await store.upsertReview({
      submissionId: targetSubId,
      evaluatorId: evaluatorGuid,
      score: numScore,
      ratingGrade: computedGrade,
      criteriaScores,
      tlComments: finalComments,
    });

    return NextResponse.json({
      ok: true,
      message: 'Assessment submitted successfully.',
      score: numScore,
      ratingGrade: computedGrade,
      employee: {
        empCode: empUser.empCode,
        name: empUser.name,
      },
    });
  } catch (err: any) {
    console.error('Error submitting TL review:', err);
    return NextResponse.json({ error: err.message || 'Internal server error.' }, { status: 500 });
  }
}

