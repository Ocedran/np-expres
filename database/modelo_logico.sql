CREATE DATABASE IF NOT EXISTS np_expres;
USE np_expres;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profissional (
    id_profissional INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    especialidade VARCHAR(100),
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    duracao_minutos INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_servico_duracao CHECK (duracao_minutos > 0),
    CONSTRAINT ck_servico_preco CHECK (preco >= 0)
);

CREATE TABLE disponibilidade (
    id_disponibilidade INT AUTO_INCREMENT PRIMARY KEY,
    id_profissional INT NOT NULL,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim DATETIME NOT NULL,
    status ENUM('disponivel', 'reservado', 'bloqueado') NOT NULL DEFAULT 'disponivel',
    CONSTRAINT fk_disponibilidade_profissional
        FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional),
    CONSTRAINT ck_disponibilidade_periodo
        CHECK (data_hora_fim > data_hora_inicio),
    CONSTRAINT uq_profissional_horario
        UNIQUE (id_profissional, data_hora_inicio, data_hora_fim)
);

CREATE TABLE agendamento (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_profissional INT NOT NULL,
    id_servico INT NOT NULL,
    id_disponibilidade INT NOT NULL UNIQUE,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('confirmado', 'concluido', 'cancelado', 'nao_compareceu') NOT NULL DEFAULT 'confirmado',
    observacao VARCHAR(255),
    CONSTRAINT fk_agendamento_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_agendamento_profissional
        FOREIGN KEY (id_profissional) REFERENCES profissional(id_profissional),
    CONSTRAINT fk_agendamento_servico
        FOREIGN KEY (id_servico) REFERENCES servico(id_servico),
    CONSTRAINT fk_agendamento_disponibilidade
        FOREIGN KEY (id_disponibilidade) REFERENCES disponibilidade(id_disponibilidade)
);

CREATE INDEX idx_agendamento_cliente ON agendamento(id_cliente);
CREATE INDEX idx_agendamento_profissional ON agendamento(id_profissional);
CREATE INDEX idx_agendamento_data ON disponibilidade(data_hora_inicio);

-- Dados de teste
INSERT INTO profissional (nome, especialidade, telefone)
VALUES ('Nicolas', 'Barbeiro', '(44) 99999-0000');

INSERT INTO servico (nome, descricao, duracao_minutos, preco)
VALUES ('Corte masculino', 'Corte tradicional ou moderno', 45, 35.00);

INSERT INTO cliente (nome, telefone, email)
VALUES ('Cliente de teste', '(44) 98888-0000', 'cliente@teste.com');
