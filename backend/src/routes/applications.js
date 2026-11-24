const router = require('express').Router();
const pool = require('../config/db');
const authenticate = require('../middleware/auth');

function calcEmi(amount, rate, months) {
  if (!amount || !rate || !months) return 0;
  const r = rate / 12 / 100;
  if (r === 0) return Math.round(amount / months);
  return Math.round((amount * r * Math.pow(1 + r, months)) / (Math.pow(1 + r, months) - 1));
}

// ── GET /api/applications  (web global list) ─────────────────────────────────
router.get('/', authenticate, async (req, res, next) => {
  try {
    const result = await pool.query(
      'SELECT * FROM loannova_applications ORDER BY applied_date DESC'
    );
    res.json({ count: result.rows.length, applications: result.rows });
  } catch (err) { next(err); }
});

// ── GET /api/applications/user/:userId (Flutter) ──────────────────────────
router.get('/user/:userId', authenticate, async (req, res, next) => {
  try {
    const userId = parseInt(req.params.userId);
    const result = await pool.query(
      'SELECT * FROM loannova_applications WHERE user_id = $1 ORDER BY applied_date DESC',
      [userId]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// ── POST /api/applications  (web) ────────────────────────────────────────────
router.post('/', authenticate, async (req, res, next) => {
  try {
    const b = req.body;
    const id = `APP-${Math.floor(10000 + Math.random() * 90000)}`;
    const emi = calcEmi(Number(b.amount), Number(b.interestRate), Number(b.tenure));
    const result = await pool.query(
      `INSERT INTO loannova_applications
         (id, user_id, product_name, type, bank, amount, tenure, interest_rate, emi,
          applicant_name, phone, email, pan, employment, monthly_income, kyc_status, status, stage)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,'Verified','Under Review',2)
       RETURNING *`,
      [id, req.user.userId, b.productName, b.type, b.bank, Number(b.amount), Number(b.tenure),
       Number(b.interestRate), emi, b.applicantName, b.phone, b.email,
       b.pan ? b.pan.toUpperCase() : null, b.employment, b.monthlyIncome]
    );
    res.status(201).json({ success: true, application: result.rows[0] });
  } catch (err) { next(err); }
});

// ── POST /api/applications/user/:userId/loan/:loanId (Flutter) ──────────────
router.post('/user/:userId/loan/:loanId', authenticate, async (req, res, next) => {
  try {
    const userId = parseInt(req.params.userId);
    const loanId = req.params.loanId;
    const { requestedAmount, tenure } = req.body;

    const loan = await pool.query('SELECT * FROM loannova_products WHERE id = $1', [loanId]);
    if (!loan.rows.length) return res.status(404).json({ message: 'Loan product not found' });
    const p = loan.rows[0];

    const user = await pool.query('SELECT name, email, phone, pan FROM loannova_users WHERE id = $1', [userId]);
    if (!user.rows.length) return res.status(404).json({ message: 'User not found' });
    const u = user.rows[0];

    const id = `APP-${Math.floor(10000 + Math.random() * 90000)}`;
    const emi = calcEmi(Number(requestedAmount), Number(p.interest_rate), Number(tenure));

    const result = await pool.query(
      `INSERT INTO loannova_applications
         (id, user_id, product_id, product_name, type, bank, amount, tenure, interest_rate,
          emi, applicant_name, phone, email, pan, kyc_status, status, stage)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,'Verified','Under Review',2)
       RETURNING *`,
      [id, userId, loanId, p.name, p.sub_type, p.bank, Number(requestedAmount),
       Number(tenure), Number(p.interest_rate), emi,
       u.name, u.phone, u.email, u.pan]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) { next(err); }
});

// ── PATCH /api/applications/:id  (status update) ────────────────────────────
router.patch('/:id', authenticate, async (req, res, next) => {
  try {
    const { status, stage } = req.body;
    const result = await pool.query(
      `UPDATE loannova_applications SET status = COALESCE($1, status), stage = COALESCE($2, stage), updated_at = NOW()
       WHERE id = $3 RETURNING *`,
      [status, stage, req.params.id]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Application not found' });
    res.json({ success: true, application: result.rows[0] });
  } catch (err) { next(err); }
});

module.exports = router;
