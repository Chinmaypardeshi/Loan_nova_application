import React, { useState, useEffect } from 'react';
import { 
  Database, 
  Search, 
  Download, 
  Copy, 
  Check, 
  ExternalLink, 
  Layers, 
  Building2, 
  ArrowRight,
  ShieldCheck,
  CreditCard,
  Wallet,
  TrendingUp,
  FileText,
  UserCheck
} from 'lucide-react';

export function DataCatalogView({ onApplyProduct, setActiveTab, searchQuery, applications: propApps }) {
  const [products, setProducts] = useState([]);
  const [applications, setApplications] = useState(propApps || []);
  const [creditScore, setCreditScore] = useState(null);
  const [activeCategory, setActiveCategory] = useState('all');
  const [searchFilter, setSearchFilter] = useState(searchQuery || '');
  const [copied, setCopied] = useState(false);
  const [expandedJsonId, setExpandedJsonId] = useState(null);

  useEffect(() => {
    if (propApps && propApps.length > 0) {
      setApplications(propApps);
    }
  }, [propApps]);

  useEffect(() => {
    if (searchQuery !== undefined) {
      setSearchFilter(searchQuery);
    }
  }, [searchQuery]);

  useEffect(() => {
    fetchAllData();
  }, []);

  const fetchAllData = async () => {
    try {
      const [prodRes, appRes, scoreRes] = await Promise.all([
        fetch('/api/products'),
        fetch('/api/applications'),
        fetch('/api/credit-score'),
      ]);
      const prodData = await prodRes.json();
      const appData = await appRes.json();
      const scoreData = await scoreRes.json();

      setProducts(prodData.products || []);
      setApplications(propApps && propApps.length > 0 ? propApps : (appData.applications || []));
      setCreditScore(scoreData);
    } catch (err) {
      console.error(err);
    }
  };

  const usersList = [
    { id: 'usr-1', name: 'Rahul Sharma', email: 'rahul.sharma@loannova.in', role: 'Customer', roleBadge: 'Borrower', score: 765, status: 'Active (Tier 1 KYC)' },
    { id: 'usr-2', name: 'HDFC Lending Officer', email: 'lending.desk@hdfcbank.com', role: 'Bank Partner', roleBadge: 'Underwriter', score: 'N/A', status: 'Licensed Lender Node' },
    { id: 'usr-3', name: 'Arun Kumar', email: 'arun.agent@loannova.in', role: 'Sales Agent', roleBadge: 'Relationship Mgr', score: 'N/A', status: 'Active Telecaller' },
    { id: 'usr-4', name: 'Super Admin', email: 'admin@loannova.in', role: 'Super Admin', roleBadge: 'Platform Ops', score: 'N/A', status: 'Full Superuser Access' },
  ];

  // Filtered Products
  const filteredProducts = products.filter((p) => {
    const matchesCat = activeCategory === 'all' || p.category === activeCategory;
    const q = searchFilter.toLowerCase();
    const matchesSearch =
      !q ||
      p.name.toLowerCase().includes(q) ||
      p.bank.toLowerCase().includes(q) ||
      p.subType.toLowerCase().includes(q);
    return matchesCat && matchesSearch;
  });

  const handleCopyAllJson = () => {
    const fullDataset = {
      totalProducts: products.length,
      products,
      applications,
      creditScore,
      users: usersList,
    };
    navigator.clipboard?.writeText(JSON.stringify(fullDataset, null, 2));
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownloadJson = () => {
    const fullDataset = {
      totalProducts: products.length,
      products,
      applications,
      creditScore,
      users: usersList,
    };
    const blob = new Blob([JSON.stringify(fullDataset, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `loannova_master_data_${Date.now()}.json`;
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <div className="space-y-6">
      {/* Top Banner */}
      <div className="bg-slate-900 text-white rounded-3xl p-6 sm:p-8 shadow-xl flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
        <div>
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/20 text-blue-300 text-xs font-bold mb-3 border border-blue-400/30">
            <Database className="w-3.5 h-3.5" />
            <span>MASTER DATABASE & DATA DIRECTORY</span>
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold tracking-tight mb-2">
            LoanNova Live Master Data Catalog
          </h1>
          <p className="text-xs sm:text-sm text-slate-300 max-w-2xl leading-relaxed">
            Complete database repository containing all products, bank offerings, interest rates, customer profiles, and live underwriting applications.
          </p>
        </div>

        {/* Export & Copy Action Buttons */}
        <div className="flex flex-wrap gap-2.5">
          <button
            onClick={handleCopyAllJson}
            className="px-4 py-2 bg-slate-800 hover:bg-slate-700 text-slate-200 hover:text-white rounded-xl text-xs font-bold border border-slate-700 flex items-center gap-1.5 transition shadow-sm"
          >
            {copied ? <Check className="w-3.5 h-3.5 text-emerald-400" /> : <Copy className="w-3.5 h-3.5" />}
            <span>{copied ? 'Copied Full JSON' : 'Copy Full Data'}</span>
          </button>
          <button
            onClick={handleDownloadJson}
            className="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition shadow-lg shadow-blue-600/30"
          >
            <Download className="w-3.5 h-3.5" />
            <span>Export JSON File</span>
          </button>
        </div>
      </div>

      {/* Quick Summary Metrics */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Total Products</span>
          <div className="text-2xl font-black text-slate-900 mt-0.5">{products.length} Items</div>
          <span className="text-[10px] text-blue-600 font-semibold">Across 5 Sectors</span>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Loans Catalog</span>
          <div className="text-2xl font-black text-slate-900 mt-0.5">
            {products.filter(p => p.category === 'loans').length} Loans
          </div>
          <span className="text-[10px] text-emerald-600 font-semibold">Starting @ 8.25%</span>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Cards & FDs</span>
          <div className="text-2xl font-black text-slate-900 mt-0.5">
            {products.filter(p => p.category === 'cards' || p.category === 'savings').length} Products
          </div>
          <span className="text-[10px] text-purple-600 font-semibold">Up to 8.5% FD Yield</span>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Invest & Insurance</span>
          <div className="text-2xl font-black text-slate-900 mt-0.5">
            {products.filter(p => p.category === 'insurance' || p.category === 'investments').length} Plans
          </div>
          <span className="text-[10px] text-amber-600 font-semibold">22.8% SIP Returns</span>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block">Live Applications</span>
          <div className="text-2xl font-black text-slate-900 mt-0.5">{applications.length} Active</div>
          <span className="text-[10px] text-emerald-600 font-semibold">Real-time sync</span>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-col md:flex-row items-center justify-between gap-4">
        {/* Category Pills */}
        <div className="flex items-center gap-1.5 overflow-x-auto w-full md:w-auto pb-1 md:pb-0">
          {[
            { id: 'all', label: 'All Products (18)' },
            { id: 'loans', label: 'Loans (7)' },
            { id: 'cards', label: 'Credit Cards (4)' },
            { id: 'savings', label: 'Savings & FDs (3)' },
            { id: 'insurance', label: 'Insurance (3)' },
            { id: 'investments', label: 'Investments (3)' },
            { id: 'applications', label: 'Applications (Live)' },
            { id: 'users', label: 'Users & Roles (4)' },
          ].map((cat) => (
            <button
              key={cat.id}
              onClick={() => setActiveCategory(cat.id)}
              className={`px-3 py-1.5 rounded-xl text-xs font-semibold whitespace-nowrap transition ${
                activeCategory === cat.id
                  ? 'bg-blue-600 text-white shadow-sm font-bold'
                  : 'bg-slate-100 hover:bg-slate-200 text-slate-700'
              }`}
            >
              {cat.label}
            </button>
          ))}
        </div>

        {/* Search input */}
        <div className="relative w-full md:w-72">
          <Search className="w-3.5 h-3.5 absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" />
          <input
            type="text"
            placeholder="Filter data by bank, name, type..."
            value={searchFilter}
            onChange={(e) => setSearchFilter(e.target.value)}
            className="w-full pl-8 pr-3 py-1.5 text-xs bg-slate-50 border border-slate-200 rounded-xl outline-none focus:border-blue-500 font-medium"
          />
        </div>
      </div>

      {/* ========================================================= */}
      {/* 1. PRODUCTS DATA TABLE */}
      {/* ========================================================= */}
      {activeCategory !== 'applications' && activeCategory !== 'users' && (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div className="p-4 border-b border-slate-100 flex items-center justify-between">
            <h3 className="font-bold text-sm text-slate-900">
              Master Products Catalog ({filteredProducts.length} Results)
            </h3>
            <span className="text-[11px] text-slate-400 font-mono">
              GET /api/products
            </span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-50 border-b border-slate-200 text-slate-500 font-semibold uppercase tracking-wider text-[10px]">
                <tr>
                  <th className="p-3.5">ID & Name</th>
                  <th className="p-3.5">Category</th>
                  <th className="p-3.5">Bank / Provider</th>
                  <th className="p-3.5">Key Pricing / Rate</th>
                  <th className="p-3.5">Limits / Coverage</th>
                  <th className="p-3.5">Customer Rating</th>
                  <th className="p-3.5 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filteredProducts.map((p) => {
                  const isExpanded = expandedJsonId === p.id;
                  return (
                    <React.Fragment key={p.id}>
                      <tr className="hover:bg-slate-50/80 transition">
                        <td className="p-3.5">
                          <div className="font-bold text-slate-900">{p.name}</div>
                          <span className="font-mono text-[10px] text-slate-400">{p.id}</span>
                        </td>
                        <td className="p-3.5">
                          <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-blue-50 text-blue-700 border border-blue-100">
                            {p.subType}
                          </span>
                        </td>
                        <td className="p-3.5 font-semibold text-slate-800">
                          {p.bank}
                        </td>
                        <td className="p-3.5">
                          {p.interestRate && (
                            <span className="font-extrabold text-blue-600">{p.interestRate}% p.a.</span>
                          )}
                          {p.annualFee !== undefined && (
                            <span className="font-bold text-slate-900">
                              {p.annualFee === 0 ? 'FREE' : `₹${p.annualFee}/yr`}
                            </span>
                          )}
                          {p.returns3Yr && (
                            <span className="font-extrabold text-emerald-600">{p.returns3Yr}</span>
                          )}
                          {p.startingPremium && (
                            <span className="font-bold text-rose-600">{p.startingPremium}</span>
                          )}
                        </td>
                        <td className="p-3.5 text-slate-600">
                          {p.maxAmount && <span>Up to ₹{(p.maxAmount/100000).toFixed(1)}L ({p.maxTenure}m)</span>}
                          {p.rewardRate && <span className="line-clamp-1">{p.rewardRate}</span>}
                          {p.coverAmount && <span>{p.coverAmount}</span>}
                          {p.minSip && <span>Min SIP ₹{p.minSip}</span>}
                          {p.minBalance !== undefined && <span>Min Bal: ₹{p.minBalance}</span>}
                        </td>
                        <td className="p-3.5">
                          <span className="font-bold text-amber-600">★ {p.rating}</span>
                          <span className="text-[10px] text-slate-400 ml-1">({p.reviewsCount})</span>
                        </td>
                        <td className="p-3.5 text-right space-x-1.5 whitespace-nowrap">
                          <button
                            onClick={() => setExpandedJsonId(isExpanded ? null : p.id)}
                            className="px-2.5 py-1 text-[11px] font-semibold bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg transition"
                          >
                            {isExpanded ? 'Hide JSON' : 'JSON'}
                          </button>
                          <button
                            onClick={() => onApplyProduct(p)}
                            className="px-3 py-1 text-[11px] font-bold bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition shadow-2xs"
                          >
                            Apply
                          </button>
                        </td>
                      </tr>
                      {/* JSON Drawer row */}
                      {isExpanded && (
                        <tr className="bg-slate-900 text-slate-300">
                          <td colSpan="7" className="p-4 font-mono text-[11px] overflow-x-auto">
                            <pre className="max-h-48 overflow-y-auto">
                              {JSON.stringify(p, null, 2)}
                            </pre>
                          </td>
                        </tr>
                      )}
                    </React.Fragment>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 2. APPLICATIONS DATA TABLE */}
      {/* ========================================================= */}
      {activeCategory === 'applications' && (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div className="p-4 border-b border-slate-100 flex items-center justify-between">
            <h3 className="font-bold text-sm text-slate-900">
              Live Application Registry ({applications.length} Applications)
            </h3>
            <span className="text-[11px] text-slate-400 font-mono">
              GET /api/applications
            </span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-50 border-b border-slate-200 text-slate-500 font-semibold uppercase tracking-wider text-[10px]">
                <tr>
                  <th className="p-3.5">App ID</th>
                  <th className="p-3.5">Product Name</th>
                  <th className="p-3.5">Applicant Details</th>
                  <th className="p-3.5">Amount & Tenure</th>
                  <th className="p-3.5">Estimated EMI</th>
                  <th className="p-3.5">Status & Stage</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {applications.map((app) => (
                  <tr key={app.id} className="hover:bg-slate-50/80 transition">
                    <td className="p-3.5 font-mono font-bold text-blue-600">{app.id}</td>
                    <td className="p-3.5 font-bold text-slate-900">{app.productName} ({app.bank})</td>
                    <td className="p-3.5">
                      <div className="font-semibold text-slate-800">{app.applicantName}</div>
                      <span className="text-[10px] text-slate-400 font-mono">PAN: {app.pan} • {app.phone}</span>
                    </td>
                    <td className="p-3.5 font-bold text-slate-900">
                      ₹{Number(app.amount).toLocaleString('en-IN')} ({app.tenure} Mos)
                    </td>
                    <td className="p-3.5 font-extrabold text-emerald-600">
                      {app.emi ? `₹${app.emi.toLocaleString('en-IN')}/mo` : '—'}
                    </td>
                    <td className="p-3.5">
                      <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-bold ${
                        app.status === 'Approved'
                          ? 'bg-emerald-100 text-emerald-800'
                          : app.status === 'Disbursed'
                          ? 'bg-blue-100 text-blue-800'
                          : 'bg-amber-100 text-amber-800'
                      }`}>
                        ● {app.status} (Stage {app.stage}/5)
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* ========================================================= */}
      {/* 3. USERS & ROLES TABLE */}
      {/* ========================================================= */}
      {activeCategory === 'users' && (
        <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
          <div className="p-4 border-b border-slate-100 flex items-center justify-between">
            <h3 className="font-bold text-sm text-slate-900">
              Platform User Personas & RBAC Access Matrix
            </h3>
            <span className="text-[11px] text-slate-400 font-mono">
              RBAC Identity Gateway
            </span>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="bg-slate-50 border-b border-slate-200 text-slate-500 font-semibold uppercase tracking-wider text-[10px]">
                <tr>
                  <th className="p-3.5">User Profile</th>
                  <th className="p-3.5">Email Identifier</th>
                  <th className="p-3.5">Assigned Role</th>
                  <th className="p-3.5">Role Permission Scope</th>
                  <th className="p-3.5">Credit Score / Metric</th>
                  <th className="p-3.5">Account Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {usersList.map((usr) => (
                  <tr key={usr.id} className="hover:bg-slate-50/80 transition">
                    <td className="p-3.5 font-bold text-slate-900 flex items-center gap-2">
                      <div className="w-6 h-6 rounded-full bg-blue-100 text-blue-700 flex items-center justify-center text-[10px] font-bold">
                        {usr.name.split(' ').map(n=>n[0]).join('').slice(0,2)}
                      </div>
                      <span>{usr.name}</span>
                    </td>
                    <td className="p-3.5 font-mono text-slate-600">{usr.email}</td>
                    <td className="p-3.5 font-semibold text-slate-800">{usr.role}</td>
                    <td className="p-3.5">
                      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-slate-100 text-slate-700">
                        {usr.roleBadge}
                      </span>
                    </td>
                    <td className="p-3.5 font-extrabold text-blue-600">{usr.score}</td>
                    <td className="p-3.5">
                      <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-100">
                        ✓ {usr.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </div>
  );
}
