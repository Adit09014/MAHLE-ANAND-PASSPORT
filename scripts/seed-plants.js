const fs = require('fs');
const path = require('path');
const sql = require('mssql/msnodesqlv8');

const sqlFilePath = path.join(__dirname, 'seed-plants.sql');
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
  requestTimeout: 120000,
};

async function run() {
  const pool = await sql.connect(config);
  console.log('Connected to SQL Server: GrowthPortal');

  for (let i = 0; i < batches.length; i++) {
    const batch = batches[i];
    console.log(`Executing batch ${i + 1}/${batches.length}...`);
    try {
      const res = await pool.request().query(batch);
      console.log(`Batch ${i + 1} succeeded.`);
    } catch (err) {
      console.error(`Batch ${i + 1} failed:`, err.message);
      throw err;
    }
  }

  // Verify counts
  const userCount = await pool.request().query('SELECT count(*) as total FROM [User]');
  const unitBreakdown = await pool.request().query(`
    SELECT un.name as plantName, count(u.id) as userCount 
    FROM [User] u 
    LEFT JOIN [Unit] un ON u.unitId = un.id 
    GROUP BY un.name
  `);
  console.log('====================================================');
  console.log(`Total Users in Database: ${userCount.recordset[0].total}`);
  console.log('Breakdown by Plant:');
  unitBreakdown.recordset.forEach(r => console.log(`  ${r.plantName || 'Unassigned'}: ${r.userCount}`));
  console.log('====================================================');

  await pool.close();
}

run().catch(err => {
  console.error('Seed execution error:', err);
  process.exit(1);
});
