'use client';

import { useEffect } from 'react';

export default function Page() {
  useEffect(() => {
    if (document.getElementById('app-logic')) return;
    const script = document.createElement('script');
    script.id = 'app-logic';
    script.src = '/app-logic.js';
    document.body.appendChild(script);
  }, []);

  return <div dangerouslySetInnerHTML={{ __html: `
<div id="app">
  <div class="hazard-strip"></div>

  <div id="topbar" class="hidden">
    <div class="brand">
      <img class="brand-logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARcAAAA9CAYAAACHky0wAAAFZ0lEQVR4nO3dy4scRRwH8O+3umd3NiZRhKCY1+4aiJLsahADHgSj/gchIB50NgfFgw8ExQeiFz15EA8eQg5J8OAfoGAOuQhiQIKEzaKE6I6axyGaRDZuMo/6/TxsIj5n51WTnuz3c66aqm7ob09Xd1VxcqrikH8hM2RsbDh5/NCZdspPTlUugrwNPiynkwC8YQtYW60euNqq5Lpte1av4arnQb7XVUsMcI+zNDz3/dzBLzutv2XHzDqrx5dDPvqaWaObLjgcZ2tNu+/Md4d+bVVw69a9a2olOxro9wJkpw2FrIQYm2+tsrEP5uY+utxNZ9tx546ZdeWmvZGHkZe6PCfJhRvdARG5OSlcRCQJhYuIJKFwEZEkFC4ikoTCRUSSULiISBIKFxFJQuEiIkkoXEQkCYWLiCShcBGRJPIe6zuZkQwAlpuwR5g3AXfH0qy5LhAh5G215TC4xR7aGignA8kMyx/bdYS7wX1ojlEKhwghw7VJrH3/9Z7ChQx0j18bmt8SGGlV1g11ko+QYZO7ddMY3P1C9NpnBEst23I0Sawns11dtTVgS+fRjhvi8eXO43UO1AncQ2Y7h+EYpXDczRYi7DCBJtj/G1Rv4RJyxFj7NGa1/VmzvLZlYcclAAdCyLoKFyIAiGfqxOu5cU2rssFsEQyPM892eSz+hceQw2L9iJXi+6znt7ZTpxlsoWScCVm+02M9dRflJuTABVp8F3m4Yhb6PkTSW7iACM7T1W8+OQvg7HLlJ6Yrl7rORxJwLJ5uc32V8e2VH8LQDCkRcJ778djH5wCca7fW3dMzPye44cgKQYba/ImJWeCdJHfgnq4+B0B62wEVvMer3du/kgiUUjxHpkJ61mkdM8uH5wilcNw5Pl5t6zG8G8NyaxeRIaNwEZEkFC4ikoTCRUSSULjIYDii0Re6qTpav/wbiJY7FEjnnLDldn7oRa9f6Iosy90AYgsR9k9sr1wgO7qp+VVgFMBm82aqLq5EJLFpcqpyBEBM0YDCRQYkrGbIHgxdfJfjcNAN7qapDn1EcFUI+aOpfl/hIgPicGv2+uWRgqWvHCk3VNOYi4gkoXARkSQULiKShMJliBHU1CIpLIXLEHO4BjilsPS2qAAs1uHwtye2P/0K4G0GPg1E2bSWixSUwqUQHEQYQ8BYh9UwTMtKyMqicCkMV07ITUVjLiKShMJFRJLQY5EMCMEQQLCjp78/N73Q3KIErm/Vk4bCRQbC4b/D4ikDLhLoZL1gM2CUwHqQG+EamOoXhy+aNY5Cs6JlWJEB8DjvwAvzswe/wAPPtNx36m+O7Wts3PrEXaWR0RcDS6+ap5tot8K4O36aP3HgsVQNKFxkUDx4XFqQ5di+jhJizFlvepq760pGRxgfr5RTLRilAV0ZHM+6Gi+xW8qE62vkYaNwEZEkFC4ikoTCRUSS0IBuYbDzLzg0t6iACLrFcrlZu9E9WRbp1ermZDNfFS6F4XUYaiDbixh3BzACYjRtv6Qj7gB4xy+LjanJ+59csDjS8R7g/1SdHT+ZYrN4dxud2HZqivlTV8xC359iFC4FwJDDLR4x2OdA2zOjrwbgYYZ8t5u23CgK9wgHdoXc1iOWGoHdv+VykIT7hofm9p7+Clf62U8AIHA7QvYmDM1e+vl/FC4FEJghsnm4Onvww07qTU5VzgfmuyMULkXhbh5CmCbD9F8mL3RpqX75/MizQN/DhQxhbQjZnt77+d8ULgVwbeik3HE99zHXmEvR0JfmQfXtB9O9dXFYwn+9elskIkkoXEQkCYWLiCShcBGRJBQuIpKEwkVEklC4iEgSChcRSULhIiJJKFxEJAmFi4gkoXARkST+AIJPzrvPGB5jAAAAAElFTkSuQmCC" alt="Mahle">
      <div class="word">Growth Passport<br>Assessment &amp; Performance Portal</div>
    </div>

    <div class="topbar-cycle-picker" id="topbarCyclePicker" style="display:flex;align-items:center;gap:6px;background:#f0f4fa;border:1px solid #d0ddec;border-radius:8px;padding:4px 10px;margin-left:auto;margin-right:12px;">
      <span style="font-size:11px;font-weight:700;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;display:flex;align-items:center;gap:4px;">
        📅 Cycle:
      </span>
      <select class="cycle-month-picker" id="topbarMonthSelect" style="padding:4px 7px;border:1px solid #c2d3ea;border-radius:6px;font-weight:600;font-size:12px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
      <select class="cycle-year-picker" id="topbarYearSelect" style="padding:4px 7px;border:1px solid #c2d3ea;border-radius:6px;font-weight:600;font-size:12px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
      <span class="badge badge-evaluated" id="topbarCycleBadge" style="font-size:10px;padding:2px 6px;">Active</span>
    </div>

    <div class="who">
      <div class="who-text">
        <div class="who-name" id="whoName">—</div>
        <div class="who-role-row">
          <span class="who-role" id="whoRole">—</span>
          <span class="who-unit" id="whoUnitBadge"></span>
        </div>
      </div>
      <div class="avatar" id="whoAvatar">—</div>
      <button type="button" class="btn btn-ghost" id="topbarManageUnitsBtn" style="font-weight:700;display:none;align-items:center;gap:6px;border:1px solid var(--panel-line);border-radius:6px;padding:6px 11px;font-size:12.5px;color:var(--mahle-blue);background:#fff;" title="Manage Plant &amp; Unit Names">
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
        <span>Edit Units</span>
      </button>
      <button class="btn btn-ghost" id="logoutBtn">Log out</button>
    </div>
  </div>

  <!-- LOGIN -->
  <section id="screen-login">
    <div class="login-split">
      <div class="login-visual">
        <div class="login-visual-inner">
          <div class="lv-badge">Growth Passport</div>
          <div class="lv-caption">Track performance. Multi-Unit Assessment. Build growth.</div>
        </div>
      </div>
      <div class="login-panel">
        <img class="login-logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARcAAAA9CAYAAACHky0wAAAFZ0lEQVR4nO3dy4scRRwH8O+3umd3NiZRhKCY1+4aiJLsahADHgSj/gchIB50NgfFgw8ExQeiFz15EA8eQg5J8OAfoGAOuQhiQIKEzaKE6I6axyGaRDZuMo/6/TxsIj5n51WTnuz3c66aqm7ob09Xd1VxcqrikH8hM2RsbDh5/NCZdspPTlUugrwNPiynkwC8YQtYW60euNqq5Lpte1av4arnQb7XVUsMcI+zNDz3/dzBLzutv2XHzDqrx5dDPvqaWaObLjgcZ2tNu+/Md4d+bVVw69a9a2olOxro9wJkpw2FrIQYm2+tsrEP5uY+utxNZ9tx546ZdeWmvZGHkZe6PCfJhRvdARG5OSlcRCQJhYuIJKFwEZEkFC4ikoTCRUSSULiISBIKFxFJQuEiIkkoXEQkCYWLiCShcBGRJPIe6zuZkQwAlpuwR5g3AXfH0qy5LhAh5G215TC4xR7aGignA8kMyx/bdYS7wX1ojlEKhwghw7VJrH3/9Z7ChQx0j18bmt8SGGlV1g11ko+QYZO7ddMY3P1C9NpnBEst23I0Sawns11dtTVgS+fRjhvi8eXO43UO1AncQ2Y7h+EYpXDczRYi7DCBJtj/G1Rv4RJyxFj7NGa1/VmzvLZlYcclAAdCyLoKFyIAiGfqxOu5cU2rssFsEQyPM892eSz+hceQw2L9iJXi+6znt7ZTpxlsoWScCVm+02M9dRflJuTABVp8F3m4Yhb6PkTSW7iACM7T1W8+OQvg7HLlJ6Yrl7rORxJwLJ5uc32V8e2VH8LQDCkRcJ778djH5wCca7fW3dMzPye44cgKQYba/ImJWeCdJHfgnq4+B0B62wEVvMer3du/kgiUUjxHpkJ61mkdM8uH5wilcNw5Pl5t6zG8G8NyaxeRIaNwEZEkFC4ikoTCRUSSULjIYDii0Re6qTpav/wbiJY7FEjnnLDldn7oRa9f6Iosy90AYgsR9k9sr1wgO7qp+VVgFMBm82aqLq5EJLFpcqpyBEBM0YDCRQYkrGbIHgxdfJfjcNAN7qapDn1EcFUI+aOpfl/hIgPicGv2+uWRgqWvHCk3VNOYi4gkoXARkSQULiKShMJliBHU1CIpLIXLEHO4BjilsPS2qAAs1uHwtye2P/0K4G0GPg1E2bSWixSUwqUQHEQYQ8BYh9UwTMtKyMqicCkMV07ITUVjLiKShMJFRJLQY5EMCMEQQLCjp78/N73Q3KIErm/Vk4bCRQbC4b/D4ikDLhLoZL1gM2CUwHqQG+EamOoXhy+aNY5Cs6JlWJEB8DjvwAvzswe/wAPPtNx36m+O7Wts3PrEXaWR0RcDS6+ap5tot8K4O36aP3HgsVQNKFxkUDx4XFqQ5di+jhJizFlvepq760pGRxgfr5RTLRilAV0ZHM+6Gi+xW8qE62vkYaNwEZEkFC4ikoTCRUSS0IBuYbDzLzg0t6iACLrFcrlZu9E9WRbp1ermZDNfFS6F4XUYaiDbixh3BzACYjRtv6Qj7gB4xy+LjanJ+59csDjS8R7g/1SdHT+ZYrN4dxud2HZqivlTV8xC359iFC4FwJDDLR4x2OdA2zOjrwbgYYZ8t5u23CgK9wgHdoXc1iOWGoHdv+VykIT7hofm9p7+Clf62U8AIHA7QvYmDM1e+vl/FC4FEJghsnm4Onvww07qTU5VzgfmuyMULkXhbh5CmCbD9F8mL3RpqX75/MizQN/DhQxhbQjZnt77+d8ULgVwbeik3HE99zHXmEvR0JfmQfXtB9O9dXFYwn+9elskIkkoXEQkCYWLiCShcBGRJBQuIpKEwkVEklC4iEgSChcRSULhIiJJKFxEJAmFi4gkoXARkST+AIJPzrvPGB5jAAAAAElFTkSuQmCC" alt="Mahle">
        <h1 id="loginHeading">Sign In</h1>
        <div class="role-toggle" id="roleToggle">
          <button type="button" class="active" data-role="employee">Employee</button>
          <button type="button" data-role="supervisor">Manager / Admin</button>
        </div>
        <div class="field">
          <label for="loginId" id="loginIdLabel">Employee ID / Code</label>
          <input type="text" id="loginId" placeholder="e.g. KA1042 or NTK1042" autocomplete="username">
        </div>
        <div class="field">
          <label for="loginPw" id="loginPwLabel">Password</label>
          <input type="password" id="loginPw" placeholder="Password" autocomplete="current-password">
        </div>
        <div class="login-note" id="loginNote">Employees: Password matches your ID. Supervisors: Enter assigned passcode.</div>
        <div class="login-error" id="loginError"></div>
        <button class="btn btn-primary" id="loginBtn">Sign In</button>
      </div>
    </div>
  </section>

  <div id="appBody" class="hidden">
    <nav id="sidebar"></nav>
    <main>

    <!-- EMPLOYEE RECORD SUB-NAV BAR (Dropdown, Stepper & Quick Actions for Selected Employee) -->
    <div id="employeeNavBar" class="employee-navbar hidden">
      <div class="enb-left">
        <div class="enb-avatar" style="font-size:10px;font-family:var(--font-mono);font-weight:700;display:flex;align-items:center;justify-content:center;">STAFF</div>
        <div>
          <div class="enb-name-row">
            <span class="enb-name" id="enbName">—</span>
            <span class="enb-code" id="enbCode">—</span>
            <span class="who-unit" id="enbUnit">Unit</span>
          </div>
          <div class="enb-status-row">
            <span class="enb-sub" id="enbSub">Passport Assessment Record</span>
            <span class="badge badge-pending" id="enbBadge">Status: —</span>
          </div>
        </div>
      </div>

      <div class="enb-center">
        <button type="button" class="enb-btn-step" id="enbPrevBtn" title="Previous section">Prev</button>
        <div class="enb-select-wrap">
          <select id="enbSheetSelect" class="enb-sheet-select" aria-label="Select Passport Section"></select>
        </div>
        <button type="button" class="enb-btn-step" id="enbNextBtn" title="Next section">Next</button>
        <button type="button" class="btn btn-sm btn-ghost" id="enbGridBtn" title="View all 10 cards">All Sections</button>
      </div>

      <div class="enb-right">
        <button type="button" class="btn btn-sm btn-primary hidden" id="enbEvalBtn">Evaluate (1-10)</button>
        <button type="button" class="btn btn-sm btn-ghost enb-close-btn" id="enbCloseBtn" title="Exit employee record">Back to Console</button>
      </div>
    </div>

    <!-- HOME SCREEN -->
    <section id="screen-home" class="hidden">
      <div class="home-wrap">
        <div class="eyebrow" id="homeEyebrow">Home</div>
        <h1 id="homeGreeting">Welcome</h1>
        <p class="lead" id="homeLead">Welcome to the MAHLE Monthly Assessment & Performance Portal.</p>

        <!-- Employee View -->
        <div id="homeEmployee">
          <!-- Employee Profile & Passport Status Hero Card -->
          <div class="emp-hero-card" id="empHeroCard">
            <div class="emp-hero-left">
              <div class="emp-hero-avatar" id="empHeroAvatar" style="font-size:11px;font-family:var(--font-mono);font-weight:700;display:flex;align-items:center;justify-content:center;">EMP</div>
              <div>
                <h2 class="emp-hero-name" id="empHeroName">Welcome</h2>
                <div class="emp-hero-meta">
                  <span class="emp-hero-pill" id="empHeroCode">ID: —</span>
                  <span class="emp-hero-pill" id="empHeroUnit">Unit</span>
                  <span class="emp-hero-pill" id="empHeroRole">Employee</span>
                  <span class="emp-hero-pill" id="empHeroDept">Line Operations</span>
                </div>
              </div>
            </div>
            <div class="emp-hero-right">
              <div class="emp-hero-status" id="empHeroStatus">Assessment Cycle: October 2026</div>
              <button class="emp-btn-hero" id="goGrowthBtn">
                <span>Open 10 Passport Sections</span>
                <span>View</span>
              </button>
            </div>
          </div>

          <!-- Employee Assessment Cycle Selector Bar -->
          <div class="emp-cycle-selector-bar" id="empCycleBar" style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:12px 18px;margin-bottom:16px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
            <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
              <span style="font-weight:700;font-size:12px;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;">Select Assessment Month &amp; Year:</span>
              <select class="cycle-month-picker" id="empScoreMonthSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              <select class="cycle-year-picker" id="empScoreYearSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
            </div>
            <div style="display:flex;align-items:center;gap:8px;">
              <span class="badge badge-evaluated" id="empScoreCycleBadge">October 2026 Cycle</span>
              <span style="font-size:11.5px;color:var(--ink-dim);">Switch cycle to view historical scorecard</span>
            </div>
          </div>

          <!-- Current Month Scorecard -->
          <div id="employeeScorecard" class="hidden"></div>

          <!-- Passport Sections Quick-Jump Hub -->
          <div class="emp-sheets-title-row">
            <div>
              <h3 style="margin:0;font-family:var(--font-display);font-size:17px;">Growth Performance Passport · Sections</h3>
              <p style="margin:2px 0 0;font-size:12.5px;color:var(--ink-dim);">Select any section below to update daily records, competencies, and performance metrics.</p>
            </div>
            <span class="badge badge-score">Passport Sections Active</span>
          </div>
          <div class="emp-sheets-grid" id="empSheetsGrid"></div>
        </div>

        <!-- Supervisor / Admin Views -->
        <div id="homeSupervisor" class="hidden">

          <!-- Super Admin / HR Head Multi-Unit Dashboard -->
          <div id="homeAdminView" class="hidden" style="margin-bottom:24px;">
            <!-- Hidden backward-compatibility anchors -->
            <button type="button" class="hidden" id="btnAdminAddUser"></button>
            <button type="button" class="hidden" id="btnAdminExportCsv"></button>
            <!-- Admin Assessment Cycle Selector Bar -->
            <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:12px 18px;margin-bottom:14px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
              <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <span style="font-weight:700;font-size:12.5px;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;">Assessment Cycle:</span>
                <select class="cycle-month-picker" id="adminMonthSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <select class="cycle-year-picker" id="adminYearSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              </div>
              <div style="display:flex;align-items:center;gap:8px;">
                <span class="badge badge-evaluated" id="adminCycleBadge">October 2026</span>
                <span style="font-size:11.5px;color:var(--ink-dim);" id="adminScopeBadge">Multi-Unit Scope (All Plants)</span>
              </div>
            </div>

            <div class="unit-filter-bar" id="unitFilterBar" style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
              <span class="unit-filter-label">Filter Unit:</span>
              <div id="dynamicUnitPills" style="display:inline-flex;align-items:center;gap:8px;flex-wrap:wrap;">
                <button type="button" class="unit-pill active" data-unit="all">All Units</button>
                <button type="button" class="unit-pill" data-unit="Gurugram">Gurugram</button>
                <button type="button" class="unit-pill" data-unit="Parwanoo">Parwanoo</button>
                <button type="button" class="unit-pill" data-unit="Pune">Pune</button>
              </div>
              <button type="button" class="btn btn-xs btn-ghost" id="unitBarEditBtn" style="margin-left:auto;font-size:12px;display:none;align-items:center;gap:4px;border:1px dashed var(--panel-line);padding:4px 10px;border-radius:20px;font-weight:600;color:var(--mahle-blue);" title="Rename Plant Units (Super Admin Only)">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                <span>Edit Unit Names</span>
              </button>
              <button type="button" class="btn btn-xs btn-ghost" id="adminMasterCatalogBtn" style="margin-left:8px;font-size:12px;display:none;align-items:center;gap:4px;border:1px dashed var(--panel-line);padding:4px 10px;border-radius:20px;font-weight:600;color:var(--mahle-blue);" title="Manage Training Matrix &amp; Activities (Super Admin Only)">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path></svg>
                <span>Training &amp; Activities</span>
              </button>
            </div>

            <div class="stat-grid" id="adminKpiGrid" style="grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));">
              <div class="stat-card">
                <span class="stat-label">Total Employees</span>
                <span class="stat-num" id="kpiTotalEmp">0</span>
                <span class="stat-sub">Active in Scope</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Reports Submitted</span>
                <span class="stat-num" id="kpiSubmitted">0</span>
                <span class="stat-sub" id="kpiSubRate">0% Submission</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Pending TL Rating</span>
                <span class="stat-num" id="kpiPendingReviews" style="color:#b45309;">0</span>
                <span class="stat-sub" id="kpiPendingRate">Awaiting Evaluation</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Evaluations Done</span>
                <span class="stat-num" id="kpiEvaluated">0</span>
                <span class="stat-sub" id="kpiEvalRate">0% Completed</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Average Score</span>
                <span class="stat-num" id="kpiAvgScore">0.0</span>
                <span class="stat-sub">Out of 10.0 scale</span>
              </div>
            </div>

            <div class="table-wrap">
              <div class="table-header">
                <div class="table-title">State Units Performance Matrix</div>
              </div>
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Unit / State</th>
                    <th>Code</th>
                    <th>Employees</th>
                    <th>Submitted</th>
                    <th>Evaluated</th>
                    <th>Avg Score (1-10)</th>
                  </tr>
                </thead>
                <tbody id="unitMatrixBody">
                  <tr><td colspan="6" style="text-align:center;color:var(--ink-dim);">Loading unit metrics…</td></tr>
                </tbody>
              </table>
            </div>

            <div class="table-wrap" style="margin-top:20px;">
              <div class="table-header">
                <div class="table-title">Senior Group Leader (SGL) & Team Performance Matrix</div>
              </div>
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Senior Group Leader (SGL)</th>
                    <th>Plant / Unit</th>
                    <th>Group Staff</th>
                    <th>Submitted</th>
                    <th>Evaluated</th>
                    <th>Avg Score (1-10)</th>
                  </tr>
                </thead>
                <tbody id="sglMatrixBody">
                  <tr><td colspan="6" style="text-align:center;color:var(--ink-dim);">Loading group metrics…</td></tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Unit Admin View -->
          <div id="homeUnitAdminView" class="hidden" style="margin-bottom:20px;">
            <!-- Unit Admin Assessment Cycle Selector Bar -->
            <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:12px 18px;margin-bottom:16px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
              <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <span style="font-weight:700;font-size:12.5px;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;">Assessment Cycle:</span>
                <select class="cycle-month-picker" id="uaMonthSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <select class="cycle-year-picker" id="uaYearSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <span class="badge badge-score" id="uaUnitBadge">Plant Unit</span>
              </div>
              <span class="badge badge-evaluated" id="uaCycleBadge">October 2026</span>
            </div>

            <!-- Unit Admin KPI Stats Grid -->
            <div class="stat-grid" id="uaKpiGrid">
              <div class="stat-card">
                <span class="stat-label">Unit Staff</span>
                <span class="stat-num" id="uaKpiTotal">0</span>
                <span class="stat-sub">Active in Unit</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Reports Submitted</span>
                <span class="stat-num" id="uaKpiSubmitted">0</span>
                <span class="stat-sub" id="uaKpiSubRate">0% Submission</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Evaluations Done</span>
                <span class="stat-num" id="uaKpiEvaluated">0</span>
                <span class="stat-sub" id="uaKpiEvalRate">0% Completed</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Unit Avg Score</span>
                <span class="stat-num" id="uaKpiAvgScore">—</span>
                <span class="stat-sub">1.0 - 10.0 Scale</span>
              </div>
            </div>
          </div>

          <!-- Team Leader View -->
          <div id="homeTLView" class="hidden" style="margin-bottom:24px;">
            <!-- Team Leader Assessment Cycle Selector Bar -->
            <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:12px 18px;margin-bottom:16px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
              <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <span style="font-weight:700;font-size:12.5px;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;">Assessment Cycle:</span>
                <select class="cycle-month-picker" id="tlMonthSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <select class="cycle-year-picker" id="tlYearSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <span class="badge badge-score" id="tlUnitBadge">Plant Unit</span>
              </div>
              <span class="badge badge-evaluated" id="tlCycleBadge">October 2026</span>
            </div>

            <!-- TL KPI Stats Grid -->
            <div class="stat-grid" id="tlKpiGrid" style="grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));margin-bottom:20px;">
              <div class="stat-card">
                <span class="stat-label">Assigned Team</span>
                <span class="stat-num" id="tlKpiTotal">0</span>
                <span class="stat-sub">Mapped in Unit</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Reports Submitted</span>
                <span class="stat-num" id="tlKpiSubmitted">0</span>
                <span class="stat-sub" id="tlKpiSubRate">0% Submission</span>
              </div>
              <div class="stat-card" style="border-left:3px solid #d97706;">
                <span class="stat-label">Pending Assessments</span>
                <span class="stat-num" id="tlKpiPending" style="color:#b45309;">0</span>
                <span class="stat-sub" id="tlKpiPendingSub">Awaiting Rating</span>
              </div>
              <div class="stat-card" style="border-left:3px solid #15803d;">
                <span class="stat-label">Evaluations Done</span>
                <span class="stat-num" id="tlKpiEvaluated" style="color:#15803d;">0</span>
                <span class="stat-sub" id="tlKpiEvalRate">0% Completed</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Team Avg Score</span>
                <span class="stat-num" id="tlKpiAvgScore">—</span>
                <span class="stat-sub">Scale 1.0 - 10.0</span>
              </div>
            </div>

            <!-- TL Assessment Tracking & Workflow Header -->
            <div class="table-wrap">
              <div class="table-header" style="flex-wrap:wrap;gap:12px;align-items:center;justify-content:space-between;padding:16px 20px;">
                <div>
                  <div class="table-title" style="display:flex;align-items:center;gap:8px;">
                    <span>Assigned Shop Floor Team Roster</span>
                    <span class="badge badge-score" id="tlUnitBadgeTitle">October 2026</span>
                  </div>
                  <div style="font-size:12.5px;color:var(--ink-dim);margin-top:3px;">
                    TL Workflow: Review Monthly Report → Give Rating/Marks (1-10) → Add Comments → Submit Assessment
                  </div>
                </div>
                
                <!-- Quick Search Input -->
                <div style="min-width:240px;max-width:320px;flex:1;">
                  <input type="text" id="tlHomeSearchInput" placeholder="Filter team member by Name or ID..." style="width:100%;padding:7px 12px;border:1px solid var(--panel-line);border-radius:6px;font-size:13px;background:#f8f9fd;">
                </div>
              </div>

              <!-- TL Filter Tabs: All, Pending, Completed -->
              <div style="display:flex;align-items:center;gap:8px;padding:10px 20px;background:#fcfdff;border-bottom:1px solid var(--panel-line);flex-wrap:wrap;">
                <span style="font-size:11.5px;font-weight:700;text-transform:uppercase;color:var(--ink-dim);letter-spacing:0.5px;margin-right:4px;">Filter Assessments:</span>
                <button type="button" class="dir-pill active" id="tlPillAll" data-tlfilter="all">
                  All Mapped Members (<span id="tlCountAll">0</span>)
                </button>
                <button type="button" class="dir-pill" id="tlPillPending" data-tlfilter="pending" style="color:#b45309;">
                  ⏳ Pending Assessments (<span id="tlCountPending">0</span>)
                </button>
                <button type="button" class="dir-pill" id="tlPillCompleted" data-tlfilter="completed" style="color:#15803d;">
                  ✓ Completed Assessments (<span id="tlCountCompleted">0</span>)
                </button>
                <span style="margin-left:auto;font-size:12px;font-family:var(--font-mono);color:var(--ink-dim);" id="tlFilterSummaryBadge">Showing team members</span>
              </div>

              <table class="data-table">
                <thead>
                  <tr>
                    <th>Emp ID</th>
                    <th>Employee Name</th>
                    <th>Department</th>
                    <th>Monthly Report</th>
                    <th>Assessment Rating (1-10)</th>
                    <th style="min-width:260px;">Team Leader Actions</th>
                  </tr>
                </thead>
                <tbody id="tlAssignedHomeBody">
                  <tr><td colspan="6" style="text-align:center;color:var(--ink-dim);padding:20px;">Loading assigned employees…</td></tr>
                </tbody>
              </table>
            </div>
          </div>


          <!-- SGL Team View -->
          <div id="homeSGLView" class="hidden" style="margin-bottom:24px;">
            <!-- Historical Cycle / Month Selector & Console Bar -->
            <div style="display:flex;align-items:center;justify-content:space-between;gap:16px;background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:12px 18px;margin-bottom:18px;flex-wrap:wrap;">
              <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <span style="font-weight:700;font-size:13px;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;">Assessment Cycle:</span>
                <select class="cycle-month-picker" id="sglMonthSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:700;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <select class="cycle-year-picker" id="sglYearSelect" style="padding:5px 9px;border:1px solid var(--panel-line);border-radius:6px;font-weight:700;font-size:12.5px;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <span class="badge badge-score" id="sglUnitBadgeTitle">Gurugram Unit</span>
                <span class="badge badge-evaluated" style="font-size:11px;">Group Supervision Active</span>
              </div>
              <div style="display:flex;align-items:center;gap:10px;flex-wrap:wrap;">
                <button type="button" class="btn btn-sm btn-primary" id="btnGoHistoricalFromHome" style="font-weight:700;display:inline-flex;align-items:center;gap:6px;background:#1e2a63;color:#fff;border-radius:6px;padding:6px 14px;cursor:pointer;">
                  <span>📅 Historical Records Archive</span> →
                </button>
                <span style="font-size:12px;color:var(--ink-dim);">🔒 TL Scores Locked (Audit Only)</span>
              </div>
            </div>

            <!-- SGL KPI Stats Grid (5 Cards) -->
            <div class="stat-grid" id="sglKpiGrid" style="grid-template-columns:repeat(auto-fit, minmax(175px, 1fr));margin-bottom:20px;">
              <div class="stat-card">
                <span class="stat-label">Group Members</span>
                <span class="stat-num" id="sglKpiTotal">0</span>
                <span class="stat-sub">Under Supervision</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Reports Submitted</span>
                <span class="stat-num" id="sglKpiSubmitted">0</span>
                <span class="stat-sub" id="sglKpiSubRate">0% Submission</span>
              </div>
              <div class="stat-card" style="border-left:3px solid #d97706;">
                <span class="stat-label">Pending Assessments</span>
                <span class="stat-num" id="sglKpiPending" style="color:#b45309;">0</span>
                <span class="stat-sub" id="sglKpiPendingSub">Awaiting TL Rating</span>
              </div>
              <div class="stat-card" style="border-left:3px solid #15803d;">
                <span class="stat-label">Evaluated by TL</span>
                <span class="stat-num" id="sglKpiEvaluated" style="color:#15803d;">0</span>
                <span class="stat-sub" id="sglKpiEvalRate">0% Completed</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Group Avg Score</span>
                <span class="stat-num" id="sglKpiAvgScore">—</span>
                <span class="stat-sub">Scale 1.0 - 10.0</span>
              </div>
            </div>

            <!-- Team Performance Monitoring Breakdown Card -->
            <div style="background:#fff;border:1px solid var(--panel-line);border-radius:10px;padding:16px 20px;margin-bottom:20px;display:flex;align-items:center;justify-content:space-between;gap:20px;flex-wrap:wrap;">
              <div>
                <div style="font-weight:700;font-size:13.5px;color:#1e2a63;margin-bottom:3px;">Group Performance &amp; Evaluation Health</div>
                <div style="font-size:12px;color:var(--ink-dim);" id="sglPerfSubtext">Monitoring score distribution and pending assessment completion for your unit.</div>
              </div>
              <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;" id="sglTierBadges">
                <div style="background:#effcf6;border:1px solid #c2f0d9;border-radius:6px;padding:6px 12px;font-size:12px;font-weight:700;color:#15803d;">
                  Grade A (≥8.0): <span id="sglCountTierA">0</span>
                </div>
                <div style="background:#f0f5ff;border:1px solid #d0e1fd;border-radius:6px;padding:6px 12px;font-size:12px;font-weight:700;color:#1e40af;">
                  Grade B (6.0-7.9): <span id="sglCountTierB">0</span>
                </div>
                <div style="background:#fffbeb;border:1px solid #fee3a2;border-radius:6px;padding:6px 12px;font-size:12px;font-weight:700;color:#b45309;">
                  Needs Review (&lt;6.0): <span id="sglCountTierC">0</span>
                </div>
              </div>
            </div>

            <!-- SGL Assessment Audit Table & Filter Tabs -->
            <div class="table-wrap">
              <div class="table-header" style="flex-wrap:wrap;gap:12px;align-items:center;justify-content:space-between;padding:16px 20px;">
                <div>
                  <div class="table-title" style="display:flex;align-items:center;gap:8px;">
                    <span>Shop Floor Group Assessment Audit</span>
                    <span class="badge badge-score" id="sglCycleBadgeTitle">October 2026</span>
                  </div>
                  <div style="font-size:12.5px;color:var(--ink-dim);margin-top:3px;">
                    SGL Workflow: View Monthly Report → View TL Assessment &amp; Scores → Audit TL Comments → Verify Remarks
                  </div>
                </div>
                
                <!-- Quick Search Input -->
                <div style="min-width:240px;max-width:320px;flex:1;">
                  <input type="text" id="sglHomeSearchInput" placeholder="Filter staff by Name, ID, or TL..." style="width:100%;padding:7px 12px;border:1px solid var(--panel-line);border-radius:6px;font-size:13px;background:#f8f9fd;">
                </div>
              </div>

              <!-- SGL Filter Tabs -->
              <div style="display:flex;align-items:center;gap:8px;padding:10px 20px;background:#fcfdff;border-bottom:1px solid var(--panel-line);flex-wrap:wrap;">
                <span style="font-size:11.5px;font-weight:700;text-transform:uppercase;color:var(--ink-dim);letter-spacing:0.5px;margin-right:4px;">Filter Group:</span>
                <button type="button" class="dir-pill active" id="sglPillAll" data-sglfilter="all">
                  All Group Staff (<span id="sglCountAll">0</span>)
                </button>
                <button type="button" class="dir-pill" id="sglPillPending" data-sglfilter="pending" style="color:#b45309;">
                  ⏳ Pending TL Assessment (<span id="sglCountPending">0</span>)
                </button>
                <button type="button" class="dir-pill" id="sglPillEvaluated" data-sglfilter="evaluated" style="color:#15803d;">
                  ✓ Evaluated by TL (<span id="sglCountEvaluated">0</span>)
                </button>
                <button type="button" class="dir-pill" id="sglPillNotSub" data-sglfilter="notsub" style="color:var(--ink-dim);">
                  📄 Report Not Submitted (<span id="sglCountNotSub">0</span>)
                </button>
                <span style="margin-left:auto;font-size:12px;font-family:var(--font-mono);color:var(--ink-dim);" id="sglFilterSummaryBadge">Showing group staff</span>
              </div>

              <table class="data-table">
                <thead>
                  <tr>
                    <th>Emp ID</th>
                    <th>Employee Name</th>
                    <th>Assigned Team Leader</th>
                    <th>Monthly Report</th>
                    <th>TL Assessment &amp; Score</th>
                    <th>TL Comments</th>
                    <th style="min-width:230px;">SGL Audit Actions</th>
                  </tr>
                </thead>
                <tbody id="sglTeamHomeBody">
                  <tr><td colspan="7" style="text-align:center;color:var(--ink-dim);padding:20px;">Loading group assessment records…</td></tr>
                </tbody>
              </table>
            </div>
          </div>

          <!-- Hidden compatibility anchors for console screens -->
          <div class="hidden" id="cardGoInbox"></div>
          <div class="hidden" id="cardGoDirectory"></div>
          <div class="hidden" id="cardGoLookup"></div>
          <div class="hidden" id="cardGoChangepw"></div>
        </div>
      </div>
    </section>

    <!-- DEDICATED SCREEN: SUBMISSIONS INBOX -->
    <section id="screen-inbox" class="hidden">
      <div class="menu-wrap" style="max-width:1060px;">
        <div class="eyebrow">Management Console</div>
        <h1>Submissions Inbox</h1>
        <p class="menu-lead">Review submitted monthly sheets from shop floor operators and audit passport assessment records.</p>

        <!-- Inbox KPI Metric Summary -->
        <div class="inbox-summary-grid">
          <div class="inbox-sum-card">
            <span class="inbox-sum-label">Total Submissions</span>
            <span class="inbox-sum-val" id="inboxSumTotal">0</span>
            <span class="inbox-sum-sub">October 2026 Cycle</span>
          </div>
          <div class="inbox-sum-card">
            <span class="inbox-sum-label">Awaiting Evaluation</span>
            <span class="inbox-sum-val" id="inboxSumPending" style="color:#a67300;">0</span>
            <span class="inbox-sum-sub">Pending TL Score</span>
          </div>
          <div class="inbox-sum-card">
            <span class="inbox-sum-label">Evaluated & Scored</span>
            <span class="inbox-sum-val" id="inboxSumEvaluated" style="color:#2f8f5f;">0</span>
            <span class="inbox-sum-sub">Completed</span>
          </div>
        </div>

        <!-- Inbox Toolbar -->
        <div class="inbox-toolbar" style="display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;">
          <div style="display:flex;align-items:center;gap:10px;flex:1;min-width:280px;flex-wrap:wrap;">
            <div class="inbox-search-wrap" style="flex:1;min-width:200px;">
              <input type="text" id="inboxSearchInput" placeholder="Filter submissions by Name, ID, or Unit...">
            </div>
            <div class="inbox-filters" id="inboxFilters">
              <button class="inbox-pill active" data-filter="all">All Submissions</button>
              <button class="inbox-pill" data-filter="pending">Awaiting Evaluation</button>
              <button class="inbox-pill" data-filter="evaluated">Evaluated</button>
            </div>
          </div>
          <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
            <div style="display:flex;align-items:center;gap:6px;background:#f8f9fd;border:1px solid var(--panel-line);border-radius:6px;padding:4px 9px;">
              <span style="font-size:11px;font-weight:700;color:#1e2a63;text-transform:uppercase;">Cycle:</span>
              <select class="cycle-month-picker" id="inboxMonthSelect" style="padding:3px 6px;border:1px solid var(--panel-line);border-radius:5px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              <select class="cycle-year-picker" id="inboxYearSelect" style="padding:3px 6px;border:1px solid var(--panel-line);border-radius:5px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
            </div>
            <span class="inbox-count-badge" id="inboxCountBadge">Showing entries</span>
          </div>
        </div>

        <!-- Submissions List Container -->
        <div id="inboxList" class="inbox-list"></div>

        <button class="btn btn-ghost" id="inboxBackBtn" style="margin-top:24px;">Back to Dashboard</button>
      </div>
    </section>

    <!-- DEDICATED SCREEN: TEAM & STAFF DIRECTORY -->
    <section id="screen-directory" class="hidden">
      <div class="menu-wrap" style="max-width:1100px;">
        <div class="eyebrow">Management Console</div>
        <h1 id="dirPageTitle">Team & Staff Directory</h1>
        <p class="menu-lead" id="dirPageLead">Roster of assigned personnel, live submission tracking, and evaluation actions.</p>

        <!-- Directory Toolbar -->
        <div class="dir-toolbar" style="display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;">
          <div style="display:flex;align-items:center;gap:10px;flex:1;min-width:280px;flex-wrap:wrap;">
            <div class="dir-search-wrap" style="flex:1;min-width:180px;">
              <input type="text" id="dirSearchInput" placeholder="Filter by Name, ID, or Unit...">
            </div>
            <div class="dir-filters" id="dirFilters">
              <button class="dir-pill active" data-filter="all">All Personnel</button>
              <button class="dir-pill" data-filter="pending">Pending Evaluation</button>
              <button class="dir-pill" data-filter="evaluated">Evaluated</button>
              <button class="dir-pill" data-filter="submitted">Submitted</button>
              <button class="dir-pill" data-filter="deactivated">Deactivated</button>
            </div>
          </div>
          <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
            <div style="display:flex;align-items:center;gap:6px;background:#f8f9fd;border:1px solid var(--panel-line);border-radius:6px;padding:4px 9px;">
              <span style="font-size:11px;font-weight:700;color:#1e2a63;text-transform:uppercase;">Cycle:</span>
              <select class="cycle-month-picker" id="dirMonthSelect" style="padding:3px 6px;border:1px solid var(--panel-line);border-radius:5px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              <select class="cycle-year-picker" id="dirYearSelect" style="padding:3px 6px;border:1px solid var(--panel-line);border-radius:5px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
            </div>
            <span class="dir-count" id="dirCountBadge" style="margin-right:4px;">Showing staff</span>
            <button type="button" class="btn btn-sm btn-primary" id="btnDirAddUser">Add User</button>
            <button type="button" class="btn btn-sm btn-ghost" id="btnDirExportCsv">Export CSV</button>
          </div>
        </div>

        <!-- Unit Admin Workforce Table -->
        <div id="dirUAView" class="hidden">
          <div class="table-wrap">
            <div class="table-header">
              <div class="table-title" id="uaTableTitle">Unit Workforce Directory</div>
            </div>
            <table class="data-table">
              <thead>
                <tr>
                  <th>Emp ID</th>
                  <th>Name</th>
                  <th>Role</th>
                  <th>Supervisors (TL / SGL)</th>
                  <th>Status</th>
                  <th>Score</th>
                  <th>Action</th>
                </tr>
              </thead>
              <tbody id="unitAdminEmpBody"></tbody>
            </table>
          </div>
        </div>

        <!-- Team Leader Assigned Team Table -->
        <div id="dirTLView" class="hidden">
          <div class="table-wrap">
            <div class="table-header">
              <div class="table-title">Assigned Shop Floor Team (October 2026)</div>
            </div>
            <table class="data-table">
              <thead>
                <tr>
                  <th>Emp ID</th>
                  <th>Employee Name</th>
                  <th>Unit</th>
                  <th>Submission</th>
                  <th>TL Score (1-10)</th>
                  <th>Evaluation</th>
                </tr>
              </thead>
              <tbody id="tlAssignedBody"></tbody>
            </table>
          </div>
        </div>

        <!-- SGL Group Roster Table -->
        <div id="dirSGLView" class="hidden">
          <div class="table-wrap">
            <div class="table-header" style="flex-wrap:wrap;gap:12px;align-items:center;justify-content:space-between;padding:16px 20px;">
              <div>
                <div class="table-title">Supervised Group Roster &amp; TL Assessment Audit</div>
                <div style="font-size:12.5px;color:var(--ink-dim);margin-top:3px;">
                  Group staff within your plant unit. Audit TL assessments, examine scores and feedback, and inspect monthly reports.
                </div>
              </div>
              <button type="button" class="btn btn-sm btn-primary" id="btnDirGoHistorical" style="background:#1e2a63;color:#fff;font-weight:700;display:inline-flex;align-items:center;gap:6px;cursor:pointer;">
                <span>📅 Historical Records Archive</span> →
              </button>
            </div>
            <table class="data-table">
              <thead>
                <tr>
                  <th>Emp ID</th>
                  <th>Employee Name</th>
                  <th>Role / Dept</th>
                  <th>Assigned TL</th>
                  <th>Monthly Report</th>
                  <th>TL Assessment &amp; Score</th>
                  <th>TL Comments</th>
                  <th style="min-width:220px;">Audit Actions</th>
                </tr>
              </thead>
              <tbody id="sglTeamBody">
                <tr><td colspan="8" style="text-align:center;color:var(--ink-dim);padding:20px;">Loading group staff…</td></tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Super Admin All Staff Table -->
        <div id="dirAdminView" class="hidden">
          <div class="table-wrap">
            <div class="table-header">
              <div class="table-title">Cross-Plant Enterprise Workforce & Account Directory</div>
            </div>
            <table class="data-table">
              <thead>
                <tr>
                  <th>Emp Code</th>
                  <th>Full Name</th>
                  <th>Plant / Unit</th>
                  <th>Role</th>
                  <th>Supervisors (TL / SGL)</th>
                  <th>Account Status</th>
                  <th>Oct 2026 Status</th>
                  <th>TL Score</th>
                  <th style="min-width:180px;">Management Actions</th>
                </tr>
              </thead>
              <tbody id="adminStaffBody"></tbody>
            </table>
          </div>
        </div>

        <button class="btn btn-ghost" id="dirBackBtn" style="margin-top:20px;">Back to Dashboard</button>
      </div>
    </section>

    <!-- DEDICATED SCREEN: HISTORICAL RECORDS ARCHIVE -->
    <section id="screen-historical" class="hidden">
      <div class="menu-wrap" style="max-width:1120px;">
        <div style="display:flex;align-items:flex-start;justify-content:space-between;flex-wrap:wrap;gap:16px;">
          <div>
            <div class="eyebrow">Audit &amp; Archives</div>
            <h1>Historical Assessment Records</h1>
            <p class="menu-lead">Browse prior assessment cycles, audit past Team Leader evaluation scores, review TL comments, and inspect employee monthly reports.</p>
          </div>
          <button type="button" class="btn btn-ghost" id="histBackBtn">← Back to Dashboard</button>
        </div>

        <!-- Historical Cycle Selector Bar -->
        <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:16px 20px;margin:20px 0;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px;">
          <div>
            <div style="font-size:11.5px;font-weight:700;text-transform:uppercase;color:var(--ink-dim);letter-spacing:0.5px;margin-bottom:8px;">Select Assessment Cycle / Month:</div>
            <div style="display:flex;gap:8px;flex-wrap:wrap;align-items:center;" id="histCyclePills">
              <button type="button" class="dir-pill active" data-cycle="2026-10">October 2026 (Active)</button>
              <button type="button" class="dir-pill" data-cycle="2026-09">September 2026</button>
              <button type="button" class="dir-pill" data-cycle="2026-08">August 2026</button>
              <button type="button" class="dir-pill" data-cycle="2026-07">July 2026</button>
              <button type="button" class="dir-pill" data-cycle="2026-06">June 2026</button>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-top:10px;">
              <span style="font-size:11.5px;font-weight:700;color:#1e2a63;text-transform:uppercase;">Or Custom Month &amp; Year:</span>
              <select class="cycle-month-picker" id="histMonthSelect" style="padding:4px 8px;border:1px solid var(--panel-line);border-radius:6px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              <select class="cycle-year-picker" id="histYearSelect" style="padding:4px 8px;border:1px solid var(--panel-line);border-radius:6px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
            </div>
          </div>
          <div style="display:flex;align-items:center;gap:10px;">
            <span class="badge badge-score" id="histUnitBadge">Plant Unit</span>
            <span class="badge badge-evaluated" id="histActiveCycleBadge">Cycle: October 2026</span>
          </div>
        </div>

        <!-- Historical Cycle Performance Summary (5 KPI Cards) -->
        <div class="stat-grid" id="histKpiGrid" style="grid-template-columns:repeat(auto-fit, minmax(180px, 1fr));margin-bottom:20px;">
          <div class="stat-card">
            <span class="stat-label">Group Workforce</span>
            <span class="stat-num" id="histKpiTotal">0</span>
            <span class="stat-sub">Mapped in Cycle</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">Reports Submitted</span>
            <span class="stat-num" id="histKpiSubmitted">0</span>
            <span class="stat-sub" id="histKpiSubRate">0% Submission</span>
          </div>
          <div class="stat-card" style="border-left:3px solid #d97706;">
            <span class="stat-label">Pending TL Rating</span>
            <span class="stat-num" id="histKpiPending" style="color:#b45309;">0</span>
            <span class="stat-sub">Awaiting Evaluation</span>
          </div>
          <div class="stat-card" style="border-left:3px solid #15803d;">
            <span class="stat-label">Evaluated by TL</span>
            <span class="stat-num" id="histKpiEvaluated" style="color:#15803d;">0</span>
            <span class="stat-sub" id="histKpiEvalRate">0% Completed</span>
          </div>
          <div class="stat-card">
            <span class="stat-label">Cycle Avg Score</span>
            <span class="stat-num" id="histKpiAvgScore">—</span>
            <span class="stat-sub">Scale 1.0 - 10.0</span>
          </div>
        </div>

        <!-- Historical Performance Tier Breakdown -->
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:10px;padding:14px 20px;margin-bottom:20px;display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap;">
          <div style="font-size:13px;font-weight:700;color:#1e2a63;">Cycle Performance Tier Breakdown:</div>
          <div style="display:flex;gap:10px;flex-wrap:wrap;">
            <span style="background:#effcf6;border:1px solid #c2f0d9;border-radius:6px;padding:5px 10px;font-size:12px;font-weight:700;color:#15803d;">
              Grade A (≥8.0): <strong id="histTierA">0</strong>
            </span>
            <span style="background:#f0f5ff;border:1px solid #d0e1fd;border-radius:6px;padding:5px 10px;font-size:12px;font-weight:700;color:#1e40af;">
              Grade B (6.0-7.9): <strong id="histTierB">0</strong>
            </span>
            <span style="background:#fffbeb;border:1px solid #fee3a2;border-radius:6px;padding:5px 10px;font-size:12px;font-weight:700;color:#b45309;">
              Needs Review (&lt;6.0): <strong id="histTierC">0</strong>
            </span>
          </div>
        </div>

        <!-- Historical Records Table Container -->
        <div class="table-wrap">
          <div class="table-header" style="flex-wrap:wrap;gap:12px;align-items:center;justify-content:space-between;padding:16px 20px;">
            <div>
              <div class="table-title" style="display:flex;align-items:center;gap:8px;">
                <span>Archived Group Assessment Records</span>
                <span class="badge badge-score" id="histTableTitleCycle">October 2026</span>
              </div>
              <div style="font-size:12.5px;color:var(--ink-dim);margin-top:3px;">
                Audit submitted monthly reports, historical TL assessment scores, feedback comments, and SGL verification notes.
              </div>
            </div>
            
            <div style="min-width:240px;max-width:320px;flex:1;">
              <input type="text" id="histSearchInput" placeholder="Filter historical record by Name, ID, or TL..." style="width:100%;padding:7px 12px;border:1px solid var(--panel-line);border-radius:6px;font-size:13px;background:#f8f9fd;">
            </div>
          </div>

          <!-- Filter Pills -->
          <div style="display:flex;align-items:center;gap:8px;padding:10px 20px;background:#fcfdff;border-bottom:1px solid var(--panel-line);flex-wrap:wrap;">
            <span style="font-size:11.5px;font-weight:700;text-transform:uppercase;color:var(--ink-dim);letter-spacing:0.5px;margin-right:4px;">Filter:</span>
            <button type="button" class="dir-pill active" id="histPillAll" data-histfilter="all">All Group Staff (<span id="histCountAll">0</span>)</button>
            <button type="button" class="dir-pill" id="histPillEvaluated" data-histfilter="evaluated" style="color:#15803d;">✓ Evaluated (<span id="histCountEvaluated">0</span>)</button>
            <button type="button" class="dir-pill" id="histPillPending" data-histfilter="pending" style="color:#b45309;">⏳ Pending Rating (<span id="histCountPending">0</span>)</button>
            <button type="button" class="dir-pill" id="histPillNotSub" data-histfilter="notsub" style="color:var(--ink-dim);">📄 Not Submitted (<span id="histCountNotSub">0</span>)</button>
            <span style="margin-left:auto;font-size:12px;font-family:var(--font-mono);color:var(--ink-dim);" id="histFilterSummaryBadge">Showing records</span>
          </div>

          <table class="data-table">
            <thead>
              <tr>
                <th>Emp ID</th>
                <th>Employee Name</th>
                <th>Role / Dept</th>
                <th>Assigned TL</th>
                <th>Monthly Report</th>
                <th>TL Assessment &amp; Score</th>
                <th>TL Comments</th>
                <th style="min-width:230px;">Audit Actions</th>
              </tr>
            </thead>
            <tbody id="histRecordsBody">
              <tr><td colspan="8" style="text-align:center;color:var(--ink-dim);padding:24px;">Loading historical assessment records…</td></tr>
            </tbody>
          </table>
        </div>
      </div>
    </section>

    <!-- DEDICATED SCREEN: LOOK UP EMPLOYEE -->
    <section id="screen-lookup" class="hidden">
      <div class="menu-wrap" style="max-width:850px;">
        <div class="eyebrow">Management Console</div>
        <h1>Look Up Employee Record</h1>
        <p class="menu-lead">Search any employee in the MAHLE network by Employee ID or Code to access their complete 10-point Growth Passport.</p>

        <div class="lookup-search-card">
          <div class="lookup-input-group">
            <input type="text" id="lookupPageInput" placeholder="Enter Employee Code (e.g. KA1042, NTK1042, K01001)...">
            <button class="btn btn-primary" id="lookupPageBtn">Search & Open</button>
          </div>

          <span class="lookup-chips-label">Quick Suggestions / Sample Employees:</span>
          <div class="lookup-chips" id="lookupChips">
            <button class="lookup-chip" data-id="KA1042">KA1042 · Employee</button>
            <button class="lookup-chip" data-id="NTK1042">NTK1042 · Employee</button>
            <button class="lookup-chip" data-id="K01001">K01001 · Team Leader</button>
            <button class="lookup-chip" data-id="UA1001">UA1001 · Unit Admin</button>
          </div>
          <div class="lookup-error" id="lookupPageError" style="margin-top:12px;"></div>
        </div>

        <!-- Hidden inputs for backward compatibility -->
        <input type="hidden" id="lookupId">
        <button type="button" id="lookupBtn" class="hidden"></button>
        <div id="lookupError" class="hidden"></div>

        <!-- Rich Employee Preview Dossier Card -->
        <div id="lookupPreviewBox" class="lookup-preview-card hidden">
          <div class="lookup-preview-header">
            <div class="lookup-preview-user">
              <div class="lookup-preview-avatar" style="font-size:10px;font-family:var(--font-mono);font-weight:700;display:flex;align-items:center;justify-content:center;">STAFF</div>
              <div>
                <div class="lookup-preview-name" id="lpName">—</div>
                <div class="lookup-preview-code" id="lpCode">—</div>
              </div>
            </div>
            <span class="badge badge-evaluated" id="lpBadge">Status: —</span>
          </div>

          <div class="lookup-details-grid">
            <div class="lookup-detail-item">
              <span class="lookup-detail-label">Plant / Unit</span>
              <span class="lookup-detail-val" id="lpUnit">—</span>
            </div>
            <div class="lookup-detail-item">
              <span class="lookup-detail-label">Designation</span>
              <span class="lookup-detail-val" id="lpRole">—</span>
            </div>
            <div class="lookup-detail-item">
              <span class="lookup-detail-label">Department</span>
              <span class="lookup-detail-val" id="lpDept">Operations</span>
            </div>
            <div class="lookup-detail-item">
              <span class="lookup-detail-label">Assessment Score</span>
              <span class="lookup-detail-val" id="lpScore">—</span>
            </div>
          </div>

          <div style="display:flex;gap:10px;flex-wrap:wrap;">
            <button class="btn btn-primary" id="lpOpenBtn">Open Growth Passport (10 Sections)</button>
            <button class="btn btn-ghost" id="lpEvalBtn">Evaluate (1-10)</button>
          </div>
        </div>

        <button class="btn btn-ghost" id="lookupBackBtn" style="margin-top:10px;">Back to Dashboard</button>
      </div>
    </section>

    <!-- DEDICATED SCREEN: SECURITY & PASSWORDS -->
    <section id="screen-changepw" class="hidden">
      <div class="menu-wrap" style="max-width:920px;">
        <div class="eyebrow">Management Console</div>
        <h1>Security & Password Management</h1>
        <p class="menu-lead">Update your sign-in passcode, inspect your active session credentials, and ensure compliance with MAHLE security guidelines.</p>

        <div class="sec-grid">
          <!-- Active Account Credentials Card -->
          <div class="sec-card">
            <div class="sec-card-title">Active Account Session</div>
            <div class="sec-card-sub">Current authenticated credentials for this portal session.</div>

            <div class="sec-info-row">
              <span class="sec-info-label">Signed-in User</span>
              <span class="sec-info-val" id="secWhoName">—</span>
            </div>
            <div class="sec-info-row">
              <span class="sec-info-label">Assigned Role</span>
              <span class="sec-info-val" id="secWhoRole">—</span>
            </div>
            <div class="sec-info-row">
              <span class="sec-info-label">Employee Code</span>
              <span class="sec-info-val" id="secWhoId">—</span>
            </div>
            <div class="sec-info-row">
              <span class="sec-info-label">Plant / Unit Scope</span>
              <span class="sec-info-val" id="secWhoUnit">—</span>
            </div>
            <div class="sec-info-row">
              <span class="sec-info-label">Security Protocol</span>
              <span class="sec-info-val" style="color:var(--green);font-size:12px;">● HTTP-only Encrypted Session</span>
            </div>
          </div>

          <!-- Update Password Card -->
          <div class="sec-card">
            <div class="sec-card-title">Update Sign-in Passcode</div>
            <div class="sec-card-sub">Enter your current passcode and choose a new secure password.</div>

            <div class="sec-form-group">
              <label for="pwCurrent">Current Passcode</label>
              <input type="password" id="pwCurrent" placeholder="Current passcode" autocomplete="current-password">
            </div>

            <div class="sec-form-group">
              <label for="pwNew">New Passcode</label>
              <input type="password" id="pwNew" placeholder="New passcode (min 6 characters)" autocomplete="new-password">
            </div>

            <div class="sec-form-group">
              <label for="pwConfirm">Confirm New Passcode</label>
              <input type="password" id="pwConfirm" placeholder="Confirm new passcode" autocomplete="new-password">
            </div>

            <button class="btn btn-primary" id="changePwBtn" style="width:100%;margin-top:6px;">Update Password</button>
            <div class="lookup-error" id="pwError" style="margin-top:10px;"></div>
            <div class="sec-success hidden" id="pwSuccess">Passcode updated successfully!</div>
          </div>
        </div>

        <button class="btn btn-ghost" id="changepwBackBtn" style="margin-top:10px;">Back to Dashboard</button>
      </div>
    </section>

    <!-- DEDICATED SCREEN: MASTER TRAINING & ACTIVITIES CATALOG -->
    <section id="screen-master-items" class="hidden">
      <div class="menu-wrap" style="max-width:1160px;">
        <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:16px;flex-wrap:wrap;margin-bottom:18px;">
          <div>
            <div class="eyebrow" style="margin-bottom:4px;">Master Catalog · Super Admin &amp; HR Head</div>
            <h1 style="margin:0;font-size:26px;">Training Matrix &amp; Plant Activities Catalog</h1>
            <p class="menu-lead" style="margin:6px 0 0;max-width:760px;">
              Configure company-wide training matrix courses (Sheet 05) and standard plant activity categories (Sheet 07).
              Any added or removed items instantly synchronize with all employees' growth passport records across all plants.
            </p>
          </div>
          <div style="display:flex;align-items:center;gap:10px;">
            <button class="btn btn-sm btn-ghost" id="masterItemsRefreshBtn" title="Reload catalog from database">
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" style="margin-right:5px;"><path d="M23 4v6h-6"></path><path d="M1 20v-6h6"></path><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>
              Refresh Catalog
            </button>
            <button class="btn btn-sm btn-primary" id="masterItemsBackBtn">Back to Dashboard</button>
          </div>
        </div>

        <!-- Catalog Status & Summary Bar -->
        <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:12px 18px;margin-bottom:22px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;">
          <div style="display:flex;align-items:center;gap:14px;flex-wrap:wrap;">
            <div style="display:flex;align-items:center;gap:6px;">
              <span style="display:inline-block;width:9px;height:9px;background:#16a34a;border-radius:50%;"></span>
              <span style="font-weight:700;font-size:12.5px;color:#1e2a63;">Live Synchronized</span>
            </div>
            <span style="color:var(--panel-line);">|</span>
            <span style="font-size:12.5px;color:var(--ink);font-weight:600;">
              Training Programs: <strong id="masterTrCount" style="color:var(--mahle-blue);">9</strong>
            </span>
            <span style="color:var(--panel-line);">|</span>
            <span style="font-size:12.5px;color:var(--ink);font-weight:600;">
              Plant Activities: <strong id="masterAcCount" style="color:var(--mahle-blue);">7</strong>
            </span>
          </div>
          <div style="font-size:12px;color:var(--ink-dim);font-family:var(--font-mono);">
            Scope: All Manufacturing State Units
          </div>
        </div>

        <!-- Split Grid: Training Matrix Programs (Left) & Plant Activities (Right) -->
        <div style="display:grid;grid-template-columns:repeat(auto-fit, minmax(460px, 1fr));gap:24px;">

          <!-- SECTION 1: TRAINING MATRIX (SHEET 05) -->
          <div style="background:#fff;border:1px solid var(--panel-line);border-radius:12px;padding:22px;box-shadow:0 2px 8px rgba(0,0,0,0.03);">
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;margin-bottom:14px;padding-bottom:14px;border-bottom:1px solid var(--panel-line);">
              <div>
                <div style="display:inline-block;padding:2px 8px;border-radius:4px;background:#eef2fa;color:#1e2a63;font-size:10.5px;font-weight:800;letter-spacing:0.5px;text-transform:uppercase;font-family:var(--font-mono);margin-bottom:6px;">
                  Sheet 05 · Program Training
                </div>
                <h2 style="margin:0;font-size:17px;color:#1e2a63;">Training Matrix Catalog</h2>
                <div style="font-size:12px;color:var(--ink-dim);margin-top:2px;">
                  Company training courses that employees review and mark monthly.
                </div>
              </div>
              <span class="badge badge-evaluated" id="trBadgeCount">9 Topics</span>
            </div>

            <!-- Add Training Form -->
            <div style="background:#f9fafc;border:1px dashed #c9d5ec;border-radius:8px;padding:14px;margin-bottom:16px;">
              <label class="f" for="newTrainingInput" style="font-size:12px;font-weight:700;color:#1e2a63;display:block;margin-bottom:6px;">
                + Add New Training Course / Topic
              </label>
              <div style="display:flex;flex-wrap:wrap;gap:8px;">
                <select id="newTrainingCategorySelect" style="flex:1;min-width:180px;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;background:#fff;color:var(--ink);font-weight:600;">
                  <option value="Generic Training Programme">Generic Training Programme</option>
                  <option value="Mandatory Training Plan">Mandatory Training Plan</option>
                  <option value="STOE Training Programs">STOE Training Programs</option>
                  <option value="Process Mastery Certification Programs">Process Mastery Certification Programs</option>
                  <option value="Others">Others (Custom / Any)</option>
                </select>
                <input type="text" id="newTrainingInput" placeholder="Course title (or any custom training in Others)..." style="flex:2;min-width:200px;padding:8px 12px;border:1px solid var(--panel-line);border-radius:6px;font-size:13px;background:#fff;">
                <button type="button" class="btn btn-primary" id="addTrainingBtn" style="white-space:nowrap;padding:8px 14px;">
                  Add Course
                </button>
              </div>
              <div class="lookup-error hidden" id="addTrainingError" style="margin-top:8px;font-size:12px;"></div>
            </div>

            <!-- Filter & List Header -->
            <div style="display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:10px;flex-wrap:wrap;">
              <select id="adminTrainingCategoryFilter" style="flex:1;min-width:170px;padding:6px 10px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;background:#fff;color:var(--ink);font-weight:600;">
                <option value="all">All Categories (All Courses)</option>
                <option value="Generic Training Programme">Generic Training Programme</option>
                <option value="Mandatory Training Plan">Mandatory Training Plan</option>
                <option value="STOE Training Programs">STOE Training Programs</option>
                <option value="Process Mastery Certification Programs">Process Mastery Certification Programs</option>
                <option value="Others">Others</option>
              </select>
              <input type="text" id="searchTrainingInput" placeholder="Search training courses..." style="flex:1.5;min-width:180px;padding:6px 10px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;background:#fff;">
            </div>

            <!-- Training Items Table -->
            <div style="max-height:480px;overflow-y:auto;border:1px solid var(--panel-line);border-radius:8px;">
              <table class="grid-table" style="margin:0;width:100%;">
                <thead>
                  <tr style="background:#f8f9fd;">
                    <th style="width:40px;text-align:center;">#</th>
                    <th style="text-align:left;">Course / Topic Name</th>
                    <th style="width:160px;text-align:left;">Category</th>
                    <th style="width:70px;text-align:center;">Action</th>
                  </tr>
                </thead>
                <tbody id="masterTrainingTableBody">
                  <tr><td colspan="4" style="text-align:center;padding:18px;color:var(--ink-dim);">Loading training catalog…</td></tr>
                </tbody>
              </table>
            </div>
            <div class="small-note" style="margin-top:10px;font-size:11.5px;color:var(--ink-dim);">
              Tip: Deleting a course removes it from the standard monthly matrix for all units.
            </div>
          </div>

          <!-- SECTION 2: ACTIVITIES (SHEET 07) -->
          <div style="background:#fff;border:1px solid var(--panel-line);border-radius:12px;padding:22px;box-shadow:0 2px 8px rgba(0,0,0,0.03);">
            <div style="display:flex;align-items:flex-start;justify-content:space-between;gap:12px;margin-bottom:14px;padding-bottom:14px;border-bottom:1px solid var(--panel-line);">
              <div>
                <div style="display:inline-block;padding:2px 8px;border-radius:4px;background:#eef2fa;color:#1e2a63;font-size:10.5px;font-weight:800;letter-spacing:0.5px;text-transform:uppercase;font-family:var(--font-mono);margin-bottom:6px;">
                  Sheet 07 · Plant Engagement
                </div>
                <h2 style="margin:0;font-size:17px;color:#1e2a63;">Plant Activities Catalog</h2>
                <div style="font-size:12px;color:var(--ink-dim);margin-top:2px;">
                  Committees, sports, and plant events available for employee participation.
                </div>
              </div>
              <span class="badge badge-evaluated" id="acBadgeCount">7 Activities</span>
            </div>

            <!-- Add Activity Form -->
            <div style="background:#f9fafc;border:1px dashed #c9d5ec;border-radius:8px;padding:14px;margin-bottom:16px;">
              <label class="f" for="newActivityInput" style="font-size:12px;font-weight:700;color:#1e2a63;display:block;margin-bottom:6px;">
                + Add New Plant Activity
              </label>
              <div style="display:flex;gap:8px;">
                <input type="text" id="newActivityInput" placeholder="e.g. Energy Conservation Club, Kaizen Competition, Blood Donation..." style="flex:1;padding:8px 12px;border:1px solid var(--panel-line);border-radius:6px;font-size:13px;background:#fff;">
                <button type="button" class="btn btn-primary" id="addActivityBtn" style="white-space:nowrap;padding:8px 14px;">
                  Add Activity
                </button>
              </div>
              <div class="lookup-error hidden" id="addActivityError" style="margin-top:8px;font-size:12px;"></div>
            </div>

            <!-- Filter & List Header -->
            <div style="display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:10px;">
              <input type="text" id="searchActivityInput" placeholder="Search plant activities..." style="width:100%;padding:6px 10px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;background:#fff;">
            </div>

            <!-- Activity Items Table -->
            <div style="max-height:480px;overflow-y:auto;border:1px solid var(--panel-line);border-radius:8px;">
              <table class="grid-table" style="margin:0;width:100%;">
                <thead>
                  <tr style="background:#f8f9fd;">
                    <th style="width:48px;text-align:center;">#</th>
                    <th style="text-align:left;">Activity Title / Committee</th>
                    <th style="width:80px;text-align:center;">Action</th>
                  </tr>
                </thead>
                <tbody id="masterActivityTableBody">
                  <tr><td colspan="3" style="text-align:center;padding:18px;color:var(--ink-dim);">Loading activities catalog…</td></tr>
                </tbody>
              </table>
            </div>
            <div class="small-note" style="margin-top:10px;font-size:11.5px;color:var(--ink-dim);">
              Tip: Employees can also add their own custom activities directly on Sheet 07.
            </div>
          </div>

        </div>

      </div>
    </section>

    <!-- GROWTH MENU / RECORD -->
    <section id="screen-menu" class="hidden">
      <div class="menu-wrap">
        <div id="recordHeader" class="record-header hidden" style="display:flex;align-items:center;justify-content:space-between;gap:16px;flex-wrap:wrap;">
          <div>
            <div class="rh-name" id="rhName">—</div>
            <div class="rh-sub" id="rhSub">—</div>
            <div style="display:flex;align-items:center;gap:8px;margin-top:6px;flex-wrap:wrap;">
              <span style="font-size:11.5px;font-weight:700;color:var(--ink-dim);text-transform:uppercase;letter-spacing:0.5px;">Assessment Cycle:</span>
              <select class="cycle-month-picker" id="rhMenuMonthSelect" style="padding:3px 8px;border:1px solid var(--panel-line);border-radius:6px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              <select class="cycle-year-picker" id="rhMenuYearSelect" style="padding:3px 8px;border:1px solid var(--panel-line);border-radius:6px;font-size:12px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
            </div>
          </div>
          <div style="display:flex;align-items:center;gap:8px;">
            <button class="btn btn-dark" id="rhMarkReviewedBtn">Mark Reviewed</button>
          </div>
        </div>
        <div class="eyebrow" id="menuEyebrow">Growth Performance</div>
        <h1>Growth Performance Sections</h1>
        <p class="menu-lead">Choose any section below to view/edit, or use the direct components in the sidebar.</p>

        <div class="submit-box hidden" id="submitBox" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px;">
          <div>
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:6px;flex-wrap:wrap;">
              <span class="sb-title" style="margin:0;">Select Assessment Month &amp; Year:</span>
              <select class="cycle-month-picker" id="empMenuMonthSelect" style="padding:4px 8px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              <select class="cycle-year-picker" id="empMenuYearSelect" style="padding:4px 8px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
            </div>
            <div class="sb-status" id="submitStatus">Not submitted yet for <span id="submitMonthLabel"></span></div>
          </div>
          <button class="btn btn-primary" id="submitBtn">Submit Passport for This Month</button>
        </div>

        <select id="sheetDropdown" class="hidden"></select>
        <button id="dropdownGoBtn" class="hidden"></button>

        <div class="station-grid" id="stationGrid"></div>
        <button class="btn btn-ghost" id="backHomeBtn" style="margin-top:20px;">Home</button>
      </div>
    </section>

    <!-- FORM VIEW -->
    <section id="screen-form" class="hidden">
      <div class="form-wrap">
        <div class="form-top">
          <div>
            <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
              <div class="crumb" id="formCrumb">Growth Performance</div>
              <span class="badge badge-evaluated" id="formCycleBadge" style="font-size:11px;">Cycle: October 2026</span>
              <div style="display:inline-flex;align-items:center;gap:4px;margin-left:4px;">
                <select class="cycle-month-picker" id="formMonthSelect" style="padding:2px 6px;border:1px solid var(--panel-line);border-radius:4px;font-size:11px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
                <select class="cycle-year-picker" id="formYearSelect" style="padding:2px 6px;border:1px solid var(--panel-line);border-radius:4px;font-size:11px;font-weight:600;background:#fff;color:#1e2a63;cursor:pointer;"></select>
              </div>
            </div>
            <h1 id="formTitle">Section</h1>
          </div>
          <div class="form-actions">
            <button class="btn btn-ghost" id="backMenuBtn">All sections</button>
            <button class="btn btn-primary" id="saveBtn">Save</button>
          </div>
        </div>
        <div class="sheet" id="sheetContainer"></div>
      </div>
    </section>
    </main>
  </div>
</div>

<!-- TL Evaluation Modal (Official 7 Metrics with Minimum 60% Enforced) -->
<div id="evalModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:640px;max-height:92vh;overflow-y:auto;">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:6px;">
      <h2 id="evalModalTitle" style="margin:0;">Evaluate Employee</h2>
      <button type="button" class="btn btn-sm btn-ghost" id="evalCloseXBtn">Close</button>
    </div>
    <div class="modal-sub" id="evalModalSub">Official Monthly Assessment (100 Marks · Scale 1.0 - 10.0)</div>
    
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:14px 18px;margin-bottom:18px;">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
        <label style="font-weight:700;font-size:14px;">Total Score (Out of 100 / Scale 1.0 - 10.0):</label>
        <div style="display:flex;align-items:center;gap:8px;">
          <input type="number" id="evalOverallScore" min="6.0" max="10.0" step="0.1" value="8.5" readonly style="width:75px;font-size:16px;font-weight:700;text-align:center;padding:5px;border:2px solid #1e2a63;border-radius:6px;background:#eef2fa;font-family:var(--font-mono);">
          <span style="font-weight:700;color:var(--ink-dim);">/ 10</span>
          <span id="evalTotalMarksBadge" style="font-size:13px;font-weight:700;color:#1e2a63;background:#e2e9f8;padding:4px 8px;border-radius:6px;margin-left:4px;">85 / 100</span>
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;">
        <span style="font-size:12px;color:var(--ink-dim);">Rating Tier:</span>
        <span class="badge badge-evaluated" id="evalGradeBadge">Grade A (Outstanding)</span>
      </div>
      <div style="margin-top:8px;font-size:11.5px;color:#a67300;font-weight:600;display:flex;align-items:center;gap:5px;">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
        <span>Mandatory Policy: Minimum 60% marks required across all sections (cannot score less).</span>
      </div>
    </div>

    <div style="margin-bottom:16px;">
      <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);margin-bottom:12px;text-transform:uppercase;letter-spacing:0.04em;">Official Marking Scheme (7 Metrics)</div>
      
      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">1. Performance on the Job</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 20 Marks · <strong style="color:#1e2a63;">Min 60%: 12 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cJobPerf" min="12" max="20" step="1" value="17" class="eval-metric-input" data-min="12" data-max="20" data-name="Performance on the Job" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 20</span>
        </div>
      </div>

      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">2. Attendance</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 10 Marks · <strong style="color:#1e2a63;">Min 60%: 6 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cAttendance" min="6" max="10" step="1" value="9" class="eval-metric-input" data-min="6" data-max="10" data-name="Attendance" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 10</span>
        </div>
      </div>

      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">3. Work Performance</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 20 Marks · <strong style="color:#1e2a63;">Min 60%: 12 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cWorkPerf" min="12" max="20" step="1" value="17" class="eval-metric-input" data-min="12" data-max="20" data-name="Work Performance" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 20</span>
        </div>
      </div>

      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">4. Line Performance</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 20 Marks · <strong style="color:#1e2a63;">Min 60%: 12 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cLinePerf" min="12" max="20" step="1" value="17" class="eval-metric-input" data-min="12" data-max="20" data-name="Line Performance" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 20</span>
        </div>
      </div>

      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">5. Recognition</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 10 Marks · <strong style="color:#1e2a63;">Min 60%: 6 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cRecognition" min="6" max="10" step="1" value="8" class="eval-metric-input" data-min="6" data-max="10" data-name="Recognition" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 10</span>
        </div>
      </div>

      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">6. Documentation (Growth File)</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 10 Marks · <strong style="color:#1e2a63;">Min 60%: 6 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cDocGrowth" min="6" max="10" step="1" value="8" class="eval-metric-input" data-min="6" data-max="10" data-name="Documentation (Growth File)" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 10</span>
        </div>
      </div>

      <div class="criteria-row" style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;padding:8px 12px;background:#fff;border:1px solid var(--panel-line);border-radius:8px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">7. AHPS / LEAN Participation</div>
          <div style="font-size:11.5px;color:var(--ink-dim);">Max: 10 Marks · <strong style="color:#1e2a63;">Min 60%: 6 Marks</strong></div>
        </div>
        <div style="display:flex;align-items:center;gap:6px;">
          <input type="number" id="cLean" min="6" max="10" step="1" value="9" class="eval-metric-input" data-min="6" data-max="10" data-name="AHPS / LEAN Participation" style="width:75px;padding:6px 8px;border:1px solid var(--panel-line);border-radius:6px;text-align:center;font-weight:700;font-family:var(--font-mono);font-size:14px;">
          <span style="font-size:12px;font-weight:600;color:var(--ink-dim);">/ 10</span>
        </div>
      </div>
    </div>

    <div class="field-block">
      <label class="f" for="evalComments">Supervisor Remarks / Feedback</label>
      <textarea id="evalComments" rows="3" placeholder="Enter comments and guidance for the employee..."></textarea>
    </div>

    <div id="evalModalError" class="lookup-error hidden" style="margin-bottom:12px;background:#fef2f2;border:1px solid #fecaca;padding:8px 12px;border-radius:6px;color:#b91c1c;font-weight:600;font-size:12.5px;"></div>

    <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:16px;">
      <button type="button" class="btn btn-ghost" id="evalCancelBtn">Cancel</button>
      <button type="button" class="btn btn-primary" id="evalSubmitBtn">Submit Assessment</button>
    </div>
  </div>
</div>

<!-- SGL Audit & Verification Modal (Read-Only TL Ratings with Verification Sign-Off) -->
<div id="sglAuditModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:640px;max-height:92vh;overflow-y:auto;">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:6px;">
      <div>
        <h2 id="sglAuditModalTitle" style="margin:0;">Audit TL Assessment</h2>
        <div class="modal-sub" id="sglAuditModalSub">Senior Group Leader Performance Audit &amp; Sign-Off</div>
      </div>
      <button type="button" class="btn btn-sm btn-ghost" id="sglAuditCloseX">✕</button>
    </div>

    <!-- Security notice: SGL cannot modify submitted TL ratings -->
    <div style="background:#fef3c7;border:1px solid #fde68a;border-radius:8px;padding:10px 14px;margin-bottom:16px;display:flex;align-items:center;gap:10px;">
      <span style="font-size:16px;">🔒</span>
      <div style="font-size:12px;color:#92400e;line-height:1.4;">
        <strong>SGL Audit Mode:</strong> Submitted Team Leader ratings and criteria scores are locked for audit integrity and cannot be modified by SGL unless specifically authorized.
      </div>
    </div>

    <!-- TL Assessment Score Hero -->
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:16px;margin-bottom:18px;">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
        <span style="font-size:13px;font-weight:700;color:#1e2a63;text-transform:uppercase;letter-spacing:0.5px;">Team Leader Official Rating:</span>
        <div style="display:flex;align-items:center;gap:8px;">
          <span style="font-size:24px;font-weight:800;color:#1e2a63;font-family:var(--font-mono);" id="sglAuditScoreVal">8.5</span>
          <span style="font-size:14px;font-weight:700;color:var(--ink-dim);">/ 10.0</span>
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;">
        <span class="badge badge-evaluated" id="sglAuditGradeBadge" style="font-size:12px;padding:4px 10px;">Grade A (Outstanding)</span>
        <span style="font-size:12px;color:var(--ink-dim);" id="sglAuditEvaluatorMeta">Evaluated by Team Leader</span>
      </div>
    </div>

    <!-- Read-Only Criteria Breakdown -->
    <div style="margin-bottom:18px;">
      <div style="font-size:11.5px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);margin-bottom:10px;text-transform:uppercase;letter-spacing:0.5px;">Evaluated Marking Breakdown (7 Metrics)</div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;">
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;">
          <span style="font-size:12px;font-weight:600;color:#334155;">1. Job Performance</span>
          <span class="badge badge-score" id="sglCritJobPerf">17 / 20</span>
        </div>
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;">
          <span style="font-size:12px;font-weight:600;color:#334155;">2. Attendance</span>
          <span class="badge badge-score" id="sglCritAttendance">9 / 10</span>
        </div>
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;">
          <span style="font-size:12px;font-weight:600;color:#334155;">3. Work Performance</span>
          <span class="badge badge-score" id="sglCritWorkPerf">17 / 20</span>
        </div>
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;">
          <span style="font-size:12px;font-weight:600;color:#334155;">4. Line Performance</span>
          <span class="badge badge-score" id="sglCritLinePerf">17 / 20</span>
        </div>
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;">
          <span style="font-size:12px;font-weight:600;color:#334155;">5. Recognition</span>
          <span class="badge badge-score" id="sglCritRecognition">8 / 10</span>
        </div>
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;">
          <span style="font-size:12px;font-weight:600;color:#334155;">6. Documentation</span>
          <span class="badge badge-score" id="sglCritDocGrowth">8 / 10</span>
        </div>
        <div style="background:#fff;border:1px solid var(--panel-line);border-radius:8px;padding:10px 12px;display:flex;justify-content:space-between;align-items:center;grid-column:span 2;">
          <span style="font-size:12px;font-weight:600;color:#334155;">7. AHPS / LEAN Participation</span>
          <span class="badge badge-score" id="sglCritLean">9 / 10</span>
        </div>
      </div>
    </div>

    <!-- Official TL Comments (Read-Only) -->
    <div style="margin-bottom:18px;">
      <div style="font-size:11.5px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);margin-bottom:8px;text-transform:uppercase;letter-spacing:0.5px;">Team Leader Comments &amp; Feedback</div>
      <div style="background:#f8f9fd;border-left:3px solid #1e2a63;border-radius:4px 8px 8px 4px;padding:12px 16px;font-size:13.5px;color:#1e293b;line-height:1.5;font-style:italic;" id="sglAuditTLCommentsText">
        "No specific comments recorded by Team Leader."
      </div>
    </div>

    <!-- SGL Verification Remarks & Sign-Off -->
    <div class="field-block" style="margin-bottom:20px;">
      <label class="f" for="sglAuditRemarksInput">SGL Verification Notes &amp; Audit Sign-Off</label>
      <textarea id="sglAuditRemarksInput" rows="3" placeholder="Enter Senior Group Leader verification remarks, audit observations, or approval notes..."></textarea>
      <div class="small-note">Recorded under your SGL credential without mutating the Team Leader's scores.</div>
    </div>

    <div style="display:flex;justify-content:space-between;align-items:center;gap:10px;">
      <button type="button" class="btn btn-ghost" id="sglAuditOpenReportBtn">Open Monthly Report (Sheets 1-9)</button>
      <div style="display:flex;gap:10px;">
        <button type="button" class="btn btn-ghost" id="sglAuditCancelBtn">Close</button>
        <button type="button" class="btn btn-primary" id="sglAuditSaveRemarksBtn">Save SGL Sign-Off</button>
      </div>
    </div>
  </div>
</div>

<!-- Super Admin User Management Modal (Add/Edit Employee/Leader/Admin) -->
<div id="userMgmtModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:720px;max-height:92vh;overflow-y:auto;">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:6px;">
      <h2 id="userMgmtTitle" style="margin:0;">User Account Management</h2>
      <button type="button" class="btn btn-sm btn-ghost" id="userMgmtCloseX">Close</button>
    </div>
    <div class="modal-sub" id="userMgmtSub">Create or edit personnel profiles, system roles, plant assignments, and login credentials.</div>

    <form id="userMgmtForm" onsubmit="return false;">
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;">
        <div class="field-block">
          <label class="f" for="userMgmtEmpCode">Employee Code / Login ID *</label>
          <input type="text" id="userMgmtEmpCode" placeholder="e.g. KA1042, K01005, UA1002" required style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;font-family:var(--font-mono);font-weight:700;">
          <div class="small-note">Unique system identifier for login.</div>
        </div>
        <div class="field-block">
          <label class="f" for="userMgmtName">Full Name *</label>
          <input type="text" id="userMgmtName" placeholder="e.g. Ramesh Kumar" required style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;">
        </div>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;">
        <div class="field-block">
          <label class="f" for="userMgmtRole">System Role *</label>
          <select id="userMgmtRole" required style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;font-weight:600;">
            <option value="Employee">Employee</option>
            <option value="Team Leader (TL)">Team Leader (TL)</option>
            <option value="Senior Group Leader (SGL)">Senior Group Leader (SGL)</option>
            <option value="Unit Admin">Unit Admin</option>
            <option value="HR Head">HR Head</option>
            <option value="Super Admin">Super Admin</option>
          </select>
        </div>
        <div class="field-block">
          <label class="f" for="userMgmtUnit">Plant / State Unit *</label>
          <select id="userMgmtUnit" required style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;font-weight:600;">
            <option value="">Select Plant / Unit...</option>
          </select>
        </div>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:14px;">
        <div class="field-block">
          <label class="f" for="userMgmtDept">Department</label>
          <input type="text" id="userMgmtDept" placeholder="e.g. Operations, Assembly, Quality" value="Operations" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;">
        </div>
        <div class="field-block">
          <label class="f" for="userMgmtPassword">Passcode / Password</label>
          <input type="password" id="userMgmtPassword" placeholder="Default: Mahle@123 (or keep existing)" autocomplete="new-password" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;">
          <div class="small-note" id="userMgmtPwNote">Leave blank to keep existing password.</div>
        </div>
      </div>

      <!-- Service & Personal Profile (Auto-populates Sheet 01 'About Myself') -->
      <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:8px;padding:12px 14px;margin-bottom:14px;">
        <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;flex-wrap:wrap;gap:6px;">
          <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);text-transform:uppercase;">
            Service &amp; Personal Profile
          </div>
          <span style="font-size:11px;color:var(--mahle-blue);font-weight:600;">Auto-populates Sheet 01 'About Myself'</span>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:12px;">
          <div class="field-block">
            <label class="f" for="userMgmtJoiningDate">Date of Joining (Joined On) *</label>
            <input type="date" id="userMgmtJoiningDate" required style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;font-weight:600;">
            <div class="small-note">Mandatory for monthly assessment tracking.</div>
          </div>
          <div class="field-block">
            <label class="f" for="userMgmtDob">Date of Birth (Birth Date)</label>
            <input type="date" id="userMgmtDob" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
            <div class="small-note">Optional · can be updated later.</div>
          </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:12px;">
          <div class="field-block">
            <label class="f" for="userMgmtFatherName">Father's Name</label>
            <input type="text" id="userMgmtFatherName" placeholder="e.g. Suresh Kumar" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
            <div class="small-note">Optional · editable later by employee.</div>
          </div>
          <div class="field-block">
            <label class="f" for="userMgmtMobile">Mobile Number</label>
            <input type="tel" id="userMgmtMobile" placeholder="e.g. 9876543210" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
          </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:12px;">
          <div class="field-block">
            <label class="f" for="userMgmtEmail">Email ID</label>
            <input type="email" id="userMgmtEmail" placeholder="e.g. employee@mahle.com" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
            <div class="small-note">Optional.</div>
          </div>
          <div class="field-block">
            <label class="f" for="userMgmtDesignation">Designation</label>
            <input type="text" id="userMgmtDesignation" placeholder="e.g. Associate Engineer, Technician" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
          </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
          <div class="field-block">
            <label class="f" for="userMgmtGradeCode">Grade Code</label>
            <input type="text" id="userMgmtGradeCode" placeholder="e.g. G01, M3, O1" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
          </div>
          <div class="field-block">
            <label class="f" for="userMgmtGroupJoiningDate">Group Joining Date</label>
            <input type="date" id="userMgmtGroupJoiningDate" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;">
          </div>
        </div>
      </div>

      <div id="userMgmtSupervisorsBlock" style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:8px;padding:12px 14px;margin-bottom:14px;">
        <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);margin-bottom:10px;text-transform:uppercase;">Supervisory Hierarchy Assignment</div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
          <div class="field-block">
            <label class="f" for="userMgmtTL">Assigned Team Leader (TL)</label>
            <select id="userMgmtTL" style="width:100%;padding:7px 9px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;font-size:13px;">
              <option value="">None / Not Applicable</option>
            </select>
          </div>
          <div class="field-block">
            <label class="f" for="userMgmtSGL">Assigned Senior Group Leader (SGL)</label>
            <select id="userMgmtSGL" style="width:100%;padding:7px 9px;border:1px solid var(--panel-line);border-radius:6px;background:#fff;font-size:13px;">
              <option value="">None / Not Applicable</option>
            </select>
          </div>
        </div>
      </div>

      <div style="display:flex;align-items:center;justify-content:space-between;padding:10px 14px;background:#fafafa;border:1px solid var(--panel-line);border-radius:8px;margin-bottom:16px;">
        <div>
          <div style="font-weight:700;font-size:13.5px;">Account Activation Status</div>
          <div style="font-size:12px;color:var(--ink-dim);">Controls whether this user can sign in and participate in performance cycles.</div>
        </div>
        <label style="display:flex;align-items:center;gap:8px;cursor:pointer;font-weight:700;font-size:13px;">
          <input type="checkbox" id="userMgmtIsActive" checked style="width:18px;height:18px;cursor:pointer;">
          <span id="userMgmtActiveLabel">Active & Permitted</span>
        </label>
      </div>

      <div class="lookup-error hidden" id="userMgmtError" style="margin-bottom:14px;"></div>

      <div style="display:flex;justify-content:flex-end;gap:10px;">
        <button type="button" class="btn btn-ghost" id="userMgmtCancelBtn">Cancel</button>
        <button type="button" class="btn btn-primary" id="userMgmtSaveBtn">Save User Account</button>
      </div>
    </form>
  </div>
</div>

<!-- Monthly Assessment Cycles Management Modal -->
<div id="cycleMgmtModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:700px;">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:6px;">
      <h2 style="margin:0;">Assessment Cycles & Parameters</h2>
      <button type="button" class="btn btn-sm btn-ghost" id="cycleMgmtCloseX">Close</button>
    </div>
    <div class="modal-sub">Audit existing monthly cycles, open new assessment windows, and manage submission deadlines.</div>

    <!-- Cycle Table -->
    <div class="table-wrap" style="margin-bottom:20px;max-height:220px;overflow-y:auto;">
      <table class="data-table" style="font-size:12.5px;">
        <thead>
          <tr>
            <th>Cycle Month</th>
            <th>Title</th>
            <th>Window Range</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody id="cycleListBody">
          <tr><td colspan="5" style="text-align:center;color:var(--ink-dim);">Loading assessment cycles…</td></tr>
        </tbody>
      </table>
    </div>

    <!-- Add/Update Cycle Form -->
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:16px;margin-bottom:16px;">
      <div style="font-size:13px;font-weight:700;margin-bottom:12px;color:var(--mahle-blue);">Create or Configure Assessment Cycle</div>
      <div style="display:grid;grid-template-columns:1fr 2fr;gap:12px;margin-bottom:12px;">
        <div class="field-block">
          <label class="f" for="cycleInputMonth">Cycle Month (YYYY-MM) *</label>
          <input type="text" id="cycleInputMonth" placeholder="e.g. 2026-11" required style="width:100%;padding:7px 9px;border:1px solid var(--panel-line);border-radius:6px;font-family:var(--font-mono);font-weight:700;">
        </div>
        <div class="field-block">
          <label class="f" for="cycleInputTitle">Cycle Display Title *</label>
          <input type="text" id="cycleInputTitle" placeholder="e.g. November 2026 Assessment Cycle" required style="width:100%;padding:7px 9px;border:1px solid var(--panel-line);border-radius:6px;">
        </div>
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:12px;">
        <div class="field-block">
          <label class="f" for="cycleInputStartDate">Window Open Date</label>
          <input type="date" id="cycleInputStartDate" style="width:100%;padding:7px 9px;border:1px solid var(--panel-line);border-radius:6px;">
        </div>
        <div class="field-block">
          <label class="f" for="cycleInputEndDate">Window Closing / Due Date</label>
          <input type="date" id="cycleInputEndDate" style="width:100%;padding:7px 9px;border:1px solid var(--panel-line);border-radius:6px;">
        </div>
      </div>

      <div style="display:flex;align-items:center;justify-content:space-between;">
        <label style="display:flex;align-items:center;gap:8px;cursor:pointer;font-weight:700;font-size:13px;">
          <input type="checkbox" id="cycleInputIsOpen" checked style="width:18px;height:18px;cursor:pointer;">
          <span>Cycle is Open for Submissions & Evaluations</span>
        </label>
        <button type="button" class="btn btn-sm btn-primary" id="btnSaveCycle">Save / Open Cycle</button>
      </div>
      <div class="lookup-error hidden" id="cycleError" style="margin-top:10px;"></div>
    </div>

    <div style="display:flex;justify-content:flex-end;">
      <button type="button" class="btn btn-ghost" id="cycleCloseBtn">Close</button>
    </div>
  </div>
</div>

<!-- Plant / Unit Management Modal (Super Admin Only) -->
<div id="unitMgmtModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:580px;width:95%;">
    <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:6px;">
      <h2 id="unitMgmtTitle" style="margin:0;display:flex;align-items:center;gap:8px;">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
        <span>Plant / Unit Management</span>
      </h2>
      <button type="button" class="btn btn-sm btn-ghost" id="unitMgmtCloseX">Close</button>
    </div>
    <div class="modal-sub">Super Admin Console · Modify plant unit names and operational codes. Password verification is strictly required.</div>

    <!-- Active Units List -->
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:8px;padding:12px;margin-bottom:16px;">
      <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);margin-bottom:8px;text-transform:uppercase;">Registered Plant Units</div>
      <div id="unitMgmtList" style="display:flex;flex-direction:column;gap:6px;">
        <div style="color:var(--ink-dim);font-size:12px;">Loading units…</div>
      </div>
    </div>

    <!-- Edit Form -->
    <form id="unitMgmtForm" onsubmit="return false;" style="background:#fff;border:1px solid var(--panel-line);border-radius:10px;padding:16px;">
      <div style="font-weight:700;font-size:13.5px;color:var(--mahle-blue);margin-bottom:12px;" id="unitEditFormTitle">Select a plant above or modify below</div>
      
      <input type="hidden" id="unitEditId" value="">

      <div style="display:grid;grid-template-columns:2fr 1fr;gap:12px;margin-bottom:12px;">
        <div class="field-block">
          <label class="f" for="unitEditName">Unit / Plant Name *</label>
          <input type="text" id="unitEditName" placeholder="e.g. Gurugram Plant" required style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;font-weight:600;">
        </div>
        <div class="field-block">
          <label class="f" for="unitEditCode">Plant Code</label>
          <input type="text" id="unitEditCode" placeholder="e.g. GGN, U02" style="width:100%;padding:8px 10px;border:1px solid var(--panel-line);border-radius:6px;font-family:var(--font-mono);font-weight:700;">
        </div>
      </div>

      <!-- Password Confirmation Block -->
      <div style="background:#fff9eb;border:1px solid #fedc77;border-radius:8px;padding:12px 14px;margin-bottom:14px;">
        <label class="f" for="unitEditPassword" style="color:#854d0e;font-weight:700;display:flex;align-items:center;gap:6px;">
          <span>🔒 Super Admin Passcode Verification *</span>
        </label>
        <input type="password" id="unitEditPassword" placeholder="Enter your current password to authorize" autocomplete="current-password" required style="width:100%;padding:8px 10px;border:1px solid #facc15;border-radius:6px;background:#fff;margin-top:4px;">
        <div style="font-size:11.5px;color:#854d0e;margin-top:4px;">Security checkpoint: Re-enter your Super Admin account password to authorize changing this plant unit.</div>
      </div>

      <div class="lookup-error hidden" id="unitEditError" style="margin-bottom:12px;"></div>

      <div style="display:flex;align-items:center;justify-content:flex-end;gap:10px;">
        <button type="button" class="btn btn-ghost" id="unitEditCancelBtn">Cancel</button>
        <button type="button" class="btn btn-primary" id="unitEditSaveBtn">Authorize &amp; Rename Unit</button>
      </div>
    </form>
  </div>
</div>

<!-- Supervisor Insights & Attached Workforce Modal (Super Admin / Unit Admin / HR Head) -->
<div id="supervisorInsightsModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:940px;width:95%;max-height:92vh;overflow-y:auto;padding:24px;">
    <!-- Header -->
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:14px;border-bottom:1px solid var(--panel-line);padding-bottom:14px;">
      <div style="display:flex;align-items:center;gap:14px;">
        <div id="siAvatar" style="width:48px;height:48px;border-radius:10px;background:var(--mahle-blue);color:#fff;display:flex;align-items:center;justify-content:center;font-weight:800;font-family:var(--font-mono);font-size:16px;">
          TL
        </div>
        <div>
          <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;">
            <h2 id="siName" style="margin:0;font-size:20px;font-weight:800;">Supervisor Name</h2>
            <span class="badge badge-score" id="siRoleBadge">Team Leader (TL)</span>
            <span class="badge badge-evaluated" id="siUnitBadge">Plant Unit</span>
          </div>
          <div style="font-size:12.5px;color:var(--ink-dim);margin-top:4px;display:flex;gap:14px;flex-wrap:wrap;">
            <span>ID: <strong id="siCode" style="font-family:var(--font-mono);color:#1e2a63;">—</strong></span>
            <span>Department: <strong id="siDept">—</strong></span>
            <span id="siHierarchyMeta">Supervisory Hierarchy: —</span>
          </div>
        </div>
      </div>
      <button type="button" class="btn btn-sm btn-ghost" id="siCloseX" style="font-size:16px;line-height:1;padding:4px 10px;">✕</button>
    </div>

    <!-- Security/Scope Info Banner -->
    <div style="background:#f0f5ff;border:1px solid #c9dcfe;border-radius:8px;padding:10px 14px;margin-bottom:16px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;">
      <div style="display:flex;align-items:center;gap:8px;">
        <span style="font-size:16px;">ℹ️</span>
        <span style="font-size:12px;color:#1e40af;font-weight:600;">
          <strong>Supervisor Dossier:</strong> Supervisors do not maintain individual growth passports. This console provides oversight into team workload, evaluation rigor, and employee comments.
        </span>
      </div>
      <div style="display:flex;align-items:center;gap:6px;">
        <span style="font-size:11px;font-weight:700;color:#1e2a63;text-transform:uppercase;">Cycle:</span>
        <span class="badge badge-evaluated" id="siCycleBadge" style="font-size:11px;">October 2026</span>
      </div>
    </div>

    <!-- Supervisor KPI Stats Grid (5 Cards) -->
    <div class="stat-grid" id="siKpiGrid" style="grid-template-columns:repeat(auto-fit, minmax(150px, 1fr));gap:12px;margin-bottom:18px;">
      <div class="stat-card" style="padding:12px 14px;">
        <span class="stat-label">Attached Employees</span>
        <span class="stat-num" id="siKpiAttached" style="font-size:22px;">0</span>
        <span class="stat-sub">Mapped Workforce</span>
      </div>
      <div class="stat-card" style="padding:12px 14px;">
        <span class="stat-label">Reports Submitted</span>
        <span class="stat-num" id="siKpiSubmitted" style="font-size:22px;">0</span>
        <span class="stat-sub" id="siKpiSubRate">0% of Team</span>
      </div>
      <div class="stat-card" style="padding:12px 14px;border-left:3px solid #15803d;">
        <span class="stat-label">Evaluations Done</span>
        <span class="stat-num" id="siKpiEvaluated" style="font-size:22px;color:#15803d;">0</span>
        <span class="stat-sub" id="siKpiEvalRate">0% Rated</span>
      </div>
      <div class="stat-card" style="padding:12px 14px;border-left:3px solid #d97706;">
        <span class="stat-label">Pending Review</span>
        <span class="stat-num" id="siKpiPending" style="font-size:22px;color:#b45309;">0</span>
        <span class="stat-sub">Awaiting Marks</span>
      </div>
      <div class="stat-card" style="padding:12px 14px;">
        <span class="stat-label">Average Score</span>
        <span class="stat-num" id="siKpiAvgScore" style="font-size:22px;">—</span>
        <span class="stat-sub">Out of 10.0</span>
      </div>
    </div>

    <!-- Grade distribution pill bar -->
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:8px;padding:10px 14px;margin-bottom:18px;display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;">
      <div style="font-size:12px;font-weight:700;color:#1e2a63;">Score Distribution Awarded:</div>
      <div style="display:flex;gap:8px;flex-wrap:wrap;" id="siGradePills">
        <span style="background:#effcf6;border:1px solid #c2f0d9;border-radius:6px;padding:3px 8px;font-size:11.5px;font-weight:700;color:#15803d;">Grade A: <strong id="siGradeA">0</strong></span>
        <span style="background:#f0f5ff;border:1px solid #d0e1fd;border-radius:6px;padding:3px 8px;font-size:11.5px;font-weight:700;color:#1e40af;">Grade B: <strong id="siGradeB">0</strong></span>
        <span style="background:#fffbeb;border:1px solid #fee3a2;border-radius:6px;padding:3px 8px;font-size:11.5px;font-weight:700;color:#b45309;">Needs Review: <strong id="siGradeNeedsReview">0</strong></span>
      </div>
    </div>

    <!-- Interactive Navigation Tabs -->
    <div style="display:flex;align-items:center;gap:8px;border-bottom:2px solid var(--panel-line);margin-bottom:16px;">
      <button type="button" class="dir-pill active" id="siTabTeamBtn" style="border-radius:6px 6px 0 0;font-weight:700;padding:8px 16px;">
        👥 Attached Employees (<span id="siTabTeamCount">0</span>)
      </button>
      <button type="button" class="dir-pill" id="siTabCommentsBtn" style="border-radius:6px 6px 0 0;font-weight:700;padding:8px 16px;">
        💬 Evaluation Comments &amp; Remarks (<span id="siTabCommentsCount">0</span>)
      </button>
    </div>

    <!-- Tab 1: Attached Workforce -->
    <div id="siTabTeamContent">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;gap:10px;flex-wrap:wrap;">
        <input type="text" id="siTeamSearchInput" placeholder="Filter attached employees by name or code..." style="max-width:320px;width:100%;padding:6px 10px;border:1px solid var(--panel-line);border-radius:6px;font-size:12.5px;">
        <span style="font-size:12px;color:var(--ink-dim);" id="siTeamShownCount">Showing all mapped employees</span>
      </div>
      <div class="table-wrap" style="max-height:340px;overflow-y:auto;">
        <table class="data-table" style="font-size:12.5px;">
          <thead>
            <tr>
              <th>Emp Code</th>
              <th>Full Name</th>
              <th>Department</th>
              <th>Submission</th>
              <th>Rating / Score</th>
              <th style="min-width:140px;">Growth Passport</th>
            </tr>
          </thead>
          <tbody id="siTeamTableBody">
            <tr><td colspan="6" style="text-align:center;color:var(--ink-dim);padding:20px;">Loading attached employees…</td></tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Tab 2: Supervisor Evaluation Comments Feed -->
    <div id="siTabCommentsContent" class="hidden">
      <div style="font-size:12px;color:var(--ink-dim);margin-bottom:12px;">
        Historical evaluation comments, feedback, and marking criteria submitted by this supervisor for their team.
      </div>
      <div id="siCommentsFeed" style="display:flex;flex-direction:column;gap:12px;max-height:380px;overflow-y:auto;padding-right:4px;">
        <div style="text-align:center;color:var(--ink-dim);padding:24px;">Loading evaluation comments…</div>
      </div>
    </div>

    <!-- Modal Footer -->
    <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:20px;border-top:1px solid var(--panel-line);padding-top:14px;">
      <button type="button" class="btn btn-ghost" id="siCloseBtn">Close Dossier</button>
    </div>
  </div>
</div>

<div class="save-toast" id="saveToast">Saved</div>
` }} />;
}
