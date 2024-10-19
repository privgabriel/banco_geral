# Correção Avaliação 1
CREATE OR REPLACE FUNCTION contar_alunos_por_curso() 

RETURNS TABLE ( 

  nome_curso VARCHAR, 

  qtd_alunos INTEGER 

) AS $$ 

BEGIN 

  RETURN QUERY 

  SELECT 

    c.nome AS nome_curso, 

    COUNT(m.matricula) AS qtd_alunos 

  FROM 

    cursos c 

  LEFT JOIN 

    matriculas m ON c.codigo = m.codigo 

  GROUP BY 

    c.nome; 

END; 

$$ LANGUAGE plpgsql;

