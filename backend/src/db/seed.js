// Seeds loannova_products from the same mock data used by the web app.
// Safe to run multiple times (uses INSERT ... ON CONFLICT DO NOTHING).
// Usage: node src/db/seed.js

const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../../.env') });

const pool = require('../config/db');

const products = [
  // ── LOANS ──────────────────────────────────────────────────────────────
  { id: 'loan-1', category: 'loans', sub_type: 'Personal Loan', name: 'HDFC Instant Personal Loan', bank: 'HDFC Bank', tag: 'Quick 10-Min Disbursal', interest_rate: 10.5, min_amount: 50000, max_amount: 4000000, min_tenure: 12, max_tenure: 60, processing_fee: '0.99% (Min ₹1,499)', rating: 4.8, reviews_count: 1420, features: ['100% Paperless KYC', 'Flexible Part-payment', 'Zero Foreclosure after 12 mos'], eligibility: 'Min Salary ₹25,000/mo, Credit Score 720+', featured: true },
  { id: 'loan-2', category: 'loans', sub_type: 'Personal Loan', name: 'SBI Xpress Credit Loan', bank: 'State Bank of India', tag: 'Lowest Interest', interest_rate: 9.85, min_amount: 100000, max_amount: 2500000, min_tenure: 12, max_tenure: 72, processing_fee: 'Nil for Salaried', rating: 4.6, reviews_count: 3100, features: ['Lowest Govt Bank Rates', 'No Hidden Charges', 'Instant In-Principle Sanction'], eligibility: 'Min Salary ₹20,000/mo, Credit Score 700+', featured: true },
  { id: 'loan-3', category: 'loans', sub_type: 'Home Loan', name: 'ICICI Pratham Home Loan', bank: 'ICICI Bank', tag: 'Best for First Home', interest_rate: 8.4, min_amount: 500000, max_amount: 30000000, min_tenure: 60, max_tenure: 360, processing_fee: '0.50% of loan', rating: 4.9, reviews_count: 2280, features: ['Up to 90% Property Value', 'Doorstep Document Pickup', 'PMAY Subsidy Assistance'], eligibility: 'Age 21-65, Salaried or Self-Employed, Score 750+', featured: true },
  { id: 'loan-4', category: 'loans', sub_type: 'Business Loan', name: 'Bajaj Finserv SME Growth Loan', bank: 'Bajaj Finance', tag: 'Collateral-Free', interest_rate: 13.0, min_amount: 200000, max_amount: 5000000, min_tenure: 12, max_tenure: 84, processing_fee: '1.5% + GST', rating: 4.7, reviews_count: 940, features: ['No Asset Collateral Needed', 'GST / ITR based approval', 'Flexi Term Repayment'], eligibility: 'Business vintage 2+ years, Turnover ₹15L+', featured: false },
  { id: 'loan-5', category: 'loans', sub_type: 'Vehicle Loan', name: 'Axis Bank Auto Drive Loan', bank: 'Axis Bank', tag: '100% On-Road Funding', interest_rate: 8.75, min_amount: 100000, max_amount: 10000000, min_tenure: 12, max_tenure: 84, processing_fee: '₹3,500 Flat', rating: 4.7, reviews_count: 1120, features: ['Up to 100% On-road Price', 'Special EV Discount 0.25%', 'Instant sanction voucher'], eligibility: 'Min Net Income ₹3 Lakh/yr', featured: false },
  { id: 'loan-6', category: 'loans', sub_type: 'Education Loan', name: 'Bank of Baroda Vidya Loan', bank: 'Bank of Baroda', tag: 'Study in India & Abroad', interest_rate: 8.25, min_amount: 200000, max_amount: 8000000, min_tenure: 36, max_tenure: 180, processing_fee: 'Nil for India / 1% Abroad', rating: 4.5, reviews_count: 650, features: ['Moratorium period + 1 yr', 'Tax benefit under Sec 80E', 'Covers living expenses'], eligibility: 'Confirmed admission in accredited college', featured: false },
  { id: 'loan-7', category: 'loans', sub_type: 'Gold Loan', name: 'Muthoot Super Express Gold Loan', bank: 'Muthoot Finance', tag: 'Fast Cash in 15 Mins', interest_rate: 9.9, min_amount: 20000, max_amount: 2000000, min_tenure: 3, max_tenure: 24, processing_fee: '₹200 to ₹500', rating: 4.8, reviews_count: 1890, features: ['Instant gold appraisal', 'Safe bank locker storage', 'Zero CIBIL check required'], eligibility: '18+ yrs, 18K to 22K Hallmarked Gold', featured: false },
  // ── CARDS ──────────────────────────────────────────────────────────────
  { id: 'card-1', category: 'cards', sub_type: 'Cashback & Shopping', name: 'HDFC Millennia Credit Card', bank: 'HDFC Bank', tag: '5% Cashback on Amazon & Flipkart', annual_fee: 1000, rating: 4.8, reviews_count: 4200, features: ['1% fuel surcharge waiver', '₹1,000 gift voucher on signup', 'Contactless payments'], badge: 'Most Popular', featured: true },
  { id: 'card-2', category: 'cards', sub_type: 'Travel & Lifestyle', name: 'Axis Bank Atlas Card', bank: 'Axis Bank', tag: 'Free International Lounges', annual_fee: 5000, rating: 4.9, reviews_count: 1650, features: ['1 EDGE Mile = 2 Partner Points', 'Complimentary airport concierge', 'Zero forex mark-up discount'], badge: 'Premium Travel', featured: true },
  { id: 'card-3', category: 'cards', sub_type: 'Fuel & Utility', name: 'SBI SimplyCLICK Card', bank: 'State Bank of India', tag: '10x Reward Points Online', annual_fee: 499, rating: 4.6, reviews_count: 3800, features: ['₹500 Amazon Gift card on joining', '1% Fuel surcharge waiver', 'Cleartrip e-vouchers on milestones'], badge: 'Best Starter Card', featured: false },
  { id: 'card-4', category: 'cards', sub_type: 'Lifetime Free', name: 'ICICI Amazon Pay Card', bank: 'ICICI Bank', tag: 'Zero Annual Fee Forever', annual_fee: 0, rating: 4.9, reviews_count: 5200, features: ['No expiry on cashback', 'Cashback directly credited to Amazon Pay', 'Zero joining charges'], badge: 'Lifetime Free', featured: true },
  // ── SAVINGS ────────────────────────────────────────────────────────────
  { id: 'save-1', category: 'savings', sub_type: 'Digital Savings Account', name: 'Kotak 811 Zero Balance Account', bank: 'Kotak Mahindra Bank', tag: 'Zero Balance Forever', interest_rate: 4.0, rating: 4.7, reviews_count: 3400, features: ['Instant Virtual Debit Card', 'Zero minimum balance penalty', 'Full Video KYC from home'] },
  { id: 'save-2', category: 'savings', sub_type: 'High Interest Savings', name: 'IDFC FIRST WOW Savings', bank: 'IDFC FIRST Bank', tag: 'Up to 7.25% Interest p.a.', interest_rate: 7.25, rating: 4.8, reviews_count: 1980, features: ['Monthly interest payout', 'Free unlimited ATM transactions', 'Complimentary airport lounge debit card'] },
  { id: 'save-3', category: 'savings', sub_type: 'Fixed Deposit', name: 'Unity Small Finance Bank FD', bank: 'Unity SFB', tag: 'High Yield 9.0% for Seniors', interest_rate: 8.5, rating: 4.6, reviews_count: 890, features: ['DICGC Insured up to ₹5 Lakh', 'Premature withdrawal option', '0.50% extra for Senior Citizens'] },
  // ── INSURANCE ──────────────────────────────────────────────────────────
  { id: 'ins-1', category: 'insurance', sub_type: 'Health Insurance', name: 'Care Supreme Comprehensive Plan', bank: 'Care Health Insurance', tag: 'Unlimited Recharge of Cover', rating: 4.8, reviews_count: 2900, features: ['Zero room rent capping', 'AYUSH treatments covered', 'Annual free full body checkup'] },
  { id: 'ins-2', category: 'insurance', sub_type: 'Term Life Insurance', name: 'HDFC Life Click 2 Protect Super', bank: 'HDFC Life', tag: '100% Tax Free Payout (Sec 10D)', rating: 4.9, reviews_count: 4100, features: ['Terminal illness cover included', 'Return of premium option', 'Tax savings under Sec 80C'] },
  { id: 'ins-3', category: 'insurance', sub_type: 'Motor / Car Insurance', name: 'Digit Zero Depreciation Car Cover', bank: 'Go Digit General Insurance', tag: 'Paperless Claims in 15 Mins', rating: 4.7, reviews_count: 3200, features: ['Smartphone self-inspection', 'Engine and gearbox protection', 'Roadside assistance 24/7'] },
  // ── INVESTMENTS ────────────────────────────────────────────────────────
  { id: 'inv-1', category: 'investments', sub_type: 'Mutual Fund SIP', name: 'Parag Parikh Flexi Cap Fund (Direct)', bank: 'PPFAS Mutual Fund', tag: 'Top Performing 5-Yr CAGR 21.4%', rating: 4.9, reviews_count: 5600, features: ['International diversification', 'Low expense ratio (0.58%)', 'Proven long-term consistency'] },
  { id: 'inv-2', category: 'investments', sub_type: 'Tax Saver ELSS', name: 'Mirae Asset ELSS Tax Saver', bank: 'Mirae Asset', tag: 'Save up to ₹46,800 Tax under 80C', rating: 4.8, reviews_count: 3100, features: ['Shortest 3-year lock-in among 80C', 'High wealth creation potential', 'Automated monthly SIP'] },
  { id: 'inv-3', category: 'investments', sub_type: 'Digital Gold & SGB', name: 'Nova 24K Pure Digital Gold', bank: 'MMTC-PAMP / Augmont', tag: '99.99% Certified Pure Gold', rating: 4.8, reviews_count: 1800, features: ['Buy from as low as ₹100', '100% insured vault storage', 'Instant buy & sell at live market rates'] },
];

async function seed() {
  const client = await pool.connect();
  try {
    console.log('[seed] Inserting products...');
    for (const p of products) {
      await client.query(
        `INSERT INTO loannova_products
           (id, category, sub_type, name, bank, tag, interest_rate, min_amount, max_amount,
            min_tenure, max_tenure, processing_fee, annual_fee, rating, reviews_count,
            features, eligibility, badge, featured)
         VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19)
         ON CONFLICT (id) DO NOTHING`,
        [
          p.id, p.category, p.sub_type, p.name, p.bank || null, p.tag || null,
          p.interest_rate || null, p.min_amount || null, p.max_amount || null,
          p.min_tenure || null, p.max_tenure || null, p.processing_fee || null,
          p.annual_fee || null, p.rating, p.reviews_count,
          JSON.stringify(p.features || []),
          p.eligibility || null, p.badge || null, p.featured || false,
        ]
      );
    }
    console.log(`[seed] ✅ ${products.length} products seeded.`);
  } finally {
    client.release();
    await pool.end();
  }
}

seed().catch((err) => {
  console.error('[seed] ❌ Failed:', err.message);
  process.exit(1);
});
