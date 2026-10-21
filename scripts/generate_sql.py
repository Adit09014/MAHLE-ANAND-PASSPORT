import os
import openpyxl
import datetime

workspace_dir = r"d:\MAHLE__ANA_PROJECT- 2\MAHLE-ANAND-PASSPORT"
data_dir = os.path.join(workspace_dir, "data")
output_sql_file = os.path.join(workspace_dir, "scripts", "seed-plants.sql")

files = [
    ("Gurugram", "Gurugram.xlsx", 0, "GGN"),
    ("Parwanoo", "Parwanoo_Skill Book_Employees details_.xlsx", 1, "PRW"),
    ("Pune", "Pune_Skill Book_Employees details_.xlsx", 0, "PUN")
]

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

def clean_mobile(val):
    if val is None:
        return None
    if isinstance(val, float):
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

all_records = []
plant_records = {"Gurugram": [], "Parwanoo": [], "Pune": []}

for plant, fname, h_idx, unit_code in files:
    fpath = os.path.join(data_dir, fname)
    wb = openpyxl.load_workbook(fpath, data_only=True)
    ws = wb.active
    rows = list(ws.iter_rows(values_only=True))
    headers = [str(c).strip() if c is not None else "" for c in rows[h_idx]]
    data_rows = rows[h_idx + 1:]
    
    for r_idx, r in enumerate(data_rows):
        emp_raw = r[0]
        name_raw = r[1]
        
        # Skip completely empty rows
        if not any(c is not None and str(c).strip() != "" for c in r[:11]):
            continue
            
        if emp_raw is None or str(emp_raw).strip() == "" or str(emp_raw).strip().lower() == "none":
            if name_raw and "Admin" in str(name_raw):
                emp_no = "ADMINGGN"
            else:
                continue
        else:
            emp_no = str(emp_raw).strip()
            
        name = clean_str(name_raw)
        
        # Fathers name & Husband name logic
        if plant == "Parwanoo":
            # Parwanoo: Col C (index 2) is Fathers Name, Col D (index 3) is Husband Name (IGNORE HUSBAND NAME)
            father_name = clean_str(r[2])
            mobile = clean_mobile(r[4])
            email = clean_str(r[5])
            joined_on = format_date(r[6])
            dob = format_date(r[7])
            designation = clean_str(r[8])
            group_joining = format_date(r[9])
            grade_code = clean_str(r[10])
            login_type = str(r[11]).strip() if len(r) > 11 and r[11] is not None else "Employee"
        else:
            father_name = clean_str(r[2])
            mobile = clean_mobile(r[3])
            email = clean_str(r[4])
            joined_on = format_date(r[5])
            dob = format_date(r[6])
            designation = clean_str(r[7])
            group_joining = format_date(r[8])
            grade_code = clean_str(r[9])
            login_type = str(r[10]).strip() if len(r) > 10 and r[10] is not None else "Employee"
            
        lt_lower = login_type.lower()
        if "super admin" in lt_lower:
            role = "Super Admin"
        elif "hr head" in lt_lower or (name and "hr head" in str(designation or "").lower()):
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
            "loginTypeRaw": login_type,
            "plant": plant,
            "unitCode": unit_code
        }
        all_records.append(rec)
        plant_records[plant].append(rec)

print(f"Total parsed records: {len(all_records)}")
for p, recs in plant_records.items():
    print(f"  {p}: {len(recs)} records")

sql_lines = []
sql_lines.append("-- ============================================================================")
sql_lines.append("-- MAHLE ANAND GROWTH PASSPORT - 3 PLANTS DATA SEED SCRIPT (SSMS)")
sql_lines.append("-- Plants: Gurugram, Parwanoo, Pune")
sql_lines.append(f"-- Total Personnel Seeded: {len(all_records)} records")
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
sql_lines.append("-- 1. ENSURE SYSTEM ROLES EXIST")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Super Admin')")
sql_lines.append("    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Super Admin');")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'HR Head')")
sql_lines.append("    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'HR Head');")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Unit Admin')")
sql_lines.append("    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Unit Admin');")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Senior Group Leader (SGL)')")
sql_lines.append("    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Senior Group Leader (SGL)');")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Team Leader (TL)')")
sql_lines.append("    INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Team Leader (TL)');")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Employee')")
sql_lines.append("BEGIN")
sql_lines.append("    IF EXISTS (SELECT 1 FROM [dbo].[Role] WHERE [name] = 'Shop Floor Employee')")
sql_lines.append("        UPDATE [dbo].[Role] SET [name] = 'Employee' WHERE [name] = 'Shop Floor Employee';")
sql_lines.append("    ELSE")
sql_lines.append("        INSERT INTO [dbo].[Role] ([id], [name]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Employee');")
sql_lines.append("END")
sql_lines.append("")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("-- 2. ENSURE 3 PLANT UNITS EXIST (GURUGRAM, PARWANOO, PUNE)")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Gurugram')")
sql_lines.append("    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Gurugram', 'GGN', 1);")
sql_lines.append("ELSE")
sql_lines.append("    UPDATE [dbo].[Unit] SET [code] = 'GGN', [isActive] = 1 WHERE [name] = 'Gurugram';")
sql_lines.append("")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Parwanoo')")
sql_lines.append("    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Parwanoo', 'PRW', 1);")
sql_lines.append("ELSE")
sql_lines.append("    UPDATE [dbo].[Unit] SET [code] = 'PRW', [isActive] = 1 WHERE [name] = 'Parwanoo';")
sql_lines.append("")
sql_lines.append("IF NOT EXISTS (SELECT 1 FROM [dbo].[Unit] WHERE [name] = 'Pune')")
sql_lines.append("    INSERT INTO [dbo].[Unit] ([id], [name], [code], [isActive]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), 'Pune', 'PUN', 1);")
sql_lines.append("ELSE")
sql_lines.append("    UPDATE [dbo].[Unit] SET [code] = 'PUN', [isActive] = 1 WHERE [name] = 'Pune';")
sql_lines.append("")
sql_lines.append("-- Resolve Unit IDs")
sql_lines.append("DECLARE @unitGurugram NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Gurugram');")
sql_lines.append("DECLARE @unitParwanoo NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Parwanoo');")
sql_lines.append("DECLARE @unitPune     NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Unit] WHERE [name] = 'Pune');")
sql_lines.append("")
sql_lines.append("-- ----------------------------------------------------------------------------")
sql_lines.append("-- 3. ENSURE STANDARD DEPARTMENTS EXIST FOR ALL 3 PLANTS")
sql_lines.append("-- ----------------------------------------------------------------------------")
departments = ['Manufacturing / Production', 'Quality Assurance', 'Assembly Line', 'Operations']
for dept in departments:
    sql_lines.append(f"IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = '{dept}' AND [unitId] = @unitGurugram)")
    sql_lines.append(f"    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), '{dept}', @unitGurugram);")
    sql_lines.append(f"IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = '{dept}' AND [unitId] = @unitParwanoo)")
    sql_lines.append(f"    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), '{dept}', @unitParwanoo);")
    sql_lines.append(f"IF NOT EXISTS (SELECT 1 FROM [dbo].[Department] WHERE [name] = '{dept}' AND [unitId] = @unitPune)")
    sql_lines.append(f"    INSERT INTO [dbo].[Department] ([id], [name], [unitId]) VALUES (CAST(NEWID() AS NVARCHAR(1000)), '{dept}', @unitPune);")

sql_lines.append("")
sql_lines.append("-- Resolve Primary Manufacturing Departments for each plant")
sql_lines.append("DECLARE @deptGgn NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitGurugram);")
sql_lines.append("DECLARE @deptPrw NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitParwanoo);")
sql_lines.append("DECLARE @deptPun NVARCHAR(1000) = (SELECT TOP 1 [id] FROM [dbo].[Department] WHERE [name] = 'Manufacturing / Production' AND [unitId] = @unitPune);")
sql_lines.append("")
sql_lines.append("-- Resolve Role IDs")
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

dept_var_map = {
    "Gurugram": "@deptGgn",
    "Parwanoo": "@deptPrw",
    "Pune": "@deptPun"
}

def generate_user_sql(rec):
    plant = rec['plant']
    unit_expr = f"@unit{plant}"
    dept_expr = dept_var_map[plant]
    
    role_map = {
        "Super Admin": "@rSuperAdmin",
        "HR Head": "@rHrHead",
        "Unit Admin": "@rUnitAdmin",
        "Senior Group Leader (SGL)": "@rSGL",
        "Team Leader (TL)": "@rTL",
        "Employee": "@rEmployee"
    }
    role_expr = role_map[rec['role']]
    
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
    
    block = f"""IF NOT EXISTS (SELECT 1 FROM [dbo].[User] WHERE [empCode] = {code})
BEGIN
    INSERT INTO [dbo].[User] (
        [id], [empCode], [name], [passwordHash], [isActive], [createdAt], [updatedAt], [roleId], [unitId], [departmentId],
        [fatherName], [mobile], [email], [joiningDate], [dob], [designation], [groupJoiningDate], [gradeCode]
    ) VALUES (
        CAST(NEWID() AS NVARCHAR(1000)), {code}, {name}, @defaultHash, 1, SYSUTCDATETIME(), SYSUTCDATETIME(), {role_expr}, {unit_expr}, {dept_expr},
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
        [unitId] = {unit_expr},
        [departmentId] = ISNULL([departmentId], {dept_expr}),
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
    return block

# Process all users by Plant
for plant in ["Gurugram", "Parwanoo", "Pune"]:
    recs = plant_records[plant]
    sql_lines.append("-- ============================================================================")
    sql_lines.append(f"-- SEEDING PLANT: {plant.upper()} ({len(recs)} Total Records)")
    sql_lines.append("-- ============================================================================")
    sql_lines.append("")
    
    for r in recs:
        sql_lines.append(generate_user_sql(r))
    sql_lines.append("")

# Hierarchy establishment
sql_lines.append("-- ============================================================================")
sql_lines.append("-- 4. ESTABLISH SUPERVISORY REPORTING HIERARCHY WITHIN EACH PLANT")
sql_lines.append("-- ============================================================================")
sql_lines.append("-- 4.1 Link Team Leaders (TL) to Senior Group Leaders (SGL) in the same plant")
sql_lines.append("""
;WITH TlCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rTL AND isActive = 1
),
SglCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn,
           COUNT(*) OVER (PARTITION BY unitId) AS sglCount
    FROM [dbo].[User]
    WHERE roleId = @rSGL AND isActive = 1
)
UPDATE t
SET t.sglId = s.id
FROM [dbo].[User] t
JOIN TlCTE tc ON t.id = tc.id
JOIN SglCTE s ON tc.unitId = s.unitId AND ((tc.rn - 1) % s.sglCount) + 1 = s.rn;
""")

sql_lines.append("-- 4.2 Link Employees to Team Leaders (TL) and SGLs in the same plant")
sql_lines.append("""
;WITH EmpCTE AS (
    SELECT id, unitId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn
    FROM [dbo].[User]
    WHERE roleId = @rEmployee AND isActive = 1
),
TlCTE AS (
    SELECT id, unitId, sglId, ROW_NUMBER() OVER (PARTITION BY unitId ORDER BY empCode) AS rn,
           COUNT(*) OVER (PARTITION BY unitId) AS tlCount
    FROM [dbo].[User]
    WHERE roleId = @rTL AND isActive = 1
)
UPDATE e
SET e.tlId = t.id,
    e.sglId = t.sglId
FROM [dbo].[User] e
JOIN EmpCTE ec ON e.id = ec.id
JOIN TlCTE t ON ec.unitId = t.unitId AND ((ec.rn - 1) % t.tlCount) + 1 = t.rn;
""")

sql_lines.append("COMMIT TRANSACTION;")
sql_lines.append("PRINT '============================================================================';")
sql_lines.append(f"PRINT 'Successfully seeded 3 plants ({len(all_records)} records) into GrowthPortal!';")
sql_lines.append("PRINT '============================================================================';")
sql_lines.append("")
sql_lines.append("END TRY")
sql_lines.append("BEGIN CATCH")
sql_lines.append("    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;")
sql_lines.append("    PRINT 'Error during plant seeding: ' + ERROR_MESSAGE();")
sql_lines.append("    THROW;")
sql_lines.append("END CATCH;")
sql_lines.append("GO")

# Write to file
with open(output_sql_file, "w", encoding="utf-8") as f:
    f.write("\n".join(sql_lines))

print(f"Successfully generated: {output_sql_file}")
