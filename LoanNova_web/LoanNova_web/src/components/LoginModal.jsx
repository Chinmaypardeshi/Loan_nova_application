import React, { useState } from 'react';
import {
  X,
  ShieldCheck,
  CheckCircle2,
  Mail,
  Lock,
  ArrowRight,
  UserCheck,
  Building2,
  ShieldAlert,
  Briefcase,
  User,
  Phone,
  Eye,
  EyeOff,
  AlertCircle,
} from 'lucide-react';
import { login, register } from '../utils/authService';

export function LoginModal({ isOpen, onClose, onLoginSuccess }) {
  if (!isOpen) return null;

  // Tabs: 'real' (email/password) | 'demo' (persona shortcuts)
  const [activeTab, setActiveTab] = useState('real');

  // Real auth form state
  const [mode, setMode] = useState('login'); // 'login' | 'register'
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  // Status
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const resetForm = () => {
    setName(''); setEmail(''); setPhone('');
    setPassword(''); setConfirmPassword('');
    setError(''); setShowPassword(false);
  };

  const switchMode = (m) => { setMode(m); resetForm(); };

  // ── Real Login ──────────────────────────────────────────
  const handleLogin = async () => {
    setError('');
    if (!email.trim() || !password.trim()) {
      return setError('Please enter your email and password.');
    }
    setLoading(true);
    try {
      const data = await login(email.trim(), password.trim());
      onLoginSuccess({
        name: data.name || email.split('@')[0],
        email: data.email || email.trim(),
        role: data.role || 'customer',
        roleLabel: data.roleLabel || 'Borrower',
        avatarText: (data.name || email).slice(0, 2).toUpperCase(),
        authProvider: 'LoanNova Auth',
        isLoggedIn: true,
        userId: data.userId,
        token: data.token,
      });
      onClose();
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  // ── Real Register ───────────────────────────────────────
  const handleRegister = async () => {
    setError('');
    if (!name.trim() || !email.trim() || !phone.trim() || !password.trim()) {
      return setError('All fields are required.');
    }
    if (password !== confirmPassword) {
      return setError('Passwords do not match.');
    }
    if (password.length < 6) {
      return setError('Password must be at least 6 characters.');
    }
    setLoading(true);
    try {
      await register(name.trim(), email.trim(), phone.trim(), password.trim());
      // Auto-login after successful registration
      const data = await login(email.trim(), password.trim());
      onLoginSuccess({
        name: data.name || name.trim(),
        email: data.email || email.trim(),
        role: data.role || 'customer',
        roleLabel: data.roleLabel || 'Borrower',
        avatarText: name.slice(0, 2).toUpperCase(),
        authProvider: 'LoanNova Auth',
        isLoggedIn: true,
        userId: data.userId,
        token: data.token,
      });
      onClose();
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      mode === 'login' ? handleLogin() : handleRegister();
    }
  };

  // ── Demo persona shortcuts (kept for presentations) ─────
  const handleDemoLogin = (roleType) => {
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
      const personas = {
        admin: {
          name: 'Super Admin (Operations)', email: 'admin@loannova.in',
          authProvider: 'Demo Mode', role: 'admin',
          roleLabel: 'Super Administrator', avatarText: 'SA',
        },
        partner: {
          name: 'HDFC Lending Officer', email: 'lending.desk@hdfcbank.com',
          authProvider: 'Demo Mode', role: 'partner',
          roleLabel: 'Bank Underwriter', avatarText: 'HB',
        },
        agent: {
          name: 'Arun Kumar (Advisor)', email: 'arun.agent@loannova.in',
          authProvider: 'Demo Mode', role: 'agent',
          roleLabel: 'Sales Relationship Manager', avatarText: 'AK',
        },
        customer: {
          name: 'Rahul Sharma', email: 'rahul.sharma@loannova.in',
          authProvider: 'Demo Mode', role: 'customer',
          roleLabel: 'Borrower', avatarText: 'RS',
        },
      };
      onLoginSuccess({ ...personas[roleType], isLoggedIn: true });
      onClose();
    }, 350);
  };

  // ── Shared input style ───────────────────────────────────
  const inputCls =
    'w-full px-3 py-2.5 text-sm border border-slate-200 rounded-xl outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-100 transition placeholder:text-slate-400';

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
      <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden text-slate-800">

        {/* ── Header ── */}
        <div className="bg-slate-900 text-white p-5 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-blue-600 flex items-center justify-center">
              <ShieldCheck className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-bold text-base">Sign In to LoanNova</h3>
              <p className="text-[11px] text-slate-400">Shared account — works on web &amp; mobile</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* ── Tabs ── */}
        <div className="flex border-b border-slate-100 text-xs font-semibold bg-slate-50">
          <button
            onClick={() => { setActiveTab('real'); resetForm(); }}
            className={`flex-1 py-3 text-center transition ${
              activeTab === 'real'
                ? 'border-b-2 border-blue-600 text-blue-600 bg-white font-bold'
                : 'text-slate-500 hover:text-slate-800'
            }`}
          >
            Login / Register
          </button>
          <button
            onClick={() => { setActiveTab('demo'); resetForm(); }}
            className={`flex-1 py-3 text-center transition ${
              activeTab === 'demo'
                ? 'border-b-2 border-blue-600 text-blue-600 bg-white font-bold'
                : 'text-slate-500 hover:text-slate-800'
            }`}
          >
            Demo Personas
          </button>
        </div>

        {/* ── Body ── */}
        <div className="p-6 space-y-4 max-h-[70vh] overflow-y-auto">

          {/* ════ REAL AUTH TAB ════ */}
          {activeTab === 'real' && (
            <div className="space-y-4">

              {/* Mode switcher */}
              <div className="flex bg-slate-100 rounded-xl p-1 gap-1">
                <button
                  onClick={() => switchMode('login')}
                  className={`flex-1 py-1.5 rounded-lg text-xs font-bold transition ${
                    mode === 'login' ? 'bg-white shadow text-blue-600' : 'text-slate-500'
                  }`}
                >
                  Sign In
                </button>
                <button
                  onClick={() => switchMode('register')}
                  className={`flex-1 py-1.5 rounded-lg text-xs font-bold transition ${
                    mode === 'register' ? 'bg-white shadow text-blue-600' : 'text-slate-500'
                  }`}
                >
                  Create Account
                </button>
              </div>

              {/* Error banner */}
              {error && (
                <div className="flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 text-xs font-semibold px-3 py-2.5 rounded-xl">
                  <AlertCircle className="w-4 h-4 shrink-0" />
                  <span>{error}</span>
                </div>
              )}

              {/* Register-only fields */}
              {mode === 'register' && (
                <>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                    <input
                      className={`${inputCls} pl-9`}
                      placeholder="Full Name"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      onKeyDown={handleKeyDown}
                    />
                  </div>
                  <div className="relative">
                    <Phone className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                    <input
                      className={`${inputCls} pl-9`}
                      placeholder="Phone Number"
                      type="tel"
                      value={phone}
                      onChange={(e) => setPhone(e.target.value)}
                      onKeyDown={handleKeyDown}
                    />
                  </div>
                </>
              )}

              {/* Email */}
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input
                  className={`${inputCls} pl-9`}
                  placeholder="Email address"
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  onKeyDown={handleKeyDown}
                />
              </div>

              {/* Password */}
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input
                  className={`${inputCls} pl-9 pr-10`}
                  placeholder="Password"
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  onKeyDown={handleKeyDown}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((v) => !v)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>

              {/* Confirm Password (register only) */}
              {mode === 'register' && (
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                  <input
                    className={`${inputCls} pl-9`}
                    placeholder="Confirm Password"
                    type="password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    onKeyDown={handleKeyDown}
                  />
                </div>
              )}

              {/* Submit button */}
              <button
                onClick={mode === 'login' ? handleLogin : handleRegister}
                disabled={loading}
                className="w-full py-3 bg-blue-600 hover:bg-blue-700 disabled:opacity-60 text-white rounded-xl text-sm font-bold transition flex items-center justify-center gap-2"
              >
                {loading ? (
                  <span className="inline-block w-4 h-4 border-2 border-white/40 border-t-white rounded-full animate-spin" />
                ) : mode === 'login' ? (
                  <>Sign In <ArrowRight className="w-4 h-4" /></>
                ) : (
                  <>Create Account <CheckCircle2 className="w-4 h-4" /></>
                )}
              </button>

              <p className="text-center text-[11px] text-slate-400">
                {mode === 'login' ? (
                  <>No account?{' '}
                    <button onClick={() => switchMode('register')} className="text-blue-600 font-semibold hover:underline">
                      Register here
                    </button>
                  </>
                ) : (
                  <>Already have an account?{' '}
                    <button onClick={() => switchMode('login')} className="text-blue-600 font-semibold hover:underline">
                      Sign in
                    </button>
                  </>
                )}
              </p>
            </div>
          )}

          {/* ════ DEMO PERSONAS TAB ════ */}
          {activeTab === 'demo' && (
            <div className="space-y-3">
              <p className="text-xs text-slate-500 bg-amber-50 border border-amber-100 rounded-xl px-3 py-2">
                ⚡ <strong>Demo Mode</strong> — instantly loads a preset persona without touching the backend. Use for presentations only.
              </p>

              {[
                {
                  key: 'admin', icon: ShieldAlert, color: 'purple',
                  title: 'Super Admin', sub: 'Full Operations & Fraud Management',
                },
                {
                  key: 'partner', icon: Building2, color: 'blue',
                  title: 'Bank Partner (Lender)', sub: 'HDFC Underwriting Desk & Disbursals',
                },
                {
                  key: 'agent', icon: Briefcase, color: 'emerald',
                  title: 'Sales Advisor CRM', sub: 'Lead Pipeline & Customer Telecalling',
                },
                {
                  key: 'customer', icon: UserCheck, color: 'slate',
                  title: 'Customer (Borrower)', sub: 'Rahul Sharma • 765 Credit Score Profile',
                },
              ].map(({ key, icon: Icon, color, title, sub }) => (
                <button
                  key={key}
                  onClick={() => handleDemoLogin(key)}
                  disabled={loading}
                  className={`w-full p-2.5 rounded-xl border border-slate-200 hover:border-${color}-300 hover:bg-${color}-50/50 text-left text-xs font-semibold flex items-center justify-between transition group disabled:opacity-50`}
                >
                  <div className="flex items-center gap-2.5">
                    <div className={`w-8 h-8 rounded-lg bg-${color}-100 text-${color}-700 flex items-center justify-center`}>
                      <Icon className="w-4 h-4" />
                    </div>
                    <div>
                      <div className="font-bold text-slate-900">{title}</div>
                      <span className="text-[10px] text-slate-400">{sub}</span>
                    </div>
                  </div>
                  <ArrowRight className="w-4 h-4 text-slate-400 group-hover:text-slate-600 transition" />
                </button>
              ))}
            </div>
          )}
        </div>

        {/* ── Footer ── */}
        <div className="bg-slate-50 px-6 py-3 border-t border-slate-100 text-center text-[11px] text-slate-400">
          Protected by RBI statutory security protocols &amp; 256-bit AES encryption.
        </div>
      </div>
    </div>
  );
}
