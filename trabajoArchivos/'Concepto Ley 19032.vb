'Concepto Ley 19032

A = "'"
NOVEDAD = LEGAJO.CONCEPTO("NOVI_60010") '0

CALCULA_MINIMO = LEGAJO.CONCEPTO("CPT_00002") '1 = SI, 2 = NO '1
SIN_DESCUENTO = LEGAJO.CONCEPTO("VLEG_SINDES") '0
MODALIDAD_CONTRATACION = LEGAJO.CONCEPTO("CPT_00040") '8.00
ACTIVIDAD_AFIP = LEGAJO.CONCEPTO("CPT_00010") '13.00
CONDICION = LEGAJO.CONCEPTO("CPT_00020") '5.00
SITUACION_REVISTA = LEGAJO.CONCEPTO("CPT_00035") '1.00
GRUPO_RIESGO_COVID = LEGAJO.CONCEPTO("VLEG_GRIESG") '0

IMPONIBLE_5_ANTERIORES = LEGAJO.CONCEPTO("CPT_50120") '0
IMPONIBLE_5 = LEGAJO.CONCEPTO("CPT_50300") '410258.30
IMPONIBLE_5_SAC_ANTERIORES = LEGAJO.CONCEPTO("CPT_50125") ' 578556.41
IMPONIBLE_5_SAC = LEGAJO.CONCEPTO("CPT_50500") '0

PORCENTAJE_LEY_19032 = LEGAJO.CONCEPTO("VCPT_60010_CONST1")*-1 '0.03
PISO_LEY_19032 = LEGAJO.CONCEPTO("VCPT_60010_CONST2") '35603.99
DESCUENTOS_LEY_ANTERIORES = LEGAJO.CONCEPTO("CPT_60009") '0

TIPOLIQ = LEGAJO.CONCEPTO("VLIQ_TIPLIQ") '1FRES

'---------------------------CÁLCULO DE DÍAS TRABAJADOS----------------------------------------------------------
NROLEG = LEGAJO.NROLEG 
ANIO = LEGAJO.CONCEPTO("VLIQ_ANOLIQ") '2023
MES = RIGHT("0"&LEGAJO.CONCEPTO("VLIQ_MESLIQ"),2) '12

PRIMER_DIA_MES = A& ANIO&MES&"01" &A '20231201
ULTIMO_DIA = QUERYEXEC(CSTR("SELECT DATEPART(DD,EOMONTH("&PRIMER_DIA_MES&"))")) '31
ULTIMO_DIA_MES = A& ANIO&MES&ULTIMO_DIA &A  '20231231

CPT_DIAS_TRABAJADOS = LEGAJO.CONCEPTO("CPT_00101") 'Días trabajados según concepto 00101   '30.00

'Si el concepto 00101 devuelve valor, utilizo esos días para el prorrateo del piso. En cambio, en otras liquidaciones, este concepto no se calcula así que utilizo la antiguedad según la solapa del Legajo
IF CPT_DIAS_TRABAJADOS <> 0 THEN
    DIAS_TRABAJADOS = CPT_DIAS_TRABAJADOS '30
ELSE
    SSQL = " "
    SSQL = " SELECT ISNULL(SUM (DATEDIFF(D,"
    SSQL = SSQL + " CASE WHEN SJMLGH_FCHING <= "&PRIMER_DIA_MES&" THEN "&PRIMER_DIA_MES&" ELSE SJMLGH_FCHING END,"
    SSQL = SSQL + " "&ULTIMO_DIA_MES&")),0)+1"
    SSQL = SSQL + " FROM SJMLGH WHERE SJMLGH_NROLEG = "&NROLEG&" AND SJMLGH_CHKEGR = 'N'"
    
    DIAS_TRABAJADOS = QUERYEXEC(CSTR(SSQL)) 'Días trabajados según ingreso (el concepto 00101 ya lo hace pero para ciertas liquidaciones no se calcula)
END IF

    DIAS_TRABAJADOS_SAC = LEGAJO.CONCEPTO("CPT_31000") '180        Sólo utilizo los "Días trabajados en el semestre" para prorratear el piso de Ley 19032 en liquidaciones SAC/AJSAC (Según visita del 01-09-2022)
'---------------------------------------------------------------------------------------------------------------


IF (DIAS_TRABAJADOS <= 30 AND DIAS_TRABAJADOS <> 0) THEN
    IF (TIPOLIQ = "SAC" OR TIPOLIQ = "AJSAC") THEN
        PISO_LEY_19032 = ((PISO_LEY_19032/2/180)*DIAS_TRABAJADOS_SAC) '(35603.99/2/180)*180 = 17.801,995
    ELSE
        PISO_LEY_19032 = ((PISO_LEY_19032/30)*DIAS_TRABAJADOS)
    END IF 
END IF

IF GRUPO_RIESGO_COVID = "S" THEN
	IMPONIBLE_5 = 0
END IF


'METODO DE CALCULO---------------------------------------------------------------------------------------------
			
IMPOSAC = Legajo.Acum("IMPOSA") 'Conceptos de SAC '0 PREGUNTAR
REMUNERATIVO = Legajo.Acum("REMUNE") - IMPOSAC ' 410258.30   'Para los imponibles normales no tomo en cuenta Conceptos Remunerativos que sean de SAC

'Si la liquidación tiene sólo conceptos Remunerativos y no tiene de SAC (Liquidación Normal) calculo sólo los valores de liquidaciones normales.
IF (REMUNERATIVO <> 0 AND IMPOSAC = 0) THEN

    BASE_IMPONIBLE_5_COMPARACION = IMPONIBLE_5_ANTERIORES + IMPONIBLE_5
    '      410258.30             =   0 + 410258.30
ELSE

    'Si la liquidación NO tiene conceptos remunerativos y sólo tiene de SAC (Liquidaciones de Aguinaldo o Finales sin conceptos remunerativos), calculo sólo valores de liquidaciones SAC.
    IF (REMUNERATIVO = 0 AND IMPOSAC <> 0) THEN

        BASE_IMPONIBLE_5_COMPARACION = IMPONIBLE_5_SAC_ANTERIORES + IMPONIBLE_5_SAC

    ELSE 'Si la liquidación tiene conceptos remunerativos y también tiene de SAC, calculo todos los valores juntos

        BASE_IMPONIBLE_5_COMPARACION = IMPONIBLE_5_ANTERIORES + IMPONIBLE_5 + IMPONIBLE_5_SAC_ANTERIORES + IMPONIBLE_5_SAC

    END IF

END IF


'Para los casos de liquidaciones acumuladas, verifico que la base imponible 1 no venga en 0 ya que puede que el tope se haya consumido y por esto termine el imponible siendo menor al piso y calcule por el piso. Por eso colocamos doble validación
IF (BASE_IMPONIBLE_5_COMPARACION < PISO_LEY_19032) AND (BASE_IMPONIBLE_5_COMPARACION <> 0) AND (CALCULA_MINIMO = 1) THEN
	FINAL = ((PISO_LEY_19032 * PORCENTAJE_LEY_19032) - DESCUENTOS_LEY_ANTERIORES)*-1
ELSE
    FINAL = ((BASE_IMPONIBLE_5_COMPARACION * PORCENTAJE_LEY_19032) - DESCUENTOS_LEY_ANTERIORES)*-1
            ' (410258.30 * 0.03)  - 0) *-1 =  -12.307,74
END IF

 
IF (SIN_DESCUENTO = "S" OR CONDICION = 2 OR MODALIDAD_CONTRATACION = 27 OR SITUACION_REVISTA = 50) THEN
	FINAL = 0
END IF 			
        
IF (NOVEDAD <> 0) THEN
	RESULT = NOVEDAD
ELSE
    'Se coloca siguiente validación por si el descuento llega a dar centavos
    IF (ABS(FINAL) < 1) THEN
	    RESULT = 0
    ELSE
	    RESULT = FINAL  '-12.307,74
    END IF
END IF