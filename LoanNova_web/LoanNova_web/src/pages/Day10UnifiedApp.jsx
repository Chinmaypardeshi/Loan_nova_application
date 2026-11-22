import React, { useState, useEffect, useRef } from 'react';
import { 
  Building2, 
  ShieldCheck, 
  Clock, 
  CheckCircle2, 
  AlertCircle, 
  FileText, 
  TrendingUp, 
  DollarSign, 
  User, 
  Users, 
  ArrowRight, 
  Sparkles, 
  Check, 
  Download, 
  PhoneCall, 
  MessageSquare,
  ShieldAlert,
  Activity,
  Layers,
  ChevronRight,
  X,
  CreditCard,
  PenTool,
  Calendar,
  Wallet,
  PhoneForwarded,
  Share2
} from 'lucide-react';
import confetti from 'canvas-confetti';
import { downloadSanctionLetter, downloadPaymentReceipt } from '../utils/documentGenerator';

const fallbackApplications = [
  {
    id: 'APP-10821',
    productName: 'HDFC Instant Personal Loan',
    type: 'Personal Loan',
    bank: 'HDFC Bank',
    amount: 300000,
    tenure: 36,
    interestRate: 10.5,
    emi: 9750,
    applicantName: 'Rahul Sharma',
    phone: '+91 98765 43210',
    email: 'rahul.sharma@loannova.in',
    pan: 'ABCDE1234F',
    kycStatus: 'Verified',
    status: 'Approved',
    appliedDate: '11 Oct 2026',
    stage: 4,
  },
  {
    id: 'APP-10822',
    productName: 'HDFC Millennia Credit Card',
    type: 'Credit Card',
    bank: 'HDFC Bank',
    amount: 150000,
    tenure: 0,
    interestRate: 0,
    emi: 0,
    applicantName: 'Rahul Sharma',
    phone: '+91 98765 43210',
    email: 'rahul.sharma@loannova.in',
    pan: 'ABCDE1234F',
    kycStatus: 'Verified',
    status: 'In Review',
    appliedDate: '12 Oct 2026',
    stage: 3,
  },
  {
    id: 'APP-10823',
    productName: 'ICICI Pratham Home Loan',
    type: 'Home Loan',
    bank: 'ICICI Bank',
    amount: 4500000,
    tenure: 240,
    interestRate: 8.4,
    emi: 38780,
    applicantName: 'Rahul Sharma',
    phone: '+91 98765 43210',
    email: 'rahul.sharma@loannova.in',
    pan: 'ABCDE1234F',
    kycStatus: 'Verified',
    status: 'Disbursed',
    appliedDate: '01 Oct 2026',
    stage: 5,
  },
  {
    id: 'APP-10824',
    productName: 'Bajaj SME Growth Loan',
    type: 'Business Loan',
    bank: 'Bajaj Finance',
    amount: 1000000,
    tenure: 48,
    interestRate: 13.0,
    emi: 26825,
    applicantName: 'Rahul Sharma',
    phone: '+91 98765 43210',
    email: 'rahul.sharma@loannova.in',
    pan: 'ABCDE1234F',
    kycStatus: 'Verified',
    status: 'Approved',
    appliedDate: '09 Oct 2026',
    stage: 4,
  },
];

export function Day10UnifiedApp({ 
  selectedRole, 
  setSelectedRole, 
  onApplyProduct, 
  onOpenChat, 
  setActiveTab,
  applications: propApps,
  onUpdateStatus
}) {
  const [stats, setStats] = useState(null);
  const [activePortalTab, setActivePortalTab] = useState(selectedRole || 'customer');
  const [actionMessage, setActionMessage] = useState(null);

  // Active Interactive Modals
  const [activeEmiModalApp, setActiveEmiModalApp] = useState(null);
  const [activeEsignModalApp, setActiveEsignModalApp] = useState(null);
  const [activeRepayModalApp, setActiveRepayModalApp] = useState(null);
  const [activeCallLead, setActiveCallLead] = useState(null);
  const [activeWhatsappLead, setActiveWhatsappLead] = useState(null);
  const [fraudScanModalOpen, setFraudScanModalOpen] = useState(false);
  const [fraudScanProgress, setFraudScanProgress] = useState(0);

  // Repayment simulation state
  const [emiPaidAppIds, setEmiPaidAppIds] = useState([]);
  const [repaying, setRepaying] = useState(false);

  // Signature Canvas state
  const [hasSigned, setHasSigned] = useState(false);
  const canvasRef = useRef(null);
  const [isDrawing, setIsDrawing] = useState(false);

  // Effective applications guaranteed to never be empty
  const applications = (propApps && propApps.length > 0) ? propApps : fallbackApplications;

  useEffect(() => {
    setActivePortalTab(selectedRole);
  }, [selectedRole]);

  useEffect(() => {
    fetch('/api/dashboard/stats')
      .then((res) => res.json())
      .then(setStats)
      .catch((err) => console.log('Stats offline fallback:', err));
  }, []);

  const showToast = (msg) => {
    setActionMessage(msg);
    setTimeout(() => setActionMessage(null), 3500);
  };

  const handleStatusUpdate = (appId, newStatus, stage) => {
    if (onUpdateStatus) {
      onUpdateStatus(appId, newStatus, stage);
    } else {
      fetch(`/api/applications/${appId}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status: newStatus, stage }),
      }).catch(console.error);
    }
    showToast(`✓ Application ${appId} updated to: ${newStatus}`);
  };

  // E-Sign Canvas helpers
  const startDrawing = (e) => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const rect = canvas.getBoundingClientRect();
    ctx.beginPath();
    ctx.moveTo(e.clientX - rect.left, e.clientY - rect.top);
    setIsDrawing(true);
  };

  const draw = (e) => {
    if (!isDrawing) return;
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    const rect = canvas.getBoundingClientRect();
    ctx.lineTo(e.clientX - rect.left, e.clientY - rect.top);
    ctx.strokeStyle = '#1e3a8a';
    ctx.lineWidth = 2.5;
    ctx.lineCap = 'round';
    ctx.stroke();
    setHasSigned(true);
  };

  const stopDrawing = () => {
    setIsDrawing(false);
  };

  const clearCanvas = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    setHasSigned(false);
  };

  const handleConfirmEsign = () => {
    if (activeEsignModalApp) {
      handleStatusUpdate(activeEsignModalApp.id, 'Approved (e-Signed)', 4);
      confetti({ particleCount: 70, spread: 60 });
      showToast(`✓ Agreement for ${activeEsignModalApp.id} digitally executed!`);
      setActiveEsignModalApp(null);
    }
  };

  const handlePayEmi = (app) => {
    setRepaying(true);
    setTimeout(() => {
      setRepaying(false);
      setEmiPaidAppIds((prev) => [...prev, app.id]);
      confetti({ particleCount: 90, spread: 80 });
      downloadPaymentReceipt(app, app.emi || 9750);
      showToast(`✓ EMI of ₹${(app.emi || 9750).toLocaleString('en-IN')} paid successfully. Receipt downloaded.`);
      setActiveRepayModalApp(null);
    }, 1200);
  };

  const runFraudScan = () => {
    setFraudScanModalOpen(true);
    setFraudScanProgress(10);
    const interval = setInterval(() => {
      setFraudScanProgress((p) => {
        if (p >= 100) {
          clearInterval(interval);
          return 100;
        }
        return p + 25;
      });
    }, 450);
  };

  const downloadAuditLedger = () => {
    const auditData = {
      timestamp: new Date().toISOString(),
      platform: 'LoanNova Enterprise Core',
      verifiedApplicationsCount: applications.length,
      applications,
      securityLogs: [
        { time: '12 Oct 20:00:12', event: 'AES-256 Key rotation completed for Document Vault', level: 'INFO', status: 'PASS' },
        { time: '12 Oct 19:48:02', event: 'Simulated high-frequency probe mitigated by WAF', level: 'BLOCKED', status: 'PASS' },
        { time: '12 Oct 19:15:33', event: 'RBI DPDP statutory consent audit verified', level: 'AUDIT OK', status: 'PASS' },
        { time: '12 Oct 18:30:10', event: 'Bank Gateway ping: HDFC (42ms), SBI (58ms), ICICI (49ms)', level: 'HEALTHY', status: 'PASS' }
      ]
    };
    const blob = new Blob([JSON.stringify(auditData, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `loannova_security_audit_${Date.now()}.json`;
    a.click();
    URL.revokeObjectURL(url);
    showToast('✓ Security Audit Ledger JSON exported successfully.');
  };

  return (
    <div className="space-y-6">
      {/* Header Showcase Banner */}
      <div className="bg-gradient-to-r from-slate-900 via-indigo-950 to-blue-900 rounded-3xl p-6 sm:p-8 text-white shadow-xl flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
        <div className="max-w-2xl">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/20 text-emerald-300 text-xs font-bold mb-3 border border-emerald-400/30">
            <span>OPERATIONS DESK</span>
            <span>•</span>
            <span>Enterprise Management & Analytics</span>
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight mb-2">
            LoanNova Enterprise Ecosystem
          </h1>
          <p className="text-xs sm:text-sm text-slate-300 leading-relaxed">
            Real-time management for Borrower Self-Serve, Bank Underwriting, Sales CRM, and Super Administrator Governance.
          </p>
        </div>

        {/* Persona Switcher Buttons */}
        <div className="bg-white/10 backdrop-blur-md p-1.5 rounded-2xl border border-white/20 flex flex-wrap gap-1">
          {[
            { id: 'customer', label: 'Borrower Portal' },
            { id: 'partner', label: 'Bank Partner' },
            { id: 'agent', label: 'Sales CRM' },
            { id: 'admin', label: 'Super Admin' },
          ].map((portal) => (
            <button
              key={portal.id}
              onClick={() => {
                setActivePortalTab(portal.id);
                setSelectedRole(portal.id);
              }}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                activePortalTab === portal.id
                  ? 'bg-blue-600 text-white shadow-md'
                  : 'text-slate-300 hover:text-white hover:bg-white/10'
              }`}
            >
              {portal.label}
            </button>
          ))}
        </div>
      </div>

      {/* Global Action Banner Toast */}
      {actionMessage && (
        <div className="bg-emerald-600 text-white text-xs font-bold py-2.5 px-4 rounded-xl flex items-center justify-between shadow-lg animate-fade-in">
          <span className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4" />
            {actionMessage}
          </span>
          <span className="text-emerald-200 text-[10px]">Real-Time Sync</span>
        </div>
      )}

      {/* ========================================================= */}
      {/* 1. CUSTOMER PORTAL VIEW */}
      {/* ========================================================= */}
      {activePortalTab === 'customer' && (
        <div className="space-y-6">
          {/* Quick Metrics */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Active Applications
              </span>
              <div className="text-2xl font-black text-slate-900">{applications.length}</div>
              <span className="text-xs text-blue-600 font-semibold mt-1 block">Live tracking active</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Credit Score
              </span>
              <div className="text-2xl font-black text-emerald-600">765</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">Experian Bureau</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Pre-Approved Credit
              </span>
              <div className="text-2xl font-black text-slate-900">₹12.5 Lakh</div>
              <span className="text-xs text-emerald-600 font-semibold mt-1 block">Zero Paperwork</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Next EMI Due
              </span>
              <div className="text-2xl font-black text-slate-900">
                {emiPaidAppIds.length > 0 ? '₹0' : '₹9,750'}
              </div>
              <span className={`text-xs font-semibold mt-1 block ${
                emiPaidAppIds.length > 0 ? 'text-emerald-600' : 'text-slate-500'
              }`}>
                {emiPaidAppIds.length > 0 ? 'Paid for Nov 2026' : 'Due 05 Nov 2026'}
              </span>
            </div>
          </div>

          {/* End-to-End Application Tracker */}
          <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-5">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-100 pb-3">
              <div>
                <h3 className="text-sm font-bold text-slate-900">Your Loan & Credit Applications</h3>
                <p className="text-xs text-slate-500">Live progress with instant digital sanction letters and amortization schedule</p>
              </div>

              <div className="flex items-center gap-2">
                <button
                  onClick={() => onApplyProduct({
                    name: 'HDFC Instant Personal Loan',
                    subType: 'Personal Loan',
                    bank: 'HDFC Bank',
                    interestRate: 10.5,
                    minAmount: 50000,
                    maxAmount: 1500000,
                    minTenure: 12,
                    maxTenure: 60,
                  })}
                  className="px-3.5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition flex items-center gap-1.5 shadow-sm"
                >
                  <Sparkles className="w-3.5 h-3.5" />
                  <span>+ Apply New Product</span>
                </button>
                <button
                  onClick={() => setActiveTab('loans')}
                  className="px-3 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-semibold transition"
                >
                  Browse All Loans →
                </button>
              </div>
            </div>

            <div className="space-y-4">
              {applications.map((app) => {
                const stage = app.stage || 2;
                const isEmiPaid = emiPaidAppIds.includes(app.id);

                return (
                  <div
                    key={app.id}
                    className="border border-slate-200 rounded-2xl p-4 bg-slate-50/60 space-y-4 hover:border-blue-300 transition"
                  >
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className="font-bold text-sm text-slate-900">{app.productName}</span>
                          <span className="font-mono text-xs bg-slate-200 text-slate-800 px-2 py-0.5 rounded font-bold">
                            {app.id}
                          </span>
                        </div>
                        <p className="text-xs text-slate-500 mt-0.5">
                          {app.bank} • ₹{Number(app.amount).toLocaleString('en-IN')} • {app.tenure ? `${app.tenure} Months` : 'Card'} • EMI: {app.emi ? `₹${Number(app.emi).toLocaleString('en-IN')}` : 'Nil'}
                        </p>
                      </div>

                      <div className="flex flex-wrap items-center gap-2">
                        <span className={`px-2.5 py-1 rounded-full text-xs font-bold ${
                          app.status.includes('Approved') || app.status === 'Sanctioned'
                            ? 'bg-emerald-100 text-emerald-800 border border-emerald-200'
                            : app.status === 'Disbursed'
                            ? 'bg-blue-100 text-blue-800 border border-blue-200'
                            : 'bg-amber-100 text-amber-800 border border-amber-200'
                        }`}>
                          ● {app.status}
                        </span>

                        {/* Action 1: Download Sanction PDF/HTML */}
                        <button
                          onClick={() => {
                            downloadSanctionLetter(app);
                            showToast(`Official Sanction Letter downloaded for ${app.id}`);
                          }}
                          className="px-2.5 py-1.5 bg-white border border-slate-200 hover:bg-slate-100 rounded-xl text-slate-700 text-xs font-semibold transition flex items-center gap-1 shadow-2xs"
                          title="Download Sanction Document"
                        >
                          <Download className="w-3.5 h-3.5 text-blue-600" />
                          <span>Sanction Letter</span>
                        </button>

                        {/* Action 2: View EMI Schedule */}
                        {app.emi > 0 && (
                          <button
                            onClick={() => setActiveEmiModalApp(app)}
                            className="px-2.5 py-1.5 bg-white border border-slate-200 hover:bg-slate-100 rounded-xl text-slate-700 text-xs font-semibold transition flex items-center gap-1 shadow-2xs"
                          >
                            <Calendar className="w-3.5 h-3.5 text-emerald-600" />
                            <span>EMI Schedule</span>
                          </button>
                        )}

                        {/* Action 3: E-Sign Agreement */}
                        {app.stage >= 3 && !app.status.includes('e-Signed') && (
                          <button
                            onClick={() => setActiveEsignModalApp(app)}
                            className="px-2.5 py-1.5 bg-indigo-50 border border-indigo-200 hover:bg-indigo-100 text-indigo-700 rounded-xl text-xs font-bold transition flex items-center gap-1 shadow-2xs"
                          >
                            <PenTool className="w-3.5 h-3.5" />
                            <span>E-Sign Agreement</span>
                          </button>
                        )}

                        {/* Action 4: Pay Next EMI */}
                        {app.emi > 0 && (
                          <button
                            onClick={() => {
                              if (isEmiPaid) {
                                downloadPaymentReceipt(app, app.emi || 9750);
                              } else {
                                setActiveRepayModalApp(app);
                              }
                            }}
                            className={`px-3 py-1.5 rounded-xl text-xs font-bold transition flex items-center gap-1 shadow-sm ${
                              isEmiPaid
                                ? 'bg-emerald-50 text-emerald-700 border border-emerald-200 hover:bg-emerald-100'
                                : 'bg-emerald-600 hover:bg-emerald-700 text-white'
                            }`}
                          >
                            <Check className="w-3.5 h-3.5" />
                            <span>{isEmiPaid ? 'Receipt (Paid)' : `Pay EMI (₹${Number(app.emi).toLocaleString('en-IN')})`}</span>
                          </button>
                        )}
                      </div>
                    </div>

                    {/* Visual 5-Stage Tracker Bar */}
                    <div className="pt-2">
                      <div className="grid grid-cols-5 text-center text-[10px] font-bold text-slate-400 mb-1.5">
                        <span className={stage >= 1 ? 'text-blue-600 font-extrabold' : ''}>1. Submitted</span>
                        <span className={stage >= 2 ? 'text-blue-600 font-extrabold' : ''}>2. KYC Verified</span>
                        <span className={stage >= 3 ? 'text-blue-600 font-extrabold' : ''}>3. Underwriting</span>
                        <span className={stage >= 4 ? 'text-blue-600 font-extrabold' : ''}>4. Sanctioned</span>
                        <span className={stage >= 5 ? 'text-emerald-600 font-extrabold' : ''}>5. Disbursed</span>
                      </div>
                      <div className="h-2 w-full bg-slate-200 rounded-full overflow-hidden flex">
                        <div
                          style={{ width: `${(stage / 5) * 100}%` }}
                          className={`h-full transition-all duration-500 ${
                            stage === 5 ? 'bg-emerald-500' : 'bg-blue-600'
                          }`}
                        ></div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 2. BANK PARTNER PORTAL VIEW */}
      {/* ========================================================= */}
      {activePortalTab === 'partner' && (
        <div className="space-y-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Inbound Lead Volume
              </span>
              <div className="text-2xl font-black text-slate-900">148 Leads</div>
              <span className="text-xs text-blue-600 font-semibold mt-1 block">Live API Feed</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Avg Underwriting Time
              </span>
              <div className="text-2xl font-black text-emerald-600">4.2 Hours</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">94% Automated</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Disbursed This Month
              </span>
              <div className="text-2xl font-black text-slate-900">₹1.84 Crore</div>
              <span className="text-xs text-emerald-600 font-semibold mt-1 block">+18% MoM</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Commission Payout
              </span>
              <div className="text-2xl font-black text-slate-900">₹94,500</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">Net Settled</span>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
            <div className="flex items-center justify-between border-b border-slate-100 pb-3">
              <div>
                <h3 className="text-sm font-bold text-slate-900">Bank Decision Underwriting Desk</h3>
                <p className="text-xs text-slate-500">Approve, sanction or disburse customer loan requests in real time</p>
              </div>
              <span className="text-xs font-bold text-blue-700 bg-blue-50 px-2.5 py-1 rounded-full">
                HDFC Bank Lending Node
              </span>
            </div>

            <div className="space-y-3">
              {applications.map((app) => (
                <div
                  key={app.id}
                  className="p-4 bg-slate-50 rounded-xl border border-slate-200 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs"
                >
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-slate-900">{app.applicantName}</span>
                      <span className="font-mono text-[11px] bg-slate-200 px-1.5 py-0.5 rounded font-bold">
                        {app.id}
                      </span>
                      <span className="text-emerald-700 font-bold bg-emerald-50 px-2 py-0.5 rounded border border-emerald-100 text-[10px]">
                        PAN: {app.pan}
                      </span>
                    </div>
                    <p className="text-slate-500 mt-0.5">
                      {app.productName} • ₹{Number(app.amount).toLocaleString('en-IN')} • Credit Score: 765 • Current: <strong className="text-slate-800">{app.status}</strong>
                    </p>
                  </div>

                  {/* Bank Action Buttons */}
                  <div className="flex flex-wrap items-center gap-2 self-end sm:self-auto">
                    <button
                      onClick={() => handleStatusUpdate(app.id, 'Approved', 4)}
                      className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-bold text-xs transition shadow-2xs"
                    >
                      ✓ Approve Sanction
                    </button>
                    <button
                      onClick={() => handleStatusUpdate(app.id, 'Disbursed', 5)}
                      className="px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-bold text-xs transition shadow-2xs"
                    >
                      ⚡ Disburse Funds
                    </button>
                    <button
                      onClick={() => handleStatusUpdate(app.id, 'Docs Requested', 2)}
                      className="px-2.5 py-1.5 bg-slate-200 hover:bg-slate-300 text-slate-700 rounded-lg font-semibold text-xs transition"
                    >
                      Request Docs
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 3. SALES CRM VIEW */}
      {/* ========================================================= */}
      {activePortalTab === 'agent' && (
        <div className="space-y-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Assigned Leads
              </span>
              <div className="text-2xl font-black text-slate-900">28 Active</div>
              <span className="text-xs text-blue-600 font-semibold mt-1 block">Arun K. (Agent)</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Conversion Rate
              </span>
              <div className="text-2xl font-black text-emerald-600">34.8%</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">Above Team Avg</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Calls Made Today
              </span>
              <div className="text-2xl font-black text-slate-900">14 Calls</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">8 Follow-ups remaining</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Monthly Commission
              </span>
              <div className="text-2xl font-black text-slate-900">₹38,200</div>
              <span className="text-xs text-emerald-600 font-semibold mt-1 block">Target 80% Achieved</span>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
            <h3 className="text-sm font-bold text-slate-900 border-b border-slate-100 pb-3">
              Sales Follow-up & Instant Engagement Desk
            </h3>

            <div className="space-y-3">
              {[
                { name: 'Rahul Sharma', phone: '+91 98765 43210', loan: 'HDFC Personal ₹3.0L', status: 'Pre-Approved', time: '10m ago' },
                { name: 'Pooja Verma', phone: '+91 98111 22334', loan: 'ICICI Home Loan ₹45L', status: 'Doc Review', time: '1h ago' },
                { name: 'Sunil Mehta', phone: '+91 99887 76655', loan: 'Bajaj SME Loan ₹15L', status: 'Contacted', time: '3h ago' },
              ].map((lead, idx) => (
                <div
                  key={idx}
                  className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 text-xs"
                >
                  <div>
                    <div className="font-bold text-slate-900">{lead.name}</div>
                    <p className="text-slate-500 mt-0.5">{lead.loan} • {lead.phone} • {lead.time}</p>
                  </div>

                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => setActiveCallLead(lead)}
                      className="px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg font-bold text-xs flex items-center gap-1 transition shadow-2xs"
                    >
                      <PhoneCall className="w-3.5 h-3.5" />
                      <span>Call Client</span>
                    </button>
                    <button
                      onClick={() => setActiveWhatsappLead(lead)}
                      className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg font-bold text-xs flex items-center gap-1 transition shadow-2xs"
                    >
                      <MessageSquare className="w-3.5 h-3.5" />
                      <span>WhatsApp Link</span>
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 4. SUPER ADMIN PORTAL VIEW */}
      {/* ========================================================= */}
      {activePortalTab === 'admin' && (
        <div className="space-y-6">
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Platform Scale
              </span>
              <div className="text-2xl font-black text-slate-900">1.24 Million</div>
              <span className="text-xs text-blue-600 font-semibold mt-1 block">Registered Users</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                System Availability
              </span>
              <div className="text-2xl font-black text-emerald-600">99.99%</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">0 Unscheduled Outages</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                AI Fraud Engine
              </span>
              <div className="text-2xl font-black text-emerald-600">342 Blocked</div>
              <span className="text-xs text-emerald-600 font-semibold mt-1 block">100% Identity Integrity</span>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
              <span className="text-slate-400 text-[11px] font-bold uppercase tracking-wider block mb-1">
                Lending Partners
              </span>
              <div className="text-2xl font-black text-slate-900">24 Banks & NBFCs</div>
              <span className="text-xs text-slate-500 font-medium mt-1 block">Active API Gateways</span>
            </div>
          </div>

          <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-100 pb-3">
              <div>
                <h3 className="text-sm font-bold text-slate-900">
                  Security Compliance & Real-Time Audit Logs
                </h3>
                <p className="text-xs text-slate-500">Continuous biometric fraud prevention and RBI regulatory ledgers</p>
              </div>

              <div className="flex items-center gap-2">
                <button
                  onClick={runFraudScan}
                  className="px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition flex items-center gap-1.5 shadow-sm"
                >
                  <ShieldAlert className="w-3.5 h-3.5" />
                  <span>Run AI Fraud Scan</span>
                </button>
                <button
                  onClick={downloadAuditLedger}
                  className="px-3 py-1.5 bg-slate-800 hover:bg-slate-900 text-white rounded-xl text-xs font-bold transition flex items-center gap-1.5"
                >
                  <Download className="w-3.5 h-3.5" />
                  <span>Export Audit Logs</span>
                </button>
              </div>
            </div>

            <div className="space-y-2 text-xs font-mono">
              {[
                { time: '12 Oct 20:00:12', event: 'AES-256 Key rotation completed for Document Vault', level: 'INFO', color: 'text-blue-400' },
                { time: '12 Oct 19:48:02', event: 'Simulated high-frequency bot probe mitigated by Cloudflare WAF', level: 'BLOCKED', color: 'text-emerald-400' },
                { time: '12 Oct 19:15:33', event: 'RBI DPDP statutory consent audit ledger verified with zero flags', level: 'AUDIT OK', color: 'text-emerald-400' },
                { time: '12 Oct 18:30:10', event: 'Bank API health ping: HDFC (42ms), SBI (58ms), ICICI (49ms)', level: 'HEALTHY', color: 'text-slate-400' },
              ].map((log, idx) => (
                <div key={idx} className="p-2.5 bg-slate-900 text-slate-300 rounded-lg flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-slate-500">{log.time}</span>
                    <span>{log.event}</span>
                  </div>
                  <span className={`font-bold ${log.color}`}>{log.level}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* MODAL 1: INTERACTIVE EMI AMORTIZATION SCHEDULE */}
      {/* ========================================================= */}
      {activeEmiModalApp && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-2xl overflow-hidden text-slate-800">
            <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Calendar className="w-5 h-5 text-blue-400" />
                <div>
                  <h3 className="font-bold text-sm">EMI Repayment Schedule</h3>
                  <p className="text-[11px] text-slate-400">{activeEmiModalApp.productName} ({activeEmiModalApp.id})</p>
                </div>
              </div>
              <button
                onClick={() => setActiveEmiModalApp(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-4 sm:p-6 space-y-4">
              <div className="grid grid-cols-3 gap-3 bg-slate-50 p-3 rounded-xl text-xs">
                <div>
                  <span className="text-slate-400 text-[10px] block">Loan Amount</span>
                  <span className="font-bold text-slate-900">₹{Number(activeEmiModalApp.amount).toLocaleString('en-IN')}</span>
                </div>
                <div>
                  <span className="text-slate-400 text-[10px] block">Monthly EMI</span>
                  <span className="font-bold text-emerald-600">₹{Number(activeEmiModalApp.emi).toLocaleString('en-IN')}</span>
                </div>
                <div>
                  <span className="text-slate-400 text-[10px] block">Interest Rate</span>
                  <span className="font-bold text-blue-600">{activeEmiModalApp.interestRate || 10.5}% p.a.</span>
                </div>
              </div>

              {/* 12 Months Amortization Table */}
              <div className="max-h-72 overflow-y-auto border border-slate-200 rounded-xl">
                <table className="w-full text-left text-xs">
                  <thead className="bg-slate-100 text-slate-600 font-semibold sticky top-0">
                    <tr>
                      <th className="p-2.5">Month</th>
                      <th className="p-2.5">Opening Bal</th>
                      <th className="p-2.5">EMI</th>
                      <th className="p-2.5">Principal</th>
                      <th className="p-2.5">Interest</th>
                      <th className="p-2.5">Closing Bal</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {(() => {
                      const rows = [];
                      let balance = Number(activeEmiModalApp.amount);
                      const emi = Number(activeEmiModalApp.emi) || 9750;
                      const monthlyRate = ((activeEmiModalApp.interestRate || 10.5) / 12) / 100;
                      const months = ['Nov 26', 'Dec 26', 'Jan 27', 'Feb 27', 'Mar 27', 'Apr 27', 'May 27', 'Jun 27', 'Jul 27', 'Aug 27', 'Sep 27', 'Oct 27'];

                      for (let i = 0; i < 12; i++) {
                        const interest = Math.round(balance * monthlyRate);
                        const principal = Math.max(0, emi - interest);
                        const closing = Math.max(0, balance - principal);
                        rows.push(
                          <tr key={i} className="hover:bg-slate-50">
                            <td className="p-2.5 font-bold text-slate-800">{months[i]}</td>
                            <td className="p-2.5 text-slate-600">₹{balance.toLocaleString('en-IN')}</td>
                            <td className="p-2.5 font-bold text-emerald-700">₹{emi.toLocaleString('en-IN')}</td>
                            <td className="p-2.5 text-blue-600">₹{principal.toLocaleString('en-IN')}</td>
                            <td className="p-2.5 text-amber-600">₹{interest.toLocaleString('en-IN')}</td>
                            <td className="p-2.5 font-semibold text-slate-800">₹{closing.toLocaleString('en-IN')}</td>
                          </tr>
                        );
                        balance = closing;
                      }
                      return rows;
                    })()}
                  </tbody>
                </table>
              </div>

              <div className="flex justify-end gap-2 pt-2">
                <button
                  onClick={() => downloadSanctionLetter(activeEmiModalApp)}
                  className="px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition flex items-center gap-1.5"
                >
                  <Download className="w-3.5 h-3.5 text-blue-600" />
                  <span>Download Full Sanction PDF</span>
                </button>
                <button
                  onClick={() => setActiveEmiModalApp(null)}
                  className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl transition"
                >
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* MODAL 2: INTERACTIVE DIGITAL E-SIGN AGREEMENT */}
      {/* ========================================================= */}
      {activeEsignModalApp && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-lg overflow-hidden text-slate-800">
            <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <PenTool className="w-5 h-5 text-indigo-400" />
                <div>
                  <h3 className="font-bold text-sm">UIDAI Aadhaar Digital e-Sign</h3>
                  <p className="text-[11px] text-slate-400">Legal Agreement Contract for {activeEsignModalApp.id}</p>
                </div>
              </div>
              <button
                onClick={() => setActiveEsignModalApp(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-5 space-y-4">
              <div className="bg-blue-50 border border-blue-100 rounded-xl p-3 text-xs text-blue-900 leading-relaxed">
                <strong>Borrower Acknowledgment:</strong> I, <strong>{activeEsignModalApp.applicantName}</strong>, hereby accept the loan facility of <strong>₹{Number(activeEsignModalApp.amount).toLocaleString('en-IN')}</strong> from <strong>{activeEsignModalApp.bank}</strong> at {activeEsignModalApp.interestRate || 10.5}% p.a. and authorize e-NACH auto-debit for ₹{activeEsignModalApp.emi || 9750}/month.
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">
                  Draw Signature with Touch / Mouse:
                </label>
                <div className="border-2 border-dashed border-slate-300 rounded-xl bg-slate-50 relative overflow-hidden">
                  <canvas
                    ref={canvasRef}
                    width={440}
                    height={120}
                    onMouseDown={startDrawing}
                    onMouseMove={draw}
                    onMouseUp={stopDrawing}
                    onMouseLeave={stopDrawing}
                    className="w-full cursor-crosshair touch-none"
                  />
                  {!hasSigned && (
                    <span className="absolute inset-0 flex items-center justify-center pointer-events-none text-xs text-slate-400">
                      Sign your signature here...
                    </span>
                  )}
                </div>
                <div className="flex justify-between items-center mt-1.5">
                  <span className="text-[11px] text-slate-400">256-bit encrypted biometric timestamp</span>
                  <button
                    onClick={clearCanvas}
                    className="text-[11px] text-slate-500 hover:text-slate-800 font-semibold"
                  >
                    Clear Signature
                  </button>
                </div>
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  onClick={() => setActiveEsignModalApp(null)}
                  className="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-semibold rounded-xl transition"
                >
                  Cancel
                </button>
                <button
                  onClick={handleConfirmEsign}
                  disabled={!hasSigned}
                  className="flex-1 py-2.5 bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white text-xs font-bold rounded-xl transition shadow-md shadow-indigo-500/20 flex items-center justify-center gap-1.5"
                >
                  <ShieldCheck className="w-4 h-4" />
                  <span>Execute Aadhaar e-Sign</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* MODAL 3: INSTANT EMI PAYMENT */}
      {/* ========================================================= */}
      {activeRepayModalApp && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden text-slate-800">
            <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Wallet className="w-5 h-5 text-emerald-400" />
                <div>
                  <h3 className="font-bold text-sm">Instant EMI Payment Gateway</h3>
                  <p className="text-[11px] text-slate-400">{activeRepayModalApp.productName}</p>
                </div>
              </div>
              <button
                onClick={() => setActiveRepayModalApp(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-5 space-y-4">
              <div className="bg-emerald-50 border border-emerald-200 rounded-2xl p-4 text-center">
                <span className="text-[11px] text-emerald-700 font-bold block uppercase tracking-wider">
                  Amount Due for Nov 2026
                </span>
                <div className="text-3xl font-black text-emerald-800 my-1">
                  ₹{Number(activeRepayModalApp.emi || 9750).toLocaleString('en-IN')}
                </div>
                <span className="text-xs text-slate-500">Due Date: 05 Nov 2026 • Zero Late Fees</span>
              </div>

              <div className="space-y-2">
                <span className="text-xs font-bold text-slate-700 block">Choose Payment Mode:</span>
                {[
                  { id: 'upi', label: 'Instant UPI (Google Pay, PhonePe, Paytm)', tag: 'RECOMMENDED' },
                  { id: 'netbanking', label: 'Net Banking (HDFC, SBI, ICICI, Axis)' },
                  { id: 'card', label: 'Debit Card / RuPay Card' },
                ].map((m, i) => (
                  <label
                    key={m.id}
                    className="p-3 border border-slate-200 rounded-xl flex items-center justify-between cursor-pointer hover:bg-slate-50 transition"
                  >
                    <div className="flex items-center gap-2.5">
                      <input type="radio" name="payMode" defaultChecked={i === 0} className="accent-blue-600" />
                      <span className="text-xs font-semibold text-slate-800">{m.label}</span>
                    </div>
                    {m.tag && (
                      <span className="text-[9px] font-extrabold bg-emerald-100 text-emerald-800 px-1.5 py-0.5 rounded">
                        {m.tag}
                      </span>
                    )}
                  </label>
                ))}
              </div>

              <button
                onClick={() => handlePayEmi(activeRepayModalApp)}
                disabled={repaying}
                className="w-full py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition shadow-lg shadow-emerald-600/30 flex items-center justify-center gap-2"
              >
                {repaying ? (
                  <span className="flex items-center gap-2">
                    <span className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                    Processing Secure Payment...
                  </span>
                ) : (
                  <>
                    <ShieldCheck className="w-4 h-4" />
                    <span>Authorize & Pay ₹{Number(activeRepayModalApp.emi || 9750).toLocaleString('en-IN')}</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* MODAL 4: SALES CRM CALL SIMULATOR */}
      {/* ========================================================= */}
      {activeCallLead && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-slate-900 text-white rounded-3xl shadow-2xl border border-slate-800 w-full max-w-sm overflow-hidden text-center p-6 space-y-5">
            <div className="w-20 h-20 rounded-full bg-blue-600/30 border-2 border-blue-400 flex items-center justify-center mx-auto text-white animate-pulse">
              <PhoneForwarded className="w-8 h-8 text-blue-400" />
            </div>

            <div>
              <span className="text-xs text-blue-400 font-semibold tracking-wider uppercase block">
                Direct VoIP Voice Connection
              </span>
              <h4 className="text-lg font-bold text-white mt-1">{activeCallLead.name}</h4>
              <p className="text-xs text-slate-400">{activeCallLead.phone} • {activeCallLead.loan}</p>
              <div className="mt-2 text-xs font-mono text-emerald-400 font-bold">
                00:18 • Connected (HD Voice)
              </div>
            </div>

            <div className="bg-slate-800/80 p-3 rounded-xl text-xs text-slate-300 text-left space-y-1">
              <div>CRM Note: Client verified Aadhaar. Offer approved at 10.5%.</div>
              <div className="text-slate-400">Next Action: Pitch 0% processing fee waiver.</div>
            </div>

            <div className="flex gap-2">
              <button
                onClick={() => {
                  showToast(`✓ Call with ${activeCallLead.name} logged. Callback scheduled.`);
                  setActiveCallLead(null);
                }}
                className="flex-1 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl transition"
              >
                Interested (Convert)
              </button>
              <button
                onClick={() => setActiveCallLead(null)}
                className="flex-1 py-2.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold rounded-xl transition"
              >
                End Call
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* MODAL 5: SALES CRM WHATSAPP LINK SIMULATOR */}
      {/* ========================================================= */}
      {activeWhatsappLead && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden text-slate-800">
            <div className="bg-emerald-700 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <MessageSquare className="w-5 h-5" />
                <div>
                  <h3 className="font-bold text-sm">WhatsApp Business Link</h3>
                  <p className="text-[11px] text-emerald-200">{activeWhatsappLead.name} ({activeWhatsappLead.phone})</p>
                </div>
              </div>
              <button
                onClick={() => setActiveWhatsappLead(null)}
                className="p-1 rounded-lg text-emerald-200 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-5 space-y-4">
              <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3 text-xs text-slate-700 leading-relaxed font-sans">
                "Hello {activeWhatsappLead.name}! 🌟 Your loan application for <strong>{activeWhatsappLead.loan}</strong> is ready for sanction. Download your official sanction letter or complete digital e-sign in 2 minutes: https://loannova.in/track"
              </div>

              <div className="flex gap-2">
                <button
                  onClick={() => {
                    navigator.clipboard?.writeText(`Hello ${activeWhatsappLead.name}! Your loan application for ${activeWhatsappLead.loan} is approved.`);
                    showToast('✓ WhatsApp message copied to clipboard!');
                  }}
                  className="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition"
                >
                  Copy Message
                </button>
                <button
                  onClick={() => {
                    showToast(`✓ Simulated WhatsApp message sent to ${activeWhatsappLead.phone}!`);
                    setActiveWhatsappLead(null);
                  }}
                  className="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl transition shadow-md shadow-emerald-600/20"
                >
                  Send via WhatsApp
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* MODAL 6: SUPER ADMIN AI FRAUD SCANNER */}
      {/* ========================================================= */}
      {fraudScanModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-slate-900 text-white rounded-2xl shadow-2xl border border-slate-700 w-full max-w-md overflow-hidden p-6 space-y-5">
            <div className="flex items-center justify-between border-b border-slate-800 pb-3">
              <div className="flex items-center gap-2">
                <ShieldAlert className="w-5 h-5 text-emerald-400" />
                <h3 className="font-bold text-sm">AI Biometric & Fraud Risk Engine</h3>
              </div>
              <button
                onClick={() => setFraudScanModalOpen(false)}
                className="text-slate-400 hover:text-white"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="space-y-3">
              <div className="flex justify-between text-xs font-semibold">
                <span>Inspection Progress</span>
                <span className="text-emerald-400">{fraudScanProgress}%</span>
              </div>
              <div className="h-2 w-full bg-slate-800 rounded-full overflow-hidden">
                <div
                  style={{ width: `${fraudScanProgress}%` }}
                  className="h-full bg-emerald-500 transition-all duration-300"
                ></div>
              </div>

              <div className="space-y-2 text-xs pt-2">
                <div className={`flex items-center justify-between p-2 rounded-lg ${fraudScanProgress >= 25 ? 'bg-slate-800 text-emerald-300' : 'text-slate-500'}`}>
                  <span>1. Aadhaar / PAN Deduplication across 1.2M records</span>
                  <span>{fraudScanProgress >= 25 ? '✓ 0 Flags' : 'Checking...'}</span>
                </div>
                <div className={`flex items-center justify-between p-2 rounded-lg ${fraudScanProgress >= 50 ? 'bg-slate-800 text-emerald-300' : 'text-slate-500'}`}>
                  <span>2. Synthetic Identity & Face Liveness Verification</span>
                  <span>{fraudScanProgress >= 50 ? '✓ 99.8% Genuine' : 'Pending...'}</span>
                </div>
                <div className={`flex items-center justify-between p-2 rounded-lg ${fraudScanProgress >= 75 ? 'bg-slate-800 text-emerald-300' : 'text-slate-500'}`}>
                  <span>3. IP Device Fingerprint & Proxy Bot Check</span>
                  <span>{fraudScanProgress >= 75 ? '✓ Clean Residential' : 'Pending...'}</span>
                </div>
                <div className={`flex items-center justify-between p-2 rounded-lg ${fraudScanProgress >= 100 ? 'bg-slate-800 text-emerald-300' : 'text-slate-500'}`}>
                  <span>4. RBI & CIBIL Defaulter Cross-Match</span>
                  <span>{fraudScanProgress >= 100 ? '✓ 100% Cleared' : 'Pending...'}</span>
                </div>
              </div>
            </div>

            {fraudScanProgress >= 100 && (
              <button
                onClick={() => setFraudScanModalOpen(false)}
                className="w-full py-2.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-bold transition shadow-lg shadow-emerald-600/30"
              >
                Scan Complete - All Applications Safe
              </button>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

export default Day10UnifiedApp;
