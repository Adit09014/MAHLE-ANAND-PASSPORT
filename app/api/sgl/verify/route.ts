import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getPool, sql } from '@/lib/mssql';
import { getSession } from '@/lib/session';

export async function POST(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized. Please sign in.' }, { status: 401 });
  }

  const userRole = session.exactRole || session.role;
  const isSGL = userRole === 'Senior Group Leader (SGL)';
  const isGlobalAdmin = userRole === 'Super Admin' || userRole === 'HR Head';

  if (!isSGL && !isGlobalAdmin) {
    return NextResponse.json({ error: 'Access restricted to Senior Group Leaders.' }, { status: 403 });
  }

  try {
    const body = await req.json();
    const { submissionId, employeeId, month, sglRemarks } = body;

    const remarksText = String(sglRemarks || '').trim();
    if (!remarksText) {
      return NextResponse.json({ error: 'SGL verification remarks cannot be empty.' }, { status: 400 });
    }

    // Explicit security protection: SGL CANNOT modify submitted TL ratings
    if (body.score !== undefined || body.ratingGrade !== undefined || body.criteriaScores !== undefined) {
      console.warn(`[SECURITY] SGL ${session.empCode} attempted to modify submitted TL ratings. Modification ignored.`);
    }

    const targetMonth = month || '2026-10';
    let targetSubId = submissionId;
    const targetEmpCode = employeeId ? String(employeeId).trim().toUpperCase() : null;

    if (!targetSubId && targetEmpCode) {
      const sub = await store.getSubmission(targetEmpCode, targetMonth);
      targetSubId = sub?.id;
    }

    if (!targetSubId) {
      return NextResponse.json({ error: 'Monthly submission record not found.' }, { status: 404 });
    }

    const pool = await getPool();

    // Verify submission ownership: employee must belong to this SGL and in this SGL's unit
    const subCheck = await pool.request()
      .input('subId', sql.NVarChar, targetSubId)
      .query(`
        SELECT m.id, m.empId, u.empCode, u.name, u.sglId, u.unitId, ar.id AS reviewId
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        WHERE m.id = @subId
      `);

    if (subCheck.recordset.length === 0) {
      return NextResponse.json({ error: 'Submission not found in database.' }, { status: 404 });
    }

    const empUser = subCheck.recordset[0];
    const sglUserId = session.userId || session.id;
    const sglEmpCode = session.empCode || session.id;

    if (isSGL) {
      const isMapped = (empUser.sglId === sglUserId || empUser.sglId === sglEmpCode);
      const isSameUnit = (!session.unitId || !empUser.unitId || empUser.unitId === session.unitId);

      if (!isMapped || !isSameUnit) {
        return NextResponse.json({
          error: 'Access denied: You can only audit employees under your supervision within your plant unit.'
        }, { status: 403 });
      }
    }

    if (!empUser.reviewId) {
      return NextResponse.json({
        error: 'Assessment has not been evaluated by Team Leader yet. TL rating must be submitted first.'
      }, { status: 400 });
    }

    // Update ONLY sglRemarks without touching score, ratingGrade, or criteriaScores
    await pool.request()
      .input('reviewId', sql.NVarChar, empUser.reviewId)
      .input('sglRemarks', sql.NVarChar, remarksText)
      .query(`
        UPDATE [AssessmentReview]
        SET 
          sglRemarks = @sglRemarks,
          updatedAt = SYSUTCDATETIME()
        WHERE id = @reviewId
      `);

    return NextResponse.json({
      ok: true,
      message: 'SGL verification remarks recorded successfully.',
      submissionId: targetSubId,
      sglRemarks: remarksText,
    });
  } catch (err: any) {
    console.error('Error in SGL verify:', err);
    return NextResponse.json({ error: err.message || 'Internal server error' }, { status: 500 });
  }
}
