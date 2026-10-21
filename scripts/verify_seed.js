const sql = require('mssql/msnodesqlv8');

const config = {
  driver: 'msnodesqlv8',
  connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=localhost\\MSSQLSERVER1;Database=GrowthPortal;Trusted_Connection=yes;',
};

async function verify() {
  const pool = await sql.connect(config);
  
  // 1. Role distribution
  console.log('\n--- ROLE DISTRIBUTION ---');
  const roles = await pool.request().query(`
    SELECT un.name AS plant, r.name AS role, COUNT(*) AS count
    FROM [User] u
    JOIN [Role] r ON u.roleId = r.id
    LEFT JOIN [Unit] un ON u.unitId = un.id
    WHERE un.name IN ('Gurugram', 'Parwanoo', 'Pune')
    GROUP BY un.name, r.name
    ORDER BY un.name, r.name
  `);
  console.table(roles.recordset);

  // 2. Supervisory linkage check
  console.log('\n--- SUPERVISORY LINKAGE IN 3 PLANTS ---');
  const hierarchy = await pool.request().query(`
    SELECT un.name AS plant,
      COUNT(u.id) AS totalEmployees,
      COUNT(u.tlId) AS hasTL,
      COUNT(u.sglId) AS hasSGL
    FROM [User] u
    JOIN [Role] r ON u.roleId = r.id
    JOIN [Unit] un ON u.unitId = un.id
    WHERE r.name = 'Employee' AND un.name IN ('Gurugram', 'Parwanoo', 'Pune')
    GROUP BY un.name
  `);
  console.table(hierarchy.recordset);

  // 3. Sample Parwanoo employees (check fatherName, no husband name)
  console.log('\n--- SAMPLE PARWANOO EMPLOYEES ---');
  const parwanoo = await pool.request().query(`
    SELECT TOP 5 u.empCode, u.name, u.fatherName, u.mobile, u.email, u.joiningDate, u.dob, u.designation, u.gradeCode,
                 tl.name AS tlName, sgl.name AS sglName
    FROM [User] u
    LEFT JOIN [User] tl ON u.tlId = tl.id
    LEFT JOIN [User] sgl ON u.sglId = sgl.id
    WHERE u.unitId = (SELECT id FROM [Unit] WHERE name = 'Parwanoo')
    ORDER BY u.empCode
  `);
  console.table(parwanoo.recordset);

  // 4. Sample Pune employees
  console.log('\n--- SAMPLE PUNE EMPLOYEES ---');
  const pune = await pool.request().query(`
    SELECT TOP 5 u.empCode, u.name, u.fatherName, u.mobile, u.email, u.joiningDate, u.dob, u.designation, u.gradeCode,
                 tl.name AS tlName, sgl.name AS sglName
    FROM [User] u
    LEFT JOIN [User] tl ON u.tlId = tl.id
    LEFT JOIN [User] sgl ON u.sglId = sgl.id
    WHERE u.unitId = (SELECT id FROM [Unit] WHERE name = 'Pune')
    ORDER BY u.empCode
  `);
  console.table(pune.recordset);

  // 5. Sample Gurugram employees
  console.log('\n--- SAMPLE GURUGRAM EMPLOYEES ---');
  const gurugram = await pool.request().query(`
    SELECT TOP 5 u.empCode, u.name, u.fatherName, u.mobile, u.email, u.joiningDate, u.dob, u.designation, u.gradeCode,
                 tl.name AS tlName, sgl.name AS sglName
    FROM [User] u
    LEFT JOIN [User] tl ON u.tlId = tl.id
    LEFT JOIN [User] sgl ON u.sglId = sgl.id
    WHERE u.unitId = (SELECT id FROM [Unit] WHERE name = 'Gurugram')
    ORDER BY u.empCode
  `);
  console.table(gurugram.recordset);

  await pool.close();
}

verify().catch(console.error);
