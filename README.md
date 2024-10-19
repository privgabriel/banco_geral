# banco_geral
1) Vantagens de Stored Procedures:
1. Desempenho: São compiladas e otimizadas, executando mais rápido.
2. Reuso de código: Centralizam a lógica de negócio, evitando duplicação.
3. Segurança: Restringem acesso direto às tabelas.
4. Menos tráfego de rede: Reduzem envios repetidos de queries.
5. Controle transacional: Facilita agrupamento de operações em transações.
Desvantagens de Stored Procedures:
1. Dependência do banco: Difícil migrar para outro SGBD.
2. Difícil de depurar: Ferramentas de depuração são limitadas.
3. Manutenção complexa: Lógica de negócio no banco dificulta mudanças.
4. Impacto na performance: Podem sobrecarregar o servidor com muita lógica.
5. Versionamento complicado: Falta de ferramentas de controle de versão.
2)
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
3)
• Lógica mais complexa: Suporta loops e condicionais.
• Melhor performance: Reduz o tráfego entre cliente e servidor.
• Manutenção centralizada: Lógica de negócio no banco de dados.
• Tratamento de exceções: Controle de erros diretamente no banco.
• Transações eficientes: Facilita rollback/commit de múltiplas etapas.
4)
• CREATE OR REPLACE PROCEDURE FAZ_ALGO( X INTEGER, OUT Y REAL)
AS $$:
• Está criando ou substituindo um procedimento chamado FAZ_ALGO.
• Ele aceita um parâmetro de entrada X (do tipo INTEGER) e retorna um valor de
saída Y (do tipo REAL).
• DECLARE subtotal ALIAS FOR $1;:
• Declara uma variável subtotal, que é um alias para o primeiro parâmetro
passado na chamada do procedimento.
• No caso, $1 corresponde ao valor de X, mas como X já foi declarado no
cabeçalho, esta linha é desnecessária e confusa, podendo ser removida.
• BEGIN:
• Início do bloco de execução da lógica do procedimento.
• Y := subtotal + subtotal * 0.05;:
• Esta linha tenta atribuir à variável Y o valor de subtotal somado a 5% de
subtotal.
• Erro: O alias subtotal foi declarado incorretamente. Em vez de usar subtotal,
deveria usar o parâmetro X, pois ele já foi passado na definição da procedure.
• END;:
• Fim do bloco do procedimento.
• $$ LANGUAGE plpgsql;:
• Indica que o código entre $$ será escrito em PL/pgSQL.
• SELECT FAZ_ALGO(100);:
• Erro: FAZ_ALGO é um procedimento, não uma função, e procedimentos não
podem ser chamados diretamente em um SELECT. Em vez disso, seria
necessário usar a sintaxe CALL para invocar o procedimento.
Erros identificados e como corrigir:
1. Uso de subtotal: O alias subtotal está incorreto, pois o parâmetro já foi
declarado como X. Basta usar X diretamente.
Correção: Substituir subtotal por X na linha do cálculo.
Chamada do procedimento: A chamada do procedimento FAZ_ALGO com SELECT
está incorreta. Como é um procedimento, deve ser usado o comando CALL.
Correção: Mudar a chamada para CALL.
5)
Resumo:
Característica Função Procedimento
Retorno de valor Sempre retorna um valor Não retorna valor
diretamente
Chamada SELECT ou em expressões
SQL Usado com CALL
Modificação de
dados
Limitada (pode, mas não é
comum)
Adequado para modificar
dados
Transações Não gerencia transações Pode gerenciar transações
Uso em triggers Sim Não
Parâmetros de
saída Apenas um valor Múltiplos via OUT
7)
• CREATE OR REPLACE FUNCTION nome_funcao(NUMERIC):
• Está criando (ou substituindo) uma função chamada nome_funcao.
• Ela aceita um parâmetro de entrada do tipo NUMERIC, que será usado na função.
• RETURNS SETOF VARCHAR(20):
• A função retorna um conjunto (ou seja, vários valores) do tipo VARCHAR(20).
• Cada valor retornado terá até 20 caracteres.
• DECLARE registro RECORD;:
• Declara uma variável registro do tipo RECORD. Essa variável será usada para
armazenar o resultado de cada linha retornada pela consulta SQL no loop.
• x ALIAS FOR $1;:
• Cria um alias chamado x para o primeiro parâmetro passado à função. No caso,
o parâmetro é o valor NUMERIC passado para a função, que será utilizado para
comparar salários.
• BEGIN:
• Início do bloco de execução da função.
• FOR registro IN SELECT * FROM Empregado WHERE SALARIO >= x
LOOP:
• Um loop que itera sobre todas as linhas retornadas pela query SELECT * FROM
Empregado WHERE SALARIO >= x.
• Ele seleciona todos os empregados na tabela Empregado que têm um salário
maior ou igual ao valor x (o parâmetro recebido).
• RETURN NEXT registro.nome;:
• Para cada linha (registro) resultante da query, a função retorna o valor da coluna
nome do registro.
• RETURN NEXT é usado em funções que retornam conjuntos de valores (SETOF),
retornando um valor a cada iteração do loop.
• END LOOP;:
• Fim do loop.
• RETURN;:
• Retorna o controle ao chamador. Como a função já retornou todos os valores
dentro do loop com RETURN NEXT, este RETURN é apenas para encerrar a
função de forma limpa.
• $$ LANGUAGE plpgsql;:
• Indica que o corpo da função é escrito em PL/pgSQL.
