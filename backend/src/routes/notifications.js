const router = require('express').Router();
const pool = require('../config/db');
const authenticate = require('../middleware/auth');

// ── GET /api/notifications/user/:userId ──────────────────────────────────────
router.get('/user/:userId', authenticate, async (req, res, next) => {
  try {
    const result = await pool.query(
      'SELECT * FROM loannova_notifications WHERE user_id = $1 ORDER BY created_at DESC LIMIT 50',
      [parseInt(req.params.userId)]
    );
    res.json(result.rows);
  } catch (err) { next(err); }
});

// ── GET /api/notifications/user/:userId/unread-count ─────────────────────────
router.get('/user/:userId/unread-count', authenticate, async (req, res, next) => {
  try {
    const result = await pool.query(
      'SELECT COUNT(*) FROM loannova_notifications WHERE user_id = $1 AND is_read = FALSE',
      [parseInt(req.params.userId)]
    );
    res.json({ count: parseInt(result.rows[0].count) });
  } catch (err) { next(err); }
});

// ── PUT /api/notifications/:id/read ─────────────────────────────────────────
router.put('/:id/read', authenticate, async (req, res, next) => {
  try {
    const result = await pool.query(
      'UPDATE loannova_notifications SET is_read = TRUE WHERE id = $1 RETURNING *',
      [parseInt(req.params.id)]
    );
    if (!result.rows.length) return res.status(404).json({ message: 'Notification not found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// ── PUT /api/notifications/user/:userId/read-all ─────────────────────────────
router.put('/user/:userId/read-all', authenticate, async (req, res, next) => {
  try {
    await pool.query(
      'UPDATE loannova_notifications SET is_read = TRUE WHERE user_id = $1',
      [parseInt(req.params.userId)]
    );
    res.json({ message: 'All notifications marked as read' });
  } catch (err) { next(err); }
});

module.exports = router;
