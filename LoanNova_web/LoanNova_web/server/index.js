import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';
import { mockProducts, mockCreditScore, initialApplications } from './data/mockData.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const distPath = path.join(__dirname, '../dist');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());
app.use(express.static(distPath));


// In-memory state
let products = [...mockProducts];
let applications = [...initialApplications];
let currentCreditScore = { ...mockCreditScore };
let referrals = {
  referralCode: 'NOVA-RAHUL99',
  totalInvited: 14,
  activeAccounts: 8,
  totalEarned: 4200,
  pendingBonus: 800,
  walletCoins: 1250,
  history: [
    { name: 'Pooja Verma', date: '08 Oct 2026', reward: '₹500', status: 'Credited' },
    { name: 'Amit Patel', date: '04 Oct 2026', reward: '₹500', status: 'Credited' },
    { name: 'Vikram Singh', date: '28 Sep 2026', reward: '₹300', status: 'Credited' },
  ],
};

// Health Check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'online',
    platform: 'LoanNova Enterprise v1.0',
    timestamp: new Date().toISOString(),
  });
});

// Products API with Filter, Search, Category
app.get('/api/products', (req, res) => {
  const { category, subType, bank, search, sort } = req.query;
  let filtered = [...products];

  if (category && category !== 'all') {
    filtered = filtered.filter((p) => p.category.toLowerCase() === category.toLowerCase());
  }
  if (subType && subType !== 'all') {
    filtered = filtered.filter((p) => p.subType.toLowerCase() === subType.toLowerCase());
  }
  if (bank && bank !== 'all') {
    filtered = filtered.filter((p) => p.bank.toLowerCase().includes(bank.toLowerCase()));
  }
  if (search) {
    const q = search.toLowerCase();
    filtered = filtered.filter(
      (p) =>
        p.name.toLowerCase().includes(q) ||
        p.bank.toLowerCase().includes(q) ||
        p.subType.toLowerCase().includes(q) ||
        (p.tag && p.tag.toLowerCase().includes(q))
    );
  }

  // Sorting
  if (sort === 'rate-low') {
    filtered.sort((a, b) => (a.interestRate || 99) - (b.interestRate || 99));
  } else if (sort === 'rating-high') {
    filtered.sort((a, b) => (b.rating || 0) - (a.rating || 0));
  }

  res.json({ count: filtered.length, products: filtered });
});

// Add new product (for Partner / Admin)
app.post('/api/products', (req, res) => {
  const newProduct = {
    id: `prod-${Date.now()}`,
    ...req.body,
    rating: req.body.rating || 4.5,
    reviewsCount: req.body.reviewsCount || 10,
  };
  products.unshift(newProduct);
  res.status(201).json({ success: true, product: newProduct });
});

// Applications API
app.get('/api/applications', (req, res) => {
  res.json({ count: applications.length, applications });
});

app.post('/api/applications', (req, res) => {
  const {
    productName,
    type,
    bank,
    amount,
    tenure,
    interestRate,
    applicantName,
    phone,
    email,
    pan,
    employment,
    monthlyIncome,
  } = req.body;

  // Simple EMI formula for loans: [P x R x (1+R)^N]/[(1+R)^N-1]
  let calculatedEmi = 0;
  if (amount && interestRate && tenure) {
    const r = (interestRate / 12) / 100;
    const n = tenure;
    if (r > 0 && n > 0) {
      calculatedEmi = Math.round((amount * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1));
    }
  }

  const newApp = {
    id: `APP-${Math.floor(10000 + Math.random() * 90000)}`,
    productName: productName || 'LoanNova Custom Product',
    type: type || 'Personal Loan',
    bank: bank || 'Partner Bank',
    amount: Number(amount) || 200000,
    tenure: Number(tenure) || 24,
    interestRate: Number(interestRate) || 10.5,
    emi: calculatedEmi,
    applicantName: applicantName || 'Demo Applicant',
    phone: phone || '+91 98765 00000',
    email: email || 'applicant@loannova.in',
    pan: pan ? pan.toUpperCase() : 'ABCDE1234F',
    employment: employment || 'Salaried',
    monthlyIncome: monthlyIncome || '₹50,000',
    kycStatus: 'Verified',
    status: 'Under Review',
    stage: 2, // Submitted & KYC passed
    appliedDate: 'Just now',
  };

  applications.unshift(newApp);
  res.status(201).json({ success: true, application: newApp });
});

// Update Application Status (Admin / Agent action)
app.patch('/api/applications/:id', (req, res) => {
  const { id } = req.params;
  const { status, stage } = req.body;
  const appIndex = applications.findIndex((a) => a.id === id);

  if (appIndex === -1) {
    return res.status(404).json({ error: 'Application not found' });
  }

  if (status) applications[appIndex].status = status;
  if (stage) applications[appIndex].stage = stage;

  res.json({ success: true, application: applications[appIndex] });
});

// Credit Score API
app.get('/api/credit-score', (req, res) => {
  res.json(currentCreditScore);
});

// Credit Score Simulator Action
app.post('/api/credit-score/simulate', (req, res) => {
  const { action } = req.body;
  let change = 0;
  let reason = '';

  if (action === 'pay_on_time') {
    change = +15;
    reason = 'Timely credit card / loan EMI payment reported';
  } else if (action === 'lower_utilization') {
    change = +25;
    reason = 'Credit utilization dropped below 20%';
  } else if (action === 'miss_payment') {
    change = -45;
    reason = 'Missed payment penalty recorded on credit bureau';
  } else if (action === 'new_inquiry') {
    change = -8;
    reason = 'Hard credit inquiry by lender';
  } else if (action === 'reset') {
    currentCreditScore.score = 765;
    return res.json({ success: true, score: currentCreditScore.score, message: 'Reset to standard score' });
  }

  currentCreditScore.score = Math.max(300, Math.min(900, currentCreditScore.score + change));
  currentCreditScore.status =
    currentCreditScore.score >= 750
      ? 'Excellent'
      : currentCreditScore.score >= 700
      ? 'Good'
      : currentCreditScore.score >= 650
      ? 'Fair'
      : 'Needs Attention';

  res.json({
    success: true,
    score: currentCreditScore.score,
    status: currentCreditScore.status,
    change,
    reason,
  });
});

// Digital KYC Verification API
app.post('/api/kyc/verify', (req, res) => {
  const { aadhaar, pan, name } = req.body;
  // Simulated AI OCR & NSDL/UIDAI check
  const isAadhaarValid = aadhaar && aadhaar.replace(/\s/g, '').length === 12;
  const isPanValid = pan && pan.trim().length === 10;

  res.json({
    success: true,
    kycId: `KYC-${Date.now().toString().slice(-6)}`,
    status: 'Instant Verified',
    ocrConfidence: '99.4%',
    livenessScore: 'Pass (0.98)',
    aadhaarMasked: aadhaar ? `XXXX-XXXX-${aadhaar.slice(-4)}` : 'XXXX-XXXX-8921',
    panVerified: pan ? pan.toUpperCase() : 'ABCDE1234F',
    nameMatch: '100% Exact Match',
    timestamp: new Date().toLocaleTimeString(),
  });
});

// AI Financial Chatbot API
app.post('/api/chat', (req, res) => {
  const { message } = req.body;
  const msg = (message || '').toLowerCase();

  let reply = '';
  let suggestedActions = [];

  if (msg.includes('loan') && (msg.includes('low') || msg.includes('best') || msg.includes('personal'))) {
    reply =
      'For personal loans, SBI Xpress Credit offers the lowest interest at 9.85% p.a. with zero processing fees. HDFC Bank is fastest with 10-minute instant disbursal at 10.5%.';
    suggestedActions = ['Compare Personal Loans', 'Calculate EMI', 'Check Eligibility'];
  } else if (msg.includes('card') || msg.includes('credit')) {
    reply =
      'If you want maximum cashback, ICICI Amazon Pay is lifetime free with 5% unlimited cashback. For travel & airport lounge access, Axis Atlas offers unlimited domestic & international lounge access.';
    suggestedActions = ['View Best Cards', 'Cashback Cards', 'Apply Now'];
  } else if (msg.includes('score') || msg.includes('cibil') || msg.includes('experian')) {
    reply =
      'Your credit score is currently 765 (Excellent). You qualify for pre-approved loans up to ₹40 Lakhs at the lowest rates! To keep it high, maintain card balance below 30% of total limit.';
    suggestedActions = ['Open Score Simulator', 'View Credit Report', 'Tips to Increase'];
  } else if (msg.includes('emi') || msg.includes('calculate')) {
    reply =
      'A ₹5 Lakh loan at 10.5% for 3 years has an estimated EMI of ₹16,252/month. Total interest is approx ₹85,072. Use our interactive EMI Calculator slider to adjust tenures!';
    suggestedActions = ['Open EMI Calculator', 'Check Max Loan Amount'];
  } else if (msg.includes('insurance') || msg.includes('health') || msg.includes('term')) {
    reply =
      'Care Supreme offers comprehensive health cover with unlimited recharge and 21,000+ cashless hospitals. For term insurance, HDFC Life Click 2 Protect covers ₹1 Crore at ₹750/month with 99.5% claim settlement ratio.';
    suggestedActions = ['Compare Health Plans', 'Calculate Term Premium'];
  } else if (msg.includes('invest') || msg.includes('sip') || msg.includes('fund') || msg.includes('gold')) {
    reply =
      'Top performer: Parag Parikh Flexi Cap Fund has generated 22.8% 3-year CAGR with global diversification. You can also start Digital Gold SIP at just ₹100 with zero locker fees.';
    suggestedActions = ['Explore SIP Funds', 'Open SIP Calculator', 'Buy Digital Gold'];
  } else {
    reply =
      `Hello! I am Nova, your AI Financial Assistant. I can help you find lowest-rate loans, best cashback cards, simulate credit score changes, and calculate exact monthly EMIs. What financial goal can I help you with today?`;
    suggestedActions = ['Best Personal Loans', 'Highest Cashback Cards', 'Check Credit Score', 'EMI Calculator'];
  }

  res.json({
    reply,
    suggestedActions,
    timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
  });
});

// Referrals API
app.get('/api/referrals', (req, res) => {
  res.json(referrals);
});

// Stats API for Dashboards & CRM
app.get('/api/dashboard/stats', (req, res) => {
  res.json({
    customer: {
      activeApplications: applications.length,
      preApprovedLimit: '₹12,50,000',
      creditScore: currentCreditScore.score,
      walletBalance: '₹4,200',
      nextEmiDue: '₹9,750 on 05 Nov 2026',
    },
    partner: {
      totalLeads: 148,
      approvedToday: 19,
      disbursedVolume: '₹1.84 Crore',
      averageTurnaround: '4.2 Hours',
      commissionEarned: '₹94,500',
    },
    admin: {
      registeredUsers: '1,240,500',
      totalApplications: '34,890',
      systemHealth: '99.99% Uptime',
      fraudAttemptsBlocked: '342 (100% Cleared)',
      activeLendingPartners: 24,
    },
  });
});

app.use((req, res) => {
  res.sendFile(path.join(distPath, 'index.html'));
});

app.listen(PORT, () => {
  console.log(`LoanNova Full-Stack Server listening on http://localhost:${PORT}`);
});

