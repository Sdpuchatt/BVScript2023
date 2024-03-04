
'06100 - Base descuento con tope
if(Legajo.Acum("REMUNE")+cpt_06090<=vcpt_06100_con001,
       --868820.11      +  0    <= 1157112.83    
        Legajo.Acum("REMUNE"),
        -- 868820.11
        (vcpt_06100_CON001-cpt_06090))
        '1157112.83 -  


'BDTANT 06090 LLAMA A FORMULA PLANILLA
Period = Legajo.peract
Nroleg = "'" & Legajo.Nroleg  & "'" 

SSQL = " " 
SSQL = SSQL + " select  isnull(sum(sjrmvi_calcul) ,0) "
SSQL = SSQL + "  from sjrmvi  "
SSQL = SSQL + "  where sjrmvi_modfor = 'sj' and sjrmvi_codfor = 'L'  "
SSQL = SSQL + "  and sjrmvi_period = period  and sjrmvi_nroleg  = " & Nroleg
SSQL = SSQL + " and sjrmvi_codcpt = '06100'  and sjrmvi_codcie is not null "
result = queryexec(cstr(ssql))

'QUERIE MEJORADA
PERIODO = LEGAJO.PERACT
NROLEG =  LEGAJO.NROLEG

SSQL = " "
SSQL = SSQL + " SELECT  ISNULL(SUM(SJRMVI_CALCUL) ,0) FROM SJRMVI INNER JOIN SJRMVH"
SSQL = SSQL + " ON SJRMVI_NROLEG = SJRMVH_NROLEG AND"
SSQL = SSQL + " SJRMVI_PERIOD = SJRMVH_PERIOD AND"
SSQL = SSQL + " SJRMVI_NROFOR = SJRMVH_NROFOR"
SSQL = SSQL + " WHERE SJRMVH_CIERRE = 'S' AND SJRMVI_CODCPT = 06100 "
SSQL = SSQL + " AND SJRMVH_NROLEG = " & NROLEG 
SSQL = SSQL + " AND SJRMVI_PERIOD = " & PERIODO
RESULT = QUERYEXEC(CSTR(SSQL))