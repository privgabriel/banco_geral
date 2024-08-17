CREATE DATABASE gerencimanto_de_tarefas;

CREATE TABLE usuarios (
    id serial,
    nome varchar(40),
    email varchar(40),
    senha varchar(40),
    primary key (id)
);

CREATE TABLE categorias (
    id serial,
    descricao varchar(40),
    primary key (id)
);

CREATE TABLE tarefas (
    id serial,
    descricao varchar(40),
    usuario_id int,
    categoria_id int,
    primary key (id),
    foreign key (usuario_id) references usuarios(id),
    foreign key (categoria_id) references categorias(id)
);

INSERT INTO usuarios (nome, email, senha) VALUES ('José', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('Maria', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('Pedro', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('João', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('MAquiavel', 'exemple@exemple.com', '123');

INSERT INTO categorias (descricao) VALUES ('Trabalho');
INSERT INTO categorias (descricao) VALUES ('Estudo');
INSERT INTO categorias (descricao) VALUES ('Lazer');
INSERT INTO categorias (descricao) VALUES ('Casa');
INSERT INTO categorias (descricao) VALUES ('Outros');

INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar SQL', 1, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar Python', 2, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar Java', 3, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar PHP', 4, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar Ruby', 5, 2);

