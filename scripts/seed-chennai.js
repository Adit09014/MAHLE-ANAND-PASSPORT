const fs = require('fs');
const path = require('path');
const sql = require('mssql/msnodesqlv8');

const sqlFilePath = path.join(__dirname, 'seed-chennai.sql');
const rawSql = fs.readFileSync(sqlFilePath, 'utf8');

// Split batches by GO commands on their own line
const batches = rawSql
  .split(/^\s*GO\s*$/gmi)
  .map(b => b.trim())
  .filter(b => b.length > 0);

console.log(`Loaded ${sqlFilePath}. Found ${batches.length} batch(es).`);

const config = {
  driver: 'msnodesqlv8',
  connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=localhost\\MSSQLSERVER1;Database=GrowthPortal;Trusted_Connection=yes;',
  requestTimeout: 180000,
};

async function run() {
  console.log('Connecting to SQL Server: GrowthPortal (localhost\\MSSQLSERVER1)...');
  const pool = await sql.connect(config);
  console.log('Connected successfully!');

  for (let i = 0; i < batches.length; i++) {
    const batch = batches[i];
    console.log(`Executing batch ${i + 1}/${batches.length}...`);
    try {
      await pool.request().query(batch);
      console.log(`Batch ${i + 1} succeeded.`);
    } catch (err) {
      console.error(`Batch ${i + 1} failed:`, err.message);
      throw err;
    }
  }

  console.log('\n====================================================');
  console.log('VERIFYING CHENNAI DATA IN DATABASE');
  console.log('====================================================');

  // Verify Unit
  const unitRes = await pool.request().query("SELECT * FROM [Unit] WHERE name = 'Chennai'");
  console.log('Chennai Unit:');
  console.table(unitRes.recordset);

  // Role Breakdown for Chennai
  const rolesRes = await pool.request().query(`
    SELECT r.name AS role, COUNT(u.id) AS count
    FROM [User] u
    JOIN [Role] r ON u.roleId = r.id
    JOIN [Unit] un ON u.unitId = un.id
    WHERE un.name = 'Chennai'
    GROUP BY r.name
    ORDER BY count DESC
  `);
  console.log('Chennai Role Distribution:');
  console.table(rolesRes.recordset);

  // Hierarchy check for Chennai
  const hierarchyRes = await pool.request().query(`
    SELECT 
      COUNT(u.id) AS totalChennaiEmployees,
      COUNT(u.tlId) AS assignedToTL,
      COUNT(u.sglId) AS assignedToSGL
    FROM [User] u
    JOIN [Role] r ON u.roleId = r.id
    JOIN [Unit] un ON u.unitId = un.id
    WHERE un.name = 'Chennai' AND r.name = 'Employee'
  `);
  console.log('Chennai Supervisory Linkage for Employees:');
  console.table(hierarchyRes.recordset);

  // Sample Chennai records
  const sampleRes = await pool.request().query(`
    SELECT TOP 5 
      u.empCode, u.name, u.fatherName, u.mobile, u.email, u.joiningDate, u.dob, u.designation, u.gradeCode,
      r.name AS roleName, tl.name AS tlName, sgl.name AS sglName
    FROM [User] u
    JOIN [Role] r ON u.roleId = r.id
    LEFT JOIN [User] tl ON u.tlId = tl.id
    LEFT JOIN [User] sgl ON u.sglId = sgl.id
    WHERE u.unitId = (SELECT id FROM [Unit] WHERE name = 'Chennai') AND r.name = 'Employee'
    ORDER BY u.empCode
  `);
  console.log('Sample Chennai Employees with Supervisors:');
  console.table(sampleRes.recordset);

  // Total system users breakdown
  const plantCounts = await pool.request().query(`
    SELECT ISNULL(un.name, 'Unassigned') as plantName, count(u.id) as userCount 
    FROM [User] u 
    LEFT JOIN [Unit] un ON u.unitId = un.id 
    GROUP BY un.name
    ORDER BY userCount DESC
  `);
  console.log('\nSystem-wide User Distribution by Plant:');
  console.table(plantCounts.recordset);

  await pool.close();
  console.log('Seed execution completed successfully.');
}

run().catch(err => {
  console.error('Seed execution error:', err);
  process.exit(1);
});
