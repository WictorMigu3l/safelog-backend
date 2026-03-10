const axios = require('axios');

async function enviarWhatsApp(mensagem) {
  const { ZAPI_INSTANCE_ID, ZAPI_TOKEN, ZAPI_PHONE } = process.env;
  if (!ZAPI_INSTANCE_ID || !ZAPI_TOKEN) return { ok: false, erro: 'Z-API não configurado' };
  const url = `https://api.z-api.io/instances/${ZAPI_INSTANCE_ID}/token/${ZAPI_TOKEN}/send-text`;
  const res = await axios.post(url, { phone: ZAPI_PHONE, message: mensagem });
  return { ok: true, data: res.data };
}

module.exports = { enviarWhatsApp };
