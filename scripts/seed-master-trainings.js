const sql = require('mssql/msnodesqlv8');

const config = {
  driver: 'msnodesqlv8',
  connectionString: 'Driver={ODBC Driver 18 for SQL Server};Server=localhost\\MSSQLSERVER1;Database=GrowthPortal;Trusted_Connection=yes;TrustServerCertificate=yes;',
};

const SEED_TRAININGS = [
  // 1. Generic Training Programme
  { title: 'Advance Product Knowledge', category: 'Generic Training Programme' },
  { title: 'NC Handling', category: 'Generic Training Programme' },
  { title: 'BBS', category: 'Generic Training Programme' },
  { title: 'SPC', category: 'Generic Training Programme' },
  { title: '7QC Tools', category: 'Generic Training Programme' },
  { title: 'Poka-Yoka', category: 'Generic Training Programme' },
  { title: 'Control Plan', category: 'Generic Training Programme' },
  { title: '8D Analysis', category: 'Generic Training Programme' },
  { title: 'MSA', category: 'Generic Training Programme' },
  { title: 'Awareness of Process', category: 'Generic Training Programme' },
  { title: 'Metrology', category: 'Generic Training Programme' },
  { title: 'AM', category: 'Generic Training Programme' },
  { title: 'PFMEA', category: 'Generic Training Programme' },
  { title: 'Production MIS', category: 'Generic Training Programme' },
  { title: 'Good Communication Skill', category: 'Generic Training Programme' },
  { title: 'SAP Knowledge', category: 'Generic Training Programme' },
  { title: 'Soft Skill / BBQ Training', category: 'Generic Training Programme' },

  // 2. Mandatory Training Plan
  { title: 'Induction', category: 'Mandatory Training Plan' },
  { title: 'CST(Creative Skill Training)', category: 'Mandatory Training Plan' },
  { title: 'ASTEr(Advanced Skill Training for Engineers)', category: 'Mandatory Training Plan' },
  { title: 'DISHA', category: 'Mandatory Training Plan' },

  // 3. STOE Training Programs
  { title: 'Safety', category: 'STOE Training Programs' },
  { title: 'Quality', category: 'STOE Training Programs' },
  { title: 'SCM', category: 'STOE Training Programs' },
  { title: 'Design', category: 'STOE Training Programs' },
  { title: 'Production', category: 'STOE Training Programs' },
  { title: 'Maintenance', category: 'STOE Training Programs' },
  { title: 'After Market', category: 'STOE Training Programs' },
  { title: 'Tooling', category: 'STOE Training Programs' },
  { title: 'PTT', category: 'STOE Training Programs' },

  // 4. Process Mastery Certification Programs
  { title: 'Water Leak Testing', category: 'Process Mastery Certification Programs' },
  { title: 'ALT -Oil Filter', category: 'Process Mastery Certification Programs' },
  { title: 'Vibration Welding', category: 'Process Mastery Certification Programs' },
  { title: 'ALT-Air Filter/EP', category: 'Process Mastery Certification Programs' },
  { title: 'Seaming', category: 'Process Mastery Certification Programs' },
  { title: 'Clipping', category: 'Process Mastery Certification Programs' },
  { title: 'Paper Pleating', category: 'Process Mastery Certification Programs' },
  { title: 'Heat Nut', category: 'Process Mastery Certification Programs' },
  { title: 'Dispencing & Dipping', category: 'Process Mastery Certification Programs' },
  { title: 'Injection Moulding', category: 'Process Mastery Certification Programs' },
  { title: 'PU - Dosing', category: 'Process Mastery Certification Programs' },
  { title: 'Coilling', category: 'Process Mastery Certification Programs' },
  { title: 'Stamping', category: 'Process Mastery Certification Programs' },
  { title: 'Ultrasonic', category: 'Process Mastery Certification Programs' },
];

async function run() {
  const pool = await sql.connect(config);
  console.log('Connected to SQL Server.');

  // Ensure category column exists
  await pool.request().query(`
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[MasterItem]') AND name = 'category')
    BEGIN
        ALTER TABLE [dbo].[MasterItem] ADD [category] NVARCHAR(100) NULL;
        PRINT 'Added category column to MasterItem.';
    END
  `);

  // Update existing items categories if null
  await pool.request().query(`
    UPDATE [MasterItem] SET category = 'Generic Training Programme' WHERE type = 'training' AND title IN ('SPC', 'PFEMA', 'TPM', 'APS Refresher', 'APS -4 Day', 'EMS', 'Product Process Knowledge', 'Sales');
    UPDATE [MasterItem] SET category = 'Mandatory Training Plan' WHERE type = 'training' AND title IN ('CST');
    UPDATE [MasterItem] SET category = 'Others' WHERE type = 'training' AND (category IS NULL OR title = 'Others');
  `);

  let sortOrder = 1;
  for (const item of SEED_TRAININGS) {
    const existing = await pool.request()
      .input('title', sql.NVarChar, item.title)
      .query(`SELECT id, category FROM [MasterItem] WHERE type = 'training' AND title = @title`);

    if (existing.recordset.length > 0) {
      await pool.request()
        .input('title', sql.NVarChar, item.title)
        .input('category', sql.NVarChar, item.category)
        .input('sortOrder', sql.Int, sortOrder)
        .query(`
          UPDATE [MasterItem]
          SET category = @category, sortOrder = @sortOrder, isActive = 1, updatedAt = SYSUTCDATETIME()
          WHERE type = 'training' AND title = @title
        `);
      console.log(`Updated: [${item.category}] ${item.title}`);
    } else {
      await pool.request()
        .input('title', sql.NVarChar, item.title)
        .input('category', sql.NVarChar, item.category)
        .input('sortOrder', sql.Int, sortOrder)
        .query(`
          INSERT INTO [MasterItem] (id, type, title, category, sortOrder, isActive, createdAt, updatedAt)
          VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'training', @title, @category, @sortOrder, 1, SYSUTCDATETIME(), SYSUTCDATETIME())
        `);
      console.log(`Inserted: [${item.category}] ${item.title}`);
    }
    sortOrder++;
  }

  const res = await pool.request().query(`
    SELECT category, COUNT(*) AS count
    FROM [MasterItem]
    WHERE type = 'training' AND isActive = 1
    GROUP BY category
    ORDER BY category
  `);
  console.log('\n--- TRAINING PROGRAM SUMMARY ---');
  console.table(res.recordset);

  process.exit(0);
}

run().catch(err => {
  console.error('Error seeding trainings:', err);
  process.exit(1);
});
