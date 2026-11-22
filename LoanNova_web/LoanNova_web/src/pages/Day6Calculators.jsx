import React, { useState } from 'react';
import { 
  Calculator, 
  Percent, 
  Calendar, 
  Coins, 
  ArrowRight, 
  PieChart, 
  Sparkles,
  TrendingUp,
  ShieldCheck 
} from 'lucide-react';

export function Day6Calculators({ onApplyCustomLoan, setActiveTab }) {
  const [activeCalc, setActiveCalc] = useState('emi'); // 'emi' | 'sip' | 'fd' | 'eligibility'

  // EMI Calculator State
  const [loanAmount, setLoanAmount] = useState(500000);
  const [loanRate, setLoanRate] = useState(10.5);
  const [loanTenure, setLoanTenure] = useState(36); // months

  // SIP Calculator State
  const [sipMonthly, setSipMonthly] = useState(5000);
  const [sipReturn, setSipReturn] = useState(14); // %
  const [sipYears, setSipYears] = useState(5);

  // FD Calculator State
  const [fdAmount, setFdAmount] = useState(100000);
  const [fdRate, setFdRate] = useState(7.5);
  const [fdYears, setFdYears] = useState(3);

  // Eligibility State
  const [salary, setSalary] = useState(60000);
  const [existingEmi, setExistingEmi] = useState(10000);

  // --- Calculations ---
  // 1. EMI
  const rEmi = (loanRate / 12) / 100;
  const nEmi = loanTenure;
  const emiMonthly = Math.round((loanAmount * rEmi * Math.pow(1 + rEmi, nEmi)) / (Math.pow(1 + rEmi, nEmi) - 1)) || 0;
  const totalPayable = emiMonthly * nEmi;
  const totalInterest = Math.max(0, totalPayable - loanAmount);
  const principalPercent = totalPayable > 0 ? Math.round((loanAmount / totalPayable) * 100) : 100;
  const interestPercent = 100 - principalPercent;

  // 2. SIP: M = P * ({[1 + i]^n - 1} / i) * (1 + i)
  const iSip = (sipReturn / 12) / 100;
  const nSip = sipYears * 12;
  const investedSip = sipMonthly * nSip;
  const totalSipValue = Math.round(sipMonthly * ((Math.pow(1 + iSip, nSip) - 1) / iSip) * (1 + iSip)) || 0;
  const estWealthGain = Math.max(0, totalSipValue - investedSip);

  // 3. FD: Compound interest annually A = P * (1 + r/n)^(nt)
  const fdMaturity = Math.round(fdAmount * Math.pow(1 + fdRate / 100, fdYears));
  const fdInterest = Math.max(0, fdMaturity - fdAmount);

  // 4. Eligibility: Max FOIR 50%
  const maxAffordableEmi = Math.max(0, Math.round(salary * 0.5 - existingEmi));
  // Approx loan eligibility assuming 10.5% for 5 years (60 mos)
  const approxEligibleLoan = Math.round(maxAffordableEmi * 46.5);

  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-bold mb-1.5">
            <span>PLANNING SUITE</span>
            <span>•</span>
            <span>Financial Calculators</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Interactive Financial Planning & EMI Simulation
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Real-time calculations for Loan EMIs, SIP Wealth Growth, Fixed Deposit Maturity and Max Borrowing Eligibility.
          </p>
        </div>

        <button
          onClick={() => setActiveTab('credit-score')}
          className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition self-stretch md:self-auto justify-center"
        >
          <span>Check Credit Score</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      {/* Calculator Type Selector */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-2">
        {[
          { id: 'emi', label: 'Loan EMI Calculator' },
          { id: 'sip', label: 'SIP Wealth Calculator' },
          { id: 'fd', label: 'Fixed Deposit (FD)' },
          { id: 'eligibility', label: 'Borrowing Eligibility' },
        ].map((c) => (
          <button
            key={c.id}
            onClick={() => setActiveCalc(c.id)}
            className={`py-3 px-3 rounded-xl text-xs font-bold transition text-center ${
              activeCalc === c.id
                ? 'bg-blue-600 text-white shadow-md shadow-blue-500/20'
                : 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200'
            }`}
          >
            {c.label}
          </button>
        ))}
      </div>

      {/* CALCULATOR 1: EMI CALCULATOR */}
      {activeCalc === 'emi' && (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          {/* Sliders Input */}
          <div className="lg:col-span-7 space-y-6">
            <h3 className="text-sm font-bold text-slate-900">Loan Parameters</h3>

            {/* Loan Amount Slider */}
            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Loan Amount</span>
                <span className="text-base font-extrabold text-blue-600">
                  ₹{loanAmount.toLocaleString('en-IN')}
                </span>
              </div>
              <input
                type="range"
                min="50000"
                max="5000000"
                step="25000"
                value={loanAmount}
                onChange={(e) => setLoanAmount(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
              <div className="flex gap-2 mt-2">
                {[200000, 500000, 1000000, 2500000].map((preset) => (
                  <button
                    key={preset}
                    onClick={() => setLoanAmount(preset)}
                    className="px-2.5 py-1 text-[11px] font-semibold bg-slate-100 hover:bg-blue-50 text-slate-700 hover:text-blue-600 rounded-lg transition"
                  >
                    ₹{(preset / 100000).toFixed(0)}L
                  </button>
                ))}
              </div>
            </div>

            {/* Interest Rate Slider */}
            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Interest Rate (% p.a.)</span>
                <span className="text-base font-extrabold text-blue-600">{loanRate}%</span>
              </div>
              <input
                type="range"
                min="8.0"
                max="24.0"
                step="0.25"
                value={loanRate}
                onChange={(e) => setLoanRate(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
              <div className="flex justify-between text-[11px] text-slate-400 mt-1">
                <span>8.0% (Home Loan)</span>
                <span>10.5% (Personal)</span>
                <span>18.0% (Business)</span>
              </div>
            </div>

            {/* Tenure Slider */}
            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Tenure</span>
                <span className="text-base font-extrabold text-blue-600">
                  {loanTenure} Months ({(loanTenure / 12).toFixed(1)} Yrs)
                </span>
              </div>
              <input
                type="range"
                min="12"
                max="84"
                step="6"
                value={loanTenure}
                onChange={(e) => setLoanTenure(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
              <div className="flex gap-2 mt-2">
                {[12, 24, 36, 60, 84].map((t) => (
                  <button
                    key={t}
                    onClick={() => setLoanTenure(t)}
                    className="px-2.5 py-1 text-[11px] font-semibold bg-slate-100 hover:bg-blue-50 text-slate-700 hover:text-blue-600 rounded-lg transition"
                  >
                    {t / 12} Yrs
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Results Summary Box */}
          <div className="lg:col-span-5 bg-slate-900 text-white rounded-xl p-6 flex flex-col justify-between">
            <div>
              <span className="text-xs font-semibold text-blue-400 uppercase tracking-wider block mb-1">
                Estimated Monthly Repayment
              </span>
              <div className="text-3xl font-extrabold text-white mb-4">
                ₹{emiMonthly.toLocaleString('en-IN')}{' '}
                <span className="text-xs font-normal text-slate-400">/ month</span>
              </div>

              {/* Progress bar visual */}
              <div className="mb-4">
                <div className="flex justify-between text-[11px] text-slate-400 mb-1">
                  <span>Principal: {principalPercent}%</span>
                  <span>Interest: {interestPercent}%</span>
                </div>
                <div className="h-3 w-full bg-slate-700 rounded-full overflow-hidden flex">
                  <div
                    style={{ width: `${principalPercent}%` }}
                    className="bg-blue-500 h-full"
                  ></div>
                  <div
                    style={{ width: `${interestPercent}%` }}
                    className="bg-amber-400 h-full"
                  ></div>
                </div>
              </div>

              <div className="space-y-2.5 text-xs border-t border-slate-800 pt-3">
                <div className="flex justify-between">
                  <span className="text-slate-400">Principal Loan:</span>
                  <span className="font-bold">₹{loanAmount.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Total Interest Payable:</span>
                  <span className="font-bold text-amber-400">₹{totalInterest.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between pt-1 border-t border-slate-800 font-bold">
                  <span className="text-slate-300">Total Repayment:</span>
                  <span className="text-emerald-400">₹{totalPayable.toLocaleString('en-IN')}</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => {
                onApplyCustomLoan({
                  name: `Custom Loan (₹${(loanAmount / 100000).toFixed(1)}L)`,
                  subType: 'Personal Loan',
                  bank: 'HDFC / SBI Partner Match',
                  interestRate: loanRate,
                  minAmount: loanAmount,
                  maxAmount: loanAmount,
                  minTenure: loanTenure,
                  maxTenure: loanTenure,
                });
              }}
              className="mt-6 w-full py-2.5 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl text-xs flex items-center justify-center gap-1.5 transition shadow-lg shadow-blue-600/30"
            >
              <span>Apply for this Loan Offer</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      {/* CALCULATOR 2: SIP CALCULATOR */}
      {activeCalc === 'sip' && (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div className="lg:col-span-7 space-y-6">
            <h3 className="text-sm font-bold text-slate-900">Systematic Investment Plan (SIP)</h3>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Monthly Investment</span>
                <span className="text-base font-extrabold text-emerald-600">₹{sipMonthly.toLocaleString('en-IN')}</span>
              </div>
              <input
                type="range"
                min="500"
                max="100000"
                step="500"
                value={sipMonthly}
                onChange={(e) => setSipMonthly(Number(e.target.value))}
                className="w-full accent-emerald-600 cursor-pointer"
              />
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Expected Annual Return (% p.a.)</span>
                <span className="text-base font-extrabold text-emerald-600">{sipReturn}%</span>
              </div>
              <input
                type="range"
                min="6"
                max="25"
                step="0.5"
                value={sipReturn}
                onChange={(e) => setSipReturn(Number(e.target.value))}
                className="w-full accent-emerald-600 cursor-pointer"
              />
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Investment Horizon</span>
                <span className="text-base font-extrabold text-emerald-600">{sipYears} Years</span>
              </div>
              <input
                type="range"
                min="1"
                max="30"
                step="1"
                value={sipYears}
                onChange={(e) => setSipYears(Number(e.target.value))}
                className="w-full accent-emerald-600 cursor-pointer"
              />
            </div>
          </div>

          <div className="lg:col-span-5 bg-slate-900 text-white rounded-xl p-6 flex flex-col justify-between">
            <div>
              <span className="text-xs font-semibold text-emerald-400 uppercase tracking-wider block mb-1">
                Estimated Maturity Wealth
              </span>
              <div className="text-3xl font-extrabold text-emerald-400 mb-4">
                ₹{totalSipValue.toLocaleString('en-IN')}
              </div>

              <div className="space-y-2.5 text-xs border-t border-slate-800 pt-3">
                <div className="flex justify-between">
                  <span className="text-slate-400">Total Invested Amount:</span>
                  <span className="font-bold">₹{investedSip.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Est. Compounded Gain:</span>
                  <span className="font-bold text-emerald-400">+₹{estWealthGain.toLocaleString('en-IN')}</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => setActiveTab('insurance')}
              className="mt-6 w-full py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-xl text-xs flex items-center justify-center gap-1.5 transition"
            >
              <span>Explore Top SIP Funds</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      {/* CALCULATOR 3: FD CALCULATOR */}
      {activeCalc === 'fd' && (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div className="lg:col-span-7 space-y-6">
            <h3 className="text-sm font-bold text-slate-900">Fixed Deposit (FD) Yield</h3>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Deposit Amount</span>
                <span className="text-base font-extrabold text-blue-600">₹{fdAmount.toLocaleString('en-IN')}</span>
              </div>
              <input
                type="range"
                min="10000"
                max="2000000"
                step="10000"
                value={fdAmount}
                onChange={(e) => setFdAmount(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Interest Rate (% p.a.)</span>
                <span className="text-base font-extrabold text-blue-600">{fdRate}%</span>
              </div>
              <input
                type="range"
                min="5"
                max="10"
                step="0.25"
                value={fdRate}
                onChange={(e) => setFdRate(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Duration</span>
                <span className="text-base font-extrabold text-blue-600">{fdYears} Years</span>
              </div>
              <input
                type="range"
                min="1"
                max="10"
                step="1"
                value={fdYears}
                onChange={(e) => setFdYears(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
            </div>
          </div>

          <div className="lg:col-span-5 bg-slate-900 text-white rounded-xl p-6 flex flex-col justify-between">
            <div>
              <span className="text-xs font-semibold text-blue-400 uppercase tracking-wider block mb-1">
                Total Maturity Amount
              </span>
              <div className="text-3xl font-extrabold text-white mb-4">
                ₹{fdMaturity.toLocaleString('en-IN')}
              </div>

              <div className="space-y-2.5 text-xs border-t border-slate-800 pt-3">
                <div className="flex justify-between">
                  <span className="text-slate-400">Principal Deposit:</span>
                  <span className="font-bold">₹{fdAmount.toLocaleString('en-IN')}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Total Interest Earned:</span>
                  <span className="font-bold text-emerald-400">+₹{fdInterest.toLocaleString('en-IN')}</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => setActiveTab('cards')}
              className="mt-6 w-full py-2.5 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl text-xs flex items-center justify-center gap-1.5 transition"
            >
              <span>View High Interest FDs</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}

      {/* CALCULATOR 4: ELIGIBILITY & AFFORDABILITY */}
      {activeCalc === 'eligibility' && (
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
          <div className="lg:col-span-7 space-y-6">
            <h3 className="text-sm font-bold text-slate-900">Borrowing Capacity & FOIR Checker</h3>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Net Monthly Salary</span>
                <span className="text-base font-extrabold text-blue-600">₹{salary.toLocaleString('en-IN')}</span>
              </div>
              <input
                type="range"
                min="20000"
                max="300000"
                step="5000"
                value={salary}
                onChange={(e) => setSalary(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
            </div>

            <div>
              <div className="flex justify-between text-xs font-semibold mb-2">
                <span className="text-slate-600">Existing Monthly EMIs</span>
                <span className="text-base font-extrabold text-blue-600">₹{existingEmi.toLocaleString('en-IN')}</span>
              </div>
              <input
                type="range"
                min="0"
                max="100000"
                step="2500"
                value={existingEmi}
                onChange={(e) => setExistingEmi(Number(e.target.value))}
                className="w-full accent-blue-600 cursor-pointer"
              />
            </div>
          </div>

          <div className="lg:col-span-5 bg-slate-900 text-white rounded-xl p-6 flex flex-col justify-between">
            <div>
              <span className="text-xs font-semibold text-emerald-400 uppercase tracking-wider block mb-1">
                Max Eligible Loan Amount
              </span>
              <div className="text-3xl font-extrabold text-emerald-400 mb-4">
                ₹{approxEligibleLoan.toLocaleString('en-IN')}
              </div>

              <div className="space-y-2.5 text-xs border-t border-slate-800 pt-3">
                <div className="flex justify-between">
                  <span className="text-slate-400">Max Safe EMI (50% FOIR):</span>
                  <span className="font-bold text-white">₹{maxAffordableEmi.toLocaleString('en-IN')}/mo</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-400">Approval Likelihood:</span>
                  <span className="font-bold text-emerald-400">98% (High Pre-Approval)</span>
                </div>
              </div>
            </div>

            <button
              onClick={() => setActiveTab('loans')}
              className="mt-6 w-full py-2.5 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl text-xs flex items-center justify-center gap-1.5 transition"
            >
              <span>Find Matching Pre-Approved Loans</span>
              <ArrowRight className="w-4 h-4" />
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
