
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

let currentRole = null;      // 'employee' | 'supervisor' (legacy)
let currentExactRole = null; // 'Super Admin' | 'HR Head' | 'Unit Admin' | 'Senior Group Leader (SGL)' | 'Team Leader (TL)' | 'Shop Floor Employee'
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

async function loadSheetData(empId, sheetId) {
  try {
    const isSup = currentRole === 'supervisor' || currentExactRole !== 'Shop Floor Employee';
    const path = (isSup && sheetId !== 'supervisor')
      ? `/api/employee/${empId}/sheet/${sheetId}`
      : (isSup ? `/api/employee/${empId}/sheet/supervisor` : `/api/sheet/${sheetId}`);
    const { data } = await api(path);
    return data;
  } catch (e) { return null; }
}
async function saveSheetData(empId, sheetId, data) {
  try {
    const isSup = currentRole === 'supervisor' || currentExactRole !== 'Shop Floor Employee';
    const path = isSup
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
  directory: document.getElementById('screen-directory'),
  lookup: document.getElementById('screen-lookup'),
  changepw: document.getElementById('screen-changepw'),
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
      viewingEmpId = (s.exactRole === 'Shop Floor Employee') ? s.id : null;
      if (viewingEmpId) {
        await updateActiveEmployeeInfo(viewingEmpId, s.name, s.unitName);
      }
      setTopbarWho(s.role, s.id, s.name, s.unitName, s.exactRole);
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
      document.getElementById('loginHeading').textContent = 'Shop Floor Sign In';
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
    viewingEmpId = (result.exactRole === 'Shop Floor Employee') ? result.id : null;
    if (viewingEmpId) {
      await updateActiveEmployeeInfo(viewingEmpId, result.name, result.unitName);
    }
    setTopbarWho(result.role, result.id, result.name, result.unitName, result.exactRole);
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
      role: u.role || 'Shop Floor Employee',
      departmentName: u.departmentName || '',
    };
  } catch (e) {
    activeEmployeeInfo = {
      empCode: empId,
      name: optName || empId,
      unitName: optUnit || currentUnitName || 'Unit',
      role: 'Shop Floor Employee',
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

async function selectEmployee(empId, optName, optUnit) {
  viewingEmpId = empId;
  await updateActiveEmployeeInfo(empId, optName, optUnit);
  renderSidebar();
  updateEmployeeNavBar();
  await openSheet('frontpage');
}

function deselectEmployee() {
  const isEmp = currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);
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
  const isSup = currentRole === 'supervisor' || currentExactRole !== 'Shop Floor Employee';

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
    select.innerHTML = SHEETS.map(s => `
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
  await renderMenu();
  showScreen('menu');
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

  const isEmp = currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);
  const isHomeActive = !screens.home.classList.contains('hidden');
  const isInboxActive = !screens.inbox.classList.contains('hidden');
  const isMenuActive = !screens.menu.classList.contains('hidden');

  let html = `<button class="sb-link-top ${isHomeActive ? 'active' : ''}" data-action="home">Dashboard</button>`;

  if (!isEmp) {
    const exact = (currentExactRole || '').toLowerCase();
    const isAdmin = exact.includes('admin') || exact.includes('hr');
    const isSupervisorOrLeader = currentRole === 'supervisor' || exact.includes('leader') || exact.includes('tl') || exact.includes('sgl') || isAdmin;

    html += `<div class="sb-section-label">Management Console</div>
      <button class="sb-link ${isInboxActive ? 'active' : ''}" data-action="inbox"><span class="sb-link-num">01</span>Submissions Inbox</button>
      <button class="sb-link" data-action="directory"><span class="sb-link-num">02</span>Workforce Directory</button>
      <button class="sb-link" data-action="lookup"><span class="sb-link-num">03</span>Look Up Employee</button>`;

    if (isAdmin) {
      html += `
        <button class="sb-link" data-action="add-user"><span class="sb-link-num">04</span>Add User</button>
        <button class="sb-link" data-action="cycles"><span class="sb-link-num">05</span>Assessment Cycles</button>
        <button class="sb-link" data-action="export-csv"><span class="sb-link-num">06</span>Export Report</button>`;
    } else if (isSupervisorOrLeader) {
      html += `
        <button class="sb-link" data-action="cycles"><span class="sb-link-num">04</span>Assessment Cycles</button>
        <button class="sb-link" data-action="export-csv"><span class="sb-link-num">05</span>Export Report</button>`;
    }

    const nextNum = isAdmin ? '07' : (isSupervisorOrLeader ? '06' : '04');
    html += `<button class="sb-link" data-action="changepw"><span class="sb-link-num">${nextNum}</span>Security &amp; Passwords</button>`;

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
    // Shop Floor Employee view
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
    viewingEmpId = currentEmpId;
    await updateActiveEmployeeInfo(currentEmpId);
    await renderMenu();
    showScreen('menu');
  });

  // Selected employee widget listeners
  sidebar.querySelector('#sbCloseBtn')?.addEventListener('click', deselectEmployee);
  sidebar.querySelector('#sbSheetSelect')?.addEventListener('change', (e) => {
    if (e.target.value) openSheet(e.target.value);
  });
  sidebar.querySelector('#sbGridBtn')?.addEventListener('click', async () => {
    await renderMenu();
    showScreen('menu');
  });

  // Employee sheet list links (for shop floor employee)
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
  const isEmp = currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);

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
    if (heroRole) heroRole.textContent = currentExactRole || 'Shop Floor Employee';
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
    await renderAdminDashboard(selectedUnitFilter || 'all');
  } else if (currentExactRole === 'Unit Admin') {
    document.getElementById('homeLead').textContent = `Managing operations and assessment coverage for ${currentUnitName || 'Unit'}.`;
    const uaUnitHeader = document.getElementById('uaUnitHeader');
    if (uaUnitHeader) uaUnitHeader.textContent = `${currentUnitName || 'Unit'} Directory & Assessment Status`;
    if (unitAdminView) unitAdminView.classList.remove('hidden');
    await renderUnitAdminView();
  } else if (currentExactRole === 'Team Leader (TL)') {
    document.getElementById('homeLead').textContent = `Assigned unit: ${currentUnitName || 'Unit'}. Review and evaluate shop floor employees under your leadership (1 - 10 scale).`;
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
async function renderEmployeeScorecard() {
  const card = document.getElementById('employeeScorecard');
  if (!card) return;
  card.innerHTML = '<div style="color:var(--ink-dim);font-size:13px;padding:16px;background:#fff;border-radius:12px;border:1px solid var(--panel-line);">Loading monthly assessment scorecard…</div>';
  card.classList.remove('hidden');

  try {
    const res = await api('/api/employee/assessment');
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
              <div class="emp-sc-title">Monthly Assessment Scorecard · October 2026</div>
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
            <div class="emp-sc-title">October 2026 Passport Assessment Status</div>
            <div class="emp-sc-sub">${isSubmitted ? 'Monthly submission received · Awaiting Team Leader evaluation' : 'Active monthly assessment cycle in progress'}</div>
          </div>
          <span class="badge ${isSubmitted ? 'badge-submitted' : 'badge-pending'}">${isSubmitted ? 'Submitted to Supervisor' : 'Draft in Progress'}</span>
        </div>

        <div class="emp-pending-steps">
          <div class="emp-step-item">
            <div class="emp-step-num">1</div>
            <div>
              <div class="emp-step-title">Passport Sheets</div>
              <div class="emp-step-desc">10 sections updated with monthly data</div>
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
async function renderAdminDashboard(unit = 'all') {
  try {
    const data = await api(`/api/admin/analytics?unit=${encodeURIComponent(unit)}`);
    const k = data.kpi || data.kpis || {};
    document.getElementById('kpiTotalEmp').textContent = k.totalEmployees || 0;
    document.getElementById('kpiSubmitted').textContent = k.submittedCount !== undefined ? k.submittedCount : (k.submittedAssessments || 0);
    document.getElementById('kpiSubRate').textContent = `${k.submissionRate || 0}% Submission`;
    document.getElementById('kpiEvaluated').textContent = k.evaluatedCount !== undefined ? k.evaluatedCount : (k.evaluatedAssessments || 0);
    document.getElementById('kpiEvalRate').textContent = `${k.evaluationRate || 0}% Completed`;
    const avgScoreVal = k.averageScore !== undefined && k.averageScore !== null ? k.averageScore : (k.avgScore || 0);
    document.getElementById('kpiAvgScore').textContent = avgScoreVal > 0 ? Number(avgScoreVal).toFixed(1) : '—';

    const tbody = document.getElementById('unitMatrixBody');
    tbody.innerHTML = '';
    (data.units || []).forEach(u => {
      const tr = document.createElement('tr');
      const subCount = u.submittedCount !== undefined ? u.submittedCount : (u.submitted || 0);
      const evalCount = u.evaluatedCount !== undefined ? u.evaluatedCount : (u.evaluated || 0);
      const avg = u.avgScore > 0 ? Number(u.avgScore).toFixed(1) + ' / 10' : '—';
      tr.innerHTML = `
        <td style="font-weight:600;">${esc(u.unitName)}</td>
        <td><span class="who-unit">${esc(u.unitCode || u.code || '—')}</span></td>
        <td>${u.totalEmployees}</td>
        <td>${subCount} (${u.totalEmployees > 0 ? Math.round(subCount/u.totalEmployees*100) : 0}%)</td>
        <td>${evalCount}</td>
        <td style="font-weight:700;color:var(--shell-2);">${avg}</td>
      `;
      tbody.appendChild(tr);
    });
  } catch (e) {
    console.error('Error rendering admin analytics:', e);
  }
}

// Unit filter pill listeners
document.querySelectorAll('#unitFilterBar .unit-pill').forEach(btn => {
  btn.addEventListener('click', async () => {
    document.querySelectorAll('#unitFilterBar .unit-pill').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    selectedUnitFilter = btn.dataset.unit;
    await renderAdminDashboard(selectedUnitFilter);
  });
});

/* ============================= UNIT ADMIN VIEW ============================= */
async function renderUnitAdminView() {
  try {
    const { employees } = await api('/api/unit-admin/employees');
    const tbody = document.getElementById('unitAdminEmpBody');
    tbody.innerHTML = '';
    if (!employees || !employees.length) {
      tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;color:var(--ink-dim);">No employees found in this unit.</td></tr>';
      return;
    }

    // Unit Admin KPI Stats
    const total = employees.length;
    const submitted = employees.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
    const evaluated = employees.filter(e => (e.tlScore !== null && e.tlScore !== undefined) || (e.score !== null && e.score !== undefined)).length;
    const scores = employees
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

    employees.forEach(emp => {
      const tr = document.createElement('tr');
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = !!scoreVal;
      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;">${esc(emp.empCode)}</td>
        <td style="font-weight:600;">${esc(emp.name)}</td>
        <td>${esc(emp.roleName || emp.role)}</td>
        <td>${esc(emp.tlName || 'Unassigned')}</td>
        <td><span class="badge ${isEval ? 'badge-evaluated' : 'badge-pending'}">${isEval ? 'Evaluated' : 'Pending'}</span></td>
        <td style="font-weight:700;">${isEval ? Number(scoreVal).toFixed(1) + ' / 10' : '—'}</td>
        <td><button class="btn btn-sm btn-ghost btn-ua-view" data-emp="${emp.empCode}" data-name="${esc(emp.name)}">View Record</button></td>
      `;
      tbody.appendChild(tr);
    });
    tbody.querySelectorAll('.btn-ua-view').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name);
      });
    });
  } catch (e) {
    console.error('Error rendering unit admin:', e);
  }
}

/* ============================= TL VIEW & EVALUATION ============================= */
async function renderTLView() {
  try {
    const { employees } = await api('/api/tl/assigned');
    const tbody = document.getElementById('tlAssignedBody');
    tbody.innerHTML = '';
    if (!employees || !employees.length) {
      tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--ink-dim);">No shop floor employees assigned to your team.</td></tr>';
      return;
    }

    // Team Leader KPI Stats
    const total = employees.length;
    const submitted = employees.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
    const evaluated = employees.filter(e => e.tlScore !== null && e.tlScore !== undefined).length;
    const scores = employees
      .map(e => e.tlScore)
      .filter(s => s !== null && s !== undefined && !isNaN(s));
    const avgScore = scores.length > 0 ? (scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1) : '—';

    const tlKpiTotal = document.getElementById('tlKpiTotal');
    if (tlKpiTotal) tlKpiTotal.textContent = total;
    const tlKpiSub = document.getElementById('tlKpiSubmitted');
    if (tlKpiSub) tlKpiSub.textContent = submitted;
    const tlKpiSubRate = document.getElementById('tlKpiSubRate');
    if (tlKpiSubRate) tlKpiSubRate.textContent = total > 0 ? `${Math.round(submitted / total * 100)}% Submission` : '0% Submission';
    const tlKpiEval = document.getElementById('tlKpiEvaluated');
    if (tlKpiEval) tlKpiEval.textContent = evaluated;
    const tlKpiEvalRate = document.getElementById('tlKpiEvalRate');
    if (tlKpiEvalRate) tlKpiEvalRate.textContent = total > 0 ? `${Math.round(evaluated / total * 100)}% Completed` : '0% Completed';
    const tlKpiAvg = document.getElementById('tlKpiAvgScore');
    if (tlKpiAvg) tlKpiAvg.textContent = avgScore;

    employees.forEach(emp => {
      const tr = document.createElement('tr');
      const hasSub = emp.submissionStatus === 'evaluated' || emp.submissionStatus === 'Submitted';
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = !!scoreVal;
      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;">${esc(emp.empCode)}</td>
        <td style="font-weight:600;">${esc(emp.name)}</td>
        <td>${esc(emp.unitName || '—')}</td>
        <td><span class="badge ${hasSub ? 'badge-evaluated' : 'badge-pending'}">${hasSub ? 'Submitted' : 'Pending'}</span></td>
        <td style="font-weight:700;">${isEval ? Number(scoreVal).toFixed(1) + ' / 10' : '<span style="color:var(--ink-dim);">Not evaluated</span>'}</td>
        <td>
          <button class="btn btn-sm btn-primary btn-tl-eval" data-emp="${emp.empCode}" data-name="${esc(emp.name)}" data-score="${scoreVal || 8.5}" data-grade="${esc(emp.ratingGrade || '')}" data-comments="${esc(emp.tlComments || '')}">Evaluate (1-10)</button>
          <button class="btn btn-sm btn-ghost btn-tl-view" data-emp="${emp.empCode}" data-name="${esc(emp.name)}" style="margin-left:6px;">View Sheets</button>
        </td>
      `;
      tbody.appendChild(tr);
    });

    tbody.querySelectorAll('.btn-tl-view').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name);
      });
    });

    tbody.querySelectorAll('.btn-tl-eval').forEach(btn => {
      btn.addEventListener('click', () => {
        openEvalModal(btn.dataset.emp, btn.dataset.name, btn.dataset.score, btn.dataset.grade, btn.dataset.comments);
      });
    });
  } catch (e) {
    console.error('Error rendering TL view:', e);
  }
}

function openEvalModal(empCode, name, score, grade, comments) {
  currentEvalEmpId = empCode;
  currentEvalEmpName = name;
  document.getElementById('evalModalTitle').textContent = `Evaluate: ${name} (${empCode})`;
  const scoreInput = document.getElementById('evalOverallScore');
  scoreInput.value = score ? Number(score).toFixed(1) : '8.5';
  document.getElementById('evalComments').value = comments || '';
  updateEvalModalGrade();
  document.getElementById('evalModal').classList.remove('hidden');
}

function updateEvalModalGrade() {
  const score = parseFloat(document.getElementById('evalOverallScore').value) || 0;
  const badge = document.getElementById('evalGradeBadge');
  if (score >= 9.0) {
    badge.textContent = 'Grade A+ (Exceptional)';
    badge.className = 'badge badge-evaluated';
  } else if (score >= 8.0) {
    badge.textContent = 'Grade A (Outstanding)';
    badge.className = 'badge badge-evaluated';
  } else if (score >= 7.0) {
    badge.textContent = 'Grade B+ (Good)';
    badge.className = 'badge badge-evaluated';
  } else if (score >= 6.0) {
    badge.textContent = 'Grade B (Satisfactory)';
    badge.className = 'badge badge-pending';
  } else {
    badge.textContent = 'Grade C (Needs Improvement)';
    badge.className = 'badge badge-pending';
  }
}

['cSafety','cQuality','cProd','cAttend','cKaizen'].forEach(id => {
  const el = document.getElementById(id);
  if (el) {
    el.addEventListener('input', () => {
      const s = (
        parseFloat(document.getElementById('cSafety').value || 0) +
        parseFloat(document.getElementById('cQuality').value || 0) +
        parseFloat(document.getElementById('cProd').value || 0) +
        parseFloat(document.getElementById('cAttend').value || 0) +
        parseFloat(document.getElementById('cKaizen').value || 0)
      ) / 5;
      document.getElementById('evalOverallScore').value = s.toFixed(1);
      updateEvalModalGrade();
    });
  }
});
document.getElementById('evalOverallScore').addEventListener('input', updateEvalModalGrade);
document.getElementById('evalCancelBtn').addEventListener('click', () => {
  document.getElementById('evalModal').classList.add('hidden');
});
document.getElementById('evalSubmitBtn').addEventListener('click', async () => {
  if (!currentEvalEmpId) return;
  const scoreVal = parseFloat(document.getElementById('evalOverallScore').value);
  if (isNaN(scoreVal) || scoreVal < 1 || scoreVal > 10) {
    alert('Please enter a valid evaluation score between 1.0 and 10.0');
    return;
  }
  const payload = {
    employeeId: currentEvalEmpId,
    cycleId: 1,
    score: scoreVal,
    ratingGrade: document.getElementById('evalGradeBadge').textContent,
    criteriaScores: {
      safety: parseFloat(document.getElementById('cSafety').value) || 8.5,
      quality: parseFloat(document.getElementById('cQuality').value) || 8.5,
      productivity: parseFloat(document.getElementById('cProd').value) || 8.5,
      attendance: parseFloat(document.getElementById('cAttend').value) || 9.0,
      kaizen: parseFloat(document.getElementById('cKaizen').value) || 8.0,
    },
    comments: document.getElementById('evalComments').value.trim(),
  };
  try {
    const res = await api('/api/tl/evaluate', { method: 'POST', body: payload });
    showToast(`Assessment submitted: ${res.score}/10`);
    document.getElementById('evalModal').classList.add('hidden');
    if (viewingEmpId === currentEvalEmpId) {
      await updateActiveEmployeeInfo(viewingEmpId);
      updateEmployeeNavBar();
    }
    await renderTLView();
  } catch (err) {
    alert(err.message || 'Failed to submit evaluation.');
  }
});

/* ============================= SGL VIEW ============================= */
async function renderSGLView() {
  try {
    const res = await api('/api/sgl/teams');
    const list = res.team || res.employees || [];
    const tbody = document.getElementById('sglTeamBody');
    tbody.innerHTML = '';
    if (!list.length) {
      tbody.innerHTML = '<tr><td colspan="6" style="text-align:center;color:var(--ink-dim);">No group members found.</td></tr>';
      return;
    }

    // SGL KPI Stats
    const total = list.length;
    const submitted = list.filter(e => e.submissionStatus === 'evaluated' || e.submissionStatus === 'submitted' || e.submissionStatus === 'Submitted').length;
    const evaluated = list.filter(e => e.tlScore !== null && e.tlScore !== undefined).length;
    const scores = list
      .map(e => e.tlScore)
      .filter(s => s !== null && s !== undefined && !isNaN(s));
    const avgScore = scores.length > 0 ? (scores.reduce((a, b) => a + Number(b), 0) / scores.length).toFixed(1) : '—';

    const sglKpiTotal = document.getElementById('sglKpiTotal');
    if (sglKpiTotal) sglKpiTotal.textContent = total;
    const sglKpiSub = document.getElementById('sglKpiSubmitted');
    if (sglKpiSub) sglKpiSub.textContent = submitted;
    const sglKpiSubRate = document.getElementById('sglKpiSubRate');
    if (sglKpiSubRate) sglKpiSubRate.textContent = total > 0 ? `${Math.round(submitted / total * 100)}% Submission` : '0% Submission';
    const sglKpiEval = document.getElementById('sglKpiEvaluated');
    if (sglKpiEval) sglKpiEval.textContent = evaluated;
    const sglKpiEvalRate = document.getElementById('sglKpiEvalRate');
    if (sglKpiEvalRate) sglKpiEvalRate.textContent = total > 0 ? `${Math.round(evaluated / total * 100)}% Completed` : '0% Completed';
    const sglKpiAvg = document.getElementById('sglKpiAvgScore');
    if (sglKpiAvg) sglKpiAvg.textContent = avgScore;

    list.forEach(emp => {
      const tr = document.createElement('tr');
      const scoreVal = (emp.tlScore !== null && emp.tlScore !== undefined) ? emp.tlScore : emp.score;
      const isEval = !!scoreVal;
      tr.innerHTML = `
        <td style="font-family:var(--font-mono);font-weight:700;">${esc(emp.empCode)}</td>
        <td style="font-weight:600;">${esc(emp.name)}</td>
        <td>${esc(emp.tlName || 'Unassigned')}</td>
        <td><span class="badge ${isEval ? 'badge-evaluated' : 'badge-pending'}">${isEval ? 'Evaluated' : 'Pending'}</span></td>
        <td style="font-weight:700;">${isEval ? Number(scoreVal).toFixed(1) + ' / 10' : '—'}</td>
        <td><button class="btn btn-sm btn-ghost btn-sgl-view" data-emp="${emp.empCode}" data-name="${esc(emp.name)}">Audit Record</button></td>
      `;
      tbody.appendChild(tr);
    });
    tbody.querySelectorAll('.btn-sgl-view').forEach(btn => {
      btn.addEventListener('click', async () => {
        await selectEmployee(btn.dataset.emp, btn.dataset.name);
      });
    });
  } catch (e) {
    console.error('Error rendering SGL view:', e);
  }
}

document.getElementById('goGrowthBtn').addEventListener('click', async () => {
  viewingEmpId = currentEmpId;
  await updateActiveEmployeeInfo(currentEmpId);
  renderSidebar();
  updateEmployeeNavBar();
  await renderMenu();
  showScreen('menu');
});
document.getElementById('backHomeBtn').addEventListener('click', () => {
  renderHome();
  showScreen('home');
});
document.getElementById('backMenuBtn').addEventListener('click', () => {
  renderMenu();
  showScreen('menu');
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

async function renderInbox() {
  const list = document.getElementById('inboxList');
  if (!list) return;
  list.innerHTML = '<p class="empty-note">Loading submissions…</p>';

  let submissions = [];
  try {
    const res = await api('/api/inbox');
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
        <p style="font-size:13px;color:var(--ink-dim);margin:6px 0 0;">Submissions will appear here once shop floor operators submit their monthly growth passports.</p>
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
            <span><strong>${esc(sub.month || 'October 2026')}</strong></span>
            <span>· Submitted ${esc(when)}</span>
          </div>
        </div>
      </div>
      <div class="inbox-card-right">
        ${isEval 
          ? `<span class="badge badge-evaluated">Evaluated ${scoreVal ? Number(scoreVal).toFixed(1) + '/10' : ''}</span>`
          : `<span class="badge badge-submitted">Awaiting Evaluation</span>`}
        
        <button class="btn btn-sm btn-primary btn-inbox-eval" data-emp="${esc(sub.empId)}" data-name="${esc(sub.name || sub.empId)}" data-score="${scoreVal || 8.5}" data-grade="${esc(sub.ratingGrade || '')}" data-comments="${esc(sub.tlComments || '')}">
          ${isEval ? 'Update Score' : 'Evaluate (1-10)'}
        </button>
        <button class="btn btn-sm btn-ghost btn-inbox-open" data-emp="${esc(sub.empId)}" data-name="${esc(sub.name || sub.empId)}" data-unit="${esc(sub.unitName || '')}">
          Open Passport
        </button>
      </div>`;

    card.querySelector('.btn-inbox-open')?.addEventListener('click', async () => {
      await selectEmployee(sub.empId, sub.name, sub.unitName);
    });

    card.querySelector('.btn-inbox-eval')?.addEventListener('click', () => {
      openEvalModal(sub.empId, sub.name || sub.empId, sub.tlScore || sub.selfScore || 8.5, sub.ratingGrade || '', sub.tlComments || '');
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

async function renderDirectory() {
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
    await renderTLView();
  } else if (currentExactRole === 'Unit Admin') {
    if (pageTitle) pageTitle.textContent = `${currentUnitName || 'Unit'} Staff Directory`;
    if (pageLead) pageLead.textContent = `Comprehensive workforce roster and TL/SGL assessment tracking for ${currentUnitName || 'Unit'}.`;
    const uaTitle = document.getElementById('uaTableTitle');
    if (uaTitle) uaTitle.textContent = `${currentUnitName || 'Unit'} Personnel & Assessment Status`;
    if (dirUAView) dirUAView.classList.remove('hidden');
    await renderUnitAdminView();
  } else if (currentExactRole === 'Senior Group Leader (SGL)') {
    if (pageTitle) pageTitle.textContent = 'Group Staff & Audit Directory';
    if (pageLead) pageLead.textContent = `Shop floor group overview and Team Leader score verification in ${currentUnitName || 'Unit'}.`;
    if (dirSGLView) dirSGLView.classList.remove('hidden');
    await renderSGLView();
  } else {
    // Super Admin / HR Head
    if (pageTitle) pageTitle.textContent = 'Cross-Plant Workforce Directory';
    if (pageLead) pageLead.textContent = 'Enterprise-wide personnel directory and assessment tracking across all 4 state units.';
    if (dirAdminView) dirAdminView.classList.remove('hidden');
    await renderAdminStaffView();
  }

  applyDirectoryFilters();
}

let adminUsersCache = [];
let adminMetadataCache = null;

async function loadAdminMetadata() {
  if (adminMetadataCache) return adminMetadataCache;
  try {
    const res = await api('/api/admin/metadata');
    adminMetadataCache = res.metadata || {};

    // Populate Plant / Unit dropdown
    const unitSelect = document.getElementById('userMgmtUnit');
    if (unitSelect && adminMetadataCache.units) {
      unitSelect.innerHTML = '<option value="">Select Plant / Unit...</option>' +
        adminMetadataCache.units.map(u => `<option value="${u.id}">${esc(u.name)} (${esc(u.code || u.state)})</option>`).join('');
    }

    // Populate TL dropdown
    const tlSelect = document.getElementById('userMgmtTL');
    if (tlSelect && adminMetadataCache.teamLeaders) {
      tlSelect.innerHTML = '<option value="">None / Not Applicable</option>' +
        adminMetadataCache.teamLeaders.map(tl => `<option value="${tl.id}">${esc(tl.name)} (${esc(tl.empCode)})</option>`).join('');
    }

    // Populate SGL dropdown
    const sglSelect = document.getElementById('userMgmtSGL');
    if (sglSelect && adminMetadataCache.seniorGroupLeaders) {
      sglSelect.innerHTML = '<option value="">None / Not Applicable</option>' +
        adminMetadataCache.seniorGroupLeaders.map(sgl => `<option value="${sgl.id}">${esc(sgl.name)} (${esc(sgl.empCode)})</option>`).join('');
    }

    return adminMetadataCache;
  } catch (err) {
    console.error('Failed to load admin metadata:', err);
    return null;
  }
}

async function renderAdminStaffView() {
  try {
    const res = await api('/api/admin/users?unit=all');
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
    roleSelect.value = userToEdit.exactRole || userToEdit.roleName || userToEdit.role || 'Shop Floor Employee';
    unitSelect.value = userToEdit.unitId || '';
    deptInput.value = userToEdit.department || 'Operations';
    tlSelect.value = userToEdit.teamLeaderId || '';
    sglSelect.value = userToEdit.seniorGroupLeaderId || '';
    pwInput.value = '';
    pwNote.textContent = 'Leave blank to preserve existing password.';
    activeCheckbox.checked = userToEdit.isActive !== false && userToEdit.isActive !== 0;
    activeLabel.textContent = activeCheckbox.checked ? 'Active & Permitted' : 'Deactivated / Login Blocked';
  } else {
    title.textContent = 'Create New User Account';
    sub.textContent = 'Add employee, supervisor, or administrator credentials and unit assignment.';
    empCodeInput.value = '';
    empCodeInput.disabled = false;
    nameInput.value = '';
    roleSelect.value = 'Shop Floor Employee';
    unitSelect.value = '1';
    deptInput.value = 'Operations';
    tlSelect.value = '';
    sglSelect.value = '';
    pwInput.value = '';
    pwNote.textContent = 'Default passcode if left blank: Mahle@123';
    activeCheckbox.checked = true;
    activeLabel.textContent = 'Active & Permitted';
  }

  modal.classList.remove('hidden');
}

async function saveUserAccount() {
  const errEl = document.getElementById('userMgmtError');
  const empCode = (document.getElementById('userMgmtEmpCode')?.value || '').trim().toUpperCase();
  const name = (document.getElementById('userMgmtName')?.value || '').trim();
  const role = document.getElementById('userMgmtRole')?.value || 'Shop Floor Employee';
  const unitId = parseInt(document.getElementById('userMgmtUnit')?.value || '0');
  const department = (document.getElementById('userMgmtDept')?.value || '').trim() || 'Operations';
  const teamLeaderId = document.getElementById('userMgmtTL')?.value ? parseInt(document.getElementById('userMgmtTL').value) : null;
  const seniorGroupLeaderId = document.getElementById('userMgmtSGL')?.value ? parseInt(document.getElementById('userMgmtSGL').value) : null;
  const password = (document.getElementById('userMgmtPassword')?.value || '').trim();
  const isActive = document.getElementById('userMgmtIsActive')?.checked ?? true;

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
  if (!unitId) {
    errEl.textContent = 'Please select a Plant / State Unit.';
    errEl.classList.remove('hidden');
    return;
  }

  const payload = {
    empCode,
    name,
    role,
    unitId,
    department,
    teamLeaderId,
    seniorGroupLeaderId,
    isActive,
  };
  if (password) payload.password = password;

  try {
    const res = await api('/api/admin/users', { method: 'POST', body: payload });
    showToast(res.message || 'User saved successfully');
    document.getElementById('userMgmtModal')?.classList.add('hidden');
    // Refresh admin cache and table
    adminMetadataCache = null; // Invalidate metadata cache in case a new TL/SGL was added
    await renderAdminStaffView();
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
document.getElementById('userMgmtIsActive')?.addEventListener('change', (e) => {
  const lbl = document.getElementById('userMgmtActiveLabel');
  if (lbl) lbl.textContent = e.target.checked ? 'Active & Permitted' : 'Deactivated / Login Blocked';
});

// CSV Export buttons
function triggerCsvExport() {
  showToast('Generating consolidated evaluation report…');
  window.location.href = `/api/admin/export-csv?unit=all&month=2026-10`;
}
document.getElementById('btnAdminExportCsv')?.addEventListener('click', triggerCsvExport);
document.getElementById('btnDirExportCsv')?.addEventListener('click', triggerCsvExport);

// Assessment Cycle Modal event listeners
document.getElementById('btnAdminCycles')?.addEventListener('click', openCycleMgmtModal);
document.getElementById('cycleMgmtCloseX')?.addEventListener('click', () => document.getElementById('cycleMgmtModal')?.classList.add('hidden'));
document.getElementById('cycleCloseBtn')?.addEventListener('click', () => document.getElementById('cycleMgmtModal')?.classList.add('hidden'));
document.getElementById('btnSaveCycle')?.addEventListener('click', saveAssessmentCycle);


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
    const role = u.role || 'Shop Floor Employee';
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
  if (whoRole) whoRole.textContent = currentExactRole || (currentRole === 'supervisor' ? 'Manager / Admin' : 'Shop Floor Employee');
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

async function renderMenu() {
  if (viewingEmpId && (!activeEmployeeInfo || activeEmployeeInfo.empCode !== viewingEmpId)) {
    await updateActiveEmployeeInfo(viewingEmpId);
  }
  updateEmployeeNavBar();
  rebuildDropdown();
  const isSup = currentRole === 'supervisor' || currentExactRole !== 'Shop Floor Employee';
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
    if (rhSub) rhSub.textContent = `Employee ID: ${viewingEmpId} · Sections 1–9 are read-only`;
  } else {
    recordHeader?.classList.add('hidden');
    submitBox?.classList.remove('hidden');
    const menuEyebrow = document.getElementById('menuEyebrow');
    if (menuEyebrow) menuEyebrow.textContent = 'Growth Performance';
    const monthLabel = document.getElementById('submitMonthLabel');
    if (monthLabel) monthLabel.textContent = currentMonthLabel();
    const statusEl = document.getElementById('submitStatus');
    try {
      const { submitted, submittedAt } = await api(`/api/my-submission?month=${encodeURIComponent(currentMonthLabel())}`);
      if (statusEl) {
        if (submitted) {
          statusEl.textContent = `Submitted for ${currentMonthLabel()} on ${new Date(submittedAt).toLocaleString()}`;
          statusEl.classList.add('done');
        } else {
          statusEl.textContent = `Not submitted yet for ${currentMonthLabel()}`;
          statusEl.classList.remove('done');
        }
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
      ${viewOnlyTag ? '<div class="locked-tag" title="View only">View Only</div>' : ''}`;
    btn.addEventListener('click', () => openSheet(s.id));
    grid.appendChild(btn);
  }
  for (const s of SHEETS) {
    const data = await loadSheetData(viewingEmpId, s.id);
    const el = grid.querySelector(`[data-status="${s.id}"]`);
    if (el) {
      const viewOnlyTag = (s.id === 'supervisor' && !isSup);
      const prefix = viewOnlyTag ? 'View only · ' : '';
      if (data) { el.textContent = prefix + 'Completed'; el.classList.add('saved'); }
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
  if (!meta) return;

  const isEmp = currentExactRole === 'Shop Floor Employee' || (currentRole === 'employee' && !currentExactRole);

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
  const container = document.getElementById('sheetContainer');
  container.innerHTML = '<p style="color:#6b7290;">Loading…</p>';
  showScreen('form');
  updateEmployeeNavBar();
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
