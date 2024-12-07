CREATE DATABASE banco_dados_aplicado;
use banco_dados_aplicado;

CREATE TABLE dim_loja (
    cgc_loja CHAR(12) PRIMARY KEY,
    nome CHAR(30),
    endereco CHAR(100),
    cidade CHAR(30),
    estado CHAR(2),
    pais CHAR(20)
);

CREATE TABLE dim_cliente (
    cpf CHAR(12) PRIMARY KEY,
    nome CHAR(30),
    endereco CHAR(100),
    cidade CHAR(30),
    estado CHAR(2),
    renda DECIMAL(15, 2),
    bairro CHAR(10)
);

CREATE TABLE dim_veiculo (
    numero_chassi CHAR(30) PRIMARY KEY,
    modelo CHAR(10),
    data_inicio_fabricacao DATE,
    data_fim_fabricacao DATE,
    valor_compra DECIMAL(15, 2)
);

CREATE TABLE dim_tempo (
    data DATE PRIMARY KEY,
    dia INT,
    mes INT,
    ano INT,
    trimestre INT
);

CREATE TABLE fato_vendas (
    venda_id INT AUTO_INCREMENT PRIMARY KEY,
    cgc_loja CHAR(12),
    cpf CHAR(12),
    numero_chassi CHAR(30),
    data_venda DATE,
    valor_venda DECIMAL(15, 2),
    valor_imposto DECIMAL(15, 2),
    FOREIGN KEY (cgc_loja) REFERENCES dim_loja(cgc_loja),
    FOREIGN KEY (cpf) REFERENCES dim_cliente(cpf),
    FOREIGN KEY (numero_chassi) REFERENCES dim_veiculo(numero_chassi)
);


INSERT INTO dim_loja (cgc_loja, nome, endereco, cidade, estado, pais) VALUES
('LOJA001', 'Loja Central', 'Rua A, 123', 'Cidade A', 'SP', 'Brasil'),
('LOJA002', 'Loja Norte', 'Rua B, 456', 'Cidade B', 'RJ', 'Brasil');

INSERT INTO dim_cliente (cpf, nome, endereco, cidade, estado, renda, bairro) VALUES
('12345678901', 'Cliente 1', 'Rua X, 10', 'Cidade A', 'SP', 5000.00, 'Bairro 1'),
('23456789012', 'Cliente 2', 'Rua Y, 20', 'Cidade B', 'RJ', 7000.00, 'Bairro 2');

INSERT INTO dim_veiculo (numero_chassi, modelo, data_inicio_fabricacao, data_fim_fabricacao, valor_compra) VALUES
('CHASSI001', 'Modelo A', '2022-01-01', '2022-12-31', 30000.00),
('CHASSI002', 'Modelo B', '2022-01-01', '2022-12-31', 25000.00);

INSERT INTO dim_tempo (data, dia, mes, ano, trimestre) VALUES
('2024-01-01', 1, 1, 2024, 1),
('2024-01-15', 15, 1, 2024, 1),
('2024-02-01', 1, 2, 2024, 1);

INSERT INTO fato_vendas (cgc_loja, cpf, numero_chassi, data_venda, valor_venda, valor_imposto) VALUES
('LOJA001', '12345678901', 'CHASSI001', '2024-01-01', 31000.00, 3000.00),
('LOJA002', '23456789012', 'CHASSI002', '2024-01-15', 26000.00, 2600.00),
('LOJA001', '12345678901', 'CHASSI002', '2024-02-01', 28000.00, 2800.00);

-- 1. Total das vendas de uma determinada loja, num determinado período
SELECT 
    l.nome AS loja, 
    SUM(v.valor_venda) AS total_vendas
FROM 
    fato_vendas v
JOIN 
    dim_loja l ON v.cgc_loja = l.cgc_loja
WHERE 
    v.data_venda BETWEEN '2024-01-01' AND '2024-12-31' -- exemplo de período
GROUP BY 
    l.nome;

-- 2. Lojas que mais venderam num determinado período
SELECT 
    l.nome AS loja, 
    SUM(v.valor_venda) AS total_vendas
FROM 
    fato_vendas v
JOIN 
    dim_loja l ON v.cgc_loja = l.cgc_loja
WHERE 
    v.data_venda BETWEEN '2024-01-01' AND '2024-12-31' -- exemplo de período
GROUP BY 
    l.nome
ORDER BY 
    total_vendas DESC;

-- 3. Lojas que menos venderam num determinado período
SELECT 
    l.nome AS loja, 
    SUM(v.valor_venda) AS total_vendas
FROM 
    fato_vendas v
JOIN 
    dim_loja l ON v.cgc_loja = l.cgc_loja
WHERE 
    v.data_venda BETWEEN '2024-01-01' AND '2024-12-31' -- exemplo de período
GROUP BY 
    l.nome
ORDER BY 
    total_vendas ASC;

-- 4. Perfil de clientes que devem-se investir (exemplo: clientes com maior renda que realizaram compras)
SELECT 
    c.nome AS cliente,
    c.renda,
    COUNT(v.venda_id) AS total_compras
FROM 
    dim_cliente c
JOIN 
    fato_vendas v ON c.cpf = v.cpf
GROUP BY 
    c.cpf, c.nome, c.renda
HAVING 
    COUNT(v.venda_id) > 1
ORDER BY 
    c.renda DESC;

-- 5. Veículos de maior aceitação numa determinada região (exemplo: por cidade)
SELECT 
    tb_v.modelo,
    l.cidade,
    COUNT(v.numero_chassi) AS total_vendas
FROM 
    fato_vendas v
JOIN 
    dim_loja l ON v.cgc_loja = l.cgc_loja
INNER JOIN dim_veiculo AS tb_v
GROUP BY 
    tb_v.modelo, l.cidade
ORDER BY 
    total_vendas DESC;

