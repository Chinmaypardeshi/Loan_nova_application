import React, { useState, useEffect } from 'react';
import { 
  ShieldCheck, 
  TrendingUp, 
  TrendingDown, 
  AlertTriangle, 
  CheckCircle2, 
  ArrowRight, 
  Sparkles, 
  RefreshCw, 
  HelpCircle,
  Award,
  Download,
  FileText,
  X,
  MessageSquare
} from 'lucide-react';
import { downloadCreditReport } from '../utils/documentGenerator';

export function Day7CreditScore({ setActiveTab }) {
  const [scoreData, setScoreData] = useState(null);
  const [loading, setLoading] = useState(false);
  const [simulationMsg, setSimulationMsg] = useState(null);
  const [disputeModalOpen, setDisputeModalOpen] = useState(false);
  const [disputeReason, setDisputeReason] = useState('Incorrect personal details');
  const [disputeSubmitted, setDisputeSubmitted] = useState(false);
  const [toastMsg, setToastMsg] = useState(null);

  useEffect(() => {
    fetchScore();
  }, []);

  const fetchScore = async () => {
    try {
      const res = await fetch('/api/credit-score');
      const data = await res.json();
      setScoreData(data);
    } catch (err) {
      console.error(err);
      // Fallback
      setScoreData({
        score: 765,
        bureau: 'Experian & CIBIL',
        status: 'Excellent',
        updatedDate: '12 Oct 2026',
        factors: [
          { name: 'Payment History', rating: 'Excellent', impact: 'High', value: '100% On-time' },
          { name: 'Credit Utilization', rating: 'Good', impact: 'High', value: '24% (Ideal < 30%)' },
          { name: 'Credit Age', rating: 'Good', impact: 'Medium', value: '4 yrs 2 mos' },
          { name: 'Total Accounts', rating: 'Good', impact: 'Low', value: '5 Active (3 Loans, 2 Cards)' },
          { name: 'Recent Inquiries', rating: 'Excellent', impact: 'Low', value: '1 in last 6 mos' },
        ],
      });
    }
  };

  const showToast = (msg) => {
    setToastMsg(msg);
    setTimeout(() => setToastMsg(null), 3000);
  };

  const handleSimulate = async (action) => {
    setLoading(true);
    try {
      const res = await fetch('/api/credit-score/simulate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action }),
      });
      const data = await res.json();
      setScoreData((prev) => ({
        ...prev,
        score: data.score,
        status: data.status,
      }));
      setSimulationMsg(data.reason || data.message || 'Score adjusted');
    } catch (err) {
      // Local calculation fallback
      setScoreData((prev) => {
        let newScore = prev.score || 765;
        let r = 'Score adjusted';
        if (action === 'pay_on_time') { newScore = Math.min(850, newScore + 15); r = 'Paying EMI on time boosts trust (+15 pts)'; }
        else if (action === 'lower_utilization') { newScore = Math.min(850, newScore + 25); r = 'Reducing balance below 20% boosts score (+25 pts)'; }
        else if (action === 'miss_payment') { newScore = Math.max(500, newScore - 45); r = 'Late default causes major rating reduction (-45 pts)'; }
        else if (action === 'new_inquiry') { newScore = Math.max(500, newScore - 8); r = 'Lender hard pull temporary impact (-8 pts)'; }
        else { newScore = 765; r = 'Reset to verified bureau baseline (765)'; }
        setSimulationMsg(r);
        return { ...prev, score: newScore, status: newScore >= 750 ? 'Excellent' : newScore >= 700 ? 'Good' : 'Fair' };
      });
    } finally {
      setLoading(false);
    }
  };

  const handleDownloadReport = () => {
    downloadCreditReport(scoreData, 'Rahul Sharma', 'ABCDE1234F');
    showToast('✓ Official Experian & CIBIL Credit Report downloaded.');
  };

  const handleSubmitDispute = (e) => {
    e.preventDefault();
    setDisputeSubmitted(true);
    setTimeout(() => {
      setDisputeSubmitted(false);
      setDisputeModalOpen(false);
      showToast('✓ Dispute Ticket EXP-DISP-8921 logged with Experian Bureau. SLA: 48 Hours.');
    }, 1200);
  };

  if (!scoreData) {
    return <div className="p-8 text-center text-xs text-slate-500">Loading Credit Bureau Data...</div>;
  }

  const score = scoreData.score || 765;
  const scorePercent = Math.min(100, Math.max(0, ((score - 300) / 600) * 100));

  return (
    <div className="space-y-6">
      {/* Toast Alert */}
      {toastMsg && (
        <div className="fixed top-20 right-6 z-50 bg-emerald-600 text-white text-xs font-bold py-2.5 px-4 rounded-xl shadow-xl flex items-center gap-2 animate-fade-in">
          <CheckCircle2 className="w-4 h-4" />
          <span>{toastMsg}</span>
        </div>
      )}

      {/* Header Banner */}
      <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-bold mb-1.5">
            <span>CREDIT BUREAU</span>
            <span>•</span>
            <span>Experian & CIBIL Bureau Simulator</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Real-Time Credit Health & Score Booster
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Official credit reporting metrics from Experian & CIBIL with dynamic what-if simulation engine.
          </p>
        </div>

        <div className="flex flex-wrap gap-2">
          <button
            onClick={handleDownloadReport}
            className="px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-xl text-xs font-bold flex items-center gap-1.5 transition border border-slate-200"
          >
            <Download className="w-4 h-4 text-blue-600" />
            <span>Download Official Report</span>
          </button>
          <button
            onClick={() => setActiveTab('kyc')}
            className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition"
          >
            <span>Digital KYC Center</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Credit Score Meter Card */}
        <div className="lg:col-span-5 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex flex-col items-center justify-between text-center space-y-4">
          <div className="w-full flex items-center justify-between text-xs text-slate-400">
            <span className="font-semibold text-slate-700">{scoreData.bureau}</span>
            <span>Updated: {scoreData.updatedDate || '12 Oct 2026'}</span>
          </div>

          {/* Score Circular Visual */}
          <div className="my-3 relative flex flex-col items-center">
            <div className="w-48 h-48 rounded-full border-8 border-slate-100 flex flex-col items-center justify-center relative shadow-inner">
              <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
                Credit Rating
              </span>
              <span className="text-5xl font-black text-slate-900 my-1">{score}</span>
              <span className={`text-xs font-extrabold px-2.5 py-0.5 rounded-full ${
                score >= 750
                  ? 'bg-emerald-100 text-emerald-800'
                  : score >= 700
                  ? 'bg-blue-100 text-blue-800'
                  : 'bg-amber-100 text-amber-800'
              }`}>
                {scoreData.status}
              </span>
            </div>

            {/* Scale Bar */}
            <div className="w-56 mt-4">
              <div className="flex justify-between text-[10px] text-slate-400 font-bold mb-1">
                <span>300 Poor</span>
                <span>650 Fair</span>
                <span>750 Good</span>
                <span>900 Excellent</span>
              </div>
              <div className="h-2 w-full bg-slate-200 rounded-full overflow-hidden">
                <div
                  style={{ width: `${scorePercent}%` }}
                  className={`h-full transition-all duration-500 ${
                    score >= 750 ? 'bg-emerald-500' : score >= 700 ? 'bg-blue-500' : 'bg-amber-500'
                  }`}
                ></div>
              </div>
            </div>
          </div>

          <div className="w-full bg-slate-50 border border-slate-100 rounded-xl p-3 text-xs text-slate-600 flex items-center justify-between">
            <span className="flex items-center gap-1.5 font-medium">
              <Award className="w-4 h-4 text-emerald-600" />
              Pre-Approved Loan Limit:
            </span>
            <span className="font-bold text-slate-900">₹12,50,000</span>
          </div>

          {/* Action Row */}
          <div className="w-full grid grid-cols-2 gap-2 pt-2">
            <button
              onClick={handleDownloadReport}
              className="py-2.5 px-3 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm"
            >
              <Download className="w-3.5 h-3.5" />
              <span>Full PDF Report</span>
            </button>
            <button
              onClick={() => setDisputeModalOpen(true)}
              className="py-2.5 px-3 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 border border-slate-200"
            >
              <AlertTriangle className="w-3.5 h-3.5 text-amber-600" />
              <span>File Dispute</span>
            </button>
          </div>
        </div>

        {/* Right Column: Simulator & Factor Breakdown */}
        <div className="lg:col-span-7 space-y-6">
          {/* Interactive Simulator Controls */}
          <div className="bg-slate-900 text-white rounded-2xl p-5 shadow-sm space-y-3">
            <div className="flex items-center justify-between">
              <h3 className="text-xs font-bold uppercase tracking-wider text-blue-400 flex items-center gap-1.5">
                <Sparkles className="w-3.5 h-3.5" />
                <span>Interactive Score Simulator</span>
              </h3>
              <span className="text-[11px] text-slate-400">Click any action to simulate score impact</span>
            </div>

            {simulationMsg && (
              <div className="p-2 bg-blue-950/70 border border-blue-800/80 rounded-lg text-xs text-blue-200 flex items-center justify-between animate-fade-in">
                <span>Impact: {simulationMsg}</span>
                <span className="font-bold text-emerald-400">Live Updated</span>
              </div>
            )}

            <div className="grid grid-cols-2 gap-2 text-xs">
              <button
                onClick={() => handleSimulate('pay_on_time')}
                disabled={loading}
                className="p-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-left border border-slate-700 font-semibold transition flex items-center justify-between"
              >
                <span>Pay EMI on time</span>
                <span className="text-emerald-400 font-bold text-xs">+15 pts</span>
              </button>

              <button
                onClick={() => handleSimulate('lower_utilization')}
                disabled={loading}
                className="p-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-left border border-slate-700 font-semibold transition flex items-center justify-between"
              >
                <span>Lower card balance &lt;20%</span>
                <span className="text-emerald-400 font-bold text-xs">+25 pts</span>
              </button>

              <button
                onClick={() => handleSimulate('miss_payment')}
                disabled={loading}
                className="p-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-left border border-slate-700 font-semibold transition flex items-center justify-between"
              >
                <span>Late payment default</span>
                <span className="text-rose-400 font-bold text-xs">-45 pts</span>
              </button>

              <button
                onClick={() => handleSimulate('new_inquiry')}
                disabled={loading}
                className="p-2.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-left border border-slate-700 font-semibold transition flex items-center justify-between"
              >
                <span>Hard lender inquiry</span>
                <span className="text-amber-400 font-bold text-xs">-8 pts</span>
              </button>
            </div>

            <div className="pt-1 flex justify-end">
              <button
                onClick={() => handleSimulate('reset')}
                className="text-[11px] text-slate-400 hover:text-white flex items-center gap-1 font-semibold"
              >
                <RefreshCw className="w-3 h-3" />
                <span>Reset to Default Score (765)</span>
              </button>
            </div>
          </div>

          {/* Bureau Factors Breakdown */}
          <div className="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm space-y-3">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
              Credit Score Key Factors
            </h3>

            <div className="space-y-2 text-xs">
              {scoreData.factors?.map((f, i) => (
                <div key={i} className="flex items-center justify-between p-2.5 bg-slate-50 rounded-xl border border-slate-100">
                  <div>
                    <span className="font-bold text-slate-800">{f.name}</span>
                    <span className="text-[11px] text-slate-500 ml-2">({f.value})</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="text-[10px] bg-slate-200 text-slate-700 px-1.5 py-0.5 rounded font-medium">
                      Impact: {f.impact}
                    </span>
                    <span className="text-emerald-700 font-bold text-xs bg-emerald-50 px-2 py-0.5 rounded border border-emerald-100">
                      {f.rating}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* DISPUTE RESOLUTION MODAL */}
      {disputeModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden text-slate-800">
            <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-amber-400" />
                <div>
                  <h3 className="font-bold text-sm">Experian & CIBIL Bureau Dispute Desk</h3>
                  <p className="text-[11px] text-slate-400">Authorized Dispute Under CICRA Act 2005</p>
                </div>
              </div>
              <button
                onClick={() => setDisputeModalOpen(false)}
                className="p-1 rounded-lg text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleSubmitDispute} className="p-5 space-y-4">
              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Select Dispute Category</label>
                <select
                  value={disputeReason}
                  onChange={(e) => setDisputeReason(e.target.value)}
                  className="w-full p-2.5 text-xs bg-slate-50 border border-slate-200 rounded-xl outline-none font-medium"
                >
                  <option value="Incorrect personal details">Incorrect personal details / PAN mapping</option>
                  <option value="Unknown loan or card inquiry">Unknown lender inquiry flagged</option>
                  <option value="Paid account reported overdue">Paid loan account still showing overdue</option>
                  <option value="Closed card still shown active">Closed credit card shown open</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Additional Clarification / Account No</label>
                <textarea
                  rows="3"
                  defaultValue="I have cleared all dues for the loan account. Kindly update Experian and CIBIL records."
                  className="w-full p-2.5 text-xs bg-slate-50 border border-slate-200 rounded-xl outline-none focus:bg-white focus:border-blue-500"
                ></textarea>
              </div>

              <div className="p-3 bg-blue-50 border border-blue-100 rounded-xl text-[11px] text-blue-800">
                Official Resolution SLA: <strong>48 Business Hours</strong>. A tracking SMS will be delivered to +91 98765 43210.
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setDisputeModalOpen(false)}
                  className="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={disputeSubmitted}
                  className="flex-1 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl transition shadow-md shadow-blue-500/20"
                >
                  {disputeSubmitted ? 'Submitting to Bureau...' : 'Submit Bureau Ticket'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default Day7CreditScore;
