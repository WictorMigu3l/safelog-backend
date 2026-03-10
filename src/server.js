require('dotenv').config();
const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => res.json({ status: 'ok', servico: 'SafeLog AI Backend', version: '1.0.0' }));
app.use('/api/notificacoes', require('./routes/notificacoes'));

app.listen(PORT, () => console.log(`🚀 SafeLog AI rodando na porta ${PORT}`));
