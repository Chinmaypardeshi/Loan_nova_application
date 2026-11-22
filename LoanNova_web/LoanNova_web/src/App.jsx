import React, { useState, useEffect } from 'react';
import { Navbar } from './components/Navbar';
import { Footer } from './components/Footer';
import { ApplicationModal } from './components/ApplicationModal';
import { LoginModal } from './components/LoginModal';
import { AiChatDrawer } from './components/AiChatDrawer';
import { isLoggedIn, getSavedName, getSavedEmail, getUserId, logout as authLogout } from './utils/authService';

// Feature Views
import { Day1Overview as ArchitectureView } from './pages/Day1Overview';
import { Day2Auth as AuthSettingsView } from './pages/Day2Auth';
import { Day3Loans as LoansView } from './pages/Day3Loans';
import { Day4CardsSavings as CardsSavingsView } from './pages/Day4CardsSavings';
import { Day5InsuranceInvest as InsuranceInvestView } from './pages/Day5InsuranceInvest';
import { Day6Calculators as CalculatorsView } from './pages/Day6Calculators';
import { Day7CreditScore as CreditScoreView } from './pages/Day7CreditScore';
import { Day8DigitalKYC as DigitalKycView } from './pages/Day8DigitalKYC';
import { Day9AiAndRewards as AiRewardsView } from './pages/Day9AiAndRewards';
import { Day10UnifiedApp as OperationsDashboardView } from './pages/Day10UnifiedApp';
import { DataCatalogView } from './pages/DataCatalogView';

import { Sparkles, CheckCircle2 } from 'lucide-react';

const initialApplicationsList = [
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

export function App() {
  const [activeTab, setActiveTab] = useState('overview'); // Default: Dashboard & Marketplace

  // ── Restore session from localStorage on mount ──────────────
  const [currentUser, setCurrentUser] = useState(() => {
    if (isLoggedIn()) {
      const name = getSavedName() || 'User';
      const email = getSavedEmail() || '';
      return {
        name,
        email,
        role: 'customer',
        roleLabel: 'Borrower',
        avatarText: name.slice(0, 2).toUpperCase(),
        authProvider: 'LoanNova Auth',
        isLoggedIn: true,
        userId: getUserId(),
      };
    }
    return {
      name: 'Guest User',
      email: 'guest@loannova.in',
      role: 'customer',
      roleLabel: 'Guest',
      avatarText: 'GU',
      isLoggedIn: false,
    };
  });

  const [applications, setApplications] = useState(() => {
    try {
      const saved = localStorage.getItem('loannova_applications');
      if (saved) {
        const parsed = JSON.parse(saved);
        if (Array.isArray(parsed) && parsed.length > 0) return parsed;
      }
    } catch (e) {
      console.error(e);
    }
    return initialApplicationsList;
  });

  const [searchQuery, setSearchQuery] = useState('');
  const [chatOpen, setChatOpen] = useState(false);
  const [loginModalOpen, setLoginModalOpen] = useState(false);
  const [selectedProductToApply, setSelectedProductToApply] = useState(null);
  const [toastMessage, setToastMessage] = useState(null);

  // Sync with backend API
  useEffect(() => {
    fetch('/api/applications')
      .then((res) => res.json())
      .then((data) => {
        if (data.applications && Array.isArray(data.applications) && data.applications.length > 0) {
          setApplications((prev) => {
            const currentIds = new Set(prev.map((a) => a.id));
            const newFromServer = data.applications.filter((a) => !currentIds.has(a.id));
            if (newFromServer.length === 0) return prev;
            const merged = [...newFromServer, ...prev];
            try {
              localStorage.setItem('loannova_applications', JSON.stringify(merged));
            } catch (e) {
              console.error(e);
            }
            return merged;
          });
        }
      })
      .catch((err) => console.log('API sync running in client-mode:', err));
  }, []);

  const handleApplyProduct = (product) => {
    setSelectedProductToApply(product);
  };

  const handleCloseModal = () => {
    setSelectedProductToApply(null);
  };

  const handleApplicationSuccess = (newApp) => {
    if (!newApp) return;
    setApplications((prev) => {
      const filtered = prev.filter((a) => a.id !== newApp.id);
      const updated = [newApp, ...filtered];
      try {
        localStorage.setItem('loannova_applications', JSON.stringify(updated));
      } catch (e) {
        console.error(e);
      }
      return updated;
    });

    setToastMessage(`✓ Application ${newApp.id} for ${newApp.productName} Sanctioned!`);
    setActiveTab('overview'); // Direct navigation so user immediately sees their card!
    setTimeout(() => setToastMessage(null), 4000);
  };

  const handleUpdateAppStatus = (appId, newStatus, stage) => {
    setApplications((prev) => {
      const updated = prev.map((a) =>
        a.id === appId ? { ...a, status: newStatus, stage: stage || a.stage } : a
      );
      try {
        localStorage.setItem('loannova_applications', JSON.stringify(updated));
      } catch (e) {
        console.error(e);
      }
      return updated;
    });

    fetch(`/api/applications/${appId}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ status: newStatus, stage }),
    }).catch(console.error);

    setToastMessage(`Application ${appId} marked as ${newStatus}`);
    setTimeout(() => setToastMessage(null), 3000);
  };

  const handleLoginSuccess = (user) => {
    setCurrentUser(user);
    setToastMessage(`Signed in as ${user.name} (${user.roleLabel})`);
    setTimeout(() => setToastMessage(null), 3500);
  };

  const handleLogout = () => {
    authLogout(); // Clear token + userId from localStorage
    setCurrentUser({
      name: 'Guest User',
      email: 'guest@loannova.in',
      role: 'customer',
      roleLabel: 'Guest',
      avatarText: 'GU',
      isLoggedIn: false,
    });
    setToastMessage('Signed out successfully.');
    setTimeout(() => setToastMessage(null), 2500);
  };

  return (
    <div className="min-h-screen flex flex-col bg-slate-50 text-slate-800 font-sans antialiased">
      {/* Global Navbar */}
      <Navbar
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        currentUser={currentUser}
        onOpenLoginModal={() => setLoginModalOpen(true)}
        onLogout={handleLogout}
        onOpenChat={() => setChatOpen(true)}
        searchQuery={searchQuery}
        onSearchQuery={setSearchQuery}
        onApplyProduct={handleApplyProduct}
      />

      {/* Floating Success Toast */}
      {toastMessage && (
        <div className="fixed top-20 right-6 z-50 bg-emerald-600 text-white text-xs font-bold py-2.5 px-4 rounded-xl shadow-xl flex items-center gap-2 animate-fade-in">
          <CheckCircle2 className="w-4 h-4" />
          <span>{toastMessage}</span>
        </div>
      )}

      {/* Main Content Area */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 py-6 sm:py-8">
        {activeTab === 'overview' && (
          <OperationsDashboardView
            selectedRole={currentUser.role}
            setSelectedRole={(newRole) => {
              setCurrentUser((prev) => ({
                ...prev,
                role: newRole,
                roleLabel:
                  newRole === 'admin'
                    ? 'Super Administrator'
                    : newRole === 'partner'
                    ? 'Bank Underwriter'
                    : newRole === 'agent'
                    ? 'Sales Advisor'
                    : 'Borrower',
              }));
            }}
            applications={applications}
            onUpdateStatus={handleUpdateAppStatus}
            onApplyProduct={handleApplyProduct}
            onOpenChat={() => setChatOpen(true)}
            setActiveTab={setActiveTab}
          />
        )}

        {activeTab === 'loans' && (
          <LoansView
            onApplyProduct={handleApplyProduct}
            searchQuery={searchQuery}
            setActiveTab={setActiveTab}
          />
        )}

        {activeTab === 'cards' && (
          <CardsSavingsView
            onApplyProduct={handleApplyProduct}
            searchQuery={searchQuery}
            setActiveTab={setActiveTab}
          />
        )}

        {activeTab === 'insurance' && (
          <InsuranceInvestView
            onApplyProduct={handleApplyProduct}
            searchQuery={searchQuery}
            setActiveTab={setActiveTab}
          />
        )}

        {activeTab === 'calculators' && (
          <CalculatorsView
            onApplyCustomLoan={handleApplyProduct}
            setActiveTab={setActiveTab}
          />
        )}

        {activeTab === 'credit-score' && (
          <CreditScoreView setActiveTab={setActiveTab} />
        )}

        {activeTab === 'kyc' && (
          <DigitalKycView setActiveTab={setActiveTab} />
        )}

        {activeTab === 'ai-rewards' && (
          <AiRewardsView
            onOpenChat={() => setChatOpen(true)}
            setActiveTab={setActiveTab}
          />
        )}

        {activeTab === 'data-catalog' && (
          <DataCatalogView
            onApplyProduct={handleApplyProduct}
            searchQuery={searchQuery}
            setActiveTab={setActiveTab}
            applications={applications}
          />
        )}

        {activeTab === 'architecture' && (
          <ArchitectureView setActiveTab={setActiveTab} />
        )}

        {activeTab === 'auth-settings' && (
          <AuthSettingsView
            selectedRole={currentUser.role}
            setSelectedRole={(r) => {
              setCurrentUser((prev) => ({ ...prev, role: r }));
            }}
            setActiveTab={setActiveTab}
          />
        )}
      </main>

      {/* Floating Nova AI Assistant Button */}
      <div className="fixed bottom-6 right-6 z-40">
        <button
          onClick={() => setChatOpen(true)}
          className="group flex items-center gap-2 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white px-4 py-3 rounded-full shadow-xl shadow-blue-500/30 transition-all hover:scale-105"
        >
          <div className="w-6 h-6 rounded-full bg-white/20 flex items-center justify-center">
            <Sparkles className="w-3.5 h-3.5 text-white" />
          </div>
          <span className="text-xs font-bold tracking-wide">Ask Nova AI</span>
        </button>
      </div>

      {/* Instant Application Modal */}
      {selectedProductToApply && (
        <ApplicationModal
          product={selectedProductToApply}
          onClose={handleCloseModal}
          onSuccess={handleApplicationSuccess}
        />
      )}

      {/* Google & Multi-Role Login Modal */}
      <LoginModal
        isOpen={loginModalOpen}
        onClose={() => setLoginModalOpen(false)}
        onLoginSuccess={handleLoginSuccess}
      />

      {/* AI Assistant Chat Drawer */}
      <AiChatDrawer
        isOpen={chatOpen}
        onClose={() => setChatOpen(false)}
        onApplyProduct={handleApplyProduct}
        onSelectProductType={(type) => {
          setChatOpen(false);
          setActiveTab('loans');
        }}
      />

      {/* Global Clean Footer */}
      <Footer setActiveTab={setActiveTab} />
    </div>
  );
}

export default App;
