-- =============================================================================
-- LoanNova — Supabase PostgreSQL Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query → Run
-- =============================================================================

-- ── USERS ─────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS loannova_users (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(255) NOT NULL,
  email       VARCHAR(255) UNIQUE NOT NULL,
  phone       VARCHAR(20),
  password_hash VARCHAR(255) NOT NULL,
  role        VARCHAR(50)  DEFAULT 'customer',   -- customer | admin | partner | agent
  credit_score INT          DEFAULT 750,
  wallet_balance DECIMAL(12,2) DEFAULT 0.00,
  pan         VARCHAR(20),
  is_active   BOOLEAN      DEFAULT TRUE,
  created_at  TIMESTAMPTZ  DEFAULT NOW(),
  updated_at  TIMESTAMPTZ  DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ln_users_email ON loannova_users(email);

-- ── PRODUCTS (seeded from mock data) ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS loannova_products (
  id            VARCHAR(50) PRIMARY KEY,
  category      VARCHAR(50)  NOT NULL,   -- loans | cards | savings | insurance | investments
  sub_type      VARCHAR(100),
  name          VARCHAR(255) NOT NULL,
  bank          VARCHAR(255),
  tag           VARCHAR(255),
  interest_rate DECIMAL(6,2),
  min_amount    DECIMAL(15,2),
  max_amount    DECIMAL(15,2),
  min_tenure    INT,
  max_tenure    INT,
  processing_fee VARCHAR(100),
  annual_fee    DECIMAL(10,2),
  rating        DECIMAL(3,1) DEFAULT 4.5,
  reviews_count INT          DEFAULT 0,
  features      JSONB        DEFAULT '[]',
  eligibility   TEXT,
  badge         VARCHAR(100),
  featured      BOOLEAN      DEFAULT FALSE,
  is_active     BOOLEAN      DEFAULT TRUE,
  created_at    TIMESTAMPTZ  DEFAULT NOW()
);

-- ── APPLICATIONS ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS loannova_applications (
  id              VARCHAR(50) PRIMARY KEY,
  user_id         INT  REFERENCES loannova_users(id) ON DELETE CASCADE,
  product_id      VARCHAR(50) REFERENCES loannova_products(id) ON DELETE SET NULL,
  product_name    VARCHAR(255),
  type            VARCHAR(100),
  bank            VARCHAR(255),
  amount          DECIMAL(15,2),
  tenure          INT,
  interest_rate   DECIMAL(6,2),
  emi             DECIMAL(12,2),
  applicant_name  VARCHAR(255),
  phone           VARCHAR(20),
  email           VARCHAR(255),
  pan             VARCHAR(20),
  employment      VARCHAR(100),
  monthly_income  VARCHAR(100),
  kyc_status      VARCHAR(50)  DEFAULT 'Pending',
  status          VARCHAR(50)  DEFAULT 'Under Review',
  stage           INT          DEFAULT 1,
  applied_date    TIMESTAMPTZ  DEFAULT NOW(),
  created_at      TIMESTAMPTZ  DEFAULT NOW(),
  updated_at      TIMESTAMPTZ  DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ln_apps_user ON loannova_applications(user_id);

-- ── REPAYMENTS ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS loannova_repayments (
  id                 SERIAL PRIMARY KEY,
  application_id     VARCHAR(50) REFERENCES loannova_applications(id) ON DELETE CASCADE,
  installment_number INT,
  due_date           DATE        NOT NULL,
  amount             DECIMAL(12,2) NOT NULL,
  principal          DECIMAL(12,2),
  interest           DECIMAL(12,2),
  status             VARCHAR(20)  DEFAULT 'pending',  -- pending | paid | overdue
  paid_date          TIMESTAMPTZ,
  payment_reference  VARCHAR(100),
  created_at         TIMESTAMPTZ  DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ln_repayments_app ON loannova_repayments(application_id);

-- ── NOTIFICATIONS ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS loannova_notifications (
  id         SERIAL PRIMARY KEY,
  user_id    INT  REFERENCES loannova_users(id) ON DELETE CASCADE,
  title      VARCHAR(255) NOT NULL,
  message    TEXT,
  type       VARCHAR(50)  DEFAULT 'info',   -- info | success | warning | alert
  is_read    BOOLEAN      DEFAULT FALSE,
  created_at TIMESTAMPTZ  DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_ln_notif_user ON loannova_notifications(user_id);
