'06800 PRESENTISMO 
A="'"
CAMPO = A&Legajo.Concepto("CPT_00060") &A  '306
NOVI=  Legajo.Concepto("NOVI_06800") '0
CLAEMP= LEGAJO.CONCEPTO("VLIQ_CLAEMP")  'JC 
AUSEN= Legajo.Concepto("CPT_00950") '0
HOR=Legajo.Concepto("CPT_00850")+(Legajo.Concepto("CPT_00900")+Legajo.Concepto("CPT_00865"))*2+Legajo.Concepto("CPT_00935")+Legajo.Concepto("CPT_01050")+Legajo.Concepto("CPT_00860")*1.5
'						80.75   +        0                    +   0     +          0                 +     0   +  0
' HOR = 80.75
CONVEN= Legajo.Concepto("CPT_00110") '171.00

	IF NOVI<>0 THEN

		RESULT= NOVI

	ELSE

		IF AUSEN>1 THEN
			RESULT=0

		ELSE
			IF CLAEMP="JC" THEN

				SSQL = ""
				SSQL= " SELECT USR_VALSOIP_PRESENT FROM USR_VALSOIP WHERE ltrim(USR_VALSOIP_CAT) = " & CAMPO   

				RESULT =queryexec(cstr(ssql))*HOR
				' 6.4800 * 80.75
				'523,26

			END IF
		END IF

	END IF