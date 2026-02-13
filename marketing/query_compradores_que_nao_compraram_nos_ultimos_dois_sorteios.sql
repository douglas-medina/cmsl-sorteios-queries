-- QUERY PARA OBTER OS CLIENTES QUE REALIZARAM COMPRA NOS ULTIMOS DOIS CONCURSOS, MAS NÃO REALIZARAM NO CONCURSO ATUAL.
-- Extrai automaticamente o Id do Concurso Atual validando a coluna "EhAtivo = 1" na tabela de Consursos

WITH ConsursoAtual AS (
	SELECT Id
	FROM cmsl_prod.Concursos
	WHERE EhAtivo = 1
),

UltimosConcursos AS (
	SELECT Id
	FROM cmsl_prod.Concursos
	WHERE Id < (SELECT Id FROM ConsursoAtual)
	ORDER BY Id DESC
	LIMIT 2
),

ClientesUltimosDoisConcursos AS (
	SELECT b.IdCliente
	FROM cmsl_prod.Bilhetes b
	WHERE b.IdConcurso in (SELECT Id FROM UltimosConcursos)
	GROUP BY b.IdCliente
	HAVING COUNT(DISTINCT b.IdConcurso) = 2
)

SELECT
    clientes.Nome as NOME,
    clientes.Telefone AS TELEFONE,
    clientes.Celular AS CELULAR,
    clientes.Email AS EMAIL,
    cidades.NOME AS CIDADE,
    ufs.Nome as UF
FROM ClientesUltimosDoisConcursos as cudc
JOIN cmsl_prod.Clientes as clientes on clientes.Id = cudc.IdCliente
LEFT JOIN cmsl_prod.Cidades as cidades on cidades.Id = clientes.IdCidade
LEFT JOIN cmsl_prod.Ufs as ufs on ufs.Id = cidades.IdUF
WHERE NOT EXISTS (
	SELECT 1
	FROM cmsl_prod.Bilhetes as b
	WHERE b.IdCliente = clientes.Id
		AND b.IdConcurso = (SELECT Id FROM ConsursoAtual)
)