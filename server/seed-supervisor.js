// Create or reset a supervisor account.
//
// Usage:
//   node seed-supervisor.js K0204 "SomeStrongPassword123"
//
// If the supervisor ID already exists, this resets its password instead of
// creating a duplicate. Run this locally or via your host's console/shell -
// never put real passwords in your Git repo or chat history.

const bcrypt = require('bcryptjs');
const store = require('./db');

const [, , rawId, password] = process.argv;

if (!rawId || !password) {
  console.log('Usage: node seed-supervisor.js <SupervisorID> <Password>');
  console.log('Example: node seed-supervisor.js K0204 "SomeStrongPassword123"');
  process.exit(1);
}

const id = rawId.trim().toUpperCase();

if (!/^K0/i.test(id)) {
  console.error('Supervisor IDs must start with "K0". Got:', id);
  process.exit(1);
}
if (password.length < 6) {
  console.error('Password must be at least 6 characters.');
  process.exit(1);
}

const hash = bcrypt.hashSync(password, 10);
const existing = store.getSupervisor(id);

store.upsertSupervisor(id, hash);
console.log(existing ? `Password reset for existing supervisor ${id}.` : `Supervisor account ${id} created.`);
