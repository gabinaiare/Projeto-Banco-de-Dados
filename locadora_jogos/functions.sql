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