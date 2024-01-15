A = "'"
NROLEG = A&LEGAJO.NROLEG&A
PERACT = CSTR(LEGAJO.PERACT)
CLASE = LEGAJO.CONCEPTO("VLIQ_CLAEMP")
FECHA_LIQ_FINAL = A&LEGAJO.CONCEPTO("CPT_00099")&A 'Si tuvo una liquidación FINAL en el período, quiere decir que volvió a ingresar en el mismo. Así que calculo todo a partir de su nuevo ingreso sin tomar lo liquidado hasta la liquidación FINAL.

'Según Tk. 10481,11433 se vuelve a normalizar el calculo de vacaciones

'Según Tk. 9864 y 9612 se agrega filtro para no tener cuenta vacaciones anteriores liquidadas para Mensuales Rawson
'IF (CLASE = "MR") THEN
'    FILTRO_VACACIONES = " AND SJRMVH_TIPLIQ NOT IN ('VAC', 'VACJ', 'VACJC') "
'ELSE
'    FILTRO_VACACIONES = " "
'END IF

SSQL = " SELECT ISNULL(SUM(SJRMVI_CALCUL),0) FROM SJRMVI "
SSQL = SSQL + " INNER JOIN SJRMVH ON SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_NROLEG = SJRMVI_NROLEG  "
SSQL = SSQL + " WHERE SJRMVH_PERIOD = "&PERACT
SSQL = SSQL + " AND SJRMVH_NROLEG = "&NROLEG
'SSQL = SSQL + FILTRO_VACACIONES
SSQL = SSQL + " AND SJRMVI_CODCPT = 50250 AND SJRMVI_TIPLIQ NOT IN ('SAC')"
SSQL = SSQL + " AND SJRMVH_CIERRE = 'S' "
SSQL = SSQL + " AND SJRMVH_FECALT >= "&FECHA_LIQ_FINAL
RESULT = QUERYEXEC(CSTR(SSQL)) 