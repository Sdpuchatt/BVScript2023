'
IF(CPT_00040=102
            ,0,
                if(vliq_tipliq="1q",
                            IF(Legajo.Acum("REMUNE")+cpt_50010<VCPT_50300_CONST2/2
                                    ,VCPT_50300_CONST2/2,
                                        Legajo.Acum("REMUNE")),
                    'else            
                    if(or(vliq_tipliq = "sac", vliq_tipliq ="f"),
                                IF(Legajo.Acum("REMUNE")<VCPT_50300_CONST2/2
                                        ,VCPT_50300_CONST2/2,
                                                Legajo.Acum("REMUNE")),
                    'else                            
                    IF(Legajo.Acum("REMUNE")+cpt_50010<VCPT_50300_CONST2
                            ,VCPT_50300_CONST2
                                ,Legajo.Acum("REMUNE"))))) 

'Se obtiene la base para calcular las contribuciones mediante el acumulador BDTCON.
'Si la remuneración actual (y la del mes) no superan el piso mínimo mensual decretado por AFIP:
    'Entonces la base para las contribuciones será el piso mínimo.
    'Caso contrario la base será la remuneración.

TIPLIQ = LEGAJO.CONCEPTO("VLIQ_TIPLIQ")
REMUNE = LEGAJO.ACUM("REMUNE") 'Remunerativo de la Liq. Actual
MODCON = LEGAJO.CONCEPTO("CPT_00040") 'MODCON Modalidad de Contratación
REMUNE_ANT = LEGAJO.CONCEPTO("CPT_50010") 'REMUNE_ANT Remuneración Liquidaciones Anteriores del Período 
PISO = LEGAJO.CONCEPTO("VCPT_50300_CONST2") 'PISO de Contribución

IF (MODCON = 102) THEN
    RESULT = 0
ELSE

    IF (TIPLIQ = "1Q") THEN

        IF ((REMUNE + REMUNE_ANT) < (PISO/2)) THEN
            RESULT = PISO/2
        ELSE
            RESULT = REMUNE
        END IF

    ELSE

        IF (TIPLIQ = "SAC" OR TIPLIQ = "F") THEN

            IF (REMUNE < (PISO/2)) THEN
                RESULT = PISO/2
            ELSE
                RESULT = REMUNE
            END IF

        ELSE

            IF ((REMUNE + REMUNE_ANT) < PISO) THEN
                RESULT = PISO
            ELSE
                RESULT = REMUNE
            END IF

        END IF

    END IF

END IF