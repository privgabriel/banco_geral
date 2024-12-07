CREATE DATABASE projeto_g2;



CREATE TABLE dim_paciente (
    paciente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    dt_nascimento DATE,
    genero CHAR(1),
    endereco VARCHAR(255),
    fumante BOOLEAN,
    numero_contato VARCHAR(20),
    dt_registro DATE DEFAULT CURRENT_TIMESTAMP,
    dt_saida DATE DEFAULT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    regiao VARCHAR(2)
);

ALTER TABLE dim_paciente ADD COLUMN endereco_atual BOOLEAN;

SELECT * FROM dim_paciente;

INSERT INTO dim_paciente (nome, dt_nascimento, genero, endereco, fumante, numero_contato, regiao, endereco_atual) VALUES
('Paciente A', '1990-01-01', 'M', 'Rua A, 123', TRUE, '123456789', 'SP', TRUE),
('Paciente B', '1995-01-01', 'F', 'Rua B, 456', FALSE, '987654321', 'RJ', TRUE),
('Paciente C', '2000-01-01', 'M', 'Rua C, 789', TRUE, '123123123', 'MG', TRUE);
SELECT * FROM dim_paciente WHERE regiao = 'SP';
INSERT INTO dim_paciente

SELECT * FROM dim_paciente;

DROP TABLE fato_registro_medico;

-- MAPEAMENTO Registros Médicos
CREATE TABLE fato_registro_medico (
    registro_id SERIAL PRIMARY KEY,
    paciente_id INT,
    diagnóstico_code VARCHAR(10),
    tratamento_id INT,
    doutor_id INT,
    dt_visita DATE,
    gravidade INT,
    dt_id INT,
    custo FLOAT,
    saida BOOLEAN,
    FOREIGN KEY (paciente_id) REFERENCES dim_paciente(paciente_id),
    FOREIGN KEY (tratamento_id) REFERENCES dim_tratamento(tratamento_id),
    FOREIGN KEY (doutor_id) REFERENCES dim_doutor(doutor_id),
    FOREIGN KEY (dt_id) REFERENCES dim_data(data_id)
);

INSERT INTO fato_registro_medico (paciente_id, diagnóstico_code, tratamento_id, doutor_id, dt_visita, gravidade, dt_id, custo, saida) VALUES
(1, 'D001', 1, 1, '2021-01-01', 1, 1, 100.00, TRUE),
(2, 'D002', 2, 2, '2021-01-02', 2, 2, 200.00, TRUE),
(3, 'D003', 3, 3, '2021-01-03', 3, 3, 300.00, TRUE);

SELECT * FROM fato_registro_medico;

CREATE TABLE dim_tratamento (
    tratamento_id SERIAL PRIMARY KEY,
    tipo_tratamento VARCHAR(100),
    ativo BOOLEAN,
    dt_inicio DATE,
    dt_fim DATE DEFAULT NULL
);

INSERT INTO dim_tratamento (tipo_tratamento, ativo, dt_inicio) VALUES
('Tratamento A', TRUE, '2021-01-01'),
('Tratamento B', TRUE, '2021-01-01'),
('Tratamento C', TRUE, '2021-01-01');

SELECT * FROM dim_tratamento;

CREATE TABLE dim_doutor (
    doutor_id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    especialidade VARCHAR(100),
    tempo_experiencia INT,
    hospital_atual VARCHAR(100)
);

INSERT INTO dim_doutor (nome, especialidade, tempo_experiencia, hospital_atual) VALUES
('Doutor A', 'Especialidade A', 1, 'Hospital A'),
('Doutor B', 'Especialidade B', 2, 'Hospital B'),
('Doutor C', 'Especialidade C', 3, 'Hospital C');

SELECT * FROM dim_doutor;

CREATE TABLE dim_diagnostico (
    diagnóstico_code VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100),
    fator_risco VARCHAR(100)
);

SELECT * FROM dim_diagnostico;

INSERT INTO dim_diagnostico (diagnóstico_code, nome, fator_risco) VALUES
('D001', 'Diagnóstico A', 'Fator de risco A'),
('D002', 'Diagnóstico B', 'Fator de risco B'),
('D003', 'Diagnóstico C', 'Fator de risco C');

SELECT * FROM dim_diagnostico;


CREATE TABLE dim_data (
    data_id SERIAL PRIMARY KEY,
    data DATE,
    dia_semana VARCHAR(20),
    mes VARCHAR(20),
    ano INT
);

INSERT INTO dim_data (data, dia_semana, mes, ano) VALUES
('2021-01-01', 'Sexta-feira', 'Janeiro', 2021),
('2021-01-02', 'Sábado', 'Janeiro', 2021),
('2021-01-03', 'Domingo', 'Janeiro', 2021);

SELECT * FROM dim_data;

-- Total de Pacientes Ativos
SELECT COUNT(*) AS total_pacientes_ativos
FROM dim_paciente
WHERE ativo = TRUE;

-- Total de Tratamentos em Curso
SELECT COUNT(*) AS total_tratamentos_ativos
FROM dim_tratamento
WHERE ativo = TRUE;


-- Total de Visitas Médicas
SELECT COUNT(*) AS total_visitas
FROM fato_registro_medico;

-- Gravidade Total das Consultas
SELECT SUM(gravidade) AS gravidade_total
FROM fato_registro_medico;


-- Número Total de Consultas Bem-Sucedidas
SELECT COUNT(*) AS consultas_sucesso
FROM fato_registro_medico
WHERE saida = TRUE;


-- Custo Total de Tratamentos Realizados
SELECT SUM(ft.custo) AS custo_total_tratamentos
FROM dim_tratamento
INNER JOIN fato_registro_medico AS ft
ON ft.tratamento_id = dim_tratamento.tratamento_id
WHERE ativo = TRUE;


-- Total de Consultas por Médico
SELECT d.nome AS medico, COUNT(f.registro_id) AS total_consultas
FROM fato_registro_medico f
JOIN dim_doutor d ON f.doutor_id = d.doutor_id
GROUP BY d.nome;


-- Total de Consultas por Diagnóstico
SELECT dg.nome AS diagnostico, COUNT(f.registro_id) AS total_consultas
FROM fato_registro_medico f
JOIN dim_diagnostico dg ON f.diagnóstico_code = dg.diagnóstico_code
GROUP BY dg.nome;


-- Total de Pacientes Fumantes
SELECT COUNT(*) AS total_fumantes
FROM dim_paciente
WHERE fumante = TRUE;


-- Total de Consultas por Dia
SELECT dd.data AS dia, COUNT(f.registro_id) AS total_consultas
FROM fato_registro_medico f
JOIN dim_data dd ON f.dt_id = dd.data_id
GROUP BY dd.data;

-- Qual é o custo total dos tratamentos por região e ano?
SELECT
    p.regiao,
    d.ano,
    SUM(f.custo) AS custo_total
FROM fato_registro_medico f
JOIN dim_paciente p ON f.paciente_id = p.paciente_id
JOIN dim_tratamento t ON f.tratamento_id = t.tratamento_id
JOIN dim_data d ON f.dt_id = d.data_id
GROUP BY p.regiao, d.ano
ORDER BY p.regiao, d.ano;

-- Quantos pacientes fumantes foram tratados para cada diagnóstico de alto risco?
SELECT
    dg.nome AS diagnostico,
    COUNT(DISTINCT f.paciente_id) AS total_pacientes_fumantes
FROM fato_registro_medico f
JOIN dim_paciente p ON f.paciente_id = p.paciente_id
JOIN dim_diagnostico dg ON f.diagnóstico_code = dg.diagnóstico_code
WHERE p.fumante = TRUE AND dg.fator_risco = 'Fator de risco A'
GROUP BY dg.nome
ORDER BY total_pacientes_fumantes DESC;

-- Quais médicos têm a maior taxa de sucesso em tratamentos?
SELECT
    d.nome AS medico,
    d.especialidade,
    COUNT(CASE WHEN f.saida = TRUE THEN 1 END) * 100.0 / COUNT(f.registro_id) AS taxa_sucesso
FROM fato_registro_medico f
JOIN dim_doutor d ON f.doutor_id = d.doutor_id
GROUP BY d.nome, d.especialidade
ORDER BY taxa_sucesso DESC
LIMIT 10; -- Mostra os 10 médicos com maior taxa de sucesso

-- Implementar lógica para mudanças no endereço SCD TIPO 2
UPDATE dim_paciente
SET dt_saida = CURRENT_DATE,
    endereco_atual = FALSE
WHERE paciente_id = ? AND endereco_atual = TRUE;

-- Inserir novo registro com endereço atualizado
INSERT INTO dim_paciente (nome, dt_nascimento, genero, endereco, fumante, numero_contato, regiao, dt_registro, dt_saida, ativo, endereco_atual)
VALUES ('Paciente A', '1990-01-01', 'M', 'Rua Nova, 123', TRUE, '123456789', 'SP', CURRENT_DATE, NULL, TRUE, TRUE);


-- Descreva o processo de extração e transformação dos dados para o data warehouse.
-- O processo de ETL (Extract, Transform, Load) é responsável por extrair dados de diferentes fontes, transformá-los e carregá-los em um data warehouse. Nesse caso, nós analisamos as tabelas da atividade, e montamos as tabelas dimensões e fatos com os dados necessários.

-- Explique como as métricas aditivas (ex.: custo total de tratamentos) serão calculadas.
-- Métricas aditivas são aquelas que podem ser somadas, como o custo total de tratamentos. No caso do código acima, por meio de selects nós fizemos diversas analsises, como por exemplo, o custo total de tratamentos realizados, que é a soma do custo de todos os tratamentos realizados.


