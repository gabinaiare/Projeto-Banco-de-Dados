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
);

CREATE TABLE Jogo(
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    ano_lancamento INTEGER,
    valor_diaria NUMERIC(10, 2) NOT NULL,
    genero VARCHAR(50)
);

CREATE TABLE JogoFisico(
    id_jogo INTEGER PRIMARY KEY REFERENCES Jogo(id_jogo),
    estoque INTEGER NOT NULL CHECK (estoque >= 0)
);

CREATE TABLE JogoDigital(
    id_jogo INTEGER PRIMARY KEY REFERENCES Jogo(id_jogo),
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
    valor_total NUMERIC(10, 2),
    multa NUMERIC(10, 2) DEFAULT 0.00,
    id_funcionario INTEGER NOT NULL REFERENCES funcioncario(id_funcionario),
    id_cliente INTEGER NOT NULL REFERENCES Cliente(id_cliente)
);

CREATE TABLE Abastece(
    cnpj_fornecedor VARCHAR(18) REFERENCES Fornecedor(cnpj),
    id_jogo_fisico INTEGER REFERENCES JogoFisico(id_jogo),
    data_abastecimento DATE NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    PRIMARY KEY (cnpj_fornecedor, id_jogo_fisico)
);

CREATE TABLE Inclui(
    id_aluguel INTEGER REFERENCES Aluguel(id_aluguel),
    id_jogo INTEGER REFERENCES Jogo(id_jogo),
    valor_unitario NUMERIC(10, 2) NOT NULL,
    quantidade INTEGER NOT NULL DEFAULT 1 CHECK (quantidade > 0),
    PRIMARY KEY (id_aluguel, id_jogo)
);

ALTER TABLE Jogo
ADD COLUMN id_plataforma INTEGER NOT NULL REFERENCES Plataforma(id_plataforma);

-- Inserção de dados
INSERT INTO funcioncario (nome, cargo) 
VALUES 
    ('Ana Pereira', 'Gerente'),
    ('João Santos', 'Caixa'),
    ('Beatriz Lima', 'Supervisora');
	
INSERT INTO Cliente (cpf, nome, data_nascimento, email) 
VALUES
    ('111.222.333-44', 'João Almeida', '1985-03-10', 'joao.almeida@email.com'),
    ('222.333.444-55', 'Fernanda Costa', '1992-07-21', 'fernanda.costa@email.com'),
    ('333.444.555-66', 'Pedro Henrique', '2001-11-05', 'pedro.henrique@email.com'),
    ('444.555.666-77', 'Carolina Souza', '1988-09-14', 'carolina.souza@email.com'),
    ('555.666.777-88', 'Lucas Martins', '1995-01-30', 'lucas.martins@email.com'),
    ('666.777.888-99', 'Beatriz Oliveira', '1999-04-25', 'beatriz.oliveira@email.com'),
    ('777.888.999-00', 'Ricardo Mendes', '1983-12-12', 'ricardo.mendes@email.com'),
    ('888.999.000-11', 'Patrícia Lima', '1997-06-18', 'patricia.lima@email.com');
	
-- Inserir plataformas
INSERT INTO Plataforma (nome, fabricante) VALUES
    ('PlayStation 5', 'Sony'),
    ('Xbox Series X', 'Microsoft'),
    ('Nintendo Switch', 'Nintendo'),
    ('PC Gamer', 'Diversos');

INSERT INTO Jogo (titulo, ano_lancamento, valor_diaria, genero, id_plataforma) VALUES
    ('Halo Infinite', 2021, 12.00, 'FPS', 2),          -- Xbox
    ('Zelda: Breath of the Wild', 2017, 10.00, 'Aventura', 3), -- Switch
    ('Cyberpunk 2077', 2020, 18.00, 'RPG', 4),         -- PC
    ('FIFA 23', 2022, 14.00, 'Esporte', 2),            -- Xbox
    ('Mario Kart 8 Deluxe', 2017, 9.00, 'Corrida', 3), -- Switch
    ('Elden Ring', 2022, 20.00, 'RPG', 4);             -- PC

-- Remoção de dados
DELETE FROM Cliente WHERE id_cliente = 1;
DELETE FROM Jogo WHERE titulo = 'The Last of Us Part II';

-- Listagem de dados
SELECT * FROM Cliente;
SELECT nome, email FROM Cliente WHERE data_nascimento < '2000-01-01';

SELECT a.id_aluguel, c.nome AS cliente, f.nome AS funcionario
FROM Aluguel a
JOIN Cliente c ON a.id_cliente = c.id_cliente
JOIN funcioncario f ON a.id_funcionario = f.id_funcionario;

SELECT genero, COUNT(*) AS total_jogos
FROM Jogo
GROUP BY genero;

-- Alteração de dados
UPDATE Cliente SET email = 'novoemail@email.com' WHERE id_cliente = 2;
UPDATE Jogo SET valor_diaria = 20.00 WHERE titulo = 'The Last of Us Part II';

-- View 1: Clientes e seus alugueis
CREATE VIEW vw_clientes_alugueis AS
SELECT c.nome AS cliente, a.id_aluguel, a.data_aluguel, a.data_devolucao
FROM Cliente c
JOIN Aluguel a ON c.id_cliente = a.id_cliente;

-- View 2: Estoque de jogos físicos
CREATE VIEW vw_estoque_jogos AS
SELECT j.titulo, jf.estoque
FROM Jogo j
JOIN JogoFisico jf ON j.id_jogo = jf.id_jogo;

-- View 3: Jogos por plataforma
CREATE VIEW vw_jogos_plataforma AS
SELECT p.nome AS plataforma, j.titulo, j.genero
FROM Jogo j
JOIN Plataforma p ON j.id_plataforma = p.id_plataforma;

-- View 4: Receita por aluguel
CREATE VIEW vw_receita_alugueis AS
SELECT a.id_aluguel, SUM(i.valor_unitario * i.quantidade) AS receita
FROM Aluguel a
JOIN Inclui i ON a.id_aluguel = i.id_aluguel
GROUP BY a.id_aluguel;

-- Trigger 1: Atualiza estoque ao abastecer
CREATE OR REPLACE FUNCTION atualizar_estoque()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE JogoFisico
    SET estoque = estoque + NEW.quantidade
    WHERE id_jogo = NEW.id_jogo_fisico;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_estoque
AFTER INSERT ON Abastece
FOR EACH ROW
EXECUTE FUNCTION atualizar_estoque();

-- Trigger 2: Calcula valor total do aluguel
CREATE OR REPLACE FUNCTION calcular_valor_aluguel()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Aluguel
    SET valor_total = (
        SELECT SUM(valor_unitario * quantidade)
        FROM Inclui
        WHERE id_aluguel = NEW.id_aluguel
    )
    WHERE id_aluguel = NEW.id_aluguel;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_calcular_valor_aluguel
AFTER INSERT OR UPDATE ON Inclui
FOR EACH ROW
EXECUTE FUNCTION calcular_valor_aluguel();

-- Função 1: calcular idade do cliente
CREATE OR REPLACE FUNCTION calcular_idade_cliente(p_id_cliente INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_idade INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento))
    INTO v_idade
    FROM Cliente
    WHERE id_cliente = p_id_cliente;
    RETURN v_idade;
END;
$$ LANGUAGE plpgsql;

-- Função 2: calcular multa por atraso
CREATE OR REPLACE FUNCTION calcular_multa(p_id_aluguel INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    v_multa NUMERIC := 0.00;
    v_dias_atraso INTEGER;
BEGIN
    SELECT EXTRACT(DAY FROM (CURRENT_DATE - data_devolucao))
    INTO v_dias_atraso
    FROM Aluguel
    WHERE id_aluguel = p_id_aluguel;

    IF v_dias_atraso > 0 THEN
        v_multa := v_dias_atraso * 5.00;
    END IF;

    RETURN v_multa;
END;
$$ LANGUAGE plpgsql;