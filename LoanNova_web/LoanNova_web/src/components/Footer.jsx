import React from 'react';
import { ShieldCheck, Heart, ExternalLink, Award, Lock } from 'lucide-react';

export function Footer({ setActiveTab }) {
  return (
    <footer className="bg-slate-900 text-slate-400 text-xs border-t border-slate-800 pt-12 pb-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <div className="grid grid-cols-2 md:grid-cols-5 gap-8 pb-10 border-b border-slate-800">
          {/* Brand Info */}
          <div className="col-span-2">
            <div className="flex items-center gap-2 mb-3">
              <div className="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center text-white font-bold">
                <ShieldCheck className="w-5 h-5" />
              </div>
              <span className="text-lg font-bold text-white">Loan<span className="text-blue-500">Nova</span></span>
            </div>
            <p className="text-slate-400 text-xs max-w-sm mb-4 leading-relaxed">
              India's premier AI-powered financial marketplace connecting customers with verified lending institutions and banks for instant, paperless credit.
            </p>
            <div className="flex items-center gap-4 text-[11px] text-slate-400">
              <span className="flex items-center gap-1 text-emerald-400">
                <Lock className="w-3.5 h-3.5" /> 256-Bit SSL
              </span>
              <span className="flex items-center gap-1 text-blue-400">
                <Award className="w-3.5 h-3.5" /> ISO 27001
              </span>
              <span>PCI DSS v4.0</span>
            </div>
          </div>

          {/* Column 1: Marketplace */}
          <div>
            <h4 className="font-bold text-white mb-3 uppercase tracking-wider text-[11px]">Marketplace</h4>
            <ul className="space-y-2">
              <li><button onClick={() => setActiveTab('loans')} className="hover:text-white transition">Personal Loans</button></li>
              <li><button onClick={() => setActiveTab('loans')} className="hover:text-white transition">Home Loans</button></li>
              <li><button onClick={() => setActiveTab('loans')} className="hover:text-white transition">Business Loans</button></li>
              <li><button onClick={() => setActiveTab('cards')} className="hover:text-white transition">Credit Cards</button></li>
              <li><button onClick={() => setActiveTab('cards')} className="hover:text-white transition">Fixed Deposits</button></li>
            </ul>
          </div>

          {/* Column 2: Tools & AI */}
          <div>
            <h4 className="font-bold text-white mb-3 uppercase tracking-wider text-[11px]">Calculators & AI</h4>
            <ul className="space-y-2">
              <li><button onClick={() => setActiveTab('calculators')} className="hover:text-white transition">EMI Calculator</button></li>
              <li><button onClick={() => setActiveTab('calculators')} className="hover:text-white transition">SIP Calculator</button></li>
              <li><button onClick={() => setActiveTab('credit-score')} className="hover:text-white transition">Free Credit Score</button></li>
              <li><button onClick={() => setActiveTab('kyc')} className="hover:text-white transition">Digital KYC Portal</button></li>
              <li><button onClick={() => setActiveTab('insurance')} className="hover:text-white transition">Insurance & Wealth</button></li>
              <li><button onClick={() => setActiveTab('ai-rewards')} className="hover:text-white transition">Nova AI & Rewards</button></li>
              <li><button onClick={() => setActiveTab('data-catalog')} className="hover:text-white transition">Master Data Catalog</button></li>
            </ul>
          </div>

          {/* Column 3: Platform Operations */}
          <div>
            <h4 className="font-bold text-white mb-3 uppercase tracking-wider text-[11px]">Operations & Security</h4>
            <ul className="space-y-2 text-slate-400">
              <li><button onClick={() => setActiveTab('overview')} className="hover:text-blue-400 transition">Underwriting Desk</button></li>
              <li><button onClick={() => setActiveTab('overview')} className="hover:text-blue-400 transition">Partner Portal</button></li>
              <li><button onClick={() => setActiveTab('overview')} className="hover:text-blue-400 transition">Super Admin Desk</button></li>
              <li><button onClick={() => setActiveTab('overview')} className="hover:text-blue-400 transition font-bold text-blue-400">Fraud Prevention Monitor</button></li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-6 flex flex-col md:flex-row items-center justify-between gap-4 text-[11px] text-slate-500">
          <div>
            © 2026 LoanNova Financial Technologies Ltd. All rights reserved.
          </div>
          <div className="flex items-center gap-6">
            <span>Privacy Policy</span>
            <span>Terms of Service</span>
            <span>RBI Fair Practice Code</span>
            <span>Grievance Redressal</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
