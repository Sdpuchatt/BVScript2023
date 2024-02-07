'analisis para el legajo 3161

--REMUNE
SELECT SUM( CASE SUBSTRING(SJRMVI_TIPCPT,1,1) WHEN 'H' THEN   SJRMVI_CALCUL
 ELSE 0 END) FROM SJRMVI WHERE 
SJRMVI_NROLEG = 3161
 AND SJRMVI_PERIOD = 202401 AND SJRMVI_CLAEMP= 'J'
 AND (SELECT SJRMVH_CIERRE FROM SJRMVH WHERE SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_NROLEG = SJRMVI_NROLEG) = 'S' AND SJRMVI_CODFOR = 'L'


 --REMUNE2
 SELECT * FROM SJRMVI;
SELECT SUM(CASE SUBSTRING(SJRMVI_TIPCPT,1,1) WHEN 'E' THEN  SJRMVI_CALCUL 
 ELSE 0 END) FROM SJRMVI WHERE 
 SJRMVI_NROLEG = 3161
  AND SJRMVI_PERIOD = 202401
 AND SJRMVI_CLAEMP= 'J'
 AND (SELECT SJRMVH_CIERRE FROM SJRMVH WHERE SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_NROLEG = SJRMVI_NROLEG) = 'S' AND SJRMVI_CODFOR = 'L'

--IMPO2 
SELECT SJRMVI_CODCPT ,(CASE SJRMVI_CODCPT WHEN '90101' THEN   SJRMVI_CALCUL
WHEN '90100' THEN SJRMVI_CALCUL
WHEN '90104' THEN SJRMVI_CALCUL
WHEN '90106' THEN SJRMVI_CALCUL
WHEN '90105' THEN SJRMVI_CALCUL
WHEN '90107' THEN SJRMVI_CALCUL
WHEN '90063' THEN SJRMVI_CALCUL
ELSE 0 END) FROM SJRMVI WHERE
SJRMVI_NROLEG = 3161
AND SJRMVI_PERIOD = 202401
 AND SJRMVI_CLAEMP= 'J'
AND (SELECT SJRMVH_CIERRE FROM SJRMVH WHERE SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_NROLEG = SJRMVI_NROLEG) = 'S' AND SJRMVI_CODFOR = 'L'


--IMPO1
SELECT SUM(CASE SJRMVI_CODCPT WHEN '50064' THEN   SJRMVI_CALCUL
WHEN '50150' THEN SJRMVI_CALCUL
WHEN '50155' THEN SJRMVI_CALCUL
WHEN '50160' THEN SJRMVI_CALCUL
WHEN '50250' THEN SJRMVI_CALCUL
WHEN '50260' THEN SJRMVI_CALCUL
WHEN '50400' THEN SJRMVI_CALCUL
WHEN '50420' THEN SJRMVI_CALCUL
WHEN '50270' THEN SJRMVI_CALCUL
ELSE 0 END) FROM SJRMVI WHERE
SJRMVI_NROLEG = 3161
 AND SJRMVI_CLAEMP= 'J'
AND SJRMVI_PERIOD = 202401
AND (SELECT SJRMVH_CIERRE FROM SJRMVH WHERE SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_NROLEG = SJRMVI_NROLEG) = 'S' AND SJRMVI_CODFOR = 'L'

--3161

--BÚSQUEDA DE LIQUIDACIÓN (HEADER)
SELECT SJRMVH_CODFOR, SJRMVH_PERIOD, SJRMVH_TIPLIQ, SJRMVH_NROLEG, SJRMVH_CLAEMP, SJRMVH_CIERRE, SJRMVH_FECALT FROM SJRMVH 
WHERE SJRMVH_PERIOD = 202401
--AND SJRMVH_TIPLIQ = 'TIPLIQ' 
AND SJRMVH_NROLEG = 3161


--CONSULTA DETALLE DE LIQUIDACIÓN (ÍTEM)
SELECT  SJRMVI_CODCPT, SJCCOH_DESCRP, SJRMVI_CALCUL, SJRMVI_INFORM, SJRMVI_DIAINF, SJRMVI_HORINF, SJRMVH_CIERRE, SJRMVI_FECALT FROM SJRMVI 
INNER JOIN SJRMVH ON SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROLEG = SJRMVI_NROLEG
INNER JOIN SJCCOH ON SJCCOH_CODCPT = SJRMVI_CODCPT
WHERE SJRMVI_NROLEG = 3161 AND SJRMVI_TIPLIQ = 'ANT' AND SJRMVI_PERIOD = 202401
AND SJRMVH_CIERRE = 'S' --Liquidación Abierta/Cerrada
ORDER BY SJRMVI_CODCPT

--2.435.850.00