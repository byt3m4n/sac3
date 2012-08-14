update "CPSAA"."GESAC_MAE_TIPO_ENSA" set "SCMTE_NOM_TIPO_ENSA"='SO3', "SCMTE_COC_UNI_MED"='POR' where "SCMTE_NOM_TIPO_ENSA" in
( SELECT    gr."SCMGT_NOM_GRUP_TIPO_ENSA"    FROM
"CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA"  gr inner join
"CPSAA"."GESAC_MAE_MATR_TRAT"  mat on(gr."SCMMT_IDE_MATR_TRAT_K"=mat."SCMMT_IDE_MATR_TRAT_K")
   WHERE   mat."SCMMT_NOM_MATR_TRAT" like 'Curva RX%'   and
gr."SCMGT_NOM_GRUP_TIPO_ENSA" like 'SO3 (%)')

select COUNT(*) FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" WHERE "SCMTE_NOM_TIPO_ENSA" LIKE '%SO3%';

SELECT * FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" where "SCMGT_IDE_GRUP_TIPO_ENSA_K" in
( SELECT    gr."SCMGT_IDE_GRUP_TIPO_ENSA_K"    FROM
"CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA"  gr inner join
"CPSAA"."GESAC_MAE_MATR_TRAT"  mat on(gr."SCMMT_IDE_MATR_TRAT_K"=mat."SCMMT_IDE_MATR_TRAT_K")
   WHERE   mat."SCMMT_NOM_MATR_TRAT" = 'Análisis Químico por vía Clásica cemento '   and
gr."SCMGT_NOM_GRUP_TIPO_ENSA" like 'K2O (%)')
-----------------------------------------------------------
update    "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica - RX' where  "SCMGT_NOM_GRUP_TIPO_ENSA"  in
( SELECT    gr."SCMGT_NOM_GRUP_TIPO_ENSA"    FROM
"CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA"  gr inner join
"CPSAA"."GESAC_MAE_MATR_TRAT"  mat
on(gr."SCMMT_IDE_MATR_TRAT_K"=mat."SCMMT_IDE_MATR_TRAT_K")
   WHERE   mat."SCMMT_NOM_MATR_TRAT" like 'Curva RX%'  and
gr."SCMGT_NOM_GRUP_TIPO_ENSA" like 'Índice de Actividad Puzolánica ? RX%' )

--PROCRESO: ANÁLISIS QUÍMICO POR VÍA CLÁSICA

--REPETIDO Humedad (mufla) (%) CON ID: 12177, 12185, 12193, 12201, 12209, 12217, 12225, 12233, 12241, 12249 
--ELIMINAR GRUPOS TIPOS DE ENSAYO Y TIPOS DE ENSAYO PARA TODAS LAS MATRICES DE ESTE PROCESO, LOS GTE SON: Humedad as received (%), Volátiles as received (%), Cenizas as received (%), hierro fijo as received (%), Poder calorífico as received (kcal/kg) (%)
--NO TIENE TIPO DE ENSAYO LA MATRIZ DE ESTE PROCESO CON PRODUCTO CALIZA, EL GRUPO TIPO DE ENSAYO ES: K2O (%)
--NO TIENE TIPO DE ENSAYO LA MATRIZ DE ESTE PROCESO CON PRODUCTO CALIZA, EL GRUPO TIPO DE ENSAYO ES: FCaO (%)


--PROCESO: CURVA RX

--NO EXISTE TIPO DE ENSAYO REGISTRADO PARA NINGUNA MATRICES DE ESTE PROCESO, DEL GRUPO TIPO DE ENSAYO: SiO2 (%), SiO2 (cuarcítica) (%),SiO2 (amorfa)(%), Al2O3 (%), Fe2O3 (%), CaO (%), MgO (%), K2O (%),Na2O (%), SO3 (%), Cl (%), TiO2 (%), F (%),FCaO (%),CaCO3 (%),Índice de Actividad Puzolánica ? RX,Pérdida al fuego (%),Azufre (%)



--PROCESO: FISICO
--caliza

update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12261
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12262
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12263
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12264
--REPETIDO EN INDICE DE HARD GROVE Y NO TIENE TE EN 12265
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12266
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12267
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12268
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12269
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12270
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12271
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12272
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12421 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12422
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12423
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12424
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12425
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12426
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12427
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12428
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12429
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12430
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12537
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12538
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12539
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12540

--FALTA:
--Densidad del Patrón (g/cm3)


--puzolana

update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12273 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12274
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12275
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12276
--REPETIDO Indice de Hard Grove Y NO HAY TE EN 12277
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12278
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12279
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12280
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12281
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12282
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12283
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12284
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12431 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12432
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12433
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12434
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12435
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12436
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12437
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12438
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12439
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12440
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12541 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12542
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12543
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12544
--FALTA:
--Densidad del Patrón (g/cm3)

--Carbón

--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12297
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12298
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12299
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12300
--REPETIDO Indice de Hard Grove y NO TIENE TE EN 12301
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12302
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12303
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12304
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12305
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12306
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12307
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12308
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12462
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12463
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12464
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12465
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12466
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12467
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12468
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12469
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12470
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12471
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12549
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12550
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12551
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12552
--FALTA:
--Densidad del Patrón (g/cm3)

--Hierro

--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12309
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12310
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12311
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12312
--REPETIDO Indice de Hard Grove y NO TIENE TE EN 12313
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12314
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12315
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12316
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12317
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12318
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12319
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12320
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12472 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12473
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12474
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12475
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12476
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12477
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12478
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12479
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12480
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12481
--REPETIDO Indice de Hard Grove y NO TIENE TE EN 12482
--REPETIDO Índice de Bond (kWh/TC) EN 12483
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12553
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12554
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12555
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12556
--FALTA:
--Densidad del Patrón (g/cm3)


--Arcilla

--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12321
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12322
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12323
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12324
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12325
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12326
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12327
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12328
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12329
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12330
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12331
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12332
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12484
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12485
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12486
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12487
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12488
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12489
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12490
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12491
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12492
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12493
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12557 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12558
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12559
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12560
--FALTA:
--Densidad del Patrón (g/cm3)

--Yeso

--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12333
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12334
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12335
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12336
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12337
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12338
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12339
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12340
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12341
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12342
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12343
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12344
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12494 
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12495
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12496
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12497
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12498
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12499
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12500
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12501
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12502
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12503
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12561
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12562
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12563
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12564
--FALTA:
--Densidad del Patrón (g/cm3)
--Fraguado Inicial (min)
--Índice de Bond (kWh/TC)

--Diatomita

--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12345
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12346
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12347
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12348
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12349
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12350
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12351
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12352
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12353
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12354
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12355
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12356
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12504 
--REPETIDO Índice de Hard Grove Y TIENE TE Blaine (g/cm2) EN 12505
--REPETIDO Índice de Hard Grove Y TIENE TE Densidad (g/cm3) EN 12506
--REPETIDO Índice de Hard Grove Y TIENE TE Densidad Aparente (TM/m3) EN 12507
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12508
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12509
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12510
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12511
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12512
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12513
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12514
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12515
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12516
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12565
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12566
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12567
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12568
--FALTA:
--Densidad del Patrón (g/cm3)

--Cal

--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12357
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12358
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12359
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12360
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12361
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12362
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12363
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12364
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12365
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12366
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12367
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12368
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12517
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12518
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12519
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12520
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12521
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12522
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12523
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12524
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12525
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12526
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12569
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12570
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12571
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12572
--FALTA:
--Densidad del Patrón (g/cm3)

--Otros
--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12369
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Blaine (g/cm2)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12370
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad (g/cm3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12371
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12372
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12373
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12374
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12375
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12376
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12377
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12378
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12379
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12380
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12527
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =  12528
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12529
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12530
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12531
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12532
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12533
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12534
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12535
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12536
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12573
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12574
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12575
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12576
--FALTA:
--Densidad del Patrón (g/cm3)


--Cemento

update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Bond (kWh/TC)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12441 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Inicial (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12442 
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Fraguado Final (min)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12443
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión en Autoclave (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12444
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión al Agua (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12445
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 14 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12446
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12447
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 45 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12448
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 90 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12449
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Expansión a los sulfatos a 180 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12450
--update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Hard Grove' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12451
--REPETIDO Índice de Hard Grove Y NO TIENE TE EN 12452
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Densidad Aparente (TM/m3)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12453
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Retenido en malla N° 325 (%)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12454
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua (mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12455
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Demanda de agua para patrón(mL)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12456
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 1 día' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12457
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 3 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" =12458
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 7 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12459
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Índice de Actividad Puzolánica a 28 días' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12460
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 1 día (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12545
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 3 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12546
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 7 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12547
update "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" set "SCMGT_NOM_GRUP_TIPO_ENSA"='Resistencia a la compresión a 28 días (PSI)' where "SCMGT_IDE_GRUP_TIPO_ENSA_K" = 12548

--FALTA:
--Densidad del Patrón (g/cm3)
--Blaine (g/cm2)
--Densidad (g/cm3)









SELECT    gr."SCMGT_IDE_GRUP_TIPO_ENSA_K", mat."SCMMT_NOM_MATR_TRAT"    FROM
"CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA"  gr inner join
"CPSAA"."GESAC_MAE_MATR_TRAT"  mat on(gr."SCMMT_IDE_MATR_TRAT_K"=mat."SCMMT_IDE_MATR_TRAT_K")
   WHERE   mat."SCMMT_NOM_MATR_TRAT" like 'Curva RX%'   and
gr."SCMGT_NOM_GRUP_TIPO_ENSA" = 'SiO2'


SELECT * FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" where "SCMGT_IDE_GRUP_TIPO_ENSA_K" in
( SELECT    gr."SCMGT_IDE_GRUP_TIPO_ENSA_K"    FROM
"CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA"  gr inner join
"CPSAA"."GESAC_MAE_MATR_TRAT"  mat on(gr."SCMMT_IDE_MATR_TRAT_K"=mat."SCMMT_IDE_MATR_TRAT_K")
   WHERE   mat."SCMMT_NOM_MATR_TRAT" like 'Curva RX%'   and
gr."SCMGT_NOM_GRUP_TIPO_ENSA" ='Azufre (%)')





