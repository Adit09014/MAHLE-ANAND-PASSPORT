require('dotenv').config();
const path = require('path');
const express = require('express');
const session = require('express-session');
const bcrypt = require('bcryptjs');
const store = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;
const SESSION_SECRET = process.env.SESSION_SECRET;
const ADMIN_KEY = process.env.ADMIN_KEY;

if (!SESSION_SECRET) {
  console.error('Missing SESSION_SECRET in your .env file. Copy .env.example to .env and fill it in.');
  process.exit(1);
}

app.use(express.json());
app.use(session({
  secret: SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,
    maxAge: 1000 * 60 * 60 * 12, // 12 hours
    secure: process.env.NODE_ENV === 'production', // requires HTTPS in production
    sameSite: 'lax',
  },
}));

/* ---------------- ID format rules ---------------- */
const isValidEmployeeId = (id) => /^(KA|NTK)/i.test(id);
const isValidSupervisorId = (id) => /^K0/i.test(id);

/* ---------------- auth helpers ---------------- */
function requireEmployee(req, res, next) {
  if (req.session.role !== 'employee') return res.status(401).json({ error: 'Not signed in as an employee.' });
  next();
}
function requireSupervisor(req, res, next) {
  if (req.session.role !== 'supervisor') return res.status(401).json({ error: 'Not signed in as a supervisor.' });
  next();
}

/* ================= AUTH ROUTES ================= */

app.post('/api/login', (req, res) => {
  const { role, id, password } = req.body || {};
  if (!role || !id || !password) return res.status(400).json({ error: 'Missing fields.' });
  const idUpper = String(id).trim().toUpperCase();

  if (role === 'supervisor') {
    if (!isValidSupervisorId(idUpper)) {
      return res.status(400).json({ error: 'Supervisor ID must start with "K0".' });
    }
    const row = store.getSupervisor(idUpper);
    if (!row) return res.status(401).json({ error: 'No supervisor account with that ID. Ask your admin to create one.' });
    if (!bcrypt.compareSync(password, row.passwordHash)) {
      return res.status(401).json({ error: 'Incorrect password.' });
    }
    req.session.role = 'supervisor';
    req.session.id = idUpper;
    return res.json({ ok: true, role: 'supervisor', id: idUpper });
  }

  if (role === 'employee') {
    if (!isValidEmployeeId(idUpper)) {
      return res.status(400).json({ error: 'Employee ID must start with "KA" or "NTK".' });
    }
    if (String(id).trim().toLowerCase() !== String(password).trim().toLowerCase()) {
      return res.status(401).json({ error: 'Incorrect Employee ID or password.' });
    }
    store.upsertEmployeeIfMissing(idUpper);
    req.session.role = 'employee';
    req.session.id = idUpper;
    return res.json({ ok: true, role: 'employee', id: idUpper, name: store.getEmployeeName(idUpper) });
  }

  return res.status(400).json({ error: 'Unknown role.' });
});

app.post('/api/logout', (req, res) => {
  req.session.destroy(() => res.json({ ok: true }));
});

app.get('/api/session', (req, res) => {
  if (!req.session.role) return res.json({ role: null });
  const name = req.session.role === 'employee' ? store.getEmployeeName(req.session.id) : null;
  res.json({ role: req.session.role, id: req.session.id, name });
});

app.post('/api/change-password', requireSupervisor, (req, res) => {
  const { currentPassword, newPassword } = req.body || {};
  if (!currentPassword || !newPassword) return res.status(400).json({ error: 'Missing fields.' });
  if (String(newPassword).length < 6) return res.status(400).json({ error: 'New password must be at least 6 characters.' });
  const row = store.getSupervisor(req.session.id);
  if (!row || !bcrypt.compareSync(currentPassword, row.passwordHash)) {
    return res.status(401).json({ error: 'Current password is incorrect.' });
  }
  const newHash = bcrypt.hashSync(newPassword, 10);
  store.upsertSupervisor(req.session.id, newHash);
  res.json({ ok: true });
});

/* ================= SHEET DATA (own record) ================= */

app.get('/api/sheet/:sheetId', requireEmployee, (req, res) => {
  const { sheetId } = req.params;
  res.json({ data: store.getSheetData(req.session.id, sheetId) });
});

app.post('/api/sheet/:sheetId', requireEmployee, (req, res) => {
  const { sheetId } = req.params;
  if (sheetId === 'supervisor') return res.status(403).json({ error: 'Locked.' });
  const data = req.body || {};
  store.setSheetData(req.session.id, sheetId, data);
  if (sheetId === 'frontpage' && data.name) {
    store.setEmployeeName(req.session.id, data.name);
  }
  res.json({ ok: true });
});

/* ================= SHEET DATA (supervisor viewing an employee) ================= */

app.get('/api/employee/:empId/sheet/:sheetId', requireSupervisor, (req, res) => {
  const empId = req.params.empId.toUpperCase();
  const { sheetId } = req.params;
  res.json({ data: store.getSheetData(empId, sheetId) });
});

// Supervisors may only WRITE the "supervisor" sheet for someone else's record.
app.post('/api/employee/:empId/sheet/supervisor', requireSupervisor, (req, res) => {
  const empId = req.params.empId.toUpperCase();
  const data = req.body || {};
  store.setSheetData(empId, 'supervisor', data);
  res.json({ ok: true });
});

app.get('/api/employee/:empId/name', (req, res) => {
  if (!req.session.role) return res.status(401).json({ error: 'Not signed in.' });
  res.json({ name: store.getEmployeeName(req.params.empId.toUpperCase()) });
});

/* ================= MONTHLY SUBMISSIONS ================= */

app.post('/api/submit', requireEmployee, (req, res) => {
  const { month } = req.body || {};
  if (!month) return res.status(400).json({ error: 'Missing month.' });
  store.upsertSubmission(req.session.id, month);
  res.json({ ok: true });
});

app.get('/api/my-submission', requireEmployee, (req, res) => {
  const { month } = req.query;
  const row = store.getSubmission(req.session.id, month);
  res.json({ submitted: !!row, submittedAt: row ? row.submittedAt : null });
});

app.get('/api/inbox', requireSupervisor, (req, res) => {
  const rows = store.listSubmissions();
  const result = rows.map(r => ({
    empId: r.empId,
    name: store.getEmployeeName(r.empId),
    month: r.month,
    submittedAt: r.submittedAt,
    status: r.status,
  }));
  res.json({ submissions: result });
});

app.post('/api/mark-reviewed', requireSupervisor, (req, res) => {
  const { empId } = req.body || {};
  if (!empId) return res.status(400).json({ error: 'Missing empId.' });
  store.markReviewed(empId.toUpperCase());
  res.json({ ok: true });
});

/* ================= ADMIN: CREATE/RESET A SUPERVISOR (no shell required) ================= */
// Visit this URL once per supervisor you need to create:
//   /api/admin/create-supervisor?key=YOUR_ADMIN_KEY&id=K0204&password=SomeStrongPassword123
// This exists because Render's Free tier has no Shell access to run seed-supervisor.js.
// Keep your ADMIN_KEY private - anyone with it could create/reset supervisor logins.
app.get('/api/admin/create-supervisor', (req, res) => {
  if (!ADMIN_KEY || req.query.key !== ADMIN_KEY) return res.status(403).send('Invalid or missing admin key.');
  const { id, password } = req.query;
  if (!id || !password) return res.status(400).send('Missing id or password. Example: ?key=...&id=K0204&password=SomeStrongPassword123');
  const idUpper = String(id).trim().toUpperCase();
  if (!isValidSupervisorId(idUpper)) return res.status(400).send('Supervisor ID must start with "K0".');
  if (String(password).length < 6) return res.status(400).send('Password must be at least 6 characters.');
  const existed = !!store.getSupervisor(idUpper);
  const hash = bcrypt.hashSync(password, 10);
  store.upsertSupervisor(idUpper, hash);
  res.send(existed ? `Password reset for existing supervisor ${idUpper}.` : `Supervisor account ${idUpper} created. You can log in now.`);
});

/* ================= ADMIN DATA EXPORT ================= */
// Simple protected export so the site owner can pull a full backup / view of the data.
// Visit /api/admin/export?key=YOUR_ADMIN_KEY in a browser (or download it) to get JSON.
app.get('/api/admin/export', (req, res) => {
  if (!ADMIN_KEY || req.query.key !== ADMIN_KEY) return res.status(403).json({ error: 'Invalid or missing admin key.' });
  res.json({ exportedAt: new Date().toISOString(), ...store.exportAll() });
});

/* ================= STATIC FRONTEND ================= */
app.use(express.static(path.join(__dirname, 'public')));
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Growth Passport server running on port ${PORT}`);
});
