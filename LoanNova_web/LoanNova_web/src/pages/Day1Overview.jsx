import React, { useState } from 'react';
import { 
  Layers, 
  Cpu, 
  Database, 
  ShieldCheck, 
  Zap, 
  Globe, 
  Server, 
  Activity, 
  ArrowRight, 
  CheckCircle2 
} from 'lucide-react';

export function Day1Overview({ setActiveTab }) {
  const [activeArchLayer, setActiveArchLayer] = useState('gateway');

  const archLayers = {
    gateway: {
      title: 'API Gateway & Edge CDN',
      desc: 'Handles 500,000+ req/min with sub-150ms latency, rate limiting, and SSL termination.',
      tech: ['Nginx / Cloudflare CDN', 'Kong API Gateway', 'WAF Shield', 'DDoS Protection']
    },
    services: {
      title: 'Microservices Mesh',
      desc: 'Stateless containerized services deployed on Kubernetes with auto-scaling.',
      tech: ['Product Engine', 'KYC Verification', 'AI Recommendation', 'Loan Origination System (LOS)']
    },
    database: {
      title: 'Distributed Storage & Cache',
      desc: 'Active-Active multi-region database with zero data-loss replication.',
      tech: ['PostgreSQL (ACID Transactions)', 'Redis Enterprise Cache', 'Elasticsearch / OpenSearch', 'S3 Encrypted Vault']
    },
    security: {
      title: 'Enterprise Security & Compliance',
      desc: '256-bit AES at rest, TLS 1.3 in transit, RBI, DPDP Act & PCI-DSS compliance.',
      tech: ['OAuth2 / OpenID Connect', 'RBAC & ABAC Access', 'Hardware Security Module (HSM)', 'Automated Audit Logs']
    }
  };

  return (
    <div className="space-y-6">
      {/* Day 1 Hero Header */}
      <div className="bg-gradient-to-r from-slate-900 via-indigo-950 to-blue-900 rounded-3xl p-6 sm:p-8 text-white shadow-xl relative overflow-hidden">
        <div className="relative z-10 max-w-3xl">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/20 text-blue-300 text-xs font-bold mb-3 border border-blue-400/30">
            <span>ENTERPRISE ARCHITECTURE</span>
            <span>•</span>
            <span>High-Availability Blueprint</span>
          </div>
          <h1 className="text-2xl sm:text-4xl font-extrabold tracking-tight mb-3">
            LoanNova System Architecture
          </h1>
          <p className="text-sm sm:text-base text-slate-300 leading-relaxed mb-6">
            Enterprise financial marketplace engineered for 100M+ users, 99.99% uptime, and instant loan approvals with bank API integrations.
          </p>

          <div className="flex flex-wrap gap-3">
            <button
              onClick={() => setActiveTab('loans')}
              className="px-5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-xs font-bold flex items-center gap-2 transition shadow-lg shadow-blue-600/30"
            >
              <span>Explore Loan Marketplace</span>
              <ArrowRight className="w-4 h-4" />
            </button>
            <button
              onClick={() => setActiveTab('overview')}
              className="px-4 py-2.5 bg-white/10 hover:bg-white/20 text-white border border-white/20 rounded-xl text-xs font-bold transition"
            >
              View Operations Dashboard
            </button>
          </div>
        </div>
      </div>

      {/* SLA & Performance Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <div className="flex items-center gap-2 text-blue-600 mb-1">
            <Zap className="w-4 h-4" />
            <span className="text-xs font-bold uppercase tracking-wider text-slate-400">Response Time</span>
          </div>
          <div className="text-xl font-extrabold text-slate-900">&lt; 150 ms</div>
          <p className="text-[11px] text-slate-500 mt-1">Search & filter latency</p>
        </div>

        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <div className="flex items-center gap-2 text-emerald-600 mb-1">
            <Activity className="w-4 h-4" />
            <span className="text-xs font-bold uppercase tracking-wider text-slate-400">High Availability</span>
          </div>
          <div className="text-xl font-extrabold text-slate-900">99.99%</div>
          <p className="text-[11px] text-slate-500 mt-1">Active-Active multi-region</p>
        </div>

        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <div className="flex items-center gap-2 text-indigo-600 mb-1">
            <Server className="w-4 h-4" />
            <span className="text-xs font-bold uppercase tracking-wider text-slate-400">Concurrent Sessions</span>
          </div>
          <div className="text-xl font-extrabold text-slate-900">1 Million+</div>
          <p className="text-[11px] text-slate-500 mt-1">Stateless microservices</p>
        </div>

        <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm">
          <div className="flex items-center gap-2 text-purple-600 mb-1">
            <ShieldCheck className="w-4 h-4" />
            <span className="text-xs font-bold uppercase tracking-wider text-slate-400">Security</span>
          </div>
          <div className="text-xl font-extrabold text-slate-900">AES-256</div>
          <p className="text-[11px] text-slate-500 mt-1">End-to-end encrypted</p>
        </div>
      </div>

      {/* Interactive Microservices Architecture Explorer */}
      <div className="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h3 className="text-base font-bold text-slate-900">Interactive Architecture Explorer</h3>
            <p className="text-xs text-slate-500">Click any component to inspect implementation details</p>
          </div>
          <span className="text-xs font-bold text-blue-600 bg-blue-50 px-2.5 py-1 rounded-full">
            Microservices Model
          </span>
        </div>

        {/* Layer Selector Buttons */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-2 mb-4">
          {[
            { id: 'gateway', label: '1. Gateway & CDN', icon: Globe },
            { id: 'services', label: '2. Microservices', icon: Cpu },
            { id: 'database', label: '3. DB & Cache', icon: Database },
            { id: 'security', label: '4. Security Vault', icon: ShieldCheck },
          ].map((item) => {
            const Icon = item.icon;
            const isSelected = activeArchLayer === item.id;
            return (
              <button
                key={item.id}
                onClick={() => setActiveArchLayer(item.id)}
                className={`p-3 rounded-xl border text-left text-xs font-semibold flex items-center gap-2 transition ${
                  isSelected
                    ? 'border-blue-600 bg-blue-50/80 text-blue-700 shadow-sm'
                    : 'border-slate-200 hover:border-slate-300 bg-slate-50 text-slate-700'
                }`}
              >
                <Icon className={`w-4 h-4 ${isSelected ? 'text-blue-600' : 'text-slate-400'}`} />
                <span>{item.label}</span>
              </button>
            );
          })}
        </div>

        {/* Selected Layer Details Box */}
        <div className="bg-slate-50 border border-slate-200 rounded-xl p-5">
          <div className="flex items-center justify-between mb-2">
            <h4 className="text-sm font-bold text-slate-900">
              {archLayers[activeArchLayer].title}
            </h4>
            <span className="text-[11px] text-emerald-600 font-bold flex items-center gap-1">
              <CheckCircle2 className="w-3.5 h-3.5" /> Fully Integrated
            </span>
          </div>
          <p className="text-xs text-slate-600 mb-4">
            {archLayers[activeArchLayer].desc}
          </p>

          <div>
            <span className="text-[11px] font-bold text-slate-400 uppercase tracking-wider block mb-2">
              Key Technologies & Subsystems:
            </span>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
              {archLayers[activeArchLayer].tech.map((t, idx) => (
                <div key={idx} className="bg-white p-2 rounded-lg border border-slate-200 text-xs font-medium text-slate-800 text-center shadow-2xs">
                  {t}
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
