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
    id_funcionario INTEGER NOT NULL REFERENCES Funcionario(id_funcionario),
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
INSERT INTO Funcionario (nome, cargo) 
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
(CURRENT_TIMESTAMP + INTERVAL '3 dias', 3, 29.70, 0.00, 1, 1),
(CURRENT_TIMESTAMP + INTERVAL '2 dias', 2, 15.00, 0.00, 2, 2),
(CURRENT_TIMESTAMP + INTERVAL '5 dias', 5, 52.50, 0.00, 3, 3),
(CURRENT_TIMESTAMP + INTERVAL '1 dias', 1, 10.00, 0.00, 4, 4); 

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

-- 1.4 Remover registros de Abastece que usam o jogo fisico 6
DELETE FROM Abastece
WHERE id_jogo_fisico = 6;

-- Remover o funcionário específico (Diego Rocha, id = 4)
DELETE FROM Funcionario
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
FROM Funcionario;

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
JOIN Funcionario f ON f.id_funcionario = a.id_funcionario;

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
JOIN Funcionario f ON f.id_funcionario = a.id_funcionario
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
UPDATE Funcionario
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
JOIN Funcionario f ON a.id_funcionario = f.id_funcionario
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
SELECT * FROM vw_faturamento_por_jogo
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
SELECT * FROM vw_estoque_por_plataforma
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
SELECT * FROM vw_clientes_alugueis
ORDER BY total_alugueis DESC;

-- Função de trigger: diminui o estoque de JogoFisico quando um item é adicionado em Inclui
CREATE OR REPLACE FUNCTION fn_atualiza_estoque_apos_incluir()
RETURNS TRIGGER AS
$$
DECLARE
    v_estoque_atual INTEGER;  -- guarda o estoque atual do jogo físico
BEGIN
    -- Busca o estoque do jogo na tabela de jogos físicos
    SELECT estoque
    INTO v_estoque_atual
    FROM JogoFisico
    WHERE id_jogo = NEW.id_jogo;

    -- Se não achou registro em JogoFisico, então é jogo digital -> não mexe em nada
    IF v_estoque_atual IS NULL THEN
        RETURN NEW;
    END IF;

    -- Verifica se, após a locação, o estoque ficaria negativo
    IF v_estoque_atual - NEW.quantidade < 0 THEN
        RAISE EXCEPTION 'Estoque insuficiente para o jogo de ID %', NEW.id_jogo;
    END IF;

    -- Atualiza o estoque subtraindo a quantidade alugada
    UPDATE JogoFisico
    SET estoque = v_estoque_atual - NEW.quantidade
    WHERE id_jogo = NEW.id_jogo;

    -- Devolve a linha que está sendo inserida na tabela Inclui
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
           data_aluguel + (tempo_aluguel || 'dias')::INTERVAL
    INTO  v_data_devolucao_real, v_data_devolucao_prevista
    FROM Aluguel
    WHERE id_aluguel = p_id_aluguel;

    -- se ainda não foi devolvido, multa 0
    IF v_data_devolucao_real IS NULL THEN
        RETURN 0;
    END IF;

    -- calcula dias de atraso (não deixa negativo)
    v_dias_atraso := GREATEST(
        DATE_PART('dia', v_data_devolucao_real - v_data_devolucao_prevista)::INTEGER,
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

-- Plano de testes melhorado (opção C): cada teste tem comando, resultado esperado e explicação.

-- 5.1 TESTES DE INSERÇÃO (INSERT)
-- Teste 1: Inserir funcionário válido
-- Comando:
INSERT INTO Funcionario (nome, cargo) VALUES ('Lucas Martins','Atendente');
-- Resultado esperado: INSERT 0 1
-- Verificação: SELECT * FROM Funcionario WHERE nome = 'Lucas Martins';
-- Explicação: deve criar um novo registro sem alterar os existentes.

-- Teste 2: Inserir cliente com CPF duplicado (deve falhar)
-- Comando:
INSERT INTO Cliente (cpf, nome, data_nascimento, email)
VALUES ('123.456.789-00', 'Teste', '1995-01-01', 'teste@example.com');
-- Resultado esperado: ERRO 23505 (violação de unicidade)
-- Explicação: CPF já existe nos dados de exemplo. Constraint UNIQUE impede duplicidade.

-- Teste 3: Inserir jogo físico com estoque negativo (deve falhar)
-- Comando:
INSERT INTO JogoFisico (id_jogo, estoque) VALUES (1, -5);
-- Resultado esperado: ERRO 23514 (violação de CHECK)
-- Explicação: CHECK (estoque >= 0) impede valores negativos.

-- 5.2 TESTES DE REMOÇÃO (DELETE)
-- Teste 4: Tentar remover cliente com alugueis existentes (com ON DELETE CASCADE o comportamento mudou)
-- Comando:
DELETE FROM Cliente WHERE id_cliente = 1;
-- Resultado esperado (com o schema fornecido): DELETE 1
-- Explicação: definimos ON DELETE CASCADE em Aluguel.id_cliente, portanto ao remover o cliente,
-- seus alugueis vinculados também serão removidos automaticamente. Se quiser testar o comportamento antigo (erro), altere a FK para RESTRICT.

-- Teste 5: Deletar cliente inexistente
-- Comando:
DELETE FROM Cliente WHERE id_cliente = 999;
-- Resultado esperado: DELETE 0

-- 5.3 TESTES DE LISTAGEM (SELECT)
-- Teste 6: Clientes nascidos após 1995-01-01
-- Comando:
SELECT nome, cpf, data_nascimento FROM Cliente WHERE data_nascimento > '1995-01-01';
-- Resultado esperado: linhas com João Pereira (2000-01-15) e Fernanda Alves (1995-12-01)

-- Teste 7: Listar jogos físicos com plataforma e estoque
-- Comando:
SELECT j.titulo, p.nome AS plataforma, jf.estoque
FROM Jogo j
JOIN Plataforma p ON j.id_plataforma = p.id_plataforma
JOIN JogoFisico jf ON jf.id_jogo = j.id_jogo;
-- Resultado esperado: linhas para os jogos físicos inseridos (6 linhas no dataset de exemplo)

-- 5.4 TESTES DE ALTERAÇÃO (UPDATE)
-- Teste 8: Atualizar cargo de um funcionário
-- Comando:
UPDATE Funcionario SET cargo = 'Supervisor' WHERE nome = 'Bruno Lima';
-- Resultado esperado: UPDATE 1; SELECT mostra cargo atualizado.

-- Teste 9: Incrementar estoque de jogo físico
-- Comando:
UPDATE JogoFisico SET estoque = estoque + 3 WHERE id_jogo = 4;
-- Resultado esperado: UPDATE 1; estoque do id_jogo=4 aumenta de 12 para 15.

-- 5.5 TESTES DE VIEWS
-- Teste 10: Consultar vw_detalhes_aluguel para 'Carlos Silva'
--Plano de Testes--
--5.1 Testes de Inserção(INSERT):--

--1°exemplo--
INSERT INTO funcioncario (nome, cargo)
VALUES ('Lucas Martins', 'Atendente');

SELECT * FROM funcioncario;

--resultado:--
--INSERT 0 1
Query returned successfully in 99 msec. 
1 1(id)	"Ana Souza"(nome)	"Atendente"(cargo)
2 3	"Carla Mendes"	"Atendente"
3 4	"Diego Rocha"	"Caixa"
4 5	"Lucas Martins"	"Atendente"
5 2	"Bruno Lima"	"Gerente"
Foi adicionado um novo úsuario a tabela.--

--2°exemplo--
INSERT INTO Cliente (cpf, nome, data_nascimento, email)
VALUES ('123.456.789-00', 'Teste', '1995-01-01', 'teste@example.com');

--resultado:--
--Ao tentar inserir um novo cliente, com o mesmo cpf já existente esse foi o resultado
ERRO:  duplicar valor da chave viola a restrição de unicidade "cliente_cpf_key"
SQL state: 23505
Detail: Chave (cpf)=(123.456.789-00) já existe.--

--3°exemplo--
INSERT INTO JogoFisico (id_jogo, estoque)
VALUES (1, -5);

--resultado:--
--Ao tentar inserir um estoque negativo esse foi o resultado
ERRO:  a nova linha da relação "jogofisico" viola a restrição de verificação "jogofisico_estoque_check"
SQL state: 23514
Detail: Registro que falhou contém (1, -5).--

--5.2 Testes de Remoção(DELETE):--

--1°exemplo--
DELETE FROM Cliente WHERE id_cliente = 1;

--resultado: --
--Ao tentar deletar um cliente especifico cujo há dependencia como o (aluguel) esse foi o resultado
ERRO:  atualização ou exclusão em tabela "cliente" viola restrição de chave estrangeira "aluguel_id_cliente_fkey" em "aluguel"
SQL state: 23503
Detail: Chave (id_cliente)=(1) ainda é referenciada pela tabela "aluguel".--

--2°exemplo--
DELETE FROM Cliente WHERE id_cliente = 999;

--resultado:--
--Ao tentar remover um cliente que não existe esse foi o resultado
DELETE 0
Query returned successfully in 84 msec.--

--5.3 Testes de Listagem (SELECT):--

--1°exemplo--
SELECT nome, cpf, data_nascimento
FROM Cliente
WHERE data_nascimento > '1995-01-01';

--resultado:--
--Essa teste consiste em filtrar os clientes que nasceram após 1995.
Successfully run. Total query runtime: 280 msec.
2 rows affected.
1 "João Pereira"	"111.222.333-44"	"2000-01-15"
2 "Fernanda Alves"	"555.666.777-88"	"1995-12-01"--

--2°exemplo--
SELECT j.titulo, p.nome AS plataforma, jf.estoque
FROM Jogo j
JOIN Plataforma p ON j.id_plataforma = p.id_plataforma
JOIN JogoFisico jf ON jf.id_jogo = j.id_jogo;

--resultado:--
--Esse teste mostra a junção das tabelas Jogo, Plataforma e JogoFisico
Successfully run. Total query runtime: 158 msec.
6 rows affected.
1 "The Witcher 3"	"PC"	10
2 "FIFA 24"	"PlayStation 5"	8
3 "Halo Infinite"	"Xbox Series X"	5
4 "Mario Kart 8 Deluxe"	"Nintendo Switch"	12
5 "God of War Ragnarok"	"PlayStation 5"	6
6 "Forza Horizon 5"	"Xbox Series X"	4--

--5.4 Testes de Alteração (UPDATE):--

--1°exemplo--
UPDATE funcioncario
SET cargo = 'Supervisor'
WHERE nome = 'Bruno Lima';

--resultado:--
--Esse teste consiste em alterar o cargo de um funcionário específico. Antes "Gerente"
UPDATE 1
Query returned successfully in 104 msec.
SELECT * FROM funcioncario WHERE nome = 'Bruno Lima';
1 2(id)	"Bruno Lima"(nome)	"Supervisor"(cargo)--

--2°exemplo--
UPDATE JogoFisico
SET estoque = estoque + 3
WHERE id_jogo = 4;

--resultado:--
--Esse teste incrementa +3 ao estoque do jogo físico id 4 cujo o estoque era 12
UPDATE 1
Query returned successfully in 145 msec.
SELECT * FROM JogoFisico WHERE id_jogo = 4;
1 4(id)	15(estoque)--

--5.5 Testes de Views--

--1°exemplo--
SELECT * FROM vw_detalhes_aluguel
WHERE cliente = 'Carlos Silva';

--resultado: --
--Esse teste consulta a view que combina cliente, aluguel, jogos e subtotal.
1 1(id)	"2025-12-09 01:30:47.338185"(data_aluguel)	"2025-12-12 01:30:47.338185"(data_devolucao)	"Carlos Silva"(cliente)	"Ana Souza"(funcionario)	"The Witcher 3"(jogo)	1(quantidade)	9.90(valor_unitario)	9.90(subtotal)
2 1	"2025-12-09 01:30:47.338185"	"2025-12-12 01:30:47.338185"	"Carlos Silva"	"Ana Souza"	"FIFA 24"	2	7.50	15.00--

--5.6 Testes de Gatilhos (Triggers)--

--1°exemplo--
INSERT INTO Inclui (id_aluguel, id_jogo, valor_unitario, quantidade)
VALUES (1, 3, 8.00, 2);

SELECT estoque FROM JogoFisico WHERE id_jogo = 3;

--resultado:--
--Esse teste consiste em inserir um novo item aoaluguel 1, referente ao jogo de id 3, com quantidade 2:
INSERT 0 1
Query returned successfully in 76 msec.
3(estoque)--

--5.7 Testes de Funções--

--1°exemplo--
SELECT fn_calcula_multa(1, 9.90, 0.5) AS multa_calculada;

--resultado:--
--Esse teste consiste em chamar a função que calcula multa de um aluguel com base no atraso.
0.000(multa_calculada)--

--2°exemplo--
SELECT fn_total_alugueis_cliente(1) AS total_alugueis_carlos;

--resultado:--
--Esse teste consiste em contar quantos alugueis o cliente 1 fez.
1(total_alugueis_carlos)--
