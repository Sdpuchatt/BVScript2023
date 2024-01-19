IF((IF((Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535>(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35,(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35,(Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535))>0,(IF((Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535>(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35,(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35,(Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535)),0)


IF(
    (IF(
        (Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535>(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35
        ,(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35 'si es true
        ,(Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535) ' si es false     
    )>0,
        (IF((Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535>(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35
            ,(Legajo.Acum("REMUNE")+Legajo.Acum("NOREMU"))*0.35 ' si es true
            ,(Legajo.Acum("GARETT")+Legajo.Acum("GARETA"))-novi_07535)),' si es false
0) 


GARETT = LEGAJO.ACUM("GARETT")
GARETA = LEGAJO.ACUM("GARETA")
REMUNE = LEGAJO.ACUM("REMUNE")
NOREMU = LEGAJO.ACUM("NOREMU")
PERCEPCIONES = LEGAJO.CONCEPTO("CPT_07535") 'novi_07535

IMPUESTO = GARETT + GARETA - PERCEPCIONES ' IMPUESTO GANANCIAS DE ESTA LIQUIDACION
BRUTO = (REMUNE + NOREMU)*0.35 'SUELDO BRUTO

IF(BRUTO = 0)THEN
    RESULT = 0
ELSE
    IF(IMPUESTO > BRUTO  )THEN
        RESULT = BRUTO
    ELSE
        RESULT = IMPUESTO 
    END IF
END IF