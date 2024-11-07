CREATE TABLE funcionarios_testIF(
    id int not null primary key,
    funcionario_codigo varchar(20),
    funcionario_nome varchar(100),
    funcionario_situacao varchar(1) default 'A',
    funcionario_comissao real,
    funcionario_cargo varchar(30),
    data_criacao timestamp,
    data_atualizacao timestamp
);

INSERT INTO funcionarios_testIF(id, funcionario_codigo, funcionario_nome, funcionario_comissao, funcionario_cargo,
                                data_criacao)
VALUES ('0003', 'B', 'VINICIUS CARAVALHO', 5, 'GERENTE', '01/01/2016');

INSERT INTO funcionarios_testIF(id, funcionario_codigo, funcionario_nome, funcionario_comissao, funcionario_cargo,
                                data_criacao) VALUES ('0004', 'A', 'JOAO DA SILVA', 2, 'VENDEDOR', '01/01/2016');

SELECT * FROM funcionarios_testIF;


CREATE OR REPLACE FUNCTION RetornaNomeFuncionario(func_id int)
    RETURNS text AS
$$
DECLARE
    nome     text;
    situacao text;
BEGIN

    SELECT funcionario_nome, funcionario_situacao
    INTO nome, situacao
    FROM funcionarios_testIF
    WHERE id = func_id;

    IF situacao = 'A' THEN
        RETURN nome || ' Usuario Ativo';
    ELSE
        RETURN nome || ' Usuario Inativo';
    END IF;
END
$$
    LANGUAGE plpgsql;

SELECT RetornaNomeFuncionario(4);
DROP FUNCTION RetornaNomeFuncionario(int);


SELECT * FROM departamentos;

CREATE TABLE empregados(
    codigo serial,
    nome_emp text,
    salario int,
    departamento_cod int,
    PRIMARY KEY (codigo),
    FOREIGN KEY (departamento_cod) REFERENCES departamentos(id)
);
INSERT INTO empregados(nome_emp, salario, departamento_cod) VALUES ('JOAO', 1000, 1);

CREATE OR REPLACE FUNCTION SalariosFuncionarios(p_dept_id INT)
    RETURNS SETOF INTEGER AS $$
DECLARE
    registro RECORD;
    retval INTEGER;
BEGIN
    FOR registro IN
    SELECT * FROM empregados WHERE salario >=$1 LOOP
        RETURN NEXT registro.codigo;
    END LOOP;

    RETURN;
END;
$$
    LANGUAGE plpgsql;

SELECT * FROM SalariosFuncionarios(1000);

DROP FUNCTION SalariosFuncionarios(int);
