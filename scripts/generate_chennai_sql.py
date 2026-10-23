import os
import openpyxl
import datetime

workspace_dir = r"d:\MAHLE__ANA_PROJECT- 2\MAHLE-ANAND-PASSPORT"
data_file = os.path.join(workspace_dir, "data", "Skill Book_Employees details-chennai.xlsx")
output_sql_file = os.path.join(workspace_dir, "scripts", "seed-chennai.sql")

def format_date(val):
    if val is None:
        return None
    if isinstance(val, (datetime.datetime, datetime.date)):
        return val.strftime('%Y-%m-%d')
    s = str(val).strip()
    if s in ('-', '#N/A', '', 'None', 'nan'):
        return None
    if ' ' in s:
        s = s.split(' ')[0]
    return s

def clean_str(val):
    if val is None:
        return None
    s = str(val).replace('\xa0', ' ').strip()
    if s in ('-', '#N/A', '', 'None', 'nan', '*'):
        return None
    return s

def clean_emp_code(val):
    if val is None:
        return None
    if isinstance(val, float) and val.is_integer():
        val = int(val)
    s = str(val).replace('\xa0', ' ').strip()
    if s in ('-', '#N/A', '', 'None', 'nan'):
        return None
    return s

def clean_mobile(val):
    if val is None:
        return None
    if isinstance(val, float) and val.is_integer():
        val = int(val)
    s = str(val).replace('\xa0', ' ').strip()
    if s in ('-', '#N/A', '', 'None', 'nan'):
        return None
    return s

def clean_grade(val):
    if val is None:
        return None
    if isinstance(val, float) and val.is_integer():
        val = int(val)
    s = str(val).replace('\xa0', ' ').strip()
    if s in ('-', '#N/A', '', 'None', 'nan'):
        return None
    return s

def sql_quote(val):
    if val is None:
        return "NULL"
    escaped = str(val).replace("'", "''")
    return f"N'{escaped}'"

wb = openpyxl.load_workbook(data_file, data_only=True)
ws = wb.active
rows = list(ws.iter_rows(values_only=True))

headers = [str(c).strip() if c is not None else "" for c in rows[0]]
data_rows = rows[1:]

chennai_records = []
for r in data_rows:
    emp_raw = r[0]
    name_raw = r[1]
    
    if emp_raw is None and name_raw is None:
        continue
    
    emp_no = clean_emp_code(emp_raw)
    if not emp_no:
        continue
        
    name = clean_str(name_raw)
    father_name = clean_str(r[2])
    mobile = clean_mobile(r[3])
    email = clean_str(r[4])
    joined_on = format_date(r[5])
    dob = format_date(r[6])
    designation = clean_str(r[7])
    group_joining = format_date(r[8])
    grade_code = clean_grade(r[9])
    login_type = str(r[10]).strip() if len(r) > 10 and r[10] is not None else "Employee"
    
    lt_lower = login_type.lower()
    if "super admin" in lt_lower:
        role = "Super Admin"
    elif "hr head" in lt_lower:
        role = "HR Head"
    elif "hr admin" in lt_lower or lt_lower == "hr" or "admin" in lt_lower:
        role = "Unit Admin"
    elif "team leader" in lt_lower:
        role = "Team Leader (TL)"
    elif "sgl" in lt_lower or "vsl" in lt_lower or "production manager" in lt_lower:
        role = "Senior Group Leader (SGL)"
    else:
        role = "Employee"
        
    rec = {
        "empCode": emp_no,
        "name": name,
        "fatherName": father_name,
        "mobile": mobile,
        "email": email,
        "joiningDate": joined_on,
        "dob": dob,
        "designation": designation,
        "groupJoiningDate": group_joining,
        "gradeCode": grade_code,
        "role": role,
        "loginTypeRaw": login_type
    }
    chennai_records.append(rec)

print(f"Total parsed Chennai records: {len(chennai_records)}")
roles_count = {}
for r in chennai_records:
    roles_count[r['role']] = roles_count.get(r['role'], 0) + 1
print("Role counts:", roles_count)

sql_lines = []
sql_lines.append("-- ============================================================================")
sql_lines.append("-- MAHLE ANAND GROWTH PASSPORT - CHENNAI PLANT DATA SEED SCRIPT")
sql_lines.append(f"-- Plant: Chennai (Code: CHN) | Total Personnel Seeded: {len(chennai_records)} records")
sql_lines.append("-- Target Database: GrowthPortal")
sql_lines.append("-- Compatible with: SQL Server 2017 / 2019 / 2022 / Azure SQL")
sql_lines.append("-- Date Generated: " + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
sql_lines.append("-- ============================================================================")
sql_lines.append("SET NOCOUNT ON;")
sql_lines.append("GO")
sql_lines.append("")
sql_lines.append("USE [GrowthPortal];")
sql_lines.append("GO")
sql_lines.append("")
sql_lines.append("BEGIN TRY")
sql_lines.append("BEGIN TRANSACTION;")
sql_lines.append("")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("-- 1. ENSURE CHENNAI UNIT EXISTS")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Chennai')")
sql_lines.append("    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Chennai', 'CHN', 1);")
sql_lines.append("ELSE")
sql_lines.append("    UPDATE [dbo].[Unit] SET [code] = 'CHN', [isActive] = 1 WHERE [name] = 'Chennai';")
sql_lines.append("")
sql_lines.append("DECLARE @unitChennai NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Chennai');")
sql_lines.append("")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("-- 2. ENSURE STANDARD DEPARTMENTS EXIST FOR CHENNAI")
sql_lines.append("-- ----------------------------------------------------------------------------")
departments = ['Manufacturing / Production', 'Quality Assurance', 'Assembly Line', 'Operations']
for dept in departments:
    sql_lines.append(f"IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = '{dept}' AND [unitId] = @unitChennai)")
    sql_lines.append(f"    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), '{dept}', @unitChennai);")

sql_lines.append("")
sql_lines.append("DECLARE @deptChennai NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitChennai);")
sql_lines.append("")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("-- 3. RESOLVE SYSTEM ROLES")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("DECLARE @rSuperAdmin NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Super Admin');")
sql_lines.append("DECLARE @rHrHead     NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'HR Head');")
sql_lines.append("DECLARE @rUnitAdmin  NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Unit Admin');")
sql_lines.append("DECLARE @rSGL        NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)');")
sql_lines.append("DECLARE @rTL         NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)');")
sql_lines.append("DECLARE @rEmployee   NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Role] WHERE [name] = 'Employee');")
sql_lines.append("")
sql_lines.append("-- Default password hash for initial user access: 'Mahle@123'")
sql_lines.append("DECLARE @defaultHash NVARCHAR(1000) = '$2b$10$QMNEYLpTPQHBfP36DMeGl.p094MbfOfESkryZmI/pi7FFoIT7w8aC';")
sql_lines.append("")
sql_lines.append("-- ============================================================================")
sql_lines.append(f"-- 4. INSERT OR UPDATE {len(chennai_records)} CHENNAI PERSONNEL")
sql_lines.append("-- ============================================================================")

role_map = {
    "Super Admin": "@rSuperAdmin",
    "HR Head": "@rHrHead",
    "Unit Admin": "@rUnitAdmin",
    "Senior Group Leader (SGL)": "@rSGL",
    "Team Leader (TL)": "@rTL",
    "Employee": "@rEmployee"
}

for rec in chennai_records:
    code = sql_quote(rec['empCode'])
    name = sql_quote(rec['name'])
    fname = sql_quote(rec['fatherName'])
    mob = sql_quote(rec['mobile'])
    em = sql_quote(rec['email'])
    jdate = sql_quote(rec['joiningDate'])
    dob = sql_quote(rec['dob'])
    desig = sql_quote(rec['designation'])
    gjdate = sql_quote(rec['groupJoiningDate'])
    grade = sql_quote(rec['gradeCode'])
    role_expr = role_map[rec['role']]
    
    block = f"""IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = {code})
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), {code}, {name}, @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), {role_expr}, @unitChennai, @deptChennai,
        {fname}, {mob}, {em}, {jdate}, {dob}, {desig}, {gjdate}, {grade}
    );
END
ELSE
BEGIN
    UPDATE [dbo].[User]
    SET [name] = ISNULL({name}, [name]),
        [passwordHash] = ISNULL([passwordHash], @defaultHash),
        [isActive] = 1,
        [roleId] = {role_expr},
        [unitId] = @unitChennai,
        [departmentId] = ISNULL([departmentId], @deptChennai),
        [fatherName] = ISNULL({fname}, [fatherName]),
        [mobile] = ISNULL({mob}, [mobile]),
        [email] = ISNULL({em}, [email]),
        [joiningDate] = ISNULL({jdate}, [joiningDate]),
        [dob] = ISNULL({dob}, [dob]),
        [designation] = ISNULL({desig}, [designation]),
        [groupJoiningDate] = ISNULL({gjdate}, [groupJoiningDate]),
        [gradeCode] = ISNULL({grade}, [gradeCode]),
        [updatedAt] = SYSUTCDATETIME()
    WHERE [empCode] = {code};
END"""
    sql_lines.append(block)

sql_lines.append("")
sql_lines.append("-- ============================================================================")
sql_lines.append("-- 5. ESTABLISH SUPERVISORY REPORTING HIERARCHY WITHIN CHENNAI")
sql_lines.append("-- ============================================================================")
sql_lines.append("-- 5.1 Link Team Leaders (TL) to Senior Group Leaders (SGL) in Chennai")
sql_lines.append("""
;WITH TlCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rTL AND unitId = @unitChennai AND isActive = 1
),
SglCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn,
           COUNT(*) OVER () AS sglCount
    FROM [dbo].[User]
    WHERE roleId = @rSGL AND unitId = @unitChennai AND isActive = 1
)
UPDATE t
SET t.sglId = s.id
FROM [dbo].[User] t
JOIN TlCTE tc ON t.id = tc.id
JOIN SglCTE s ON ((tc.rn - 1) % s.sglCount) + 1 = s.rn;
""")

sql_lines.append("-- 5.2 Link Employees to Team Leaders (TL) and SGLs in Chennai")
sql_lines.append("""
;WITH EmpCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rEmployee AND unitId = @unitChennai AND isActive = 1
),
TlCTE AS (
    SELECT id, unitId, sglId, ROW_NUMBER() OVER (ORDER BY empCode) AS rn,
           COUNT(*) OVER () AS tlCount
    FROM [dbo].[User]
    WHERE roleId = @rTL AND unitId = @unitChennai AND isActive = 1
)
UPDATE e
SET e.tlId = t.id,
    e.sglId = t.sglId
FROM [dbo].[User] e
JOIN EmpCTE ec ON e.id = ec.id
JOIN TlCTE t ON ((ec.rn - 1) % t.tlCount) + 1 = t.rn;
""")

sql_lines.append("COMMIT TRANSACTION;")
sql_lines.append("PRINT '============================================================================';")
sql_lines.append(f"PRINT 'Successfully seeded Chennai plant ({len(chennai_records)} records) into GrowthPortal!';")
sql_lines.append("PRINT '============================================================================';")
sql_lines.append("")
sql_lines.append("END TRY")
sql_lines.append("BEGIN CATCH")
sql_lines.append("    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;")
sql_lines.append("    PRINT 'Error during Chennai seeding: ' + ERROR_MESSAGE();")
sql_lines.append("    THROW;")
sql_lines.append("END CATCH;")
sql_lines.append("GO")

with open(output_sql_file, "w", encoding="utf-8") as f:
    f.write("\n".join(sql_lines))

print(f"Successfully generated Chennai-only SQL file: {output_sql_file}")
