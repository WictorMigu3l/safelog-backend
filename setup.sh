# 📦 SafeLog AI — Backend

Sistema de prevenção de acidentes para armazéns logísticos.

---

## 🗂 Estrutura do Projeto

```
safelog-backend/
├── src/
│   ├── server.js              ← Ponto de entrada principal
│   ├── config/
│   │   └── database.js        ← Conexão PostgreSQL
│   ├── routes/
│   │   ├── eventos.js         ← CRUD de incidentes
│   │   ├── alertas.js         ← Recebe detecções da IA
│   │   ├── setores.js         ← Score de risco por área
│   │   ├── notificacoes.js    ← Histórico de envios
│   │   ├── relatorios.js      ← Relatórios diário/mensal
│   │   └── previsao.js        ← Previsão de risco IA
│   └── services/
│       ├── websocket.js       ← Alertas em tempo real
│       ├── notificacao.js     ← WhatsApp + Email
│       └── scheduler.js       ← Tarefas agendadas
└── scripts/
    ├── migrate.js             ← Cria as tabelas no BD
    └── seed.js                ← Insere dados de exemplo
```

---

## 🚀 Como Rodar (Passo a Passo)

### 1. Instalar dependências

```bash
npm install
```

### 2. Configurar variáveis de ambiente

```bash
cp .env.example .env
# Edite o .env com suas credenciais
```

### 3. Instalar e iniciar o PostgreSQL

**Windows:** Baixe em https://www.postgresql.org/download/windows/

**Mac:**
```bash
brew install postgresql
brew services start postgresql
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

### 4. Criar o banco de dados

```bash
# Entre no PostgreSQL
psql -U postgres

# Dentro do psql:
CREATE DATABASE safelog;
\q
```

### 5. Criar as tabelas

```bash
node scripts/migrate.js
```

### 6. Popular com dados de exemplo (opcional)

```bash
node scripts/seed.js
```

### 7. Iniciar o servidor

```bash
# Produção
npm start

# Desenvolvimento (reinicia ao salvar arquivos)
npm run dev
```

Servidor rodando em: **http://localhost:3001**

---

## 📡 Endpoints da API

| Método | Rota | Descrição |
|--------|------|-----------|
| GET | `/health` | Status do servidor |
| GET | `/api/eventos` | Lista eventos (com filtros) |
| POST | `/api/eventos` | Registra novo evento |
| GET | `/api/eventos/stats` | Estatísticas para dashboard |
| POST | `/api/alertas` | **Recebe detecção da IA** |
| GET | `/api/alertas/ativos` | Alertas das últimas 2h |
| GET | `/api/setores/risco` | Score de risco por setor |
| GET | `/api/previsao` | Previsão próximas horas |
| GET | `/api/relatorios/diario` | Relatório do dia |
| GET | `/api/relatorios/mensal` | Relatório mensal |
| GET | `/api/notificacoes` | Histórico de envios |
| POST | `/api/notificacoes/teste` | Envia mensagem de teste |

---

## 📱 Configurar WhatsApp (Z-API)

1. Crie conta em https://z-api.io (tem plano gratuito para testes)
2. Crie uma instância e escaneie o QR code com seu WhatsApp
3. Copie o **Instance ID** e o **Token**
4. Cole no `.env`:
```env
ZAPI_INSTANCE_ID=sua_instance_id
ZAPI_TOKEN=seu_token
ZAPI_PHONE=5583999990000
```

---

## 📧 Configurar Email (Gmail)

1. Ative verificação em 2 etapas no Google
2. Vá em: Conta Google → Segurança → Senhas de app
3. Crie uma senha para "Mail"
4. Cole no `.env`:
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu@gmail.com
SMTP_PASS=xxxx xxxx xxxx xxxx    ← senha de app (16 chars)
EMAIL_TO=gestor@empresa.com
```

---

## 🤖 Integrar com IA (Python/YOLOv8)

Quando a câmera detectar algo, o script Python faz:

```python
import requests

requests.post("http://localhost:3001/api/alertas", json={
    "setor":     "Carga/Descarga",
    "tipo":      "Funcionário sem capacete",
    "gravidade": "critical",
    "camera_id": "CAM-01",
    "confianca": 94.5,
    "descricao": "Detectado às 14:32 — frame 1847"
})
```

O backend automaticamente:
- ✅ Salva no PostgreSQL
- ✅ Envia WhatsApp
- ✅ Envia E-mail
- ✅ Notifica o Dashboard via WebSocket

---

## 🔌 WebSocket no Dashboard

```javascript
const ws = new WebSocket('ws://localhost:3001');

ws.onmessage = (event) => {
  const { type, payload } = JSON.parse(event.data);

  if (type === 'NEW_ALERT') {
    mostrarAlerta(payload);    // exibe no dashboard
  }
  if (type === 'RISK_UPDATE') {
    atualizarHeatmap(payload); // atualiza mapa de calor
  }
  if (type === 'NOTIFICATION_SENT') {
    mostrarConfirmacao(payload); // ✅ WhatsApp/Email enviado
  }
};
```

---

## 🗓 Próximos Passos

- [ ] Adicionar autenticação JWT
- [ ] Integrar script Python com YOLOv8
- [ ] Deploy com Docker + Nginx
- [ ] App mobile com React Native
