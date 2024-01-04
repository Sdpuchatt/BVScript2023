20/12 creamos el nuevo concepto 8-0500 "Monto Deducción Contribución" de cálculo intermedio.
21/12 vimos lógica de Libro de Sueldos digital para el cálculo del Monto Deducción Contribución 
y fuimos creando la fórmula VBScript para el concepto en base a toda esa lógica.
Levantamos en ambiente de testeo una base de datos de producción y reabrimos la liquidación Mensual del 
legajo 45 para probarlo, y funcionó.
22/12 vimos toda la lógica de la formula y terminamos el calculo. 
En primera instancia la formula fallo por que era para liquidaciones cerradas. 
Por lo tanto agregamos la función de acumulador remunerativo de la liquidación actual. 
Luego el concepto seguía sin calcular por lo tanto usamos el sta.log para encontrar el error. 
El problema era una comilla simple en 
'tipo de liquidación'. Corregimos y probamos en testeo y funciono. 
'Agregamos la variable de concepto CONST 1 = 7003.68 
'Es importante en la creacion del concepto elegir el numero y orden del concepto.
'Siempre tiene que usar conceptos anteriores, no puede usar conceptos posteriores a el.
'Para la creacion del concepto usamos la tabla "Conceptos de sueldo".
'buscamos nuevo concepto y empezamos a a editarlo.
A = "'"
NROLEG = LEGAJO.NROLEG 'Creacion de variables 
MES = LEGAJO.CONCEPTO("VLIQ_MESLIQ") 'tenemos una herramienta de sofland para trer
ANIO = LEGAJO.CONCEPTO("VLIQ_ANOLIQ") ' los valores de la liquidacion que estamos procesando
PERIODO = LEGAJO.PERACT
TIPLIQ = LEGAJO.CONCEPTO("VLIQ_TIPLIQ")

DETRACCION = LEGAJO.CONCEPTO("VCPT_80500_CONST1") 'esta variable busca en la solapa VARIABLE DE CONCEPTO

SSQL = " SELECT SJMLGA_CODVAL FROM SJMLGA "  'aca leemos consulta de sql traemos 
SSQL = SSQL + " WHERE SJMLGA_CODATR = 'CODACT' " ' codigo de actividad del legajo
SSQL = SSQL + " AND SJMLGA_NROLEG = "&NROLEG
CODACT = QUERYEXEC(CSTR(SSQL)) ' con la funcion CSTR() transformamos el valor en un string

FECHA_INGRESO = QUERYEXEC(CSTR("SELECT SJMLGH_FCHING FROM SJMLGH WHERE SJMLGH_NROLEG = "&NROLEG))
FECHA_INGRESO = A& YEAR(FECHA_INGRESO) & RIGHT("0"&MONTH(FECHA_INGRESO),2) & RIGHT("0"&DAY(FECHA_INGRESO),2) &A
'formateamos codigo de la fecha de ingreso
PRIMER_DIA_MES = A& ANIO & MES & "01" &A 'creamos el primer dia del mes

SSQL = " SELECT DAY(EOMONTH("&PRIMER_DIA_MES&")) " 'obtenemos el ultimo dia del mes
DIAS_MES = QUERYEXEC(CSTR(SSQL)) 

ULTIMO_DIA_MES = A& ANIO & MES & DIAS_MES &A

SSQL = " SELECT ISNULL(SUM(DATEDIFF(D,NEWING,NEWEGR)+1),0) FROM "
SSQL = SSQL + " (SELECT *,"
SSQL = SSQL + " CASE WHEN SJMLGH_FCHING <= "&PRIMER_DIA_MES&" THEN "&PRIMER_DIA_MES&" ELSE SJMLGH_FCHING END AS NEWING, "
SSQL = SSQL + " CASE WHEN SJMLGH_FCHEGR >= "&ULTIMO_DIA_MES&" THEN "&ULTIMO_DIA_MES&" ELSE SJMLGH_FCHEGR END AS NEWEGR "
SSQL = SSQL + " FROM SJMLGH "
SSQL = SSQL + " WHERE SJMLGH_NROLEG = "&NROLEG
SSQL = SSQL + " AND SJMLGH_FCHING <= "&ULTIMO_DIA_MES&" AND SJMLGH_FCHEGR >= "&PRIMER_DIA_MES&") AS TABLA "
CAMPO = QUERYEXEC(CSTR(SSQL))

IF (CAMPO = 0) THEN
    'Para aquellos legajos que entraron en este mes
    IF (FECHA_INGRESO > PRIMER_DIA_MES AND FECHA_INGRESO <= ULTIMO_DIA_MES) THEN
        'Calculo la diferencia de días entre el ingreso y el último día del mes
        DIAS_TRABAJADOS = QUERYEXEC(CSTR("SELECT DATEDIFF(D,"&FECHA_INGRESO&","&ULTIMO_DIA_MES&")+1"))
    ELSE
        'El legajo trabajó todo el mes
        DIAS_TRABAJADOS = 100
    END IF
ELSE
    DIAS_TRABAJADOS = CAMPO
END IF


IF (DIAS_TRABAJADOS = 100 AND CODACT = 120) THEN ' CODACT codigo de activacion
    DETRACCION = DETRACCION*2.5
ELSE
    IF (DIAS_TRABAJADOS = 100 AND CODACT <> 120) THEN
        DETRACCION = DETRACCION
    ELSE
        IF (DIAS_TRABAJADOS <> 100 AND CODACT = 120) THEN
            DETRACCION = (DIAS_TRABAJADOS/DIAS_MES)*(DETRACCION*2.5)
        ELSE
            DETRACCION = (DIAS_TRABAJADOS/DIAS_MES)*(DETRACCION*2.5)
        END IF
    END IF
END IF

REMUNE_LIQ = LEGAJO.ACUM("REMUNE") 'Remunerativo de la liq. actual

SSQL = " SELECT SUM(CASE SUBSTRING(SJRMVI_TIPCPT,1,1) WHEN 'H' THEN SJRMVI_CALCUL "
SSQL = SSQL + " ELSE 0 END) FROM SJRMVI "
SSQL = SSQL + " INNER JOIN SJRMVH ON SJRMVH_NROLEG = SJRMVI_NROLEG AND SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_MODFOR = SJRMVI_MODFOR AND SJRMVH_CODFOR = SJRMVI_CODFOR AND SJRMVH_NROFOR = SJRMVI_NROFOR "
SSQL = SSQL + " WHERE SJRMVH_NROLEG = "&NROLEG
SSQL = SSQL + " AND SJRMVI_PERIOD = "&PERIODO
SSQL = SSQL + " AND SJRMVH_CIERRE = 'S' "
SSQL = SSQL + " AND (SJRMVI_TIPLIQ = '"&TIPLIQ&"'"
SSQL = SSQL + "      OR SJRMVI_TIPLIQ IN "
SSQL = SSQL + " (SELECT USR_LIBSUE_DATOS_TIPLIQ FROM USR_LIBSUE_DATOS "
SSQL = SSQL + "  WHERE USR_LIBSUE_DATOS_PERIODO = "&PERIODO
SSQL = SSQL + "  AND USR_LIBSUE_DATOS_PRESENTADO = 'S')) "
REMUNE_MES = QUERYEXEC(CSTR(SSQL)) 'Suma de Remunerativo de todo el mes

REMUNERATIVO = REMUNE_LIQ+REMUNE_MES

SSQL = "SELECT SJCCOV_IMPORT FROM SJCCOV WHERE SJCCOV_CODCPT = 50120 AND SJCCOV_CODVAR = 'CONST2'"
TOPEDM = QUERYEXEC(CSTR(SSQL))

IF ((REMUNERATIVO-DETRACCION) > 0 AND (REMUNERATIVO-DETRACCION) > TOPEDM) THEN
    RESULT = DETRACCION ' Result es una palabra reservada del sistema sirve para devolver el dato calculado
ELSE
    IF ((REMUNERATIVO-DETRACCION) > 0 AND (REMUNERATIVO-DETRACCION) < TOPEDM) THEN
        RESULT = REMUNERATIVO-TOPEDM
    ELSE
        RESULT = 0
    END IF
END IF