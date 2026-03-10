const express = require('express');
const router = express.Router();
const { enviarWhatsApp } = require('../services/notificacao');

router.post('/teste', async (req, res) => {
  try {
    const resultado = await enviarWhatsApp('✅ *SafeLog AI* — Teste de notificação funcionando!');
    res.json({ success: true, data: resultado });
  } catch (err) {
    res.json({ success: false, error: err.message });
  }
});

module.exports = router;
