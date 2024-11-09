CREATE TABLE dim_cliente (
    cliente_sk INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    nome VARCHAR(100),
    data_nascimento DATE,
    endereco VARCHAR(255),
    categoria_fidelidade VARCHAR(20),
    data_inicio DATE,
    data_fim DATE DEFAULT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    UNIQUE (cliente_id, data_inicio)
);

INSERT INTO dim_cliente (cliente_id, nome, data_nascimento, endereco, categoria_fidelidade, data_inicio) VALUES
(1, 'Cliente A', '1990-01-01', 'Rua A, 123', 'Ouro', '2020-01-01'),
(2, 'Cliente B', '1995-01-01', 'Rua B, 456', 'Prata', '2020-01-01');

CREATE TABLE dim_quarto (
    quarto_sk INT AUTO_INCREMENT PRIMARY KEY,
    quarto_id INT,
    hotel_sk INT,
    tipo_quarto VARCHAR(50),
    status_manutencao VARCHAR(20),
    data_inicio DATE,
    data_fim DATE DEFAULT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    UNIQUE (quarto_id, data_inicio),
    FOREIGN KEY (hotel_sk) REFERENCES dim_hotel(hotel_sk)
);

INSERT INTO dim_quarto (quarto_id, hotel_sk, tipo_quarto, status_manutencao, data_inicio) VALUES
(1, 1, 'Standard', 'Disponível', '2020-01-01'),
(2, 2, 'Luxo', 'Disponível', '2020-01-01');

CREATE TABLE dim_hotel (
    hotel_sk INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    nome_hotel VARCHAR(100),
    cidade VARCHAR(100),
    pais VARCHAR(50),
    data_inauguracao DATE
);

INSERT INTO dim_hotel (hotel_id, nome_hotel, cidade, pais, data_inauguracao) VALUES
(1, 'Hotel A', 'Cidade A', 'Brasil', '2020-01-01'),
(2, 'Hotel B', 'Cidade B', 'Brasil', '2020-01-01');

CREATE TABLE dim_tempo (
    tempo_sk INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    ano INT,
    mes INT,
    dia INT,
    dia_da_semana VARCHAR(20)
);

INSERT INTO dim_tempo (data, ano, mes, dia, dia_da_semana) VALUES
('2021-01-01', 2021, 1, 1, 'Sexta-feira'),
('2021-01-02', 2021, 1, 2, 'Sábado'),
('2021-01-03', 2021, 1, 3, 'Domingo'),
('2021-01-04', 2021, 1, 4, 'Segunda-feira'),
('2021-01-05', 2021, 1, 5, 'Terça-feira'),
('2021-01-06', 2021, 1, 6, 'Quarta-feira'),
('2021-01-07', 2021, 1, 7, 'Quinta-feira');

CREATE TABLE fato_reservas (
    reserva_sk INT AUTO_INCREMENT PRIMARY KEY,
    cliente_sk INT,
    quarto_sk INT,
    hotel_sk INT,
    tempo_checkin_sk INT,
    tempo_checkout_sk INT,
    valor_reserva DECIMAL(15, 2),
    FOREIGN KEY (cliente_sk) REFERENCES dim_cliente(cliente_sk),
    FOREIGN KEY (quarto_sk) REFERENCES dim_quarto(quarto_sk),
    FOREIGN KEY (hotel_sk) REFERENCES dim_hotel(hotel_sk),
    FOREIGN KEY (tempo_checkin_sk) REFERENCES dim_tempo(tempo_sk),
    FOREIGN KEY (tempo_checkout_sk) REFERENCES dim_tempo(tempo_sk)
);

INSERT INTO fato_reservas (cliente_sk, quarto_sk, hotel_sk, tempo_checkin_sk, tempo_checkout_sk, valor_reserva) VALUES
(1, 1, 1, 1, 2, 100.00),
(2, 2, 2, 1, 2, 150.00);

CREATE TABLE fato_receitas (
    hotel_sk INT,
    tempo_sk INT,
    receita_diaria DECIMAL(15, 2),
    despesas_diaria DECIMAL(15, 2),
    PRIMARY KEY (hotel_sk, tempo_sk),
    FOREIGN KEY (hotel_sk) REFERENCES dim_hotel(hotel_sk),
    FOREIGN KEY (tempo_sk) REFERENCES dim_tempo(tempo_sk)
);

INSERT INTO fato_receitas (hotel_sk, tempo_sk, receita_diaria, despesas_diaria) VALUES
(1, 1, 1000.00, 500.00),
(2, 1, 1500.00, 700.00);

-- // Receita Média por Cliente e Categoria de Fidelidade ---
SELECT
    c.categoria_fidelidade,
    AVG(fr.valor_reserva) AS receita_media
FROM
    Fato_Reservas fr
JOIN
    Dim_Cliente c ON fr.cliente_sk = c.cliente_sk
GROUP BY
    c.categoria_fidelidade;

-- // Taxas de Ocupação por Hotel ---
SELECT
    h.nome_hotel,
    t.data,
    COUNT(fr.reserva_sk) AS total_reservas,
    COUNT(DISTINCT fr.quarto_sk) AS total_quartos,
    COUNT(fr.reserva_sk) / COUNT(DISTINCT fr.quarto_sk) AS taxa_ocupacao
FROM
    Fato_Reservas fr
JOIN
    Dim_Hotel h ON fr.hotel_sk = h.hotel_sk
JOIN
    Dim_Tempo t ON fr.tempo_checkin_sk = t.tempo_sk
GROUP BY
    h.nome_hotel, t.data;

-- // Receita Diária por Hotel ---
SELECT
    h.nome_hotel,
    t.data,
    SUM(fr.valor_reserva) AS receita_diaria
FROM
    Fato_Reservas fr
JOIN
    Dim_Hotel h ON fr.hotel_sk = h.hotel_sk
JOIN
    Dim_Tempo t ON fr.tempo_checkin_sk = t.tempo_sk
GROUP BY
    h.nome_hotel, t.data;

-- // Média de Tempo de Permanência por Categoria de Fidelidade --
SELECT
    c.categoria_fidelidade,
    AVG(DATEDIFF(fr.tempo_checkout_sk, fr.tempo_checkin_sk)) AS media_tempo_permanencia
FROM
    Fato_Reservas fr
JOIN
    Dim_Cliente c ON fr.cliente_sk = c.cliente_sk
GROUP BY
    c.categoria_fidelidade;

-- // Quartos Mais Frequentemente Reformados
SELECT
    q.quarto_id,
    COUNT(q.quarto_id) AS total_reformas
FROM
    Dim_Quarto q
WHERE
    q.status_manutencao = 'Manutenção'
GROUP BY
    q.quarto_id
ORDER BY
    total_reformas DESC;

--- // Perfil de Clientes com Maior Gasto em Reservas por País e Categoria de Fidelidade
SELECT
    h.pais,
    c.categoria_fidelidade,
    c.nome,
    SUM(fr.valor_reserva) AS total_gasto
FROM
    Fato_Reservas fr
JOIN
    Dim_Cliente c ON fr.cliente_sk = c.cliente_sk
JOIN
    Dim_Hotel h ON fr.hotel_sk = h.hotel_sk
GROUP BY
    h.pais, c.categoria_fidelidade, c.nome
ORDER BY
    total_gasto DESC;




