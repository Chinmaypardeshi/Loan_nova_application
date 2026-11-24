// Runs schema.sql against Supabase PostgreSQL
// Usage: node src/db/migrate.js

const fs = require('fs');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const pool = require('../config/db');

async function migrate() {
  const sql = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf8');
  const client = await pool.connect();
  try {
    console.log('[migrate] Running schema...');
    await client.query(sql);
    console.log('[migrate] ✅ All tables created / verified.');
  } finally {
    client.release();
    await pool.end();
  }
}

migrate().catch((err) => {
  console.error('[migrate] ❌ Failed:', err.message);
  process.exit(1);
});
