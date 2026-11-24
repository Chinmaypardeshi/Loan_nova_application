const router = require('express').Router();

// In-memory per-session credit scores (keyed by userId)
const scores = {};

function getScore(userId) {
  if (!scores[userId]) scores[userId] = { score: 765, status: 'Excellent' };
  return scores[userId];
}
function labelFor(s) {
  return s >= 750 ? 'Excellent' : s >= 700 ? 'Good' : s >= 650 ? 'Fair' : 'Needs Attention';
}

// ── GET /api/credit-score ─────────────────────────────────────────────────────
router.get('/', (req, res) => {
  const userId = req.query.userId || 'guest';
  const cs = getScore(userId);
  res.json({
    score: cs.score,
    status: cs.status,
    bureau: 'Experian / CIBIL',
    updatedDate: '12 Oct 2026',
    nextUpdateDate: '12 Nov 2026',
    factors: [
      { name: 'Payment History', rating: 'Excellent', impact: 'High', value: '100% On-time' },
      { name: 'Credit Utilization', rating: 'Good', impact: 'High', value: '24% (Ideal < 30%)' },
      { name: 'Credit Age', rating: 'Good', impact: 'Medium', value: '4 yrs 2 mos' },
      { name: 'Total Accounts', rating: 'Good', impact: 'Low', value: '5 Active (3 Loans, 2 Cards)' },
      { name: 'Recent Inquiries', rating: 'Excellent', impact: 'Low', value: '1 in last 6 mos' },
    ],
    tips: [
      'Keep your credit card balance below 30% of total limit.',
      'Avoid opening multiple credit cards in a single month.',
      'Continue paying EMI at least 3 days before due date.',
      'Check your credit report monthly for any reporting inaccuracies.',
    ],
  });
});

// ── POST /api/credit-score/simulate ──────────────────────────────────────────
router.post('/simulate', (req, res) => {
  const { action, userId } = req.body;
  const uid = userId || 'guest';
  const cs = getScore(uid);
  const changes = { pay_on_time: 15, lower_utilization: 25, miss_payment: -45, new_inquiry: -8 };
  if (action === 'reset') { cs.score = 765; cs.status = 'Excellent'; return res.json({ success: true, score: cs.score, message: 'Reset to standard score' }); }
  const delta = changes[action] || 0;
  cs.score = Math.max(300, Math.min(900, cs.score + delta));
  cs.status = labelFor(cs.score);
  res.json({ success: true, score: cs.score, status: cs.status, change: delta, reason: action });
});

module.exports = router;
