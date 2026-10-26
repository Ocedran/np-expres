PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    telefone TEXT NOT NULL,
    email TEXT,
    data_cadastro TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS profissionais (
    id_profissional INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    especialidade TEXT,
    telefone TEXT,
    ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS servicos (
    id_servico INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    descricao TEXT,
    duracao_minutos INTEGER NOT NULL CHECK (duracao_minutos > 0),
    preco NUMERIC NOT NULL CHECK (preco >= 0),
    ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS disponibilidades (
    id_disponibilidade INTEGER PRIMARY KEY AUTOINCREMENT,
    id_profissional INTEGER NOT NULL,
    data_hora_inicio TEXT NOT NULL,
    data_hora_fim TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'disponivel' CHECK (status IN ('disponivel', 'reservado', 'bloqueado')),
    FOREIGN KEY (id_profissional) REFERENCES profissionais(id_profissional) ON DELETE RESTRICT,
    UNIQUE (id_profissional, data_hora_inicio, data_hora_fim),
    CHECK (data_hora_fim > data_hora_inicio)
);

CREATE TABLE IF NOT EXISTS agendamentos (
    id_agendamento INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    id_profissional INTEGER NOT NULL,
    id_servico INTEGER NOT NULL,
    id_disponibilidade INTEGER NOT NULL UNIQUE,
    data_criacao TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL DEFAULT 'confirmado' CHECK (status IN ('confirmado', 'concluido', 'cancelado', 'nao_compareceu')),
    observacao TEXT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_profissional) REFERENCES profissionais(id_profissional) ON DELETE RESTRICT,
    FOREIGN KEY (id_servico) REFERENCES servicos(id_servico) ON DELETE RESTRICT,
    FOREIGN KEY (id_disponibilidade) REFERENCES disponibilidades(id_disponibilidade) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_disponibilidades_data ON disponibilidades(data_hora_inicio);
CREATE INDEX IF NOT EXISTS idx_agendamentos_cliente ON agendamentos(id_cliente);
CREATE INDEX IF NOT EXISTS idx_agendamentos_profissional ON agendamentos(id_profissional);

INSERT INTO profissionais (nome, especialidade, telefone)
SELECT 'Nicolas', 'Barbeiro', '(44) 99999-0000'
WHERE NOT EXISTS (SELECT 1 FROM profissionais);

INSERT INTO servicos (nome, descricao, duracao_minutos, preco)
SELECT 'Corte masculino', 'Corte tradicional ou moderno', 45, 35.00
WHERE NOT EXISTS (SELECT 1 FROM servicos);
