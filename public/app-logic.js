
/* ============================= CONFIG ============================= */
const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const DAYS = Array.from({length:31}, (_,i)=>i+1);

const SHEETS = [
  {id:'frontpage',  num:1,  name:'About Myself',                   sub:'Your profile & details'},
  {id:'lineperf',   num:2,  name:'Line Performance',                sub:'Rejection, production, 5-S'},
  {id:'attendance', num:3,  name:'Attendance Sheet',                sub:'Daily attendance & extra work'},
  {id:'iip',        num:4,  name:'IIP Matrix',                      sub:'Improvement ideas & benefits'},
  {id:'training',   num:5,  name:'Training Matrix',                 sub:'On-the-job & program training'},
  {id:'activities', num:6,  name:'Activities',                      sub:'Participation in plant activities'},
  {id:'swot',       num:7,  name:'SWOT Analysis',                   sub:'Strengths, weaknesses, opportunities, threats'},
  {id:'selfdev',    num:8,  name:'Self Development Course Details', sub:'Technical & non-technical courses'},
  {id:'supervisor', num:9,  name:'Supervisor Remarks',              sub:'Ratings & sign-off'},
];

let currentRole = null;      // 'employee' | 'supervisor' (legacy)
let currentExactRole = null; // 'Super Admin' | 'HR Head' | 'Unit Admin' | 'Senior Group Leader (SGL)' | 'Team Leader (TL)' | 'Employee'
let currentUser = null;
let currentUnitName = null;
let currentEmpId = null;     // whoever is logged in
let currentSheetId = null;
let viewingEmpId = null;     // whose record is on screen
let selectedUnitFilter = 'all';
let currentEvalEmpId = null;
let currentEvalEmpName = '';
let activeEmployeeInfo = null; // { name, empCode, unitName, role, departmentName, assessment }

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

async function loadSheetData(empId, sheetId, cycle = getGlobalCycle()) {
  try {
    const isSup = currentRole === 'supervisor' || (currentExactRole !== 'Employee' && currentExactRole !== 'Shop Floor Employee');
    const cParam = `cycle=${encodeURIComponent(cycle || getGlobalCycle())}`;
    const path = (isSup && sheetId !== 'supervisor')
      ? `/api/employee/${empId}/sheet/${sheetId}?${cParam}`
      : (isSup ? `/api/employee/${empId}/sheet/supervisor?${cParam}` : `/api/sheet/${sheetId}?${cParam}`);
    const { data } = await api(path);
    return data;
  } catch (e) { return null; }
}
async function saveSheetData(empId, sheetId, data, cycle = getGlobalCycle()) {
  try {
    const isSup = currentRole === 'supervisor' || (currentExactRole !== 'Employee' && currentExactRole !== 'Shop Floor Employee');
    const cParam = `cycle=${encodeURIComponent(cycle || getGlobalCycle())}`;
    const path = isSup
      ? `/api/employee/${empId}/sheet/supervisor?${cParam}`
      : `/api/sheet/${sheetId}?${cParam}`;
    await api(path, { method: 'POST', body: data });
    return true;
  } catch (e) { console.error(e); return false; }
}
async function getDisplayName(empId) {
  try { const { name } = await api(`/api/employee/${empId}/name`); return name; }
  catch (e) { return empId; }
}
/* ============================= GLOBAL ASSESSMENT CYCLE & MONTH/YEAR ENGINE ============================= */
const MONTH_NAMES = [
  { val: '01', name: 'January', short: 'Jan' },
  { val: '02', name: 'February', short: 'Feb' },
  { val: '03', name: 'March', short: 'Mar' },
  { val: '04', name: 'April', short: 'Apr' },
  { val: '05', name: 'May', short: 'May' },
  { val: '06', name: 'June', short: 'Jun' },
  { val: '07', name: 'July', short: 'Jul' },
  { val: '08', name: 'August', short: 'Aug' },
  { val: '09', name: 'September', short: 'Sep' },
  { val: '10', name: 'October', short: 'Oct' },
  { val: '11', name: 'November', short: 'Nov' },
  { val: '12', name: 'December', short: 'Dec' },
];

let globalSelectedYear = '2026';
let globalSelectedMonth = '10';

function getGlobalCycle() {
  return `${globalSelectedYear}-${globalSelectedMonth}`;
}

function getGlobalCycleLabel() {
  const m = MONTH_NAMES.find(x => x.val === globalSelectedMonth);
  return `${m ? m.name : globalSelectedMonth} ${globalSelectedYear}`;
}

function getCycleLabel(cycleStr) {
  if (!cycleStr) return getGlobalCycleLabel();
  const parts = String(cycleStr).split('-');
  if (parts.length === 2) {
    const yr = parts[0];
    const mo = parts[1];
    const m = MONTH_NAMES.find(x => x.val === mo);
    return `${m ? m.name : mo} ${yr}`;
  }
  return cycleStr;
}

function currentMonthLabel() {
  return getGlobalCycleLabel();
}

function populateAllMonthYearPickers() {
  const monthPickers = document.querySelectorAll('.cycle-month-picker');
  const yearPickers = document.querySelectorAll('.cycle-year-picker');

  const monthHtml = MONTH_NAMES.map(m => 
    `<option value="${m.val}" ${m.val === globalSelectedMonth ? 'selected' : ''}>${m.val} - ${m.name}</option>`
  ).join('');

  const now = new Date();
  const currentYr = now.getFullYear();
  const startYr = Math.min(2025, currentYr - 1);
  const endYr = Math.max(2027, currentYr + 1);
  const years = [];
  for (let y = startYr; y <= endYr; y++) years.push(y);
  if (!years.includes(parseInt(globalSelectedYear, 10))) {
    years.push(parseInt(globalSelectedYear, 10));
    years.sort();
  }

  const yearHtml = years.map(y => 
    `<option value="${y}" ${String(y) === String(globalSelectedYear) ? 'selected' : ''}>${y}</option>`
  ).join('');

  monthPickers.forEach(p => {
    p.innerHTML = monthHtml;
    p.value = globalSelectedMonth;
  });

  yearPickers.forEach(p => {
    p.innerHTML = yearHtml;
    p.value = globalSelectedYear;
  });

  syncCycleBadges();
}

async function setGlobalCycle(newMonth, newYear) {
  if (newMonth) globalSelectedMonth = String(newMonth).padStart(2, '0');
  if (newYear) globalSelectedYear = String(newYear);

  document.querySelectorAll('.cycle-month-picker').forEach(el => {
    el.value = globalSelectedMonth;
  });
  document.querySelectorAll('.cycle-year-picker').forEach(el => {
    el.value = globalSelectedYear;
  });

  syncCycleBadges();
  await refreshCurrentScreenForCycle(getGlobalCycle());
}

function syncCycleBadges() {
  const label = getGlobalCycleLabel();

  const topbarBadge = document.getElementById('topbarCycleBadge');
  if (topbarBadge) topbarBadge.textContent = label;

  const empHeroStatus = document.getElementById('empHeroStatus');
  if (empHeroStatus) empHeroStatus.textContent = `Assessment Cycle: ${label}`;

  const empScoreBadge = document.getElementById('empScoreCycleBadge');
  if (empScoreBadge) empScoreBadge.textContent = `${label} Cycle`;

  const formCycleBadge = document.getElementById('formCycleBadge');
  if (formCycleBadge) formCycleBadge.textContent = `Cycle: ${label}`;

  const submitMonthLabel = document.getElementById('submitMonthLabel');
  if (submitMonthLabel) submitMonthLabel.textContent = label;

  const submitBtn = document.getElementById('submitBtn');
  if (submitBtn) submitBtn.textContent = `Submit Passport for ${label}`;

  const adminCycleBadge = document.getElementById('adminCycleBadge');
  if (adminCycleBadge) adminCycleBadge.textContent = label;

  const uaCycleBadge = document.getElementById('uaCycleBadge');
  if (uaCycleBadge) uaCycleBadge.textContent = label;

  const tlCycleBadge = document.getElementById('tlCycleBadge');
  if (tlCycleBadge) tlCycleBadge.textContent = label;

  const tlUnitBadgeTitle = document.getElementById('tlUnitBadgeTitle');
  if (tlUnitBadgeTitle) tlUnitBadgeTitle.textContent = label;

  const sglCycleBadgeTitle = document.getElementById('sglCycleBadgeTitle');
  if (sglCycleBadgeTitle) sglCycleBadgeTitle.textContent = label;

  const histActiveCycleBadge = document.getElementById('histActiveCycleBadge');
  if (histActiveCycleBadge) histActiveCycleBadge.textContent = `Cycle: ${label}`;

  const histTableTitleCycle = document.getElementById('histTableTitleCycle');
  if (histTableTitleCycle) histTableTitleCycle.textContent = label;
}

async function refreshCurrentScreenForCycle(cycle) {
  if (screens.home && !screens.home.classList.contains('hidden')) {
    if (currentExactRole === 'Employee' || currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole)) {
      await renderEmployeeScorecard(cycle);
    } else if (currentExactRole === 'Team Leader (TL)') {
      await renderTLView(cycle);
    } else if (currentExactRole === 'Senior Group Leader (SGL)') {
      await renderSGLView(cycle);
    } else if (currentExactRole === 'Unit Admin') {
      await renderUnitAdminView(cycle);
    } else if (currentExactRole === 'Super Admin' || currentExactRole === 'HR Head') {
      await renderAdminDashboard(selectedUnitFilter || 'all', cycle);
    }
  } else if (screens.menu && !screens.menu.classList.contains('hidden')) {
    await renderMenu(cycle);
  } else if (screens.form && !screens.form.classList.contains('hidden') && currentSheetId) {
    await openSheet(currentSheetId);
  } else if (screens.inbox && !screens.inbox.classList.contains('hidden')) {
    await renderInbox(cycle);
  } else if (screens.directory && !screens.directory.classList.contains('hidden')) {
    await renderDirectory(cycle);
  } else if (screens.historical && !screens.historical.classList.contains('hidden')) {
    await renderHistoricalRecordsView(cycle);
  }
}

// Global delegated change listener for month & year pickers
document.addEventListener('change', async (e) => {
  if (e.target.classList.contains('cycle-month-picker')) {
    await setGlobalCycle(e.target.value, globalSelectedYear);
  } else if (e.target.classList.contains('cycle-year-picker')) {
    await setGlobalCycle(globalSelectedMonth, e.target.value);
  }
});

/* ============================= SCREENS ============================= */
const screens = {
  login: document.getElementById('screen-login'),
  home: document.getElementById('screen-home'),
  inbox: document.getElementById('screen-inbox'),
  directory: document.getElementById('screen-directory'),
  historical: document.getElementById('screen-historical'),
  lookup: document.getElementById('screen-lookup'),
  changepw: document.getElementById('screen-changepw'),
  masterItems: document.getElementById('screen-master-items'),
  menu: document.getElementById('screen-menu'),
  form: document.getElementById('screen-form'),
};
function showScreen(name) {
  Object.values(screens).forEach(s => s.classList.add('hidden'));
  screens[name].classList.remove('hidden');
  document.getElementById('topbar').classList.toggle('hidden', name === 'login');
  document.getElementById('appBody').classList.toggle('hidden', name === 'login');
  window.scrollTo(0, 0);
  updateEmployeeNavBar();
  updateSidebarActive();
  syncCycleBadges();
}

function setTopbarWho(role, id, name, unitName, exactRole) {
  const label = name && name !== id ? name : id;
  document.getElementById('whoName').textContent = label;
  document.getElementById('whoRole').textContent = exactRole || (role === 'supervisor' ? `Supervisor · ${id}` : 'Employee');
  
  const unitBadge = document.getElementById('whoUnitBadge');
  if (unitBadge) {
    if (unitName) {
      unitBadge.textContent = unitName;
      unitBadge.classList.remove('global', 'hidden');
    } else if (exactRole === 'Super Admin' || exactRole === 'HR Head') {
      unitBadge.textContent = 'All Units';
      unitBadge.classList.add('global');
      unitBadge.classList.remove('hidden');
    } else {
      unitBadge.textContent = '';
      unitBadge.classList.add('hidden');
    }
  }
  document.getElementById('whoAvatar').innerHTML = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12c2.7 0 4.9-2.2 4.9-4.9S14.7 2.2 12 2.2 7.1 4.4 7.1 7.1 9.3 12 12 12zm0 2.4c-3.3 0-9.8 1.6-9.8 4.9v2.5h19.6v-2.5c0-3.3-6.5-4.9-9.8-4.9z"/></svg>';

  const manageUnitsBtn = document.getElementById('topbarManageUnitsBtn');
  const unitBarEditBtn = document.getElementById('unitBarEditBtn');
  const isSuper = (exactRole === 'Super Admin' || exactRole === 'HR Head');
  if (manageUnitsBtn) manageUnitsBtn.style.display = isSuper ? 'inline-flex' : 'none';
  if (unitBarEditBtn) unitBarEditBtn.style.display = isSuper ? 'inline-flex' : 'none';
}

/* -- restore session on page load, so a refresh doesn't log people out -- */
(async function restoreSession() {
  try {
    const s = await api('/api/session');
    if (s.ok && s.role) {
      currentRole = s.role;
      currentExactRole = s.exactRole;
      currentUser = s.user;
      currentUnitName = s.unitName;
      currentEmpId = s.id;
      viewingEmpId = (s.exactRole === 'Employee' || s.exactRole === 'Shop Floor Employee') ? s.id : null;
      if (viewingEmpId) {
        await updateActiveEmployeeInfo(viewingEmpId, s.name, s.unitName);
      }
      setTopbarWho(s.role, s.id, s.name, s.unitName, s.exactRole);
      populateAllMonthYearPickers();
      await renderHome();
      renderSidebar();
      updateEmployeeNavBar();
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
      document.getElementById('loginHeading').textContent = 'Manager / Admin Sign In';
      document.getElementById('loginIdLabel').textContent = 'Employee Code / ID';
      document.getElementById('loginId').placeholder = 'e.g. K01001, UA1001, ADMIN01';
      document.getElementById('loginPwLabel').textContent = 'Password';
      document.getElementById('loginPw').placeholder = 'Passcode';
      document.getElementById('loginNote').textContent = 'Super Admin, HR Head, Unit Admin, SGL, or Team Leader login.';
    } else {
      document.getElementById('loginHeading').textContent = 'Employee Sign In';
      document.getElementById('loginIdLabel').textContent = 'Employee ID';
      document.getElementById('loginId').placeholder = 'e.g. KA1042 or NTK1042';
      document.getElementById('loginPwLabel').textContent = 'Password';
      document.getElementById('loginPw').placeholder = 'Password';
      document.getElementById('loginNote').textContent = 'Enter your Employee ID and password to access your growth passport.';
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
    currentExactRole = result.exactRole;
    currentUser = result.user;
    currentUnitName = result.unitName;
    currentEmpId = result.id;
    viewingEmpId = (result.exactRole === 'Employee' || result.exactRole === 'Shop Floor Employee') ? result.id : null;
    if (viewingEmpId) {
      await updateActiveEmployeeInfo(viewingEmpId, result.name, result.unitName);
    }
    setTopbarWho(result.role, result.id, result.name, result.unitName, result.exactRole);
    populateAllMonthYearPickers();
    document.getElementById('loginId').value = '';
    document.getElementById('loginPw').value = '';
    await renderHome();
    renderSidebar();
    updateEmployeeNavBar();
    showScreen('home');
  } catch (e) {
    errEl.textContent = e.message;
  }
}

document.getElementById('logoutBtn').addEventListener('click', async () => {
  try { await api('/api/logout', { method: 'POST' }); } catch (e) {}
  currentRole = null;
  currentExactRole = null;
  currentUser = null;
  currentUnitName = null;
  currentEmpId = null;
  currentSheetId = null;
  viewingEmpId = null;
  activeEmployeeInfo = null;
  const manageUnitsBtn = document.getElementById('topbarManageUnitsBtn');
  const unitBarEditBtn = document.getElementById('unitBarEditBtn');
  if (manageUnitsBtn) manageUnitsBtn.style.display = 'none';
  if (unitBarEditBtn) unitBarEditBtn.style.display = 'none';
  updateEmployeeNavBar();
  showScreen('login');
});

/* ============================= ACTIVE EMPLOYEE & SUB-NAV ============================= */
async function updateActiveEmployeeInfo(empId, optName, optUnit) {
  if (!empId) {
    activeEmployeeInfo = null;
    return;
  }
  try {
    const res = await api(`/api/employee/${encodeURIComponent(empId)}/name`);
    const name = res.name || optName || empId;
    const u = res.user || {};
    activeEmployeeInfo = {
      empCode: empId,
      name: name,
      unitName: u.unitName || optUnit || currentUnitName || 'Unit',
      role: (u.role === 'Shop Floor Employee' ? 'Employee' : u.role) || 'Employee',
      departmentName: u.departmentName || '',
    };
  } catch (e) {
    activeEmployeeInfo = {
      empCode: empId,
      name: optName || empId,
      unitName: optUnit || currentUnitName || 'Unit',
      role: 'Employee',
    };
  }

  try {
    const aRes = await api(`/api/employee/assessment?empCode=${encodeURIComponent(empId)}`);
    if (activeEmployeeInfo) {
      activeEmployeeInfo.assessment = aRes.assessment || null;
    }
  } catch (e) {
    if (activeEmployeeInfo) activeEmployeeInfo.assessment = null;
  }
}

async function selectEmployee(empId, optName, optUnit, targetSheet = null) {
  viewingEmpId = empId;
  await updateActiveEmployeeInfo(empId, optName, optUnit);
  renderSidebar();
  updateEmployeeNavBar();
  if (targetSheet) {
    await openSheet(targetSheet);
  } else {
    try {
      await renderMenu();
      showScreen('menu');
    } catch (err) {
      console.error('Error opening 10 sections menu:', err);
      showScreen('menu');
    }
  }
}

function deselectEmployee() {
  const isEmp = currentExactRole === 'Employee' || currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);
  viewingEmpId = isEmp ? currentEmpId : null;
  activeEmployeeInfo = null;
  renderSidebar();
  updateEmployeeNavBar();
  renderHome();
  showScreen('home');
}

function updateEmployeeNavBar() {
  const bar = document.getElementById('employeeNavBar');
  if (!bar) return;

  const isFormOrMenu = !screens.form.classList.contains('hidden') || !screens.menu.classList.contains('hidden');
  const hasEmp = !!viewingEmpId;

  if (!isFormOrMenu || !hasEmp) {
    bar.classList.add('hidden');
    return;
  }

  bar.classList.remove('hidden');

  const empName = activeEmployeeInfo?.name || viewingEmpId;
  const empCode = viewingEmpId;
  const unit = activeEmployeeInfo?.unitName || currentUnitName || 'Unit';

  const nameEl = document.getElementById('enbName');
  if (nameEl) nameEl.textContent = empName;
  const codeEl = document.getElementById('enbCode');
  if (codeEl) codeEl.textContent = empCode;
  const unitEl = document.getElementById('enbUnit');
  if (unitEl) unitEl.textContent = unit;

  // Status Badge
  const badge = document.getElementById('enbBadge');
  const a = activeEmployeeInfo?.assessment;
  const isSup = currentRole === 'supervisor' || (currentExactRole !== 'Employee' && currentExactRole !== 'Shop Floor Employee');

  if (badge) {
    const scoreVal = (a && a.tlScore !== null && a.tlScore !== undefined) ? a.tlScore : (a?.score);
    if (scoreVal !== null && scoreVal !== undefined) {
      badge.textContent = `Score: ${Number(scoreVal).toFixed(1)} / 10`;
      badge.className = 'badge badge-evaluated';
    } else if (a && (a.submissionStatus === 'submitted' || a.submissionStatus === 'Submitted')) {
      badge.textContent = 'Submitted · Awaiting Evaluation';
      badge.className = 'badge badge-submitted';
    } else {
      badge.textContent = 'Evaluation Pending';
      badge.className = 'badge badge-pending';
    }
  }

  // Populate Section Select Dropdown
  const select = document.getElementById('enbSheetSelect');
  if (select) {
    select.innerHTML = '<option value="">— Choose a Section —</option>' + SHEETS.map(s => `
      <option value="${s.id}" ${s.id === currentSheetId ? 'selected' : ''}>
        ${String(s.num).padStart(2, '0')}. ${s.name}
      </option>
    `).join('');
  }

  // Stepper buttons
  const currIdx = SHEETS.findIndex(s => s.id === currentSheetId);
  const prevBtn = document.getElementById('enbPrevBtn');
  const nextBtn = document.getElementById('enbNextBtn');
  if (prevBtn) prevBtn.disabled = currIdx <= 0;
  if (nextBtn) nextBtn.disabled = currIdx === -1 || currIdx >= SHEETS.length - 1;

  // Quick evaluate button for supervisors
  const evalBtn = document.getElementById('enbEvalBtn');
  if (evalBtn) {
    const canEval = isSup && (currentExactRole === 'Team Leader (TL)' || currentExactRole === 'Super Admin' || currentExactRole === 'HR Head' || currentExactRole === 'Unit Admin');
    evalBtn.classList.toggle('hidden', !canEval);
  }
}

// Global listeners for Employee Nav Bar
document.getElementById('enbPrevBtn')?.addEventListener('click', () => {
  const currIdx = SHEETS.findIndex(s => s.id === currentSheetId);
  if (currIdx > 0) openSheet(SHEETS[currIdx - 1].id);
});
document.getElementById('enbNextBtn')?.addEventListener('click', () => {
  const currIdx = SHEETS.findIndex(s => s.id === currentSheetId);
  if (currIdx >= 0 && currIdx < SHEETS.length - 1) openSheet(SHEETS[currIdx + 1].id);
});
document.getElementById('enbSheetSelect')?.addEventListener('change', (e) => {
  if (e.target.value) openSheet(e.target.value);
});
document.getElementById('enbGridBtn')?.addEventListener('click', async () => {
  try {
    await renderMenu();
    showScreen('menu');
  } catch (err) {
    console.error('Error opening 10 sections menu:', err);
    showScreen('menu');
  }
});
document.getElementById('enbCloseBtn')?.addEventListener('click', () => {
  deselectEmployee();
});
document.getElementById('enbEvalBtn')?.addEventListener('click', () => {
  if (!viewingEmpId) return;
  const a = activeEmployeeInfo?.assessment || {};
  const scoreVal = a.tlScore || a.score || 8.5;
  openEvalModal(viewingEmpId, activeEmployeeInfo?.name || viewingEmpId, scoreVal, a.ratingGrade || '', a.tlComments || '');
});

/* ============================= SIDEBAR ============================= */
function renderSidebar() {
  const sidebar = document.getElementById('sidebar');
  if (!sidebar) return;

  const isEmp = currentExactRole === 'Employee' || currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);
  const isHomeActive = !screens.home.classList.contains('hidden');
  const isInboxActive = !screens.inbox.classList.contains('hidden');
  const isMenuActive = !screens.menu.classList.contains('hidden');

  let html = `<button class="sb-link-top ${isHomeActive ? 'active' : ''}" data-action="home">Dashboard</button>`;

  if (!isEmp) {
    const isSuperOrHr = currentExactRole === 'Super Admin' || currentExactRole === 'HR Head';
    const isUnitAdmin = currentExactRole === 'Unit Admin';
    const isSgl = currentExactRole === 'Senior Group Leader (SGL)';
    const isHistActive = screens.historical && !screens.historical.classList.contains('hidden');

    html += `<div class="sb-section-label">Management Console</div>
      <button class="sb-link ${isInboxActive ? 'active' : ''}" data-action="inbox"><span class="sb-link-num">01</span>Submissions Inbox</button>
      <button class="sb-link ${screens.directory && !screens.directory.classList.contains('hidden') ? 'active' : ''}" data-action="directory"><span class="sb-link-num">02</span>Workforce Directory</button>`;

    let nextNum = 3;
    if (isSgl || isSuperOrHr) {
      html += `<button class="sb-link ${isHistActive ? 'active' : ''}" data-action="historical-records"><span class="sb-link-num">0${nextNum++}</span>Historical Records</button>`;
    }
    html += `<button class="sb-link" data-action="lookup"><span class="sb-link-num">0${nextNum++}</span>Look Up Employee</button>`;

    if (isSuperOrHr) {
      html += `
        <button class="sb-link" data-action="add-user"><span class="sb-link-num">0${nextNum++}</span>Add User</button>
        <button class="sb-link" data-action="cycles"><span class="sb-link-num">0${nextNum++}</span>Assessment Cycles</button>
        <button class="sb-link ${screens.masterItems && !screens.masterItems.classList.contains('hidden') ? 'active' : ''}" data-action="master-items"><span class="sb-link-num">0${nextNum++}</span>Training &amp; Activities</button>
        <button class="sb-link" data-action="export-csv"><span class="sb-link-num">0${nextNum++}</span>Export Report</button>`;
      if (currentExactRole === 'Super Admin') {
        html += `<button class="sb-link" data-action="manage-units"><span class="sb-link-num">0${nextNum++}</span>Plant / Unit Settings</button>`;
      }
    } else if (isUnitAdmin) {
      html += `
        <button class="sb-link" data-action="add-user"><span class="sb-link-num">0${nextNum++}</span>Add User</button>
        <button class="sb-link" data-action="export-csv"><span class="sb-link-num">0${nextNum++}</span>Export Report</button>`;
    }

    html += `<button class="sb-link" data-action="changepw"><span class="sb-link-num">${String(nextNum).padStart(2, '0')}</span>Security &amp; Passwords</button>`;

    // If an employee is currently selected:
    if (viewingEmpId && viewingEmpId !== currentEmpId) {
      const activeName = activeEmployeeInfo?.name || viewingEmpId;
      html += `
        <div class="sb-active-card">
          <div class="sb-active-header">
            <div>
              <div class="sb-active-tag">Selected Employee</div>
              <div class="sb-active-name" title="${esc(activeName)}">${esc(activeName)}</div>
              <div class="sb-active-code">${esc(viewingEmpId)}</div>
            </div>
            <button class="sb-btn-close" id="sbCloseBtn" title="Close record & return to console">Close</button>
          </div>
          <div class="sb-active-select-box">
            <label class="sb-active-label">Jump to Section:</label>
            <select class="sb-active-select" id="sbSheetSelect">
              ${SHEETS.map(s => `<option value="${s.id}" ${s.id === currentSheetId ? 'selected' : ''}>${String(s.num).padStart(2, '0')}. ${s.name}</option>`).join('')}
            </select>
          </div>
          <button class="btn btn-sm btn-ghost sb-btn-grid" id="sbGridBtn">10 Sections Grid</button>
        </div>
      `;
    } else {
      html += `
        <div class="sb-note-box">
          <span style="font-size:11px;color:var(--ink-dim);display:block;line-height:1.45;">
            Select an employee from Team Directory, Inbox, or Search to view their Passport.
          </span>
        </div>
      `;
    }
  } else {
    // Employee view
    html += `<div class="sb-section-label">My Growth Passport</div>
      <button class="sb-link ${isMenuActive ? 'active' : ''}" data-action="menu"><span class="sb-link-num">All</span>All 10 Sections</button>
      <div class="sb-components-list">
        ${SHEETS.map(s => `
          <button class="sb-link ${s.id === currentSheetId && !screens.form.classList.contains('hidden') ? 'active' : ''}" data-sheet="${s.id}" title="${s.name} - ${s.sub}">
            <span class="sb-link-num">${String(s.num).padStart(2, '0')}</span>
            <span class="sb-link-text">${s.name}</span>
          </button>
        `).join('')}
      </div>
      <div class="sb-section-label" style="margin-top:16px;">Account Security</div>
      <button class="sb-link" data-action="changepw"><span class="sb-link-num">Sec</span>Security &amp; Passwords</button>`;
  }

  sidebar.innerHTML = html;

  sidebar.querySelector('[data-action="home"]')?.addEventListener('click', () => {
    renderHome();
    showScreen('home');
  });

  const inboxBtn = sidebar.querySelector('[data-action="inbox"]');
  if (inboxBtn) inboxBtn.addEventListener('click', async () => {
    await renderInbox();
    showScreen('inbox');
  });

  const dirBtn = sidebar.querySelector('[data-action="directory"]');
  if (dirBtn) dirBtn.addEventListener('click', async () => {
    await renderDirectory();
    showScreen('directory');
  });

  const histLink = sidebar.querySelector('[data-action="historical-records"]');
  if (histLink) histLink.addEventListener('click', async () => {
    await renderHistoricalRecordsView();
    showScreen('historical');
  });

  const lookupLink = sidebar.querySelector('[data-action="lookup"]');
  if (lookupLink) lookupLink.addEventListener('click', () => {
    renderLookupPage();
    showScreen('lookup');
  });

  sidebar.querySelector('[data-action="add-user"]')?.addEventListener('click', () => {
    openUserMgmtModal(null);
  });

  sidebar.querySelector('[data-action="cycles"]')?.addEventListener('click', () => {
    openCycleMgmtModal();
  });

  sidebar.querySelector('[data-action="master-items"]')?.addEventListener('click', async () => {
    await renderMasterItemsPage();
    showScreen('masterItems');
  });

  sidebar.querySelector('[data-action="manage-units"]')?.addEventListener('click', () => {
    openUnitMgmtModal();
  });

  sidebar.querySelector('[data-action="export-csv"]')?.addEventListener('click', () => {
    triggerCsvExport();
  });

  const changepwLink = sidebar.querySelector('[data-action="changepw"]');
  if (changepwLink) changepwLink.addEventListener('click', () => {
    renderChangePwPage();
    showScreen('changepw');
  });

  const menuLink = sidebar.querySelector('[data-action="menu"]');
  if (menuLink) menuLink.addEventListener('click', async () => {
    if (!viewingEmpId) {
      viewingEmpId = currentEmpId;
      await updateActiveEmployeeInfo(currentEmpId);
    }
    try {
      await renderMenu();
      showScreen('menu');
    } catch (err) {
      console.error('Error opening 10 sections menu:', err);
      showScreen('menu');
    }
  });

  // Selected employee widget listeners
  sidebar.querySelector('#sbCloseBtn')?.addEventListener('click', deselectEmployee);
  sidebar.querySelector('#sbSheetSelect')?.addEventListener('change', (e) => {
    if (e.target.value) openSheet(e.target.value);
  });
  sidebar.querySelector('#sbGridBtn')?.addEventListener('click', async () => {
    try {
      await renderMenu();
      showScreen('menu');
    } catch (err) {
      console.error('Error opening 10 sections menu:', err);
      showScreen('menu');
    }
  });

  // Employee sheet list links (for employee)
  sidebar.querySelectorAll('[data-sheet]').forEach(btn => {
    btn.addEventListener('click', () => {
      viewingEmpId = currentEmpId;
      openSheet(btn.dataset.sheet);
    });
  });

  updateSidebarActive();
}

function updateSidebarActive() {
  const isFormActive = screens.form && !screens.form.classList.contains('hidden');
  const isHomeActive = screens.home && !screens.home.classList.contains('hidden');
  const isInboxActive = screens.inbox && !screens.inbox.classList.contains('hidden');
  const isDirActive = screens.directory && !screens.directory.classList.contains('hidden');
  const isHistActive = screens.historical && !screens.historical.classList.contains('hidden');
  const isLookupActive = screens.lookup && !screens.lookup.classList.contains('hidden');
  const isChangepwActive = screens.changepw && !screens.changepw.classList.contains('hidden');
  const isMenuActive = screens.menu && !screens.menu.classList.contains('hidden');

  document.querySelectorAll('.sb-link[data-sheet]').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.sheet === currentSheetId && isFormActive);
  });
  const homeBtn = document.querySelector('.sb-link-top[data-action="home"]');
  if (homeBtn) {
    homeBtn.classList.toggle('active', isHomeActive);
  }
  const inboxBtn = document.querySelector('.sb-link[data-action="inbox"]');
  if (inboxBtn) {
    inboxBtn.classList.toggle('active', isInboxActive);
  }
  const dirBtn = document.querySelector('.sb-link[data-action="directory"]');
  if (dirBtn) {
    dirBtn.classList.toggle('active', isDirActive);
  }
  const histBtn = document.querySelector('.sb-link[data-action="historical-records"]');
  if (histBtn) {
    histBtn.classList.toggle('active', isHistActive);
  }
  const lookupBtn = document.querySelector('.sb-link[data-action="lookup"]');
  if (lookupBtn) {
    lookupBtn.classList.toggle('active', isLookupActive);
  }
  const changepwBtn = document.querySelector('.sb-link[data-action="changepw"]');
  if (changepwBtn) {
    changepwBtn.classList.toggle('active', isChangepwActive);
  }
  const menuBtn = document.querySelector('.sb-link[data-action="menu"]');
  if (menuBtn) {
    menuBtn.classList.toggle('active', isMenuActive);
  }
  const isMasterItemsActive = screens.masterItems && !screens.masterItems.classList.contains('hidden');
  const masterItemsBtn = document.querySelector('.sb-link[data-action="master-items"]');
  if (masterItemsBtn) {
    masterItemsBtn.classList.toggle('active', isMasterItemsActive);
  }

  const sbSelect = document.getElementById('sbSheetSelect');
  if (sbSelect && currentSheetId) {
    sbSelect.value = currentSheetId;
  }
  const enbSelect = document.getElementById('enbSheetSelect');
  if (enbSelect && currentSheetId) {
    enbSelect.value = currentSheetId;
  }
}

/* ============================= HOME (role-aware dashboards) ============================= */
async function renderHome() {
  const isEmp = currentExactRole === 'Employee' || currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);

  document.getElementById('homeEmployee')?.classList.toggle('hidden', !isEmp);
  document.getElementById('homeSupervisor')?.classList.toggle('hidden', isEmp);
  if (document.getElementById('lookupError')) document.getElementById('lookupError').textContent = '';
  if (document.getElementById('lookupId')) document.getElementById('lookupId').value = '';
  if (document.getElementById('pwError')) document.getElementById('pwError').textContent = '';

  if (isEmp) {
    document.getElementById('homeEyebrow').textContent = 'Growth Performance';
    const displayName = await getDisplayName(currentEmpId);
    document.getElementById('homeGreeting').textContent = `Welcome, ${displayName}`;
    document.getElementById('homeLead').textContent = "This is your monthly growth passport dashboard. Track your assessment evaluations, review supervisor coaching, and complete all 10 passport sheets.";

    // Update hero card
    const heroName = document.getElementById('empHeroName');
    if (heroName) heroName.textContent = displayName;
    const heroCode = document.getElementById('empHeroCode');
    if (heroCode) heroCode.textContent = `ID: ${currentEmpId}`;
    const heroUnit = document.getElementById('empHeroUnit');
    if (heroUnit) heroUnit.textContent = `Plant: ${currentUnitName || 'Gurugram'}`;
    const heroRole = document.getElementById('empHeroRole');
    if (heroRole) heroRole.textContent = (currentExactRole === 'Shop Floor Employee' ? 'Employee' : currentExactRole) || 'Employee';
    const heroDept = document.getElementById('empHeroDept');
    if (heroDept) heroDept.textContent = activeEmployeeInfo?.departmentName || 'Line Operations';

    // Render 10 sheets quick-jump grid
    const grid = document.getElementById('empSheetsGrid');
    if (grid) {
      grid.innerHTML = SHEETS.map(s => `
        <div class="emp-sheet-tile" data-sheet="${s.id}">
          <div>
            <span class="emp-sheet-tile-num">Sheet ${String(s.num).padStart(2, '0')}</span>
            <div class="emp-sheet-tile-name">${esc(s.name)}</div>
            <div class="emp-sheet-tile-sub">${esc(s.sub)}</div>
          </div>
          <div class="emp-sheet-tile-footer">
            <span>Open & Edit</span>
            <span>→</span>
          </div>
        </div>
      `).join('');

      grid.querySelectorAll('.emp-sheet-tile').forEach(tile => {
        tile.addEventListener('click', () => {
          viewingEmpId = currentEmpId;
          openSheet(tile.dataset.sheet);
        });
      });
    }

    await renderEmployeeScorecard();
    return;
  }

  // Hide all sub-views initially
  const adminView = document.getElementById('homeAdminView');
  const unitAdminView = document.getElementById('homeUnitAdminView');
  const tlView = document.getElementById('homeTLView');
  const sglView = document.getElementById('homeSGLView');

  if (adminView) adminView.classList.add('hidden');
  if (unitAdminView) unitAdminView.classList.add('hidden');
  if (tlView) tlView.classList.add('hidden');
  if (sglView) sglView.classList.add('hidden');

  document.getElementById('homeEyebrow').textContent = currentExactRole || 'Supervisor Console';
  document.getElementById('homeGreeting').textContent = `Welcome, ${currentUser?.name || currentEmpId}`;

  if (currentExactRole === 'Super Admin' || currentExactRole === 'HR Head') {
    document.getElementById('homeLead').textContent = 'Centralized multi-unit assessment analytics and performance tracking across all 4 State Units.';
    if (adminView) adminView.classList.remove('hidden');
    const unitBarEditBtn = document.getElementById('unitBarEditBtn');
    if (unitBarEditBtn) unitBarEditBtn.style.display = 'inline-flex';
    await renderUnitFilterPills();
    await renderAdminDashboard(selectedUnitFilter || 'all');
  } else if (currentExactRole === 'Unit Admin') {
    document.getElementById('homeLead').textContent = `Managing operations and assessment coverage for ${currentUnitName || 'Unit'}.`;
    const uaUnitHeader = document.getElementById('uaUnitHeader');
    if (uaUnitHeader) uaUnitHeader.textContent = `${currentUnitName || 'Unit'} Directory & Assessment Status`;
    if (unitAdminView) unitAdminView.classList.remove('hidden');
    await renderUnitAdminView();
  } else if (currentExactRole === 'Team Leader (TL)') {
    document.getElementById('homeLead').textContent = `Assigned unit: ${currentUnitName || 'Unit'}. Review and evaluate employees under your leadership (1 - 10 scale).`;
    if (tlView) tlView.classList.remove('hidden');
    await renderTLView();
  } else if (currentExactRole === 'Senior Group Leader (SGL)') {
    document.getElementById('homeLead').textContent = `Review evaluation scores, audit team performance, and verify TL assessments across your group in ${currentUnitName || 'Unit'}.`;
    if (sglView) sglView.classList.remove('hidden');
    await renderSGLView();
  } else {
    document.getElementById('homeLead').textContent = 'Review employee growth records and complete supervisor remarks.';
  }
}

/* ============================= EMPLOYEE SCORECARD ============================= */
async function renderEmployeeScorecard(month = getGlobalCycle()) {
  const card = document.getElementById('employeeScorecard');
  if (!card) return;
  card.innerHTML = `<div style="color:var(--ink-dim);font-size:13px;padding:16px;background:#fff;border-radius:12px;border:1px solid var(--panel-line);">Loading monthly assessment scorecard for ${esc(getGlobalCycleLabel())}…</div>`;
  card.classList.remove('hidden');

  try {
    const res = await api(`/api/employee/assessment?month=${encodeURIComponent(month)}`);
    const a = res.assessment;

    const scoreVal = (a && a.tlScore !== null && a.tlScore !== undefined) ? a.tlScore : (a?.score !== null && a?.score !== undefined ? a.score : null);

    if (scoreVal !== null && scoreVal !== undefined) {
      // Evaluated state
      const numScore = Number(scoreVal);
      const pct = Math.min(Math.max(Math.round((numScore / 10) * 100), 10), 100);
      const crit = a.criteriaScores || {};
      const grade = a.ratingGrade || (numScore >= 9.0 ? 'Grade A+ (Exceptional)' : (numScore >= 8.0 ? 'Grade A (Outstanding)' : (numScore >= 7.0 ? 'Grade B+ (Good)' : 'Grade B (Satisfactory)')));

      const evalDate = a.evaluatedAt || a.reviewedAt || Date.now();
      const dateStr = new Date(evalDate).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
      const evaluator = a.evaluatorName || 'Team Leader';

      const sScore = parseFloat(crit.safety || crit['5s'] || (numScore >= 8 ? 9.0 : 7.5));
      const qScore = parseFloat(crit.quality || (numScore >= 8 ? 8.5 : 7.0));
      const pScore = parseFloat(crit.productivity || (numScore >= 8 ? 8.5 : 7.5));
      const aScore = parseFloat(crit.attendance || (numScore >= 8 ? 9.5 : 8.0));
      const kScore = parseFloat(crit.kaizen || (numScore >= 8 ? 8.0 : 7.0));

      card.innerHTML = `
        <div class="emp-scorecard-card">
          <div class="emp-scorecard-top">
            <div>
              <div class="emp-sc-title">Monthly Assessment Scorecard · ${esc(getGlobalCycleLabel())}</div>
              <div class="emp-sc-sub">Evaluated by ${esc(evaluator)} on ${dateStr} · Official Performance Review</div>
            </div>
            <span class="emp-sc-grade-badge">${esc(grade)}</span>
          </div>

          <div class="emp-score-hero-row">
            <div class="emp-big-score-box">
              <span class="emp-big-score-num">${numScore.toFixed(1)}</span>
              <span class="emp-big-score-scale">/ 10.0</span>
            </div>
            <div class="emp-score-progress-wrap">
              <div class="emp-score-progress-header">
                <span>Overall Performance Rating</span>
                <span>${numScore.toFixed(1)} on 10.0 Evaluation Scale (${pct}%)</span>
              </div>
              <div class="emp-score-bar-bg">
                <div class="emp-score-bar-fill" style="width:${pct}%;"></div>
              </div>
              <div class="emp-score-bench">
                ${numScore >= 7.5 ? 'Benchmark Achieved (Target: ≥ 7.5 / 10.0)' : 'Benchmark Target: ≥ 7.5 / 10.0'}
              </div>
            </div>
          </div>

          <div class="emp-crit-section-title">Core Performance Competencies (Scale 1 - 10)</div>
          <div class="emp-crit-grid">
            <div class="emp-crit-card">
              <div class="emp-crit-card-top">
                <span class="emp-crit-card-icon" style="font-size:10px;font-weight:700;letter-spacing:0.04em;">SEC</span>
                <span class="emp-crit-card-score">${sScore.toFixed(1)} / 10</span>
              </div>
              <div class="emp-crit-card-name">Safety & 5S</div>
              <div class="emp-crit-card-bar-bg">
                <div class="emp-crit-card-bar-fill" style="width:${Math.round((sScore / 10) * 100)}%;"></div>
              </div>
            </div>

            <div class="emp-crit-card">
              <div class="emp-crit-card-top">
                <span class="emp-crit-card-icon" style="font-size:10px;font-weight:700;letter-spacing:0.04em;">QLT</span>
                <span class="emp-crit-card-score">${qScore.toFixed(1)} / 10</span>
              </div>
              <div class="emp-crit-card-name">Quality & Defects</div>
              <div class="emp-crit-card-bar-bg">
                <div class="emp-crit-card-bar-fill" style="width:${Math.round((qScore / 10) * 100)}%;"></div>
              </div>
            </div>

            <div class="emp-crit-card">
              <div class="emp-crit-card-top">
                <span class="emp-crit-card-icon" style="font-size:10px;font-weight:700;letter-spacing:0.04em;">PRD</span>
                <span class="emp-crit-card-score">${pScore.toFixed(1)} / 10</span>
              </div>
              <div class="emp-crit-card-name">Productivity</div>
              <div class="emp-crit-card-bar-bg">
                <div class="emp-crit-card-bar-fill" style="width:${Math.round((pScore / 10) * 100)}%;"></div>
              </div>
            </div>

            <div class="emp-crit-card">
              <div class="emp-crit-card-top">
                <span class="emp-crit-card-icon" style="font-size:10px;font-weight:700;letter-spacing:0.04em;">ATD</span>
                <span class="emp-crit-card-score">${aScore.toFixed(1)} / 10</span>
              </div>
              <div class="emp-crit-card-name">Attendance</div>
              <div class="emp-crit-card-bar-bg">
                <div class="emp-crit-card-bar-fill" style="width:${Math.round((aScore / 10) * 100)}%;"></div>
              </div>
            </div>

            <div class="emp-crit-card">
              <div class="emp-crit-card-top">
                <span class="emp-crit-card-icon" style="font-size:10px;font-weight:700;letter-spacing:0.04em;">5S</span>
                <span class="emp-crit-card-score">${kScore.toFixed(1)} / 10</span>
              </div>
              <div class="emp-crit-card-name">Kaizen & Ideas</div>
              <div class="emp-crit-card-bar-bg">
                <div class="emp-crit-card-bar-fill" style="width:${Math.round((kScore / 10) * 100)}%;"></div>
              </div>
            </div>
          </div>

          <div class="emp-feedback-box">
            <div class="emp-fb-header">
              <span>Feedback:</span>
              <span>Team Leader Feedback & Coaching:</span>
            </div>
            <p class="emp-fb-text">"${esc(a.tlComments || 'Consistently maintaining outstanding performance on the assembly station, proactive in Kaizen ideas and adherence to 5S safety standards.')}"</p>
            <div class="emp-fb-author">
              <span>Verified by ${esc(evaluator)}</span>
              <span>· Official MAHLE Passport Record</span>
            </div>
          </div>
        </div>
      `;
      return;
    }

    // Pending evaluation or draft state
    const isSubmitted = a && (a.submissionStatus === 'submitted' || a.submissionStatus === 'Submitted');
    card.innerHTML = `
      <div class="emp-pending-card">
        <div class="emp-pending-header">
          <div>
            <div class="emp-sc-title">${esc(getGlobalCycleLabel())} Passport Assessment Status</div>
            <div class="emp-sc-sub">${isSubmitted ? 'Monthly submission received · Awaiting Team Leader evaluation' : 'Active monthly assessment cycle in progress'}</div>
          </div>
          <span class="badge ${isSubmitted ? 'badge-submitted' : 'badge-pending'}">${isSubmitted ? 'Submitted to Supervisor' : 'Draft in Progress'}</span>
        </div>

        <div class="emp-pending-steps">
          <div class="emp-step-item">
            <div class="emp-step-num">1</div>
            <div>
              <div class="emp-step-title">Passport Sheets</div>
              <div class="emp-step-desc">Passport sections updated with monthly data</div>
            </div>
          </div>
          <div class="emp-step-item ${isSubmitted ? '' : 'active'}">
            <div class="emp-step-num">2</div>
            <div>
              <div class="emp-step-title">Monthly Submission</div>
              <div class="emp-step-desc">${isSubmitted ? 'Submitted on ' + new Date(a.submittedAt || Date.now()).toLocaleDateString() : 'Ready for submission to Team Leader'}</div>
            </div>
          </div>
          <div class="emp-step-item ${isSubmitted ? 'active' : ''}">
            <div class="emp-step-num">3</div>
            <div>
              <div class="emp-step-title">TL Evaluation (1-10)</div>
              <div class="emp-step-desc">${isSubmitted ? 'Evaluation in progress by Team Leader' : 'Pending submission approval'}</div>
            </div>
          </div>
        </div>

        <div style="display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap;margin-top:14px;padding-top:14px;border-top:1px solid #f0f2f8;">
          <span style="font-size:12.5px;color:var(--ink-dim);line-height:1.45;">
            ${isSubmitted ? 'Your Team Leader evaluates five core competencies: Safety & 5S, Quality, Productivity, Attendance, and Kaizen.' : 'Make sure to complete your monthly logs in Line Performance and Attendance before submission.'}
          </span>
          <button class="btn btn-sm btn-primary" id="scReviewBtn">
            ${isSubmitted ? 'Review My Submitted Sheets →' : 'Edit My Passport Sheets →'}
          </button>
        </div>
      </div>
    `;

    document.getElementById('scReviewBtn')?.addEventListener('click', async () => {
      viewingEmpId = currentEmpId;
      await updateActiveEmployeeInfo(currentEmpId);
      await renderMenu();
      showScreen('menu');
    });
  } catch (err) {
    card.innerHTML = `<div style="color:var(--ink-dim);font-size:13px;padding:12px;">Scorecard details temporarily unavailable.</div>`;
  }
}

/* ============================= ADMIN DASHBOARD ============================= */
async function renderAdminDashboard(unit = 'all', month = getGlobalCycle()) {
  try {
    const data = await api(`/api/admin/analytics?unit=${encodeURIComponent(unit)}&month=${encodeURIComponent(month)}`);
    const k = data.kpi || data.kpis || {};

    const scopeBadge = document.getElementById('adminScopeBadge');
    if (scopeBadge) {
      scopeBadge.textContent = (unit && unit !== 'all') ? `${unit} Plant Scope (Filtered)` : 'Multi-Unit Scope (All Plants)';
    }

    document.getElementById('kpiTotalEmp').textContent = k.totalEmployees || 0;
    document.getElementById('kpiSubmitted').textContent = k.submittedCount !== undefined ? k.submittedCount : (k.submittedAssessments || 0);
    document.getElementById('kpiSubRate').textContent = `${k.submissionRate || 0}% Submission`;
    document.getElementById('kpiEvaluated').textContent = k.evaluatedCount !== undefined ? k.evaluatedCount : (k.evaluatedAssessments || 0);
    document.getElementById('kpiEvalRate').textContent = `${k.evaluationRate || 0}% Completed`;
    const avgScoreVal = k.averageScore !== undefined && k.averageScore !== null ? k.averageScore : (k.avgScore || 0);
    const pendingVal = k.pendingReviewCount !== undefined ? k.pendingReviewCount : Math.max(0, (k.submittedCount || 0) - (k.evaluatedCount || 0));
    const kpiPendingReviews = document.getElementById('kpiPendingReviews');
    if (kpiPendingReviews) kpiPendingReviews.textContent = pendingVal;
    const kpiPendingRate = document.getElementById('kpiPendingRate');
    if (kpiPendingRate) {
      kpiPendingRate.textContent = (k.submittedCount > 0)
        ? `${Math.round(pendingVal / k.submittedCount * 100)}% Awaiting Rating`
        : 'All Evaluated';
    }

    const tbody = document.getElementById('unitMatrixBody');
    tbody.innerHTML = '';
    (data.units || []).forEach(u => {
      const isSelected = (unit !== 'all' && (
        (u.unitName && unit && u.unitName.toLowerCase() === unit.toLowerCase()) ||
        u.unitId === unit
      ));
      const tr = document.createElement('tr');
      if (isSelected) {
        tr.style.backgroundColor = '#eff6ff';
        tr.style.boxShadow = 'inset 4px 0 0 var(--mahle-blue)';
      }
      const subCount = u.submittedCount !== undefined ? u.submittedCount : (u.submitted || 0);
      const evalCount = u.evaluatedCount !== undefined ? u.evaluatedCount : (u.evaluated || 0);
      const avg = u.avgScore > 0 ? Number(u.avgScore).toFixed(1) + ' / 10' : '—';
      tr.innerHTML = `
        <td style="font-weight:600;">
          ${esc(u.unitName)}
          ${isSelected ? '<span class="badge" style="background:var(--mahle-blue);color:#fff;font-size:10px;margin-left:6px;padding:2px 8px;border-radius:12px;font-weight:700;">Active Filter</span>' : ''}
        </td>
        <td><span class="who-unit">${esc(u.unitCode || u.code || '—')}</span></td>
        <td>${u.totalEmployees}</td>
        <td>${subCount} (${u.totalEmployees > 0 ? Math.round(subCount/u.totalEmployees*100) : 0}%)</td>
        <td>${evalCount}</td>
        <td style="font-weight:700;color:var(--shell-2);">${avg}</td>
      `;
      tbody.appendChild(tr);
    });

    const sglTbody = document.getElementById('sglMatrixBody');
    if (sglTbody) {
      sglTbody.innerHTML = '';
      const teams = data.teams || [];
      if (!teams.length) {
        sglTbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--ink-dim);padding:18px;">No Senior Group Leader teams found in this scope.</td></tr>';
      } else {
        teams.forEach(tm => {
          const tr = document.createElement('tr');
          const subCount = tm.submittedCount || 0;
          const evalCount = tm.evaluatedCount || 0;
          const avg = tm.avgScore > 0 ? Number(tm.avgScore).toFixed(1) + ' / 10' : '—';
          tr.innerHTML = `
            <td style="font-weight:600;">
              <span>${esc(tm.sglName)}</span>
              ${tm.sglEmpCode ? `<span class="who-unit" style="margin-left:6px;">${esc(tm.sglEmpCode)}</span>` : ''}
            </td>
            <td><span class="who-unit" style="background:#f0f3fa;color:#1e2a63;">${esc(tm.unitName || 'Plant')}</span></td>
            <td>${tm.totalEmployees || 0}</td>
            <td>${subCount} (${tm.totalEmployees > 0 ? Math.round(subCount / tm.totalEmployees * 100) : 0}%)</td>
            <td>${evalCount}</td>
            <td style="font-weight:700;color:var(--shell-2);">${avg}</td>
          `;
          sglTbody.appendChild(tr);
        });
      }
    }
  } catch (e) {
    console.error('Error rendering admin analytics:', e);
  }
}

async function renderUnitFilterPills() {
  const container = document.getElementById('dynamicUnitPills');
  if (!container) return;

  let units = [];
  try {
    const res = await api('/api/admin/units');
    units = res.units || [];
  } catch (e) {
    units = adminMetadataCache?.units || [];
  }

  if (!units || !units.length) {
    units = [
      { name: 'Gurugram', code: 'GGN' },
      { name: 'Khandsa', code: 'K02' },
      { name: 'State Unit 3', code: 'U03' },
      { name: 'State Unit 4', code: 'U04' }
    ];
  }

  container.innerHTML = `
    <button type="button" class="unit-pill ${selectedUnitFilter === 'all' ? 'active' : ''}" data-unit="all">All Units</button>
    ${units.map(u => `
      <button type="button" class="unit-pill ${selectedUnitFilter === u.name ? 'active' : ''}" data-unit="${esc(u.name)}" data-id="${esc(u.id || '')}">
        ${esc(u.name)}
      </button>
    `).join('')}
  `;

  container.querySelectorAll('.unit-pill').forEach(btn => {
    btn.addEventListener('click', async () => {
      container.querySelectorAll('.unit-pill').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      selectedUnitFilter = btn.dataset.unit || 'all';
      await renderAdminDashboard(selectedUnitFilter, getGlobalCycle());
    });
  });
}

let unitAdminEmployeesCache = [];

/* ============================= UNIT ADMIN VIEW ============================= */
async function renderUnitAdminView(month = getGlobalCycle()) {
  try {
    const { employees } = await api(`/api/unit-admin/employees?month=${encodeURIComponent(month)}`);
    unitAdminEmployeesCache = employees || [];
    const tbody = document.getElementById('unitAdminEmpBody');
    tbody.innerHTML = '';
    if (!unitAdminEmployeesCache || !unitAdminEmployeesCache.length) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;color:var(--ink-dim);padding:24px;">No employees found in this unit.</td></tr>';
      return;
    }

    // Unit Admin KPI Stats
    const total = unitAdminEmployeesCache.length;
    const submitted = unitAdminEmployeesCache.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
    const evaluated = unitAdminEmployeesCache.filter(e => (e.tlScore !== null && e.tlScore !== undefined) || (e.score !== null && e.score !== undefined)).length;
    const scores = unitAdminEmployeesCache
      .map(e => (e.tlScore !== null && e.tlScore !== undefined) ? e.tlScore : e.score)
      .filter(s => s !== null && s !== undefined && !isNaN(s));
    const avgScore = scores.length > 0 ? (scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1) : '—';

    const uaKpiTotal = document.getElementById('uaKpiTotal');
    if (uaKpiTotal) uaKpiTotal.textContent = total;
    const uaKpiSub = document.getElementById('uaKpiSubmitted');
    if (uaKpiSub) uaKpiSub.textContent = submitted;
    const uaKpiSubRate = document.getElementById('uaKpiSubRate');
    if (uaKpiSubRate) uaKpiSubRate.textContent = total > 0 ? `${Math.round(submitted / total * 100)}% Submission` : '0% Submission';
    const uaKpiEval = document.getElementById('uaKpiEvaluated');
    if (uaKpiEval) uaKpiEval.textContent = evaluated;
    const uaKpiEvalRate = document.getElementById('uaKpiEvalRate');
    if (uaKpiEvalRate) uaKpiEvalRate.textContent = total > 0 ? `${Math.round(evaluated / total * 100)}% Completed` : '0% Completed';
    const uaKpiAvg = document.getElementById('uaKpiAvgScore');
    if (uaKpiAvg) uaKpiAvg.textContent = avgScore;

    unitAdminEmployeesCache.forEach(emp => {
      const tr = document.createElement('tr');
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = !!scoreVal;
      const isSub = emp.submissionStatus === 'submitted' || emp.submissionStatus === 'Submitted';
      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;">${esc(emp.empCode)}</td>
        <td style="font-weight:600;">${esc(emp.name)}</td>
        <td><span style="font-size:12.5px;font-weight:600;">${esc(emp.roleName || emp.role)}</span></td>
        <td style="font-size:12px;line-height:1.4;">
          <div><strong>TL:</strong> ${esc(emp.tlName || 'Unassigned')}</div>
          ${emp.sglName ? `<div style="color:var(--ink-dim);font-size:11px;"><strong>SGL:</strong> ${esc(emp.sglName)}</div>` : ''}
        </td>
        <td>
          <span class="badge ${isEval ? 'badge-evaluated' : (isSub ? 'badge-evaluated' : 'badge-pending')}" style="${!isEval && isSub ? 'background:#e8f0fe;color:#1a73e8;' : ''}">
            ${isEval ? 'Evaluated' : (isSub ? 'Submitted' : 'Pending')}
          </span>
        </td>
        <td style="font-weight:700;font-family:var(--font-mono);">${isEval ? Number(scoreVal).toFixed(1) + ' / 10' : '—'}</td>
        <td>
          <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
            <button class="btn btn-sm btn-ghost btn-ua-view" data-emp="${esc(emp.empCode)}" data-name="${esc(emp.name)}">View Record</button>
            <button class="btn btn-sm btn-ghost btn-ua-edit" data-emp="${esc(emp.empCode)}" title="Edit user profile & supervisor mapping">Edit / Map</button>
          </div>
        </td>
      `;
      tbody.appendChild(tr);
    });

    tbody.querySelectorAll('.btn-ua-view').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name);
      });
    });

    tbody.querySelectorAll('.btn-ua-edit').forEach(btn => {
      btn.addEventListener('click', async () => {
        const emp = unitAdminEmployeesCache.find(e => e.empCode === btn.dataset.emp);
        if (emp) await openUserMgmtModal(emp);
      });
    });
  } catch (e) {
    console.error('Error rendering unit admin:', e);
  }
}

/* ============================= TL VIEW & EVALUATION ============================= */
let tlAssignedCache = [];
let tlActiveFilter = 'all'; // 'all' | 'pending' | 'completed'
let tlSearchQuery = '';

async function renderTLView(month = getGlobalCycle()) {
  try {
    const res = await api(`/api/tl/assigned?month=${encodeURIComponent(month)}`);
    tlAssignedCache = res.employees || [];
    applyTLDashboardView();
  } catch (e) {
    console.error('Error rendering TL view:', e);
  }
}

function applyTLDashboardView() {
  const employees = tlAssignedCache || [];
  const homeTbody = document.getElementById('tlAssignedHomeBody');
  const dirTbody = document.getElementById('tlAssignedBody');

  // Team Leader KPI Stats
  const total = employees.length;
  const submitted = employees.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
  const evaluated = employees.filter(e => e.tlScore !== null && e.tlScore !== undefined).length;
  const pending = total - evaluated;
  const scores = employees
    .map(e => e.tlScore)
    .filter(s => s !== null && s !== undefined && !isNaN(s));
  const avgScore = scores.length > 0 ? (scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1) : '—';

  // Update KPI Cards
  const tlKpiTotal = document.getElementById('tlKpiTotal');
  if (tlKpiTotal) tlKpiTotal.textContent = total;
  const tlKpiSub = document.getElementById('tlKpiSubmitted');
  if (tlKpiSub) tlKpiSub.textContent = submitted;
  const tlKpiSubRate = document.getElementById('tlKpiSubRate');
  if (tlKpiSubRate) tlKpiSubRate.textContent = total > 0 ? `${Math.round(submitted / total * 100)}% Submission` : '0% Submission';
  
  const tlKpiPending = document.getElementById('tlKpiPending');
  if (tlKpiPending) tlKpiPending.textContent = pending;
  const tlKpiPendingSub = document.getElementById('tlKpiPendingSub');
  if (tlKpiPendingSub) tlKpiPendingSub.textContent = pending > 0 ? `${pending} Awaiting Rating` : 'All Evaluated';

  const tlKpiEval = document.getElementById('tlKpiEvaluated');
  if (tlKpiEval) tlKpiEval.textContent = evaluated;
  const tlKpiEvalRate = document.getElementById('tlKpiEvalRate');
  if (tlKpiEvalRate) tlKpiEvalRate.textContent = total > 0 ? `${Math.round(evaluated / total * 100)}% Completed` : '0% Completed';
  
  const tlKpiAvg = document.getElementById('tlKpiAvgScore');
  if (tlKpiAvg) tlKpiAvg.textContent = avgScore;

  // Update Filter Pill Counts
  const countAll = document.getElementById('tlCountAll');
  if (countAll) countAll.textContent = total;
  const countPending = document.getElementById('tlCountPending');
  if (countPending) countPending.textContent = pending;
  const countCompleted = document.getElementById('tlCountCompleted');
  if (countCompleted) countCompleted.textContent = evaluated;

  const unitBadgeTitle = document.getElementById('tlUnitBadgeTitle');
  if (unitBadgeTitle && currentUnitName) unitBadgeTitle.textContent = `${currentUnitName} · ${getGlobalCycleLabel()}`;

  // Apply Filter & Search
  const query = (tlSearchQuery || '').toLowerCase().trim();
  const filtered = employees.filter(emp => {
    const isEval = (emp.tlScore !== null && emp.tlScore !== undefined);
    
    // Status Filter
    if (tlActiveFilter === 'pending' && isEval) return false;
    if (tlActiveFilter === 'completed' && !isEval) return false;

    // Search Query
    if (query) {
      const matchEmp = (emp.empCode || '').toLowerCase().includes(query);
      const matchName = (emp.name || '').toLowerCase().includes(query);
      const matchDept = (emp.departmentName || '').toLowerCase().includes(query);
      if (!matchEmp && !matchName && !matchDept) return false;
    }

    return true;
  });

  const summaryBadge = document.getElementById('tlFilterSummaryBadge');
  if (summaryBadge) {
    summaryBadge.textContent = `Showing ${filtered.length} of ${total} staff`;
  }

  // Helper to render rows into a tbody
  const populateTbody = (tbody, isHome) => {
    if (!tbody) return;
    tbody.innerHTML = '';

    if (!filtered.length) {
      const emptyMsg = total === 0 
        ? 'No shop floor operators mapped under your supervision in this plant unit.' 
        : (tlActiveFilter === 'pending' 
          ? '✓ Great job! All assigned team members have been evaluated.' 
          : 'No team members matching current filter.');
      tbody.innerHTML = `<tr><td colspan="6" style="text-align:center;color:var(--ink-dim);padding:24px;">${esc(emptyMsg)}</td></tr>`;
      return;
    }

    filtered.forEach(emp => {
      const tr = document.createElement('tr');
      const hasSub = emp.submissionStatus === 'evaluated' || emp.submissionStatus === 'submitted' || emp.submissionStatus === 'Submitted';
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = (scoreVal !== null && scoreVal !== undefined && !isNaN(scoreVal));
      
      let critJsonStr = '';
      try {
        critJsonStr = emp.criteriaScores ? JSON.stringify(emp.criteriaScores) : '';
      } catch (e) {}

      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;color:#1e2a63;">${esc(emp.empCode)}</td>
        <td style="font-weight:600;">${esc(emp.name)}</td>
        <td>${esc(emp.departmentName || 'Operations')}</td>
        <td>
          <span class="badge ${hasSub ? 'badge-evaluated' : 'badge-pending'}">
            ${hasSub ? '✓ Submitted' : 'Pending Submission'}
          </span>
        </td>
        <td>
          ${isEval 
            ? `<div style="display:flex;align-items:center;gap:6px;">
                <span style="font-weight:700;font-size:13.5px;color:#1e2a63;">${Number(scoreVal).toFixed(1)} / 10</span>
                <span class="badge badge-evaluated" style="font-size:10.5px;">${esc(emp.ratingGrade || 'Grade A')}</span>
               </div>`
            : `<span class="badge badge-pending" style="background:#fff3cd;color:#856404;font-weight:700;">⏳ Awaiting Rating</span>`
          }
        </td>
        <td>
          <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
            <button type="button" class="btn btn-sm btn-ghost btn-tl-review" data-emp="${esc(emp.empCode)}" data-name="${esc(emp.name)}" data-unit="${esc(emp.unitName || '')}" title="Open employee Growth Passport to review monthly report (Sheets 1-9)">
              Review Report
            </button>
            <button type="button" class="btn btn-sm ${isEval ? 'btn-ghost' : 'btn-primary'} btn-tl-eval" data-emp="${esc(emp.empCode)}" data-name="${esc(emp.name)}" data-score="${isEval ? scoreVal : 8.5}" data-grade="${esc(emp.ratingGrade || '')}" data-comments="${esc(emp.tlComments || '')}" data-crit='${esc(critJsonStr)}' title="Give rating marks (1-10) and submit assessment">
              ${isEval ? 'Update Rating (1-10)' : 'Give Rating (1-10)'}
            </button>
          </div>
        </td>
      `;
      tbody.appendChild(tr);
    });

    tbody.querySelectorAll('.btn-tl-review').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name, btn.dataset.unit);
      });
    });

    tbody.querySelectorAll('.btn-tl-eval').forEach(btn => {
      btn.addEventListener('click', () => {
        let parsedCrit = null;
        try {
          if (btn.dataset.crit) parsedCrit = JSON.parse(btn.dataset.crit);
        } catch (e) {}
        openEvalModal(btn.dataset.emp, btn.dataset.name, btn.dataset.score, btn.dataset.grade, btn.dataset.comments, parsedCrit);
      });
    });
  };

  populateTbody(homeTbody, true);
  populateTbody(dirTbody, false);
}

// TL Filter Buttons event listeners
document.querySelectorAll('[data-tlfilter]').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('[data-tlfilter]').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    tlActiveFilter = btn.dataset.tlfilter || 'all';
    applyTLDashboardView();
  });
});

// TL Home Search event listener
document.getElementById('tlHomeSearchInput')?.addEventListener('input', (e) => {
  tlSearchQuery = e.target.value;
  applyTLDashboardView();
});

const EVAL_METRICS = [
  { id: 'cJobPerf', key: 'Performance on the Job', label: 'Performance on the Job', max: 20, min60: 12, def: 17 },
  { id: 'cAttendance', key: 'Attendance', label: 'Attendance', max: 10, min60: 6, def: 9 },
  { id: 'cWorkPerf', key: 'Work Performance', label: 'Work Performance', max: 20, min60: 12, def: 17 },
  { id: 'cLinePerf', key: 'Line Performance', label: 'Line Performance', max: 20, min60: 12, def: 17 },
  { id: 'cRecognition', key: 'Recognition', label: 'Recognition', max: 10, min60: 6, def: 8 },
  { id: 'cDocGrowth', key: 'Documentation (Growth File)', label: 'Documentation (Growth File)', max: 10, min60: 6, def: 8 },
  { id: 'cLean', key: 'AHPS / LEAN Participation', label: 'AHPS / LEAN Participation', max: 10, min60: 6, def: 9 },
];

function openEvalModal(empCode, name, score, grade, comments, criteriaScores = null) {
  currentEvalEmpId = empCode;
  currentEvalEmpName = name;
  document.getElementById('evalModalTitle').textContent = `Evaluate Assessment: ${name} (${empCode})`;
  const subEl = document.getElementById('evalModalSub');
  if (subEl) subEl.textContent = `Plant: ${currentUnitName || 'Unit'} · Official Monthly Rating (Scale 1.0 - 10.0)`;

  // Populate criteria breakdown
  const crit = (criteriaScores && typeof criteriaScores === 'object') ? criteriaScores : {};
  EVAL_METRICS.forEach(m => {
    const el = document.getElementById(m.id);
    if (el) {
      let val = crit[m.key] ?? crit[m.label] ?? crit[m.id];
      if (val === undefined || val === null || val === '') {
        val = m.def;
      }
      val = parseFloat(val);
      if (isNaN(val) || val < m.min60) val = m.min60;
      if (val > m.max) val = m.max;
      el.value = val;
    }
  });

  document.getElementById('evalComments').value = comments || '';
  recalculateEvalModal();
  document.getElementById('evalModal').classList.remove('hidden');
}

function recalculateEvalModal() {
  let totalMarks = 0;
  let hasValidationError = false;
  let errorMessage = '';

  const errBox = document.getElementById('evalModalError');
  const submitBtn = document.getElementById('evalSubmitBtn');

  EVAL_METRICS.forEach(m => {
    const el = document.getElementById(m.id);
    if (!el) return;
    const raw = String(el.value).trim();
    const val = parseFloat(raw);

    if (raw === '' || isNaN(val)) {
      hasValidationError = true;
      el.style.borderColor = '#ef4444';
      el.style.backgroundColor = '#fef2f2';
      if (!errorMessage) errorMessage = `Please enter marks for "${m.label}".`;
    } else if (val < m.min60) {
      hasValidationError = true;
      el.style.borderColor = '#ef4444';
      el.style.backgroundColor = '#fef2f2';
      if (!errorMessage) {
        errorMessage = `Mandatory policy: Minimum 60% marks required. "${m.label}" cannot be less than ${m.min60} / ${m.max} marks.`;
      }
    } else if (val > m.max) {
      hasValidationError = true;
      el.style.borderColor = '#ef4444';
      el.style.backgroundColor = '#fef2f2';
      if (!errorMessage) {
        errorMessage = `"${m.label}" cannot exceed maximum ${m.max} marks.`;
      }
    } else {
      el.style.borderColor = 'var(--panel-line)';
      el.style.backgroundColor = '#fff';
      totalMarks += val;
    }
  });

  const overallScore = totalMarks > 0 ? Number((totalMarks / 10).toFixed(1)) : 0;
  const scoreInp = document.getElementById('evalOverallScore');
  if (scoreInp) scoreInp.value = overallScore.toFixed(1);

  const totalBadge = document.getElementById('evalTotalMarksBadge');
  if (totalBadge) totalBadge.textContent = `${totalMarks} / 100`;

  const gradeBadge = document.getElementById('evalGradeBadge');
  if (gradeBadge) {
    if (overallScore >= 9.0) {
      gradeBadge.textContent = 'Grade A+ (Distinction)';
      gradeBadge.className = 'badge badge-evaluated';
    } else if (overallScore >= 8.0) {
      gradeBadge.textContent = 'Grade A (Outstanding)';
      gradeBadge.className = 'badge badge-evaluated';
    } else if (overallScore >= 7.0) {
      gradeBadge.textContent = 'Grade B+ (Good)';
      gradeBadge.className = 'badge badge-evaluated';
    } else if (overallScore >= 6.0) {
      gradeBadge.textContent = 'Grade B (Satisfactory)';
      gradeBadge.className = 'badge badge-pending';
    } else {
      gradeBadge.textContent = 'Grade C (Under 60% - Not Allowed)';
      gradeBadge.className = 'badge badge-pending';
    }
  }

  if (totalMarks < 60 && !hasValidationError) {
    hasValidationError = true;
    errorMessage = 'Policy violation: Total marks must be at least 60 / 100 (minimum 6.0 / 10.0 scale).';
  }

  if (errBox) {
    if (hasValidationError) {
      errBox.textContent = errorMessage;
      errBox.classList.remove('hidden');
    } else {
      errBox.textContent = '';
      errBox.classList.add('hidden');
    }
  }

  if (submitBtn) {
    submitBtn.disabled = hasValidationError;
    submitBtn.style.opacity = hasValidationError ? '0.5' : '1';
    submitBtn.style.cursor = hasValidationError ? 'not-allowed' : 'pointer';
  }

  return !hasValidationError;
}

EVAL_METRICS.forEach(m => {
  const el = document.getElementById(m.id);
  if (el) {
    el.addEventListener('input', recalculateEvalModal);
  }
});

document.getElementById('evalCancelBtn')?.addEventListener('click', () => {
  document.getElementById('evalModal')?.classList.add('hidden');
});

document.getElementById('evalSubmitBtn')?.addEventListener('click', async () => {
  if (!currentEvalEmpId) return;
  if (!recalculateEvalModal()) {
    return;
  }

  const criteriaScores = {};
  EVAL_METRICS.forEach(m => {
    criteriaScores[m.key] = parseFloat(document.getElementById(m.id).value);
  });

  const payload = {
    employeeId: currentEvalEmpId,
    month: getGlobalCycle(),
    score: parseFloat(document.getElementById('evalOverallScore').value),
    ratingGrade: document.getElementById('evalGradeBadge').textContent,
    criteriaScores,
    tlComments: document.getElementById('evalComments').value.trim(),
    comments: document.getElementById('evalComments').value.trim(),
  };

  try {
    const res = await api('/api/tl/evaluate', { method: 'POST', body: payload });
    showToast(`Assessment submitted: ${res.score}/10 (${res.ratingGrade})`);
    document.getElementById('evalModal').classList.add('hidden');
    if (viewingEmpId === currentEvalEmpId) {
      await updateActiveEmployeeInfo(viewingEmpId);
      updateEmployeeNavBar();
      if (currentSheetId === 'supervisor') {
        await openSheet('supervisor');
      }
    }
    await renderTLView(getGlobalCycle());
  } catch (err) {
    const errBox = document.getElementById('evalModalError');
    if (errBox) {
      errBox.textContent = err.message || 'Failed to submit evaluation.';
      errBox.classList.remove('hidden');
    } else {
      showToast(err.message || 'Failed to submit evaluation.');
    }
  }
});

/* ============================= SGL VIEW & AUDIT WORKFLOW ============================= */
let sglTeamCache = [];
let sglActiveFilter = 'all';
let sglSearchQuery = '';
let sglSelectedMonth = getGlobalCycle();
let currentSglAuditEmp = null;

async function renderSGLView(month = getGlobalCycle()) {
  sglSelectedMonth = month;
  try {
    const res = await api(`/api/sgl/teams?month=${encodeURIComponent(sglSelectedMonth)}`);
    sglTeamCache = res.team || res.employees || [];
    
    // Update unit badge & cycle title
    const monthSelect = document.getElementById('sglMonthSelect');
    if (monthSelect && monthSelect.value !== globalSelectedMonth) {
      monthSelect.value = globalSelectedMonth;
    }
    const yearSelect = document.getElementById('sglYearSelect');
    if (yearSelect && yearSelect.value !== globalSelectedYear) {
      yearSelect.value = globalSelectedYear;
    }
    const unitBadgeTitle = document.getElementById('sglUnitBadgeTitle');
    if (unitBadgeTitle) {
      unitBadgeTitle.textContent = `${currentUnitName || 'Unit'} · Plant Supervision`;
    }
    const cycleBadgeTitle = document.getElementById('sglCycleBadgeTitle');
    if (cycleBadgeTitle) {
      cycleBadgeTitle.textContent = getGlobalCycleLabel();
    }

    applySGLDashboardView();
  } catch (e) {
    console.error('Error rendering SGL view:', e);
  }
}

function applySGLDashboardView() {
  const employees = sglTeamCache || [];
  const homeTbody = document.getElementById('sglTeamHomeBody');
  const dirTbody = document.getElementById('sglTeamBody');

  // Compute SGL Metrics
  const total = employees.length;
  const submitted = employees.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
  const evaluated = employees.filter(e => e.tlScore !== null && e.tlScore !== undefined && !isNaN(e.tlScore)).length;
  const pending = employees.filter(e => (e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted') && (e.tlScore === null || e.tlScore === undefined)).length;
  const notSub = total - submitted;

  const scores = employees
    .map(e => e.tlScore)
    .filter(s => s !== null && s !== undefined && !isNaN(s));
  const avgScore = scores.length > 0 ? (scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1) : '—';

  // Performance Tiers Distribution
  const tierA = scores.filter(s => Number(s) >= 8.0).length;
  const tierB = scores.filter(s => Number(s) >= 6.0 && Number(s) < 8.0).length;
  const tierC = scores.filter(s => Number(s) < 6.0).length;

  // Update KPI Cards
  const sglKpiTotal = document.getElementById('sglKpiTotal');
  if (sglKpiTotal) sglKpiTotal.textContent = total;
  const sglKpiSub = document.getElementById('sglKpiSubmitted');
  if (sglKpiSub) sglKpiSub.textContent = submitted;
  const sglKpiSubRate = document.getElementById('sglKpiSubRate');
  if (sglKpiSubRate) sglKpiSubRate.textContent = total > 0 ? `${Math.round(submitted / total * 100)}% Submission` : '0% Submission';

  const sglKpiPending = document.getElementById('sglKpiPending');
  if (sglKpiPending) sglKpiPending.textContent = pending;
  const sglKpiPendingSub = document.getElementById('sglKpiPendingSub');
  if (sglKpiPendingSub) sglKpiPendingSub.textContent = pending > 0 ? `${pending} Awaiting TL Rating` : 'All Submissions Scored';

  const sglKpiEval = document.getElementById('sglKpiEvaluated');
  if (sglKpiEval) sglKpiEval.textContent = evaluated;
  const sglKpiEvalRate = document.getElementById('sglKpiEvalRate');
  if (sglKpiEvalRate) sglKpiEvalRate.textContent = total > 0 ? `${Math.round(evaluated / total * 100)}% Completed` : '0% Completed';

  const sglKpiAvg = document.getElementById('sglKpiAvgScore');
  if (sglKpiAvg) sglKpiAvg.textContent = avgScore;

  // Update Tier Distribution Cards
  const countTierA = document.getElementById('sglCountTierA');
  if (countTierA) countTierA.textContent = tierA;
  const countTierB = document.getElementById('sglCountTierB');
  if (countTierB) countTierB.textContent = tierB;
  const countTierC = document.getElementById('sglCountTierC');
  if (countTierC) countTierC.textContent = tierC;

  // Update Filter Pill Counts
  const countAll = document.getElementById('sglCountAll');
  if (countAll) countAll.textContent = total;
  const countPendingPill = document.getElementById('sglCountPending');
  if (countPendingPill) countPendingPill.textContent = pending;
  const countEvalPill = document.getElementById('sglCountEvaluated');
  if (countEvalPill) countEvalPill.textContent = evaluated;
  const countNotSubPill = document.getElementById('sglCountNotSub');
  if (countNotSubPill) countNotSubPill.textContent = notSub;

  // Filter & Search
  const query = (sglSearchQuery || '').toLowerCase().trim();
  const filtered = employees.filter(emp => {
    const isEval = (emp.tlScore !== null && emp.tlScore !== undefined && !isNaN(emp.tlScore));
    const hasSub = (emp.submissionStatus === 'evaluated' || emp.submissionStatus === 'submitted' || emp.submissionStatus === 'Submitted');

    if (sglActiveFilter === 'pending' && (!hasSub || isEval)) return false;
    if (sglActiveFilter === 'evaluated' && !isEval) return false;
    if (sglActiveFilter === 'notsub' && hasSub) return false;

    if (query) {
      const mCode = (emp.empCode || '').toLowerCase().includes(query);
      const mName = (emp.name || '').toLowerCase().includes(query);
      const mTL = (emp.tlName || '').toLowerCase().includes(query);
      const mDept = (emp.departmentName || '').toLowerCase().includes(query);
      if (!mCode && !mName && !mTL && !mDept) return false;
    }

    return true;
  });

  const summaryBadge = document.getElementById('sglFilterSummaryBadge');
  if (summaryBadge) {
    summaryBadge.textContent = `Showing ${filtered.length} of ${total} group staff`;
  }

  // Populate Table Helper
  const populateTable = (tbody, isHome) => {
    if (!tbody) return;
    tbody.innerHTML = '';

    if (!filtered.length) {
      const emptyMsg = total === 0
        ? 'No employees mapped under your group supervision in this plant unit.'
        : (sglActiveFilter === 'pending'
          ? '✓ Great job! No pending TL assessments awaiting rating in your group.'
          : 'No group members matching current filter.');
      tbody.innerHTML = `<tr><td colspan="${isHome ? 7 : 8}" style="text-align:center;color:var(--ink-dim);padding:24px;">${esc(emptyMsg)}</td></tr>`;
      return;
    }

    filtered.forEach(emp => {
      const tr = document.createElement('tr');
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = (scoreVal !== null && scoreVal !== undefined && !isNaN(scoreVal));
      const hasSub = (emp.submissionStatus === 'evaluated' || emp.submissionStatus === 'submitted' || emp.submissionStatus === 'Submitted');
      const tlFeedback = emp.tlComments ? `"${esc(emp.tlComments)}"` : '—';
      const roleOrDept = emp.roleName === 'Team Leader (TL)' ? 'Team Leader' : (emp.departmentName || 'Operations');

      let actionButtons = `
        <button type="button" class="btn btn-sm btn-ghost btn-sgl-report" data-emp="${esc(emp.empCode)}" data-name="${esc(emp.name)}" data-unit="${esc(emp.unitName || '')}" title="View employee monthly growth passport (Sheets 1-9)">
          Review Report
        </button>
      `;

      if (isEval) {
        actionButtons += `
          <button type="button" class="btn btn-sm btn-primary btn-sgl-audit" data-emp="${esc(emp.empCode)}" title="Audit TL assessment score, criteria breakdown, feedback, and record SGL sign-off">
            Audit TL Review
          </button>
        `;
      } else if (hasSub) {
        actionButtons += `
          <span class="badge badge-pending" style="font-size:11px;background:#fff3cd;color:#856404;" title="Awaiting evaluation from assigned Team Leader">
            ⏳ Awaiting TL
          </span>
        `;
      }

      if (isHome) {
        tr.innerHTML = `
          <td style="font-family:var(--font-mono);font-weight:700;color:#1e2a63;">${esc(emp.empCode)}</td>
          <td style="font-weight:600;">${esc(emp.name)}</td>
          <td>${esc(emp.tlName || 'Unassigned TL')}</td>
          <td>
            <span class="badge ${hasSub ? 'badge-evaluated' : 'badge-pending'}">
              ${hasSub ? '✓ Submitted' : 'Pending'}
            </span>
          </td>
          <td>
            ${isEval 
              ? `<div style="display:flex;align-items:center;gap:6px;">
                  <span style="font-weight:700;font-size:13.5px;color:#1e2a63;">${Number(scoreVal).toFixed(1)} / 10</span>
                  <span class="badge badge-evaluated" style="font-size:10.5px;">${esc(emp.ratingGrade || 'Grade A')}</span>
                 </div>`
              : (hasSub 
                  ? `<span class="badge badge-pending" style="background:#fff3cd;color:#856404;font-weight:700;">⏳ Pending TL Rating</span>`
                  : `<span class="badge badge-pending" style="opacity:0.6;">Report Not Submitted</span>`)
            }
          </td>
          <td style="max-width:220px;font-size:12.5px;color:var(--ink-dim);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${esc(emp.tlComments || '')}">
            ${tlFeedback}
          </td>
          <td>
            <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
              ${actionButtons}
            </div>
          </td>
        `;
      } else {
        // Directory Table View
        tr.innerHTML = `
          <td style="font-family:var(--font-mono);font-weight:700;color:#1e2a63;">${esc(emp.empCode)}</td>
          <td style="font-weight:600;">${esc(emp.name)}</td>
          <td>${esc(roleOrDept)}</td>
          <td>${esc(emp.tlName || 'Unassigned TL')}</td>
          <td>
            <span class="badge ${hasSub ? 'badge-evaluated' : 'badge-pending'}">
              ${hasSub ? '✓ Submitted' : 'Pending'}
            </span>
          </td>
          <td>
            ${isEval 
              ? `<span style="font-weight:700;color:#1e2a63;">${Number(scoreVal).toFixed(1)} / 10</span> <span class="badge badge-evaluated" style="font-size:10px;">${esc(emp.ratingGrade || 'Grade A')}</span>`
              : (hasSub 
                  ? `<span class="badge badge-pending" style="background:#fff3cd;color:#856404;font-size:11px;">⏳ Awaiting TL</span>`
                  : `<span style="color:var(--ink-dim);">—</span>`)
            }
          </td>
          <td style="max-width:180px;font-size:12px;color:var(--ink-dim);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${esc(emp.tlComments || '')}">
            ${tlFeedback}
          </td>
          <td>
            <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
              ${actionButtons}
            </div>
          </td>
        `;
      }

      tbody.appendChild(tr);
    });

    tbody.querySelectorAll('.btn-sgl-report').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name, btn.dataset.unit);
      });
    });

    tbody.querySelectorAll('.btn-sgl-audit').forEach(btn => {
      btn.addEventListener('click', () => {
        const empCode = btn.dataset.emp;
        const emp = sglTeamCache.find(e => e.empCode === empCode);
        if (emp) openSglAuditModal(emp);
      });
    });
  };

  populateTable(homeTbody, true);
  populateTable(dirTbody, false);
}

function openSglAuditModal(emp) {
  currentSglAuditEmp = emp;
  const scoreVal = emp.tlScore !== null && emp.tlScore !== undefined ? emp.tlScore : emp.score;
  const numScore = scoreVal ? Number(scoreVal) : 8.5;
  const crit = emp.criteriaScores || {};

  document.getElementById('sglAuditModalTitle').textContent = `Audit TL Assessment: ${emp.name} (${emp.empCode})`;
  document.getElementById('sglAuditModalSub').textContent = `Plant: ${emp.unitName || currentUnitName || 'Unit'} · Assigned TL: ${emp.tlName || 'Team Leader'} · Cycle: ${sglSelectedMonth}`;

  const scoreEl = document.getElementById('sglAuditScoreVal');
  if (scoreEl) scoreEl.textContent = scoreVal ? numScore.toFixed(1) : '—';

  const gradeEl = document.getElementById('sglAuditGradeBadge');
  if (gradeEl) {
    gradeEl.textContent = emp.ratingGrade || (numScore >= 9.0 ? 'Grade A+ (Distinction)' : (numScore >= 8.0 ? 'Grade A (Outstanding)' : (numScore >= 7.0 ? 'Grade B+ (Good)' : 'Grade B (Satisfactory)')));
  }

  const evalMeta = document.getElementById('sglAuditEvaluatorMeta');
  if (evalMeta) {
    const revDate = emp.reviewedAt ? new Date(emp.reviewedAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }) : 'Recorded';
    evalMeta.textContent = `Evaluated by ${emp.evaluatorName || emp.tlName || 'Team Leader'} on ${revDate}`;
  }

  // Criteria Scores (Read-Only 7 Metrics)
  const setCrit = (id, val, max, fallback) => {
    const el = document.getElementById(id);
    const scoreVal = (val !== undefined && val !== null && val !== '') ? parseFloat(val) : fallback;
    if (el) el.textContent = `${scoreVal} / ${max}`;
  };
  setCrit('sglCritJobPerf', crit['Performance on the Job'] ?? crit.jobPerf, 20, 17);
  setCrit('sglCritAttendance', crit['Attendance'] ?? crit.attendance, 10, 9);
  setCrit('sglCritWorkPerf', crit['Work Performance'] ?? crit.workPerf, 20, 17);
  setCrit('sglCritLinePerf', crit['Line Performance'] ?? crit.linePerf, 20, 17);
  setCrit('sglCritRecognition', crit['Recognition'] ?? crit.recognition, 10, 8);
  setCrit('sglCritDocGrowth', crit['Documentation (Growth File)'] ?? crit.docGrowth, 10, 8);
  setCrit('sglCritLean', crit['AHPS / LEAN Participation'] ?? crit.lean, 10, 9);

  // TL Comments
  const commentsEl = document.getElementById('sglAuditTLCommentsText');
  if (commentsEl) {
    commentsEl.textContent = emp.tlComments ? `"${emp.tlComments}"` : '"No specific comments recorded by Team Leader."';
  }

  // SGL Remarks Input
  const remarksInput = document.getElementById('sglAuditRemarksInput');
  if (remarksInput) {
    remarksInput.value = emp.sglRemarks || '';
  }

  document.getElementById('sglAuditModal')?.classList.remove('hidden');
}

// SGL Modal Event Listeners
document.getElementById('sglAuditCloseX')?.addEventListener('click', () => {
  document.getElementById('sglAuditModal')?.classList.add('hidden');
});
document.getElementById('sglAuditCancelBtn')?.addEventListener('click', () => {
  document.getElementById('sglAuditModal')?.classList.add('hidden');
});
document.getElementById('sglAuditOpenReportBtn')?.addEventListener('click', async () => {
  if (currentSglAuditEmp) {
    document.getElementById('sglAuditModal')?.classList.add('hidden');
    await selectEmployee(currentSglAuditEmp.empCode, currentSglAuditEmp.name, currentSglAuditEmp.unitName);
  }
});
document.getElementById('sglAuditSaveRemarksBtn')?.addEventListener('click', async () => {
  if (!currentSglAuditEmp) return;
  const remarksText = (document.getElementById('sglAuditRemarksInput')?.value || '').trim();
  if (!remarksText) {
    alert('Please enter verification notes or observations before saving.');
    return;
  }
  const targetMonth = currentSglAuditEmp.month || (screens.historical && !screens.historical.classList.contains('hidden') ? histSelectedCycle : sglSelectedMonth);
  try {
    const res = await api('/api/sgl/verify', {
      method: 'POST',
      body: {
        submissionId: currentSglAuditEmp.submissionId,
        employeeId: currentSglAuditEmp.empCode,
        month: targetMonth,
        sglRemarks: remarksText,
      }
    });
    showToast('SGL verification sign-off recorded successfully.');
    document.getElementById('sglAuditModal')?.classList.add('hidden');
    if (screens.historical && !screens.historical.classList.contains('hidden')) {
      await renderHistoricalRecordsView(histSelectedCycle);
    } else {
      await renderSGLView(sglSelectedMonth);
    }
  } catch (err) {
    alert(err.message || 'Failed to record SGL verification.');
  }
});

// SGL Filter Pills
document.querySelectorAll('[data-sglfilter]').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('[data-sglfilter]').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    sglActiveFilter = btn.dataset.sglfilter || 'all';
    applySGLDashboardView();
  });
});

// SGL Home Search
document.getElementById('sglHomeSearchInput')?.addEventListener('input', (e) => {
  sglSearchQuery = e.target.value;
  applySGLDashboardView();
});

// SGL Month Selector
document.getElementById('sglMonthSelect')?.addEventListener('change', async (e) => {
  await renderSGLView(e.target.value);
});

/* ============================= DEDICATED SCREEN: HISTORICAL RECORDS (SGL) ============================= */
let histRecordsCache = [];
let histActiveFilter = 'all';
let histSearchQuery = '';
let histSelectedCycle = getGlobalCycle();

async function renderHistoricalRecordsView(cycle = getGlobalCycle()) {
  histSelectedCycle = cycle;

  // Highlight selected cycle pill
  document.querySelectorAll('#histCyclePills [data-cycle]').forEach(pill => {
    pill.classList.toggle('active', pill.dataset.cycle === histSelectedCycle);
  });

  const cycleTitle = getGlobalCycleLabel();
  const cycleBadge = document.getElementById('histActiveCycleBadge');
  if (cycleBadge) cycleBadge.textContent = `Cycle: ${cycleTitle}`;
  const tableTitleCycle = document.getElementById('histTableTitleCycle');
  if (tableTitleCycle) tableTitleCycle.textContent = cycleTitle;

  const unitBadge = document.getElementById('histUnitBadge');
  if (unitBadge) {
    if (currentExactRole === 'Super Admin' || currentExactRole === 'HR Head') {
      unitBadge.textContent = 'All Plants · Enterprise Oversight';
    } else {
      unitBadge.textContent = `${currentUnitName || 'Unit'} · Plant Supervision`;
    }
  }

  const tbody = document.getElementById('histRecordsBody');
  if (tbody) {
    tbody.innerHTML = `<tr><td colspan="8" style="text-align:center;color:var(--ink-dim);padding:24px;">Loading ${cycleTitle} assessment records…</td></tr>`;
  }

  try {
    const res = await api(`/api/sgl/teams?month=${encodeURIComponent(histSelectedCycle)}`);
    histRecordsCache = res.team || res.employees || [];
    applyHistoricalDashboardView();
  } catch (err) {
    console.error('Error loading historical records:', err);
    if (tbody) {
      tbody.innerHTML = `<tr><td colspan="8" style="text-align:center;color:#b91c1c;padding:24px;">Failed to load historical records: ${esc(err.message || 'Server error')}</td></tr>`;
    }
  }
}

function applyHistoricalDashboardView() {
  const employees = histRecordsCache || [];
  const tbody = document.getElementById('histRecordsBody');
  const cycleTitle = getGlobalCycleLabel();

  // Compute Metrics
  const total = employees.length;
  const submitted = employees.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
  const evaluated = employees.filter(e => e.tlScore !== null && e.tlScore !== undefined && !isNaN(e.tlScore)).length;
  const pending = employees.filter(e => (e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted') && (e.tlScore === null || e.tlScore === undefined)).length;
  const notSub = total - submitted;

  const scores = employees
    .map(e => e.tlScore)
    .filter(s => s !== null && s !== undefined && !isNaN(s));
  const avgScore = scores.length > 0 ? (scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1) : '—';

  // Performance Tiers Distribution
  const tierA = scores.filter(s => Number(s) >= 8.0).length;
  const tierB = scores.filter(s => Number(s) >= 6.0 && Number(s) < 8.0).length;
  const tierC = scores.filter(s => Number(s) < 6.0).length;

  // Update KPI Cards
  const kpiTotal = document.getElementById('histKpiTotal');
  if (kpiTotal) kpiTotal.textContent = total;
  const kpiSub = document.getElementById('histKpiSubmitted');
  if (kpiSub) kpiSub.textContent = submitted;
  const kpiSubRate = document.getElementById('histKpiSubRate');
  if (kpiSubRate) kpiSubRate.textContent = total > 0 ? `${Math.round(submitted / total * 100)}% Submission` : '0% Submission';

  const kpiPending = document.getElementById('histKpiPending');
  if (kpiPending) kpiPending.textContent = pending;

  const kpiEval = document.getElementById('histKpiEvaluated');
  if (kpiEval) kpiEval.textContent = evaluated;
  const kpiEvalRate = document.getElementById('histKpiEvalRate');
  if (kpiEvalRate) kpiEvalRate.textContent = total > 0 ? `${Math.round(evaluated / total * 100)}% Completed` : '0% Completed';

  const kpiAvg = document.getElementById('histKpiAvgScore');
  if (kpiAvg) kpiAvg.textContent = avgScore;

  // Update Tier Distribution Cards
  const countTierA = document.getElementById('histTierA');
  if (countTierA) countTierA.textContent = tierA;
  const countTierB = document.getElementById('histTierB');
  if (countTierB) countTierB.textContent = tierB;
  const countTierC = document.getElementById('histTierC');
  if (countTierC) countTierC.textContent = tierC;

  // Update Filter Pill Counts
  const countAll = document.getElementById('histCountAll');
  if (countAll) countAll.textContent = total;
  const countPending = document.getElementById('histCountPending');
  if (countPending) countPending.textContent = pending;
  const countEval = document.getElementById('histCountEvaluated');
  if (countEval) countEval.textContent = evaluated;
  const countNotSub = document.getElementById('histCountNotSub');
  if (countNotSub) countNotSub.textContent = notSub;

  // Filter & Search
  const query = (histSearchQuery || '').toLowerCase().trim();
  const filtered = employees.filter(emp => {
    const isEval = (emp.tlScore !== null && emp.tlScore !== undefined && !isNaN(emp.tlScore));
    const hasSub = (emp.submissionStatus === 'evaluated' || emp.submissionStatus === 'submitted' || emp.submissionStatus === 'Submitted');

    if (histActiveFilter === 'pending' && (!hasSub || isEval)) return false;
    if (histActiveFilter === 'evaluated' && !isEval) return false;
    if (histActiveFilter === 'notsub' && hasSub) return false;

    if (query) {
      const mCode = (emp.empCode || '').toLowerCase().includes(query);
      const mName = (emp.name || '').toLowerCase().includes(query);
      const mTL = (emp.tlName || '').toLowerCase().includes(query);
      const mDept = (emp.departmentName || '').toLowerCase().includes(query);
      if (!mCode && !mName && !mTL && !mDept) return false;
    }

    return true;
  });

  const summaryBadge = document.getElementById('histFilterSummaryBadge');
  if (summaryBadge) {
    summaryBadge.textContent = `Showing ${filtered.length} of ${total} records (${cycleTitle})`;
  }

  if (!tbody) return;
  tbody.innerHTML = '';

  if (!filtered.length) {
    const emptyMsg = total === 0
      ? `No employee assessment records found for ${cycleTitle} in your plant unit.`
      : (histActiveFilter === 'pending'
        ? `✓ No pending TL evaluations awaiting rating for ${cycleTitle}.`
        : `No records matching search filter in ${cycleTitle}.`);
    tbody.innerHTML = `<tr><td colspan="8" style="text-align:center;color:var(--ink-dim);padding:24px;">${esc(emptyMsg)}</td></tr>`;
    return;
  }

  filtered.forEach(emp => {
    const tr = document.createElement('tr');
    const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
    const isEval = (scoreVal !== null && scoreVal !== undefined && !isNaN(scoreVal));
    const hasSub = (emp.submissionStatus === 'evaluated' || emp.submissionStatus === 'submitted' || emp.submissionStatus === 'Submitted');
    const tlFeedback = emp.tlComments ? `"${esc(emp.tlComments)}"` : '—';
    const roleOrDept = emp.roleName === 'Team Leader (TL)' ? 'Team Leader' : (emp.departmentName || 'Operations');

    let actionButtons = `
      <button type="button" class="btn btn-sm btn-ghost btn-hist-report" data-emp="${esc(emp.empCode)}" data-name="${esc(emp.name)}" data-unit="${esc(emp.unitName || '')}" title="View employee monthly growth passport (Sheets 1-9)">
        Review Report
      </button>
    `;

    if (isEval) {
      actionButtons += `
        <button type="button" class="btn btn-sm btn-primary btn-hist-audit" data-emp="${esc(emp.empCode)}" title="Audit TL assessment score, criteria breakdown, feedback, and record SGL sign-off">
          Audit TL Review
        </button>
      `;
    } else if (hasSub) {
      actionButtons += `
        <span class="badge badge-pending" style="font-size:11px;background:#fff3cd;color:#856404;" title="Awaiting evaluation from assigned Team Leader">
          ⏳ Awaiting TL
        </span>
      `;
    }

    tr.innerHTML = `
      <td style="font-family:var(--font-mono);font-weight:700;color:#1e2a63;">${esc(emp.empCode)}</td>
      <td style="font-weight:600;">${esc(emp.name)}</td>
      <td>${esc(roleOrDept)}</td>
      <td>${esc(emp.tlName || 'Unassigned TL')}</td>
      <td>
        <span class="badge ${hasSub ? 'badge-evaluated' : 'badge-pending'}">
          ${hasSub ? '✓ Submitted' : 'Pending'}
        </span>
      </td>
      <td>
        ${isEval 
          ? `<span style="font-weight:700;color:#1e2a63;">${Number(scoreVal).toFixed(1)} / 10</span> <span class="badge badge-evaluated" style="font-size:10px;">${esc(emp.ratingGrade || 'Grade A')}</span>`
          : (hasSub 
              ? `<span class="badge badge-pending" style="background:#fff3cd;color:#856404;font-size:11px;">⏳ Awaiting TL</span>`
              : `<span style="color:var(--ink-dim);">—</span>`)
        }
      </td>
      <td style="max-width:180px;font-size:12px;color:var(--ink-dim);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${esc(emp.tlComments || '')}">
        ${tlFeedback}
      </td>
      <td>
        <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
          ${actionButtons}
        </div>
      </td>
    `;

    tbody.appendChild(tr);
  });

  tbody.querySelectorAll('.btn-hist-report').forEach(btn => {
    btn.addEventListener('click', async () => {
      await selectEmployee(btn.dataset.emp, btn.dataset.name, btn.dataset.unit);
    });
  });

  tbody.querySelectorAll('.btn-hist-audit').forEach(btn => {
    btn.addEventListener('click', () => {
      const empCode = btn.dataset.emp;
      const emp = histRecordsCache.find(e => e.empCode === empCode);
      if (emp) openSglAuditModal(emp);
    });
  });
}

// Historical Cycle Pills
document.querySelectorAll('#histCyclePills [data-cycle]').forEach(btn => {
  btn.addEventListener('click', async () => {
    const cycle = btn.dataset.cycle;
    const parts = cycle.split('-');
    if (parts.length === 2) {
      await setGlobalCycle(parts[1], parts[0]);
    } else {
      await renderHistoricalRecordsView(cycle);
    }
  });
});

// Historical Filter Pills
document.querySelectorAll('[data-histfilter]').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('[data-histfilter]').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    histActiveFilter = btn.dataset.histfilter || 'all';
    applyHistoricalDashboardView();
  });
});

// Historical Search Input
document.getElementById('histSearchInput')?.addEventListener('input', (e) => {
  histSearchQuery = e.target.value;
  applyHistoricalDashboardView();
});

// Historical Navigation Buttons
document.getElementById('histBackBtn')?.addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('btnGoHistoricalFromHome')?.addEventListener('click', async () => {
  await renderHistoricalRecordsView();
  showScreen('historical');
});
document.getElementById('btnDirGoHistorical')?.addEventListener('click', async () => {
  await renderHistoricalRecordsView();
  showScreen('historical');
});

document.getElementById('goGrowthBtn').addEventListener('click', async () => {
  viewingEmpId = currentEmpId;
  await updateActiveEmployeeInfo(currentEmpId);
  renderSidebar();
  updateEmployeeNavBar();
  try {
    await renderMenu();
    showScreen('menu');
  } catch (err) {
    console.error('Error opening 10 sections menu:', err);
    showScreen('menu');
  }
});
document.getElementById('backHomeBtn').addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('backMenuBtn').addEventListener('click', async () => {
  try {
    await renderMenu();
    showScreen('menu');
  } catch (err) {
    console.error('Error opening 10 sections menu:', err);
    showScreen('menu');
  }
});

/* ============================= MANAGEMENT CONSOLE: QUICK ACCESS & BACK ============================= */
document.getElementById('cardGoInbox')?.addEventListener('click', async () => {
  await renderInbox();
  showScreen('inbox');
});
document.getElementById('cardGoDirectory')?.addEventListener('click', async () => {
  await renderDirectory();
  showScreen('directory');
});
document.getElementById('cardGoLookup')?.addEventListener('click', () => {
  renderLookupPage();
  showScreen('lookup');
});
document.getElementById('cardGoChangepw')?.addEventListener('click', () => {
  renderChangePwPage();
  showScreen('changepw');
});

// Back buttons
document.getElementById('inboxBackBtn')?.addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('dirBackBtn')?.addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('lookupBackBtn')?.addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('changepwBackBtn')?.addEventListener('click', () => {
  renderHome();
  showScreen('home');
});

// Backward compatibility buttons
document.getElementById('goInboxBtn')?.addEventListener('click', async () => {
  await renderInbox();
  showScreen('inbox');
});

/* ============================= DEDICATED SCREEN: SUBMISSIONS INBOX ============================= */
let activeInboxFilter = 'all';

async function renderInbox(month = getGlobalCycle()) {
  const list = document.getElementById('inboxList');
  if (!list) return;
  list.innerHTML = '<p class="empty-note">Loading submissions…</p>';

  let submissions = [];
  try {
    const res = await api(`/api/inbox?month=${encodeURIComponent(month)}`);
    submissions = res.submissions || [];
  } catch (e) {
    submissions = [];
  }

  // Update summary metrics
  const total = submissions.length;
  const evaluatedCount = submissions.filter(s => (s.tlScore !== null && s.tlScore !== undefined) || s.status === 'reviewed').length;
  const pendingCount = total - evaluatedCount;

  const sumTotal = document.getElementById('inboxSumTotal');
  if (sumTotal) sumTotal.textContent = total;
  const sumPending = document.getElementById('inboxSumPending');
  if (sumPending) sumPending.textContent = pendingCount;
  const sumEvaluated = document.getElementById('inboxSumEvaluated');
  if (sumEvaluated) sumEvaluated.textContent = evaluatedCount;

  if (!submissions.length) {
    list.innerHTML = `
      <div style="background:#fff;border:1px dashed var(--panel-line);border-radius:12px;padding:36px;text-align:center;">
        <div style="font-weight:700;font-size:12px;color:var(--ink-dim);margin-bottom:8px;letter-spacing:1px;text-transform:uppercase;">No Submissions Found</div>
        <div style="font-family:var(--font-display);font-size:16px;font-weight:700;color:var(--ink);">No Monthly Submissions Found</div>
        <p style="font-size:13px;color:var(--ink-dim);margin:6px 0 0;">Submissions for ${esc(getGlobalCycleLabel())} will appear here once shop floor operators submit their monthly growth passports.</p>
      </div>`;
    const countBadge = document.getElementById('inboxCountBadge');
    if (countBadge) countBadge.textContent = 'Showing 0 entries';
    return;
  }

  list.innerHTML = '';
  submissions.forEach(sub => {
    const card = document.createElement('div');
    card.className = 'inbox-card';
    const when = sub.submittedAt ? new Date(sub.submittedAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }) : 'Recent';
    const isEval = (sub.tlScore !== null && sub.tlScore !== undefined) || sub.status === 'reviewed';
    const scoreVal = sub.tlScore || sub.selfScore;

    card.dataset.emp = (sub.empId || '').toLowerCase();
    card.dataset.name = (sub.name || '').toLowerCase();
    card.dataset.unit = (sub.unitName || '').toLowerCase();
    card.dataset.status = isEval ? 'evaluated' : 'pending';

    const isSglUser = currentExactRole === 'Senior Group Leader (SGL)';
    const evalBtnText = isSglUser
      ? 'Audit TL Review'
      : (isEval ? 'Update Score' : 'Evaluate (1-10)');

    card.innerHTML = `
        <div class="inbox-card-left">
          <div class="inbox-card-avatar">${esc((sub.name || sub.empId || 'U').charAt(0).toUpperCase())}</div>
          <div>
            <div class="inbox-card-emp">
              <span>${esc(sub.name || sub.empId)}</span>
              <span class="who-unit">${esc(sub.empId)}</span>
              <span class="who-unit" style="background:#f0f3fa;color:#1e2a63;">${esc(sub.unitName || 'Unit')}</span>
              ${sub.departmentName ? `<span style="font-size:11px;color:var(--ink-dim);font-weight:500;">· ${esc(sub.departmentName)}</span>` : ''}
            </div>
            <div class="inbox-card-sub">
              <span><strong>${esc(sub.month || getGlobalCycleLabel())}</strong></span>
              <span>· Submitted ${esc(when)}</span>
            </div>
          </div>
        </div>
        <div class="inbox-card-right">
          ${isEval 
            ? `<span class="badge badge-evaluated">Evaluated ${scoreVal ? Number(scoreVal).toFixed(1) + '/10' : ''}</span>`
            : `<span class="badge badge-submitted">Awaiting Evaluation</span>`}
          
          <button class="btn btn-sm btn-primary btn-inbox-eval" data-emp="${esc(sub.empId)}" data-name="${esc(sub.name || sub.empId)}" data-score="${scoreVal || 8.5}" data-grade="${esc(sub.ratingGrade || '')}" data-comments="${esc(sub.tlComments || '')}">
            ${evalBtnText}
          </button>
          <button class="btn btn-sm btn-ghost btn-inbox-open" data-emp="${esc(sub.empId)}" data-name="${esc(sub.name || sub.empId)}" data-unit="${esc(sub.unitName || '')}">
            Open Passport
          </button>
        </div>`;

    card.querySelector('.btn-inbox-open')?.addEventListener('click', async () => {
      await selectEmployee(sub.empId, sub.name, sub.unitName);
    });

    card.querySelector('.btn-inbox-eval')?.addEventListener('click', () => {
      if (isSglUser) {
        openSglAuditModal({
          empCode: sub.empId,
          name: sub.name || sub.empId,
          unitName: sub.unitName,
          submissionId: sub.id,
          tlScore: sub.tlScore,
          ratingGrade: sub.ratingGrade,
          tlComments: sub.tlComments,
          criteriaScores: sub.criteriaScores,
          reviewedAt: sub.reviewedAt || sub.submittedAt,
          evaluatorName: sub.evaluatorName || 'Team Leader',
        });
      } else {
        openEvalModal(sub.empId, sub.name || sub.empId, sub.tlScore || sub.selfScore || 8.5, sub.ratingGrade || '', sub.tlComments || '');
      }
    });

    list.appendChild(card);
  });

  applyInboxFilters();
}

function applyInboxFilters() {
  const query = (document.getElementById('inboxSearchInput')?.value || '').trim().toLowerCase();
  const filter = activeInboxFilter || 'all';
  const cards = document.querySelectorAll('#inboxList .inbox-card');
  let matchCount = 0;

  cards.forEach(card => {
    const emp = card.dataset.emp || '';
    const name = card.dataset.name || '';
    const unit = card.dataset.unit || '';
    const status = card.dataset.status || '';

    const matchesSearch = !query || emp.includes(query) || name.includes(query) || unit.includes(query);
    const matchesFilter = (filter === 'all') || (status === filter);

    const show = matchesSearch && matchesFilter;
    card.style.display = show ? 'flex' : 'none';
    if (show) matchCount++;
  });

  const countBadge = document.getElementById('inboxCountBadge');
  if (countBadge) {
    countBadge.textContent = `Showing ${matchCount} ${matchCount === 1 ? 'submission' : 'submissions'}`;
  }
}

// Inbox Search & Filter listeners
document.getElementById('inboxSearchInput')?.addEventListener('input', applyInboxFilters);
document.querySelectorAll('#inboxFilters .inbox-pill').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('#inboxFilters .inbox-pill').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    activeInboxFilter = btn.dataset.filter;
    applyInboxFilters();
  });
});

/* ============================= DEDICATED SCREEN: TEAM & STAFF DIRECTORY ============================= */
let activeDirectoryFilter = 'all';

async function renderDirectory(month = getGlobalCycle()) {
  const dirTLView = document.getElementById('dirTLView');
  const dirUAView = document.getElementById('dirUAView');
  const dirSGLView = document.getElementById('dirSGLView');
  const dirAdminView = document.getElementById('dirAdminView');
  const pageTitle = document.getElementById('dirPageTitle');
  const pageLead = document.getElementById('dirPageLead');
  const searchInput = document.getElementById('dirSearchInput');

  if (dirTLView) dirTLView.classList.add('hidden');
  if (dirUAView) dirUAView.classList.add('hidden');
  if (dirSGLView) dirSGLView.classList.add('hidden');
  if (dirAdminView) dirAdminView.classList.add('hidden');
  if (searchInput) searchInput.value = '';

  activeDirectoryFilter = 'all';
  document.querySelectorAll('#dirFilters .dir-pill').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.filter === 'all');
  });

  if (currentExactRole === 'Team Leader (TL)') {
    if (pageTitle) pageTitle.textContent = 'Assigned Team Directory';
    if (pageLead) pageLead.textContent = `Direct shop floor operators under your supervision in ${currentUnitName || 'Unit'}. Review performance and evaluate monthly assessments.`;
    if (dirTLView) dirTLView.classList.remove('hidden');
    await renderTLView(month);
  } else if (currentExactRole === 'Unit Admin') {
    if (pageTitle) pageTitle.textContent = `${currentUnitName || 'Unit'} Staff Directory`;
    if (pageLead) pageLead.textContent = `Comprehensive workforce roster and TL/SGL assessment tracking for ${currentUnitName || 'Unit'}.`;
    const uaTitle = document.getElementById('uaTableTitle');
    if (uaTitle) uaTitle.textContent = `${currentUnitName || 'Unit'} Personnel & Assessment Status`;
    if (dirUAView) dirUAView.classList.remove('hidden');
    await renderUnitAdminView(month);
  } else if (currentExactRole === 'Senior Group Leader (SGL)') {
    if (pageTitle) pageTitle.textContent = 'Group Staff & Audit Directory';
    if (pageLead) pageLead.textContent = `Shop floor group overview and Team Leader score verification in ${currentUnitName || 'Unit'}.`;
    if (dirSGLView) dirSGLView.classList.remove('hidden');
    await renderSGLView(month);
  } else {
    // Super Admin / HR Head
    if (pageTitle) pageTitle.textContent = 'Cross-Plant Workforce Directory';
    if (pageLead) pageLead.textContent = 'Enterprise-wide personnel directory and assessment tracking across all 4 state units.';
    if (dirAdminView) dirAdminView.classList.remove('hidden');
    await renderAdminStaffView(month);
  }

  const isSuperOrHr = currentExactRole === 'Super Admin' || currentExactRole === 'HR Head';
  const isUnitAdmin = currentExactRole === 'Unit Admin';
  const canAdd = isSuperOrHr || isUnitAdmin;
  const canExport = isSuperOrHr || isUnitAdmin;

  const btnDirAddUser = document.getElementById('btnDirAddUser');
  const btnDirExportCsv = document.getElementById('btnDirExportCsv');
  if (btnDirAddUser) btnDirAddUser.style.display = canAdd ? 'inline-flex' : 'none';
  if (btnDirExportCsv) btnDirExportCsv.style.display = canExport ? 'inline-flex' : 'none';

  applyDirectoryFilters();
}

let adminUsersCache = [];
let adminMetadataCache = null;

async function loadAdminMetadata() {
  if (!adminMetadataCache) {
    try {
      const res = await api('/api/admin/metadata');
      adminMetadataCache = res.metadata || {};
    } catch (err) {
      console.error('Failed to load admin metadata:', err);
      return null;
    }
  }

  // Populate Plant / Unit dropdown
  const unitSelect = document.getElementById('userMgmtUnit');
  if (unitSelect && adminMetadataCache.units && (!unitSelect.options || unitSelect.options.length <= 1)) {
    unitSelect.innerHTML = '<option value="">Select Plant / Unit...</option>' +
      adminMetadataCache.units.map(u => `<option value="${u.id}">${esc(u.name)} (${esc(u.code || u.state || 'Plant')})</option>`).join('');
  }

  // Populate TL dropdown
  const tlSelect = document.getElementById('userMgmtTL');
  if (tlSelect && adminMetadataCache.teamLeaders && (!tlSelect.options || tlSelect.options.length <= 1)) {
    tlSelect.innerHTML = '<option value="">None / Not Applicable</option>' +
      adminMetadataCache.teamLeaders.map(tl => `<option value="${tl.id}">${esc(tl.name)} (${esc(tl.empCode)})</option>`).join('');
  }

  // Populate SGL dropdown
  const sglSelect = document.getElementById('userMgmtSGL');
  if (sglSelect && adminMetadataCache.seniorGroupLeaders && (!sglSelect.options || sglSelect.options.length <= 1)) {
    sglSelect.innerHTML = '<option value="">None / Not Applicable</option>' +
      adminMetadataCache.seniorGroupLeaders.map(sgl => `<option value="${sgl.id}">${esc(sgl.name)} (${esc(sgl.empCode)})</option>`).join('');
  }

  return adminMetadataCache;
}

async function renderAdminStaffView(month = getGlobalCycle()) {
  try {
    const res = await api(`/api/admin/users?unit=all&month=${encodeURIComponent(month)}`);
    adminUsersCache = res.users || [];
    const tbody = document.getElementById('adminStaffBody');
    if (!tbody) return;
    tbody.innerHTML = '';
    if (!adminUsersCache.length) {
      tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;color:var(--ink-dim);padding:24px;">No workforce records found.</td></tr>';
      return;
    }

    adminUsersCache.forEach(emp => {
      const tr = document.createElement('tr');
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = !!scoreVal;
      const isActive = emp.isActive !== false && emp.isActive !== 0;

      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;">${esc(emp.empCode)}</td>
        <td style="font-weight:600;">${esc(emp.name)}</td>
        <td><span class="who-unit">${esc(emp.unitName || 'Plant')}</span></td>
        <td><span style="font-size:12.5px;font-weight:600;">${esc(emp.exactRole || emp.roleName || emp.role)}</span></td>
        <td style="font-size:12px;color:var(--ink-dim);line-height:1.4;">
          ${emp.teamLeaderName ? `<div><strong>TL:</strong> ${esc(emp.teamLeaderName)}</div>` : ''}
          ${emp.seniorGroupLeaderName ? `<div><strong>SGL:</strong> ${esc(emp.seniorGroupLeaderName)}</div>` : (!emp.teamLeaderName ? '—' : '')}
        </td>
        <td>
          <span class="badge" style="${isActive ? 'background:#e6f4ea;color:#137333;' : 'background:#fce8e6;color:#c5221f;'}font-weight:700;">
            ${isActive ? 'Active' : 'Deactivated'}
          </span>
        </td>
        <td>
          <span class="badge ${isEval ? 'badge-evaluated' : (emp.submittedAt ? 'badge-evaluated' : 'badge-pending')}" style="${!isEval && emp.submittedAt ? 'background:#e8f0fe;color:#1a73e8;' : ''}">
            ${isEval ? 'Evaluated' : (emp.submittedAt ? 'Submitted' : 'Pending')}
          </span>
        </td>
        <td style="font-weight:700;font-family:var(--font-mono);">${isEval ? Number(scoreVal).toFixed(1) + ' / 10' : '—'}</td>
        <td>
          <div style="display:flex;align-items:center;gap:6px;flex-wrap:wrap;">
            <button class="btn btn-sm btn-ghost btn-admin-view" data-emp="${esc(emp.empCode)}" data-name="${esc(emp.name)}" data-unit="${esc(emp.unitName || '')}" title="Open Passport">View Record</button>
            <button class="btn btn-sm btn-ghost btn-admin-edit" data-emp="${esc(emp.empCode)}" title="Edit User & Roles">Edit</button>
            <button class="btn btn-sm ${isActive ? 'btn-ghost' : 'btn-primary'} btn-admin-toggle-active" data-emp="${esc(emp.empCode)}" data-active="${isActive ? '1' : '0'}" title="${isActive ? 'Deactivate Account' : 'Activate Account'}">
              ${isActive ? 'Deactivate' : 'Activate'}
            </button>
          </div>
        </td>
      `;
      tbody.appendChild(tr);
    });

    tbody.querySelectorAll('.btn-admin-view').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name, btn.dataset.unit);
      });
    });

    tbody.querySelectorAll('.btn-admin-edit').forEach(btn => {
      btn.addEventListener('click', async () => {
        const emp = adminUsersCache.find(u => u.empCode === btn.dataset.emp);
        if (emp) await openUserMgmtModal(emp);
      });
    });

    tbody.querySelectorAll('.btn-admin-toggle-active').forEach(btn => {
      btn.addEventListener('click', async () => {
        const empCode = btn.dataset.emp;
        const currentlyActive = btn.dataset.active === '1';
        await toggleUserActive(empCode, currentlyActive);
      });
    });
  } catch (e) {
    console.error('Error rendering admin staff view:', e);
  }
}

async function openUserMgmtModal(userToEdit = null) {
  await loadAdminMetadata();

  const modal = document.getElementById('userMgmtModal');
  const title = document.getElementById('userMgmtTitle');
  const sub = document.getElementById('userMgmtSub');
  const errEl = document.getElementById('userMgmtError');
  const empCodeInput = document.getElementById('userMgmtEmpCode');
  const nameInput = document.getElementById('userMgmtName');
  const roleSelect = document.getElementById('userMgmtRole');
  const unitSelect = document.getElementById('userMgmtUnit');
  const deptInput = document.getElementById('userMgmtDept');
  const tlSelect = document.getElementById('userMgmtTL');
  const sglSelect = document.getElementById('userMgmtSGL');
  const pwInput = document.getElementById('userMgmtPassword');
  const pwNote = document.getElementById('userMgmtPwNote');
  const activeCheckbox = document.getElementById('userMgmtIsActive');
  const activeLabel = document.getElementById('userMgmtActiveLabel');

  const joiningDateInput = document.getElementById('userMgmtJoiningDate');
  const dobInput = document.getElementById('userMgmtDob');
  const fatherNameInput = document.getElementById('userMgmtFatherName');
  const mobileInput = document.getElementById('userMgmtMobile');
  const emailInput = document.getElementById('userMgmtEmail');
  const designationInput = document.getElementById('userMgmtDesignation');
  const gradeCodeInput = document.getElementById('userMgmtGradeCode');
  const groupJoiningDateInput = document.getElementById('userMgmtGroupJoiningDate');

  if (errEl) {
    errEl.textContent = '';
    errEl.classList.add('hidden');
  }

  if (userToEdit) {
    title.textContent = `Edit User: ${userToEdit.name} (${userToEdit.empCode})`;
    sub.textContent = 'Modify personnel role, plant assignment, supervisors, and account state.';
    empCodeInput.value = userToEdit.empCode;
    empCodeInput.disabled = true;
    nameInput.value = userToEdit.name || '';
    roleSelect.value = userToEdit.exactRole === 'Shop Floor Employee' ? 'Employee' : (userToEdit.exactRole || userToEdit.roleName || userToEdit.role || 'Employee');
    unitSelect.value = userToEdit.unitId || '';
    deptInput.value = userToEdit.department || userToEdit.departmentName || 'Operations';
    tlSelect.value = userToEdit.tlId || userToEdit.teamLeaderId || '';
    sglSelect.value = userToEdit.sglId || userToEdit.seniorGroupLeaderId || '';
    pwInput.value = '';
    pwNote.textContent = 'Leave blank to preserve existing password.';
    activeCheckbox.checked = userToEdit.isActive !== false && userToEdit.isActive !== 0;
    activeLabel.textContent = activeCheckbox.checked ? 'Active & Permitted' : 'Deactivated / Login Blocked';

    if (joiningDateInput) joiningDateInput.value = userToEdit.joiningDate || '';
    if (dobInput) dobInput.value = userToEdit.dob || '';
    if (fatherNameInput) fatherNameInput.value = userToEdit.fatherName || '';
    if (mobileInput) mobileInput.value = userToEdit.mobile || '';
    if (emailInput) emailInput.value = userToEdit.email || '';
    if (designationInput) designationInput.value = userToEdit.designation || '';
    if (gradeCodeInput) gradeCodeInput.value = userToEdit.gradeCode || '';
    if (groupJoiningDateInput) groupJoiningDateInput.value = userToEdit.groupJoiningDate || '';
  } else {
    title.textContent = 'Create New User Account';
    sub.textContent = 'Add employee, supervisor, or administrator credentials and unit assignment.';
    empCodeInput.value = '';
    empCodeInput.disabled = false;
    nameInput.value = '';
    roleSelect.value = 'Employee';
    if (currentExactRole === 'Unit Admin' && (currentUser?.unitId || currentUser?.unitName)) {
      if (currentUser?.unitId) unitSelect.value = currentUser.unitId;
      unitSelect.disabled = true;
    } else {
      unitSelect.value = '';
      unitSelect.disabled = false;
    }
    deptInput.value = 'Operations';
    tlSelect.value = '';
    sglSelect.value = '';
    pwInput.value = '';
    pwNote.textContent = 'Default passcode if left blank: Mahle@123';
    activeCheckbox.checked = true;
    activeLabel.textContent = 'Active & Permitted';

    if (joiningDateInput) joiningDateInput.value = '';
    if (dobInput) dobInput.value = '';
    if (fatherNameInput) fatherNameInput.value = '';
    if (mobileInput) mobileInput.value = '';
    if (emailInput) emailInput.value = '';
    if (designationInput) designationInput.value = '';
    if (gradeCodeInput) gradeCodeInput.value = '';
    if (groupJoiningDateInput) groupJoiningDateInput.value = '';
  }

  // Toggle supervisor selection for executive roles
  const isSuper = roleSelect.value === 'Super Admin' || roleSelect.value === 'HR Head';
  const supBlock = document.getElementById('userMgmtSupervisorsBlock');
  if (supBlock) supBlock.style.display = isSuper ? 'none' : 'block';

  modal.classList.remove('hidden');
}

async function saveUserAccount() {
  const errEl = document.getElementById('userMgmtError');
  const empCode = (document.getElementById('userMgmtEmpCode')?.value || '').trim().toUpperCase();
  const name = (document.getElementById('userMgmtName')?.value || '').trim();
  const role = document.getElementById('userMgmtRole')?.value || 'Employee';
  const unitId = (document.getElementById('userMgmtUnit')?.value || '').trim();
  const department = (document.getElementById('userMgmtDept')?.value || '').trim() || 'Operations';
  const teamLeaderId = (document.getElementById('userMgmtTL')?.value || '').trim() || null;
  const seniorGroupLeaderId = (document.getElementById('userMgmtSGL')?.value || '').trim() || null;
  const password = (document.getElementById('userMgmtPassword')?.value || '').trim();
  const isActive = document.getElementById('userMgmtIsActive')?.checked ?? true;

  const joiningDate = (document.getElementById('userMgmtJoiningDate')?.value || '').trim();
  const dob = (document.getElementById('userMgmtDob')?.value || '').trim();
  const fatherName = (document.getElementById('userMgmtFatherName')?.value || '').trim();
  const mobile = (document.getElementById('userMgmtMobile')?.value || '').trim();
  const email = (document.getElementById('userMgmtEmail')?.value || '').trim();
  const designation = (document.getElementById('userMgmtDesignation')?.value || '').trim();
  const gradeCode = (document.getElementById('userMgmtGradeCode')?.value || '').trim();
  const groupJoiningDate = (document.getElementById('userMgmtGroupJoiningDate')?.value || '').trim();

  if (errEl) {
    errEl.textContent = '';
    errEl.classList.add('hidden');
  }

  if (!empCode) {
    errEl.textContent = 'Please provide a valid Employee Code / Login ID.';
    errEl.classList.remove('hidden');
    return;
  }
  if (!name) {
    errEl.textContent = 'Please enter the user full name.';
    errEl.classList.remove('hidden');
    return;
  }
  const isExecutive = role === 'Super Admin' || role === 'HR Head';
  if (!unitId && !isExecutive) {
    errEl.textContent = 'Please select a Plant / State Unit.';
    errEl.classList.remove('hidden');
    return;
  }
  if (!joiningDate) {
    errEl.textContent = 'Please provide Date of Joining (Joined On) — it is required.';
    errEl.classList.remove('hidden');
    return;
  }

  const payload = {
    empCode,
    name,
    role,
    unitId: unitId || null,
    department,
    teamLeaderId,
    seniorGroupLeaderId,
    isActive,
    joiningDate,
    dob: dob || null,
    fatherName: fatherName || null,
    mobile: mobile || null,
    email: email || null,
    designation: designation || null,
    gradeCode: gradeCode || null,
    groupJoiningDate: groupJoiningDate || null,
  };
  if (password) payload.password = password;

  try {
    const res = await api('/api/admin/users', { method: 'POST', body: payload });
    showToast(res.message || 'User saved successfully');
    document.getElementById('userMgmtModal')?.classList.add('hidden');
    // Refresh admin cache and table
    adminMetadataCache = null; // Invalidate metadata cache in case a new TL/SGL was added
    if (currentExactRole === 'Unit Admin') {
      await renderUnitAdminView();
    } else {
      await renderAdminStaffView();
    }
    applyDirectoryFilters();
  } catch (err) {
    if (errEl) {
      errEl.textContent = err.message || 'Failed to save user account.';
      errEl.classList.remove('hidden');
    }
  }
}

async function toggleUserActive(empCode, currentlyActive) {
  try {
    const res = await api('/api/admin/users', {
      method: 'PATCH',
      body: { empCode, action: 'toggle-status' }
    });
    showToast(res.isActive ? `Activated user ${empCode}` : `Deactivated user ${empCode}`);
    await renderAdminStaffView();
    applyDirectoryFilters();
  } catch (err) {
    alert(err.message || 'Failed to toggle account activation.');
  }
}

// Assessment Cycle Management
async function openCycleMgmtModal() {
  if (currentExactRole !== 'Super Admin' && currentExactRole !== 'HR Head') {
    showToast('Assessment Cycles can only be configured by Super Admin and HR Head.');
    return;
  }

  const modal = document.getElementById('cycleMgmtModal');
  const monthInput = document.getElementById('cycleInputMonth');
  const titleInput = document.getElementById('cycleInputTitle');
  const errEl = document.getElementById('cycleError');

  if (errEl) {
    errEl.textContent = '';
    errEl.classList.add('hidden');
  }

  if (monthInput && !monthInput.value) {
    monthInput.value = '2026-11';
  }
  if (titleInput && !titleInput.value) {
    titleInput.value = 'November 2026 Assessment Cycle';
  }

  modal.classList.remove('hidden');
  await loadCycleList();
}

async function loadCycleList() {
  const tbody = document.getElementById('cycleListBody');
  if (!tbody) return;
  tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;color:var(--ink-dim);padding:14px;">Loading assessment cycles…</td></tr>';

  try {
    const res = await api('/api/admin/cycles');
    const cycles = res.cycles || [];
    tbody.innerHTML = '';
    if (!cycles.length) {
      tbody.innerHTML = '<tr><td colspan="5" style="text-align:center;color:var(--ink-dim);padding:14px;">No assessment cycles recorded.</td></tr>';
      return;
    }

    cycles.forEach(c => {
      const tr = document.createElement('tr');
      const monthVal = c.month || c.cycleMonth || '';
      const isOpen = (c.status === 'open') || (c.isOpen === true);
      const startStr = c.startDate ? new Date(c.startDate).toISOString().slice(0,10) : '—';
      const endStr = c.endDate ? new Date(c.endDate).toISOString().slice(0,10) : '—';
      const range = (startStr !== '—' || endStr !== '—') ? `${startStr} to ${endStr}` : 'Standard Monthly Cycle';

      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;">${esc(monthVal)}</td>
        <td style="font-weight:600;">${esc(c.title || `${monthVal} Cycle`)}</td>
        <td style="font-size:12px;color:var(--ink-dim);">${esc(range)}</td>
        <td>
          <span class="badge" style="${isOpen ? 'background:#e6f4ea;color:#137333;' : 'background:#f1f3f4;color:#5f6368;'}font-weight:700;">
            ${isOpen ? 'Open' : 'Closed'}
          </span>
        </td>
        <td>
          <button class="btn btn-sm ${isOpen ? 'btn-ghost' : 'btn-primary'} btn-cycle-toggle" data-month="${esc(monthVal)}" data-open="${isOpen ? '1' : '0'}">
            ${isOpen ? 'Close Cycle' : 'Re-open'}
          </button>
        </td>
      `;
      tbody.appendChild(tr);
    });

    tbody.querySelectorAll('.btn-cycle-toggle').forEach(btn => {
      btn.addEventListener('click', async () => {
        const cycleMonth = btn.dataset.month;
        const currentOpen = btn.dataset.open === '1';
        try {
          await api('/api/admin/cycles', {
            method: 'POST',
            body: {
              month: cycleMonth,
              cycleMonth,
              isOpen: !currentOpen,
              status: !currentOpen ? 'open' : 'closed'
            }
          });
          showToast(`Cycle ${cycleMonth} ${!currentOpen ? 'opened' : 'closed'}`);
          await loadCycleList();
        } catch (err) {
          alert(err.message || 'Failed to toggle cycle status');
        }
      });
    });
  } catch (err) {
    tbody.innerHTML = `<tr><td colspan="5" style="text-align:center;color:red;padding:14px;">Error loading cycles: ${esc(err.message)}</td></tr>`;
  }
}

async function saveAssessmentCycle() {
  const errEl = document.getElementById('cycleError');
  const cycleMonth = (document.getElementById('cycleInputMonth')?.value || '').trim();
  const title = (document.getElementById('cycleInputTitle')?.value || '').trim();
  const startDate = document.getElementById('cycleInputStartDate')?.value || null;
  const endDate = document.getElementById('cycleInputEndDate')?.value || null;
  const isOpen = document.getElementById('cycleInputIsOpen')?.checked ?? true;

  if (errEl) {
    errEl.textContent = '';
    errEl.classList.add('hidden');
  }

  if (!cycleMonth || !/^\d{4}-\d{2}$/.test(cycleMonth)) {
    errEl.textContent = 'Please enter a valid Cycle Month format (YYYY-MM, e.g. 2026-11).';
    errEl.classList.remove('hidden');
    return;
  }
  if (!title) {
    errEl.textContent = 'Please enter a cycle display title.';
    errEl.classList.remove('hidden');
    return;
  }

  try {
    await api('/api/admin/cycles', {
      method: 'POST',
      body: {
        month: cycleMonth,
        cycleMonth,
        title,
        startDate,
        endDate,
        isOpen,
        status: isOpen ? 'open' : 'closed'
      }
    });
    showToast(`Cycle ${cycleMonth} saved successfully`);
    const mInput = document.getElementById('cycleInputMonth');
    if (mInput) mInput.value = '';
    const tInput = document.getElementById('cycleInputTitle');
    if (tInput) tInput.value = '';
    await loadCycleList();
  } catch (err) {
    if (errEl) {
      errEl.textContent = err.message || 'Failed to save assessment cycle.';
      errEl.classList.remove('hidden');
    }
  }
}

function applyDirectoryFilters() {
  const query = (document.getElementById('dirSearchInput')?.value || '').trim().toLowerCase();
  const filter = activeDirectoryFilter || 'all';

  let activeTbody = null;
  if (currentExactRole === 'Team Leader (TL)') activeTbody = document.getElementById('tlAssignedBody');
  else if (currentExactRole === 'Unit Admin') activeTbody = document.getElementById('unitAdminEmpBody');
  else if (currentExactRole === 'Senior Group Leader (SGL)') activeTbody = document.getElementById('sglTeamBody');
  else activeTbody = document.getElementById('adminStaffBody');

  if (!activeTbody) return;

  const rows = activeTbody.querySelectorAll('tr');
  let matchCount = 0;

  rows.forEach(row => {
    // Skip empty placeholder row
    if (row.querySelector('td[colspan]')) return;

    const text = row.textContent.toLowerCase();
    const matchesSearch = !query || text.includes(query);

    let matchesStatus = true;
    if (filter === 'pending') {
      matchesStatus = text.includes('pending') || text.includes('not evaluated');
    } else if (filter === 'evaluated') {
      matchesStatus = text.includes('evaluated') || text.includes('/ 10');
    } else if (filter === 'submitted') {
      matchesStatus = text.includes('submitted');
    } else if (filter === 'deactivated') {
      matchesStatus = text.includes('deactivated');
    }

    const show = matchesSearch && matchesStatus;
    row.style.display = show ? '' : 'none';
    if (show) matchCount++;
  });

  const countBadge = document.getElementById('dirCountBadge');
  if (countBadge) {
    countBadge.textContent = `Showing ${matchCount} ${matchCount === 1 ? 'employee' : 'employees'}`;
  }
}

// Directory Search & Filter listeners
document.getElementById('dirSearchInput')?.addEventListener('input', applyDirectoryFilters);
document.querySelectorAll('#dirFilters .dir-pill').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('#dirFilters .dir-pill').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    activeDirectoryFilter = btn.dataset.filter;
    applyDirectoryFilters();
  });
});

// User Management Modal event listeners
document.getElementById('btnAdminAddUser')?.addEventListener('click', () => openUserMgmtModal(null));
document.getElementById('btnDirAddUser')?.addEventListener('click', () => openUserMgmtModal(null));
document.getElementById('userMgmtCloseX')?.addEventListener('click', () => document.getElementById('userMgmtModal')?.classList.add('hidden'));
document.getElementById('userMgmtCancelBtn')?.addEventListener('click', () => document.getElementById('userMgmtModal')?.classList.add('hidden'));
document.getElementById('userMgmtSaveBtn')?.addEventListener('click', saveUserAccount);
document.getElementById('userMgmtRole')?.addEventListener('change', (e) => {
  const role = e.target.value;
  const isSuper = role === 'Super Admin' || role === 'HR Head';
  const supBlock = document.getElementById('userMgmtSupervisorsBlock');
  if (supBlock) supBlock.style.display = isSuper ? 'none' : 'block';
});
document.getElementById('userMgmtIsActive')?.addEventListener('change', (e) => {
  const lbl = document.getElementById('userMgmtActiveLabel');
  if (lbl) lbl.textContent = e.target.checked ? 'Active & Permitted' : 'Deactivated / Login Blocked';
});

// CSV Export buttons
function triggerCsvExport() {
  const isSuperOrHr = currentExactRole === 'Super Admin' || currentExactRole === 'HR Head';
  const isUnitAdmin = currentExactRole === 'Unit Admin';
  if (!isSuperOrHr && !isUnitAdmin) {
    showToast('Exporting reports is restricted to authorized Administrators.');
    return;
  }
  showToast('Generating consolidated evaluation report…');
  const unit = (currentExactRole === 'Unit Admin' && (currentUser?.unitId || currentUnitName)) 
    ? (currentUser?.unitId || currentUnitName) 
    : (selectedUnitFilter || 'all');
  window.location.href = `/api/admin/export-csv?unit=${encodeURIComponent(unit)}&month=${encodeURIComponent(getGlobalCycle())}`;
}
document.getElementById('btnAdminExportCsv')?.addEventListener('click', triggerCsvExport);
document.getElementById('btnDirExportCsv')?.addEventListener('click', triggerCsvExport);

// Assessment Cycle Modal event listeners
document.getElementById('btnAdminCycles')?.addEventListener('click', openCycleMgmtModal);
document.getElementById('cycleMgmtCloseX')?.addEventListener('click', () => document.getElementById('cycleMgmtModal')?.classList.add('hidden'));
document.getElementById('cycleCloseBtn')?.addEventListener('click', () => document.getElementById('cycleMgmtModal')?.classList.add('hidden'));
document.getElementById('btnSaveCycle')?.addEventListener('click', saveAssessmentCycle);

// Unit Management (Super Admin)
let currentUnitsList = [];

async function openUnitMgmtModal() {
  const modal = document.getElementById('unitMgmtModal');
  const listEl = document.getElementById('unitMgmtList');
  const errEl = document.getElementById('unitEditError');
  const idInput = document.getElementById('unitEditId');
  const nameInput = document.getElementById('unitEditName');
  const codeInput = document.getElementById('unitEditCode');
  const pwInput = document.getElementById('unitEditPassword');
  const titleEl = document.getElementById('unitEditFormTitle');

  if (errEl) {
    errEl.textContent = '';
    errEl.classList.add('hidden');
  }
  if (idInput) idInput.value = '';
  if (nameInput) nameInput.value = '';
  if (codeInput) codeInput.value = '';
  if (pwInput) pwInput.value = '';
  if (titleEl) titleEl.textContent = 'Select a plant above or modify below';

  modal.classList.remove('hidden');

  try {
    const res = await api('/api/admin/units');
    currentUnitsList = res.units || [];
    if (!currentUnitsList.length) {
      listEl.innerHTML = '<div style="color:var(--ink-dim);font-size:12px;">No plant units found.</div>';
      return;
    }

    listEl.innerHTML = currentUnitsList.map(u => `
      <div style="display:flex;align-items:center;justify-content:space-between;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:6px;">
        <div>
          <strong style="font-size:13.5px;color:var(--ink-main);">${esc(u.name)}</strong>
          ${u.code ? `<span class="who-unit" style="margin-left:8px;">${esc(u.code)}</span>` : ''}
        </div>
        <button type="button" class="btn btn-xs btn-ghost btn-select-unit-edit" data-id="${esc(u.id)}" data-name="${esc(u.name)}" data-code="${esc(u.code || '')}" style="font-weight:700;color:var(--mahle-blue);">
          Select to Edit ✏️
        </button>
      </div>
    `).join('');

    listEl.querySelectorAll('.btn-select-unit-edit').forEach(btn => {
      btn.addEventListener('click', () => {
        idInput.value = btn.dataset.id;
        nameInput.value = btn.dataset.name;
        codeInput.value = btn.dataset.code;
        titleEl.textContent = `Rename Plant: ${btn.dataset.name}`;
        pwInput.value = '';
        if (errEl) errEl.classList.add('hidden');
        nameInput.focus();
      });
    });

    if (currentUnitsList.length > 0 && !idInput.value) {
      const first = currentUnitsList[0];
      idInput.value = first.id;
      nameInput.value = first.name;
      codeInput.value = first.code || '';
      titleEl.textContent = `Rename Plant: ${first.name}`;
    }
  } catch (err) {
    listEl.innerHTML = `<div style="color:red;font-size:12px;">Failed to load units: ${esc(err.message)}</div>`;
  }
}

async function saveUnitEdit() {
  const errEl = document.getElementById('unitEditError');
  const unitId = (document.getElementById('unitEditId')?.value || '').trim();
  const name = (document.getElementById('unitEditName')?.value || '').trim();
  const code = (document.getElementById('unitEditCode')?.value || '').trim().toUpperCase();
  const password = (document.getElementById('unitEditPassword')?.value || '').trim();

  if (errEl) {
    errEl.textContent = '';
    errEl.classList.add('hidden');
  }

  if (!unitId) {
    errEl.textContent = 'Please select a plant unit from the list above.';
    errEl.classList.remove('hidden');
    return;
  }
  if (!name) {
    errEl.textContent = 'Please enter a valid unit name.';
    errEl.classList.remove('hidden');
    return;
  }
  if (!password) {
    errEl.textContent = 'Super Admin password is required to authorize changing the unit name.';
    errEl.classList.remove('hidden');
    return;
  }

  try {
    const res = await api('/api/admin/units', {
      method: 'PATCH',
      body: { unitId, name, code, password }
    });

    showToast(res.message || 'Unit renamed successfully');
    document.getElementById('unitMgmtModal')?.classList.add('hidden');
    document.getElementById('unitEditPassword').value = '';

    // Invalidate metadata cache so all dropdowns refresh
    adminMetadataCache = null;

    // Refresh dynamic pills, dashboard, and metadata
    await renderUnitFilterPills();
    if (screens.home && !screens.home.classList.contains('hidden') && (currentExactRole === 'Super Admin' || currentExactRole === 'HR Head')) {
      await renderAdminDashboard(selectedUnitFilter);
    }
    await loadAdminMetadata();
  } catch (err) {
    if (errEl) {
      errEl.textContent = err.message || 'Failed to update unit.';
      errEl.classList.remove('hidden');
    }
  }
}

document.getElementById('topbarManageUnitsBtn')?.addEventListener('click', openUnitMgmtModal);
document.getElementById('unitBarEditBtn')?.addEventListener('click', openUnitMgmtModal);
document.getElementById('unitMgmtCloseX')?.addEventListener('click', () => document.getElementById('unitMgmtModal')?.classList.add('hidden'));
document.getElementById('unitEditCancelBtn')?.addEventListener('click', () => document.getElementById('unitMgmtModal')?.classList.add('hidden'));
document.getElementById('unitEditSaveBtn')?.addEventListener('click', saveUnitEdit);

/* ============================= MASTER CATALOG (TRAINING & ACTIVITIES) ============================= */
let masterTrainingsCache = null;
let masterActivitiesCache = null;
let masterItemsLoaded = false;
let masterTrainingSearchQuery = '';
let masterActivitySearchQuery = '';

const DEFAULT_TRAINING_NAMES = ['APS -4 Day', 'APS Refresher', 'TPM', 'SPC', 'PFEMA', 'EMS', 'Product Process Knowledge', 'Sales', 'Others'];
const DEFAULT_ACTIVITY_NAMES = ['Participation in Committees', 'Sports', 'First Aid', 'Safety Committee', 'Canteen Committee', 'Cultural Activities', 'Participation in CI-meet'];

async function loadMasterItems(forceRefresh = false) {
  if (masterItemsLoaded && !forceRefresh) return;
  try {
    const res = await api('/api/master-items');
    if (res && (res.ok || res.success)) {
      masterTrainingsCache = (Array.isArray(res.trainings) ? res.trainings : []).map(t => ({
        id: t.id,
        name: t.title || t.name,
        type: 'training',
        sortOrder: t.sortOrder
      }));
      masterActivitiesCache = (Array.isArray(res.activities) ? res.activities : []).map(a => ({
        id: a.id,
        name: a.title || a.name,
        type: 'activity',
        sortOrder: a.sortOrder
      }));
      masterItemsLoaded = true;
    }
  } catch (err) {
    console.warn('Failed to load master items, using fallbacks:', err);
    if (!masterTrainingsCache) masterTrainingsCache = DEFAULT_TRAINING_NAMES.map((name, i) => ({ id: `tr_${i}`, type: 'training', name, sortOrder: i }));
    if (!masterActivitiesCache) masterActivitiesCache = DEFAULT_ACTIVITY_NAMES.map((name, i) => ({ id: `ac_${i}`, type: 'activity', name, sortOrder: i }));
  }
}

function getMasterTrainingsList() {
  if (masterTrainingsCache && masterTrainingsCache.length) {
    return masterTrainingsCache.map(t => t.name);
  }
  return DEFAULT_TRAINING_NAMES;
}

function getMasterActivitiesList() {
  if (masterActivitiesCache && masterActivitiesCache.length) {
    return masterActivitiesCache.map(a => a.name);
  }
  return DEFAULT_ACTIVITY_NAMES;
}

async function renderMasterItemsPage() {
  await loadMasterItems(true);
  renderMasterItemsTables();
}

function renderMasterItemsTables() {
  const trTbody = document.getElementById('masterTrainingTableBody');
  const acTbody = document.getElementById('masterActivityTableBody');
  const trCountEl = document.getElementById('masterTrCount');
  const acCountEl = document.getElementById('masterAcCount');
  const trBadge = document.getElementById('trBadgeCount');
  const acBadge = document.getElementById('acBadgeCount');

  const trainings = masterTrainingsCache || [];
  const activities = masterActivitiesCache || [];

  if (trCountEl) trCountEl.textContent = trainings.length;
  if (acCountEl) acCountEl.textContent = activities.length;
  if (trBadge) trBadge.textContent = `${trainings.length} Topics`;
  if (acBadge) acBadge.textContent = `${activities.length} Activities`;

  // Filter trainings
  const qTr = (masterTrainingSearchQuery || '').toLowerCase().trim();
  const filteredTrainings = qTr ? trainings.filter(t => t.name.toLowerCase().includes(qTr)) : trainings;

  if (trTbody) {
    if (!filteredTrainings.length) {
      trTbody.innerHTML = `<tr><td colspan="3" style="text-align:center;padding:18px;color:var(--ink-dim);">${trainings.length === 0 ? 'No training courses configured yet. Add one above!' : 'No matching courses found.'}</td></tr>`;
    } else {
      trTbody.innerHTML = filteredTrainings.map((t, idx) => `
        <tr data-id="${esc(t.id)}">
          <td style="text-align:center;color:var(--ink-dim);font-weight:600;font-size:12px;">${idx + 1}</td>
          <td style="font-weight:600;color:var(--ink);font-size:13px;">${esc(t.name)}</td>
          <td style="text-align:center;">
            <button type="button" class="btn btn-sm btn-ghost del-master-item-btn" data-type="training" data-id="${esc(t.id)}" data-name="${esc(t.name)}" title="Delete Course" style="color:#dc2626;padding:3px 8px;font-size:12px;">
              Delete
            </button>
          </td>
        </tr>
      `).join('');
    }
  }

  // Filter activities
  const qAc = (masterActivitySearchQuery || '').toLowerCase().trim();
  const filteredActivities = qAc ? activities.filter(a => a.name.toLowerCase().includes(qAc)) : activities;

  if (acTbody) {
    if (!filteredActivities.length) {
      acTbody.innerHTML = `<tr><td colspan="3" style="text-align:center;padding:18px;color:var(--ink-dim);">${activities.length === 0 ? 'No activities configured yet. Add one above!' : 'No matching activities found.'}</td></tr>`;
    } else {
      acTbody.innerHTML = filteredActivities.map((a, idx) => `
        <tr data-id="${esc(a.id)}">
          <td style="text-align:center;color:var(--ink-dim);font-weight:600;font-size:12px;">${idx + 1}</td>
          <td style="font-weight:600;color:var(--ink);font-size:13px;">${esc(a.name)}</td>
          <td style="text-align:center;">
            <button type="button" class="btn btn-sm btn-ghost del-master-item-btn" data-type="activity" data-id="${esc(a.id)}" data-name="${esc(a.name)}" title="Delete Activity" style="color:#dc2626;padding:3px 8px;font-size:12px;">
              Delete
            </button>
          </td>
        </tr>
      `).join('');
    }
  }
}

async function handleAddMasterItem(type, nameInputId, errorElId) {
  const input = document.getElementById(nameInputId);
  const errorEl = document.getElementById(errorElId);
  if (!input) return;
  const name = input.value.trim();
  if (errorEl) { errorEl.textContent = ''; errorEl.classList.add('hidden'); }
  if (!name) {
    if (errorEl) { errorEl.textContent = 'Please enter a name.'; errorEl.classList.remove('hidden'); }
    return;
  }
  try {
    const res = await api('/api/admin/master-items', {
      method: 'POST',
      body: { action: 'add', type, name, title: name }
    });
    if (res && (res.success || res.ok)) {
      input.value = '';
      showToast(`${type === 'training' ? 'Training course' : 'Plant activity'} added successfully.`);
      await renderMasterItemsPage();
    } else {
      throw new Error(res?.error || 'Failed to add item.');
    }
  } catch (err) {
    if (errorEl) {
      errorEl.textContent = err.message || 'Error adding item.';
      errorEl.classList.remove('hidden');
    } else {
      showToast(err.message);
    }
  }
}

async function handleDeleteMasterItem(type, id, name) {
  try {
    // 1. Optimistically remove from client cache for immediate 0ms UI feedback
    if (type === 'training' && masterTrainingsCache) {
      masterTrainingsCache = masterTrainingsCache.filter(item => item.id !== id && item.name !== name);
    } else if (type === 'activity' && masterActivitiesCache) {
      masterActivitiesCache = masterActivitiesCache.filter(item => item.id !== id && item.name !== name);
    }
    renderMasterItemsTables();

    // 2. Call admin delete API
    const res = await api('/api/admin/master-items', {
      method: 'POST',
      body: { action: 'delete', type, id, name, title: name }
    });

    // 3. Verify success (both res.ok and res.success supported)
    if (res && (res.ok || res.success)) {
      showToast(`Deleted "${name}".`);
      await renderMasterItemsPage();
    } else {
      throw new Error(res?.error || 'Failed to delete item.');
    }
  } catch (err) {
    showToast(err.message || 'Error deleting item.');
    await renderMasterItemsPage();
  }
}

// Master Items event listeners
document.getElementById('masterItemsRefreshBtn')?.addEventListener('click', () => {
  renderMasterItemsPage();
});
document.getElementById('masterItemsBackBtn')?.addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('adminMasterCatalogBtn')?.addEventListener('click', async () => {
  await renderMasterItemsPage();
  showScreen('masterItems');
});

document.getElementById('addTrainingBtn')?.addEventListener('click', () => {
  handleAddMasterItem('training', 'newTrainingInput', 'addTrainingError');
});
document.getElementById('newTrainingInput')?.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') {
    e.preventDefault();
    handleAddMasterItem('training', 'newTrainingInput', 'addTrainingError');
  }
});

document.getElementById('addActivityBtn')?.addEventListener('click', () => {
  handleAddMasterItem('activity', 'newActivityInput', 'addActivityError');
});
document.getElementById('newActivityInput')?.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') {
    e.preventDefault();
    handleAddMasterItem('activity', 'newActivityInput', 'addActivityError');
  }
});

document.getElementById('searchTrainingInput')?.addEventListener('input', (e) => {
  masterTrainingSearchQuery = e.target.value;
  renderMasterItemsTables();
});
document.getElementById('searchActivityInput')?.addEventListener('input', (e) => {
  masterActivitySearchQuery = e.target.value;
  renderMasterItemsTables();
});

document.getElementById('masterTrainingTableBody')?.addEventListener('click', (e) => {
  const btn = e.target.closest('.del-master-item-btn');
  if (btn) {
    handleDeleteMasterItem(btn.dataset.type, btn.dataset.id, btn.dataset.name);
  }
});
document.getElementById('masterActivityTableBody')?.addEventListener('click', (e) => {
  const btn = e.target.closest('.del-master-item-btn');
  if (btn) {
    handleDeleteMasterItem(btn.dataset.type, btn.dataset.id, btn.dataset.name);
  }
});

// Global delegated click listener for unit filter pills and edit unit button
document.addEventListener('click', async (e) => {
  const editBtn = e.target.closest('#unitBarEditBtn, #topbarManageUnitsBtn');
  if (editBtn) {
    e.preventDefault();
    openUnitMgmtModal();
    return;
  }

  const pill = e.target.closest('#dynamicUnitPills .unit-pill, .unit-filter-bar .unit-pill');
  if (!pill) return;
  e.preventDefault();

  const container = document.getElementById('dynamicUnitPills') || pill.parentElement;
  if (container) {
    container.querySelectorAll('.unit-pill').forEach(b => b.classList.remove('active'));
  }
  pill.classList.add('active');
  selectedUnitFilter = pill.dataset.unit || 'all';
  await renderAdminDashboard(selectedUnitFilter, getGlobalCycle());
});


/* ============================= DEDICATED SCREEN: LOOK UP EMPLOYEE ============================= */
function renderLookupPage() {
  const input = document.getElementById('lookupPageInput');
  const errEl = document.getElementById('lookupPageError');
  const previewBox = document.getElementById('lookupPreviewBox');
  if (input) input.value = '';
  if (errEl) errEl.textContent = '';
  if (previewBox) previewBox.classList.add('hidden');
  setTimeout(() => input?.focus(), 50);
}

async function doLookupSearch(empCode) {
  const code = (empCode || document.getElementById('lookupPageInput')?.value || '').trim().toUpperCase();
  const errEl = document.getElementById('lookupPageError');
  const previewBox = document.getElementById('lookupPreviewBox');
  if (errEl) errEl.textContent = '';

  if (!code) {
    if (errEl) errEl.textContent = 'Please enter an Employee ID or Code to search.';
    return;
  }

  try {
    const res = await api(`/api/employee/${encodeURIComponent(code)}/name`);
    if (!res.name && !res.user) {
      if (errEl) errEl.textContent = `No employee found with code "${code}".`;
      if (previewBox) previewBox.classList.add('hidden');
      return;
    }

    const name = res.name || code;
    const u = res.user || {};
    const unit = u.unitName || currentUnitName || 'Unit';
    const role = (u.role === 'Shop Floor Employee' ? 'Employee' : u.role) || 'Employee';
    const dept = u.departmentName || 'Operations';

    // Fetch assessment info
    let assess = null;
    try {
      const aRes = await api(`/api/employee/assessment?empCode=${encodeURIComponent(code)}`);
      assess = aRes.assessment || null;
    } catch (e) {}

    // Populate preview card
    const lpName = document.getElementById('lpName');
    const lpCode = document.getElementById('lpCode');
    const lpUnit = document.getElementById('lpUnit');
    const lpRole = document.getElementById('lpRole');
    const lpDept = document.getElementById('lpDept');
    const lpScore = document.getElementById('lpScore');
    const lpBadge = document.getElementById('lpBadge');

    if (lpName) lpName.textContent = name;
    if (lpCode) lpCode.textContent = code;
    if (lpUnit) lpUnit.textContent = unit;
    if (lpRole) lpRole.textContent = role;
    if (lpDept) lpDept.textContent = dept;

    const scoreVal = (assess && assess.tlScore !== null && assess.tlScore !== undefined) ? assess.tlScore : assess?.score;
    if (lpScore) {
      lpScore.textContent = scoreVal !== null && scoreVal !== undefined ? `${Number(scoreVal).toFixed(1)} / 10.0` : 'Not Evaluated';
    }
    if (lpBadge) {
      if (scoreVal !== null && scoreVal !== undefined) {
        lpBadge.textContent = `Evaluated · ${assess.ratingGrade || 'Grade A'}`;
        lpBadge.className = 'badge badge-evaluated';
      } else if (assess && (assess.submissionStatus === 'submitted' || assess.submissionStatus === 'Submitted')) {
        lpBadge.textContent = 'Submitted · Awaiting TL Score';
        lpBadge.className = 'badge badge-submitted';
      } else {
        lpBadge.textContent = 'Evaluation Pending';
        lpBadge.className = 'badge badge-pending';
      }
    }

    // Wire action buttons
    const openBtn = document.getElementById('lpOpenBtn');
    if (openBtn) {
      openBtn.onclick = async () => {
        await selectEmployee(code, name, unit);
      };
    }

    const evalBtn = document.getElementById('lpEvalBtn');
    if (evalBtn) {
      evalBtn.onclick = () => {
        openEvalModal(code, name, scoreVal || 8.5, assess?.ratingGrade || '', assess?.tlComments || '');
      };
    }

    if (previewBox) previewBox.classList.remove('hidden');
  } catch (err) {
    if (errEl) errEl.textContent = err.message || `Employee "${code}" not found.`;
    if (previewBox) previewBox.classList.add('hidden');
  }
}

document.getElementById('lookupPageBtn')?.addEventListener('click', () => doLookupSearch());
document.getElementById('lookupPageInput')?.addEventListener('keydown', (e) => {
  if (e.key === 'Enter') doLookupSearch();
});

// Quick chips
document.querySelectorAll('#lookupChips .lookup-chip').forEach(chip => {
  chip.addEventListener('click', () => {
    const code = chip.dataset.id;
    const input = document.getElementById('lookupPageInput');
    if (input) input.value = code;
    doLookupSearch(code);
  });
});

// Backward compatibility alias for lookup
document.getElementById('lookupBtn')?.addEventListener('click', async () => {
  const id = document.getElementById('lookupId')?.value.trim().toUpperCase();
  if (id) await selectEmployee(id);
});

/* ============================= DEDICATED SCREEN: SECURITY & PASSWORDS ============================= */
function renderChangePwPage() {
  const whoName = document.getElementById('secWhoName');
  const whoRole = document.getElementById('secWhoRole');
  const whoId = document.getElementById('secWhoId');
  const whoUnit = document.getElementById('secWhoUnit');

  if (whoName) whoName.textContent = currentUser?.name || currentEmpId || '—';
  if (whoRole) whoRole.textContent = (currentExactRole === 'Shop Floor Employee' ? 'Employee' : currentExactRole) || (currentRole === 'supervisor' ? 'Manager / Admin' : 'Employee');
  if (whoId) whoId.textContent = currentEmpId || '—';
  if (whoUnit) whoUnit.textContent = currentUnitName || (currentExactRole === 'Super Admin' ? 'All Units (Global)' : 'State Unit');

  const cur = document.getElementById('pwCurrent');
  const next = document.getElementById('pwNew');
  const confirm = document.getElementById('pwConfirm');
  const errEl = document.getElementById('pwError');
  const successEl = document.getElementById('pwSuccess');

  if (cur) cur.value = '';
  if (next) next.value = '';
  if (confirm) confirm.value = '';
  if (errEl) errEl.textContent = '';
  if (successEl) successEl.classList.add('hidden');
}

document.getElementById('changePwBtn')?.addEventListener('click', async () => {
  const cur = document.getElementById('pwCurrent')?.value.trim();
  const next = document.getElementById('pwNew')?.value.trim();
  const confirm = document.getElementById('pwConfirm')?.value.trim();
  const errEl = document.getElementById('pwError');
  const successEl = document.getElementById('pwSuccess');

  if (errEl) errEl.textContent = '';
  if (successEl) successEl.classList.add('hidden');

  if (!cur || !next || !confirm) {
    if (errEl) errEl.textContent = 'Please fill in all three password fields.';
    return;
  }
  if (next.length < 6) {
    if (errEl) errEl.textContent = 'New password must be at least 6 characters long.';
    return;
  }
  if (next !== confirm) {
    if (errEl) errEl.textContent = 'New password and confirmation do not match.';
    return;
  }

  try {
    await api('/api/change-password', { method: 'POST', body: { currentPassword: cur, newPassword: next } });
    if (document.getElementById('pwCurrent')) document.getElementById('pwCurrent').value = '';
    if (document.getElementById('pwNew')) document.getElementById('pwNew').value = '';
    if (document.getElementById('pwConfirm')) document.getElementById('pwConfirm').value = '';
    if (successEl) successEl.classList.remove('hidden');
    showToast('Passcode updated successfully!');
  } catch (e) {
    if (errEl) errEl.textContent = e.message;
  }
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
  if (!dropdown) return;
  dropdown.innerHTML = '<option value="">— Select a section —</option>';
  SHEETS.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.textContent = `${s.num}. ${s.name}`;
    dropdown.appendChild(opt);
  });
}
const dropdownGoBtn = document.getElementById('dropdownGoBtn');
if (dropdownGoBtn) {
  dropdownGoBtn.addEventListener('click', () => {
    if (dropdown && dropdown.value) openSheet(dropdown.value);
  });
}

async function renderMenu(month = getGlobalCycle()) {
  currentSheetId = null;
  const currentCycle = month || getGlobalCycle();
  if (viewingEmpId && (!activeEmployeeInfo || activeEmployeeInfo.empCode !== viewingEmpId)) {
    await updateActiveEmployeeInfo(viewingEmpId);
  }
  updateEmployeeNavBar();
  rebuildDropdown();
  const isSup = currentRole === 'supervisor' || (currentExactRole !== 'Employee' && currentExactRole !== 'Shop Floor Employee');
  const recordHeader = document.getElementById('recordHeader');
  const submitBox = document.getElementById('submitBox');

  if (isSup && viewingEmpId && viewingEmpId !== currentEmpId) {
    recordHeader?.classList.remove('hidden');
    submitBox?.classList.add('hidden');
    const menuEyebrow = document.getElementById('menuEyebrow');
    if (menuEyebrow) menuEyebrow.textContent = 'Supervisor View';
    const rhName = document.getElementById('rhName');
    if (rhName) rhName.textContent = await getDisplayName(viewingEmpId);
    const rhSub = document.getElementById('rhSub');
    if (rhSub) rhSub.textContent = `Employee ID: ${viewingEmpId} · Cycle: ${getCycleLabel(currentCycle)} · Sections 1–9 are read-only`;
  } else if (isSup) {
    recordHeader?.classList.add('hidden');
    submitBox?.classList.add('hidden');
    const menuEyebrow = document.getElementById('menuEyebrow');
    if (menuEyebrow) menuEyebrow.textContent = 'Management View';
  } else {
    recordHeader?.classList.add('hidden');
    submitBox?.classList.remove('hidden');
    const menuEyebrow = document.getElementById('menuEyebrow');
    if (menuEyebrow) menuEyebrow.textContent = 'Growth Performance';
    const monthLabel = document.getElementById('submitMonthLabel');
    if (monthLabel) monthLabel.textContent = getCycleLabel(currentCycle);
    const statusEl = document.getElementById('submitStatus');
    try {
      const { submitted, submittedAt } = await api(`/api/my-submission?month=${encodeURIComponent(currentCycle)}`);
      if (statusEl) {
        if (submitted) {
          statusEl.textContent = `Submitted for ${getCycleLabel(currentCycle)} on ${new Date(submittedAt).toLocaleString()}`;
          statusEl.classList.add('done');
        } else {
          statusEl.textContent = `Not submitted yet for ${getCycleLabel(currentCycle)}`;
          statusEl.classList.remove('done');
        }
      }
    } catch (e) {}
  }

  const grid = document.getElementById('stationGrid');
  grid.innerHTML = '';
  for (const s of SHEETS) {
    const isViewOnly = (!isSup && s.id === 'supervisor') || (isSup && s.id !== 'supervisor');
    const btn = document.createElement('button');
    btn.className = 'station';
    btn.innerHTML = `<div class="num">${String(s.num).padStart(2, '0')}</div>
      <div class="name">${s.name}</div>
      <div class="status" data-status="${s.id}">checking…</div>
      ${isViewOnly ? '<div class="locked-tag" title="View only">View Only</div>' : ''}`;
    btn.addEventListener('click', () => openSheet(s.id));
    grid.appendChild(btn);
  }

  await Promise.all(SHEETS.map(async (s) => {
    try {
      const data = await loadSheetData(viewingEmpId, s.id, currentCycle);
      const el = grid.querySelector(`[data-status="${s.id}"]`);
      if (el) {
        const isViewOnly = (!isSup && s.id === 'supervisor') || (isSup && s.id !== 'supervisor');
        const prefix = isViewOnly ? 'View only · ' : '';
        if (data) {
          el.textContent = prefix + 'Completed';
          el.classList.add('saved');
        } else {
          el.textContent = prefix + 'Not started';
          el.classList.remove('saved');
        }
      }
    } catch (e) {}
  }));
}

document.getElementById('submitBtn').addEventListener('click', async () => {
  try {
    await api('/api/submit', { method: 'POST', body: { month: getGlobalCycle() } });
    showToast(`Submitted passport for ${getGlobalCycleLabel()} to supervisor`);
    renderMenu();
  } catch (e) { showToast(e.message); }
});

async function openSheet(sheetId) {
  currentSheetId = sheetId;
  const meta = SHEETS.find(s => s.id === sheetId);
  if (!meta) return;

  const isEmp = currentExactRole === 'Employee' || currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);

  if (!viewingEmpId) {
    viewingEmpId = currentEmpId;
  }
  if (!activeEmployeeInfo || activeEmployeeInfo.empCode !== viewingEmpId) {
    await updateActiveEmployeeInfo(viewingEmpId);
  }

  let readOnlyMessage = '';
  if (!isEmp && sheetId !== 'supervisor') {
    readOnlyMessage = `Viewing only (${esc(viewingEmpId)}) — this section belongs to the employee and can't be edited here.`;
  } else if (isEmp && sheetId === 'supervisor') {
    readOnlyMessage = "Viewing only — Supervisor Remarks can only be filled in by your supervisor.";
  }
  const isReadOnly = !!readOnlyMessage;

  document.getElementById('formCrumb').textContent = `Growth Performance / ${String(meta.num).padStart(2, '0')}`;
  document.getElementById('formTitle').textContent = meta.name;

  const formCycleBadge = document.getElementById('formCycleBadge');
  if (formCycleBadge) {
    if (sheetId === 'frontpage') {
      formCycleBadge.textContent = 'Scope: Permanent Profile (Never Resets)';
      formCycleBadge.className = 'badge badge-evaluated';
    } else if (sheetId === 'swot') {
      formCycleBadge.textContent = `Cycle: ${getGlobalCycleLabel()} (Monthly Reset)`;
      formCycleBadge.className = 'badge badge-evaluated';
    } else {
      formCycleBadge.textContent = `Year: ${globalSelectedYear} (Annual Record · Resets Yearly)`;
      formCycleBadge.className = 'badge badge-evaluated';
    }
  }

  const container = document.getElementById('sheetContainer');
  container.innerHTML = '<p style="color:#6b7290;">Loading…</p>';
  showScreen('form');
  updateEmployeeNavBar();
  updateSidebarActive();
  if (sheetId === 'training' || sheetId === 'activities') {
    await loadMasterItems();
  }
  const saved = await loadSheetData(viewingEmpId, sheetId, getGlobalCycle());
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
  const ok = await saveSheetData(viewingEmpId, currentSheetId, data, getGlobalCycle());
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

function toDateInputVal(val) {
  if (!val) return '';
  const s = String(val).trim();
  if (/^\d{4}-\d{2}-\d{2}/.test(s)) return s.substring(0, 10);
  const d = new Date(s);
  if (!isNaN(d.getTime())) return d.toISOString().split('T')[0];
  return s;
}

/* ---------- 1. FRONT PAGE ---------- */
RENDERERS.frontpage = (el, d) => {
  d = Object.assign({
    empCode: viewingEmpId || '',
    name: '',
    father: '',
    dob: '',
    doj: '',
    designation: '',
    gradeCode: '',
    groupDoj: '',
    mobile: '',
    email: '',
    permAddr: '',
    phone1: '',
    corrAddr: '',
    phone2: '',
  }, d);

  el.innerHTML = `
    <h2 class="section-title">About Myself</h2>
    <p class="small-note" style="margin-bottom:14px;color:var(--mahle-blue);font-weight:600;">
      Permanent Employee Profile &amp; Growth Passport Master Record. Synchronized automatically from your personnel profile.
    </p>

    <!-- Professional & Employment Details -->
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:8px;padding:14px;margin-bottom:16px;">
      <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);text-transform:uppercase;margin-bottom:12px;letter-spacing:0.04em;">
        Official Employment Record
      </div>
      <div class="grid-2">
        <div class="field-block">
          <label class="f">Employee No. (Emp Code)</label>
          <input type="text" id="f_empCode" value="${esc(d.empCode || viewingEmpId || '')}" readonly style="background:#f1f3f9;font-weight:700;font-family:var(--font-mono);">
        </div>
        <div class="field-block">
          <label class="f">Full Name / Display Name</label>
          <input type="text" id="f_name" value="${esc(d.name)}">
        </div>
        <div class="field-block">
          <label class="f">Designation</label>
          <input type="text" id="f_designation" value="${esc(d.designation)}">
        </div>
        <div class="field-block">
          <label class="f">Grade Code</label>
          <input type="text" id="f_gradeCode" value="${esc(d.gradeCode)}">
        </div>
        <div class="field-block">
          <label class="f">Date of Joining (Joined On)</label>
          <input type="date" id="f_doj" value="${esc(toDateInputVal(d.doj))}">
        </div>
        <div class="field-block">
          <label class="f">Group Joining Date</label>
          <input type="date" id="f_groupDoj" value="${esc(toDateInputVal(d.groupDoj))}">
        </div>
      </div>
    </div>

    <!-- Personal & Contact Details -->
    <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:14px;margin-bottom:16px;">
      <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);text-transform:uppercase;margin-bottom:12px;letter-spacing:0.04em;">
        Personal Details &amp; Contacts
      </div>
      <div class="grid-2">
        <div class="field-block">
          <label class="f">Father's Name</label>
          <input type="text" id="f_father" value="${esc(d.father)}">
          <div class="small-note">Can be edited or updated anytime.</div>
        </div>
        <div class="field-block">
          <label class="f">Date of Birth (Birth Date)</label>
          <input type="date" id="f_dob" value="${esc(toDateInputVal(d.dob))}">
        </div>
        <div class="field-block">
          <label class="f">Mobile Number</label>
          <input type="text" id="f_mobile" value="${esc(d.mobile)}" placeholder="e.g. 9876543210" style="width:100%;box-sizing:border-box;">
        </div>
        <div class="field-block">
          <label class="f">Email ID</label>
          <input type="email" id="f_email" value="${esc(d.email)}" placeholder="e.g. employee@mahle.com" style="width:100%;box-sizing:border-box;">
        </div>
      </div>
    </div>

    <!-- Address Information -->
    <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:14px;margin-bottom:16px;">
      <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);text-transform:uppercase;margin-bottom:12px;letter-spacing:0.04em;">
        Address Information
      </div>
      <div class="field-block">
        <label class="f">Permanent Address</label>
        <textarea id="f_permaddr" placeholder="Enter permanent residential address...">${esc(d.permAddr)}</textarea>
      </div>
      <div class="field-block" style="margin-top:12px;">
        <label class="f">Correspondence Address</label>
        <textarea id="f_corraddr" placeholder="Enter correspondence / current communication address...">${esc(d.corrAddr)}</textarea>
      </div>
    </div>
  `;
};
COLLECTORS.frontpage = () => ({
  empCode: val('f_empCode') || viewingEmpId,
  name: val('f_name'),
  father: val('f_father'),
  dob: val('f_dob'),
  doj: val('f_doj'),
  designation: val('f_designation'),
  gradeCode: val('f_gradeCode'),
  groupDoj: val('f_groupDoj'),
  mobile: val('f_mobile'),
  email: val('f_email'),
  permAddr: val('f_permaddr'),
  corrAddr: val('f_corraddr'),
  phone1: val('f_mobile'),
  phone2: '',
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
  const currYear = now.getFullYear();

  d = Object.assign({year: parseInt(globalSelectedYear, 10) || currYear, regular: emptyGrid(), extra: emptyGrid()}, d);

  el.innerHTML = `
    <h2 class="section-title">Attendance Sheet</h2>
    <div class="field-block" style="max-width: 150px;">
      <label class="f">Year</label>
      <input type="number" id="att_year" value="${esc(d.year)}">
    </div>
    <p class="small-note" style="margin-bottom:10px;color:var(--ink-dim);">Monthly attendance logs across all categories (Present, Absent, Leave, Holiday, Week Off). All months are open for filling.</p>
    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:14px 0 8px;">Attendance</h3>
    ${attendanceTable('reg', d.regular)}
    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:20px 0 8px;">Extra Work</h3>
    ${attendanceTable('ext', d.extra)}
  `;
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
  const trainingList = getMasterTrainingsList();
  trainingList.forEach(k=>{ if(!d.fixed[k]) d.fixed[k] = Array(12).fill(false); });
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
    <button type="button" class="addrow-btn" id="ojtAddBtn">+ Add training</button>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:20px 0 8px;">Program Training</h3>
    <div class="table-scroll"><table class="grid-table">
      ${monthHeaderRow('Program')}
      ${trainingList.map(k=>`
        <tr><td class="rowlabel">${esc(k)}</td>
        ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="tr-fixed" data-key="${esc(k)}" data-mi="${mi}" ${(d.fixed[k] && d.fixed[k][mi])?'checked':''}></td>`).join('')}
        </tr>`).join('')}
    </table></div>
  `;
  document.getElementById('ojtAddBtn')?.addEventListener('click', ()=>{
    const tbl = document.getElementById('ojtTable');
    const ri = tbl.querySelectorAll('tr.ojt-row').length;
    tbl.insertAdjacentHTML('beforeend', ojtRow({title:'',months:Array(12).fill(false)}, ri));
  });
  document.getElementById('ojtTable')?.addEventListener('click', (e) => {
    const delBtn = e.target.closest('.ojt-del-btn');
    if (delBtn) {
      delBtn.closest('tr.ojt-row')?.remove();
    }
  });
};
function ojtRow(r,ri){
  return `<tr class="ojt-row" data-ri="${ri}">
    <td>
      <div style="display:flex;align-items:center;gap:6px;">
        <input type="text" class="cell-text ojt-title" style="flex:1;" placeholder="Training description…" value="${esc(r.title || '')}">
        <button type="button" class="btn-del-row ojt-del-btn" title="Remove row" style="background:none;border:none;color:#dc2626;cursor:pointer;font-size:14px;padding:2px 4px;">✕</button>
      </div>
    </td>
    ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="ojt-month" data-mi="${mi}" ${r.months && r.months[mi]?'checked':''}></td>`).join('')}
  </tr>`;
}
COLLECTORS.training = () => {
  const ojt = [];
  document.querySelectorAll('#ojtTable tr.ojt-row').forEach(tr=>{
    const title = tr.querySelector('.ojt-title')?.value || '';
    const months = Array.from(tr.querySelectorAll('.ojt-month')).map(c=>c.checked);
    if (title.trim() || months.some(Boolean)) {
      ojt.push({ title, months });
    }
  });
  const fixed = {};
  const trainingList = getMasterTrainingsList();
  trainingList.forEach(k=>{ fixed[k] = Array(12).fill(false); });
  document.querySelectorAll('.tr-fixed').forEach(c=>{
    if (!fixed[c.dataset.key]) fixed[c.dataset.key] = Array(12).fill(false);
    fixed[c.dataset.key][+c.dataset.mi] = c.checked;
  });
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
  d = Object.assign({rows:{}, custom:[]}, d);
  if (!Array.isArray(d.custom)) d.custom = [];
  if (!d.custom.length) d.custom = [{title:'', months:Array(12).fill(false)}];
  const actList = getMasterActivitiesList();
  actList.forEach(k=>{ if(!d.rows[k]) d.rows[k] = Array(12).fill(false); });
  el.innerHTML = `
    <h2 class="section-title">Participation in Other Activities</h2>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:16px 0 8px;">Standard Plant Activities</h3>
    <div class="table-scroll"><table class="grid-table">
      ${monthHeaderRow('Particular')}
      ${actList.map(k=>`
        <tr><td class="rowlabel">${esc(k)}</td>
        ${MONTHS.map((m,mi)=>`<td><input type="checkbox" class="ac-cell" data-key="${esc(k)}" data-mi="${mi}" ${(d.rows[k] && d.rows[k][mi])?'checked':''}></td>`).join('')}
        </tr>`).join('')}
    </table></div>

    <h3 style="font-family:var(--font-mono);font-size:11px;letter-spacing:.06em;text-transform:uppercase;color:#6b6455;margin:24px 0 8px;">Custom / Additional Activities</h3>
    <p class="small-note" style="margin-bottom:8px;">Add your own additional activities, committee roles, or plant initiatives here.</p>
    <div class="table-scroll"><table class="grid-table" id="actCustomTable">
      ${monthHeaderRow('Custom Activity')}
      ${d.custom.map((r, ri) => actCustomRow(r, ri)).join('')}
    </table></div>
    <button type="button" class="addrow-btn" id="actAddCustomBtn">+ Add Custom Activity</button>
  `;

  document.getElementById('actAddCustomBtn')?.addEventListener('click', () => {
    const tbl = document.getElementById('actCustomTable');
    const ri = tbl.querySelectorAll('tr.act-custom-row').length;
    tbl.insertAdjacentHTML('beforeend', actCustomRow({title:'', months:Array(12).fill(false)}, ri));
  });

  document.getElementById('actCustomTable')?.addEventListener('click', (e) => {
    const delBtn = e.target.closest('.act-custom-del-btn');
    if (delBtn) {
      delBtn.closest('tr.act-custom-row')?.remove();
    }
  });
};

function actCustomRow(r, ri) {
  return `<tr class="act-custom-row" data-ri="${ri}">
    <td>
      <div style="display:flex;align-items:center;gap:6px;">
        <input type="text" class="cell-text act-custom-title" style="flex:1;" placeholder="Activity description…" value="${esc(r.title || '')}">
        <button type="button" class="btn-del-row act-custom-del-btn" title="Remove row" style="background:none;border:none;color:#dc2626;cursor:pointer;font-size:14px;padding:2px 4px;">✕</button>
      </div>
    </td>
    ${MONTHS.map((m, mi) => `<td><input type="checkbox" class="act-custom-month" data-mi="${mi}" ${r.months && r.months[mi] ? 'checked' : ''}></td>`).join('')}
  </tr>`;
}

COLLECTORS.activities = () => {
  const rows = {};
  const actList = getMasterActivitiesList();
  actList.forEach(k => { rows[k] = Array(12).fill(false); });
  document.querySelectorAll('.ac-cell').forEach(c => {
    if (!rows[c.dataset.key]) rows[c.dataset.key] = Array(12).fill(false);
    rows[c.dataset.key][+c.dataset.mi] = c.checked;
  });

  const custom = [];
  document.querySelectorAll('#actCustomTable tr.act-custom-row').forEach(tr => {
    const title = tr.querySelector('.act-custom-title')?.value || '';
    const months = Array.from(tr.querySelectorAll('.act-custom-month')).map(c => c.checked);
    if (title.trim() || months.some(Boolean)) {
      custom.push({ title, months });
    }
  });

  return { rows, custom };
};

/* ---------- 8. SWOT ANALYSIS ---------- */
RENDERERS.swot = (el, d) => {
  d = Object.assign({strength:'',weakness:'',opportunity:'',threats:''}, d);
  el.innerHTML = `
    <h2 class="section-title">SWOT Analysis</h2>
    <p class="small-note" style="margin-bottom:12px;color:var(--mahle-blue);font-weight:600;">Monthly Self-Evaluation Reflection for <strong>${esc(getGlobalCycleLabel())}</strong>. Resets every month to track fresh growth observations.</p>
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
  ['Performance on the Job', 20, 12],
  ['Attendance', 10, 6],
  ['Work Performance', 20, 12],
  ['Line Performance', 20, 12],
  ['Recognition', 10, 6],
  ['Documentation (Growth File)', 10, 6],
  ['AHPS / LEAN Participation', 10, 6],
];
RENDERERS.supervisor = (el, d) => {
  d = Object.assign({name:'',area:'',scores:{},signature:''}, d);
  SUP_CRITERIA.forEach(([k])=>{ if(!d.scores[k]) d.scores[k] = Array(12).fill(''); });
  
  const isSup = currentRole === 'supervisor' || (currentExactRole !== 'Employee' && currentExactRole !== 'Shop Floor Employee');
  const a = activeEmployeeInfo?.assessment;
  const currentScore = (a && a.tlScore !== null && a.tlScore !== undefined) ? a.tlScore : (a?.score !== null && a?.score !== undefined ? a.score : null);
  const ratingGrade = a?.ratingGrade || '';

  const supBanner = isSup ? `
    <div style="background:#eef2fa;border:1px solid #c9d5ec;border-radius:10px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;">
      <div>
        <div style="font-weight:700;font-size:14.5px;color:#1e2a63;">Official Monthly Assessment (Scale 1.0 to 10.0)</div>
        <div style="font-size:12.5px;color:var(--ink-dim);margin-top:2px;">
          ${currentScore !== null 
            ? `Current Score: <strong style="color:#1e2a63;font-size:14px;">${Number(currentScore).toFixed(1)} / 10</strong> · <span class="badge badge-evaluated">${esc(ratingGrade)}</span>`
            : 'Assessment Pending · Review performance and give official marks across criteria.'}
        </div>
      </div>
      <button type="button" class="btn btn-primary" id="btnSec10Eval">
        ${currentScore !== null ? 'Update Rating (1-10)' : 'Give Rating / Marks &amp; Submit'}
      </button>
    </div>
  ` : '';

  el.innerHTML = `
    <h2 class="section-title">Supervisor Remarks &amp; Assessment</h2>
    ${supBanner}
    <div class="grid-2">
      <div class="field-block"><label class="f">Name</label><input type="text" id="sr_name" value="${esc(d.name)}"></div>
      <div class="field-block"><label class="f">Area</label><input type="text" id="sr_area" value="${esc(d.area)}"></div>
    </div>
    <div style="margin: 12px 0; background:#f0f7ff; border:1px solid #cce3ff; border-radius:8px; padding:10px 14px; font-size:12.5px; color:#0c4a6e; display:flex; align-items:center; gap:8px;">
      <span style="font-size:16px;">ℹ️</span>
      <span><strong>Marking Scheme &amp; Minimum 60% Rule:</strong> A minimum of 60% marks must be awarded for each section (Performance &ge; 12/20, Attendance &ge; 6/10, etc.). Team Leaders are not allowed to score below 60%.</span>
    </div>
    <div class="table-scroll"><table class="grid-table" id="srTable">
      <tr><th>Criteria</th><th>Max Marks</th>${MONTHS.map(m=>`<th>${m}</th>`).join('')}</tr>
      ${SUP_CRITERIA.map(([k, max, min60])=>`
        <tr>
          <td class="rowlabel">
            <div style="font-weight:600;">${k}</div>
            <div style="font-size:10.5px;color:var(--ink-dim);font-weight:normal;">Min 60%: ${min60} marks</div>
          </td>
          <td style="text-align:center;font-weight:700;">${max}</td>
          ${MONTHS.map((m,mi)=>`<td><input type="number" min="${min60}" max="${max}" class="sr-cell" data-key="${k}" data-mi="${mi}" data-min="${min60}" data-max="${max}" value="${esc(d.scores[k][mi])}"></td>`).join('')}
        </tr>`).join('')}
      <tr class="total-row"><td class="rowlabel">Total (Min 60)</td><td style="text-align:center;font-weight:700;">100</td>
        ${MONTHS.map((m,mi)=>`<td id="sr-total-${mi}">0</td>`).join('')}
      </tr>
    </table></div>
    <div id="srTableNotice" style="display:none;margin-top:10px;background:#fef2f2;border:1px solid #fecaca;color:#b91c1c;padding:8px 12px;border-radius:6px;font-size:12.5px;font-weight:600;"></div>
    <div class="field-block" style="max-width:320px;margin-top:16px;">
      <label class="f">Supervisor Signature</label>
      <input type="text" id="sr_signature" value="${esc(d.signature)}">
    </div>
  `;
  const recalcTotals = ()=>{
    let hasUnder60 = false;
    let under60Msg = '';
    const noticeEl = document.getElementById('srTableNotice');

    document.querySelectorAll('.sr-cell').forEach(inp => {
      const raw = inp.value.trim();
      const min = parseFloat(inp.dataset.min) || 0;
      const max = parseFloat(inp.dataset.max) || 100;
      if (raw !== '') {
        const val = parseFloat(raw);
        if (isNaN(val) || val < min) {
          inp.style.borderColor = '#ef4444';
          inp.style.backgroundColor = '#fef2f2';
          hasUnder60 = true;
          if (!under60Msg) under60Msg = `Minimum 60% required: "${inp.dataset.key}" cannot be less than ${min} / ${max} marks.`;
        } else if (val > max) {
          inp.style.borderColor = '#ef4444';
          inp.style.backgroundColor = '#fef2f2';
          hasUnder60 = true;
          if (!under60Msg) under60Msg = `"${inp.dataset.key}" cannot exceed ${max} marks.`;
        } else {
          inp.style.borderColor = '';
          inp.style.backgroundColor = '';
        }
      } else {
        inp.style.borderColor = '';
        inp.style.backgroundColor = '';
      }
    });

    for(let mi=0; mi<12; mi++){
      let sum = 0;
      document.querySelectorAll(`.sr-cell[data-mi="${mi}"]`).forEach(inp=>{ sum += parseFloat(inp.value)||0; });
      const totEl = document.getElementById(`sr-total-${mi}`);
      if (totEl) {
        totEl.textContent = sum;
        if (sum > 0 && sum < 60) {
          totEl.style.color = '#dc2626';
          totEl.style.fontWeight = '800';
        } else {
          totEl.style.color = '';
          totEl.style.fontWeight = '';
        }
      }
    }

    if (noticeEl) {
      if (hasUnder60 && isSup) {
        noticeEl.textContent = under60Msg;
        noticeEl.style.display = 'block';
      } else {
        noticeEl.style.display = 'none';
      }
    }
  };
  document.querySelectorAll('.sr-cell').forEach(inp=> inp.addEventListener('input', recalcTotals));
  recalcTotals();

  document.getElementById('btnSec10Eval')?.addEventListener('click', () => {
    if (!viewingEmpId) return;
    const ass = activeEmployeeInfo?.assessment || {};
    openEvalModal(
      viewingEmpId,
      activeEmployeeInfo?.name || viewingEmpId,
      ass.tlScore || ass.score || 8.5,
      ass.ratingGrade || '',
      ass.tlComments || '',
      ass.criteriaScores || null
    );
  });
};
COLLECTORS.supervisor = () => {
  const scores = {};
  SUP_CRITERIA.forEach(([k])=>{ scores[k] = Array(12).fill(''); });
  let hasUnder60 = false;
  let under60Error = '';

  document.querySelectorAll('.sr-cell').forEach(inp=>{
    const raw = inp.value.trim();
    scores[inp.dataset.key][+inp.dataset.mi] = raw;
    if (raw !== '') {
      const val = parseFloat(raw);
      const min = parseFloat(inp.dataset.min) || 0;
      const max = parseFloat(inp.dataset.max) || 100;
      if (isNaN(val) || val < min) {
        hasUnder60 = true;
        if (!under60Error) under60Error = `Minimum 60% required: "${inp.dataset.key}" cannot be scored less than ${min} / ${max} marks.`;
      } else if (val > max) {
        hasUnder60 = true;
        if (!under60Error) under60Error = `"${inp.dataset.key}" cannot exceed ${max} marks.`;
      }
    }
  });

  if (hasUnder60) {
    showToast(under60Error);
    throw new Error(under60Error);
  }

  return { name: val('sr_name'), area: val('sr_area'), scores, signature: val('sr_signature') };
};

/* ============================= UTIL ============================= */
function val(id){ const e = document.getElementById(id); return e ? e.value : ''; }
function esc(s){
  if(s===undefined || s===null) return '';
  return String(s).replace(/&/g,'&amp;').replace(/"/g,'&quot;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// Initial cycle picker population
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', populateAllMonthYearPickers);
} else {
  populateAllMonthYearPickers();
}

