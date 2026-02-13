SELECT
    C.Nome,
    C.Telefone,
    C.Celular,
    C.Email,
    C2.NOME AS CIDADE,
    u.Nome as UF
FROM
    cmsl_prod.Clientes C
    LEFT JOIN cmsl_prod.Cidades C2 ON C2.ID = C.IDCIDADE
    LEFT JOIN cmsl_prod.Ufs u on u.Id = C2.IdUF 
WHERE
    EXISTS (
        SELECT 1
        FROM cmsl_prod.Bilhetes B
        WHERE B.IDCLIENTE = C.ID
          AND B.IDCONCURSO = 73
    )
    AND EXISTS (
        SELECT 1
        FROM cmsl_prod.Bilhetes B
        WHERE B.IDCLIENTE = C.ID
          AND B.IDCONCURSO = 74
    )
    AND NOT EXISTS (
        SELECT 1
        FROM cmsl_prod.Bilhetes B
        WHERE B.IDCLIENTE = C.ID
          AND B.IDCONCURSO = 75
    );

