const router = require('express').Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const pool = require('../config/db');
const { JWT_SECRET, JWT_EXPIRES_IN } = require('../config/env');

// ── POST /api/auth/register ─────────────────────────────────────────────────
router.post('/register', async (req, res, next) => {
  try {
    const { name, email, phone, password } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'name, email and password are required' });
    }
    if (password.length < 6) {
      return res.status(400).json({ message: 'Password must be at least 6 characters' });
    }

    const existing = await pool.query(
      'SELECT id FROM loannova_users WHERE email = $1', [email.toLowerCase()]
    );
    if (existing.rows.length > 0) {
      return res.status(409).json({ message: 'An account with this email already exists' });
    }

    const hash = await bcrypt.hash(password, 12);
    const result = await pool.query(
      `INSERT INTO loannova_users (name, email, phone, password_hash)
       VALUES ($1, $2, $3, $4) RETURNING id, name, email, role, created_at`,
      [name.trim(), email.toLowerCase().trim(), phone || null, hash]
    );
    const user = result.rows[0];

    // Welcome notification
    await pool.query(
      `INSERT INTO loannova_notifications (user_id, title, message, type)
       VALUES ($1, $2, $3, 'success')`,
      [user.id, 'Welcome to LoanNova! 🎉', `Hi ${user.name}, your account is ready. Explore loans, cards, insurance and more.`]
    );

    res.status(201).json({ message: 'Account created successfully', userId: user.id, name: user.name, email: user.email });
  } catch (err) {
    next(err);
  }
});

// ── POST /api/auth/login ────────────────────────────────────────────────────
router.post('/login', async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: 'email and password are required' });
    }

    const result = await pool.query(
      'SELECT * FROM loannova_users WHERE email = $1 AND is_active = TRUE',
      [email.toLowerCase().trim()]
    );
    if (result.rows.length === 0) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const user = result.rows[0];
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const token = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: JWT_EXPIRES_IN }
    );

    res.json({
      token,
      userId: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      creditScore: user.credit_score,
    });
  } catch (err) {
    next(err);
  }
});

module.exports = router;
