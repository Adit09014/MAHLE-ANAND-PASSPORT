# Mahle Growth Passport — Server

A real backend for the Growth Passport portal: Node.js + Express + SQLite,
with hashed passwords, employee/supervisor roles, and the KA / NTK / K0
ID rules enforced on the server.

## What's inside
- `index.js` — the web server (routes, auth, sessions)
- `db.js` — a plain JSON-file database (creates `data/growth.json` automatically).
  No native modules to compile — this was changed from SQLite specifically so
  it installs reliably on hosts like Render without build errors.
- `seed-supervisor.js` — command you run to create/reset a supervisor login
- `public/index.html` — the site itself (frontend)
- `.env.example` — copy to `.env` and fill in

## 1. Run it on your own computer first (recommended)
You'll need [Node.js](https://nodejs.org) installed (version 18 or newer).

```bash
cd server
npm install
cp .env.example .env
```
Open `.env` and replace the two placeholder secrets with random strings.
Easiest way to generate one:
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```
Run that twice — once for `SESSION_SECRET`, once for `ADMIN_KEY`.

Create your first supervisor account:
```bash
node seed-supervisor.js K0204 "SomeStrongPassword123"
```

Start the server:
```bash
npm start
```
Visit **http://localhost:3000** — log in as an employee with any ID starting
`KA` or `NTK` (password = same ID), or as the supervisor account you just made.

## 2. Put it on the internet (Render.com — free to start, simplest option)

1. Create a free account at [render.com](https://render.com).
2. Put this `server` folder in a GitHub repository (Render deploys from Git).
   - Easiest: create a new repo on GitHub, upload these files to it.
3. In Render: **New → Web Service**, connect that GitHub repo.
4. Settings:
   - **Root directory:** `server`
   - **Build command:** `npm install`
   - **Start command:** `npm start`
5. Under **Environment**, add:
   - `SESSION_SECRET` = (a random string, see command above)
   - `ADMIN_KEY` = (a different random string)
   - `NODE_ENV` = `production`
6. Under **Disks**, add a persistent disk (e.g. 1 GB) mounted at `/opt/render/project/src/server/data`
   — **this step matters**: without it, your database resets every time you deploy.
7. Click **Create Web Service**. Render gives you a live URL like
   `https://mahle-growth-passport.onrender.com` — that's the link you send
   to employees and supervisors.
8. Open Render's **Shell** tab (or use the same commands locally against
   the same disk) to run `node seed-supervisor.js K0204 "password"` and
   create real supervisor accounts.
9. Optional: in Render, add a **Custom Domain** (e.g. `growth.mahle.com`)
   if you own that domain — Render issues the HTTPS certificate for you
   automatically.

Free Render web services sleep after inactivity and wake up on the next
visit (a few seconds' delay) — fine for internal tools; upgrade to a paid
instance if you want it always-on.

## 3. Viewing / backing up the data (you keep full access)
- The database is a single file: `server/data/growth.json`. It's plain
  text — you can open it directly in any text editor to see everything
  stored: employees, submissions, and all 10 sheets per employee.
- There's also a built-in export: visit
  `https://your-site-url/api/admin/export?key=YOUR_ADMIN_KEY`
  in a browser to get a full JSON dump of employees, sheet data, and
  submissions (password hashes are never included).
- Back up by simply copying `growth.db` somewhere safe on a regular basis.

## Notes on this being a "just me" setup
- Supervisor accounts are created by you via `seed-supervisor.js` — there's
  no public supervisor sign-up, which is intentional.
- Employee accounts are created automatically the first time someone logs
  in with a valid KA/NTK ID (password = their ID, as requested).
- Sessions are kept in server memory, which is fine for a single small
  instance. If you ever need multiple server instances for heavy traffic,
  swap in a shared session store (e.g. Redis) — flag it if you get there
  and it can be added.
