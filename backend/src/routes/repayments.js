const router = require('express').Router();
const pool = require('../config/db');
const authenticate = require('../middleware/auth');

// ── GET /api/repayments/loan/:appId ─────────────────────────────────────────
router.get('/loan/:appId', authenticate, async (req, res, next) => {
  try {
    const result = await pool.query(
      'SELECT * FROM loannova_repayments WHERE application_id = $1 ORDER BY installment_number',
      [req.params.appId]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// ── GET /api/repayments/loan/:appId/summary ──────────────────────────────────
router.get('/loan/:appId/summary', authenticate, async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT
         COUNT(*) FILTER (WHERE status = 'paid') AS paid_count,
         COUNT(*) FILTER (WHERE status = 'pending') AS pending_count,
         COUNT(*) FILTER (WHERE status = 'overdue') AS overdue_count,
         COALESCE(SUM(amount) FILTER (WHERE status = 'paid'), 0) AS total_paid,
         COALESCE(SUM(amount) FILTER (WHERE status != 'paid'), 0) AS total_remaining
       FROM loannova_repayments WHERE application_id = $1`,
      [req.params.appId]
    );
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// ── POST /api/repayments/loan/:appId/generate ────────────────────────────────
router.post('/loan/:appId/generate', authenticate, async (req, res, next) => {
  try {
    const appId = req.params.appId;
    const app = await pool.query('SELECT * FROM loannova_applications WHERE id = $1', [appId]);
    if (!app.rows.length) return res.status(404).json({ message: 'Application not found' });

    const { amount, tenure, interest_rate } = app.rows[0];
    const r = Number(interest_rate) / 12 / 100;
    const n = Number(tenure);
    const emi = r > 0
      ? Math.round((Number(amount) * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1))
      : Math.round(Number(amount) / n);

    // Clear existing schedule first
    await pool.query('DELETE FROM loannova_repayments WHERE application_id = $1', [appId]);

    let balance = Number(amount);
    const rows = [];
    for (let i = 1; i <= n; i++) {
      const interestPart = Math.round(balance * r);
      const principalPart = emi - interestPart;
      const dueDate = new Date();
      dueDate.setMonth(dueDate.getMonth() + i);
      const result = await pool.query(
        `INSERT INTO loannova_repayments
           (application_id, installment_number, due_date, amount, principal, interest, status)
         VALUES ($1,$2,$3,$4,$5,$6,'pending') RETURNING *`,
        [appId, i, dueDate.toISOString().split('T')[0], emi, principalPart, interestPart]
      );
      rows.push(result.rows[0]);
      balance -= principalPart;
    }
    res.status(201).json(rows);
  } catch (err) { next(err); }
});

// ── PUT /api/repayments/:id/pay ───────────────────────────────────────────────
router.put('/:id/pay', authenticate, async (req, res, next) => {
  try {
    const { paymentReference } = req.query;
    const result = await pool.query(
      `UPDATE loannova_repayments
       SET status = 'paid', paid_date = NOW(), payment_reference = $1
       WHERE id = $2 RETURNING *`,
      [paymentReference || `PAY-${Date.now()}`, req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Repayment not found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

module.exports = router;
