import React, { useState } from 'react';
import { 
  KeyRound, 
  Smartphone, 
  Mail, 
  ShieldCheck, 
  CheckCircle2, 
  ArrowRight, 
  User, 
  Lock, 
  Sparkles, 
  Fingerprint,
  RefreshCw
} from 'lucide-react';

export function Day2Auth({ selectedRole, setSelectedRole, setActiveTab }) {
  const [authMode, setAuthMode] = useState('otp'); // 'otp' | 'password' | 'passwordless'
  const [phone, setPhone] = useState('9876543210');
  const [otpSent, setOtpSent] = useState(false);
  const [otpValue, setOtpValue] = useState(['4', '8', '2', '1']);
  const [verified, setVerified] = useState(false);
  const [mfaEnabled, setMfaEnabled] = useState(true);

  const handleSendOtp = () => {
    setOtpSent(true);
    setVerified(false);
  };

  const handleVerifyOtp = () => {
    setVerified(true);
  };

  return (
    <div className="space-y-6">
      {/* Header Banner */}
      <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-700 text-xs font-bold mb-1.5">
            <span>IDENTITY & ACCESS</span>
            <span>•</span>
            <span>Customer Authentication & Security Portal</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Secure Access, OTP & Identity Profiles
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            Compliant with RBI guidelines for 2-factor authentication, biometric logins, and role-based access.
          </p>
        </div>

        <button
          onClick={() => setActiveTab('loans')}
          className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition self-stretch md:self-auto justify-center"
        >
          <span>Explore Loans</span>
          <ArrowRight className="w-4 h-4" />
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Interactive Auth Simulator */}
        <div className="lg:col-span-7 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-5">
          <div className="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 className="text-sm font-bold text-slate-900 flex items-center gap-2">
              <KeyRound className="w-4 h-4 text-blue-600" />
              <span>Multi-Method Login Terminal</span>
            </h3>

            {/* Auth Method Tabs */}
            <div className="flex gap-1 bg-slate-100 p-1 rounded-lg text-xs font-semibold">
              <button
                onClick={() => setAuthMode('otp')}
                className={`px-2.5 py-1 rounded-md transition ${authMode === 'otp' ? 'bg-white text-blue-600 shadow-2xs font-bold' : 'text-slate-600'}`}
              >
                Mobile OTP
              </button>
              <button
                onClick={() => setAuthMode('passwordless')}
                className={`px-2.5 py-1 rounded-md transition ${authMode === 'passwordless' ? 'bg-white text-blue-600 shadow-2xs font-bold' : 'text-slate-600'}`}
              >
                Passwordless
              </button>
              <button
                onClick={() => setAuthMode('social')}
                className={`px-2.5 py-1 rounded-md transition ${authMode === 'social' ? 'bg-white text-blue-600 shadow-2xs font-bold' : 'text-slate-600'}`}
              >
                Social SSO
              </button>
            </div>
          </div>

          {/* OTP Mode */}
          {authMode === 'otp' && (
            <div className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1.5">
                  Mobile Number (SMS & WhatsApp OTP)
                </label>
                <div className="flex gap-2">
                  <div className="flex items-center px-3 bg-slate-100 border border-slate-200 rounded-xl text-xs font-bold text-slate-600">
                    +91
                  </div>
                  <input
                    type="tel"
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="flex-1 px-3.5 py-2 text-xs border border-slate-200 rounded-xl font-semibold outline-none focus:border-blue-500 bg-slate-50 focus:bg-white"
                  />
                  <button
                    onClick={handleSendOtp}
                    className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition whitespace-nowrap shadow-sm shadow-blue-500/20"
                  >
                    {otpSent ? 'Resend OTP' : 'Send OTP'}
                  </button>
                </div>
              </div>

              {otpSent && (
                <div className="p-4 bg-blue-50/70 border border-blue-200 rounded-xl space-y-3">
                  <div className="flex items-center justify-between text-xs">
                    <span className="text-blue-900 font-semibold">Enter 4-Digit OTP Code</span>
                    <span className="text-emerald-700 font-bold bg-emerald-100 px-2 py-0.5 rounded text-[11px]">
                      Simulated OTP: 4821
                    </span>
                  </div>

                  <div className="flex gap-2 justify-center py-1">
                    {otpValue.map((digit, i) => (
                      <input
                        key={i}
                        type="text"
                        maxLength="1"
                        value={digit}
                        onChange={(e) => {
                          const newOtp = [...otpValue];
                          newOtp[i] = e.target.value;
                          setOtpValue(newOtp);
                        }}
                        className="w-12 h-12 text-center text-lg font-bold border border-blue-300 rounded-xl bg-white text-slate-900 focus:ring-2 focus:ring-blue-500 outline-none"
                      />
                    ))}
                  </div>

                  <button
                    onClick={handleVerifyOtp}
                    className="w-full py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-1.5 shadow-md shadow-emerald-600/20"
                  >
                    <CheckCircle2 className="w-4 h-4" />
                    <span>Verify OTP & Sign In</span>
                  </button>
                </div>
              )}

              {verified && (
                <div className="p-3 bg-emerald-50 border border-emerald-200 rounded-xl flex items-center justify-between text-xs text-emerald-800">
                  <span className="font-bold flex items-center gap-1.5">
                    <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                    Session Authenticated: Rahul Sharma (Token Generated)
                  </span>
                  <span className="text-[10px] bg-emerald-200/60 font-mono px-2 py-0.5 rounded">
                    JWT Expires in 24h
                  </span>
                </div>
              )}
            </div>
          )}

          {/* Passwordless Biometric / Magic Link Mode */}
          {authMode === 'passwordless' && (
            <div className="p-4 bg-slate-50 border border-slate-200 rounded-xl space-y-3 text-center">
              <div className="w-12 h-12 rounded-full bg-blue-100 text-blue-600 flex items-center justify-center mx-auto">
                <Fingerprint className="w-6 h-6" />
              </div>
              <div>
                <h4 className="text-xs font-bold text-slate-900">FIDO2 / WebAuthn Biometric Login</h4>
                <p className="text-[11px] text-slate-500 mt-0.5">
                  Sign in instantly using Touch ID, Face ID, or Windows Hello security key.
                </p>
              </div>
              <button
                onClick={() => setVerified(true)}
                className="px-5 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition inline-flex items-center gap-1.5"
              >
                <Fingerprint className="w-4 h-4" />
                <span>Simulate Biometric Verification</span>
              </button>
            </div>
          )}

          {/* Social SSO Mode */}
          {authMode === 'social' && (
            <div className="space-y-2">
              <button
                onClick={() => setVerified(true)}
                className="w-full p-2.5 border border-slate-200 hover:bg-slate-50 rounded-xl text-xs font-semibold text-slate-700 flex items-center justify-center gap-2 transition"
              >
                <span className="font-bold text-blue-600">G</span>
                <span>Continue with Google Workspace</span>
              </button>
              <button
                onClick={() => setVerified(true)}
                className="w-full p-2.5 border border-slate-200 hover:bg-slate-50 rounded-xl text-xs font-semibold text-slate-700 flex items-center justify-center gap-2 transition"
              >
                <span className="font-bold text-slate-900"></span>
                <span>Continue with Apple ID</span>
              </button>
            </div>
          )}

          {/* Security & MFA Settings */}
          <div className="pt-3 border-t border-slate-100">
            <div className="flex items-center justify-between">
              <div>
                <span className="text-xs font-bold text-slate-800">Multi-Factor Authentication (MFA)</span>
                <p className="text-[11px] text-slate-500">Require secondary OTP check on new device logins</p>
              </div>
              <button
                onClick={() => setMfaEnabled(!mfaEnabled)}
                className={`w-11 h-6 rounded-full transition-colors relative ${mfaEnabled ? 'bg-blue-600' : 'bg-slate-300'}`}
              >
                <span className={`block w-4 h-4 rounded-full bg-white transition-transform ${mfaEnabled ? 'translate-x-6' : 'translate-x-1'}`}></span>
              </button>
            </div>
          </div>
        </div>

        {/* Right Column: User Profile & Role Overview */}
        <div className="lg:col-span-5 space-y-4">
          <div className="bg-white rounded-2xl p-5 border border-slate-200 shadow-sm">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400 mb-3">
              Active User Identity Profile
            </h3>

            <div className="flex items-center gap-3 p-3 bg-slate-50 rounded-xl border border-slate-100 mb-4">
              <div className="w-12 h-12 rounded-full bg-gradient-to-tr from-blue-600 to-indigo-600 text-white font-extrabold flex items-center justify-center text-sm">
                RS
              </div>
              <div>
                <h4 className="text-sm font-bold text-slate-900">Rahul Sharma</h4>
                <p className="text-xs text-slate-500">rahul.sharma@example.com</p>
                <span className="text-[10px] bg-emerald-100 text-emerald-800 font-bold px-2 py-0.5 rounded-full inline-block mt-1">
                  KYC Verified • Tier 1
                </span>
              </div>
            </div>

            <div className="space-y-2 text-xs">
              <div className="flex justify-between py-1.5 border-b border-slate-100">
                <span className="text-slate-500">Registered Phone:</span>
                <span className="font-semibold text-slate-800">+91 98765 43210</span>
              </div>
              <div className="flex justify-between py-1.5 border-b border-slate-100">
                <span className="text-slate-500">PAN Verification:</span>
                <span className="font-semibold text-emerald-600">ABCDE1234F (Linked)</span>
              </div>
              <div className="flex justify-between py-1.5 border-b border-slate-100">
                <span className="text-slate-500">Credit Score:</span>
                <span className="font-bold text-blue-600">765 (Experian)</span>
              </div>
              <div className="flex justify-between py-1.5">
                <span className="text-slate-500">Session Security:</span>
                <span className="font-semibold text-slate-800">TLS 1.3 / AES-256</span>
              </div>
            </div>
          </div>

          {/* Quick Role Switcher Showcase */}
          <div className="bg-slate-900 text-white rounded-2xl p-5 shadow-sm space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-blue-400 uppercase tracking-wider">
                RBAC Access Preview
              </span>
              <span className="text-[10px] bg-blue-500/20 text-blue-300 px-2 py-0.5 rounded">
                Current: {selectedRole}
              </span>
            </div>
            <p className="text-xs text-slate-300">
              LoanNova isolates workflows for Customers, Banks, Loan Advisors, and Compliance Officers.
            </p>

            <div className="grid grid-cols-2 gap-2 text-xs">
              {[
                { id: 'customer', name: 'Borrower' },
                { id: 'partner', name: 'Bank Partner' },
                { id: 'agent', name: 'Sales Agent' },
                { id: 'admin', name: 'Super Admin' },
              ].map((r) => (
                <button
                  key={r.id}
                  onClick={() => setSelectedRole(r.id)}
                  className={`p-2 rounded-lg text-center font-bold transition ${
                    selectedRole === r.id
                      ? 'bg-blue-600 text-white shadow-sm'
                      : 'bg-slate-800 hover:bg-slate-700 text-slate-300'
                  }`}
                >
                  {r.name}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
