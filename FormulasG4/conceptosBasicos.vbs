'Variables VBScript de Softland

CPT_XXXXX = LEGAJO.CONCEPTO("CPT_XXXXX") 'Concepto anterior (SJRMVI_CALCUL)

NOVEDAD = LEGAJO.CONCEPTO("NOVI_XXXXX") 'Novedad de concepto X (Importe)
HORAS = LEGAJO.CONCEPTO("NOVH_XXXXX") 'Novedad de concepto X (Horas)
DIAS = LEGAJO.CONCEPTO("NOVD_XXXXX") 'Novedad de concepto X (Días)

NROLEG = LEGAJO.NROLEG 'Número de legajo
PERIODO = LEGAJO.PERACT 'Período de actividad (202312)

TIPLIQ = LEGAJO.CONCEPTO("VLIQ_TIPLIQ") 'Tipo de liquidación
CLAEMP = LEGAJO.CONCEPTO("VLIQ_CLAEMP") 'Clase de Empleado ("MENS", "E", "J")
MES = LEGAJO.CONCEPTO("VLIQ_MESLIQ") 'Mes de liquidación (1, 2, 3... 11, 12)
ANIO = LEGAJO.CONCEPTO("VLIQ_ANOLIQ") 'Año de liquidación

Liquidacion de sueldos 
Ley 20744
deducciones retenciones a la seguridad 
    Jubilacion 11%
    Obra social 3%
    ley 19032 3%
    sindicato 3%