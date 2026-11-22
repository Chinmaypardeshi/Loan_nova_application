# LoanNova - AI-Powered Financial Marketplace & Credit Platform
*Version 1.0 | Full-Stack Enterprise Web Application*

LoanNova is a financial marketplace connecting consumers and businesses with leading banks and NBFCs for personal loans, home loans, business loans, credit cards, savings accounts, insurance, and investments with paperless KYC, real-time credit score tracking, and AI-powered recommendations.

---

## 🌐 Quick Start (Live Application)

The platform is running as a Full-Stack application (Node.js Express REST APIs + React 19 Frontend):

```bash
# Start Full-Stack Server
npm start
```
Open in browser: **[http://localhost:5000](http://localhost:5000)**

*(For Vite hot-reloading dev mode: `npm run dev` on port 3000)*

---

## 🔐 Google Login & Role-Based Access Control (RBAC)

The platform includes an interactive **Sign In / Account Switcher** accessible via the user avatar or **"Switch Account / Persona"**:

1. **Google Login ("Continue with Google")**:
   - Integrated OAuth 2.0 flow simulation.
   - Signs in the user securely (e.g. `Rahul Sharma`, `rahul.sharma@gmail.com`), sets the session token, and displays the "Google Linked" verified badge in the navbar.

2. **Multi-Role Personas**:
   - **Customer (Borrower)**: Discovers loans & cards, checks 765 credit score, submits paperless applications, and tracks approval stages in real-time.
   - **Bank Partner (HDFC Underwriting Desk)**: Reviews inbound loan applications, approves sanctions, and disburses loan amounts.
   - **Sales Agent (Relationship Manager)**: Accesses sales CRM, follow-up leads, calls clients, and tracks earned commissions.
   - **Super Admin (Operations & Compliance)**: Complete platform control, monitors 99.99% system health, reviews AI fraud detection, and audits compliance security logs.

---

## 📋 Enterprise Development Blueprint: Step-by-Step (Day 1 to Day 10)

Here is the complete engineering breakdown of what tools, libraries, and steps are required to build each phase of the LoanNova platform:

### **Day 1: System Architecture & Core Shell**
- **Requirements**: High-throughput API gateway, scalable microservices, containerization.
- **Tech Stack & Libraries**: Docker, Kubernetes, Nginx / Kong API Gateway, Node.js / Express, Redis (caching), PostgreSQL (ACID data storage).
- **Deliverables**: Setting up project repositories, environment configs, CORS, rate-limiting, and health check endpoints (`/api/health`).

### **Day 2: Authentication, Security & RBAC Profiles**
- **Requirements**: RBI compliant 2-Factor Authentication, Social SSO, and granular role management.
- **Tech Stack & Libraries**: Google OAuth 2.0 (`@react-oauth/google` / Passport.js), JWT (`jsonwebtoken`), Twilio / AWS SNS (SMS OTP), WebAuthn (Biometrics).
- **Deliverables**: Multi-method login modal, OTP validation logic, secure session storage, and role-based permissions (Customer, Bank Partner, Agent, Super Admin).

### **Day 3: Loan Marketplace & Comparison Engine**
- **Requirements**: 6+ loan categories (Personal, Home, Business, Gold, Vehicle, Education), sorting & filtering.
- **Tech Stack & Libraries**: RESTful filter APIs, Tailwind CSS responsive cards, Lucide Icons.
- **Deliverables**: Product catalog, interest rate filters, side-by-side comparison drawer, and 1-click application trigger.

### **Day 4: Credit Cards & High-Yield Accounts**
- **Requirements**: Reward points, cashback calculator, airport lounge perks, zero-balance bank accounts & high-yield FDs.
- **Tech Stack & Libraries**: Dynamic card graphic renderers, fee-waiver eligibility algorithms, DICGC insurance indicators.
- **Deliverables**: Curated card catalog, benefit breakdown, and 1-click instant account opening flow.

### **Day 5: Insurance & Wealth Investments**
- **Requirements**: Health, Term Life & Motor insurance with cashless hospital network; SIP mutual funds & 24K digital gold.
- **Tech Stack & Libraries**: Insurance aggregators, CAGR calculation algorithms, Gold price feed API mock.
- **Deliverables**: Cashless hospital coverage counters, claim settlement ratio metrics (99.5%), and direct SIP onboarding.

### **Day 6: Interactive Financial Calculators Suite**
- **Requirements**: Real-time reactive sliders for EMI, SIP, FD compound interest, and maximum borrowing eligibility (FOIR).
- **Tech Stack & Libraries**: Standard compound interest formulas, HTML5 range inputs with responsive state handlers.
- **Deliverables**: Real-time breakdown of Principal vs. Interest, tenure adjustment, and instant "Apply for this offer" pre-fill.

### **Day 7: Credit Score Bureau & Simulator**
- **Requirements**: Official credit bureau rating (300-900), key factor analysis, and what-if score simulator.
- **Tech Stack & Libraries**: Experian/CIBIL API schema mock, dynamic SVG meter / gauge, factor weight calculation.
- **Deliverables**: 5-factor breakdown (Payment history, credit utilization, inquiries), score simulator buttons (+/- points for actions), and improvement tips.

### **Day 8: Digital KYC & Document Management**
- **Requirements**: Paperless onboarding compliant with UIDAI & NSDL regulations, OCR document scanning, face liveness check.
- **Tech Stack & Libraries**: Tesseract.js / AWS Textract (OCR), Face-API / WebRTC camera capture (liveness test), AES-256 encrypted storage.
- **Deliverables**: Instant Aadhaar & PAN validation, anti-spoofing face match simulator, and document upload checklist with OCR confidence ratings.

### **Day 9: AI Financial Assistant & Referral Wallet**
- **Requirements**: 24/7 financial advisor chatbot, prompt suggestions, viral referral code generator, and cashback wallet.
- **Tech Stack & Libraries**: OpenAI API / local LLM integration, Web Speech API (voice prompts), Clipboard API.
- **Deliverables**: Nova AI assistant drawer with quick chips, unique referral link sharing, wallet coin balance, and UPI payout simulation.

### **Day 10: Unified Enterprise Platform & Admin Desk**
- **Requirements**: Borrower dashboard, bank underwriter decision portal, sales telecalling CRM, and super admin governance.
- **Tech Stack & Libraries**: Unified state orchestration, Canvas Confetti, audit logging system.
- **Deliverables**: 5-stage application tracker (*Submitted ➔ KYC ➔ Review ➔ Sanctioned ➔ Disbursed*), 1-click bank sanction approval & fund disbursal, and admin security logs.

---

## 🛠️ Tech Stack Summary
- **Frontend**: React 19, Tailwind CSS v4, Lucide Icons, Canvas Confetti
- **Backend**: Node.js, Express.js (REST APIs, CORS, Static SPA serving)
- **Security & Standards**: AES-256 vault architecture, RBI Fair Practice, PCI-DSS ready schema
- **Port**: 5000 (Full-Stack) / 3000 (Vite Dev Server)
