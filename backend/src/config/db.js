const { Pool } = require('pg');
const { DATABASE_URL } = require('./env');

const isLocal =
  !DATABASE_URL ||
  DATABASE_URL.includes('localhost') ||
  DATABASE_URL.includes('127.0.0.1');

const pool = new Pool({
  connectionString: DATABASE_URL,
  ssl: isLocal ? false : { rejectUnauthorized: false },
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 10000,
});

pool.on('error', (err) => {
  console.error('[DB] Unexpected error on idle client:', err.message);
});

module.exports = pool;
