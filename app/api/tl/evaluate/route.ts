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

    const METRIC_SPECS = [
      { key: 'Performance on the Job', label: 'Performance on the Job', max: 20, min60: 12 },
      { key: 'Attendance', label: 'Attendance', max: 10, min60: 6 },
      { key: 'Work Performance', label: 'Work Performance', max: 20, min60: 12 },
      { key: 'Line Performance', label: 'Line Performance', max: 20, min60: 12 },
      { key: 'Recognition', label: 'Recognition', max: 10, min60: 6 },
      { key: 'Documentation (Growth File)', label: 'Documentation (Growth File)', max: 10, min60: 6 },
      { key: 'AHPS / LEAN Participation', label: 'AHPS / LEAN Participation', max: 10, min60: 6 },
    ];

    // Enforce 60% minimum marks on all sections
    let totalMarks = 0;
    const finalCriteriaScores: Record<string, number> = {};

    if (criteriaScores && typeof criteriaScores === 'object') {
      for (const m of METRIC_SPECS) {
        const rawVal = criteriaScores[m.key] ?? criteriaScores[m.label];
        if (rawVal !== undefined && rawVal !== null && rawVal !== '') {
          const val = parseFloat(rawVal);
          if (isNaN(val) || val < m.min60) {
            return NextResponse.json({
              error: `Minimum 60% marks required: '${m.label}' cannot be scored less than ${m.min60} / ${m.max} marks.`
            }, { status: 400 });
          }
          if (val > m.max) {
            return NextResponse.json({
              error: `'${m.label}' cannot exceed maximum marks of ${m.max}.`
            }, { status: 400 });
          }
          finalCriteriaScores[m.key] = val;
          totalMarks += val;
        } else {
          // If a section is omitted, default to min 60%
          finalCriteriaScores[m.key] = m.min60;
          totalMarks += m.min60;
        }
      }
    }

    const calculatedScaleScore = totalMarks > 0 ? Number((totalMarks / 10).toFixed(1)) : (parseFloat(score) || 8.5);

    if (calculatedScaleScore < 6.0) {
      return NextResponse.json({
        error: 'Minimum 60% overall marks (6.0 / 10.0 or 60 / 100) is required. Team Leader cannot score less than 60%.'
      }, { status: 400 });
    }

    const numScore = calculatedScaleScore;
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
        SELECT m.id, m.empId, u.empCode, u.name, u.tlId, u.unitId, d.name AS departmentName
        FROM [MonthlySubmission] m
        JOIN [User] u ON m.empId = u.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
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
    const evaluatorDisplayName = evaluatorUser?.name || session.name || tlEmpCode;

    // Determine rating tier
    let computedGrade = ratingGrade;
    if (!computedGrade) {
      if (numScore >= 9.0) computedGrade = 'Grade A+ (Distinction)';
      else if (numScore >= 8.0) computedGrade = 'Grade A (Outstanding)';
      else if (numScore >= 7.0) computedGrade = 'Grade B+ (Good)';
      else if (numScore >= 6.0) computedGrade = 'Grade B (Satisfactory)';
      else computedGrade = 'Grade C (Under 60% - Not Allowed)';
    }

    const finalComments = (tlComments || comments || '').trim();

    // 1. Save review in [AssessmentReview]
    await store.upsertReview({
      submissionId: targetSubId,
      evaluatorId: evaluatorGuid,
      score: numScore,
      ratingGrade: computedGrade,
      criteriaScores: Object.keys(finalCriteriaScores).length > 0 ? finalCriteriaScores : criteriaScores,
      tlComments: finalComments,
    });

    // 2. Automatically synchronize into Sheet 10 ("Supervisor Remarks & Assessment")
    try {
      const monthParts = targetMonth.split('-');
      const monthNum = parseInt(monthParts[1] || '10', 10);
      const mi = (monthNum >= 1 && monthNum <= 12) ? monthNum - 1 : 9;

      let sheetData = await store.getSheetData(empUser.empCode, 'supervisor', targetMonth);
      if (!sheetData) {
        sheetData = {
          name: empUser.name || empUser.empCode,
          area: empUser.departmentName || 'Operations',
          scores: {},
          signature: evaluatorDisplayName
        };
      }
      if (!sheetData.scores) sheetData.scores = {};
      if (!sheetData.name) sheetData.name = empUser.name || empUser.empCode;
      if (!sheetData.area) sheetData.area = empUser.departmentName || 'Operations';
      sheetData.signature = evaluatorDisplayName;

      for (const m of METRIC_SPECS) {
        if (!sheetData.scores[m.key] || !Array.isArray(sheetData.scores[m.key])) {
          sheetData.scores[m.key] = Array(12).fill('');
        }
        if (finalCriteriaScores[m.key] !== undefined) {
          sheetData.scores[m.key][mi] = finalCriteriaScores[m.key];
        }
      }

      await store.setSheetData(empUser.empCode, 'supervisor', sheetData, targetMonth);
    } catch (sErr) {
      console.warn('Failed to sync to Sheet 10 supervisor table:', sErr);
    }

    return NextResponse.json({
      ok: true,
      message: 'Assessment submitted successfully.',
      score: numScore,
      ratingGrade: computedGrade,
      criteriaScores: finalCriteriaScores,
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

