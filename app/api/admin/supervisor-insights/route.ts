import { NextResponse } from 'next/server';
import { getPool, sql } from '@/lib/mssql';
import { getSession } from '@/lib/session';

// GET /api/admin/supervisor-insights?empCode=...&month=...
export async function GET(req: Request) {
  try {
    const session = await getSession();
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
    }

    const exact = session.exactRole || session.role;
    const isSuperOrHr = exact === 'Super Admin' || exact === 'HR Head';
    const isUnitAdmin = exact === 'Unit Admin';

    if (!isSuperOrHr && !isUnitAdmin) {
      return NextResponse.json(
        { error: 'Forbidden. Supervisor insights are only accessible to administrators.' },
        { status: 403 }
      );
    }

    const url = new URL(req.url);
    const empCode = (url.searchParams.get('empCode') || url.searchParams.get('id') || '').trim().toUpperCase();
    const month = (url.searchParams.get('month') || '2026-10').trim();

    if (!empCode) {
      return NextResponse.json({ error: 'Supervisor employee code is required.' }, { status: 400 });
    }

    const pool = await getPool();

    // 1. Fetch Supervisor Profile
    const supRes = await pool.request()
      .input('empCode', sql.NVarChar, empCode)
      .query(`
        SELECT 
          u.id,
          u.empCode,
          u.name,
          u.isActive,
          u.mobile,
          u.email,
          u.designation,
          u.joiningDate,
          r.name AS roleName,
          un.id AS unitId,
          un.name AS unitName,
          un.code AS unitCode,
          d.id AS departmentId,
          d.name AS departmentName,
          sgl.id AS sglId,
          sgl.name AS sglName,
          sgl.empCode AS sglCode
        FROM [User] u
        JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [Unit] un ON u.unitId = un.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [User] sgl ON u.sglId = sgl.id
        WHERE u.empCode = @empCode
      `);

    if (!supRes.recordset || supRes.recordset.length === 0) {
      return NextResponse.json({ error: `Supervisor with code "${empCode}" not found.` }, { status: 404 });
    }

    const supervisor = supRes.recordset[0];
    const isTL = supervisor.roleName === 'Team Leader (TL)';
    const isSGL = supervisor.roleName === 'Senior Group Leader (SGL)';

    // Unit Admin can only view supervisors in their own unit
    if (isUnitAdmin && session.unitId && supervisor.unitId !== session.unitId) {
      return NextResponse.json({ error: 'Access restricted to your assigned unit.' }, { status: 403 });
    }

    // 2. Fetch Attached Employees
    const empQuery = isTL
      ? `
        SELECT 
          u.id,
          u.empCode,
          u.name,
          u.designation,
          u.mobile,
          u.email,
          d.name AS departmentName,
          sgl.name AS sglName,
          m.id AS submissionId,
          ISNULL(m.status, 'not_started') AS submissionStatus,
          m.selfScore,
          m.submittedAt,
          ar.score AS tlScore,
          ar.ratingGrade,
          ar.tlComments,
          ar.sglRemarks,
          ar.reviewedAt,
          ar.criteriaScores
        FROM [User] u
        JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [User] sgl ON u.sglId = sgl.id
        LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        WHERE u.tlId = @supId AND r.name IN ('Employee', 'Shop Floor Employee')
        ORDER BY u.name ASC
      `
      : `
        SELECT 
          u.id,
          u.empCode,
          u.name,
          u.designation,
          u.mobile,
          u.email,
          d.name AS departmentName,
          tl.name AS tlName,
          tl.empCode AS tlCode,
          m.id AS submissionId,
          ISNULL(m.status, 'not_started') AS submissionStatus,
          m.selfScore,
          m.submittedAt,
          ar.score AS tlScore,
          ar.ratingGrade,
          ar.tlComments,
          ar.sglRemarks,
          ar.reviewedAt,
          ar.criteriaScores
        FROM [User] u
        JOIN [Role] r ON u.roleId = r.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        LEFT JOIN [User] tl ON u.tlId = tl.id
        LEFT JOIN [MonthlySubmission] m ON u.id = m.empId AND m.month = @month
        LEFT JOIN [AssessmentReview] ar ON m.id = ar.submissionId
        WHERE u.sglId = @supId AND r.name IN ('Employee', 'Shop Floor Employee')
        ORDER BY tl.name ASC, u.name ASC
      `;

    const empRes = await pool.request()
      .input('supId', sql.NVarChar, supervisor.id)
      .input('month', sql.NVarChar, month)
      .query(empQuery);

    const attachedEmployees = empRes.recordset || [];

    // 3. Compute KPI Metrics
    const totalEmployees = attachedEmployees.length;
    const submittedCount = attachedEmployees.filter(e => 
      e.submissionStatus === 'submitted' || e.submissionStatus === 'evaluated'
    ).length;
    const evaluatedCount = attachedEmployees.filter(e => 
      e.tlScore !== null && e.tlScore !== undefined && !isNaN(e.tlScore)
    ).length;
    const pendingCount = totalEmployees - evaluatedCount;

    const scores = attachedEmployees
      .map(e => e.tlScore)
      .filter(s => s !== null && s !== undefined && !isNaN(s));
    const avgScore = scores.length > 0 
      ? Number((scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1)) 
      : null;

    const gradeDistribution: Record<string, number> = {
      'Grade A+': 0,
      'Grade A': 0,
      'Grade B+': 0,
      'Grade B': 0,
    };

    attachedEmployees.forEach(e => {
      if (e.ratingGrade) {
        if (e.ratingGrade.includes('A+')) gradeDistribution['Grade A+']++;
        else if (e.ratingGrade.includes('A')) gradeDistribution['Grade A']++;
        else if (e.ratingGrade.includes('B+')) gradeDistribution['Grade B+']++;
        else if (e.ratingGrade.includes('B')) gradeDistribution['Grade B']++;
      } else if (e.tlScore) {
        const s = Number(e.tlScore);
        if (s >= 9.0) gradeDistribution['Grade A+']++;
        else if (s >= 8.0) gradeDistribution['Grade A']++;
        else if (s >= 7.0) gradeDistribution['Grade B+']++;
        else if (s >= 6.0) gradeDistribution['Grade B']++;
      }
    });

    // 4. Fetch Feedback & Evaluation Comments made by this supervisor
    const commentsQuery = isTL
      ? `
        SELECT 
          ar.id,
          ar.score,
          ar.ratingGrade,
          ar.tlComments AS comment,
          ar.criteriaScores,
          ar.reviewedAt,
          m.month,
          u.empCode,
          u.name AS empName,
          d.name AS departmentName
        FROM [AssessmentReview] ar
        JOIN [MonthlySubmission] m ON ar.submissionId = m.id
        JOIN [User] u ON m.empId = u.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        WHERE (ar.evaluatorId = @supId OR u.tlId = @supId)
          AND ar.tlComments IS NOT NULL 
          AND LEN(LTRIM(RTRIM(ar.tlComments))) > 0
        ORDER BY ar.reviewedAt DESC
      `
      : `
        SELECT 
          ar.id,
          ar.score,
          ar.ratingGrade,
          ar.sglRemarks,
          ar.tlComments,
          COALESCE(ar.sglRemarks, ar.tlComments) AS comment,
          ar.criteriaScores,
          ar.reviewedAt,
          m.month,
          u.empCode,
          u.name AS empName,
          tl.name AS tlName,
          d.name AS departmentName
        FROM [AssessmentReview] ar
        JOIN [MonthlySubmission] m ON ar.submissionId = m.id
        JOIN [User] u ON m.empId = u.id
        LEFT JOIN [User] tl ON u.tlId = tl.id
        LEFT JOIN [Department] d ON u.departmentId = d.id
        WHERE u.sglId = @supId
          AND (
            (ar.sglRemarks IS NOT NULL AND LEN(LTRIM(RTRIM(ar.sglRemarks))) > 0)
            OR (ar.tlComments IS NOT NULL AND LEN(LTRIM(RTRIM(ar.tlComments))) > 0)
          )
        ORDER BY ar.reviewedAt DESC
      `;

    const commentsRes = await pool.request()
      .input('supId', sql.NVarChar, supervisor.id)
      .query(commentsQuery);

    const recentComments = (commentsRes.recordset || []).map(r => {
      let parsedCrit = null;
      if (r.criteriaScores) {
        try {
          parsedCrit = typeof r.criteriaScores === 'string' ? JSON.parse(r.criteriaScores) : r.criteriaScores;
        } catch (e) {}
      }
      return {
        ...r,
        criteriaScores: parsedCrit
      };
    });

    // 5. If SGL, also fetch subordinate TLs
    let assignedTLs: any[] = [];
    if (isSGL) {
      const tlRes = await pool.request()
        .input('supId', sql.NVarChar, supervisor.id)
        .query(`
          SELECT DISTINCT
            tl.id,
            tl.empCode,
            tl.name,
            tl.mobile,
            tl.email,
            d.name AS departmentName,
            (SELECT COUNT(*) FROM [User] e WHERE e.tlId = tl.id AND e.sglId = @supId) AS assignedEmpCount
          FROM [User] u
          JOIN [User] tl ON u.tlId = tl.id
          LEFT JOIN [Department] d ON tl.departmentId = d.id
          WHERE u.sglId = @supId
          ORDER BY tl.name ASC
        `);
      assignedTLs = tlRes.recordset || [];
    }

    return NextResponse.json({
      ok: true,
      supervisor: {
        id: supervisor.id,
        empCode: supervisor.empCode,
        name: supervisor.name,
        roleName: supervisor.roleName,
        isTL,
        isSGL,
        isActive: supervisor.isActive,
        mobile: supervisor.mobile,
        email: supervisor.email,
        designation: supervisor.designation,
        joiningDate: supervisor.joiningDate,
        unitName: supervisor.unitName,
        unitCode: supervisor.unitCode,
        departmentName: supervisor.departmentName,
        sglName: supervisor.sglName,
        sglCode: supervisor.sglCode,
      },
      metrics: {
        month,
        totalEmployees,
        submittedCount,
        evaluatedCount,
        pendingCount,
        submissionRate: totalEmployees > 0 ? Math.round((submittedCount / totalEmployees) * 100) : 0,
        evaluationRate: totalEmployees > 0 ? Math.round((evaluatedCount / totalEmployees) * 100) : 0,
        avgScore,
        gradeDistribution,
      },
      attachedEmployees,
      recentComments,
      assignedTLs,
    });
  } catch (err: any) {
    console.error('Error in supervisor-insights API:', err);
    return NextResponse.json({ error: err.message || 'Server error.' }, { status: 500 });
  }
}
