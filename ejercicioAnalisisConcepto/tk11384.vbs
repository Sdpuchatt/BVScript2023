'MDQACHA
hasta 25/01/2024  tk. 11384
IF(CPT_00040=102,0,if(vliq_tipliq="1q",IF(Legajo.Acum("REMUNE")+cpt_50010<VCPT_50300_CONST2/2,VCPT_50300_CONST2/2,Legajo.Acum("REMUNE")+cpt_50010),if(or(vliq_tipliq = "sac", vliq_tipliq ="f"),IF(Legajo.Acum("REMUNE")<VCPT_50300_CONST2/2,VCPT_50300_CONST2/2,Legajo.Acum("REMUNE")),IF(Legajo.Acum("REMUNE")+cpt_50010<VCPT_50300_CONST2,VCPT_50300_CONST2,Legajo.Acum("REMUNE"))))) 


'MQDJBJ
IF(CPT_00040=102,0,if(vliq_tipliq="1q",IF(Legajo.Acum("REMUNE")+cpt_50010<VCPT_50300_CONST2/2,VCPT_50300_CONST2/2,Legajo.Acum("REMUNE")),if(or(vliq_tipliq = "sac", vliq_tipliq ="f"),IF(Legajo.Acum("REMUNE")<VCPT_50300_CONST2/2,VCPT_50300_CONST2/2,Legajo.Acum("REMUNE")),IF(Legajo.Acum("REMUNE")+cpt_50010<VCPT_50300_CONST2,VCPT_50300_CONST2,Legajo.Acum("REMUNE")))))