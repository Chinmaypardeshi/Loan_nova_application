import React, { useState, useEffect } from 'react';
import { 
  ShieldPlus, 
  TrendingUp, 
  HeartHandshake, 
  Car, 
  Coins, 
  ArrowRight, 
  CheckCircle, 
  Sparkles, 
  ShieldCheck,
  Building 
} from 'lucide-react';

export function Day5InsuranceInvest({ onApplyProduct, searchQuery, setActiveTab }) {
  const [activeTab, setActiveSubTab] = useState('insurance'); // 'insurance' | 'investments'
  const [products, setProducts] = useState([]);

  useEffect(() => {
    fetchData();
  }, [activeTab, searchQuery]);

  const fetchData = async () => {
    try {
      let url = `/api/products?category=${activeTab}`;
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
            <span>PROTECTION & WEALTH</span>
            <span>•</span>
            <span>Insurance & Investments</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Protect Life & Grow Wealth with AI Precision
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Cashless hospital coverage, 99.5% claim settlement, top SIP mutual funds, and 24K pure digital gold.
          </p>
        </div>

        <button
          onClick={() => setActiveTab('calculators')}
          className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition self-stretch md:self-auto justify-center"
        >
          <span>Financial Calculators</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      {/* Sub-Tabs: Insurance vs Investments */}
      <div className="flex gap-2">
        <button
          onClick={() => setActiveSubTab('insurance')}
          className={`flex-1 py-3 px-4 rounded-2xl text-xs font-bold flex items-center justify-center gap-2 transition ${
            activeTab === 'insurance'
              ? 'bg-slate-900 text-white shadow-md'
              : 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200'
          }`}
        >
          <ShieldPlus className="w-4 h-4 text-rose-400" />
          <span>Insurance Marketplace (Health, Term & Motor)</span>
        </button>

        <button
          onClick={() => setActiveSubTab('investments')}
          className={`flex-1 py-3 px-4 rounded-2xl text-xs font-bold flex items-center justify-center gap-2 transition ${
            activeTab === 'investments'
              ? 'bg-slate-900 text-white shadow-md'
              : 'bg-white hover:bg-slate-50 text-slate-700 border border-slate-200'
          }`}
        >
          <TrendingUp className="w-4 h-4 text-emerald-400" />
          <span>Investments & Mutual Funds (SIP & Gold)</span>
        </button>
      </div>

      {/* Insurance Products Grid */}
      {activeTab === 'insurance' && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          {products.map((item) => (
            <div
              key={item.id}
              className="bg-white rounded-2xl border border-slate-200 hover:border-blue-300 shadow-sm hover:shadow-md transition p-5 flex flex-col justify-between"
            >
              <div>
                <span className="text-[10px] font-bold text-rose-700 bg-rose-50 px-2 py-0.5 rounded-md">
                  {item.subType}
                </span>
                <h3 className="font-bold text-base text-slate-900 mt-2">{item.name}</h3>
                <p className="text-xs text-slate-500 font-medium">{item.bank}</p>

                <div className="bg-rose-50/50 border border-rose-100 rounded-xl p-3 my-4 space-y-1.5 text-xs">
                  <div className="flex justify-between">
                    <span className="text-slate-500">Coverage:</span>
                    <span className="font-bold text-slate-900">{item.coverAmount}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500">Starting Premium:</span>
                    <span className="font-bold text-rose-600">{item.startingPremium}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500">Claim Settlement:</span>
                    <span className="font-bold text-emerald-600">{item.claimRatio}</span>
                  </div>
                  {item.cashlessHospitals && (
                    <div className="flex justify-between">
                      <span className="text-slate-500">Cashless Network:</span>
                      <span className="font-bold text-slate-900">{item.cashlessHospitals}</span>
                    </div>
                  )}
                </div>

                <div className="space-y-1.5 text-xs text-slate-600 mb-4">
                  {item.features?.map((f, i) => (
                    <div key={i} className="flex items-center gap-1.5">
                      <CheckCircle className="w-3.5 h-3.5 text-emerald-500 shrink-0" />
                      <span>{f}</span>
                    </div>
                  ))}
                </div>
              </div>

              <button
                onClick={() => onApplyProduct(item)}
                className="w-full py-2.5 bg-rose-600 hover:bg-rose-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm shadow-rose-600/20"
              >
                <span>Instant Policy Purchase</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          ))}
        </div>
      )}

      {/* Investments Grid */}
      {activeTab === 'investments' && (
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
                <p className="text-xs text-slate-500 font-medium">{item.bank}</p>

                <div className="bg-emerald-50/60 border border-emerald-100 rounded-xl p-3 my-4 space-y-1.5 text-xs">
                  <div className="flex justify-between">
                    <span className="text-slate-500">3-Yr Annualized Return:</span>
                    <span className="font-extrabold text-emerald-600 text-sm">{item.returns3Yr}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500">Min Investment / SIP:</span>
                    <span className="font-bold text-slate-900">₹{item.minSip}/month</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-slate-500">Risk Profile:</span>
                    <span className="font-semibold text-slate-800">{item.riskLevel}</span>
                  </div>
                </div>

                <div className="space-y-1.5 text-xs text-slate-600 mb-4">
                  {item.features?.map((f, i) => (
                    <div key={i} className="flex items-center gap-1.5">
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
                <span>Start SIP in 1-Click</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
