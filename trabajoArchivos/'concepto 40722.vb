'concepto 40722
NOVEDAD = LEGAJO.CONCEPTO("NOVI_40722") ' 0
CATEGORIA = LEGAJO.CONCEPTO("CPT_00060") 'CATEGORIA DE LEGAJO '58.00
ACTA_ACUERDO = LEGAJO.ACUM("ACTAAC") 'ACTA ACUERDO  234826.85

CONST1 = LEGAJO.CONCEPTO("VCPT_40722_CONST1") '0
CONST2 = LEGAJO.CONCEPTO("VCPT_40722_CONST2") '0.7131
CONST3 = LEGAJO.CONCEPTO("VCPT_40722_CONST3") '0

IF NOVEDAD <> 0 THEN
    RESULT = NOVEDAD
ELSE
    IF (CATEGORIA = 5550 OR CATEGORIA =5551  ) THEN
        RESULT = ACTA_ACUERDO*CONST1
    ELSE
        IF (CATEGORIA = 5552 OR CATEGORIA = 5553 ) THEN
            RESULT = ACTA_ACUERDO*CONST2
        ELSE
            IF (CATEGORIA = 56 OR CATEGORIA = 57 OR CATEGORIA = 58 OR CATEGORIA = 61 OR CATEGORIA = 51 OR CATEGORIA = 50 OR CATEGORIA=52 OR CATEGORIA=53) THEN
                RESULT = ACTA_ACUERDO*CONST2 '167.455
            ELSE
                RESULT = 0
            END IF
        END IF
    END IF
END IF 


'03605
IF(CPT_00075=1,
    0,
        IF(NOVI_03605 <> 0,
            NOVI_03605,
                IF(((LEGAJO.ACUM("ROPFRE"))*(CPT_01460/100))<0
                                ,0,((LEGAJO.ACUM("ROPFRE"))*(CPT_01460/100)))))
                                    '7.916,26
ART223 = LEGAJO.CONCEPTO("CPT_00075") 'Corresponde aplicacion ART 223 BIS
NOVI_03605 = LEGAJO.CONCEPTO("NOVI_03605") 'ROPA DE TRABAJO POR NOVEDAD
ROPFRE = LEGAJO.ACUM("ROPFRE") 'Ropa de Agua Fresqueros
PORCENTAJE = LEGAJO.CONCEPTO("CPT_01460") 'Porcentaje Ropa de Trabajo

IF (ART223 = 1) THEN
    RESULT = 0
ELSE
    IF (NOVI_03605 <> 0)THEN
        RESULT = NOVI_03605
    ELSE
        IF ((ROPFRE*(PORCENTAJE/100))<0)THEN
            RESULT =  0
        ELSE
            RESULT = (ROPFRE*(PORCENTAJE/100))
        END IF
    END IF
END IF   