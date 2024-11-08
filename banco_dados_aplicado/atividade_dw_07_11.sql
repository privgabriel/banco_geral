USE banco_dados_aplicado;

CREATE TABLE dim_cliente (
    cliente_sk INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    data_inicio DATE,
    data_fim DATE DEFAULT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    UNIQUE(cliente_id, data_inicio)
);

INSERT INTO dim_cliente (cliente_id, nome, endereco, cidade, estado, data_inicio) VALUES
(1, 'João', 'Rua A, 123', 'Cidade A', 'SP', '2021-01-01'),
(2, 'Maria', 'Rua B, 456', 'Cidade B', 'RJ', '2021-01-01'),
(3, 'José', 'Rua C, 789', 'Cidade C', 'MG', '2021-01-01');

CREATE TABLE dim_centro (
    centro_sk INT AUTO_INCREMENT PRIMARY KEY,
    centro_id INT,
    nome VARCHAR(100),
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    data_inicio DATE,
    data_fim DATE DEFAULT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    UNIQUE(centro_id, data_inicio)
);

INSERT INTO dim_centro (centro_id, nome, endereco, cidade, estado, data_inicio) VALUES
(1, 'Centro A', 'Rua A, 123', 'Cidade A', 'SP', '2021-01-01'),
(2, 'Centro B', 'Rua B, 456', 'Cidade B', 'RJ', '2021-01-01'),
(3, 'Centro C', 'Rua C, 789', 'Cidade C', 'MG', '2021-01-01');

CREATE TABLE dim_tempo (
    tempo_sk INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    dia_da_semana VARCHAR(10)
);

ALTER TABLE dim_tempo MODIFY dia_da_semana VARCHAR(25);

INSERT INTO dim_tempo (data, ano, mes, dia, dia_da_semana) VALUES
('2021-01-01', 2021, 1, 1, 'Sexta-feira'),
('2021-01-02', 2021, 1, 2, 'Sábado'),
('2021-01-03', 2021, 1, 3, 'Domingo');

INSERT INTO Dim_Tempo (data, ano, mes, dia, dia_da_semana)
VALUES
('2021-01-01', 2021, 1, 1, 'Sexta'),
('2021-01-02', 2021, 1, 2, 'Sábado'),
('2021-01-03', 2021, 1, 3, 'Domingo');

DROP TABLE fato_entregas;

INSERT INTO fato_entregas (entrega_id, pedido_id, cliente_sk, centro_saida_sk, centro_destino_sk, tempo_pedido_sk, tempo_saida_sk, tempo_chegada_sk, quantidade, valor_total, quilometragem)
VALUES
(1, 1, 1, 1, 2, 1, 1, 2, 10, 100.00, 50.0), -- tempo_saida_sk = 1, tempo_chegada_sk = 2
(2, 2, 1, 1, 2, 1, 2, 3, 15, 150.00, 75.0), -- tempo_saida_sk = 2, tempo_chegada_sk = 3
(3, 3, 1, 1, 2, 1, 3, 1, 20, 200.00, 100.0); -- Erro intencional com tempo_chegada_sk < tempo_saida_sk para verificar comportamento

CREATE TABLE fato_entregas (
    entrega_id INT PRIMARY KEY,
    pedido_id INT,
    cliente_sk INT,
    centro_saida_sk INT,
    centro_destino_sk INT,
    tempo_pedido_sk INT,
    tempo_saida_sk INT,
    tempo_chegada_sk INT,
    quantidade INT,
    valor_total DECIMAL(10, 2),
    quilometragem DECIMAL(10, 2),
    FOREIGN KEY (cliente_sk) REFERENCES Dim_Cliente(cliente_sk),
    FOREIGN KEY (centro_saida_sk) REFERENCES Dim_Centro(centro_sk),
    FOREIGN KEY (centro_destino_sk) REFERENCES Dim_Centro(centro_sk),
    FOREIGN KEY (tempo_pedido_sk) REFERENCES Dim_Tempo(tempo_sk),
    FOREIGN KEY (tempo_saida_sk) REFERENCES Dim_Tempo(tempo_sk),
    FOREIGN KEY (tempo_chegada_sk) REFERENCES Dim_Tempo(tempo_sk)
);

INSERT INTO fato_entregas (entrega_id, pedido_id, cliente_sk, centro_saida_sk, centro_destino_sk, tempo_pedido_sk, tempo_saida_sk, tempo_chegada_sk, quantidade, valor_total, quilometragem) VALUES
(1, 1, 1, 1, 2, 1, 1, 2, 10, 100.00, 10.00),
(2, 2, 2, 2, 3, 2, 2, 3, 20, 200.00, 20.00),
(3, 3, 3, 3, 1, 3, 3, 1, 30, 300.00, 30.00);

-- //  Cálculo do Total de Produtos Transportados -----

SELECT SUM(quantidade) AS total_produtos FROM fato_entregas;

SELECT * FROM fato_entregas;

-- //  Cálculo do Tempo Total de Entrega -----

SELECT
    SUM(CASE WHEN DATEDIFF(chegada.data, saida.data) > 0
             THEN DATEDIFF(chegada.data, saida.data)
             ELSE 0 END) AS tempo_total_entrega
FROM
    fato_entregas
JOIN
    Dim_Tempo AS saida ON fato_entregas.tempo_saida_sk = saida.tempo_sk
JOIN
    Dim_Tempo AS chegada ON fato_entregas.tempo_chegada_sk = chegada.tempo_sk;


SELECT * FROM fato_entregas;

-- //  Cálculo do Tempo Médio de Entrega por Pedido -----

SELECT
    AVG(CASE WHEN DATEDIFF(chegada.data, saida.data)
             THEN DATEDIFF(chegada.data, saida.data)
             ELSE NULL END) AS tempo_medio_entrega
FROM
    fato_entregas AS ft
JOIN
    dim_tempo AS saida ON ft.tempo_saida_sk = saida.tempo_sk
JOIN
    dim_tempo AS chegada ON ft.tempo_chegada_sk = chegada.tempo_sk;



-- //  Cálculo do Custo Médio por Quilômetro -----

SELECT AVG(valor_total / quilometragem) AS custo_medio_quilometro FROM fato_entregas;x



