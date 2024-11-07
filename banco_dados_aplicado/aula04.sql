CREATE TABLE ExecutivoDeCinema(
    codigo INT PRIMARY KEY,
    nome VARCHAR(100),
    patrimonio NUMERIC(10,2)
                              );

CREATE TABLE Estudio(
    nome VARCHAR(30) PRIMARY KEY,
    endereco VARCHAR(70),
    codigo_presidente INTEGER
                    REFERENCES ExecutivoDeCinema(codigo)
);

CREATE TABLE Filme(
    titulo VARCHAR(100),
    ano INT,
    duracao INT,
    colorido BOOLEAN,
    genero VARCHAR(30),
    nome_estudio VARCHAR(30) REFERENCES Estudio(nome),
    codigo_produtor INT REFERENCES ExecutivoDeCinema(codigo),
    PRIMARY KEY(titulo, ano)
);

CREATE TABLE EStrelaDeCinema(
    nome VARCHAR(50) PRIMARY KEY,
    endereco VARCHAR(70),
    sexo CHAR,
    data_nascimento DATE
);

CREATE TABLE Elenco(
    titulo_filme VARCHAR(50),
    ano_filme INT,
    nome_estrela VARCHAR(50) REFERENCES EstrelaDeCinema(nome),
    PRIMARY KEY (titulo_filme, ano_filme, nome_estrela),
    FOREIGN KEY (titulo_filme, ano_filme) REFERENCES Filme(titulo, ano)
);