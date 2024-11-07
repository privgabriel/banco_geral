SELECT * FROM pg_language;

CREATE FUNCTION Soma(int, int) RETURNS int AS
'
    SELECT $1 + $2;
'
    LANGUAGE SQL;

SELECT Soma(1,2);
SELECT * FROM funcionarios;
DROP FUNCTION Soma(int, int);


CREATE FUNCTION BuscarFuncionarios(p_dept_id INT)
RETURNS TABLE (
    descricao VARCHAR(40),
    nome_funcionario VARCHAR(40),
    nome_cidade VARCHAR(40)
) AS
$$
BEGIN
    RETURN QUERY
    SELECT
        d.descricao AS descricao,
        f.nome AS nome_funcionario,
        c.nome AS nome_cidade
    FROM
        funcionarios AS f
    JOIN departamentos AS d ON f.dept_id = d.id
    JOIN cidades AS c ON f.cidade_id = c.id
    WHERE
        d.id = p_dept_id
    ORDER BY
        d.descricao;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM buscarfuncionarios(1);

CREATE FUNCTION TotalFuncionariosCidade(p_cidade_nome varchar) RETURNS INT AS
'
    SELECT COUNT(*) AS total
    FROM funcionarios AS f
    JOIN cidades AS c ON f.cidade_id = c.id
    WHERE c.nome like $1;
'
LANGUAGE SQL;

CREATE FUNCTION TotalFuncionariosCidadesNomes()
    RETURNS TABLE
            (
                cidade_nome VARCHAR(40),
                total       INT
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT c.nome                          AS cidade_nome,
               TotalFuncionariosCidade(c.nome) AS total
        FROM cidades AS c
        ORDER BY c.nome;
END;
$$
    LANGUAGE plpgsql;

SELECT * FROM TotalFuncionariosCidadesNomes();

DROP FUNCTION TotalFuncionariosCidadesNomes(varchar);
