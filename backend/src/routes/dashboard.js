const router = require('express').Router();
const pool = require('../config/db');
const authenticate = require('../middleware/auth');

// ── GET /api/dashboard/user/:userId  (Flutter) ──────────────────────────────
router.get('/user/:userId', authenticate, async (req, res, next) => {
  try {
    const userId = parseInt(req.params.userId);
    const [userRes, appsRes, unreadRes] = await Promise.all([
      pool.query('SELECT name, credit_score, wallet_balance FROM loannova_users WHERE id = $1', [userId]),
      pool.query('SELECT COUNT(*) FROM loannova_applications WHERE user_id = $1', [userId]),
      pool.query('SELECT COUNT(*) FROM loannova_notifications WHERE user_id = $1 AND is_read = FALSE', [userId]),
    ]);
    if (!userRes.rows.length) return res.status(404).json({ message: 'User not found' });
    const u = userRes.rows[0];
    res.json({
      name: u.name,
      creditScore: u.credit_score,
      walletBalance: `₹${Number(u.wallet_balance).toLocaleString('en-IN')}`,
      activeApplications: parseInt(appsRes.rows[0].count),
      unreadNotifications: parseInt(unreadRes.rows[0].count),
      preApprovedLimit: '₹12,50,000',
      nextEmiDue: '₹9,750 on 05 Dec 2026',
    });
  } catch (err) { next(err); }
});

// ── GET /api/dashboard/stats  (web — aggregate stats) ───────────────────────
router.get('/stats', authenticate, async (req, res, next) => {
  try {
    const [users, apps] = await Promise.all([
      pool.query('SELECT COUNT(*) FROM loannova_users'),
      pool.query('SELECT COUNT(*) FROM loannova_applications'),
    ]);
    res.json({
      customer: { activeApplications: parseInt(apps.rows[0].count), preApprovedLimit: '₹12,50,000', creditScore: 765, walletBalance: '₹4,200', nextEmiDue: '₹9,750 on 05 Dec 2026' },
      partner: { totalLeads: 148, approvedToday: 19, disbursedVolume: '₹1.84 Crore', averageTurnaround: '4.2 Hours', commissionEarned: '₹94,500' },
      admin: { registeredUsers: parseInt(users.rows[0].count).toLocaleString('en-IN'), totalApplications: parseInt(apps.rows[0].count).toLocaleString('en-IN'), systemHealth: '99.99% Uptime', fraudAttemptsBlocked: '342 (100% Cleared)', activeLendingPartners: 24 },
    });
  } catch (err) { next(err); }
});

module.exports = router;
