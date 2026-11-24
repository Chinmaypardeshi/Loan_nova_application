const router = require('express').Router();
const pool = require('../config/db');
const authenticate = require('../middleware/auth');

// ── GET /api/products  (web — with filter/search/sort) ──────────────────────
// ── GET /api/loans     (Flutter — same handler, aliased in app.js) ──────────
router.get('/', async (req, res, next) => {
  try {
    const { category, subType, bank, search, sort } = req.query;
    let where = ['is_active = TRUE'];
    const params = [];

    if (category && category !== 'all') {
      params.push(category.toLowerCase());
      where.push(`category = $${params.length}`);
    }
    if (subType && subType !== 'all') {
      params.push(subType.toLowerCase());
      where.push(`LOWER(sub_type) = $${params.length}`);
    }
    if (bank && bank !== 'all') {
      params.push(`%${bank.toLowerCase()}%`);
      where.push(`LOWER(bank) LIKE $${params.length}`);
    }
    if (search) {
      params.push(`%${search.toLowerCase()}%`);
      const idx = params.length;
      where.push(`(LOWER(name) LIKE $${idx} OR LOWER(bank) LIKE $${idx} OR LOWER(sub_type) LIKE $${idx} OR LOWER(tag) LIKE $${idx})`);
    }

    const whereClause = where.length ? `WHERE ${where.join(' AND ')}` : '';
    let orderClause = 'ORDER BY featured DESC, reviews_count DESC';
    if (sort === 'rate-low') orderClause = 'ORDER BY interest_rate ASC NULLS LAST';
    if (sort === 'rating-high') orderClause = 'ORDER BY rating DESC';

    const result = await pool.query(
      `SELECT * FROM loannova_products ${whereClause} ${orderClause}`,
      params
    );
    res.json({ count: result.rows.length, products: result.rows });
  } catch (err) { next(err); }
});

// ── GET /api/products/:id ────────────────────────────────────────────────────
router.get('/:id', async (req, res, next) => {
  try {
    const result = await pool.query('SELECT * FROM loannova_products WHERE id = $1', [req.params.id]);
    if (!result.rows.length) return res.status(404).json({ message: 'Product not found' });
    res.json(result.rows[0]);
  } catch (err) { next(err); }
});

// ── POST /api/products (admin/partner) ──────────────────────────────────────
router.post('/', authenticate, async (req, res, next) => {
  try {
    const p = req.body;
    const id = p.id || `prod-${Date.now()}`;
    await pool.query(
      `INSERT INTO loannova_products
         (id, category, sub_type, name, bank, tag, interest_rate, min_amount, max_amount,
          min_tenure, max_tenure, processing_fee, annual_fee, rating, reviews_count, features, eligibility, featured)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18)
       ON CONFLICT (id) DO NOTHING`,
      [id, p.category, p.subType || p.sub_type, p.name, p.bank, p.tag,
       p.interestRate || p.interest_rate, p.minAmount || p.min_amount, p.maxAmount || p.max_amount,
       p.minTenure || p.min_tenure, p.maxTenure || p.max_tenure, p.processingFee || p.processing_fee,
       p.annualFee || p.annual_fee, p.rating || 4.5, p.reviewsCount || p.reviews_count || 0,
       JSON.stringify(p.features || []), p.eligibility, p.featured || false]
    );
    res.status(201).json({ success: true, id });
  } catch (err) { next(err); }
});

module.exports = router;
