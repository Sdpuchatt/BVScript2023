--DEFINICION DE PARÁMETROS DE BÚSQUEDA
DECLARE @BUSQUEDA VARCHAR(155) = '%60000%' --> SOLO REEMPLAZAR LA PALABRA "12345" (¡¡DEJAR LOS PORCENTAJES!!)

--BUSQUEDA

    --EN CONCEPTOS
        SELECT 
        SJCCOH_CODCPT AS 'CONCEPTO', 
        SJCCOH_DESCRP AS 'DESCRIPCION', 
        SJCCOH_FORPLA AS 'FOR. PLANILLA', 
        SJCCOH_FORVBS AS 'FOR. VBS', 
        SJCCOH_FORASO AS 'FOR. ASOCIADA', 
        SJCCOH_VIGHAS AS 'VIGENCIA HASTA', 
        ISNULL((SELECT DISTINCT 'S' FROM SJCCOA WHERE SJCCOA_CODCPT = SJCCOH_CODCPT AND SJCCOA_ACUMUL = 'S'),'N') AS 'TIENE ACUMULADORES', 
        ISNULL((SELECT DISTINCT 'S' FROM SJCCOH WHERE SJCCOH_FORPLA LIKE SJCCOH_CODCPT OR SJCCOH_FORVBS LIKE SJCCOH_CODCPT OR SJCCOH_FORASO LIKE SJCCOH_CODCPT),'N') AS 'APARECE EN CONCEPTOS',
        ISNULL((SELECT DISTINCT 'S' FROM SJTFOH INNER JOIN SJCCOH ON SJCCOH_FORASO = SJTFOH_CODIGO WHERE SJTFOH_FORVBS LIKE @BUSQUEDA),'N') 'APARECE EN FORMULAS'
        FROM SJCCOH 
        WHERE SJCCOH_CODCPT NOT LIKE @BUSQUEDA
        AND (SJCCOH_FORPLA LIKE @BUSQUEDA OR SJCCOH_FORVBS LIKE @BUSQUEDA OR SJCCOH_FORASO LIKE @BUSQUEDA)

    --EN FORMULAS
        SELECT
        SJTFOH_CODIGO AS 'CODIGO FORMULA', 
        SJTFOH_DESCRP AS 'DESCRIPCION', 
        SJTFOH_FORVBS AS 'FORMULA', 
        SJCCOH_CODCPT 'CONCEPTO', 
        SJCCOH_DESCRP 'DESCRIPCION', 
        SJCCOH_VIGHAS 'VIGENCIA HASTA', 
        ISNULL((SELECT DISTINCT 'S' FROM SJCCOA WHERE SJCCOA_CODCPT = SJCCOH_CODCPT AND SJCCOA_ACUMUL = 'S'),'N') AS 'TIENE ACUMULADORES', 
        ISNULL((SELECT DISTINCT 'S' FROM SJCCOH WHERE SJCCOH_FORPLA LIKE SJCCOH_CODCPT OR SJCCOH_FORVBS LIKE SJCCOH_CODCPT OR SJCCOH_FORASO LIKE SJCCOH_CODCPT),'N') AS 'APARECE EN CONCEPTOS',
        ISNULL((SELECT DISTINCT 'S' FROM SJTFOH INNER JOIN SJCCOH ON SJCCOH_FORASO = SJTFOH_CODIGO WHERE SJTFOH_FORVBS LIKE @BUSQUEDA),'N') 'APARECE EN FORMULAS'
        FROM SJTFOH
        INNER JOIN SJCCOH ON SJCCOH_FORASO = SJTFOH_CODIGO
        WHERE SJCCOH_CODCPT NOT LIKE @BUSQUEDA
        AND SJTFOH_FORVBS LIKE @BUSQUEDA