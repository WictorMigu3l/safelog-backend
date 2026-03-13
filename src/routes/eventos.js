const express = require('express');
const router = express.Router();
const pool = require('../config/database');

router.get('/', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM eventos ORDER BY timestamp DESC LIMIT 100');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

router.get('/stats', async (req, res) => {
  try {
    const total = await pool.query('SELECT COUNT(*) FROM eventos');
    const criticos = await pool.query("SELECT COUNT(*) FROM eventos WHERE gravidade IN ('critical','high')");
    const porSetor = await pool.query('SELECT setor, COUNT(*) as total FROM eventos GROUP BY setor ORDER BY total DESC LIMIT 10');
    const porTipo = await pool.query('SELECT tipo, COUNT(*) as total FROM eventos GROUP BY tipo ORDER BY total DESC');
    res.json({ total: parseInt(total.rows[0].count), criticos: parseInt(criticos.rows[0].count), por_setor: porSetor.rows, por_tipo: porTipo.rows });
  } catch (err) {
    res.status(500).json({ erro: err.message });
  }
});

module.exports = router;