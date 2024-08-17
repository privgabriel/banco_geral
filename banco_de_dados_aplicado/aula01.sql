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

