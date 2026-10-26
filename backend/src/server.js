const fs = require('node:fs');
const path = require('node:path');
const express = require('express');
const cors = require('cors');
const Database = require('better-sqlite3');

const app = express();
const PORT = process.env.PORT || 3000;
const root = path.resolve(__dirname, '..', '..');
const dbPath = process.env.DB_PATH || path.join(__dirname, '..', 'np-expres.sqlite');
const schemaPath = path.join(root, 'database', 'schema.sql');
const db = new Database(dbPath);
db.pragma('foreign_keys = ON');
db.exec(fs.readFileSync(schemaPath, 'utf8'));

app.use(cors());
app.use(express.json());

const resources = {
  clientes: { table: 'clientes', id: 'id_cliente', fields: ['nome', 'telefone', 'email'] },
  profissionais: { table: 'profissionais', id: 'id_profissional', fields: ['nome', 'especialidade', 'telefone', 'ativo'] },
  servicos: { table: 'servicos', id: 'id_servico', fields: ['nome', 'descricao', 'duracao_minutos', 'preco', 'ativo'] },
  disponibilidades: { table: 'disponibilidades', id: 'id_disponibilidade', fields: ['id_profissional', 'data_hora_inicio', 'data_hora_fim', 'status'] },
  agendamentos: { table: 'agendamentos', id: 'id_agendamento', fields: ['id_cliente', 'id_profissional', 'id_servico', 'id_disponibilidade', 'status', 'observacao'] }
};

function validFields(resource, body, partial = false) {
  const values = {};
  for (const field of resource.fields) {
    if (body[field] !== undefined) values[field] = body[field];
  }
  if (!partial) {
    const missing = resource.fields.filter((field) => body[field] === undefined && !['email', 'descricao', 'especialidade', 'telefone', 'ativo', 'status', 'observacao'].includes(field));
    if (missing.length) throw new Error(`Campos obrigatórios ausentes: ${missing.join(', ')}`);
  }
  return values;
}

function registerCrud(name, resource) {
  const base = `/api/${name}`;
  app.get(base, (req, res) => {
    const rows = db.prepare(`SELECT * FROM ${resource.table} ORDER BY ${resource.id} DESC`).all();
    res.json(rows);
  });

  app.get(`${base}/:id`, (req, res) => {
    const row = db.prepare(`SELECT * FROM ${resource.table} WHERE ${resource.id} = ?`).get(Number(req.params.id));
    if (!row) return res.status(404).json({ erro: 'Registro não encontrado' });
    res.json(row);
  });

  app.post(base, (req, res) => {
    try {
      const values = validFields(resource, req.body);
      const fields = Object.keys(values);
      const result = db.prepare(`INSERT INTO ${resource.table} (${fields.join(', ')}) VALUES (${fields.map(() => '?').join(', ')})`).run(...fields.map((field) => values[field]));
      const created = db.prepare(`SELECT * FROM ${resource.table} WHERE ${resource.id} = ?`).get(result.lastInsertRowid);
      res.status(201).json(created);
    } catch (error) {
      res.status(400).json({ erro: error.message });
    }
  });

  app.put(`${base}/:id`, (req, res) => {
    try {
      const values = validFields(resource, req.body, true);
      const fields = Object.keys(values);
      if (!fields.length) return res.status(400).json({ erro: 'Nenhum campo para atualizar' });
      const result = db.prepare(`UPDATE ${resource.table} SET ${fields.map((field) => `${field} = ?`).join(', ')} WHERE ${resource.id} = ?`).run(...fields.map((field) => values[field]), Number(req.params.id));
      if (!result.changes) return res.status(404).json({ erro: 'Registro não encontrado' });
      res.json(db.prepare(`SELECT * FROM ${resource.table} WHERE ${resource.id} = ?`).get(Number(req.params.id)));
    } catch (error) {
      res.status(400).json({ erro: error.message });
    }
  });

  app.delete(`${base}/:id`, (req, res) => {
    try {
      const result = db.prepare(`DELETE FROM ${resource.table} WHERE ${resource.id} = ?`).run(Number(req.params.id));
      if (!result.changes) return res.status(404).json({ erro: 'Registro não encontrado' });
      res.status(204).send();
    } catch (error) {
      res.status(409).json({ erro: 'Não foi possível excluir: o registro pode estar sendo utilizado.' });
    }
  });
}

Object.entries(resources).forEach(([name, resource]) => registerCrud(name, resource));

app.get('/api', (req, res) => {
  res.json({
    projeto: 'NP Expres',
    versao: '1.0.0',
    recursos: Object.keys(resources).map((name) => ({
      recurso: name,
      rotas: [`GET/POST /api/${name}`, `GET/PUT/DELETE /api/${name}/:id`]
    }))
  });
});

app.get('/api/health', (req, res) => res.json({ status: 'ok', projeto: 'NP Expres' }));

app.use((error, req, res, next) => {
  res.status(500).json({ erro: 'Erro interno do servidor' });
});

app.listen(PORT, () => {
  console.log(`NP Expres API executando em http://localhost:${PORT}`);
});
