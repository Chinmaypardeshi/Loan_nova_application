import React, { useState, useEffect, useRef } from 'react';
import { 
  ShieldCheck, 
  Search, 
  Bell, 
  User, 
  Sparkles, 
  ChevronDown, 
  CheckCircle, 
  Menu, 
  X, 
  CreditCard, 
  Building2, 
  Sliders, 
  Award, 
  LogOut, 
  UserCheck, 
  ShieldAlert,
  ArrowRight
} from 'lucide-react';

export function Navbar({ 
  activeTab, 
  setActiveTab, 
  currentUser, 
  onOpenLoginModal, 
  onLogout, 
  onOpenChat, 
  onSearchQuery, 
  searchQuery, 
  onApplyProduct,
  unreadCount = 2 
}) {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [showProfileMenu, setShowProfileMenu] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  
  // Live Search States
  const [liveResults, setLiveResults] = useState([]);
  const [showDropdown, setShowDropdown] = useState(false);
  const searchContainerRef = useRef(null);

  const notifications = [
    { id: 1, title: 'Loan Approved!', text: 'HDFC Instant Loan pre-approved for ₹3,00,000.', time: '10m ago' },
    { id: 2, title: 'Credit Score Alert', text: 'Experian score updated to 765 (+15 pts).', time: '1h ago' },
    { id: 3, title: 'Cashback Credited', text: '₹500 referral bonus added to Nova Wallet.', time: 'Yesterday' }
  ];

  // Fetch live search results when user types
  useEffect(() => {
    const q = (searchQuery || '').trim();
    if (!q) {
      setLiveResults([]);
      setShowDropdown(false);
      return;
    }

    const timer = setTimeout(async () => {
      try {
        const res = await fetch(`/api/products?search=${encodeURIComponent(q)}`);
        const data = await res.json();
        setLiveResults(data.products || []);
        setShowDropdown(true);
      } catch (err) {
        console.error('Search fetch error:', err);
      }
    }, 200);

    return () => clearTimeout(timer);
  }, [searchQuery]);

  // Click outside listener to dismiss search dropdown
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (searchContainerRef.current && !searchContainerRef.current.contains(e.target)) {
        setShowDropdown(false);
      }
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Handle Search Submission (clicking Search button or pressing Enter)
  const handleSearchSubmit = (e) => {
    if (e) e.preventDefault();
    if (!searchQuery.trim()) return;
    setShowDropdown(false);
    // Switch to loans or data-catalog to display matching results
    setActiveTab('loans');
  };

  const handleMobileSearchSubmit = (e) => {
    if (e) e.preventDefault();
    if (!searchQuery.trim()) return;
    setMobileMenuOpen(false);
    setActiveTab('loans');
  };

  return (
    <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200">
      {/* Top Utility Bar */}
      <div className="bg-slate-900 text-slate-300 text-xs py-1.5 px-4 sm:px-6">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <span className="flex items-center gap-1.5 text-emerald-400 font-medium">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
              99.99% Uptime
            </span>
            <span className="hidden md:inline text-slate-500">|</span>
            <span className="hidden md:inline text-slate-400">
              RBI Compliant • 256-Bit SSL Encryption • PCI DSS Certified
            </span>
          </div>

          <div className="flex items-center gap-4">
            {/* Active User / Role Badge */}
            <div className="flex items-center gap-2">
              <span className="text-slate-400 hidden sm:inline">Role:</span>
              <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${
                currentUser?.role === 'admin'
                  ? 'bg-purple-900/60 text-purple-300 border border-purple-500/40'
                  : currentUser?.role === 'partner'
                  ? 'bg-blue-900/60 text-blue-300 border border-blue-500/40'
                  : currentUser?.role === 'agent'
                  ? 'bg-emerald-900/60 text-emerald-300 border border-emerald-500/40'
                  : 'bg-slate-800 text-slate-200'
              }`}>
                {currentUser?.roleLabel || 'Borrower'}
              </span>
            </div>

            <button 
              onClick={onOpenChat}
              className="flex items-center gap-1 text-emerald-400 hover:text-emerald-300 font-medium"
            >
              <Sparkles className="w-3.5 h-3.5" />
              <span>Nova AI Assistant</span>
            </button>
          </div>
        </div>
      </div>

      {/* Main Navbar */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6">
        <div className="flex items-center justify-between h-16 gap-4">
          {/* Logo */}
          <div className="flex items-center gap-3">
            <button 
              onClick={() => setActiveTab('overview')} 
              className="flex items-center gap-2 group text-left"
            >
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-600 via-indigo-600 to-sky-500 flex items-center justify-center text-white shadow-md shadow-blue-500/20 group-hover:scale-105 transition">
                <ShieldCheck className="w-6 h-6" />
              </div>
              <div>
                <div className="flex items-center gap-1.5">
                  <span className="text-xl font-extrabold tracking-tight text-slate-900 group-hover:text-blue-600 transition">
                    Loan<span className="text-blue-600">Nova</span>
                  </span>
                  <span className="bg-blue-100 text-blue-700 text-[10px] font-bold px-1.5 py-0.5 rounded tracking-wide uppercase">
                    AI Platform
                  </span>
                </div>
                <p className="text-[10px] text-slate-500 -mt-0.5 font-medium hidden sm:block">
                  Smart Financial Marketplace
                </p>
              </div>
            </button>
          </div>

          {/* Quick Search Form with Dedicated 'Search' Action Button */}
          <div ref={searchContainerRef} className="flex-1 max-w-md hidden md:block relative">
            <form onSubmit={handleSearchSubmit} className="relative">
              <div className="flex items-center bg-slate-100 hover:bg-slate-50 focus-within:bg-white focus-within:ring-2 focus-within:ring-blue-500/20 border border-slate-200/80 focus-within:border-blue-400 rounded-full p-1 pl-3 transition shadow-xs">
                <Search className="w-4 h-4 text-slate-400 shrink-0 mr-2" />
                <input
                  type="text"
                  placeholder="Search loans, cards, funds, insurance..."
                  value={searchQuery}
                  onChange={(e) => onSearchQuery(e.target.value)}
                  onFocus={() => { if (liveResults.length > 0) setShowDropdown(true); }}
                  className="w-full text-xs bg-transparent outline-none text-slate-900 font-medium placeholder:text-slate-400"
                />

                {searchQuery && (
                  <button 
                    type="button"
                    onClick={() => { 
                      onSearchQuery(''); 
                      setLiveResults([]); 
                      setShowDropdown(false); 
                    }}
                    className="text-slate-400 hover:text-slate-600 px-2 text-xs font-semibold"
                    title="Clear search"
                  >
                    ✕
                  </button>
                )}

                {/* SEARCH ACTION BUTTON */}
                <button
                  type="submit"
                  className="px-3.5 py-1.5 bg-blue-600 hover:bg-blue-700 active:scale-95 text-white rounded-full text-xs font-bold transition flex items-center gap-1 shrink-0 shadow-sm shadow-blue-500/20"
                >
                  <Search className="w-3.5 h-3.5" />
                  <span>Search</span>
                </button>
              </div>
            </form>

            {/* LIVE RESULTS DROPDOWN MODAL */}
            {showDropdown && searchQuery.trim().length > 0 && (
              <div className="absolute top-full mt-2 left-0 right-0 bg-white rounded-2xl shadow-2xl border border-slate-200 overflow-hidden z-50 animate-fade-in">
                <div className="p-3 bg-slate-50 border-b border-slate-100 flex items-center justify-between text-xs font-bold text-slate-700">
                  <span className="flex items-center gap-1.5">
                    <Search className="w-3.5 h-3.5 text-blue-600" />
                    <span>Search Matches ({liveResults.length})</span>
                  </span>
                  <button
                    type="button"
                    onClick={() => setShowDropdown(false)}
                    className="text-slate-400 hover:text-slate-600 text-[11px]"
                  >
                    ✕ Close
                  </button>
                </div>

                {liveResults.length === 0 ? (
                  <div className="p-4 text-center text-xs text-slate-500">
                    No products found matching "{searchQuery}".
                  </div>
                ) : (
                  <div className="max-h-72 overflow-y-auto divide-y divide-slate-100">
                    {liveResults.slice(0, 5).map((prod) => (
                      <div
                        key={prod.id}
                        className="p-3 hover:bg-blue-50/60 transition flex items-center justify-between gap-2"
                      >
                        <div className="flex-1 min-w-0">
                          <div className="font-bold text-xs text-slate-900 truncate">{prod.name}</div>
                          <div className="text-[11px] text-slate-500 flex items-center gap-2">
                            <span>{prod.bank}</span>
                            <span>•</span>
                            <span className="text-blue-600 font-bold">
                              {prod.interestRate 
                                ? `${prod.interestRate}% p.a.` 
                                : prod.annualFee !== undefined 
                                ? (prod.annualFee === 0 ? 'Lifetime Free' : `₹${prod.annualFee}/yr`) 
                                : prod.returns3Yr || prod.startingPremium || ''}
                            </span>
                          </div>
                        </div>

                        <button
                          type="button"
                          onClick={() => {
                            setShowDropdown(false);
                            if (onApplyProduct) onApplyProduct(prod);
                          }}
                          className="px-2.5 py-1 bg-blue-600 hover:bg-blue-700 text-white text-[11px] font-bold rounded-lg transition shrink-0 shadow-2xs"
                        >
                          Apply Now
                        </button>
                      </div>
                    ))}
                  </div>
                )}

                <div className="p-2.5 bg-slate-50 border-t border-slate-100 text-center">
                  <button
                    type="button"
                    onClick={() => {
                      setShowDropdown(false);
                      setActiveTab('loans');
                    }}
                    className="text-xs text-blue-600 font-bold hover:underline inline-flex items-center gap-1"
                  >
                    <span>View all results in Loans Marketplace</span>
                    <ArrowRight className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Desktop Links */}
          <nav className="hidden lg:flex items-center gap-1 text-xs font-semibold text-slate-600">
            <button
              onClick={() => setActiveTab('overview')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'overview' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Dashboard
            </button>
            <button
              onClick={() => setActiveTab('loans')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'loans' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Loans
            </button>
            <button
              onClick={() => setActiveTab('cards')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'cards' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Cards & Accounts
            </button>
            <button
              onClick={() => setActiveTab('insurance')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'insurance' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Insurance & Wealth
            </button>
            <button
              onClick={() => setActiveTab('calculators')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'calculators' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Calculators
            </button>
            <button
              onClick={() => setActiveTab('credit-score')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'credit-score' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Credit Score
            </button>
            <button
              onClick={() => setActiveTab('kyc')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'kyc' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Digital KYC
            </button>
            <button
              onClick={() => setActiveTab('data-catalog')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'data-catalog' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Master Data
            </button>
            <button
              onClick={() => setActiveTab('ai-rewards')}
              className={`px-3 py-2 rounded-lg transition ${activeTab === 'ai-rewards' ? 'bg-blue-50 text-blue-600 font-bold' : 'hover:bg-slate-100'}`}
            >
              Rewards & AI
            </button>
          </nav>

          {/* Action Icons & Profile / Login */}
          <div className="flex items-center gap-2">
            {/* Notification Bell */}
            <div className="relative">
              <button
                onClick={() => setShowNotifications(!showNotifications)}
                className="p-2 text-slate-600 hover:text-blue-600 hover:bg-slate-100 rounded-full transition relative"
                title="Notifications"
              >
                <Bell className="w-5 h-5" />
                {unreadCount > 0 && (
                  <span className="absolute top-1 right-1 w-2.5 h-2.5 bg-rose-500 rounded-full ring-2 ring-white"></span>
                )}
              </button>

              {showNotifications && (
                <div className="absolute right-0 mt-2 w-80 bg-white rounded-xl shadow-xl border border-slate-200 p-3 z-50">
                  <div className="flex items-center justify-between pb-2 mb-2 border-b border-slate-100">
                    <span className="font-bold text-xs text-slate-800">Notifications</span>
                    <span className="text-[11px] text-blue-600 font-semibold cursor-pointer">Mark all read</span>
                  </div>
                  <div className="space-y-2">
                    {notifications.map((n) => (
                      <div key={n.id} className="p-2 bg-slate-50 hover:bg-blue-50/50 rounded-lg text-left transition">
                        <div className="flex items-center justify-between">
                          <span className="font-semibold text-xs text-slate-800">{n.title}</span>
                          <span className="text-[10px] text-slate-400">{n.time}</span>
                        </div>
                        <p className="text-[11px] text-slate-600 mt-0.5">{n.text}</p>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Profile Dropdown & Login Trigger */}
            <div className="relative">
              <button
                onClick={() => setShowProfileMenu(!showProfileMenu)}
                className="flex items-center gap-2 pl-2 pr-3 py-1.5 rounded-full bg-slate-100 hover:bg-slate-200 transition text-xs font-semibold text-slate-800"
              >
                <div className={`w-7 h-7 rounded-full flex items-center justify-center font-bold text-xs text-white ${
                  currentUser?.role === 'admin'
                    ? 'bg-purple-600'
                    : currentUser?.role === 'partner'
                    ? 'bg-blue-600'
                    : currentUser?.role === 'agent'
                    ? 'bg-emerald-600'
                    : 'bg-blue-600'
                }`}>
                  {currentUser?.avatarText || 'RS'}
                </div>
                <span className="hidden sm:inline max-w-[100px] truncate">
                  {currentUser?.name?.split(' ')[0] || 'Rahul'}
                </span>
                <ChevronDown className="w-3 h-3 text-slate-400" />
              </button>

              {showProfileMenu && (
                <div className="absolute right-0 mt-2 w-64 bg-white rounded-2xl shadow-xl border border-slate-200 p-3 z-50">
                  <div className="pb-3 border-b border-slate-100">
                    <div className="font-bold text-xs text-slate-900">{currentUser?.name}</div>
                    <div className="text-[11px] text-slate-500 truncate">{currentUser?.email}</div>
                    <div className="flex items-center gap-1.5 mt-1.5">
                      <span className="text-[10px] bg-blue-100 text-blue-800 font-bold px-2 py-0.5 rounded-full">
                        {currentUser?.roleLabel}
                      </span>
                      {currentUser?.authProvider?.includes('Google') && (
                        <span className="text-[10px] bg-emerald-50 text-emerald-700 font-bold px-1.5 py-0.5 rounded border border-emerald-100">
                          Google Linked
                        </span>
                      )}
                    </div>
                  </div>

                  <div className="py-2 space-y-1 text-xs font-medium text-slate-700">
                    <button
                      onClick={() => {
                        setShowProfileMenu(false);
                        onOpenLoginModal();
                      }}
                      className="w-full text-left px-2.5 py-1.5 rounded-lg hover:bg-slate-100 flex items-center justify-between"
                    >
                      <span>Switch Account / Persona</span>
                      <UserCheck className="w-3.5 h-3.5 text-slate-400" />
                    </button>
                    <button
                      onClick={() => {
                        setShowProfileMenu(false);
                        setActiveTab('overview');
                      }}
                      className="w-full text-left px-2.5 py-1.5 rounded-lg hover:bg-slate-100 flex items-center justify-between"
                    >
                      <span>Active Workspace</span>
                      <Building2 className="w-3.5 h-3.5 text-slate-400" />
                    </button>
                  </div>

                  <div className="pt-2 border-t border-slate-100">
                    <button
                      onClick={() => {
                        setShowProfileMenu(false);
                        onLogout();
                      }}
                      className="w-full text-left px-2.5 py-1.5 rounded-lg hover:bg-rose-50 text-rose-600 font-semibold text-xs flex items-center justify-between"
                    >
                      <span>Sign Out</span>
                      <LogOut className="w-3.5 h-3.5" />
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* Mobile menu toggle */}
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="lg:hidden p-2 text-slate-600 hover:text-slate-900 rounded-lg"
            >
              {mobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Drawer */}
      {mobileMenuOpen && (
        <div className="lg:hidden border-t border-slate-200 bg-white px-4 py-4 space-y-3">
          {/* Mobile Search Form with Button */}
          <form onSubmit={handleMobileSearchSubmit} className="flex gap-2">
            <div className="flex-1 relative flex items-center bg-slate-100 rounded-xl px-3 py-2 border border-slate-200">
              <Search className="w-4 h-4 text-slate-400 mr-2 shrink-0" />
              <input
                type="text"
                placeholder="Search loans, cards, funds..."
                value={searchQuery}
                onChange={(e) => onSearchQuery(e.target.value)}
                className="w-full text-xs bg-transparent outline-none font-medium text-slate-900"
              />
            </div>
            <button
              type="submit"
              className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded-xl transition shadow-sm shrink-0"
            >
              Search
            </button>
          </form>

          <div className="grid grid-cols-2 gap-2 text-xs font-semibold">
            <button
              onClick={() => { setActiveTab('overview'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-blue-600 text-white rounded-lg font-bold"
            >
              Dashboard
            </button>
            <button
              onClick={() => { setActiveTab('loans'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800"
            >
              Loans Marketplace
            </button>
            <button
              onClick={() => { setActiveTab('cards'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800"
            >
              Cards & Accounts
            </button>
            <button
              onClick={() => { setActiveTab('insurance'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800"
            >
              Insurance & Wealth
            </button>
            <button
              onClick={() => { setActiveTab('calculators'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800"
            >
              Calculators
            </button>
            <button
              onClick={() => { setActiveTab('credit-score'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800"
            >
              Credit Score
            </button>
            <button
              onClick={() => { setActiveTab('kyc'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800"
            >
              Digital KYC
            </button>
            <button
              onClick={() => { setActiveTab('data-catalog'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-blue-50 text-blue-700 rounded-lg font-bold"
            >
              Master Data Catalog
            </button>
            <button
              onClick={() => { setActiveTab('ai-rewards'); setMobileMenuOpen(false); }}
              className="p-2.5 text-left bg-slate-50 rounded-lg text-slate-800 font-bold"
            >
              Rewards & AI Copilot
            </button>
            <button
              onClick={() => { onOpenLoginModal(); setMobileMenuOpen(false); }}
              className="col-span-2 p-2.5 text-center bg-slate-100 hover:bg-slate-200 rounded-lg text-slate-800 font-bold"
            >
              Login / Switch Persona Role
            </button>
          </div>
        </div>
      )}
    </header>
  );
}
