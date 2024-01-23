'Concepto Jubilación

A = "'"
NOVEDAD = LEGAJO.CONCEPTO("NOVI_60000")

CALCULA_MINIMO = LEGAJO.CONCEPTO("CPT_00002") '1 = SI, 2 = NO
SIN_DESCUENTO = LEGAJO.CONCEPTO("VLEG_SINDES")
MODALIDAD_CONTRATACION = LEGAJO.CONCEPTO("CPT_00040")
ACTIVIDAD_AFIP = LEGAJO.CONCEPTO("CPT_00010")
SITUACION_REVISTA = LEGAJO.CONCEPTO("CPT_00035")
GRUPO_RIESGO_COVID = LEGAJO.CONCEPTO("VLEG_GRIESG")

IMPONIBLE_1_ANTERIORES = LEGAJO.CONCEPTO("CPT_50100")
IMPONIBLE_1 = LEGAJO.CONCEPTO("CPT_50200") '1157112.83

salida = IMPONIBLE_1
QueryExec("dbo.G4_WRITE_FILE 'pruebaJubilacion','"&replace(salida,"'", "''")&"'")

IMPONIBLE_1_SAC_ANTERIORES = LEGAJO.CONCEPTO("CPT_50105") 
IMPONIBLE_1_SAC = LEGAJO.CONCEPTO("CPT_50400")

PORCENTAJE_JUBILACION = LEGAJO.CONCEPTO("VCPT_60000_CONST1")*-1
PISO_JUBILACION = LEGAJO.CONCEPTO("VCPT_60000_CONST2")
DESCUENTOS_JUB_ANTERIORES = LEGAJO.CONCEPTO("CPT_59999")

TIPOLIQ = LEGAJO.CONCEPTO("VLIQ_TIPLIQ")

'---------------------------CÁLCULO DE DÍAS TRABAJADOS----------------------------------------------------------
NROLEG = LEGAJO.NROLEG
ANIO = LEGAJO.CONCEPTO("VLIQ_ANOLIQ")
MES = RIGHT("0"&LEGAJO.CONCEPTO("VLIQ_MESLIQ"),2)

PRIMER_DIA_MES = A& ANIO&MES&"01" &A
ULTIMO_DIA = QUERYEXEC(CSTR("SELECT DATEPART(DD,EOMONTH("&PRIMER_DIA_MES&"))"))
ULTIMO_DIA_MES = A& ANIO&MES&ULTIMO_DIA &A

CPT_DIAS_TRABAJADOS = LEGAJO.CONCEPTO("CPT_00101")

'Si el concepto 00101 devuelve valor, utilizo esos días para el prorrateo del piso. En cambio, en otras liquidaciones, este concepto no se calcula así que utilizo la antiguedad según la solapa del Legajo
IF CPT_DIAS_TRABAJADOS <> 0 THEN
    DIAS_TRABAJADOS = CPT_DIAS_TRABAJADOS
ELSE
    SSQL = " "
    SSQL = " SELECT ISNULL(SUM (DATEDIFF(D,"
    SSQL = SSQL + " CASE WHEN SJMLGH_FCHING <= "&PRIMER_DIA_MES&" THEN "&PRIMER_DIA_MES&" ELSE SJMLGH_FCHING END,"
    SSQL = SSQL + " "&ULTIMO_DIA_MES&")),0)+1"
    SSQL = SSQL + " FROM SJMLGH WHERE SJMLGH_NROLEG = "&NROLEG&" AND SJMLGH_CHKEGR = 'N'"
    
    DIAS_TRABAJADOS = QUERYEXEC(CSTR(SSQL))
END IF

    DIAS_TRABAJADOS_SAC = LEGAJO.CONCEPTO("CPT_31000") 'Sólo utilizo los "Días trabajados en el semestre" para prorratear el piso de Jubilación en liquidaciones SAC/AJSAC (Según visita del 01-09-2022)
'---------------------------------------------------------------------------------------------------------------

IF (DIAS_TRABAJADOS <= 30 AND DIAS_TRABAJADOS <> 0) THEN
    IF (TIPOLIQ = "SAC" OR TIPOLIQ = "AJSAC") THEN
        PISO_JUBILACION = ((PISO_JUBILACION/2/180)*DIAS_TRABAJADOS_SAC)
    ELSE
        PISO_JUBILACION = ((PISO_JUBILACION/30)*DIAS_TRABAJADOS)
    END IF
END IF

IF GRUPO_RIESGO_COVID = "S" THEN
	IMPONIBLE_1 = 0
END IF


'METODO DE CALCULO---------------------------------------------------------------------------------------------

IMPOSAC = Legajo.Acum("IMPOSA") 'Conceptos de SAC
REMUNERATIVO = Legajo.Acum("REMUNE") - IMPOSAC 'Para los imponibles normales no tomo en cuenta Conceptos Remunerativos que sean de SAC                

'Si la liquidación tiene sólo conceptos Remunerativos y no tiene de SAC (Liquidación Normal) calculo sólo los valores de liquidaciones normales.
IF (REMUNERATIVO <> 0 AND IMPOSAC = 0) THEN

    BASE_IMPONIBLE_1_COMPARACION = IMPONIBLE_1_ANTERIORES + IMPONIBLE_1 

ELSE

    'Si la liquidación NO tiene conceptos remunerativos y sólo tiene de SAC (Liquidaciones de Aguinaldo o Finales sin conceptos remunerativos), calculo sólo valores de liquidaciones SAC.
    IF (REMUNERATIVO = 0 AND IMPOSAC <> 0) THEN

        BASE_IMPONIBLE_1_COMPARACION = IMPONIBLE_1_SAC_ANTERIORES + IMPONIBLE_1_SAC

    ELSE 'Si la liquidación tiene conceptos remunerativos y también tiene de SAC, calculo todos los valores juntos

        BASE_IMPONIBLE_1_COMPARACION = IMPONIBLE_1_ANTERIORES + IMPONIBLE_1 + IMPONIBLE_1_SAC_ANTERIORES + IMPONIBLE_1_SAC

    END IF

END IF



'Para los casos de liquidaciones acumuladas, verifico que la base imponible 1 no venga en 0 ya que puede que el tope se haya consumido y por esto termine el imponible siendo menor al piso y calcule por el piso. Por eso colocamos doble validación
IF (BASE_IMPONIBLE_1_COMPARACION < PISO_JUBILACION) AND (BASE_IMPONIBLE_1_COMPARACION <> 0) AND (CALCULA_MINIMO = 1) THEN
    FINAL = ((PISO_JUBILACION * PORCENTAJE_JUBILACION) - DESCUENTOS_JUB_ANTERIORES)*-1
ELSE
    FINAL = ((BASE_IMPONIBLE_1_COMPARACION * PORCENTAJE_JUBILACION) - DESCUENTOS_JUB_ANTERIORES)*-1
END IF 

IF (SIN_DESCUENTO = "S" OR MODALIDAD_CONTRATACION = 27 OR SITUACION_REVISTA = 50) THEN
	FINAL = 0
END IF 
			
        
IF (NOVEDAD <> 0) THEN
	RESULT = NOVEDAD
ELSE
    'Se coloca siguiente validación por si el descuento llega a dar centavos
    IF (ABS(FINAL) < 1) THEN
	    RESULT = 0
    ELSE
	    RESULT = FINAL
    END IF
END IF