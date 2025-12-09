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