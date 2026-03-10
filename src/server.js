require('dotenv').config();
const express = require('express');
const cors = require('cors');
const http = require('http');
const app = express();
const server = http.createServer(app);
const PORT = process.env.PORT || 3001;
app.use(cors());
app.use(express.json());
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', servico: 'SafeLog AI Backend', version: '1.0.0' });
});
server.listen(PORT, () => console.log(`🚀 SafeLog AI rodando na porta ${PORT}`));
