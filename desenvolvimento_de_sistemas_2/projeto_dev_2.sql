CREATE DATABASE gerenciamento_financeiro;

CREATE TABLE user_data(
    id serial PRIMARY KEY,
    nome varchar(50),
    salario float
);

INSERT INTO user_data(nome, salario) VALUES ('Gabriel Santos', 10000000);

SELECT * FROM user_data;

CREATE TABLE expenses(
    id serial PRIMARY KEY,
    user_data_id int REFERENCES user_data(id),
    descricao varchar(100),
    valor float,
    data date,
    categoria_id int REFERENCES categories(id)
);

INSERT INTO expenses(user_data_id, descricao, valor, data, categoria_id) VALUES (7, 'Almoço', 204, '2021-01-01', 2);

CREATE TABLE categories(
    id serial PRIMARY KEY,
    descricao varchar(100)
);

INSERT INTO categories(descricao) VALUES ('Carro');

CREATE TABLE income_categories(
    id serial PRIMARY KEY,
    descricao varchar(100)
);

INSERT INTO income_categories(descricao) VALUES ('Investimento');

CREATE TABLE financial_goals(
    id serial PRIMARY KEY,
    user_data_id int REFERENCES user_data(id),
    descricao varchar(100),
    valor_esperado float,
    data_limite date,
    status varchar(20) DEFAULT 'Em Progresso'
);

INSERT INTO financial_goals(user_data_id, descricao, valor_esperado, data_limite) VALUES (7, 'Comprar um carro', 20000, '2022-01-01');

CREATE TABLE recurring_transactions(
    id serial PRIMARY KEY,
    user_data_id int REFERENCES user_data(id),
    descricao varchar(100),
    valor float,
    data_inicio date,
    frequencia varchar(20), -- Exemplo: 'Mensal', 'Semanal', 'Anual'
    categoria_id int REFERENCES categories(id),
    tipo varchar(10) CHECK (tipo IN ('Despesa', 'Receita'))
);

INSERT INTO recurring_transactions(user_data_id, descricao, valor, data_inicio, frequencia, categoria_id, tipo) VALUES (7, 'Aluguel', 500, '2021-01-01', 'Mensal', 2, 'Despesa');

CREATE TABLE notifications(
    id serial PRIMARY KEY,
    user_data_id int REFERENCES user_data(id),
    mensagem varchar(255),
    data date,
    lida boolean DEFAULT false
);

INSERT INTO notifications(user_data_id, mensagem, data) VALUES (7, 'Você tem uma nova despesa', '2021-01-01');

CREATE TABLE user_settings(
    id serial PRIMARY KEY,
    user_data_id int REFERENCES user_data(id),
    preferencia_idioma varchar(10),
    moeda varchar(10),
    notificacoes_ativas boolean DEFAULT true
);

INSERT INTO user_settings(user_data_id, preferencia_idioma, moeda) VALUES (7, 'pt-br', 'BRL');


CREATE TABLE income(
    id serial PRIMARY KEY,
    user_data_id int REFERENCES user_data(id),
    descricao varchar(100),
    valor float,
    data date,
    categoria_id int REFERENCES income_categories(id)
);

INSERT INTO income(user_data_id, descricao, valor, data, categoria_id) VALUES (7, 'Salário', 1000, '2021-01-01', 2);
