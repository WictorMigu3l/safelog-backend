require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  host:     process.env.DB_HOST,
  port:     process.env.DB_PORT,
  database: process.env.DB_NAME,
  user:     process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl:      { rejectUnauthorized: false }
});

async function migrate() {
  const client = await pool.connect();
  try {
    console.log('🗄 Criando tabelas...');

    await client.query(`
      CREATE TABLE IF NOT EXISTS eventos (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        timestamp TIMESTAMPTZ DEFAULT NOW(),
        setor VARCHAR(50),
        tipo VARCHAR(100),
        gravidade VARCHAR(20),
        descricao TEXT,
        camera_id VARCHAR(20),
        confianca FLOAT,
        notificado BOOLEAN DEFAULT false,
        created_at TIMESTAMPTZ DEFAULT NOW()
      );
    `);
    console.log('✅ Tabela eventos criada');

    await client.query(`
      CREATE TABLE IF NOT EXISTS notificacoes (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        evento_id UUID REFERENCES eventos(id),
        canal VARCHAR(20),
        destinatario VARCHAR(100),
        status VARCHAR(20) DEFAULT 'pendente',
        erro TEXT,
        enviado_em TIMESTAMPTZ DEFAULT NOW()
      );
    `);
    console.log('✅ Tabela notificacoes criada');

    await client.query(`
      CREATE TABLE IF NOT EXISTS previsoes (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        setor VARCHAR(50),
        risco_pct FLOAT,
        fatores JSONB,
        horario_base TIME,
        modelo_versao VARCHAR(20),
        created_at TIMESTAMPTZ DEFAULT NOW()
      );
    `);
    console.log('✅ Tabela previsoes criada');

    console.log('🎉 Banco de dados pronto!');
  } finally {
    client.release();
    await pool.end();
  }
}

migrate().catch(err => { console.error('❌ Erro:', err.message); process.exit(1); });
