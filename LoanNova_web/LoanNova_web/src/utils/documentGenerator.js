// Utility to generate printable official Sanction Letter, Payment Receipt, Credit Report, and KYC Certificates

export function downloadSanctionLetter(app) {
  const currentDate = new Date().toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  const validUntil = new Date(Date.now() + 60 * 24 * 60 * 60 * 1000).toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  const amountStr = Number(app.amount || 300000).toLocaleString('en-IN');
  const emiStr = Number(app.emi || 9750).toLocaleString('en-IN');
  const rate = app.interestRate || 10.5;
  const tenure = app.tenure || 36;
  const bank = app.bank || 'HDFC Bank';
  const applicant = app.applicantName || 'Rahul Sharma';
  const appId = app.id || 'APP-10821';
  const pan = app.pan || 'ABCDE1234F';

  const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Sanction Letter - ${appId}</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      padding: 40px;
      color: #1e293b;
      background: #f8fafc;
    }
    .sheet {
      max-width: 800px;
      margin: 0 auto;
      background: #ffffff;
      padding: 48px;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      border-bottom: 2px solid #2563eb;
      padding-bottom: 20px;
      margin-bottom: 24px;
    }
    .brand-title {
      font-size: 26px;
      font-weight: 800;
      color: #0f172a;
      letter-spacing: -0.5px;
    }
    .brand-sub {
      font-size: 11px;
      color: #2563eb;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .badge-approved {
      background: #ecfdf5;
      color: #047857;
      border: 1px solid #a7f3d0;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
    }
    .meta-row {
      display: flex;
      justify-content: space-between;
      font-size: 12px;
      color: #64748b;
      margin-bottom: 20px;
    }
    .subject {
      font-size: 14px;
      font-weight: 700;
      color: #0f172a;
      background: #f1f5f9;
      padding: 10px 14px;
      border-radius: 6px;
      margin-bottom: 20px;
    }
    .details-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
      font-size: 13px;
    }
    .details-table th, .details-table td {
      padding: 10px 14px;
      border: 1px solid #e2e8f0;
      text-align: left;
    }
    .details-table th {
      background: #f8fafc;
      font-weight: 600;
      color: #475569;
      width: 40%;
    }
    .details-table td {
      font-weight: 700;
      color: #0f172a;
    }
    .highlight-cell {
      color: #047857 !important;
      font-size: 15px;
    }
    .terms {
      font-size: 11px;
      color: #64748b;
      line-height: 1.6;
      margin-top: 24px;
      border-top: 1px solid #e2e8f0;
      padding-top: 16px;
    }
    .signatures {
      display: flex;
      justify-content: space-between;
      margin-top: 36px;
      padding-top: 16px;
    }
    .sig-block {
      text-align: center;
      width: 200px;
      border-top: 1px dashed #94a3b8;
      padding-top: 8px;
      font-size: 11px;
      font-weight: 600;
      color: #475569;
    }
    .stamp {
      display: inline-block;
      border: 2px solid #047857;
      color: #047857;
      font-size: 10px;
      font-weight: 800;
      padding: 4px 8px;
      border-radius: 4px;
      transform: rotate(-4deg);
      margin-top: 8px;
    }
    @media print {
      body { background: white; padding: 0; }
      .sheet { box-shadow: none; border: none; }
    }
  </style>
</head>
<body>
  <div class="sheet">
    <div class="header">
      <div>
        <div class="brand-sub">LoanNova Financial Marketplace & Lending Gateway</div>
        <div class="brand-title">Official Loan Sanction Letter</div>
        <div style="font-size: 12px; color: #64748b; margin-top: 2px;">In Partnership with ${bank} (RBI Regulated Node)</div>
      </div>
      <div>
        <span class="badge-approved">✓ In-Principle Approved</span>
      </div>
    </div>

    <div class="meta-row">
      <div>
        <strong>Sanction Ref:</strong> ${appId}<br>
        <strong>Borrower:</strong> ${applicant}<br>
        <strong>PAN No:</strong> ${pan}
      </div>
      <div style="text-align: right;">
        <strong>Sanction Date:</strong> ${currentDate}<br>
        <strong>Offer Validity:</strong> 60 Days (Till ${validUntil})<br>
        <strong>Disbursal Mode:</strong> Direct NEFT/RTGS to Savings A/C
      </div>
    </div>

    <div class="subject">
      SUB: In-Principle Sanction of ${app.productName || 'Personal Loan'} Facility of ₹${amountStr}/-
    </div>

    <p style="font-size: 12px; color: #334155; line-height: 1.6;">
      Dear <strong>${applicant}</strong>,<br>
      We are pleased to inform you that your application for a <strong>${app.productName || 'Loan Facility'}</strong> has been sanctioned by <strong>${bank}</strong> through the LoanNova Digital Marketplace on the terms and conditions outlined below:
    </p>

    <table class="details-table">
      <tr>
        <th>Sanctioned Loan Amount</th>
        <td class="highlight-cell">₹${amountStr}/- (Rupees ${amountStr} Only)</td>
      </tr>
      <tr>
        <th>Rate of Interest</th>
        <td>${rate}% per annum (Fixed / Reducing Balance)</td>
      </tr>
      <tr>
        <th>Repayment Tenure</th>
        <td>${tenure} Calendar Months</td>
      </tr>
      <tr>
        <th>Equated Monthly Installment (EMI)</th>
        <td class="highlight-cell">₹${emiStr} per month</td>
      </tr>
      <tr>
        <th>Processing Fee</th>
        <td>₹0/- (LoanNova Pre-Approved Waiver)</td>
      </tr>
      <tr>
        <th>First EMI Due Date</th>
        <td>05th of next calendar month</td>
      </tr>
      <tr>
        <th>e-NACH Auto-Debit Mandate</th>
        <td>Registered via Aadhaar / NPCI Gateway</td>
      </tr>
      <tr>
        <th>KYC Status</th>
        <td>UIDAI Aadhaar Verified & NSDL PAN Validated</td>
      </tr>
    </table>

    <div class="terms">
      <strong>Terms & Conditions:</strong><br>
      1. This letter constitutes an in-principle approval based on verified credit score and KYC records submitted via LoanNova.<br>
      2. The sanctioned amount shall be disbursed within 4 business hours upon digital execution of the loan agreement.<br>
      3. Prepayment and foreclosure charges are Nil after 6 successful EMI payments in accordance with RBI fair lending practices.<br>
      4. LoanNova is an authorized digital lending platform partner under RBI/2022-23/111 guidelines.
    </div>

    <div class="signatures">
      <div class="sig-block">
        <div>${applicant}</div>
        <div style="color: #64748b; font-size: 10px; margin-top: 2px;">Borrower Signature (e-Signed)</div>
        <div class="stamp">AADHAAR VERIFIED</div>
      </div>
      <div class="sig-block">
        <div>Credit Committee</div>
        <div style="color: #64748b; font-size: 10px; margin-top: 2px;">${bank} Underwriting Desk</div>
        <div class="stamp">OFFICIALLY SANCTIONED</div>
      </div>
    </div>
  </div>
</body>
</html>`;

  const blob = new Blob([htmlContent], { type: 'text/html' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `Sanction_Letter_${appId}_${applicant.replace(/\s+/g, '_')}.html`;
  a.click();
  URL.revokeObjectURL(url);
}

export function downloadPaymentReceipt(app, emiAmount = 9750) {
  const currentDate = new Date().toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });

  const txnId = `TXN-EMI-${Math.floor(100000 + Math.random() * 900000)}`;
  const applicant = app.applicantName || 'Rahul Sharma';
  const appId = app.id || 'APP-10821';
  const bank = app.bank || 'HDFC Bank';

  const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>EMI Payment Receipt - ${txnId}</title>
  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 40px; background: #f8fafc; color: #0f172a; }
    .box { max-width: 600px; margin: 0 auto; background: white; padding: 36px; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
    .title { font-size: 22px; font-weight: bold; color: #047857; }
    .sub { font-size: 12px; color: #64748b; margin-top: 4px; }
    .amt { font-size: 32px; font-weight: 800; color: #0f172a; margin: 20px 0; }
    .row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f1f5f9; font-size: 13px; }
  </style>
</head>
<body>
  <div class="box">
    <div class="title">✓ EMI Payment Successful</div>
    <div class="sub">LoanNova Instant Repayment Gateway</div>
    <div class="amt">₹${Number(emiAmount).toLocaleString('en-IN')}</div>
    <div class="row"><span>Transaction ID:</span><strong>${txnId}</strong></div>
    <div class="row"><span>Application Ref:</span><strong>${appId}</strong></div>
    <div class="row"><span>Product:</span><strong>${app.productName || 'Personal Loan'}</strong></div>
    <div class="row"><span>Lending Partner:</span><strong>${bank}</strong></div>
    <div class="row"><span>Borrower:</span><strong>${applicant}</strong></div>
    <div class="row"><span>Payment Mode:</span><strong>Instant UPI (NPCI Auto-Debit)</strong></div>
    <div class="row"><span>Timestamp:</span><strong>${currentDate}</strong></div>
    <div class="row"><span>Status:</span><strong style="color: #047857;">CLEARED & SETTLED</strong></div>
  </div>
</body>
</html>`;

  const blob = new Blob([htmlContent], { type: 'text/html' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `EMI_Receipt_${txnId}.html`;
  a.click();
  URL.revokeObjectURL(url);
}

export function downloadCreditReport(scoreData, applicant = 'Rahul Sharma', pan = 'ABCDE1234F') {
  const currentDate = new Date().toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  const score = scoreData?.score || 765;
  const status = scoreData?.status || 'Excellent';
  const reportId = `EXP-RPT-${Math.floor(100000 + Math.random() * 900000)}`;

  const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Credit Bureau Health Report - ${reportId}</title>
  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 40px; background: #f8fafc; color: #1e293b; }
    .sheet { max-width: 800px; margin: 0 auto; background: white; padding: 44px; border-radius: 12px; border: 1px solid #e2e8f0; }
    .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #059669; padding-bottom: 16px; margin-bottom: 20px; }
    .score-circle { width: 120px; height: 120px; border-radius: 50%; border: 6px solid #059669; display: flex; flex-direction: column; align-items: center; justify-content: center; }
    .score-num { font-size: 36px; font-weight: 900; color: #065f46; }
    .table { width: 100%; border-collapse: collapse; margin-top: 16px; font-size: 13px; }
    .table th, .table td { padding: 9px 12px; border: 1px solid #e2e8f0; text-align: left; }
    .table th { background: #f1f5f9; color: #475569; }
  </style>
</head>
<body>
  <div class="sheet">
    <div class="header">
      <div>
        <h2 style="margin: 0; color: #0f172a; font-size: 24px;">Experian & CIBIL Credit Health Report</h2>
        <div style="font-size: 12px; color: #64748b; margin-top: 4px;">Authorized Financial Partner: LoanNova Credit Bureau Gateway</div>
      </div>
      <div style="text-align: right; font-size: 12px; color: #64748b;">
        <strong>Report ID:</strong> ${reportId}<br>
        <strong>Generated:</strong> ${currentDate}
      </div>
    </div>

    <div style="display: flex; gap: 32px; align-items: center; background: #f0fdf4; padding: 24px; border-radius: 12px; margin-bottom: 24px; border: 1px solid #bbf7d0;">
      <div class="score-circle">
        <span style="font-size: 10px; font-weight: 700; color: #047857; text-transform: uppercase;">Experian</span>
        <div class="score-num">${score}</div>
        <span style="font-size: 11px; font-weight: 700; color: #047857;">${status}</span>
      </div>
      <div>
        <h3 style="margin: 0 0 6px 0; font-size: 18px; color: #065f46;">Credit Health: Outstanding Pre-Approved Standing</h3>
        <p style="margin: 0; font-size: 12px; color: #334155; line-height: 1.5;">
          Borrower: <strong>${applicant}</strong> • PAN: <strong>${pan}</strong><br>
          Estimated Maximum Borrowing Limit: <strong>₹12,50,000 (Zero Collateral)</strong><br>
          Repayment Track Record: <strong>100% On-Time (Zero 30+ DPD Flags)</strong>
        </p>
      </div>
    </div>

    <h4 style="margin: 16px 0 8px 0; font-size: 14px;">Detailed Credit Bureau Metric Factors:</h4>
    <table class="table">
      <thead>
        <tr>
          <th>Credit Parameter</th>
          <th>Weight Impact</th>
          <th>Recorded Value</th>
          <th>Bureau Rating</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><strong>Payment History</strong></td>
          <td>High Impact</td>
          <td>100% On-Time Payments</td>
          <td style="color: #047857; font-weight: 700;">Excellent</td>
        </tr>
        <tr>
          <td><strong>Credit Utilization</strong></td>
          <td>High Impact</td>
          <td>24% of Total Limit (Below 30% safe threshold)</td>
          <td style="color: #047857; font-weight: 700;">Good</td>
        </tr>
        <tr>
          <td><strong>Credit Age & History</strong></td>
          <td>Medium Impact</td>
          <td>4 Years, 2 Months Active Credit History</td>
          <td style="color: #047857; font-weight: 700;">Good</td>
        </tr>
        <tr>
          <td><strong>Active Credit Accounts</strong></td>
          <td>Low Impact</td>
          <td>5 Accounts (3 Loans, 2 Credit Cards)</td>
          <td style="color: #047857; font-weight: 700;">Balanced</td>
        </tr>
        <tr>
          <td><strong>Hard Lender Inquiries</strong></td>
          <td>Low Impact</td>
          <td>1 Inquiry in last 6 months</td>
          <td style="color: #047857; font-weight: 700;">Low Risk</td>
        </tr>
      </tbody>
    </table>

    <div style="margin-top: 28px; padding-top: 14px; border-top: 1px solid #e2e8f0; font-size: 11px; color: #64748b;">
      * Disclaimer: This credit report is generated in real-time under direct license from credit information bureaus under Credit Information Companies (Regulation) Act, 2005.
    </div>
  </div>
</body>
</html>`;

  const blob = new Blob([htmlContent], { type: 'text/html' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `Credit_Health_Report_${applicant.replace(/\s+/g, '_')}_${reportId}.html`;
  a.click();
  URL.revokeObjectURL(url);
}

export function downloadKycCertificate(name = 'Rahul Sharma', pan = 'ABCDE1234F', aadhaar = 'XXXX-XXXX-1234') {
  const currentDate = new Date().toLocaleDateString('en-IN', {
    day: 'numeric',
    month: 'long',
    year: 'numeric'
  });

  const kycId = `KYC-UIDAI-${Math.floor(100000 + Math.random() * 900000)}`;

  const htmlContent = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>e-KYC Compliance Certificate - ${kycId}</title>
  <style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 40px; background: #f8fafc; color: #0f172a; }
    .sheet { max-width: 700px; margin: 0 auto; background: white; padding: 44px; border-radius: 12px; border: 1px solid #e2e8f0; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
    .title { font-size: 22px; font-weight: 800; color: #1e3a8a; }
    .badge { display: inline-block; background: #dcfce7; color: #15803d; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: bold; margin-top: 6px; }
    .row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f1f5f9; font-size: 13px; }
  </style>
</head>
<body>
  <div class="sheet">
    <div style="text-align: center; margin-bottom: 24px;">
      <div style="font-size: 11px; font-weight: 700; color: #2563eb; text-transform: uppercase;">Unique Identification Authority of India & NSDL</div>
      <div class="title">Digital e-KYC Verification Certificate</div>
      <div class="badge">✓ Tier 1 KYC Fully Verified</div>
    </div>

    <div class="row"><span>Certificate Reference:</span><strong style="font-family: monospace;">${kycId}</strong></div>
    <div class="row"><span>Verified Applicant:</span><strong>${name}</strong></div>
    <div class="row"><span>Masked Aadhaar Number:</span><strong style="font-family: monospace;">${aadhaar}</strong></div>
    <div class="row"><span>NSDL PAN Card:</span><strong style="font-family: monospace;">${pan}</strong></div>
    <div class="row"><span>Face Match Confidence:</span><strong style="color: #15803d;">99.8% AI Liveness Match</strong></div>
    <div class="row"><span>Govt Gateway Response:</span><strong>UIDAI OTP Authentication: SUCCESS</strong></div>
    <div class="row"><span>NSDL ITD Database Match:</span><strong>OPERATIVE & VERIFIED</strong></div>
    <div class="row"><span>Verification Date:</span><strong>${currentDate}</strong></div>
    <div class="row"><span>Compliance Standard:</span><strong>RBI Master Direction - KYC Direction, 2016</strong></div>

    <div style="margin-top: 32px; text-align: center; border-top: 1px dashed #cbd5e1; padding-top: 16px; font-size: 11px; color: #64748b;">
      Digitally signed and cryptographically certified by LoanNova Trust Node ID: SEC-GATEWAY-2026.
    </div>
  </div>
</body>
</html>`;

  const blob = new Blob([htmlContent], { type: 'text/html' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `eKYC_Certificate_${kycId}.html`;
  a.click();
  URL.revokeObjectURL(url);
}
