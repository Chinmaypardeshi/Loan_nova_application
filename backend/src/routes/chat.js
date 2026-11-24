const router = require('express').Router();

const replies = [
  { keys: ['loan', 'personal', 'best', 'low'], reply: 'For personal loans, SBI Xpress Credit offers the lowest interest at 9.85% p.a. with zero processing fees. HDFC Bank is fastest with 10-minute instant disbursal at 10.5%.', actions: ['Compare Personal Loans', 'Calculate EMI', 'Check Eligibility'] },
  { keys: ['card', 'credit', 'cashback'], reply: 'If you want maximum cashback, ICICI Amazon Pay is lifetime free with 5% unlimited cashback. For travel & airport lounge access, Axis Atlas offers unlimited domestic & international lounge access.', actions: ['View Best Cards', 'Cashback Cards', 'Apply Now'] },
  { keys: ['score', 'cibil', 'experian'], reply: 'Your credit score is currently 765 (Excellent). You qualify for pre-approved loans up to ₹40 Lakhs at the lowest rates! To keep it high, maintain card balance below 30% of total limit.', actions: ['Open Score Simulator', 'View Credit Report', 'Tips to Increase'] },
  { keys: ['emi', 'calculate'], reply: 'A ₹5 Lakh loan at 10.5% for 3 years has an estimated EMI of ₹16,252/month. Total interest is approx ₹85,072. Use our interactive EMI Calculator slider to adjust tenures!', actions: ['Open EMI Calculator', 'Check Max Loan Amount'] },
  { keys: ['insurance', 'health', 'term'], reply: 'Care Supreme offers comprehensive health cover with unlimited recharge and 21,000+ cashless hospitals. For term insurance, HDFC Life Click 2 Protect covers ₹1 Crore at ₹750/month with 99.5% claim settlement ratio.', actions: ['Compare Health Plans', 'Calculate Term Premium'] },
  { keys: ['invest', 'sip', 'fund', 'gold'], reply: 'Top performer: Parag Parikh Flexi Cap Fund has generated 22.8% 3-year CAGR with global diversification. You can also start Digital Gold SIP at just ₹100 with zero locker fees.', actions: ['Explore SIP Funds', 'Open SIP Calculator', 'Buy Digital Gold'] },
];

// ── POST /api/chat ────────────────────────────────────────────────────────────
router.post('/', (req, res) => {
  const msg = (req.body.message || '').toLowerCase();
  const matched = replies.find(r => r.keys.some(k => msg.includes(k)));
  res.json({
    reply: matched ? matched.reply : 'Hello! I am Nova, your AI Financial Assistant. I can help you find lowest-rate loans, best cashback cards, simulate credit score changes, and calculate exact monthly EMIs. What financial goal can I help you with today?',
    suggestedActions: matched ? matched.actions : ['Best Personal Loans', 'Highest Cashback Cards', 'Check Credit Score', 'EMI Calculator'],
    timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
  });
});

module.exports = router;
