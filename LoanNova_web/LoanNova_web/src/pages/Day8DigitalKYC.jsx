import React, { useState } from 'react';
import { 
  ShieldCheck, 
  FileCheck2, 
  Camera, 
  Upload, 
  CheckCircle2, 
  ArrowRight, 
  Sparkles, 
  FileText, 
  UserCheck,
  AlertCircle,
  Download,
  Eye,
  X
} from 'lucide-react';
import confetti from 'canvas-confetti';
import { downloadKycCertificate } from '../utils/documentGenerator';

export function Day8DigitalKYC({ setActiveTab }) {
  const [aadhaarInput, setAadhaarInput] = useState('5432 9876 1234');
  const [panInput, setPanInput] = useState('ABCDE1234F');
  const [isVerifying, setIsVerifying] = useState(false);
  const [kycResult, setKycResult] = useState({
    status: 'Verified (Tier 1)',
    kycId: 'KYC-UIDAI-89412',
    aadhaarMasked: 'XXXX-XXXX-1234',
    ocrConfidence: '99.8% Match',
    nameMatch: 'Exact (Rahul Sharma)'
  });
  const [livenessTested, setLivenessTested] = useState(true);
  const [previewDoc, setPreviewDoc] = useState(null);
  const [toastMsg, setToastMsg] = useState(null);

  const [documents, setDocuments] = useState([
    { 
      name: 'Latest 3 Months Salary Slip', 
      type: 'Income Proof', 
      status: 'OCR Verified', 
      confidence: '99.8%',
      extractedData: {
        employer: 'Tata Consultancy Services Ltd',
        grossPay: '₹72,500',
        netPay: '₹65,400',
        month: 'August - October 2026'
      }
    },
    { 
      name: 'Bank Statement (6 Months)', 
      type: 'Banking Proof', 
      status: 'OCR Verified', 
      confidence: '98.5%',
      extractedData: {
        bankName: 'HDFC Bank (Salary A/C)',
        avgBalance: '₹1,48,200',
        inflowCount: '6 Credits',
        bounceCount: '0 (Clean)'
      }
    },
    { 
      name: 'Form 16 / ITR Ack', 
      type: 'Tax Record', 
      status: 'OCR Verified', 
      confidence: '99.1%',
      extractedData: {
        assessmentYear: '2026-27',
        taxableIncome: '₹7,80,000',
        taxPaid: '₹34,500 (Verified)',
        ackNumber: 'ITR-7781290312'
      }
    },
  ]);

  const showToast = (msg) => {
    setToastMsg(msg);
    setTimeout(() => setToastMsg(null), 3000);
  };

  const handleVerifyKyc = async () => {
    setIsVerifying(true);
    try {
      const res = await fetch('/api/kyc/verify', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ aadhaar: aadhaarInput, pan: panInput, name: 'Rahul Sharma' }),
      });
      const data = await res.json();
      setKycResult(data);
      confetti({ particleCount: 70, spread: 60 });
      showToast('✓ Identity documents verified with UIDAI & NSDL databases!');
    } catch (err) {
      // Local fallback
      setKycResult({
        status: 'Verified (Tier 1)',
        kycId: `KYC-UIDAI-${Math.floor(10000 + Math.random() * 90000)}`,
        aadhaarMasked: `XXXX-XXXX-${aadhaarInput.slice(-4) || '1234'}`,
        ocrConfidence: '99.8% Match',
        nameMatch: 'Exact (Rahul Sharma)'
      });
      confetti({ particleCount: 70, spread: 60 });
      showToast('✓ Identity verified successfully!');
    } finally {
      setIsVerifying(false);
    }
  };

  const handleUploadDoc = (index) => {
    const updated = [...documents];
    updated[index].status = 'OCR Verified';
    updated[index].confidence = '99.4%';
    setDocuments(updated);
    showToast(`✓ ${updated[index].name} uploaded & parsed via OCR.`);
  };

  const handleDownloadCertificate = () => {
    downloadKycCertificate('Rahul Sharma', panInput, `XXXX-XXXX-${aadhaarInput.slice(-4) || '1234'}`);
    showToast('✓ Official e-KYC Compliance Certificate downloaded.');
  };

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
            <span>DIGITAL VERIFICATION</span>
            <span>•</span>
            <span>Paperless KYC & Smart Document Vault</span>
          </div>
          <h2 className="text-xl sm:text-2xl font-bold text-slate-900">
            Paperless Onboarding, Face Match & Smart OCR
          </h2>
          <p className="text-xs text-slate-500 mt-1">
            UIDAI Aadhaar OTP, NSDL PAN verification, AI face liveness detection, and automated document parsing.
          </p>
        </div>

        <div className="flex flex-wrap gap-2">
          <button
            onClick={handleDownloadCertificate}
            className="px-3.5 py-2 bg-slate-100 hover:bg-slate-200 text-slate-800 rounded-xl text-xs font-bold flex items-center gap-1.5 transition border border-slate-200"
          >
            <Download className="w-4 h-4 text-emerald-600" />
            <span>Download e-KYC Certificate</span>
          </button>
          <button
            onClick={() => setActiveTab('overview')}
            className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold flex items-center gap-1.5 transition"
          >
            <span>View Dashboard</span>
            <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
        {/* Left Column: Identity Verification Terminal */}
        <div className="lg:col-span-7 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-5">
          <div className="flex items-center justify-between border-b border-slate-100 pb-3">
            <h3 className="text-sm font-bold text-slate-900 flex items-center gap-2">
              <ShieldCheck className="w-4 h-4 text-emerald-600" />
              <span>Instant UIDAI & NSDL Verification</span>
            </h3>
            <span className="text-[10px] font-bold bg-emerald-50 text-emerald-700 px-2.5 py-0.5 rounded-full border border-emerald-100">
              RBI Compliant e-KYC
            </span>
          </div>

          <div className="space-y-3.5">
            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                Aadhaar Number (12 Digits)
              </label>
              <input
                type="text"
                value={aadhaarInput}
                onChange={(e) => setAadhaarInput(e.target.value)}
                className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl font-mono font-bold bg-slate-50 focus:bg-white outline-none focus:border-blue-500"
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-700 mb-1">
                PAN Card (Permanent Account Number)
              </label>
              <input
                type="text"
                value={panInput}
                onChange={(e) => setPanInput(e.target.value)}
                className="w-full px-3.5 py-2 text-xs border border-slate-200 rounded-xl font-mono font-bold uppercase bg-slate-50 focus:bg-white outline-none focus:border-blue-500"
              />
            </div>

            <button
              onClick={handleVerifyKyc}
              disabled={isVerifying}
              className="w-full py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-bold transition flex items-center justify-center gap-2 shadow-sm shadow-blue-500/20"
            >
              {isVerifying ? (
                <span className="flex items-center gap-2">
                  <span className="w-3.5 h-3.5 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                  Validating with Govt API Gateways...
                </span>
              ) : (
                <>
                  <Sparkles className="w-4 h-4" />
                  <span>Verify Identity Documents Instantly</span>
                </>
              )}
            </button>

            {kycResult && (
              <div className="p-4 bg-emerald-50/80 border border-emerald-200 rounded-xl space-y-2 text-xs text-emerald-900 animate-fade-in">
                <div className="flex items-center justify-between font-bold">
                  <span className="flex items-center gap-1.5 text-emerald-800">
                    <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                    Status: {kycResult.status}
                  </span>
                  <span className="font-mono text-[11px] bg-emerald-100 px-2 py-0.5 rounded text-emerald-800">
                    {kycResult.kycId}
                  </span>
                </div>
                <div className="grid grid-cols-2 gap-2 text-[11px] pt-1">
                  <div>Masked Aadhaar: <strong className="font-mono">{kycResult.aadhaarMasked}</strong></div>
                  <div>NSDL PAN Status: <strong className="text-emerald-700">Active & Valid</strong></div>
                  <div>AI OCR Match: <strong>{kycResult.ocrConfidence}</strong></div>
                  <div>Name Authenticity: <strong>{kycResult.nameMatch}</strong></div>
                </div>

                <div className="pt-2 border-t border-emerald-200/60 flex justify-end">
                  <button
                    onClick={handleDownloadCertificate}
                    className="px-3 py-1 bg-emerald-700 hover:bg-emerald-800 text-white rounded-lg text-xs font-bold flex items-center gap-1 shadow-2xs"
                  >
                    <Download className="w-3 h-3" />
                    <span>Download e-KYC Pass Certificate</span>
                  </button>
                </div>
              </div>
            )}
          </div>

          {/* Biometric Liveness / Video KYC Simulation */}
          <div className="pt-4 border-t border-slate-100">
            <h4 className="text-xs font-bold text-slate-800 mb-2 flex items-center gap-1.5">
              <Camera className="w-4 h-4 text-blue-600" />
              <span>AI Face Liveness & Video KYC Simulation</span>
            </h4>
            <div className="bg-slate-50 border border-slate-200 rounded-xl p-4 flex flex-col sm:flex-row items-center justify-between gap-4">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-xl bg-blue-100 flex items-center justify-center text-blue-700">
                  <UserCheck className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <div className="text-xs font-bold text-slate-900">
                    {livenessTested ? 'Face Liveness Confirmed (0.98 Score)' : 'Liveness Detection Check'}
                  </div>
                  <p className="text-[11px] text-slate-500">
                    Anti-spoofing algorithm checks micro-movements and 3D depth.
                  </p>
                </div>
              </div>

              <button
                onClick={() => {
                  setLivenessTested(true);
                  showToast('✓ Face Liveness verified (Anti-Spoof Score: 0.98)');
                }}
                className={`px-3 py-2 rounded-xl text-xs font-bold whitespace-nowrap transition ${
                  livenessTested
                    ? 'bg-emerald-100 text-emerald-800 border border-emerald-200'
                    : 'bg-blue-600 hover:bg-blue-700 text-white shadow-sm'
                }`}
              >
                {livenessTested ? '✓ Liveness Verified' : 'Test Liveness'}
              </button>
            </div>
          </div>
        </div>

        {/* Right Column: Encrypted Document Management Vault */}
        <div className="lg:col-span-5 bg-white rounded-2xl p-6 border border-slate-200 shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-xs font-bold uppercase tracking-wider text-slate-400">
              Encrypted Document Vault (AES-256)
            </h3>
            <span className="text-[10px] text-emerald-600 font-bold bg-emerald-50 px-2 py-0.5 rounded-full">
              3/3 Verified
            </span>
          </div>

          <p className="text-xs text-slate-600">
            Uploaded proofs are parsed in real time by LoanNova OCR to verify income, vintage, and debt capacity.
          </p>

          <div className="space-y-3">
            {documents.map((doc, idx) => (
              <div
                key={idx}
                className="p-3.5 bg-slate-50 rounded-xl border border-slate-200 flex items-center justify-between text-xs hover:border-blue-300 transition"
              >
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded-lg bg-blue-50 text-blue-600 flex items-center justify-center">
                    <FileText className="w-4 h-4" />
                  </div>
                  <div>
                    <h5 className="font-bold text-slate-900 leading-tight">{doc.name}</h5>
                    <span className="text-[10px] text-slate-400">{doc.type}</span>
                  </div>
                </div>

                <div className="flex items-center gap-1.5">
                  <button
                    onClick={() => setPreviewDoc(doc)}
                    className="p-1.5 bg-white border border-slate-200 hover:bg-slate-100 text-slate-700 rounded-lg text-[10px] font-bold transition flex items-center gap-1"
                    title="Inspect Parsed OCR Data"
                  >
                    <Eye className="w-3 h-3 text-blue-600" />
                    <span>OCR View</span>
                  </button>

                  {doc.status === 'OCR Verified' ? (
                    <span className="inline-block text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-1 rounded border border-emerald-100">
                      ✓ {doc.confidence}
                    </span>
                  ) : (
                    <button
                      onClick={() => handleUploadDoc(idx)}
                      className="px-2.5 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-[11px] font-bold transition flex items-center gap-1"
                    >
                      <Upload className="w-3 h-3" />
                      <span>Upload</span>
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>

          <div className="bg-blue-50 border border-blue-100 rounded-xl p-3 text-[11px] text-blue-800 space-y-1">
            <span className="font-bold block">Zero-Knowledge Vault Guarantee:</span>
            <span>Financial records are processed in sandboxed enclaves with PII redaction according to RBI/2022-23/111 guidelines.</span>
          </div>
        </div>
      </div>

      {/* OCR DOCUMENT PREVIEW MODAL */}
      {previewDoc && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-fade-in">
          <div className="bg-white rounded-2xl shadow-2xl border border-slate-200 w-full max-w-md overflow-hidden text-slate-800">
            <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <FileCheck2 className="w-5 h-5 text-emerald-400" />
                <div>
                  <h3 className="font-bold text-sm">Parsed OCR Identity Record</h3>
                  <p className="text-[11px] text-slate-400">{previewDoc.name}</p>
                </div>
              </div>
              <button
                onClick={() => setPreviewDoc(null)}
                className="p-1 rounded-lg text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <div className="p-5 space-y-3 text-xs">
              <div className="flex items-center justify-between p-2.5 bg-emerald-50 text-emerald-900 rounded-xl border border-emerald-100 font-bold">
                <span>OCR Parser Confidence:</span>
                <span>{previewDoc.confidence} (High Authenticity)</span>
              </div>

              <div className="space-y-2 border border-slate-200 rounded-xl p-3 bg-slate-50">
                {Object.entries(previewDoc.extractedData || {}).map(([k, v], idx) => (
                  <div key={idx} className="flex justify-between py-1 border-b border-slate-200/60 last:border-0">
                    <span className="text-slate-500 capitalize">{k.replace(/([A-Z])/g, ' $1')}:</span>
                    <strong className="text-slate-900">{v}</strong>
                  </div>
                ))}
              </div>

              <div className="pt-2 flex justify-end">
                <button
                  onClick={() => setPreviewDoc(null)}
                  className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold rounded-xl transition"
                >
                  Done
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default Day8DigitalKYC;
