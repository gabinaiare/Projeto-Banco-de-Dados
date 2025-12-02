CREATE TABLE funcioncario(
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
)

CREATE TABLE Jogo (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_lancamento INTEGER,
    valor_diaria NUMERIC(10, 2) NOT NULL,
    genero VARCHAR(50)
);

CREATE TABLE JogoFisico (
    id_jogo INTEGER PRIMARY KEY REFERENCES Jogo(id_jogo),
    estoque INTEGER NOT NULL CHECK (estoque >= 0)
);

CREATE TABLE JogoDigital (
    id_jogo INTEGER PRIMARY KEY REFERENCES Jogo(id_jogo),
    codigo_licenca VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Fornecedor (
    cnpj VARCHAR(18) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    contato VARCHAR(100)
);

CREATE TABLE Aluguel (
    id_aluguel SERIAL PRIMARY KEY,
    data_aluguel TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    data_devolucao TIMESTAMP,
    tempo_aluguel INTEGER,
    valor_total NUMERIC(10, 2),
    multa NUMERIC(10, 2) DEFAULT 0.00,
    id_funcionario INTEGER NOT NULL REFERENCES Funcionario(id_funcionario),
    id_cliente INTEGER NOT NULL REFERENCES Cliente(id_cliente)
);

CREATE TABLE Abastece (
    cnpj_fornecedor VARCHAR(18) REFERENCES Fornecedor(cnpj),
    id_jogo_fisico INTEGER REFERENCES JogoFisico(id_jogo),
    data_abastecimento DATE NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),

    PRIMARY KEY (cnpj_fornecedor, id_jogo_fisico)
);

CREATE TABLE Inclui (
    id_aluguel INTEGER REFERENCES Aluguel(id_aluguel),
    id_jogo INTEGER REFERENCES Jogo(id_jogo),
    valor_unitario NUMERIC(10, 2) NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),

    PRIMARY KEY (id_aluguel, id_jogo)
);

ALTER TABLE Jogo
ADD COLUMN id_plataforma INTEGER NOT NULL REFERENCES Plataforma(id_plataforma);