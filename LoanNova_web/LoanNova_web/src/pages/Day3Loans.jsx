import React, { useState, useEffect } from 'react';
import { 
  Building, 
  Percent, 
  CheckCircle, 
  Filter, 
  ArrowUpDown, 
  Sparkles, 
  Clock, 
  CreditCard, 
  ArrowRight,
  ShieldCheck,
  Star
} from 'lucide-react';

export function Day3Loans({ onApplyProduct, searchQuery, setActiveTab }) {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedSubType, setSelectedSubType] = useState('all');
  const [sortOption, setSortOption] = useState('rate-low');
  const [compareList, setCompareList] = useState([]);

  const subTypes = [
    { id: 'all', label: 'All Loans' },
    { id: 'Personal Loan', label: 'Personal Loan' },
    { id: 'Home Loan', label: 'Home Loan' },
    { id: 'Business Loan', label: 'Business Loan' },
    { id: 'Vehicle Loan', label: 'Vehicle Loan' },
    { id: 'Education Loan', label: 'Education Loan' },
    { id: 'Gold Loan', label: 'Gold Loan' },
  ];

  useEffect(() => {
    fetchLoans();
  }, [selectedSubType, sortOption, searchQuery]);

  const fetchLoans = async () => {
    setLoading(true);
    try {
      let url = `/api/products?category=loans&sort=${sortOption}`;
      if (selectedSubType !== 'all') url += `&subType=${encodeURIComponent(selectedSubType)}`;
      if (searchQuery) url += `&search=${encodeURIComponent(searchQuery)}`;
      
      const res = await fetch(url);
      const data = await res.json();
      setProducts(data.products || []);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const toggleCompare = (prod) => {
    if (compareList.find((p) => p.id === prod.id)) {
      setCompareList(compareList.filter((p) => p.id !== prod.id));
    } else {
      if (compareList.length < 3) {
        setCompareList([...compareList, prod]);
      }
    }
  };

  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-bold mb-1.5">
            <span>LOAN MARKETPLACE</span>
            <span>•</span>
            <span>Instant Pre-Approved Loans</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Compare & Apply: Instant Pre-Approved Loans
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Personal, Home, Business, Gold, Vehicle & Education loans with 10-minute digital approval.
          </p>
        </div>

        <div className="flex gap-2">
          <button
            onClick={() => setActiveTab('calculators')}
            className="px-3 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl text-xs font-semibold transition"
          >
            Calculate EMI
          </button>
          <button
            onClick={() => setActiveTab('cards')}
            className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition"
          >
            <span>Explore Credit Cards</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </div>

      {/* Filter & Sort Bar */}
      <div className="bg-white rounded-2xl p-4 border border-slate-200 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-3">
        {/* Subtype Pills */}
        <div className="flex items-center gap-1.5 overflow-x-auto w-full md:w-auto pb-1 md:pb-0">
          {subTypes.map((sub) => (
            <button
              key={sub.id}
              onClick={() => setSelectedSubType(sub.id)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition ${
                selectedSubType === sub.id
                  ? 'bg-blue-600 text-white shadow-sm'
                  : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
              }`}
            >
              {sub.label}
            </button>
          ))}
        </div>

        {/* Sort Selector */}
        <div className="flex items-center gap-2 text-xs self-end md:self-auto">
          <span className="text-slate-500 font-medium flex items-center gap-1">
            <ArrowUpDown className="w-3.5 h-3.5" /> Sort:
          </span>
          <select
            value={sortOption}
            onChange={(e) => setSortOption(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-2.5 py-1.5 font-bold text-slate-800 outline-none cursor-pointer"
          >
            <option value="rate-low">Lowest Interest Rate</option>
            <option value="rating-high">Highest Customer Rating</option>
          </select>
        </div>
      </div>

      {/* Product List Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
        {products.map((prod) => {
          const isComparing = compareList.some((p) => p.id === prod.id);

          return (
            <div
              key={prod.id}
              className="bg-white rounded-2xl border border-slate-200 hover:border-blue-300 shadow-sm hover:shadow-md transition-all flex flex-col justify-between overflow-hidden"
            >
              {/* Card Header */}
              <div className="p-5 border-b border-slate-100">
                <div className="flex items-start justify-between gap-2 mb-2">
                  <span className="text-[11px] font-bold text-blue-600 bg-blue-50 px-2 py-0.5 rounded-md">
                    {prod.subType}
                  </span>
                  {prod.tag && (
                    <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-md border border-emerald-100">
                      {prod.tag}
                    </span>
                  )}
                </div>

                <h3 className="font-bold text-base text-slate-900 line-clamp-1">{prod.name}</h3>
                <p className="text-xs text-slate-500 font-medium flex items-center gap-1 mt-0.5">
                  <Building className="w-3.5 h-3.5 text-slate-400" />
                  <span>{prod.bank}</span>
                </p>
              </div>

              {/* Key Metrics Grid */}
              <div className="p-5 bg-slate-50/60 grid grid-cols-2 gap-3 text-xs border-b border-slate-100">
                <div>
                  <span className="text-slate-400 font-medium text-[11px] block">Interest Rate</span>
                  <span className="text-base font-extrabold text-blue-600">
                    {prod.interestRate}% <span className="text-[10px] font-normal text-slate-500">p.a.</span>
                  </span>
                </div>
                <div>
                  <span className="text-slate-400 font-medium text-[11px] block">Max Loan Amount</span>
                  <span className="text-base font-extrabold text-slate-900">
                    ₹{(prod.maxAmount / 100000).toFixed(1)} Lakh
                  </span>
                </div>
                <div>
                  <span className="text-slate-400 font-medium text-[11px] block">Max Tenure</span>
                  <span className="font-bold text-slate-800">{prod.maxTenure} Months</span>
                </div>
                <div>
                  <span className="text-slate-400 font-medium text-[11px] block">Processing Fee</span>
                  <span className="font-bold text-slate-800 truncate block">{prod.processingFee}</span>
                </div>
              </div>

              {/* Features List */}
              <div className="p-5 space-y-2 flex-1">
                <div className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider">
                  Features & Perks
                </div>
                {prod.features && prod.features.map((feat, idx) => (
                  <div key={idx} className="flex items-center gap-1.5 text-xs text-slate-600">
                    <CheckCircle className="w-3.5 h-3.5 text-emerald-500 shrink-0" />
                    <span className="line-clamp-1">{feat}</span>
                  </div>
                ))}

                <div className="pt-2 text-[11px] text-slate-500 flex items-center justify-between border-t border-slate-100 mt-2">
                  <span className="flex items-center gap-1 text-amber-500 font-bold">
                    <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                    <span>{prod.rating}</span>
                    <span className="text-slate-400 font-normal">({prod.reviewsCount})</span>
                  </span>
                  <span className="text-slate-400 truncate max-w-[140px] text-right">{prod.eligibility}</span>
                </div>
              </div>

              {/* Action Buttons */}
              <div className="p-4 bg-white border-t border-slate-100 flex items-center gap-2">
                <button
                  onClick={() => toggleCompare(prod)}
                  className={`px-3 py-2 rounded-xl text-xs font-semibold border transition ${
                    isComparing
                      ? 'border-blue-600 bg-blue-50 text-blue-700'
                      : 'border-slate-200 text-slate-600 hover:bg-slate-50'
                  }`}
                >
                  {isComparing ? '✓ Comparing' : '+ Compare'}
                </button>

                <button
                  onClick={() => onApplyProduct(prod)}
                  className="flex-1 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-sm shadow-blue-500/20"
                >
                  <span>Apply Now</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* Side-by-Side Comparison Drawer / Sticky Panel */}
      {compareList.length > 0 && (
        <div className="fixed bottom-4 left-4 right-4 z-40 max-w-4xl mx-auto bg-slate-900 text-white rounded-2xl p-4 shadow-2xl border border-slate-700 animate-slide-up flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <span className="bg-blue-600 text-white text-xs font-bold px-2.5 py-1 rounded-lg">
              Comparing {compareList.length}/3
            </span>
            <div className="flex gap-2">
              {compareList.map((p) => (
                <div key={p.id} className="text-xs bg-slate-800 px-2.5 py-1 rounded-lg font-semibold flex items-center gap-1.5">
                  <span className="truncate max-w-[120px]">{p.name}</span>
                  <button
                    onClick={() => toggleCompare(p)}
                    className="text-slate-400 hover:text-white"
                  >
                    ✕
                  </button>
                </div>
              ))}
            </div>
          </div>

          <div className="flex gap-2">
            <button
              onClick={() => setCompareList([])}
              className="text-xs text-slate-400 hover:text-white px-3 py-1.5"
            >
              Clear All
            </button>
            <button
              onClick={() => onApplyProduct(compareList[0])}
              className="px-4 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white rounded-xl text-xs font-bold transition"
            >
              Apply Top Pick ({compareList[0]?.name.split(' ')[0]})
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
