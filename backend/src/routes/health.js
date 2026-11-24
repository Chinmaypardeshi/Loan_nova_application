const router = require('express').Router();
const pool = require('../config/db');

router.get('/', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'online', platform: 'LoanNova Backend v2.0', db: 'Supabase PostgreSQL', timestamp: new Date().toISOString() });
  } catch {
    res.status(503).json({ status: 'degraded', message: 'DB unreachable', timestamp: new Date().toISOString() });
  }
});

module.exports = router;
