IF(OR(CPT_00040=102,Legajo.Acum("REMUNE")=0),
    0,
    if(vliq_tipliq="1q",
        if((Legajo.Acum("REMUNE")+CPT_50010)<VCPT_50020_CONST2/2,
        VCPT_50020_CONST2/2,
        Legajo.Acum("REMUNE")),
        if(Legajo.Acum("REMUNE")+CPT_50010<VCPT_50020_CONST2,
        VCPT_50020_CONST2-cpt_50010,
            IF(VCPT_50020_CONST1-CPT_50010>0,
                IF(Legajo.Acum("REMUNE")+CPT_50010>VCPT_50020_CONST1,
                    VCPT_50020_CONST1-CPT_50010,Legajo.Acum("REMUNE")),0))))

'50020CONST2 = 35603.99