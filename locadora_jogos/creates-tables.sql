-- Criação de tabelas, constraints e views

-- TABELAS
CREATE TABLE Funcionario(
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50) NOT NULL
);

CREATE TABLE Cliente(
    id_cliente SERIAL PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Plataforma(
    id_plataforma SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fabricante VARCHAR(50)
);

CREATE TABLE Jogo(
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_lancamento INTEGER,
    valor_diaria NUMERIC(10,2) NOT NULL,
    genero VARCHAR(50),
    id_plataforma INTEGER NOT NULL REFERENCES Plataforma(id_plataforma) ON DELETE RESTRICT
);

CREATE TABLE JogoFisico(
    id_jogo INTEGER PRIMARY KEY REFERENCES Jogo(id_jogo) ON DELETE CASCADE,
    estoque INTEGER NOT NULL CHECK (estoque >= 0)
);

CREATE TABLE JogoDigital(
    id_jogo INTEGER PRIMARY KEY REFERENCES Jogo(id_jogo) ON DELETE CASCADE,
    codigo_licenca VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Fornecedor(
    cnpj VARCHAR(18) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100)
);

CREATE TABLE Aluguel(
    id_aluguel SERIAL PRIMARY KEY,
    data_aluguel TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    data_devolucao TIMESTAMP,
    tempo_aluguel INTEGER,
    valor_total NUMERIC(10,2) DEFAULT 0.00,
    multa NUMERIC(10,2) DEFAULT 0.00,
    id_funcionario INTEGER NOT NULL REFERENCES Funcionario(id_funcionario) ON DELETE CASCADE,
    id_cliente INTEGER NOT NULL REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE Abastece(
    cnpj_fornecedor VARCHAR(18) REFERENCES Fornecedor(cnpj) ON DELETE CASCADE,
    id_jogo_fisico INTEGER REFERENCES JogoFisico(id_jogo) ON DELETE CASCADE,
    data_abastecimento DATE NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (cnpj_fornecedor, id_jogo_fisico, data_abastecimento)
);

CREATE TABLE Inclui(
    id_aluguel INTEGER NOT NULL REFERENCES Aluguel(id_aluguel) ON DELETE CASCADE,
    id_jogo INTEGER NOT NULL REFERENCES Jogo(id_jogo) ON DELETE RESTRICT,
    valor_unitario NUMERIC(10,2) NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    PRIMARY KEY (id_aluguel, id_jogo)
);

-- VIEWS
CREATE OR REPLACE VIEW vw_detalhes_aluguel AS
SELECT a.id_aluguel,
       a.data_aluguel,
       a.data_devolucao,
       c.nome        AS cliente,
       f.nome        AS funcionario,
       j.titulo      AS jogo,
       i.quantidade,
       i.valor_unitario,
       (i.quantidade * i.valor_unitario) AS subtotal
FROM Aluguel a
JOIN Cliente c      ON a.id_cliente = c.id_cliente
JOIN Funcionario f  ON a.id_funcionario = f.id_funcionario
JOIN Inclui i       ON i.id_aluguel = a.id_aluguel
JOIN Jogo j         ON j.id_jogo = i.id_jogo;

CREATE OR REPLACE VIEW vw_faturamento_por_jogo AS
SELECT j.id_jogo,
       j.titulo,
       SUM(i.valor_unitario * i.quantidade) AS faturamento_total,
       COUNT(DISTINCT i.id_aluguel)         AS alugueis_distintos
FROM Jogo j
JOIN Inclui i ON i.id_jogo = j.id_jogo
GROUP BY j.id_jogo, j.titulo;

CREATE OR REPLACE VIEW vw_estoque_por_plataforma AS
SELECT p.nome  AS plataforma,
       j.id_jogo,
       j.titulo,
       jf.estoque
FROM Plataforma p
JOIN Jogo j      ON j.id_plataforma = p.id_plataforma
JOIN JogoFisico jf ON jf.id_jogo = j.id_jogo;

CREATE OR REPLACE VIEW vw_clientes_alugueis AS
SELECT c.id_cliente,
       c.nome,
       c.cpf,
       COUNT(a.id_aluguel) AS total_alugueis
FROM Cliente c
LEFT JOIN Aluguel a ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.cpf;