REM  ME FIJO SI YA SE PAGO EN EL PERIODO LA A.R.T. FIJA.
REM SI SE PAGO DEVUELVO 1 SINO 0


A = "'" 

Nroleg = A & Legajo.Nroleg & A
Period = Legajo.Peract 

SSQL = " "
SSQL = SSQL + "  select isnull(sum(sjrmvi_calcul),0)  from sjrmvi where sjrmvi_period = " & Period 
SSQL = SSQL + "  and sjrmvi_nroleg = " &  Nroleg  & " and sjrmvi_codcpt= '92270' and (SELECT SJRMVH_CIERRE FROM SJRMVH WHERE SJRMVH_PERIOD = SJRMVI_PERIOD AND SJRMVH_TIPLIQ = SJRMVI_TIPLIQ AND SJRMVH_NROFOR = SJRMVI_NROFOR AND SJRMVH_NROLEG = SJRMVI_NROLEG) = 'S' "
CAMPO  = QUERYEXEC(CSTR(SSQL))

IF CAMPO > 0 THEN 
             RESULT = 1
ELSE 
             RESULT = 0
END IF 


'92250
(legajo.acum("ACU001")+legajo.acum("NOREMU")-legajo.acum("NOIMP9"))*(VCPT_92250_CONST1/100)
'VSCRIPT
ACUM001 = LEGAJO.ACUM("ACU001")
NOREMU = LEGAJO.ACUM("NOREMU")
NOIMP9 = LEGAJO.ACUM("NOIMP9")
CONST1 = LEGAJO.CONCEPTO("VCPT_92250_CONST1")
RESULT = (ACUM001 + NOREMU - NOIMP9) * (CONST1/100)

'
IF(CPT_50014<VCPT_50025_CONST1,
        VCPT_50025_CONST2*CPT_50025,
        IF(CPT_50014<VCPT_50025_CONST3,
                CPT_50025*VCPT_50025_CONST4,
                IF(CPT_50014<VCPT_50025_CONST5,
                    CPT_50025*VCPT_50025_CONST6,
                    0)))