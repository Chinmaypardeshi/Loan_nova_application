import React, { useState } from 'react';
import { 
  X, 
  CheckCircle, 
  ShieldCheck, 
  ArrowRight, 
  Sparkles, 
  Building, 
  User, 
  CreditCard, 
  FileCheck2, 
  AlertCircle,
  Clock,
  Download,
  ShieldPlus,
  TrendingUp,
  Wallet
} from 'lucide-react';
import confetti from 'canvas-confetti';
import { downloadSanctionLetter } from '../utils/documentGenerator';

export function ApplicationModal({ product, onClose, onSuccess }) {
  if (!product) return null;

  const isCard = product.category === 'cards' || product.subType?.toLowerCase().includes('card');
  const isInsurance = product.category === 'insurance' || product.subType?.toLowerCase().includes('insurance');
  const isInvestment = product.category === 'investments' || product.subType?.toLowerCase().includes('sip') || product.subType?.toLowerCase().includes('gold') || product.subType?.toLowerCase().includes('elss');

  const [step, setStep] = useState(1);
  const [amount, setAmount] = useState(
    isInvestment ? (product.minSip || 5000) : (product.minAmount || 300000)
  );
  const [tenure, setTenure] = useState(product.minTenure || 24);
  const [applicantName, setApplicantName] = useState('Rahul Sharma');
  const [phone, setPhone] = useState('+91 98765 43210');
  const [email, setEmail] = useState('rahul.sharma@loannova.in');
  const [pan, setPan] = useState('ABCDE1234F');
  const [aadhaar, setAadhaar] = useState('5432 9876 1234');
  const [employment, setEmployment] = useState('Salaried');
  const [monthlyIncome, setMonthlyIncome] = useState('₹65,000');
  const [isVerifying, setIsVerifying] = useState(false);
  const [applicationResult, setApplicationResult] = useState(null);

  // EMI calculation helper
  const rate = product.interestRate || (isCard || isInsurance || isInvestment ? 0 : 10.5);
  const r = (rate / 12) / 100;
  const n = tenure;
  let emi = 0;
  if (!isCard && !isInsurance && !isInvestment && rate > 0) {
    emi = Math.round((amount * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1)) || 0;
  }

  const handleKycAndSubmit = async () => {
    setIsVerifying(true);

    try {
      // 1. Simulate digital KYC
      await fetch('/api/kyc/verify', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ aadhaar, pan, name: applicantName }),
      });

      // 2. Submit Application to backend
      const res = await fetch('/api/applications', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          productName: product.name,
          type: product.subType || product.category || 'Financial Product',
          bank: product.bank || 'Partner Bank',
          amount,
          tenure: isCard || isInsurance || isInvestment ? 0 : tenure,
          interestRate: rate,
          applicantName,
          phone,
          email,
          pan,
          employment,
          monthlyIncome,
        }),
      });

      const data = await res.json();
      const finalApp = data.application || {
        id: `APP-${Math.floor(10000 + Math.random() * 90000)}`,
        productName: product.name,
        type: product.subType || product.category || 'Financial Product',
        bank: product.bank || 'HDFC Bank',
        amount: Number(amount),
        tenure: isCard || isInsurance || isInvestment ? 0 : Number(tenure),
        interestRate: rate,
        emi: isInvestment ? Number(amount) : emi,
        applicantName,
        phone,
        email,
        pan,
        kycStatus: 'Verified',
        status: 'Approved',
        stage: 4,
        appliedDate: 'Today'
      };

      setApplicationResult(finalApp);

      // Fire confetti celebration
      confetti({
        particleCount: 85,
        spread: 75,
        origin: { y: 0.6 }
      });

      setStep(4); // Approval Screen
      if (onSuccess) onSuccess(finalApp);
    } catch (err) {
      console.error(err);
      // Fallback local approval for seamless HR demo
      const fallbackApp = {
        id: `APP-${Math.floor(10000 + Math.random() * 90000)}`,
        productName: product.name,
        type: product.subType || product.category || 'Financial Product',
        bank: product.bank || 'HDFC Bank',
        amount: Number(amount),
        tenure: isCard || isInsurance || isInvestment ? 0 : Number(tenure),
        interestRate: rate,
        emi: isInvestment ? Number(amount) : emi,
        applicantName,
        phone,
        email,
        pan,
        kycStatus: 'Verified',
        status: 'Approved',
        stage: 4,
        appliedDate: 'Today'
      };
      setApplicationResult(fallbackApp);
      confetti({ particleCount: 75, spread: 65 });
      setStep(4);
      if (onSuccess) onSuccess(fallbackApp);
    } finally {
      setIsVerifying(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
      <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-xl overflow-hidden text-slate-800">
        {/* Modal Header */}
        <div className="bg-slate-900 text-white p-4 sm:p-5 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className={`w-10 h-10 rounded-xl flex items-center justify-center text-white ${
              isCard ? 'bg-amber-600' : isInsurance ? 'bg-rose-600' : isInvestment ? 'bg-emerald-600' : 'bg-blue-600'
            }`}>
              {isCard ? <CreditCard className="w-5 h-5" /> : isInsurance ? <ShieldPlus className="w-5 h-5" /> : isInvestment ? <TrendingUp className="w-5 h-5" /> : <Building className="w-5 h-5" />}
            </div>
            <div>
              <div className="text-xs text-blue-300 font-semibold uppercase tracking-wider">
                {isCard ? 'Instant Credit Card Application' : isInsurance ? 'Instant Policy Application' : isInvestment ? 'Instant SIP Mandate' : 'Instant Digital Application'}
              </div>
              <h3 className="text-base font-bold text-white line-clamp-1">{product.name}</h3>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Progress Stepper */}
        <div className="bg-slate-50 border-b border-slate-200 px-6 py-2.5 flex items-center justify-between text-xs font-semibold text-slate-500">
          <span className={step >= 1 ? 'text-blue-600 flex items-center gap-1 font-bold' : ''}>
            1. {isCard ? 'Card Preference' : isInsurance ? 'Policy Details' : isInvestment ? 'SIP Setup' : 'Amount & Term'}
          </span>
          <span>→</span>
          <span className={step >= 2 ? 'text-blue-600 flex items-center gap-1 font-bold' : ''}>
            2. Personal Info
          </span>
          <span>→</span>
          <span className={step >= 3 ? 'text-blue-600 flex items-center gap-1 font-bold' : ''}>
            3. Digital KYC
          </span>
          <span>→</span>
          <span className={step === 4 ? 'text-emerald-600 flex items-center gap-1 font-bold' : ''}>
            4. {isCard ? 'Card Active' : isInsurance ? 'Policy Issued' : isInvestment ? 'SIP Started' : 'Sanction'}
          </span>
        </div>

        {/* Step Contents */}
        <div className="p-6">
          {/* STEP 1: Details */}
          {step === 1 && (
            <div className="space-y-4">
              {/* Product specific highlights */}
              {isCard ? (
                <div className="bg-amber-50 border border-amber-200 rounded-xl p-3.5 flex items-center justify-between">
                  <div>
                    <span className="text-xs text-amber-800 font-medium">Annual Joining Fee</span>
                    <div className="text-lg font-bold text-amber-950">
                      {product.annualFee === 0 ? 'LIFETIME FREE' : `₹${product.annualFee || 500}`}
                    </div>
                  </div>
                  <div className="text-right">
                    <span className="text-xs text-amber-800 font-medium">Lounge Access</span>
                    <div className="text-lg font-bold text-amber-950">{product.loungeAccess || 'Complimentary'}</div>
                  </div>
                </div>
              ) : isInsurance ? (
                <div className="bg-rose-50 border border-rose-200 rounded-xl p-3.5 flex items-center justify-between">
                  <div>
                    <span className="text-xs text-rose-700 font-medium">Life / Health Cover</span>
                    <div className="text-lg font-bold text-rose-950">{product.coverAmount || '₹1 Crore Cover'}</div>
                  </div>
                  <div className="text-right">
                    <span className="text-xs text-rose-700 font-medium">Starting Premium</span>
                    <div className="text-lg font-bold text-rose-950">{product.startingPremium || '₹850 / mo'}</div>
                  </div>
                </div>
              ) : isInvestment ? (
                <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3.5 flex items-center justify-between">
                  <div>
                    <span className="text-xs text-emerald-700 font-medium">3-Year Return</span>
                    <div className="text-lg font-bold text-emerald-950">{product.returns3Yr || '22.8% p.a.'}</div>
                  </div>
                  <div className="text-right">
                    <span className="text-xs text-emerald-700 font-medium">Minimum SIP</span>
                    <div className="text-lg font-bold text-emerald-950">₹{product.minSip || 500}/month</div>
                  </div>
                </div>
              ) : (
                <div className="bg-blue-50 border border-blue-100 rounded-xl p-3.5 flex items-center justify-between">
                  <div>
                    <span className="text-xs text-blue-700 font-medium">Interest Rate</span>
                    <div className="text-lg font-bold text-blue-900">{rate}% p.a.</div>
                  </div>
                  <div className="text-right">
                    <span className="text-xs text-blue-700 font-medium">Est. Monthly EMI</span>
                    <div className="text-lg font-bold text-blue-900">₹{emi.toLocaleString('en-IN')}</div>
                  </div>
                </div>
              )}

              {/* Amount slider */}
              <div>
                <div className="flex justify-between text-xs font-semibold mb-1 text-slate-700">
                  <span>{isCard ? 'Requested Card Credit Limit' : isInvestment ? 'Monthly SIP Commitment' : isInsurance ? 'Coverage Sum Selected' : 'Required Loan Amount'}</span>
                  <span className="text-blue-600 font-bold">₹{amount.toLocaleString('en-IN')}</span>
                </div>
                <input
                  type="range"
                  min={isInvestment ? 500 : isCard ? 25000 : (product.minAmount || 50000)}
                  max={isInvestment ? 50000 : isCard ? 500000 : (product.maxAmount || 2000000)}
                  step={isInvestment ? 500 : isCard ? 25000 : 25000}
                  value={amount}
                  onChange={(e) => setAmount(Number(e.target.value))}
                  className="w-full accent-blue-600 cursor-pointer"
                />
                <div className="flex justify-between text-[11px] text-slate-400 mt-1">
                  <span>₹{(isInvestment ? 500 : isCard ? 25000 : (product.minAmount || 50000)).toLocaleString('en-IN')}</span>
                  <span>₹{(isInvestment ? 50000 : isCard ? 500000 : (product.maxAmount || 2000000)).toLocaleString('en-IN')}</span>
                </div>
              </div>

              {/* Tenure slider for loans */}
              {!isCard && !isInsurance && !isInvestment && (
                <div>
                  <div className="flex justify-between text-xs font-semibold mb-1 text-slate-700">
                    <span>Repayment Tenure</span>
                    <span className="text-blue-600 font-bold">{tenure} Months ({Math.round(tenure/12)} Yrs)</span>
                  </div>
                  <input
                    type="range"
                    min={product.minTenure || 12}
                    max={product.maxTenure || 60}
                    step="6"
                    value={tenure}
                    onChange={(e) => setTenure(Number(e.target.value))}
                    className="w-full accent-blue-600 cursor-pointer"
                  />
                  <div className="flex justify-between text-[11px] text-slate-400 mt-1">
                    <span>{product.minTenure || 12} Mos</span>
                    <span>{product.maxTenure || 60} Mos</span>
                  </div>
                </div>
              )}

              {/* Perks badges */}
              <div className="bg-slate-50 border border-slate-200 rounded-xl p-3 text-xs space-y-1">
                <span className="font-bold text-slate-800 block">Pre-Approved Offer Highlights:</span>
                <div className="flex flex-wrap gap-1.5 pt-1">
                  <span className="bg-white border border-slate-200 text-slate-700 px-2 py-0.5 rounded text-[10px] font-bold">✓ 100% Paperless</span>
                  <span className="bg-white border border-slate-200 text-slate-700 px-2 py-0.5 rounded text-[10px] font-bold">✓ Instant Bank Sanction</span>
                  <span className="bg-white border border-slate-200 text-slate-700 px-2 py-0.5 rounded text-[10px] font-bold">✓ Zero Documentation</span>
                </div>
              </div>

              <div className="pt-2">
                <button
                  onClick={() => setStep(2)}
                  className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 transition shadow-md shadow-blue-500/20"
                >
                  <span>Proceed to Applicant Details</span>
                  <ArrowRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* STEP 2: Personal Info */}
          {step === 2 && (
            <div className="space-y-3.5">
              <div className="grid grid-cols-2 gap-3 text-xs">
                <div>
                  <label className="block text-slate-600 font-medium mb-1">Full Name</label>
                  <input
                    type="text"
                    value={applicantName}
                    onChange={(e) => setApplicantName(e.target.value)}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl font-semibold outline-none focus:border-blue-500 bg-slate-50 focus:bg-white"
                  />
                </div>
                <div>
                  <label className="block text-slate-600 font-medium mb-1">Mobile Number</label>
                  <input
                    type="text"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl font-semibold outline-none focus:border-blue-500 bg-slate-50 focus:bg-white"
                  />
                </div>
              </div>

              <div className="text-xs">
                <label className="block text-slate-600 font-medium mb-1">Email ID</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="w-full px-3 py-2 border border-slate-200 rounded-xl font-semibold outline-none focus:border-blue-500 bg-slate-50 focus:bg-white"
                />
              </div>

              <div className="grid grid-cols-2 gap-3 text-xs">
                <div>
                  <label className="block text-slate-600 font-medium mb-1">PAN Card Number</label>
                  <input
                    type="text"
                    value={pan}
                    onChange={(e) => setPan(e.target.value.toUpperCase())}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl font-mono font-bold uppercase outline-none focus:border-blue-500 bg-slate-50 focus:bg-white"
                  />
                </div>
                <div>
                  <label className="block text-slate-600 font-medium mb-1">Employment Type</label>
                  <select
                    value={employment}
                    onChange={(e) => setEmployment(e.target.value)}
                    className="w-full px-3 py-2 border border-slate-200 rounded-xl font-semibold outline-none bg-slate-50 focus:bg-white cursor-pointer"
                  >
                    <option value="Salaried">Salaried (Corporate)</option>
                    <option value="Self-Employed">Self-Employed / Business</option>
                    <option value="Professional">Doctor / CA / Lawyer</option>
                  </select>
                </div>
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  onClick={() => setStep(1)}
                  className="w-1/3 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-semibold text-xs transition"
                >
                  Back
                </button>
                <button
                  onClick={() => setStep(3)}
                  className="w-2/3 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 transition shadow-md shadow-blue-500/20"
                >
                  <span>Verify with Instant e-KYC</span>
                  <ArrowRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* STEP 3: Digital KYC */}
          {step === 3 && (
            <div className="space-y-4 text-xs">
              <div className="p-4 bg-emerald-50 border border-emerald-200 rounded-xl space-y-2">
                <div className="flex items-center gap-2 text-emerald-800 font-bold">
                  <ShieldCheck className="w-5 h-5 text-emerald-600" />
                  <span>Instant Verification Ready</span>
                </div>
                <p className="text-slate-600 text-[11px] leading-relaxed">
                  Your identity details will be cross-referenced with UIDAI Aadhaar and NSDL databases.
                </p>

                <div className="space-y-1.5 pt-2">
                  <div className="flex items-center justify-between p-2 bg-white rounded-lg border">
                    <span className="text-slate-600">Aadhaar:</span>
                    <span className="font-mono font-bold text-slate-900">{aadhaar}</span>
                    <span className="text-emerald-600 font-semibold text-[11px] flex items-center gap-1">
                      <CheckCircle className="w-3.5 h-3.5" /> Ready
                    </span>
                  </div>

                  <div className="flex items-center justify-between p-2 bg-white rounded-lg border">
                    <span className="text-slate-600">PAN Card:</span>
                    <span className="font-mono font-bold text-slate-900">{pan}</span>
                    <span className="text-emerald-600 font-semibold text-[11px] flex items-center gap-1">
                      <CheckCircle className="w-3.5 h-3.5" /> Ready
                    </span>
                  </div>

                  <div className="flex items-center justify-between p-2 bg-white rounded-lg border">
                    <span className="text-slate-600">Credit Score Check:</span>
                    <span className="font-bold text-emerald-700">765 (Experian Bureau)</span>
                    <span className="bg-emerald-100 text-emerald-800 font-bold px-1.5 py-0.5 rounded text-[10px]">
                      Pre-Qualified
                    </span>
                  </div>
                </div>
              </div>

              <div className="flex gap-2">
                <button
                  onClick={() => setStep(2)}
                  className="w-1/3 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl font-semibold text-xs transition"
                >
                  Back
                </button>
                <button
                  onClick={handleKycAndSubmit}
                  disabled={isVerifying}
                  className="w-2/3 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl font-bold text-xs flex items-center justify-center gap-1.5 transition shadow-lg shadow-emerald-600/20"
                >
                  {isVerifying ? (
                    <span className="flex items-center gap-2">
                      <span className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                      Verifying with Bank...
                    </span>
                  ) : (
                    <>
                      <Sparkles className="w-4 h-4" />
                      <span>{isCard ? 'Submit & Issue Card' : isInsurance ? 'Submit & Issue Policy' : isInvestment ? 'Submit & Setup SIP' : 'Submit & Generate Sanction'}</span>
                    </>
                  )}
                </button>
              </div>
            </div>
          )}

          {/* STEP 4: Sanction & Approval Success */}
          {step === 4 && (
            <div className="text-center py-2 space-y-4">
              <div className="w-14 h-14 bg-emerald-100 text-emerald-600 rounded-full flex items-center justify-center mx-auto shadow-md">
                <CheckCircle className="w-8 h-8" />
              </div>

              <div>
                <span className="bg-emerald-100 text-emerald-800 text-[11px] font-bold px-2 py-0.5 rounded-full">
                  {isCard ? 'Instant Card Approval' : isInsurance ? 'Policy Issued Online' : isInvestment ? 'SIP Mandate Active' : 'Instant Sanction Approved'}
                </span>
                <h4 className="text-lg font-bold text-slate-900 mt-1">Congratulations, {applicantName}!</h4>
                <p className="text-xs text-slate-600 max-w-sm mx-auto">
                  Your application for <strong className="text-slate-900">{product.name}</strong> has been sanctioned by {product.bank}.
                </p>
              </div>

              <div className="bg-slate-50 border border-slate-200 rounded-xl p-3.5 text-xs text-left space-y-1.5">
                <div className="flex justify-between">
                  <span className="text-slate-500">Application Reference ID:</span>
                  <span className="font-mono font-bold text-blue-600">{applicationResult?.id}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500">{isCard ? 'Approved Credit Limit:' : isInvestment ? 'Monthly SIP Amount:' : 'Approved Amount:'}</span>
                  <span className="font-bold text-slate-900">₹{amount.toLocaleString('en-IN')}</span>
                </div>
                {!isCard && !isInsurance && (
                  <div className="flex justify-between">
                    <span className="text-slate-500">Monthly Commitment:</span>
                    <span className="font-bold text-emerald-600">₹{(isInvestment ? amount : emi).toLocaleString('en-IN')} / mo</span>
                  </div>
                )}
                <div className="flex justify-between">
                  <span className="text-slate-500">Digital Execution Status:</span>
                  <span className="font-bold text-emerald-700">✓ In-Principle Approved</span>
                </div>
              </div>

              <div className="pt-2 flex flex-col sm:flex-row gap-2">
                <button
                  onClick={() => downloadSanctionLetter(applicationResult || {
                    id: 'APP-10821',
                    productName: product.name,
                    bank: product.bank,
                    amount,
                    tenure,
                    interestRate: rate,
                    emi: isInvestment ? amount : emi,
                    applicantName,
                    pan
                  })}
                  className="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-xl font-bold text-xs transition flex items-center justify-center gap-1.5 border border-slate-200"
                >
                  <Download className="w-4 h-4 text-blue-600" />
                  <span>Download Sanction Document</span>
                </button>
                <button
                  onClick={onClose}
                  className="flex-1 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-bold text-xs transition shadow-md shadow-blue-500/20 flex items-center justify-center gap-1.5"
                >
                  <CheckCircle className="w-4 h-4" />
                  <span>Done & View in Dashboard</span>
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default ApplicationModal;
