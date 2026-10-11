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
      <div class="word">Growth Passport<br>Shop Floor Performance Record</div>
    </div>
    <div class="who">
      <div class="who-text">
        <div class="who-name" id="whoName">—</div>
        <div class="who-role" id="whoRole">—</div>
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
            <div class="lv-caption">Track performance. Build growth. Every year.</div>
          </div>
        </div>
        <div class="login-panel">
          <img class="login-logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAARcAAAA9CAYAAACHky0wAAAFZ0lEQVR4nO3dy4scRRwH8O+3umd3NiZRhKCY1+4aiJLsahADHgSj/gchIB50NgfFgw8ExQeiFz15EA8eQg5J8OAfoGAOuQhiQIKEzaKE6I6axyGaRDZuMo/6/TxsIj5n51WTnuz3c66aqm7ob09Xd1VxcqrikH8hM2RsbDh5/NCZdspPTlUugrwNPiynkwC8YQtYW60euNqq5Lpte1av4arnQb7XVUsMcI+zNDz3/dzBLzutv2XHzDqrx5dDPvqaWaObLjgcZ2tNu+/Md4d+bVVw69a9a2olOxro9wJkpw2FrIQYm2+tsrEP5uY+utxNZ9tx546ZdeWmvZGHkZe6PCfJhRvdARG5OSlcRCQJhYuIJKFwEZEkFC4ikoTCRUSSULiISBIKFxFJQuEiIkkoXEQkCYWLiCShcBGRJPIe6zuZkQwAlpuwR5g3AXfH0qy5LhAh5G215TC4xR7aGignA8kMyx/bdYS7wX1ojlEKhwghw7VJrH3/9Z7ChQx0j18bmt8SGGlV1g11ko+QYZO7ddMY3P1C9NpnBEst23I0Sawns11dtTVgS+fRjhvi8eXO43UO1AncQ2Y7h+EYpXDczRYi7DCBJtj/G1Rv4RJyxFj7NGa1/VmzvLZlYcclAAdCyLoKFyIAiGfqxOu5cU2rssFsEQyPM892eSz+hceQw2L9iJXi+6znt7ZTpxlsoWScCVm+02M9dRflJuTABVp8F3m4Yhb6PkTSW7iACM7T1W8+OQvg7HLlJ6Yrl7rORxJwLJ5uc32V8e2VH8LQDCkRcJ778djH5wCca7fW3dMzPye44cgKQYba/ImJWeCdJHfgnq4+B0B62wEVvMer3du/kgiUUjxHpkJ61mkdM8uH5wilcNw5Pl5t6zG8G8NyaxeRIaNwEZEkFC4ikoTCRUSSULjIYDii0Re6qTpav/wbiJY7FEjnnLDldn7oRa9f6Iosy90AYgsR9k9sr1wgO7qp+VVgFMBm82aqLq5EJLFpcqpyBEBM0YDCRQYkrGbIHgxdfJfjcNAN7qapDn1EcFUI+aOpfl/hIgPicGv2+uWRgqWvHCk3VNOYi4gkoXARkSQULiKShMJliBHU1CIpLIXLEHO4BjilsPS2qAAs1uHwtye2P/0K4G0GPg1E2bSWixSUwqUQHEQYQ8BYh9UwTMtKyMqicCkMV07ITUVjLiKShMJFRJLQY5EMCMEQQLCjp78/N73Q3KIErm/Vk4bCRQbC4b/D4ikDLhLoZL1gM2CUwHqQG+EamOoXhy+aNY5Cs6JlWJEB8DjvwAvzswe/wAPPtNx36m+O7Wts3PrEXaWR0RcDS6+ap5tot8K4O36aP3HgsVQNKFxkUDx4XFqQ5di+jhJizFlvepq760pGRxgfr5RTLRilAV0ZHM+6Gi+xW8qE62vkYaNwEZEkFC4ikoTCRUSS0IBuYbDzLzg0t6iACLrFcrlZu9E9WRbp1ermZDNfFS6F4XUYaiDbixh3BzACYjRtv6Qj7gB4xy+LjanJ+59csDjS8R7g/1SdHT+ZYrN4dxud2HZqivlTV8xC359iFC4FwJDDLR4x2OdA2zOjrwbgYYZ8t5u23CgK9wgHdoXc1iOWGoHdv+VykIT7hofm9p7+Clf62U8AIHA7QvYmDM1e+vl/FC4FEJghsnm4Onvww07qTU5VzgfmuyMULkXhbh5CmCbD9F8mL3RpqX75/MizQN/DhQxhbQjZnt77+d8ULgVwbeik3HE99zHXmEvR0JfmQfXtB9O9dXFYwn+9elskIkkoXEQkCYWLiCShcBGRJBQuIpKEwkVEklC4iEgSChcRSULhIiJJKFxEJAmFi4gkoXARkST+AIJPzrvPGB5jAAAAAElFTkSuQmCC" alt="Mahle">
          <h1 id="loginHeading">Sign In</h1>
          <div class="role-toggle" id="roleToggle">
            <button type="button" class="active" data-role="employee">Employee</button>
            <button type="button" data-role="supervisor">Supervisor</button>
          </div>
          <div class="field">
            <label for="loginId" id="loginIdLabel">Employee ID</label>
            <input type="text" id="loginId" placeholder="e.g. KA1042 or NTK1042" autocomplete="username">
          </div>
          <div class="field">
            <label for="loginPw" id="loginPwLabel">Password</label>
            <input type="password" id="loginPw" placeholder="Password" autocomplete="current-password">
          </div>
          <div class="login-note" id="loginNote">Enter your Employee ID and password to continue.</div>
          <div class="login-error" id="loginError"></div>
          <button class="btn btn-primary" id="loginBtn">Sign In</button>
        </div>
      </div>
    </section>

  <div id="appBody" class="hidden">
    <nav id="sidebar"></nav>
    <main>


    <!-- HOME -->
    <section id="screen-home" class="hidden">
      <div class="home-wrap">
        <div class="eyebrow" id="homeEyebrow">Home</div>
        <h1 id="homeGreeting">Welcome</h1>
        <p class="lead" id="homeLead">This is your growth profile. It keeps you updated on your performance through the year and helps you plan further improvement.</p>

        <!-- Employee view -->
        <div id="homeEmployee">
          <button class="tile-go" id="goGrowthBtn" style="width:100%;border:1px solid var(--panel-line);">
            <div class="t-left">
              <div class="icon">&#9733;</div>
              <div>
                <div class="t-title">Growth Performance</div>
                <div class="t-sub">Open your 10-point growth record</div>
              </div>
            </div>
            <div class="arrow">&#8594;</div>
          </button>
        </div>

        <!-- Supervisor view -->
        <div id="homeSupervisor" class="hidden">
          <button class="tile-go" id="goInboxBtn" style="width:100%;border:1px solid var(--panel-line);margin-bottom:14px;">
            <div class="t-left">
              <div class="icon">&#128203;</div>
              <div>
                <div class="t-title">Submissions Inbox</div>
                <div class="t-sub">Records employees have submitted this month</div>
              </div>
            </div>
            <div class="arrow">&#8594;</div>
          </button>
          <div class="tile-go" style="cursor:default;">
            <div class="t-left" style="width:100%;">
              <div class="icon">&#128269;</div>
              <div style="width:100%;">
                <div class="t-title">Look Up an Employee</div>
                <div class="t-sub">Open any employee's record directly by ID</div>
                <div class="lookup-row">
                  <input type="text" id="lookupId" placeholder="Employee ID (KA... or NTK...)">
                  <button class="btn btn-primary" id="lookupBtn">Open Record</button>
                </div>
                <div class="lookup-error" id="lookupError"></div>
              </div>
            </div>
          </div>

          <div class="tile-go" style="cursor:default;margin-top:14px;">
            <div class="t-left" style="width:100%;">
              <div class="icon">&#128273;</div>
              <div style="width:100%;">
                <div class="t-title">Change Password</div>
                <div class="t-sub">Update the supervisor sign-in passcode</div>
                <div class="lookup-row" style="flex-direction:column;align-items:stretch;">
                  <input type="password" id="pwCurrent" placeholder="Current passcode">
                  <input type="password" id="pwNew" placeholder="New passcode">
                  <input type="password" id="pwConfirm" placeholder="Confirm new passcode">
                  <button class="btn btn-primary" id="changePwBtn" style="width:100%;">Update Password</button>
                </div>
                <div class="lookup-error" id="pwError"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- SUPERVISOR INBOX -->
    <section id="screen-inbox" class="hidden">
      <div class="menu-wrap">
        <div class="eyebrow">Supervisor</div>
        <h1>Submissions Inbox</h1>
        <div id="inboxList"></div>
        <button class="btn btn-ghost" id="inboxBackBtn" style="margin-top:14px;">&#8592; Home</button>
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
        <h1>Choose a section</h1>

        <div class="submit-box hidden" id="submitBox">
          <div>
            <div class="sb-title">Submit this month to your supervisor</div>
            <div class="sb-status" id="submitStatus">Not submitted yet for <span id="submitMonthLabel"></span></div>
          </div>
          <button class="btn btn-primary" id="submitBtn">Submit This Month</button>
        </div>

        <div class="dropdown-row">
          <select id="sheetDropdown">
            <option value="">— Select a section —</option>
          </select>
          <button class="btn btn-primary" id="dropdownGoBtn">Open</button>
          <button class="btn btn-ghost" id="backHomeBtn">&#8592; Home</button>
        </div>
        <div class="station-grid" id="stationGrid"></div>
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
            <button class="btn btn-ghost" id="backMenuBtn">&#8592; All sections</button>
            <button class="btn btn-primary" id="saveBtn">Save</button>
          </div>
        </div>
        <div class="sheet" id="sheetContainer"></div>
      </div>
    </section>
    </main>
  </div>
</div>
<div class="save-toast" id="saveToast">Saved</div>

` }} />;
}
