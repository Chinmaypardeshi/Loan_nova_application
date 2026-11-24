const router = require('express').Router();

// Static referral data (can be moved to DB later)
const referrals = {
  referralCode: 'NOVA-USER99',
  totalInvited: 14, activeAccounts: 8, totalEarned: 4200, pendingBonus: 800, walletCoins: 1250,
  history: [
    { name: 'Pooja Verma', date: '08 Oct 2026', reward: '₹500', status: 'Credited' },
    { name: 'Amit Patel', date: '04 Oct 2026', reward: '₹500', status: 'Credited' },
    { name: 'Vikram Singh', date: '28 Sep 2026', reward: '₹300', status: 'Credited' },
  ],
};

router.get('/', (req, res) => res.json(referrals));

module.exports = router;
