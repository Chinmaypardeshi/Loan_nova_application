const router = require('express').Router();
const bcrypt = require('bcryptjs');
const pool = require('../config/db');
const authenticate = require('../middleware/auth');

// ── GET /api/users/:userId ──────────────────────────────────────────────────
router.get('/:userId', authenticate, async (req, res, next) => {
  try {
    const id = parseInt(req.params.userId);
    const result = await pool.query(
      `SELECT id, name, email, phone, role, credit_score, wallet_balance, pan, created_at
       FROM loannova_users WHERE id = $1`,
      [id]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'User not found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// ── PUT /api/users/:userId/password ─────────────────────────────────────────
router.put('/:userId/password', authenticate, async (req, res, next) => {
  try {
    const id = parseInt(req.params.userId);
    if (req.user.userId !== id) return res.status(403).json({ message: 'Forbidden' });
    const { currentPassword, newPassword } = req.body;
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ message: 'currentPassword and newPassword required' });
    }
    const result = await pool.query('SELECT password_hash FROM loannova_users WHERE id = $1', [id]);
    if (!result.rows.length) return res.status(404).json({ message: 'User not found' });
    const match = await bcrypt.compare(currentPassword, result.rows[0].password_hash);
    if (!match) return res.status(401).json({ message: 'Current password is incorrect' });
    const hash = await bcrypt.hash(newPassword, 12);
    await pool.query('UPDATE loannova_users SET password_hash = $1, updated_at = NOW() WHERE id = $2', [hash, id]);
    res.json({ message: 'Password changed successfully' });
  } catch (err) { next(err); }
});

module.exports = router;
