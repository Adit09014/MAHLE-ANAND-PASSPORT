
/* ============================= CONFIG ============================= */
const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const DAYS = Array.from({length:31}, (_,i)=>i+1);

const SHEETS = [
  {id:'frontpage',  num:1,  name:'About Myself',                   sub:'Your profile & details'},
  {id:'lineperf',   num:2,  name:'Line Performance',                sub:'Rejection, production, 5-S'},
  {id:'attendance', num:3,  name:'Attendance Sheet',                sub:'Daily attendance & extra work'},
  {id:'iip',        num:4,  name:'IIP Matrix',                      sub:'Improvement ideas & benefits'},
  {id:'training',   num:5,  name:'Training Matrix',                 sub:'On-the-job & program training'},
  {id:'keylearning',num:6,  name:'Key Learnings',                   sub:'Skills acquired by month'},
  {id:'activities', num:7,  name:'Activities',                      sub:'Participation in plant activities'},
  {id:'swot',       num:8,  name:'SWOT Analysis',                   sub:'Strengths, weaknesses, opportunities, threats'},
  {id:'selfdev',    num:9,  name:'Self Development Course Details', sub:'Technical & non-technical courses'},
  {id:'supervisor', num:10, name:'Supervisor Remarks',              sub:'Ratings & sign-off'},
];

let currentRole = null;      // 'employee' | 'supervisor'
let currentEmpId = null;     // whoever is logged in
let currentSheetId = null;
let viewingEmpId = null;     // whose record is on screen

/* ============================= API HELPERS ============================= */
async function api(path, opts = {}) {
  const res = await fetch(path, {
    method: opts.method || 'GET',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: opts.body ? JSON.stringify(opts.body) : undefined,
  });
  let json = {};
  try { json = await res.json(); } catch (e) {}
  if (!res.ok) throw new Error(json.error || 'Request failed.');
  return json;
}

async function loadSheetData(empId, sheetId) {
  try {
    const path = (currentRole === 'supervisor' && sheetId !== 'supervisor')
      ? `/api/employee/${empId}/sheet/${sheetId}`
      : (currentRole === 'supervisor' ? `/api/employee/${empId}/sheet/supervisor` : `/api/sheet/${sheetId}`);
    const { data } = await api(path);
    return data;
  } catch (e) { return null; }
}
async function saveSheetData(empId, sheetId, data) {
  try {
    const path = (currentRole === 'supervisor')
      ? `/api/employee/${empId}/sheet/supervisor`
      : `/api/sheet/${sheetId}`;
    await api(path, { method: 'POST', body: data });
    return true;
  } catch (e) { console.error(e); return false; }
}
async function getDisplayName(empId) {
  try { const { name } = await api(`/api/employee/${empId}/name`); return name; }
  catch (e) { return empId; }
}
function currentMonthLabel() {
  return new Date().toLocaleString('default', { month: 'long', year: 'numeric' });
}

/* ============================= SCREENS ============================= */
const screens = {
  login: document.getElementById('screen-login'),
  home: document.getElementById('screen-home'),
  inbox: document.getElementById('screen-inbox'),
  menu: document.getElementById('screen-menu'),
  form: document.getElementById('screen-form'),
};
function showScreen(name) {
  Object.values(screens).forEach(s => s.classList.add('hidden'));
  screens[name].classList.remove('hidden');
  document.getElementById('topbar').classList.toggle('hidden', name === 'login');
  document.getElementById('appBody').classList.toggle('hidden', name === 'login');
  window.scrollTo(0, 0);
}

function setTopbarWho(role, id, name) {
  const label = name && name !== id ? name : id;
  document.getElementById('whoName').textContent = label;
  document.getElementById('whoRole').textContent = role === 'supervisor' ? `Supervisor · ${id}` : 'Employee';
  document.getElementById('whoAvatar').innerHTML = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.7 0 4.9-2.2 4.9-4.9S14.7 2.2 12 2.2 7.1 4.4 7.1 7.1 9.3 12 12 12zm0 2.4c-3.3 0-9.8 1.6-9.8 4.9v2.5h19.6v-2.5c0-3.3-6.5-4.9-9.8-4.9z"/></svg>';
}

/* -- restore session on page load, so a refresh doesn't log people out -- */
(async function restoreSession() {
  try {
    const s = await api('/api/session');
    if (s.role) {
      currentRole = s.role;
      currentEmpId = s.id;
      viewingEmpId = s.role === 'employee' ? s.id : null;
      setTopbarWho(s.role, s.id, s.name);
      await renderHome();
      renderSidebar();
      showScreen('home');
      return;
    }
  } catch (e) {}
  showScreen('login');
})();

/* ============================= LOGIN ============================= */
document.querySelectorAll('#roleToggle button').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('#roleToggle button').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    const role = btn.dataset.role;
    document.getElementById('loginError').textContent = '';
    if (role === 'supervisor') {
      document.getElementById('loginHeading').textContent = 'Supervisor Sign In';
      document.getElementById('loginIdLabel').textContent = 'Supervisor ID';
      document.getElementById('loginId').placeholder = 'e.g. K0204';
      document.getElementById('loginPwLabel').textContent = 'Password';
      document.getElementById('loginPw').placeholder = 'Supervisor password';
      document.getElementById('loginNote').textContent = 'Ask your admin if you don\u2019t have an account yet.';
    } else {
      document.getElementById('loginHeading').textContent = 'Sign In';
      document.getElementById('loginIdLabel').textContent = 'Employee ID';
      document.getElementById('loginId').placeholder = 'e.g. KA1042 or NTK1042';
      document.getElementById('loginPwLabel').textContent = 'Password';
      document.getElementById('loginPw').placeholder = 'Password';
      document.getElementById('loginNote').textContent = 'Enter your Employee ID and password to continue.';
    }
  });
});

document.getElementById('loginBtn').addEventListener('click', doLogin);
document.getElementById('loginPw').addEventListener('keydown', e => { if (e.key === 'Enter') doLogin(); });
document.getElementById('loginId').addEventListener('keydown', e => { if (e.key === 'Enter') document.getElementById('loginPw').focus(); });

async function doLogin() {
  const id = document.getElementById('loginId').value.trim();
  const pw = document.getElementById('loginPw').value.trim();
  const role = document.querySelector('#roleToggle button.active').dataset.role;
  const errEl = document.getElementById('loginError');
  errEl.textContent = '';
  if (!id || !pw) { errEl.textContent = 'Please fill in both fields.'; return; }

  try {
    const result = await api('/api/login', { method: 'POST', body: { role, id, password: pw } });
    currentRole = result.role;
    currentEmpId = result.id;
    viewingEmpId = result.role === 'employee' ? result.id : null;
    setTopbarWho(result.role, result.id, result.name);
    document.getElementById('loginId').value = '';
    document.getElementById('loginPw').value = '';
    await renderHome();
    renderSidebar();
    showScreen('home');
  } catch (e) {
    errEl.textContent = e.message;
  }
}

document.getElementById('logoutBtn').addEventListener('click', async () => {
  try { await api('/api/logout', { method: 'POST' }); } catch (e) {}
  currentRole = null; currentEmpId = null; currentSheetId = null; viewingEmpId = null;
  showScreen('login');
});

/* ============================= HOME (role-aware) ============================= */
async function renderHome() {
  const isSup = currentRole === 'supervisor';
  document.getElementById('homeEmployee').classList.toggle('hidden', isSup);
  document.getElementById('homeSupervisor').classList.toggle('hidden', !isSup);
  document.getElementById('lookupError').textContent = '';
  document.getElementById('lookupId').value = '';
  document.getElementById('pwError').textContent = '';

  if (isSup) {
    document.getElementById('homeEyebrow').textContent = 'Supervisor Console';
    document.getElementById('homeGreeting').textContent = `Welcome, ${currentEmpId}`;
    document.getElementById('homeLead').textContent = 'Review employee growth records and complete supervisor remarks.';
  } else {
    document.getElementById('homeEyebrow').textContent = 'Home';
    const displayName = await getDisplayName(currentEmpId);
    document.getElementById('homeGreeting').textContent = `Welcome, ${displayName}`;
    document.getElementById('homeLead').textContent = "This is your growth profile. It keeps you updated on your performance through the year and helps you plan further improvement.";
  }
}

/* ============================= SIDEBAR ============================= */
function renderSidebar() {
  const sidebar = document.getElementById('sidebar');
  let html = `<button class="sb-link-top" data-action="home">Home</button>`;

  if (currentRole === 'employee') {
    html += `<div class="sb-group" data-group="growth">
      <button class="sb-group-header" data-toggle="growth"><span>Growth Performance</span><span class="chev">&#9662;</span></button>
      <div class="sb-group-body">
        ${SHEETS.map(s => `<button class="sb-link" data-sheet="${s.id}"><span class="sb-link-num">${String(s.num).padStart(2, '0')}</span>${s.name}</button>`).join('')}
      </div>
    </div>`;
  } else if (currentRole === 'supervisor') {
    html += `<div class="sb-group" data-group="sup">
      <button class="sb-group-header" data-toggle="sup"><span>Supervisor</span><span class="chev">&#9662;</span></button>
      <div class="sb-group-body">
        <button class="sb-link" data-action="inbox"><span class="sb-link-num">&middot;</span>Submissions Inbox</button>
        <button class="sb-link" data-action="lookup"><span class="sb-link-num">&middot;</span>Look Up Employee</button>
        <button class="sb-link" data-action="changepw"><span class="sb-link-num">&middot;</span>Change Password</button>
      </div>
    </div>`;
    if (viewingEmpId) {
      html += `<div class="sb-group" data-group="record">
        <button class="sb-group-header" data-toggle="record"><span>Record: ${esc(viewingEmpId)}</span><span class="chev">&#9662;</span></button>
        <div class="sb-group-body">
          ${SHEETS.map(s => `<button class="sb-link" data-sheet="${s.id}"><span class="sb-link-num">${String(s.num).padStart(2, '0')}</span>${s.name}</button>`).join('')}
        </div>
      </div>`;
    }
  }

  sidebar.innerHTML = html;

  sidebar.querySelectorAll('[data-toggle]').forEach(btn => {
    btn.addEventListener('click', () => btn.closest('.sb-group').classList.toggle('collapsed'));
  });
  sidebar.querySelectorAll('[data-sheet]').forEach(btn => {
    btn.addEventListener('click', () => openSheet(btn.dataset.sheet));
  });
  sidebar.querySelector('[data-action="home"]').addEventListener('click', () => { renderHome(); showScreen('home'); });
  const inboxBtn = sidebar.querySelector('[data-action="inbox"]');
  if (inboxBtn) inboxBtn.addEventListener('click', async () => { await renderInbox(); showScreen('inbox'); });
  const lookupLink = sidebar.querySelector('[data-action="lookup"]');
  if (lookupLink) lookupLink.addEventListener('click', () => { renderHome(); showScreen('home'); setTimeout(() => document.getElementById('lookupId').focus(), 50); });
  const changepwLink = sidebar.querySelector('[data-action="changepw"]');
  if (changepwLink) changepwLink.addEventListener('click', () => { renderHome(); showScreen('home'); setTimeout(() => document.getElementById('pwCurrent').focus(), 50); });

  updateSidebarActive();
}
function updateSidebarActive() {
  document.querySelectorAll('.sb-link[data-sheet]').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.sheet === currentSheetId && !screens.form.classList.contains('hidden'));
  });
}

document.getElementById('goGrowthBtn').addEventListener('click', () => { viewingEmpId = currentEmpId; renderMenu(); showScreen('menu'); });
document.getElementById('backHomeBtn').addEventListener('click', () => { renderHome(); showScreen('home'); });
document.getElementById('backMenuBtn').addEventListener('click', () => { renderMenu(); showScreen('menu'); });

/* ============================= SUPERVISOR: CHANGE PASSWORD ============================= */
document.getElementById('changePwBtn').addEventListener('click', async () => {
  const cur = document.getElementById('pwCurrent').value.trim();
  const next = document.getElementById('pwNew').value.trim();
  const confirm = document.getElementById('pwConfirm').value.trim();
  const errEl = document.getElementById('pwError');
  errEl.textContent = '';
  if (!cur || !next || !confirm) { errEl.textContent = 'Fill in all three fields.'; return; }
  if (next !== confirm) { errEl.textContent = 'New password and confirmation do not match.'; return; }
  try {
    await api('/api/change-password', { method: 'POST', body: { currentPassword: cur, newPassword: next } });
    document.getElementById('pwCurrent').value = '';
    document.getElementById('pwNew').value = '';
    document.getElementById('pwConfirm').value = '';
    showToast('Password updated');
  } catch (e) {
    errEl.textContent = e.message;
  }
});

/* ============================= SUPERVISOR: INBOX + LOOKUP ============================= */
document.getElementById('goInboxBtn').addEventListener('click', async () => { await renderInbox(); showScreen('inbox'); });
document.getElementById('inboxBackBtn').addEventListener('click', () => { renderHome(); showScreen('home'); });

async function renderInbox() {
  const list = document.getElementById('inboxList');
  list.innerHTML = '<p class="empty-note">Loading…</p>';
  let submissions = [];
  try { ({ submissions } = await api('/api/inbox')); } catch (e) {}
  if (!submissions.length) {
    list.innerHTML = '<p class="empty-note">No submissions yet. Entries appear here once an employee submits their monthly record.</p>';
    return;
  }
  list.innerHTML = '';
  submissions.forEach(sub => {
    const row = document.createElement('div');
    row.className = 'inbox-row';
    const when = new Date(sub.submittedAt).toLocaleString();
    row.innerHTML = `
      <div>
        <div class="ir-emp">${esc(sub.name)} <span style="color:var(--ink-dim);font-weight:500;">(${esc(sub.empId)})</span></div>
        <div class="ir-sub">${esc(sub.month)} · submitted ${esc(when)}</div>
      </div>
      <div style="display:flex;align-items:center;gap:12px;">
        <span class="status-pill ${sub.status === 'reviewed' ? 'reviewed' : 'new'}">${sub.status === 'reviewed' ? 'Reviewed' : 'New'}</span>
        <button class="btn btn-primary open-record-btn">Open</button>
      </div>`;
    row.querySelector('.open-record-btn').addEventListener('click', async () => {
      viewingEmpId = sub.empId;
      renderSidebar();
      await renderMenu();
      showScreen('menu');
    });
    list.appendChild(row);
  });
}

document.getElementById('lookupBtn').addEventListener('click', async () => {
  const id = document.getElementById('lookupId').value.trim().toUpperCase();
  const errEl = document.getElementById('lookupError');
  errEl.textContent = '';
  if (!id) { errEl.textContent = 'Enter an Employee ID.'; return; }
  viewingEmpId = id;
  renderSidebar();
  await renderMenu();
  showScreen('menu');
});

document.getElementById('rhMarkReviewedBtn').addEventListener('click', async () => {
  try {
    await api('/api/mark-reviewed', { method: 'POST', body: { empId: viewingEmpId } });
    showToast('Marked reviewed');
  } catch (e) { showToast(e.message); }
});

/* ============================= GROWTH MENU / RECORD ============================= */
const dropdown = document.getElementById('sheetDropdown');
function rebuildDropdown() {
  dropdown.innerHTML = '<option value="">— Select a section —</option>';
  SHEETS.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.textContent = `${s.num}. ${s.name}`;
    dropdown.appendChild(opt);
  });
}
document.getElementById('dropdownGoBtn').addEventListener('click', () => {
  if (dropdown.value) openSheet(dropdown.value);
});

async function renderMenu() {
  rebuildDropdown();
  const isSup = currentRole === 'supervisor';
  const recordHeader = document.getElementById('recordHeader');
  const submitBox = document.getElementById('submitBox');

  if (isSup) {
    recordHeader.classList.remove('hidden');
    submitBox.classList.add('hidden');
    document.getElementById('menuEyebrow').textContent = 'Supervisor View';
    document.getElementById('rhName').textContent = await getDisplayName(viewingEmpId);
    document.getElementById('rhSub').textContent = `Employee ID: ${viewingEmpId} · Sections 1–9 are read-only`;
  } else {
    recordHeader.classList.add('hidden');
    submitBox.classList.remove('hidden');
    document.getElementById('menuEyebrow').textContent = 'Growth Performance';
    document.getElementById('submitMonthLabel').textContent = currentMonthLabel();
    const statusEl = document.getElementById('submitStatus');
    try {
      const { submitted, submittedAt } = await api(`/api/my-submission?month=${encodeURIComponent(currentMonthLabel())}`);
      if (submitted) {
        statusEl.textContent = `Submitted for ${currentMonthLabel()} on ${new Date(submittedAt).toLocaleString()}`;
        statusEl.classList.add('done');
      } else {
        statusEl.textContent = `Not submitted yet for ${currentMonthLabel()}`;
        statusEl.classList.remove('done');
      }
    } catch (e) {}
  }

  const grid = document.getElementById('stationGrid');
  grid.innerHTML = '';
  for (const s of SHEETS) {
    const viewOnlyTag = (s.id === 'supervisor' && !isSup); // employees can view, not edit
    const btn = document.createElement('button');
    btn.className = 'station';
    btn.innerHTML = `<div class="num">${String(s.num).padStart(2, '0')}</div>
      <div class="name">${s.name}</div>
      <div class="status" data-status="${s.id}">checking…</div>
      ${viewOnlyTag ? '<div class="locked-tag" title="View only">&#128065;</div>' : ''}`;
    btn.addEventListener('click', () => openSheet(s.id));
    grid.appendChild(btn);
  }
  for (const s of SHEETS) {
    const data = await loadSheetData(viewingEmpId, s.id);
    const el = grid.querySelector(`[data-status="${s.id}"]`);
    if (el) {
      const viewOnlyTag = (s.id === 'supervisor' && !isSup);
      const prefix = viewOnlyTag ? 'View only · ' : '';
      if (data) { el.textContent = prefix + '✓ Filled'; el.classList.add('saved'); }
      else { el.textContent = prefix + 'Not started'; }
    }
  }
}

document.getElementById('submitBtn').addEventListener('click', async () => {
  try {
    await api('/api/submit', { method: 'POST', body: { month: currentMonthLabel() } });
    showToast('Submitted to supervisor');
    renderMenu();
  } catch (e) { showToast(e.message); }
});

async function openSheet(sheetId) {
  currentSheetId = sheetId;
  const meta = SHEETS.find(s => s.id === sheetId);

  let readOnlyMessage = '';
  if (currentRole === 'supervisor' && sheetId !== 'supervisor') {
    readOnlyMessage = "Viewing only — this section belongs to the employee and can't be edited here.";
  } else if (currentRole === 'employee' && sheetId === 'supervisor') {
    readOnlyMessage = "Viewing only — Supervisor Remarks can only be filled in by your supervisor.";
  }
  const isReadOnly = !!readOnlyMessage;

  document.getElementById('formCrumb').textContent = `Growth Performance / ${String(meta.num).padStart(2, '0')}`;
  document.getElementById('formTitle').textContent = meta.name;
  const container = document.getElementById('sheetContainer');
  container.innerHTML = '<p style="color:#6b7290;">Loading…</p>';
  showScreen('form');
  updateSidebarActive();
  const saved = await loadSheetData(viewingEmpId, sheetId);
  container.classList.toggle('readonly', isReadOnly);
  RENDERERS[sheetId](container, saved || {});
  if (isReadOnly) {
    container.insertAdjacentHTML('afterbegin', `<div class="readonly-banner">${readOnlyMessage}</div>`);
    container.querySelectorAll('input, select, textarea, button').forEach(elm => elm.disabled = true);
  }
  document.getElementById('saveBtn').classList.toggle('hidden', isReadOnly);
}

document.getElementById('saveBtn').addEventListener('click', async () => {
  const data = COLLECTORS[currentSheetId]();
  const ok = await saveSheetData(viewingEmpId, currentSheetId, data);
  showToast(ok ? 'Saved' : 'Could not save — try again');
});

let toastTimer;
function showToast(msg) {
  const t = document.getElementById('saveToast');
  t.textContent = msg;
  t.classList.add('show');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => t.classList.remove('show'), 1800);
}

const RENDERERS = {};
const COLLECTORS = {};

function monthHeaderRow(extraLeadCols){
  return `<tr><th>${extraLeadCols}</th>${MONTHS.map(m=>`<th>${m}</th>`).join('')}</tr>`;
}

/* ---------- 1. FRONT PAGE ---------- */
RENDERERS.frontpage = (el, d) => {
  el.innerHTML = `
    <h2 class="section-title">About Myself</h2>
    <div class="grid-2">
      <div class="field-block"><label class="f">Name</label><input type="text" id="f_name" value="${esc(d.name)}"></div>
      <div class="field-block"><label class="f">Father's Name</label><input type="text" id="f_father" value="${esc(d.father)}"></div>
      <div class="field-block"><label class="f">Date of Birth</label><input type="date" id="f_dob" value="${esc(d.dob)}"></div>
      <div class="field-block"><label class="f">Date of Joining</label><input type="date" id="f_doj" value="${esc(d.doj)}"></div>
    </div>
    <div class="field-block"><label class="f">Permanent Address</label><textarea id="f_permaddr">${esc(d.permAddr)}</textarea></div>
    <div class="grid-2">
      <div class="field-block"><label class="f">Phone</label><input type="text" id="f_phone1" value="${esc(d.phone1)}"></div>
      <div class="field-block"><label class="f">Mobile No.</label><input type="text" id="f_mobile" value="${esc(d.mobile)}"></div>
    </div>
    <div class="field-block"><label class="f">Correspondence Address</label><textarea id="f_corraddr">${esc(d.corrAddr)}</textarea></div>
    <div class="field-block"><label class="f">Phone</label><input type="text" id="f_phone2" value="${esc(d.phone2)}"></div>
  `;
};
COLLECTORS.frontpage = () => ({
  name: val('f_name'), father: val('f_father'), dob: val('f_dob'), doj: val('f_doj'),
  permAddr: val('f_permaddr'), phone1: val('f_phone1'), mobile: val('f_mobile'),
  corrAddr: val('f_corraddr'), phone2: val('f_phone2'),
});

/* ---------- 2. LINE PERFORMANCE ---------- */
RENDERERS.lineperf = (el, d) => {
  d = Object.assign({rejection:Array(12).fill(''),production:Array(12).fill(''),fiveS:Array(12).fill(''),actions:''}, d);
  const rows = [['Rejection Level','rejection'],['Production','production'],['5-S Score','fiveS']];
  el.innerHTML = `
    <h2 class="section-title">Line Performance</h2>
    <div class="table-scroll"><table class="grid-table">
      ${monthHeaderRow('Particular')}
      ${rows.map(([label,key])=>`
        <tr><td class="rowlabel">${label}</td>
        ${MONTHS.map((m,i)=>`<td><input type="number" step="any" class="lp-${key}" data-i="${i}" value="${esc(d[key][i])}"></td>`).join('')}
        </tr>`).join('')}
    </table></div>
    <div class="field-block">
      <label class="f">Actions for Improvement (with team)</label>
      <textarea id="lp_actions">${esc(d.actions)}</textarea>
    </div>
  `;
};
COLLECTORS.lineperf = () => {
  const get = key => Array.from(document.querySelectorAll(`.lp-${key}`)).map(i=>i.value);
  return { rejection:get('rejection'), production:get('production'), fiveS:get('fiveS'), actions: val('lp_actions') };
};

/* ---------- 3. ATTENDANCE SHEET ---------- */
const ATT_CATS = ['Present (P)', 'Absent (A)', 'Leave (L)', 'Holiday (H)', 'Week Off (WO)'];
function attendanceTable(prefix, data){
  return `<div class="table-scroll"><table class="grid-table">
    <tr><th>Month</th>${ATT_CATS.map(c=>`<th>${c}</th>`).join('')}</tr>
    ${MONTHS.map((m,mi)=>`
      <tr><td class="rowlabel">${m}</td>
      ${ATT_CATS.map((_,ci)=>`
        <td><input type="number" min="0" max="31" class="att-${prefix}" data-m="${mi}" data-c="${ci}" value="${esc(data[mi] && data[mi][ci] !== undefined ? data[mi][ci] : '')}"></td>`).join('')}
      </tr>`).join('')}
  </table></div>`;
}
function emptyGrid(){ return Array.from({length:12},()=>Array(5).fill('')); }
RENDERERS.attendance = (el, d) => {
  const now = new Date();
  const currMonth = now.getMonth();
  const currYear = now.getFullYear();
  const lastMonth = currMonth === 0 ? 11 : currMonth - 1;
  const targetYear = currMonth === 0 ? currYear - 1 : currYear;

  d = Object.assign({year: targetYear, regular: emptyGrid(), extra: emptyGrid()}, d);

  el.innerHTML = `
    <h2 class="section-title">Attendance Sheet</h2>
    <div class="field-block" style="max-width: 150px;">
      <label class="f">Year</label>
      <input type="number" id="att_year" value="${esc(d.year)}">
    </div>
    <p class="small-note" style="margin-bottom:10px;">Note: You can only fill out attendance for the last month gone.</p>
    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:14px 0 8px;">Attendance</h3>
    ${attendanceTable('reg', d.regular)}
    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:20px 0 8px;">Extra Work</h3>
    ${attendanceTable('ext', d.extra)}
  `;

  const yearInput = el.querySelector('#att_year');
  const updateLocks = () => {
    const selYear = parseInt(yearInput.value, 10) || 0;
    el.querySelectorAll('.att-reg, .att-ext').forEach(inp => {
      const mi = parseInt(inp.dataset.m, 10);
      const canEdit = (selYear === targetYear && mi === lastMonth);
      inp.disabled = !canEdit;
    });
  };
  yearInput.addEventListener('input', updateLocks);
  updateLocks();
};
COLLECTORS.attendance = () => {
  const read = prefix => {
    const grid = emptyGrid();
    document.querySelectorAll(`.att-${prefix}`).forEach(inp=>{
      grid[+inp.dataset.m][+inp.dataset.c] = inp.value;
    });
    return grid;
  };
  return { year: val('att_year'), regular: read('reg'), extra: read('ext') };
};

/* ---------- 4. IIP MATRIX ---------- */
RENDERERS.iip = (el, d) => {
  d = Object.assign({workArea:'', rows:[]}, d);
  if(!d.rows.length) d.rows = [{idea:'',benefit:'',months:Array(12).fill(false)}];
  el.innerHTML = `
    <h2 class="section-title">IIP Matrix</h2>
    <div class="field-block"><label class="f">Work Area</label><input type="text" id="iip_area" value="${esc(d.workArea)}"></div>
    <div class="table-scroll"><table class="grid-table" id="iipTable">
      <tr><th>S.N.</th><th>Idea</th><th>Benefit</th>${MONTHS.map(m=>`<th>${m}</th>`).join('')}</tr>
      ${d.rows.map((r,ri)=>iipRow(r,ri)).join('')}
    </table></div>
    <button class="addrow-btn" id="iipAddBtn">+ Add idea</button>
  `;
  document.getElementById('iipAddBtn').addEventListener('click', ()=>{
    const tbl = document.getElementById('iipTable');
    const ri = tbl.querySelectorAll('tr.iip-row').length;
    tbl.insertAdjacentHTML('beforeend', iipRow({idea:'',benefit:'',months:Array(12).fill(false)}, ri));
  });
};
function iipRow(r,ri){
  return `<tr class="iip-row" data-ri="${ri}">
    <td>${ri+1}</td>
    <td><input type="text" class="cell-text iip-idea" value="${esc(r.idea)}"></td>
    <td><input type="text" class="cell-text iip-benefit" value="${esc(r.benefit)}"></td>
    ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="iip-month" data-mi="${mi}" ${r.months[mi]?'checked':''}></td>`).join('')}
  </tr>`;
}
COLLECTORS.iip = () => {
  const rows = [];
  document.querySelectorAll('#iipTable tr.iip-row').forEach(tr=>{
    rows.push({
      idea: tr.querySelector('.iip-idea').value,
      benefit: tr.querySelector('.iip-benefit').value,
      months: Array.from(tr.querySelectorAll('.iip-month')).map(c=>c.checked),
    });
  });
  return { workArea: val('iip_area'), rows };
};

/* ---------- 5. TRAINING MATRIX ---------- */
const TRAINING_FIXED = ['APS -4 Day','APS Refresher','TPM','SPC','PFEMA','EMS','Product Process Knowledge','Sales','Others'];
RENDERERS.training = (el, d) => {
  d = Object.assign({name:'',area:'', ojt:[], fixed:{}}, d);
  if(!d.ojt.length) d.ojt = [{title:'',months:Array(12).fill(false)}];
  TRAINING_FIXED.forEach(k=>{ if(!d.fixed[k]) d.fixed[k] = Array(12).fill(false); });
  el.innerHTML = `
    <h2 class="section-title">Training Matrix</h2>
    <div class="grid-2">
      <div class="field-block"><label class="f">Name</label><input type="text" id="tr_name" value="${esc(d.name)}"></div>
      <div class="field-block"><label class="f">Area</label><input type="text" id="tr_area" value="${esc(d.area)}"></div>
    </div>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:16px 0 8px;">On the Job Training</h3>
    <p class="small-note" style="margin-bottom:8px;">Any knowledge acquired about product / process technology goes here.</p>
    <div class="table-scroll"><table class="grid-table" id="ojtTable">
      ${monthHeaderRow('Training')}
      ${d.ojt.map((r,ri)=>ojtRow(r,ri)).join('')}
    </table></div>
    <button class="addrow-btn" id="ojtAddBtn">+ Add training</button>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:20px 0 8px;">Program Training</h3>
    <div class="table-scroll"><table class="grid-table">
      ${monthHeaderRow('Program')}
      ${TRAINING_FIXED.map(k=>`
        <tr><td class="rowlabel">${k}</td>
        ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="tr-fixed" data-key="${k}" data-mi="${mi}" ${d.fixed[k][mi]?'checked':''}></td>`).join('')}
        </tr>`).join('')}
    </table></div>
  `;
  document.getElementById('ojtAddBtn').addEventListener('click', ()=>{
    const tbl = document.getElementById('ojtTable');
    const ri = tbl.querySelectorAll('tr.ojt-row').length;
    tbl.insertAdjacentHTML('beforeend', ojtRow({title:'',months:Array(12).fill(false)}, ri));
  });
};
function ojtRow(r,ri){
  return `<tr class="ojt-row" data-ri="${ri}">
    <td><input type="text" class="cell-text ojt-title" value="${esc(r.title)}"></td>
    ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="ojt-month" data-mi="${mi}" ${r.months[mi]?'checked':''}></td>`).join('')}
  </tr>`;
}
COLLECTORS.training = () => {
  const ojt = [];
  document.querySelectorAll('#ojtTable tr.ojt-row').forEach(tr=>{
    ojt.push({ title: tr.querySelector('.ojt-title').value, months: Array.from(tr.querySelectorAll('.ojt-month')).map(c=>c.checked) });
  });
  const fixed = {};
  TRAINING_FIXED.forEach(k=>{ fixed[k] = Array(12).fill(false); });
  document.querySelectorAll('.tr-fixed').forEach(c=>{ fixed[c.dataset.key][+c.dataset.mi] = c.checked; });
  return { name: val('tr_name'), area: val('tr_area'), ojt, fixed };
};

/* ---------- 6. KEY LEARNINGS ---------- */
RENDERERS.keylearning = (el, d) => {
  d = Object.assign({name:'', rows:[], skills:''}, d);
  if(!d.rows.length) d.rows = [{particular:'',months:Array(12).fill('')}];
  el.innerHTML = `
    <h2 class="section-title">Key Learnings</h2>
    <div class="field-block"><label class="f">Name</label><input type="text" id="kl_name" value="${esc(d.name)}"></div>
    <div class="table-scroll"><table class="grid-table" id="klTable">
      ${monthHeaderRow('Particular')}
      ${d.rows.map((r,ri)=>klRow(r,ri)).join('')}
    </table></div>
    <button class="addrow-btn" id="klAddBtn">+ Add row</button>
    <div class="field-block" style="margin-top:14px;max-width:220px;">
      <label class="f">No. of Skills Acquired</label>
      <input type="number" id="kl_skills" value="${esc(d.skills)}">
    </div>
  `;
  document.getElementById('klAddBtn').addEventListener('click', ()=>{
    const tbl = document.getElementById('klTable');
    const ri = tbl.querySelectorAll('tr.kl-row').length;
    tbl.insertAdjacentHTML('beforeend', klRow({particular:'',months:Array(12).fill('')}, ri));
  });
};
function klRow(r,ri){
  return `<tr class="kl-row" data-ri="${ri}">
    <td><input type="text" class="cell-text kl-particular" value="${esc(r.particular)}"></td>
    ${MONTHS.map((m,mi)=>`<td><input type="text" class="cell-text kl-month" data-mi="${mi}" value="${esc(r.months[mi])}"></td>`).join('')}
  </tr>`;
}
COLLECTORS.keylearning = () => {
  const rows = [];
  document.querySelectorAll('#klTable tr.kl-row').forEach(tr=>{
    rows.push({
      particular: tr.querySelector('.kl-particular').value,
      months: Array.from(tr.querySelectorAll('.kl-month')).map(i=>i.value),
    });
  });
  return { name: val('kl_name'), rows, skills: val('kl_skills') };
};

/* ---------- 7. ACTIVITIES ---------- */
const ACTIVITY_ROWS = ['Participation in Committees','Sports','First Aid','Safety Committee','Canteen Committee','Cultural Activities','Participation in CI-meet'];
RENDERERS.activities = (el, d) => {
  d = Object.assign({rows:{}}, d);
  ACTIVITY_ROWS.forEach(k=>{ if(!d.rows[k]) d.rows[k] = Array(12).fill(false); });
  el.innerHTML = `
    <h2 class="section-title">Participation in Other Activities</h2>
    <div class="table-scroll"><table class="grid-table">
      ${monthHeaderRow('Particular')}
      ${ACTIVITY_ROWS.map(k=>`
        <tr><td class="rowlabel">${k}</td>
        ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="ac-cell" data-key="${k}" data-mi="${mi}" ${d.rows[k][mi]?'checked':''}></td>`).join('')}
        </tr>`).join('')}
    </table></div>
  `;
};
COLLECTORS.activities = () => {
  const rows = {};
  ACTIVITY_ROWS.forEach(k=>{ rows[k] = Array(12).fill(false); });
  document.querySelectorAll('.ac-cell').forEach(c=>{ rows[c.dataset.key][+c.dataset.mi] = c.checked; });
  return { rows };
};

/* ---------- 8. SWOT ANALYSIS ---------- */
RENDERERS.swot = (el, d) => {
  d = Object.assign({strength:'',weakness:'',opportunity:'',threats:''}, d);
  el.innerHTML = `
    <h2 class="section-title">SWOT Analysis</h2>
    <div class="swot-grid">
      <div class="swot-box strength"><h3>Strength</h3><textarea id="sw_strength">${esc(d.strength)}</textarea></div>
      <div class="swot-box weakness"><h3>Weakness</h3><textarea id="sw_weakness">${esc(d.weakness)}</textarea></div>
      <div class="swot-box opportunity"><h3>Opportunity</h3><textarea id="sw_opportunity">${esc(d.opportunity)}</textarea></div>
      <div class="swot-box threats"><h3>Threats</h3><textarea id="sw_threats">${esc(d.threats)}</textarea></div>
    </div>
  `;
};
COLLECTORS.swot = () => ({
  strength: val('sw_strength'), weakness: val('sw_weakness'),
  opportunity: val('sw_opportunity'), threats: val('sw_threats'),
});

/* ---------- 9. SELF DEVELOPMENT COURSE DETAILS ---------- */
function semTable(prefix, rows, appeared, cleared){
  const semHeader = ['Sem 1','Sem 2','Sem 3','Sem 4','Sem 5','Sem 6'];
  return `<div class="table-scroll"><table class="grid-table">
    <tr><th>Course</th>${semHeader.map(s=>`<th>${s}</th>`).join('')}</tr>
    ${rows.map((r,ri)=>`
      <tr class="${prefix}-row" data-ri="${ri}">
        <td><input type="text" class="cell-text ${prefix}-course" value="${esc(r.course)}"></td>
        ${r.sems.map((v,si)=>`<td><input type="text" class="cell-text ${prefix}-sem" data-si="${si}" value="${esc(v)}"></td>`).join('')}
      </tr>`).join('')}
    <tr><td class="rowlabel">Appeared</td>${appeared.map((v,si)=>`<td><input type="checkbox" class="${prefix}-appeared" data-si="${si}" ${v?'checked':''}></td>`).join('')}</tr>
    <tr><td class="rowlabel">Cleared</td>${cleared.map((v,si)=>`<td><input type="checkbox" class="${prefix}-cleared" data-si="${si}" ${v?'checked':''}></td>`).join('')}</tr>
  </table></div>`;
}
RENDERERS.selfdev = (el, d) => {
  d = Object.assign({name:'',doj:'',area:'',
    technical:{duration:'', rows:[{course:'',sems:Array(6).fill('')}], appeared:Array(6).fill(false), cleared:Array(6).fill(false)},
    nontechnical:{duration:'', rows:[{course:'',sems:Array(6).fill('')}], appeared:Array(6).fill(false), cleared:Array(6).fill(false)},
  }, d);
  el.innerHTML = `
    <h2 class="section-title">Self Development Course Details</h2>
    <div class="grid-3">
      <div class="field-block"><label class="f">Name</label><input type="text" id="sd_name" value="${esc(d.name)}"></div>
      <div class="field-block"><label class="f">Date of Joining</label><input type="date" id="sd_doj" value="${esc(d.doj)}"></div>
      <div class="field-block"><label class="f">Area</label><input type="text" id="sd_area" value="${esc(d.area)}"></div>
    </div>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:16px 0 8px;">Technical</h3>
    <div class="field-block" style="max-width:220px;"><label class="f">Duration</label><input type="text" id="sdt_duration" value="${esc(d.technical.duration)}"></div>
    ${semTable('sdt', d.technical.rows, d.technical.appeared, d.technical.cleared)}
    <button class="addrow-btn" id="sdtAddBtn">+ Add course row</button>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:20px 0 8px;">Non-Technical</h3>
    <div class="field-block" style="max-width:220px;"><label class="f">Duration</label><input type="text" id="sdn_duration" value="${esc(d.nontechnical.duration)}"></div>
    ${semTable('sdn', d.nontechnical.rows, d.nontechnical.appeared, d.nontechnical.cleared)}
    <button class="addrow-btn" id="sdnAddBtn">+ Add course row</button>
  `;
  document.getElementById('sdtAddBtn').addEventListener('click', ()=> addSemRow('sdt'));
  document.getElementById('sdnAddBtn').addEventListener('click', ()=> addSemRow('sdn'));
};
function addSemRow(prefix){
  const table = document.querySelectorAll(`.${prefix}-row`);
  const lastRow = table[table.length-1];
  const ri = table.length;
  const html = `<tr class="${prefix}-row" data-ri="${ri}">
      <td><input type="text" class="cell-text ${prefix}-course" value=""></td>
      ${Array.from({length:6}).map((_,si)=>`<td><input type="text" class="cell-text ${prefix}-sem" data-si="${si}" value=""></td>`).join('')}
    </tr>`;
  lastRow.insertAdjacentHTML('afterend', html);
}
function collectSemBlock(prefix){
  const rows = [];
  document.querySelectorAll(`.${prefix}-row`).forEach(tr=>{
    rows.push({
      course: tr.querySelector(`.${prefix}-course`).value,
      sems: Array.from(tr.querySelectorAll(`.${prefix}-sem`)).map(i=>i.value),
    });
  });
  const appeared = Array.from(document.querySelectorAll(`.${prefix}-appeared`)).map(c=>c.checked);
  const cleared = Array.from(document.querySelectorAll(`.${prefix}-cleared`)).map(c=>c.checked);
  return { duration: val(prefix+'_duration'), rows, appeared, cleared };
}
COLLECTORS.selfdev = () => ({
  name: val('sd_name'), doj: val('sd_doj'), area: val('sd_area'),
  technical: collectSemBlock('sdt'),
  nontechnical: collectSemBlock('sdn'),
});

/* ---------- 10. SUPERVISOR REMARKS ---------- */
const SUP_CRITERIA = [
  ['Performance on the Job',20],['Attendance',10],['Work Performance',20],
  ['Line Performance',20],['Recognition',10],['Documentation (Growth File)',10],
  ['AHPS / LEAN Participation',10],
];
RENDERERS.supervisor = (el, d) => {
  d = Object.assign({name:'',area:'',scores:{},signature:''}, d);
  SUP_CRITERIA.forEach(([k])=>{ if(!d.scores[k]) d.scores[k] = Array(12).fill(''); });
  el.innerHTML = `
    <h2 class="section-title">Supervisor Remarks</h2>
    <div class="grid-2">
      <div class="field-block"><label class="f">Name</label><input type="text" id="sr_name" value="${esc(d.name)}"></div>
      <div class="field-block"><label class="f">Area</label><input type="text" id="sr_area" value="${esc(d.area)}"></div>
    </div>
    <div class="table-scroll"><table class="grid-table" id="srTable">
      <tr><th>Criteria</th><th>Max Marks</th>${MONTHS.map(m=>`<th>${m}</th>`).join('')}</tr>
      ${SUP_CRITERIA.map(([k,max])=>`
        <tr><td class="rowlabel">${k}</td><td>${max}</td>
        ${MONTHS.map((m,mi)=>`<td><input type="number" min="0" max="${max}" class="sr-cell" data-key="${k}" data-mi="${mi}" value="${esc(d.scores[k][mi])}"></td>`).join('')}
        </tr>`).join('')}
      <tr class="total-row"><td class="rowlabel">Total</td><td>100</td>
        ${MONTHS.map((m,mi)=>`<td id="sr-total-${mi}">0</td>`).join('')}
      </tr>
    </table></div>
    <div class="field-block" style="max-width:320px;">
      <label class="f">Supervisor Signature</label>
      <input type="text" id="sr_signature" value="${esc(d.signature)}">
    </div>
  `;
  const recalcTotals = ()=>{
    for(let mi=0; mi<12; mi++){
      let sum = 0;
      document.querySelectorAll(`.sr-cell[data-mi="${mi}"]`).forEach(inp=>{ sum += parseFloat(inp.value)||0; });
      document.getElementById(`sr-total-${mi}`).textContent = sum;
    }
  };
  document.querySelectorAll('.sr-cell').forEach(inp=> inp.addEventListener('input', recalcTotals));
  recalcTotals();
};
COLLECTORS.supervisor = () => {
  const scores = {};
  SUP_CRITERIA.forEach(([k])=>{ scores[k] = Array(12).fill(''); });
  document.querySelectorAll('.sr-cell').forEach(inp=>{ scores[inp.dataset.key][+inp.dataset.mi] = inp.value; });
  return { name: val('sr_name'), area: val('sr_area'), scores, signature: val('sr_signature') };
};

/* ============================= UTIL ============================= */
function val(id){ const e = document.getElementById(id); return e ? e.value : ''; }
function esc(s){
  if(s===undefined || s===null) return '';
  return String(s).replace(/&/g,'&amp;').replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
