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


    <div class="who">
      <div class="who-text">
        <div class="who-name" id="whoName">—</div>
        <div class="who-role-row">
          <span class="who-role" id="whoRole">—</span>
          <span class="who-unit" id="whoUnitBadge"></span>
        </div>
      </div>
      <div class="avatar" id="whoAvatar">—</div>
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
          <button type="button" class="active" data-role="employee">Shop Floor Employee</button>
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
                  <span class="emp-hero-pill" id="empHeroRole">Shop Floor Employee</span>
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

          <!-- Current Month Scorecard -->
          <div id="employeeScorecard" class="hidden"></div>

          <!-- 10 Sections Quick-Jump Hub -->
          <div class="emp-sheets-title-row">
            <div>
              <h3 style="margin:0;font-family:var(--font-display);font-size:17px;">Growth Performance Passport · 10 Sections</h3>
              <p style="margin:2px 0 0;font-size:12.5px;color:var(--ink-dim);">Select any section below to update daily records, competencies, and performance metrics.</p>
            </div>
            <span class="badge badge-score">10 Sections Active</span>
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
            <button type="button" class="hidden" id="btnAdminCycles"></button>

            <div class="unit-filter-bar" id="unitFilterBar">
              <span class="unit-filter-label">Filter Unit:</span>
              <button class="unit-pill active" data-unit="all">All Units</button>
              <button class="unit-pill" data-unit="Gurugram">Gurugram</button>
              <button class="unit-pill" data-unit="State Unit 2">State Unit 2</button>
              <button class="unit-pill" data-unit="State Unit 3">State Unit 3</button>
              <button class="unit-pill" data-unit="State Unit 4">State Unit 4</button>
            </div>

            <div class="stat-grid" id="adminKpiGrid">
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
          </div>

          <!-- Unit Admin View -->
          <div id="homeUnitAdminView" class="hidden" style="margin-bottom:20px;">
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
          <div id="homeTLView" class="hidden" style="margin-bottom:20px;">
            <!-- TL KPI Stats Grid -->
            <div class="stat-grid" id="tlKpiGrid">
              <div class="stat-card">
                <span class="stat-label">Assigned Team</span>
                <span class="stat-num" id="tlKpiTotal">0</span>
                <span class="stat-sub">Shop Floor Staff</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Submissions</span>
                <span class="stat-num" id="tlKpiSubmitted">0</span>
                <span class="stat-sub" id="tlKpiSubRate">0% Submission</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Evaluations Done</span>
                <span class="stat-num" id="tlKpiEvaluated">0</span>
                <span class="stat-sub" id="tlKpiEvalRate">0% Completed</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Team Avg Score</span>
                <span class="stat-num" id="tlKpiAvgScore">—</span>
                <span class="stat-sub">1.0 - 10.0 Scale</span>
              </div>
            </div>
          </div>

          <!-- SGL Team View -->
          <div id="homeSGLView" class="hidden" style="margin-bottom:20px;">
            <!-- SGL KPI Stats Grid -->
            <div class="stat-grid" id="sglKpiGrid">
              <div class="stat-card">
                <span class="stat-label">Group Members</span>
                <span class="stat-num" id="sglKpiTotal">0</span>
                <span class="stat-sub">Under Supervision</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Submissions</span>
                <span class="stat-num" id="sglKpiSubmitted">0</span>
                <span class="stat-sub" id="sglKpiSubRate">0% Submission</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Evaluated by TL</span>
                <span class="stat-num" id="sglKpiEvaluated">0</span>
                <span class="stat-sub" id="sglKpiEvalRate">0% Completed</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Group Avg Score</span>
                <span class="stat-num" id="sglKpiAvgScore">—</span>
                <span class="stat-sub">1.0 - 10.0 Scale</span>
              </div>
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
        <div class="inbox-toolbar">
          <div class="inbox-search-wrap">
            <input type="text" id="inboxSearchInput" placeholder="Filter submissions by Name, ID, or Unit...">
          </div>
          <div class="inbox-filters" id="inboxFilters">
            <button class="inbox-pill active" data-filter="all">All Submissions</button>
            <button class="inbox-pill" data-filter="pending">Awaiting Evaluation</button>
            <button class="inbox-pill" data-filter="evaluated">Evaluated</button>
          </div>
          <span class="inbox-count-badge" id="inboxCountBadge">Showing entries</span>
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
          <div style="display:flex;align-items:center;gap:12px;flex:1;min-width:280px;">
            <div class="dir-search-wrap" style="flex:1;">
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
          <div style="display:flex;align-items:center;gap:8px;">
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
                  <th>Team Leader</th>
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
            <div class="table-header">
              <div class="table-title">Group Overview & Assessment Audit</div>
            </div>
            <table class="data-table">
              <thead>
                <tr>
                  <th>Emp ID</th>
                  <th>Employee Name</th>
                  <th>Team Leader</th>
                  <th>Status</th>
                  <th>TL Score (1-10)</th>
                  <th>Review</th>
                </tr>
              </thead>
              <tbody id="sglTeamBody"></tbody>
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
            <button class="lookup-chip" data-id="KA1042">KA1042 · Shop Floor Operator</button>
            <button class="lookup-chip" data-id="NTK1042">NTK1042 · Shop Floor Operator</button>
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

    <!-- GROWTH MENU / RECORD -->
    <section id="screen-menu" class="hidden">
      <div class="menu-wrap">
        <div id="recordHeader" class="record-header hidden">
          <div>
            <div class="rh-name" id="rhName">—</div>
            <div class="rh-sub" id="rhSub">—</div>
          </div>
          <button class="btn btn-dark" id="rhMarkReviewedBtn">Mark Reviewed</button>
        </div>
        <div class="eyebrow" id="menuEyebrow">Growth Performance</div>
        <h1>Growth Performance Sections</h1>
        <p class="menu-lead">Choose any section below to view/edit, or use the direct components in the sidebar.</p>

        <div class="submit-box hidden" id="submitBox">
          <div>
            <div class="sb-title">Submit this month to your supervisor</div>
            <div class="sb-status" id="submitStatus">Not submitted yet for <span id="submitMonthLabel"></span></div>
          </div>
          <button class="btn btn-primary" id="submitBtn">Submit This Month</button>
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
            <div class="crumb" id="formCrumb">Growth Performance</div>
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

<!-- TL Evaluation Modal (1 to 10 Scoring) -->
<div id="evalModal" class="modal-backdrop hidden">
  <div class="modal-card">
    <h2 id="evalModalTitle">Evaluate Employee</h2>
    <div class="modal-sub" id="evalModalSub">Monthly Assessment (Scale 1.0 - 10.0)</div>
    
    <div style="background:#f8f9fd;border:1px solid var(--panel-line);border-radius:10px;padding:16px;margin-bottom:18px;">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
        <label style="font-weight:700;font-size:14px;">Overall Score (1.0 to 10.0):</label>
        <div style="display:flex;align-items:center;gap:8px;">
          <input type="number" id="evalOverallScore" min="1.0" max="10.0" step="0.1" value="8.5" style="width:80px;font-size:16px;font-weight:700;text-align:center;padding:6px;border:2px solid #1e2a63;border-radius:6px;font-family:var(--font-mono);">
          <span style="font-weight:700;color:var(--ink-dim);">/ 10</span>
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;align-items:center;">
        <span style="font-size:12px;color:var(--ink-dim);">Rating Tier:</span>
        <span class="badge badge-evaluated" id="evalGradeBadge">Grade A (Outstanding)</span>
      </div>
    </div>

    <div style="margin-bottom:16px;">
      <div style="font-size:12px;font-family:var(--font-mono);font-weight:700;color:var(--ink-dim);margin-bottom:10px;text-transform:uppercase;">Criteria Breakdown (1 - 10)</div>
      <div class="criteria-row">
        <label>1. Safety & 5S Discipline</label>
        <input type="number" id="cSafety" min="1" max="10" step="0.5" value="8.5">
      </div>
      <div class="criteria-row">
        <label>2. Quality & Defect Prevention</label>
        <input type="number" id="cQuality" min="1" max="10" step="0.5" value="8.5">
      </div>
      <div class="criteria-row">
        <label>3. Productivity & Output Target</label>
        <input type="number" id="cProd" min="1" max="10" step="0.5" value="8.5">
      </div>
      <div class="criteria-row">
        <label>4. Attendance & Punctuality</label>
        <input type="number" id="cAttend" min="1" max="10" step="0.5" value="9.0">
      </div>
      <div class="criteria-row">
        <label>5. Kaizen & Improvement Ideas</label>
        <input type="number" id="cKaizen" min="1" max="10" step="0.5" value="8.0">
      </div>
    </div>

    <div class="field-block">
      <label class="f" for="evalComments">Supervisor Remarks / Feedback</label>
      <textarea id="evalComments" rows="3" placeholder="Enter comments and guidance for the employee..."></textarea>
    </div>

    <div style="display:flex;justify-content:flex-end;gap:10px;margin-top:20px;">
      <button type="button" class="btn btn-ghost" id="evalCancelBtn">Cancel</button>
      <button type="button" class="btn btn-primary" id="evalSubmitBtn">Submit Assessment</button>
    </div>
  </div>
</div>

<!-- Super Admin User Management Modal (Add/Edit Employee/Leader/Admin) -->
<div id="userMgmtModal" class="modal-backdrop hidden">
  <div class="modal-card" style="max-width:640px;">
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
            <option value="Shop Floor Employee">Shop Floor Employee</option>
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

<div class="save-toast" id="saveToast">Saved</div>
` }} />;
}
