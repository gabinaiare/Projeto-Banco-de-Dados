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
