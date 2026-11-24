const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const rateLimit = require('express-rate-limit');
const { CORS_ORIGINS, NODE_ENV } = require('./config/env');
const errorHandler = require('./middleware/errorHandler');

const app = express();

// ── Security headers ─────────────────────────────────────────────────────────
app.use(helmet());

// ── CORS — allow web app + Flutter (mobile ignores CORS but good practice) ───
app.use(cors({
  origin: (origin, cb) => {
    // Allow requests with no origin (mobile apps, curl, Postman)
    if (!origin) return cb(null, true);
    if (CORS_ORIGINS.includes('*') || CORS_ORIGINS.includes(origin)) return cb(null, true);
    cb(new Error(`CORS: origin ${origin} not allowed`));
  },
  credentials: true,
}));

// ── Body parsing ─────────────────────────────────────────────────────────────
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true }));

// ── Rate limiting (100 req / 15 min per IP) ───────────────────────────────────
const limiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 100, standardHeaders: true, legacyHeaders: false });
app.use('/api', limiter);

// ── Routes ────────────────────────────────────────────────────────────────────
app.use('/api/health',        require('./routes/health'));
app.use('/api/auth',          require('./routes/auth'));
app.use('/api/users',         require('./routes/users'));
app.use('/api/products',      require('./routes/products'));
app.use('/api/loans',         require('./routes/products'));   // Flutter alias
app.use('/api/applications',  require('./routes/applications'));
app.use('/api/repayments',    require('./routes/repayments'));
app.use('/api/notifications', require('./routes/notifications'));
app.use('/api/dashboard',     require('./routes/dashboard'));
app.use('/api/credit-score',  require('./routes/creditScore'));
app.use('/api/kyc',           require('./routes/kyc'));
app.use('/api/chat',          require('./routes/chat'));
app.use('/api/referrals',     require('./routes/referrals'));

// ── 404 ───────────────────────────────────────────────────────────────────────
app.use((req, res) => res.status(404).json({ message: `Route ${req.method} ${req.path} not found` }));

// ── Global error handler ─────────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;
