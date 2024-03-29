--Agregar el campo Estado a empresa-- Column:"SCMAE_COC_EST"

ALTER TABLE "CPSAA"."GESAC_MAE_EMPR" ADD COLUMN "SCMAE_COC_EST" character varying(3);

UPDATE "CPSAA"."GESAC_MAE_EMPR" SET "SCMAE_COC_EST" = 'ACT';

UPDATE "CPSAA"."GESAC_DET_RESP" SET "SCDRE_COC_EST" = 'ACT';

UPDATE "CPSAA"."GESAC_MAE_PLAN" SET "SCMAP_COC_EST" = 'ACT';


-- Column: "SCMAN_COC_EST"

ALTER TABLE "CPSAA"."GESAC_MAE_NEGO" DROP COLUMN "SCMAN_COC_EST";

ALTER TABLE "CPSAA"."GESAC_MAE_NEGO" ADD COLUMN "SCMAN_COC_EST" character varying(3);

ALTER TABLE "CPSAA"."GESAC_DET_ALCA" ADD COLUMN "SCMAP_COC_EST" character varying(3);

UPDATE "CPSAA"."GESAC_DET_ALCA"  set "SCMAP_COC_EST"='ACT';

UPDATE "CPSAA"."GESAC_MAE_ROL" SET "SCMAR_COC_EST" = 'ACT';

ALTER TABLE "CPSAA"."GESAC_DET_ROL_PUE_TRA" ADD COLUMN "SCMAP_COC_EST" character varying(3);

UPDATE "CPSAA"."GESAC_DET_ROL_PUE_TRA"  set "SCMAP_COC_EST"='ACT';

ALTER TABLE "CPSAA"."GESAC_DET_PUE_TRA_USU" ADD COLUMN "SCDPU_COC_EST" character varying(3);

UPDATE "CPSAA"."GESAC_DET_PUE_TRA_USU" set "SCDPU_COC_EST"='ACT';

CREATE TABLE "CPSAA"."GESAC_CONFIGURACION_ICONO"
(
  "SCMIC_IDE_ICONO_K" numeric(10,0) NOT NULL,
  "SCMAE_IDE_EMPR_K" numeric(10,0) NOT NULL,
  "SCMAP_IDE_PLAN_K" numeric(10,0) NOT NULL,
  "SCMPC_IDE_PROC_K" numeric(10,0) NOT NULL,
  "SCMEQ_IDE_EQUI_K" numeric(10,0),
  "SCICO_NOM_ICONO" character varying(100) NOT NULL,
  fila integer,
  "SCMAR_IDE_ROL_K" numeric(10,0) NOT NULL,
  "SCICO_IDE_GRUPO" numeric(10,0),
  CONSTRAINT "PK_GESAC_ICONO" PRIMARY KEY ("SCMIC_IDE_ICONO_K"),
  CONSTRAINT "FK_GESAC_MAE_EMP_GESAC_ICONO" FOREIGN KEY ("SCMAE_IDE_EMPR_K")
      REFERENCES "CPSAA"."GESAC_MAE_EMPR" ("SCMAE_IDE_EMPR_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "FK_GESAC_MAE_PLAN_GESAC_ICONO" FOREIGN KEY ("SCMAP_IDE_PLAN_K")
      REFERENCES "CPSAA"."GESAC_MAE_PLAN" ("SCMAP_IDE_PLAN_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "FK_GESAC_MAE_PROC_GESAC_ICONO" FOREIGN KEY ("SCMPC_IDE_PROC_K")
      REFERENCES "CPSAA"."GESAC_MAE_PROC" ("SCMPC_IDE_PROC_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

--PARAMETROS DEL SISTEMA


INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR") VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'CLAVEENSAYO', 'CLAVEENSAYO', MD5('johnvaraamez'));

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR") VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'DIASPERMITIDOS', 'DIASPERMITIDOS', '2');

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR") VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'NROFILASICONO', 'NROFILASICONO','7');

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR") VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'NROCOLUMNASICONO', 'NROCOLUMNASICONO', '7');

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR") VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'DIASPERMITIDOSCEMENTOS', 'DIASPERMITIDOSCEMENTOS','500');

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR")
    VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'CLAVEENSAYOCEMENTOS', 'CLAVEENSAYOCEMENTOS', MD5('johnvaraamez'));

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR")
    VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR),'CLAVEENSAYOPREMEZCLADOS','CLAVEENSAYOPREMEZCLADOS', MD5('johnvaraamez'));

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR")
    VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR), 'DIASPERMITIDOSPREMEZCLADOS', 'DIASPERMITIDOSPREMEZCLADOS','500');

INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR")
    VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1  from  "CPSAA"."GESAC_PAR_SIS" PAR) ,'AGRUPARPONDERAR','AGRUPARPONDERAR','24');

--INFORMACION DE AUDITORIA

VACUUM "CPSAA"."GESAC_SYS_LOG_TABL"


---PARA LA ADMINISTRACION DE INFORMACION DE AUDITORIA    --->   "CPSAA"."GESAC_SYS_LOG_TABL"    


ALTER TABLE "CPSAA"."GESAC_SYS_LOG_TABL" ADD COLUMN "SCMOE_VALOR_ANTIGUO" numeric(10,4);

ALTER TABLE "CPSAA"."GESAC_SYS_LOG_TABL" ADD COLUMN "SCMOE_VALOR_NUEVO" numeric(10,4);

ALTER TABLE "CPSAA"."GESAC_SYS_LOG_TABL" ADD COLUMN "TIPO_ACTUALIZACION" character varying(50);

CREATE INDEX "GESAC_SYS_LOG_TABL_ENTIDAD_ACCION_FECHA"
  ON "CPSAA"."GESAC_SYS_LOG_TABL"
  USING btree
  ("SCSLT_COC_TABL", "SCSLT_COC_ACC_AUD","SCSLT_FCH_ACC");


CREATE INDEX "PK_GESAC_SYS_LOG_TABL_SCSLT_SCSLT_IDE_LOG_TABL_K"
  ON "CPSAA"."GESAC_SYS_LOG_TABL"
  USING btree
  ("SCSLT_IDE_LOG_TABL_K");

ALTER TABLE "CPSAA"."GESAC_MAE_PROC" ADD COLUMN "SCMPC_NOM_NEGO" character varying(80);


---------Prefabricados
UPDATE "CPSAA"."GESAC_MAE_PROC" SET "SCMPC_NOM_NEGO"='Prefabricados' WHERE "SCMPC_IDE_PROC_K" IN (SELECT proceBase."SCMPC_IDE_PROC_K" FROM "CPSAA"."GESAC_MAE_PROC" proc INNER JOIN "CPSAA"."GESAC_MAE_PROC" proceBase ON proc."SCMPC_IDE_PROC_K"= proceBase."SCMPC_IDE_PROC_BASE_K" WHERE (proc."SCMPC_NOM_PROC"='Almac. y Despacho de Prefabricados' ) OR (proc."SCMPC_NOM_PROC"='Elaboraci�n de productos prefabricados'));

--------Concreto
UPDATE "CPSAA"."GESAC_MAE_PROC"   set "SCMPC_NOM_NEGO"='Concreto' WHERE "SCMPC_IDE_PROC_K" IN
(SELECT proceBase."SCMPC_IDE_PROC_K" FROM "CPSAA"."GESAC_MAE_PROC" proc INNER JOIN "CPSAA"."GESAC_MAE_PROC" proceBase ON proc."SCMPC_IDE_PROC_K"=proceBase."SCMPC_IDE_PROC_BASE_K" 
 WHERE  (proc."SCMPC_NOM_PROC"='[x] Transp. y sumin. de concreto pmz' ) OR (proc."SCMPC_NOM_PROC"='[x] Transp. y sumin. de concreto en disp.' ) OR
(proc."SCMPC_NOM_PROC"='Elab., transp. y sumin. de concreto pmz.' ) OR (proc."SCMPC_NOM_PROC"='Transp., elab. y sumin. de concreto en disp.' ) OR (proc."SCMPC_NOM_PROC"='Elab., transp. y sumin. de mortero pmz.' ));


  --------Premezclados
UPDATE "CPSAA"."GESAC_MAE_PROC"   set "SCMPC_NOM_NEGO"='Premezclados' WHERE "SCMPC_IDE_PROC_K" IN
(SELECT   proceBase."SCMPC_IDE_PROC_K" FROM "CPSAA"."GESAC_MAE_PROC"  proc  inner join  "CPSAA"."GESAC_MAE_PROC"  proceBase ON proc."SCMPC_IDE_PROC_K"=proceBase."SCMPC_IDE_PROC_BASE_K" 
WHERE  (proc."SCMPC_NOM_PROC"='Recepci�n y almacenaje de M.P.' ) OR (proc."SCMPC_NOM_PROC"='Zarandeo y chancado de agregados' ));


--MODIFICAR

INSERT INTO "CPSAA"."GESAC_MAE_PERM"("SCMAP_IDE_PERM_K", "SCMAP_COC_PERM", "SCMAP_NOM_PERM","SCMAP_GLS_DES","SCMAP_GLS_MOD_FUN", "SCMAP_GLS_CAS_USO", "SCMAP_COC_EST")
    VALUES ((SELECT coalesce(max(PER."SCMAP_IDE_PERM_K"),0) + 1 FROM "CPSAA"."GESAC_MAE_PERM" PER), 'CAL013_PER_001', 'Permisos para Iconos de Acceso Directo','Facilita la busqueda en la func. Buscar por Rango Muestra','CAL', 'CAL013', 'ACT');

INSERT INTO "CPSAA"."GESAC_DET_PERM_ROL"("SCDPR_IDE_PERM_ROL_K", "SCMAP_IDE_PERM_K", "SCMAR_IDE_ROL_K","SCDPR_FLG_ELI", "SCDPR_COC_EST")
    VALUES ((SELECT coalesce(max(PER."SCDPR_IDE_PERM_ROL_K"),0) + 1 FROM "CPSAA"."GESAC_DET_PERM_ROL" PER), (SELECT MAX("SCMAP_IDE_PERM_K") FROM "CPSAA"."GESAC_MAE_PERM"), 26,'N', 'ACT');


INSERT INTO "CPSAA"."GESAC_DET_PERM_ROL"("SCDPR_IDE_PERM_ROL_K", "SCMAP_IDE_PERM_K", "SCMAR_IDE_ROL_K","SCDPR_FLG_ELI", "SCDPR_COC_EST")
    VALUES ((SELECT coalesce(max(PER."SCDPR_IDE_PERM_ROL_K"),0) + 1 FROM "CPSAA"."GESAC_DET_PERM_ROL" PER), (SELECT MAX("SCMAP_IDE_PERM_K") FROM "CPSAA"."GESAC_MAE_PERM"), 4,'N', 'ACT');

--NUEVO PERMISO en el 10.10.17.13 ya est�

--INSERT INTO "CPSAA"."GESAC_MAE_PERM"(
--            "SCMAP_IDE_PERM_K", "SCMAP_COC_PERM", "SCMAP_NOM_PERM", "SCMAP_GLS_DES","SCMAP_GLS_MOD_FUN","SCMAP_GLS_CAS_USO","SCMAP_COC_EST")
--    VALUES ((SELECT coalesce(max(PAR."SCMAP_IDE_PERM_K"),0) + 1  from  "CPSAA"."GESAC_MAE_PERM" PAR) ,'CAL014 PER 001','Registrar ensayo rango muestra - Check Muestras especiales','Registrar ensayo rango muestra - Check Muestras especiales','CAL','CAL014','ACT');


INSERT INTO "CPSAA"."GESAC_SYS_TABL_GENE"("SCSTG_IDE_TAB_GEN_K", "SCSTG_COD_TAB_GEN", "SCSTG_COD_LLA_TAB", "SCSTG_NRO_ORD", "SCSTG_NOM_TAB", "SCSTG_NOM_TAB_MOS", "SCSTG_GLS_DES") VALUES ((select max("SCSTG_IDE_TAB_GEN_K") + 1 from  "CPSAA"."GESAC_SYS_TABL_GENE"),'ACCAUD','REE', 4, NULL,'Reemplazo', null);


--INSERT INTO "CPSAA"."GESAC_MAE_EQUI"  ("SCMEQ_IDE_EQUI_K", "SCMPC_IDE_PROC_K", "SCMEQ_NOM_EQUI", "SCMEQ_GLS_SIG", "SCMEQ_GLS_DES", "SCMEQ_COC_EST") VALUES (0,10, 'Gen�rico', 'Gen�rico', NULL, 'ACT'); 