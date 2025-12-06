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

-- FUNCIONARIOS
INSERT INTO funcioncario (nome, cargo) 
VALUES
('Ana Souza', 'Atendente'),          
('Bruno Lima', 'Gerente'),           
('Carla Mendes', 'Atendente'),       
('Diego Rocha', 'Caixa');            

-- CLIENTES
INSERT INTO Cliente (cpf, nome, data_nascimento, email) 
VALUES
('123.456.789-00', 'Carlos Silva', '1990-05-10', 'carlos.silva@example.com'),
('987.654.321-00', 'Mariana Costa', '1988-09-22', 'mariana.costa@example.com'),
('111.222.333-44', 'João Pereira', '2000-01-15', 'joao.pereira@example.com'), 
('555.666.777-88', 'Fernanda Alves', '1995-12-01', 'fernanda.alves@example.com');

-- PLATAFORMAS
INSERT INTO Plataforma (nome, fabricante) 
VALUES
('PlayStation 5', 'Sony'),    
('Xbox Series X', 'Microsoft'), 
('Nintendo Switch', 'Nintendo'),
('PC', 'Diversos');            

-- JOGOS
INSERT INTO Jogo (titulo, ano_lancamento, valor_diaria, genero, id_plataforma) 
VALUES
('The Witcher 3', 2015, 9.90, 'RPG', 4),      
('FIFA 24', 2023, 7.50, 'Esporte', 1),                 
('Halo Infinite', 2021, 8.00, 'FPS', 2),              
('Mario Kart 8 Deluxe', 2017, 6.50, 'Corrida', 3),     
('God of War Ragnarok', 2022, 10.00, 'Ação', 1),         
('Forza Horizon 5', 2021, 9.00, 'Corrida', 2),             
('Zelda: Breath of the Wild', 2017, 10.50, 'Aventura', 3),
('Cyberpunk 2077', 2020, 8.50, 'RPG', 4);                  

-- JOGOS FISICOS
INSERT INTO JogoFisico (id_jogo, estoque) 
VALUES
(1, 10),
(2, 8),
(3, 5),
(4, 12),
(5, 6),
(6, 4);

-- JOGOS DIGITAIS
INSERT INTO JogoDigital (id_jogo, codigo_licenca) 
VALUES
(7, 'ZELDA-BOTW-KEY-001'),
(8, 'CYBERPUNK-2077-KEY-001'),
(2, 'FIFA24-DIG-KEY-001');

-- FORNECEDORES
INSERT INTO Fornecedor (cnpj, nome, contato) 
VALUES
('12.345.678/0001-90', 'Games Distribuidora', 'contato@gamesdist.com'),
('98.765.432/0001-10', 'Max Games Supply', 'vendas@maxgames.com'),
('22.333.444/0001-55', 'PlayMore Distribuidora', 'playmore@distrib.com');

-- ALUGUEIS
INSERT INTO Aluguel (data_devolucao, tempo_aluguel, valor_total, multa, id_funcionario, id_cliente) 
VALUES
(CURRENT_TIMESTAMP + INTERVAL '3 days', 3, 29.70, 0.00, 1, 1),
(CURRENT_TIMESTAMP + INTERVAL '2 days', 2, 15.00, 0.00, 2, 2),
(CURRENT_TIMESTAMP + INTERVAL '5 days', 5, 52.50, 0.00, 3, 3),
(CURRENT_TIMESTAMP + INTERVAL '1 days', 1, 10.00, 0.00, 4, 4); 

-- ABASTECE (fornecedor abastece jogos fisicos)
INSERT INTO Abastece (cnpj_fornecedor, id_jogo_fisico, data_abastecimento, quantidade) 
VALUES
('12.345.678/0001-90', 1, '2025-01-10', 5),
('12.345.678/0001-90', 2, '2025-01-10', 3),
('98.765.432/0001-10', 3, '2025-02-05', 4),
('22.333.444/0001-55', 4, '2025-03-12', 6),
('98.765.432/0001-10', 5, '2025-04-01', 2),
('22.333.444/0001-55', 6, '2025-04-15', 3);

-- ITENS DOS ALUGUEIS (INCLUI)
INSERT INTO Inclui (id_aluguel, id_jogo, valor_unitario, quantidade) 
VALUES
-- Aluguel 1 (Carlos)
(1, 1, 9.90, 1),  -- The Witcher 3
(1, 2, 7.50, 2),  -- FIFA 24

-- Aluguel 2 (Mariana)
(2, 5, 10.00, 1), -- God of War Ragnarok
(2, 4, 6.50, 1),  -- Mario Kart 8

-- Aluguel 3 (João)
(3, 7, 10.50, 2), -- Zelda BOTW digital
(3, 3, 8.00, 1),  -- Halo Infinite

-- Aluguel 4 (Fernanda)
(4, 6, 9.00, 1),  -- Forza Horizon 5
(4, 4, 6.50, 1);  -- Mario Kart 8

DELETE FROM Inclui
WHERE id_aluguel IN (
    SELECT id_aluguel
    FROM Aluguel
    WHERE id_cliente = 3
       OR id_funcionario = 4
);

-- 1.2 Remover alugueis do cliente 3 (João Pereira)
DELETE FROM Aluguel
WHERE id_cliente = 3;

-- 1.3 Se quiser também remover alugueis do funcionario 4 (Fernanda)
DELETE FROM Aluguel
WHERE id_funcionario = 4;

-- 1.4 Remover registros de Abastece que usam o jogo fisico 6
DELETE FROM Abastece
WHERE id_jogo_fisico = 6;

-- Remover o funcionário específico (Diego Rocha, id = 4)
DELETE FROM funcioncario
WHERE id_funcionario = 4;

-- Remover o cliente específico (João Pereira, id = 3)
DELETE FROM Cliente
WHERE id_cliente = 3;

-- Remover um jogo físico com pouco estoque (jogo id = 6, Forza Horizon 5)
DELETE FROM JogoFisico
WHERE id_jogo = 6;

-- Remover todos os abastecimentos de um fornecedor específico
DELETE FROM Abastece
WHERE cnpj_fornecedor = '22.333.444/0001-55';

-- Listar todos os funcionários
SELECT id_funcionario, nome, cargo
FROM funcioncario;

-- Listar todos os clientes
SELECT id_cliente, nome, cpf, email
FROM Cliente;

-- Listar todos os jogos com plataforma
SELECT id_jogo, titulo, ano_lancamento, valor_diaria, genero, id_plataforma
FROM Jogo;

-- Clientes que nasceram após 1995
SELECT nome, cpf, data_nascimento
FROM Cliente
WHERE data_nascimento > '1995-01-01';

-- Jogos de gênero RPG
SELECT titulo, genero, valor_diaria
FROM Jogo
WHERE genero = 'RPG';

-- Alugueis do cliente com CPF '123.456.789-00' (Carlos Silva)
SELECT a.id_aluguel, a.data_aluguel, a.valor_total
FROM Aluguel a
JOIN Cliente c ON c.id_cliente = a.id_cliente
WHERE c.cpf = '123.456.789-00';

-- Jogos físicos com estoque e informações de plataforma
SELECT j.id_jogo,
       j.titulo,
       p.nome       AS plataforma,
       jf.estoque
FROM Jogo j
JOIN Plataforma p ON p.id_plataforma = j.id_plataforma
JOIN JogoFisico jf ON jf.id_jogo = j.id_jogo;

-- Alugueis com cliente e funcionário
SELECT a.id_aluguel,
       a.data_aluguel,
       c.nome AS cliente,
       f.nome AS funcionario
FROM Aluguel a
JOIN Cliente c      ON c.id_cliente = a.id_cliente
JOIN funcioncario f ON f.id_funcionario = a.id_funcionario;

-- Itens de aluguel com jogo, cliente e funcionário
SELECT a.id_aluguel,
       c.nome        AS cliente,
       f.nome        AS funcionario,
       j.titulo      AS jogo,
       i.quantidade,
       i.valor_unitario,
       (i.quantidade * i.valor_unitario) AS subtotal
FROM Inclui i
JOIN Aluguel a      ON a.id_aluguel = i.id_aluguel
JOIN Cliente c      ON c.id_cliente = a.id_cliente
JOIN funcioncario f ON f.id_funcionario = a.id_funcionario
JOIN Jogo j         ON j.id_jogo = i.id_jogo;

-- Total de alugueis por cliente
SELECT c.nome AS cliente,
       COUNT(a.id_aluguel) AS total_alugueis
FROM Cliente c
LEFT JOIN Aluguel a ON a.id_cliente = c.id_cliente
GROUP BY c.nome;

-- Faturamento total por jogo
SELECT j.titulo,
       SUM(i.valor_unitario * i.quantidade) AS faturamento_total
FROM Jogo j
JOIN Inclui i ON i.id_jogo = j.id_jogo
GROUP BY j.titulo;

-- Quantidade total abastecida por fornecedor
SELECT f.nome AS fornecedor,
       SUM(ab.quantidade) AS total_abastecido
FROM Fornecedor f
JOIN Abastece ab ON ab.cnpj_fornecedor = f.cnpj
GROUP BY f.nome;

-- Aumentar o estoque de um jogo físico (ex.: Mario Kart 8 Deluxe, id_jogo = 4)
UPDATE JogoFisico
SET estoque = estoque + 3
WHERE id_jogo = 4;

-- Mudar o cargo de um funcionário (ex.: Bruno Lima vira Supervisor)
UPDATE funcioncario
SET cargo = 'Supervisor'
WHERE nome = 'Bruno Lima';

-- Atualizar e-mail de um cliente (ex.: Mariana Costa)
UPDATE Cliente
SET email = 'mariana.costa.novo@example.com'
WHERE cpf = '987.654.321-00';

-- Dar desconto em um aluguel (ex.: aluguel id = 2)
UPDATE Aluguel
SET valor_total = valor_total * 0.9  -- 10% de desconto
WHERE id_aluguel = 2;

-- Reajustar valor_da_diaria dos jogos de Corrida em +1.00
UPDATE Jogo
SET valor_diaria = valor_diaria + 1.00
WHERE genero = 'Corrida';

-- View para detalhes completos dos alugueis
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
JOIN funcioncario f ON a.id_funcionario = f.id_funcionario
JOIN Inclui i       ON i.id_aluguel = a.id_aluguel
JOIN Jogo j         ON j.id_jogo = i.id_jogo;

-- Consultar a view criada
SELECT * FROM vw_detalhes_aluguel
WHERE cliente = 'Carlos Silva';

-- View para faturamento total por jogo
CREATE OR REPLACE VIEW vw_faturamento_por_jogo AS
SELECT j.id_jogo,
       j.titulo,
       SUM(i.valor_unitario * i.quantidade) AS faturamento_total,
       COUNT(DISTINCT i.id_aluguel)         AS alugueis_distintos
FROM Jogo j
JOIN Inclui i ON i.id_jogo = j.id_jogo
GROUP BY j.id_jogo, j.titulo;

-- Consultar a view de faturamento por jogo
SELECT *
FROM vw_faturamento_por_jogo
ORDER BY faturamento_total DESC;

-- View para estoque de jogos físicos por plataforma
CREATE OR REPLACE VIEW vw_estoque_por_plataforma AS
SELECT p.nome  AS plataforma,
       j.id_jogo,
       j.titulo,
       jf.estoque
FROM Plataforma p
JOIN Jogo j      ON j.id_plataforma = p.id_plataforma
JOIN JogoFisico jf ON jf.id_jogo = j.id_jogo;

-- Consultar a view de estoque por plataforma
SELECT *
FROM vw_estoque_por_plataforma
WHERE plataforma = 'PlayStation 5';

-- View para total de alugueis por cliente
CREATE OR REPLACE VIEW vw_clientes_alugueis AS
SELECT c.id_cliente,
       c.nome,
       c.cpf,
       COUNT(a.id_aluguel) AS total_alugueis
FROM Cliente c
LEFT JOIN Aluguel a ON a.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome, c.cpf;

-- Consultar a view de total de alugueis por cliente
SELECT *
FROM vw_clientes_alugueis
ORDER BY total_alugueis DESC;

-- Função de trigger: diminui o estoque de JogoFisico quando um item é adicionado em Inclui
CREATE OR REPLACE FUNCTION fn_atualiza_estoque_apos_incluir()
RETURNS TRIGGER AS
$$
BEGIN
    -- Só mexe se o jogo for físico
    IF EXISTS (
        SELECT 1
        FROM JogoFisico jf
        WHERE jf.id_jogo = NEW.id_jogo
    ) THEN
        
        UPDATE JogoFisico
        SET estoque = estoque - NEW.quantidade
        WHERE id_jogo = NEW.id_jogo;

        -- Evita estoque negativo
        IF (SELECT estoque FROM JogoFisico WHERE id_jogo = NEW.id_jogo) < 0 THEN
            RAISE EXCEPTION 'Estoque insuficiente para o jogo de ID %', NEW.id_jogo;
        END IF;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Gatilho: dispara depois de inserir linha em Inclui
CREATE TRIGGER trg_atualiza_estoque_incluir
AFTER INSERT ON Inclui
FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_estoque_apos_incluir();

-- Função de trigger: recalcula o valor_total do aluguel ao mudar os itens em Inclui
CREATE OR REPLACE FUNCTION fn_calcula_valor_total_aluguel()
RETURNS TRIGGER AS
$$
BEGIN
    UPDATE Aluguel
    SET valor_total = sub.total
    FROM (
        SELECT i.id_aluguel,
               SUM(i.valor_unitario * i.quantidade) AS total
        FROM Inclui i
        WHERE i.id_aluguel = NEW.id_aluguel
        GROUP BY i.id_aluguel
    ) AS sub
    WHERE Aluguel.id_aluguel = sub.id_aluguel;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Gatilho: dispara após INSERT ou UPDATE em Inclui
CREATE TRIGGER tg_calcula_valor_total
AFTER INSERT OR UPDATE ON Inclui
FOR EACH ROW
EXECUTE FUNCTION fn_calcula_valor_total_aluguel();

-- Função para calcular multa por atraso na devolução
CREATE OR REPLACE FUNCTION fn_calcula_multa(
    p_id_aluguel  INTEGER,
    p_valor_diaria NUMERIC,
    p_taxa_multa   NUMERIC
)
RETURNS NUMERIC AS
$$
DECLARE
    v_dias_atraso            INTEGER;
    v_data_devolucao_real    TIMESTAMP;
    v_data_devolucao_prevista TIMESTAMP;
BEGIN
    -- pega a devolução real e a data prevista (data_aluguel + tempo_aluguel)
    SELECT data_devolucao,
           data_aluguel + (tempo_aluguel || ' days')::INTERVAL
    INTO  v_data_devolucao_real, v_data_devolucao_prevista
    FROM Aluguel
    WHERE id_aluguel = p_id_aluguel;

    -- se ainda não foi devolvido, multa 0
    IF v_data_devolucao_real IS NULL THEN
        RETURN 0;
    END IF;

    -- calcula dias de atraso (não deixa negativo)
    v_dias_atraso := GREATEST(
        DATE_PART('day', v_data_devolucao_real - v_data_devolucao_prevista)::INTEGER,
        0
    );

    RETURN v_dias_atraso * p_valor_diaria * p_taxa_multa;
END;
$$ LANGUAGE plpgsql;

-- Consultar a multa de um aluguel específico
SELECT fn_calcula_multa(1, 9.90, 0.5) AS multa_calculada;

-- Atualizar a coluna multa de todos os alugueis usando a função
UPDATE Aluguel a
SET multa = fn_calcula_multa(a.id_aluguel, 9.90, 0.5);

-- Função para retornar o total de alugueis feitos por um cliente
CREATE OR REPLACE FUNCTION fn_total_alugueis_cliente(p_id_cliente INTEGER)
RETURNS INTEGER AS
$$
DECLARE
    v_total INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM Aluguel
    WHERE id_cliente = p_id_cliente;

    RETURN v_total;
END;
$$ LANGUAGE plpgsql;

-- Ver o total de alugueis de um cliente específico
SELECT fn_total_alugueis_cliente(1) AS total_alugueis_carlos;

-- Listar todos os clientes já com o total de alugueis calculado pela função
SELECT c.id_cliente,
       c.nome,
       fn_total_alugueis_cliente(c.id_cliente) AS total_alugueis
FROM Cliente c
ORDER BY total_alugueis DESC;