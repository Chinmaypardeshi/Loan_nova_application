import React, { useState, useEffect } from 'react';
import { 
  Sparkles, 
  Gift, 
  Share2, 
  Coins, 
  Copy, 
  Check, 
  Send, 
  ArrowRight, 
  Bot, 
  UserCheck, 
  Award,
  Wallet,
  X,
  CheckCircle2,
  Trophy,
  MessageSquare
} from 'lucide-react';
import confetti from 'canvas-confetti';

export function Day9AiAndRewards({ onOpenChat, setActiveTab }) {
  const [copied, setCopied] = useState(false);
  const [referralsData, setReferralsData] = useState(null);
  const [chatInput, setChatInput] = useState('');
  const [chatReplies, setChatReplies] = useState([
    {
      sender: 'ai',
      text: 'Hi Rahul! Based on your 765 credit score and ₹65,000 monthly income, you are eligible for pre-approved loans up to ₹12.5 Lakhs at just 9.85% p.a.',
    },
  ]);
  const [withdrawModalOpen, setWithdrawModalOpen] = useState(false);
  const [upiId, setUpiId] = useState('rahul.sharma@okhdfcbank');
  const [withdrawing, setWithdrawing] = useState(false);
  const [withdrawn, setWithdrawn] = useState(false);
  const [toastMsg, setToastMsg] = useState(null);

  useEffect(() => {
    fetchReferrals();
  }, []);

  const fetchReferrals = async () => {
    try {
      const res = await fetch('/api/referrals');
      const data = await res.json();
      setReferralsData(data);
    } catch (err) {
      console.error(err);
      setReferralsData({
        referralCode: 'NOVA-RAHUL99',
        totalEarned: 4200,
        pendingPayout: 1000,
        successfulReferrals: 8,
        history: [
          { name: 'Amit Verma', date: '10 Oct 2026', reward: '₹500', status: 'Disbursed' },
          { name: 'Sneha Patel', date: '08 Oct 2026', reward: '₹500', status: 'Disbursed' },
          { name: 'Rajesh Kumar', date: '05 Oct 2026', reward: '₹500', status: 'Disbursed' },
        ]
      });
    }
  };

  const showToast = (msg) => {
    setToastMsg(msg);
    setTimeout(() => setToastMsg(null), 3500);
  };

  const handleCopyCode = () => {
    navigator.clipboard?.writeText(referralsData?.referralCode || 'NOVA-RAHUL99');
    setCopied(true);
    showToast('✓ Referral code NOVA-RAHUL99 copied to clipboard!');
    setTimeout(() => setCopied(false), 2000);
  };

  const handleShareWhatsApp = () => {
    const text = `Join LoanNova with my code ${referralsData?.referralCode || 'NOVA-RAHUL99'} and get ₹500 cashback on pre-approved loans at 9.85%! https://loannova.in`;
    navigator.clipboard?.writeText(text);
    showToast('✓ WhatsApp invite message copied to clipboard!');
  };

  const handleSendQuery = async (queryText) => {
    const text = queryText || chatInput;
    if (!text.trim()) return;

    setChatReplies((prev) => [...prev, { sender: 'user', text }]);
    setChatInput('');

    try {
      const res = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text }),
      });
      const data = await res.json();
      setChatReplies((prev) => [...prev, { sender: 'ai', text: data.reply }]);
    } catch (err) {
      setChatReplies((prev) => [
        ...prev,
        { sender: 'ai', text: 'You can save up to ₹46,800 under Section 80C with Mirae Asset ELSS fund.' },
      ]);
    }
  };

  const handleExecuteWithdrawal = (e) => {
    e.preventDefault();
    setWithdrawing(true);
    setTimeout(() => {
      setWithdrawing(false);
      setWithdrawn(true);
      setWithdrawModalOpen(false);
      confetti({ particleCount: 80, spread: 70 });
      showToast(`✓ ₹${referralsData?.totalEarned || 4200} transferred instantly to ${upiId} (IMPS Ref: TXN-UPI-98214)`);
    }, 1200);
  };

  const leaderboard = [
    { rank: 1, name: 'Arun Kumar', referrals: '32 Loans', earnings: '₹16,000', badge: 'Diamond Ambassador' },
    { rank: 2, name: 'Priya Mukherjee', referrals: '24 Loans', earnings: '₹12,000', badge: 'Gold Advisor' },
    { rank: 3, name: 'Rahul Sharma (You)', referrals: '8 Loans', earnings: '₹4,200', badge: 'Silver Partner' },
    { rank: 4, name: 'Vikram Singh', referrals: '6 Loans', earnings: '₹3,000', badge: 'Bronze' },
  ];

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
            <span>SMART COPILOT & REWARDS</span>
            <span>•</span>
            <span>Nova AI Financial Assistant & Referral Engine</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Intelligent AI Advisory & Viral Referral Engine
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Personalized algorithmic suggestions, cash rewards, instant UPI payouts, and community leaderboard.
          </p>
        </div>

        <button
          onClick={() => setActiveTab('overview')}
          className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition self-stretch md:self-auto justify-center"
        >
          <span>Back to Dashboard</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: AI Advisor Terminal */}
        <div className="lg:col-span-7 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4 flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between border-b border-slate-100 pb-3 mb-4">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-blue-600 to-indigo-600 text-white flex items-center justify-center">
                  <Bot className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-sm font-bold text-slate-900">Nova AI Financial Copilot</h3>
                  <span className="text-[10px] text-emerald-600 font-semibold flex items-center gap-1">
                    <span className="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Online & Analyzing Profile
                  </span>
                </div>
              </div>

              <div className="flex gap-1.5">
                {['Lowest EMI', 'Tax Saving 80C', 'Best Credit Card'].map((chip, idx) => (
                  <button
                    key={idx}
                    onClick={() => handleSendQuery(chip)}
                    className="hidden sm:inline-block px-2 py-1 bg-slate-100 hover:bg-blue-50 text-slate-700 hover:text-blue-600 rounded-lg text-[10px] font-semibold transition"
                  >
                    {chip}
                  </button>
                ))}
              </div>
            </div>

            {/* Chat Box */}
            <div className="space-y-3 max-h-72 overflow-y-auto pr-1">
              {chatReplies.map((c, i) => (
                <div
                  key={i}
                  className={`flex flex-col ${c.sender === 'user' ? 'items-end' : 'items-start'}`}
                >
                  <div
                    className={`max-w-[90%] p-3 rounded-2xl text-xs leading-relaxed ${
                      c.sender === 'user'
                        ? 'bg-blue-600 text-white'
                        : 'bg-slate-50 text-slate-800 border border-slate-200'
                    }`}
                  >
                    {c.text}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Chat Input */}
          <div className="pt-3 border-t border-slate-100">
            <form
              onSubmit={(e) => {
                e.preventDefault();
                handleSendQuery();
              }}
              className="flex gap-2"
            >
              <input
                type="text"
                placeholder="Ask Nova anything (e.g. 'How to lower my EMI by ₹2000?')..."
                value={chatInput}
                onChange={(e) => setChatInput(e.target.value)}
                className="flex-1 px-3.5 py-2 text-xs border border-slate-200 rounded-xl outline-none focus:border-blue-500 bg-slate-50 focus:bg-white"
              />
              <button
                type="submit"
                className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition flex items-center gap-1"
              >
                <Send className="w-3.5 h-3.5" />
                <span className="hidden sm:inline">Ask AI</span>
              </button>
            </form>
          </div>
        </div>

        {/* Right Column: Referral & Rewards Wallet */}
        <div className="lg:col-span-5 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-5">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
              Referral Program & Rewards Wallet
            </h3>
            <span className="text-[10px] font-bold bg-amber-100 text-amber-800 px-2 py-0.5 rounded-full">
              Level 2 Ambassador
            </span>
          </div>

          {/* Wallet Balance Card */}
          <div className="bg-gradient-to-tr from-slate-900 via-indigo-950 to-slate-800 rounded-2xl p-5 text-white space-y-3">
            <div className="flex justify-between items-center text-xs text-slate-300">
              <span className="flex items-center gap-1">
                <Wallet className="w-4 h-4 text-emerald-400" /> Nova Cash Wallet
              </span>
              <span className="text-amber-400 font-bold">1,250 Nova Coins</span>
            </div>

            <div className="text-3xl font-black text-white">
              {withdrawn ? '₹0' : `₹${referralsData?.totalEarned || 4200}`}
            </div>

            <div className="flex gap-2 pt-1">
              <button
                onClick={() => setWithdrawModalOpen(true)}
                disabled={withdrawn}
                className="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-500 disabled:bg-slate-700 text-white text-xs font-bold rounded-xl transition flex items-center justify-center gap-1.5 shadow-md shadow-emerald-600/20"
              >
                <Check className="w-3.5 h-3.5" />
                <span>{withdrawn ? '✓ Transferred via UPI' : 'Instant Withdraw to UPI'}</span>
              </button>
            </div>
          </div>

          {/* Referral Code Box */}
          <div className="bg-slate-50 border border-slate-200 rounded-xl p-3.5 space-y-2">
            <span className="text-[11px] font-semibold text-slate-600 block">
              Share invite code — Earn ₹500 per friend loan disbursal
            </span>
            <div className="flex items-center gap-2">
              <div className="flex-1 px-3 py-1.5 bg-white border border-slate-200 rounded-lg font-mono font-bold text-xs text-slate-900">
                {referralsData?.referralCode || 'NOVA-RAHUL99'}
              </div>
              <button
                onClick={handleCopyCode}
                className="px-3 py-1.5 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-xs font-bold transition flex items-center gap-1"
              >
                {copied ? <Check className="w-3.5 h-3.5" /> : <Copy className="w-3.5 h-3.5" />}
                <span>{copied ? 'Copied' : 'Copy'}</span>
              </button>
              <button
                onClick={handleShareWhatsApp}
                className="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-bold transition flex items-center gap-1"
                title="Share to WhatsApp"
              >
                <MessageSquare className="w-3.5 h-3.5" />
                <span>Share</span>
              </button>
            </div>
          </div>

          {/* Community Leaderboard */}
          <div className="space-y-2">
            <div className="flex items-center justify-between">
              <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider flex items-center gap-1">
                <Trophy className="w-3.5 h-3.5 text-amber-500" />
                <span>Top Ambassadors of October</span>
              </span>
              <span className="text-[10px] text-blue-600 font-bold">Monthly Pool ₹50k</span>
            </div>

            <div className="space-y-1.5">
              {leaderboard.map((lead) => (
                <div key={lead.rank} className="flex items-center justify-between text-xs p-2 bg-slate-50 rounded-xl border border-slate-100">
                  <div className="flex items-center gap-2">
                    <span className={`w-5 h-5 rounded-full flex items-center justify-center font-black text-[10px] ${
                      lead.rank === 1 ? 'bg-amber-400 text-amber-950 font-black' : lead.rank === 2 ? 'bg-slate-300 text-slate-900' : 'bg-slate-200 text-slate-700'
                    }`}>
                      {lead.rank}
                    </span>
                    <div>
                      <span className="font-bold text-slate-800">{lead.name}</span>
                      <span className="text-[10px] text-slate-400 block">{lead.referrals}</span>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className="font-extrabold text-emerald-600">{lead.earnings}</span>
                    <span className="text-[9px] text-slate-400 block">{lead.badge}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* UPI WITHDRAWAL MODAL */}
      {withdrawModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden text-slate-800">
            <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Wallet className="w-5 h-5 text-emerald-400" />
                <h3 className="font-bold text-sm">Instant UPI Cash Payout</h3>
              </div>
              <button
                onClick={() => setWithdrawModalOpen(false)}
                className="p-1 rounded-lg text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleExecuteWithdrawal} className="p-5 space-y-4">
              <div className="bg-emerald-50 border border-emerald-200 rounded-xl p-3 text-center">
                <span className="text-[11px] font-bold text-emerald-700 block">Available Withdrawable Balance</span>
                <div className="text-2xl font-black text-emerald-900 my-1">
                  ₹{referralsData?.totalEarned || 4200}
                </div>
                <span className="text-[10px] text-slate-500">Zero Processing Fee • Direct NPCI IMPS Transfer</span>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">Enter Receiving UPI ID</label>
                <input
                  type="text"
                  value={upiId}
                  onChange={(e) => setUpiId(e.target.value)}
                  placeholder="e.g. mobile@upi or username@okhdfcbank"
                  className="w-full p-2.5 text-xs bg-slate-50 border border-slate-200 rounded-xl font-mono font-bold outline-none focus:border-blue-500"
                  required
                />
              </div>

              <div className="flex gap-2 pt-2">
                <button
                  type="button"
                  onClick={() => setWithdrawModalOpen(false)}
                  className="flex-1 py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-xl transition"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={withdrawing}
                  className="flex-1 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl transition shadow-md shadow-emerald-600/20"
                >
                  {withdrawing ? 'Transferring via IMPS...' : `Transfer ₹${referralsData?.totalEarned || 4200}`}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}

export default Day9AiAndRewards;
