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
-- Comando:
SELECT * FROM vw_detalhes_aluguel WHERE cliente = 'Carlos Silva';
-- Resultado esperado: linhas correspondentes aos itens do aluguel do Carlos (The Witcher 3 e FIFA 24), com subtotais 9.90 e 15.00.

-- 5.6 TESTES DE GATILHOS (TRIGGERS)
-- Teste 11: Inserir item em Inclui e verificar estoque (jogo físico id 3 tem estoque inicial 5)
-- Comando:
INSERT INTO Inclui (id_aluguel, id_jogo, valor_unitario, quantidade) VALUES (1, 3, 8.00, 2);
-- Resultado esperado: INSERT 0 1; e estoque do JogoFisico id_jogo=3 passa de 5 para 3.
-- Observação: se a quantidade solicitada exceder o estoque, espera-se erro da trigger.

-- Teste 12: Deletar item em Inclui e verificar restauração de estoque
-- Comando:
DELETE FROM Inclui WHERE id_aluguel = 1 AND id_jogo = 3;
-- Resultado esperado: DELETE 1; estoque do JogoFisico id_jogo=3 volta de 3 para 5.

-- 5.7 TESTES DE FUNÇÕES
-- Teste 13: Calcular multa para aluguel sem devolução (data_devolucao NULL)
-- Comando:
SELECT fn_calcula_multa(1, 0.5) AS multa_calculada;
-- Resultado esperado: 0.0 — função retorna 0 quando data_devolucao é NULL.

-- Teste 14: Total de alugueis de um cliente
-- Comando:
SELECT fn_total_alugueis_cliente(1) AS total_alugueis_carlos;
-- Resultado esperado: número inteiro (1 no dataset de exemplo).