// A small, dependency-free JSON-file database. No native compilation required,
// so it installs and deploys reliably anywhere Node.js runs (including Render's
// free tier, which can't build native modules like better-sqlite3).
//
// Not built for huge scale, but is plenty for a company growth-tracking portal.
// The whole database lives in one human-readable file: data/growth.json

const fs = require('fs');
const path = require('path');

const dataDir = path.join(__dirname, 'data');
const dataFile = path.join(dataDir, 'growth.json');

if (!fs.existsSync(dataDir)) fs.mkdirSync(dataDir, { recursive: true });

function loadData() {
  if (!fs.existsSync(dataFile)) {
    return { employees: {}, supervisors: {}, sheetData: {}, submissions: {} };
  }
  try {
    return JSON.parse(fs.readFileSync(dataFile, 'utf8'));
  } catch (e) {
    console.error('Could not read data file, starting fresh:', e.message);
    return { employees: {}, supervisors: {}, sheetData: {}, submissions: {} };
  }
}

let data = loadData();

function persist() {
  const tmp = dataFile + '.tmp';
  fs.writeFileSync(tmp, JSON.stringify(data, null, 2));
  fs.renameSync(tmp, dataFile);
}

module.exports = {
  /* ---------------- employees ---------------- */
  upsertEmployeeIfMissing(id) {
    if (!data.employees[id]) {
      data.employees[id] = { name: id, createdAt: new Date().toISOString() };
      persist();
    }
  },
  setEmployeeName(id, name) {
    if (!data.employees[id]) data.employees[id] = { createdAt: new Date().toISOString() };
    data.employees[id].name = name;
    persist();
  },
  getEmployeeName(id) {
    const e = data.employees[id];
    return (e && e.name) ? e.name : id;
  },

  /* ---------------- supervisors ---------------- */
  getSupervisor(id) {
    return data.supervisors[id] || null;
  },
  upsertSupervisor(id, passwordHash) {
    const createdAt = (data.supervisors[id] && data.supervisors[id].createdAt) || new Date().toISOString();
    data.supervisors[id] = { passwordHash, createdAt };
    persist();
  },

  /* ---------------- sheet data ---------------- */
  getSheetData(empId, sheetId) {
    return (data.sheetData[empId] && data.sheetData[empId][sheetId]) || null;
  },
  setSheetData(empId, sheetId, sheetContent) {
    if (!data.sheetData[empId]) data.sheetData[empId] = {};
    data.sheetData[empId][sheetId] = sheetContent;
    persist();
  },

  /* ---------------- monthly submissions ---------------- */
  upsertSubmission(empId, month) {
    data.submissions[`${empId}::${month}`] = {
      empId, month, submittedAt: new Date().toISOString(), status: 'submitted',
    };
    persist();
  },
  getSubmission(empId, month) {
    return data.submissions[`${empId}::${month}`] || null;
  },
  listSubmissions() {
    return Object.values(data.submissions).sort((a, b) => new Date(b.submittedAt) - new Date(a.submittedAt));
  },
  markReviewed(empId) {
    let changed = false;
    Object.values(data.submissions).forEach(s => {
      if (s.empId === empId && s.status !== 'reviewed') { s.status = 'reviewed'; changed = true; }
    });
    if (changed) persist();
  },

  /* ---------------- admin export ---------------- */
  exportAll() {
    return {
      employees: data.employees,
      supervisors: Object.fromEntries(Object.entries(data.supervisors).map(([k, v]) => [k, { createdAt: v.createdAt }])),
      sheetData: data.sheetData,
      submissions: data.submissions,
    };
  },
};
