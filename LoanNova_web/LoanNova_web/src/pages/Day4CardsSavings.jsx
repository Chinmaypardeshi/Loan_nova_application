import React, { useState, useEffect } from 'react';
import { 
  CreditCard, 
  Wallet, 
  Plane, 
  Fuel, 
  Gift, 
  ShieldCheck, 
  ArrowRight, 
  CheckCircle, 
  Sparkles, 
  Percent, 
  Building2 
} from 'lucide-react';

export function Day4CardsSavings({ onApplyProduct, searchQuery, setActiveTab }) {
  const [activeSection, setActiveSection] = useState('cards'); // 'cards' | 'savings'
  const [cardFilter, setCardFilter] = useState('all');
  const [products, setProducts] = useState([]);

  useEffect(() => {
    fetchProducts();
  }, [activeSection, cardFilter, searchQuery]);

  const fetchProducts = async () => {
    try {
      const cat = activeSection === 'cards' ? 'cards' : 'savings';
      let url = `/api/products?category=${cat}`;
      if (searchQuery) url += `&search=${encodeURIComponent(searchQuery)}`;
      const res = await fetch(url);
      const data = await res.json();
      setProducts(data.products || []);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-bold mb-1.5">
            <span>CARDS & ACCOUNTS</span>
            <span>•</span>
            <span>Premium Cards & High-Yield FDs</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Compare Premium Credit Cards & Fixed Deposits
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Airport lounges, 5% cashback, lifetime free perks, and up to 8.5% interest on fixed deposits.
          </p>
        </div>

        <button
          onClick={() => setActiveTab('insurance')}
          className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition self-stretch md:self-auto justify-center"
        >
          <span>Insurance & Wealth</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      {/* Category Toggle: Cards vs Savings */}
      <div className="flex gap-2">
        <button
          onClick={() => setActiveSection('cards')}
          className={`flex-1 py-3 px-4 rounded-2xl text-xs font-bold flex items-center justify-center gap-2 transition ${
            activeSection === 'cards'
              ? 'bg-slate-900 text-white shadow-md'
              : 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200'
          }`}
        >
          <CreditCard className="w-4 h-4 text-blue-400" />
          <span>Credit Cards Marketplace (4 Curated Cards)</span>
        </button>

        <button
          onClick={() => setActiveSection('savings')}
          className={`flex-1 py-3 px-4 rounded-2xl text-xs font-bold flex items-center justify-center gap-2 transition ${
            activeSection === 'savings'
              ? 'bg-slate-900 text-white shadow-md'
              : 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200'
          }`}
        >
          <Wallet className="w-4 h-4 text-emerald-400" />
          <span>Savings Accounts & High-Yield FDs</span>
        </button>
      </div>

      {/* Credit Cards View */}
      {activeSection === 'cards' && (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          {products.map((card) => (
            <div
              key={card.id}
              className="bg-white rounded-2xl border border-slate-200 hover:border-blue-300 shadow-sm hover:shadow-md transition p-5 flex flex-col justify-between"
            >
              <div>
                <div className="flex items-start justify-between mb-3">
                  <div>
                    <span className="text-[10px] font-bold text-blue-700 bg-blue-50 px-2 py-0.5 rounded-md">
                      {card.bank}
                    </span>
                    <h3 className="font-bold text-base text-slate-900 mt-1">{card.name}</h3>
                    <p className="text-xs text-slate-500 font-medium">{card.subType}</p>
                  </div>
                  {card.badge && (
                    <span className="text-[10px] font-bold bg-amber-100 text-amber-800 px-2 py-0.5 rounded-full border border-amber-200">
                      ★ {card.badge}
                    </span>
                  )}
                </div>

                {/* Card Visual Graphic Mock */}
                <div className="bg-gradient-to-tr from-slate-900 via-indigo-950 to-slate-800 text-white rounded-xl p-4 mb-4 relative overflow-hidden shadow-inner">
                  <div className="flex justify-between items-center text-xs font-bold text-slate-400 mb-6">
                    <span className="tracking-widest">LOANNOVA EXCLUSIVE</span>
                    <span className="text-amber-400">{card.bank}</span>
                  </div>
                  <div className="text-sm font-bold text-white mb-2">{card.tag}</div>
                  <div className="flex justify-between items-end text-[11px] text-slate-400 font-mono">
                    <span>•••• •••• •••• 8912</span>
                    <span className="text-slate-200 font-sans font-semibold">RuPay / Visa</span>
                  </div>
                </div>

                {/* Key Card Specs */}
                <div className="grid grid-cols-3 gap-2 bg-slate-50 p-3 rounded-xl text-xs mb-4">
                  <div>
                    <span className="text-slate-400 text-[10px] block">Joining Fee</span>
                    <span className="font-bold text-slate-900">
                      {card.joiningFee === 0 ? 'FREE' : `₹${card.joiningFee}`}
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-400 text-[10px] block">Annual Fee</span>
                    <span className="font-bold text-slate-900">
                      {card.annualFee === 0 ? 'FREE' : `₹${card.annualFee}`}
                    </span>
                  </div>
                  <div>
                    <span className="text-slate-400 text-[10px] block">Airport Lounges</span>
                    <span className="font-bold text-emerald-600 truncate block">
                      {card.loungeAccess.split(' ')[0]} {card.loungeAccess.split(' ')[1] || ''}
                    </span>
                  </div>
                </div>

                {/* Perks Checklist */}
                <div className="space-y-1.5 mb-4 text-xs">
                  {card.features?.map((f, i) => (
                    <div key={i} className="flex items-center gap-1.5 text-slate-600">
                      <CheckCircle className="w-3.5 h-3.5 text-emerald-500 shrink-0" />
                      <span>{f}</span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Action Button */}
              <button
                onClick={() => onApplyProduct(card)}
                className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm shadow-blue-500/20"
              >
                <span>Apply for Card</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Savings & FD View */}
      {activeSection === 'savings' && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {products.map((item) => (
            <div
              key={item.id}
              className="bg-white rounded-2xl border border-slate-200 hover:border-blue-300 shadow-sm hover:shadow-md transition p-5 flex flex-col justify-between"
            >
              <div>
                <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md">
                  {item.subType}
                </span>
                <h3 className="font-bold text-base text-slate-900 mt-2">{item.name}</h3>
                <p className="text-xs text-slate-500">{item.bank}</p>

                <div className="bg-emerald-50/70 border border-emerald-100 rounded-xl p-3 my-4 text-center">
                  <span className="text-[11px] text-emerald-800 font-medium block">Interest Rate p.a.</span>
                  <div className="text-2xl font-extrabold text-emerald-700">
                    {item.interestRate}%
                  </div>
                  <span className="text-[10px] text-slate-500">Min Balance: ₹{item.minBalance}</span>
                </div>

                <div className="space-y-1.5 text-xs text-slate-600 mb-4">
                  {item.features?.map((f, idx) => (
                    <div key={idx} className="flex items-center gap-1.5">
                      <CheckCircle className="w-3.5 h-3.5 text-emerald-500 shrink-0" />
                      <span>{f}</span>
                    </div>
                  ))}
                </div>
              </div>

              <button
                onClick={() => onApplyProduct(item)}
                className="w-full py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm shadow-emerald-600/20"
              >
                <span>Open Online in 5 Mins</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
