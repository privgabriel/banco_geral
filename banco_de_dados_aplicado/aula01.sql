CREATE DATABASE banco_de_dados_aplicado;

CREATE TABLE cidades (
    id serial,
    nome varchar(40),
    primary key (id)
);

CREATE TABLE departamentos (
    id serial,
    descricao varchar(30),
    primary key (id)
);

CREATE TABLE funcionarios (
    id serial,
    nome varchar(40),
    dept_id int,
    cidade_id int,
    primary key (id),
    foreign key (dept_id) references departamentos(id),
    foreign key (cidade_id) references cidades(id)
);
SELECT * FROM cidades;

INSERT INTO cidades (nome) VALUES ('Pelotas');
INSERT INTO cidades (nome) VALUES ('Porto Alegre');
INSERT INTO cidades (nome) VALUES ('São Paulo');
INSERT INTO cidades (nome) VALUES ('Rio de Janeiro');


INSERT INTO departamentos (descricao) VALUES ('Financeiro');
INSERT INTO departamentos (descricao) VALUES ('Contábil');
INSERT INTO departamentos (descricao) VALUES ('TI');

INSERT INTO funcionarios (nome, dept_id, cidade_id) VALUES ('José', 1, 1);
INSERT INTO funcionarios (nome, dept_id, cidade_id) VALUES ('Maria', 2, 3);
INSERT INTO funcionarios (nome, dept_id, cidade_id) VALUES ('Pedro', 1, 4);
INSERT INTO funcionarios (nome, dept_id, cidade_id) VALUES ('Ana', 2, 1);