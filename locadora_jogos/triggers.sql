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