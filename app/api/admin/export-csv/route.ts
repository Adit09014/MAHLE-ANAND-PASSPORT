import { NextResponse } from 'next/server';
import store from '@/lib/db';
import { getSession } from '@/lib/session';

export async function GET(req: Request) {
  const session = await getSession();
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized.' }, { status: 401 });
  }

  const exact = session.exactRole || session.role;
  const isSuperAdmin = exact === 'Super Admin' || exact === 'HR Head';
  const isUnitAdmin = exact === 'Unit Admin';

  if (!isSuperAdmin && !isUnitAdmin) {
    return NextResponse.json({ error: 'Admin access required.' }, { status: 403 });
  }

  const url = new URL(req.url);
  let unitFilter = url.searchParams.get('unit') || 'all';
  const month = url.searchParams.get('month') || '2026-10';

  if (isUnitAdmin) {
    unitFilter = session.unitId || 'all';
  }

  try {
    const users = await store.getAllUsersForAdmin({
      unit: unitFilter,
      month,
    });

    const headers = [
      'Employee Code',
      'Full Name',
      'Father Name',
      'Mobile',
      'Email ID',
      'Date of Joining',
      'Date of Birth',
      'Designation',
      'Group Joining Date',
      'Grade Code',
      'Role',
      'Active Status',
      'Plant Unit',
      'Unit Code',
      'Department',
      'Team Leader',
      'Senior Group Leader',
      'Assessment Cycle',
      'Submission Status',
      'Self Score',
      'Submitted At',
      'TL Score (1-10)',
      'Rating Grade',
      'Evaluated At',
      'Safety & 5S Score',
      'Quality Score',
      'Productivity Score',
      'Attendance Score',
      'Kaizen Score',
      'TL Remarks',
      'SGL Remarks',
    ];

    const escapeCsv = (val: any) => {
      if (val === null || val === undefined) return '""';
      const str = String(val).replace(/"/g, '""');
      return `"${str}"`;
    };

    const rows = users.map(u => {
      let crit: any = {};
      try {
        if (u.criteriaScores) {
          crit = typeof u.criteriaScores === 'string' ? JSON.parse(u.criteriaScores) : u.criteriaScores;
        }
      } catch (e) {}

      return [
        escapeCsv(u.empCode),
        escapeCsv(u.name),
        escapeCsv(u.fatherName || ''),
        escapeCsv(u.mobile || ''),
        escapeCsv(u.email || ''),
        escapeCsv(u.joiningDate || ''),
        escapeCsv(u.dob || ''),
        escapeCsv(u.designation || ''),
        escapeCsv(u.groupJoiningDate || ''),
        escapeCsv(u.gradeCode || ''),
        escapeCsv(u.roleName),
        escapeCsv(u.isActive ? 'Active' : 'Deactivated'),
        escapeCsv(u.unitName || 'Central'),
        escapeCsv(u.unitCode || 'ALL'),
        escapeCsv(u.departmentName || 'General'),
        escapeCsv(u.tlName || 'Unassigned'),
        escapeCsv(u.sglName || 'Unassigned'),
        escapeCsv(month),
        escapeCsv(u.submissionStatus || 'not_started'),
        escapeCsv(u.selfScore !== null ? Number(u.selfScore).toFixed(1) : ''),
        escapeCsv(u.submittedAt ? new Date(u.submittedAt).toISOString().split('T')[0] : ''),
        escapeCsv(u.tlScore !== null ? Number(u.tlScore).toFixed(1) : ''),
        escapeCsv(u.ratingGrade || ''),
        escapeCsv(u.reviewedAt ? new Date(u.reviewedAt).toISOString().split('T')[0] : ''),
        escapeCsv(crit.safety || crit['5s'] || ''),
        escapeCsv(crit.quality || ''),
        escapeCsv(crit.productivity || ''),
        escapeCsv(crit.attendance || ''),
        escapeCsv(crit.kaizen || ''),
        escapeCsv(u.tlComments || ''),
        escapeCsv(u.sglRemarks || ''),
      ].join(',');
    });

    const csvContent = '\uFEFF' + [headers.join(','), ...rows].join('\r\n');

    return new NextResponse(csvContent, {
      status: 200,
      headers: {
        'Content-Type': 'text/csv; charset=utf-8',
        'Content-Disposition': `attachment; filename="MAHLE_Consolidated_Assessment_Report_${month}.csv"`,
      },
    });
  } catch (err: any) {
    console.error('Error generating CSV export:', err);
    return NextResponse.json({ error: err.message || 'Export failed.' }, { status: 500 });
  }
}
