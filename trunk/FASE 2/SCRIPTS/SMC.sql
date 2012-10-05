
-- Function: registrar_lote_no_enviado(numeric, character, character)
-- DROP FUNCTION registrar_lote_no_enviado(numeric, character, character);

--select registrar_lote_no_enviado(33361, 'CON','ACT')
CREATE OR REPLACE FUNCTION registrar_lote_no_enviado(numeric, character,
character)
   RETURNS character varying AS
$BODY$
DECLARE
        existeRegistro numeric:=0;
  BEGIN
  SELECT COUNT(*)FROM "CPSAA"."GESAC_AUX_ERROR_SAC_SAP"
                  WHERE "SCMOL_IDE_LOTE_K"=$1
                  AND "SCD_ACCION" = $3 INTO existeRegistro;


    IF(existeRegistro=0) THEN

      INSERT INTO  "CPSAA"."GESAC_AUX_ERROR_SAC_SAP"
("SCMOL_IDE_LOTE_K","SCMOL_COC_EST",

"SCD_IDE_ERROR_DESCRIPCION","SCD_ACCION")
      SELECT "SCMOL_IDE_LOTE_K", "SCMOL_COC_EST",$2,$3
      FROM "CPSAA"."GESAC_MOV_LOTE"
      WHERE "SCMOL_IDE_LOTE_K"=$1;
    ELSE
      UPDATE "CPSAA"."GESAC_AUX_ERROR_SAC_SAP"
      SET "SCMOL_COC_EST"=(SELECT "SCMOL_COC_EST" FROM
"CPSAA"."GESAC_MOV_LOTE" WHERE "SCMOL_IDE_LOTE_K"=$1)
      WHERE "SCMOL_IDE_LOTE_K"=$1
      AND "SCD_ACCION"=$3;


    END IF;
   RETURN 'Registrado con exito';

  END;
  $BODY$
   LANGUAGE plpgsql VOLATILE
   COST 100;
ALTER FUNCTION registrar_lote_no_enviado(numeric, character, character)
OWNER TO postgres;


CREATE OR REPLACE FUNCTION cantidad_lote(numeric)
  RETURNS character varying AS
$BODY$
DECLARE
       CANTIDAD varchar;
 BEGIN

  SELECT INTO CANTIDAD (COALESCE("SCMOL_VLR_TAM",0.00)) FROM
"CPSAA"."GESAC_MOV_LOTE"
  WHERE "SCMOL_IDE_LOTE_K"=$1;

  RETURN CANTIDAD;

 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cantidad_lote(numeric) OWNER TO postgres;


--------------------------------------------------------------------------------------------------------------------------------------------------------


-- Function: registro_sac_sap(numeric, numeric, numeric)

-- DROP FUNCTION registro_sac_sap(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION registro_sac_sap(numeric, numeric, numeric)
  RETURNS character varying AS
$BODY$
DECLARE        
       resultado  varchar:='0-0';
       estadoPrueba28  varchar:='0';
       estadoPrueba7   varchar:='0';
       estadoPrueba14  varchar:='0';
       estadoOtroPrueba  varchar:='0';
       esResistencia28Dias Integer := 0;
       esResistencia7Dias Integer := 0;
       esResistencia14Dias Integer := 0;
       otrasPruebasEstadoNOC Integer := 0;
       otrasPruebasEstadoCON Integer := 0;
       otrasPruebas          numeric := 0;
       idMuestra             numeric:=0;
       idLote numeric(10,0); 


     
 BEGIN   


    SELECT "SCMOM_IDE_MUES_K" FROM "CPSAA"."GESAC_MOV_MUES"
                              WHERE "SCMOL_IDE_LOTE_K"=$3  INTO idMuestra;



    SELECT existeResistenciaCompresion28Dias(idMuestra) INTO esResistencia28Dias;
    SELECT existeResistenciaCompresion7Dias(idMuestra) INTO esResistencia7Dias;
    SELECT existeResistenciaCompresion14Dias(idMuestra) INTO esResistencia14Dias;





    SELECT COUNT(*)  FROM "CPSAA"."GESAC_MOV_ENSA"
				      WHERE "SCMOM_IDE_MUES_K" = idMuestra
				      AND   "SCMOE_COC_EST_TRA" = 'NOC' INTO otrasPruebasEstadoNOC;
    SELECT COUNT(*)  FROM  "CPSAA"."GESAC_MOV_ENSA"
				      WHERE "SCMOM_IDE_MUES_K" = idMuestra
				      AND   "SCMOE_COC_EST_TRA" = 'CON' INTO otrasPruebasEstadoCON;	
   IF(esResistencia28Dias=1) THEN
     SELECT INTO estadoPrueba28 'NCO';
    ELSIF(esResistencia28Dias=2) THEN
     SELECT INTO estadoPrueba28  'CON';
    ELSIF(esResistencia28Dias=0)  THEN
     SELECT INTO estadoPrueba28 '0';
    END IF;

   IF(esResistencia7Dias=1) THEN
     SELECT INTO estadoPrueba7 'NCO';
    ELSIF(esResistencia7Dias=2) THEN
     SELECT INTO estadoPrueba7  'CON';
    ELSIF(esResistencia7Dias=0)  THEN
     SELECT INTO estadoPrueba7 '0';
    END IF;

    IF(esResistencia14Dias=1) THEN
     SELECT INTO estadoPrueba14 'NCO';
    ELSIF(esResistencia14Dias=2) THEN
     SELECT INTO estadoPrueba14  'CON';
    ELSIF(esResistencia14Dias=0)  THEN
     SELECT INTO estadoPrueba14 '0';
    END IF;



    IF(otrasPruebasEstadoNOC>0) THEN
      SELECT INTO estadoOtroPrueba 'NCO';
    ELSIF(otrasPruebasEstadoCON>0)  THEN
      SELECT INTO estadoOtroPrueba 'CON';
    ELSIF(otrasPruebasEstadoCON=0)  THEN
      SELECT INTO estadoOtroPrueba '0';
      
    END IF;		      

  
  RETURN estadoPrueba28|| '-' ||estadoPrueba14|| '-' ||estadoPrueba7|| '-' ||estadoOtroPrueba;   

           
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION registro_sac_sap(numeric, numeric, numeric) OWNER TO postgres;


------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------


-- Function: loteeliminadonoenviado(numeric, character varying, character)

-- DROP FUNCTION loteeliminadonoenviado(numeric, character varying, character);

CREATE OR REPLACE FUNCTION loteeliminadonoenviado(numeric, character varying, character)
  RETURNS character varying AS
$BODY$
DECLARE        
       CANTIDAD varchar;
 BEGIN     

   INSERT INTO  "CPSAA"."GESAC_AUX_ERROR_SAC_SAP"  ("SCMOL_IDE_LOTE_K", "SCMAP_IDE_PLAN_K",  "SCMPR_IDE_PROD_K", "SCMOL_COC_COL_PROD", "SCMTU_IDE_TURN_K",
   "SCMOL_FCH_HOR_REG",  "SCMOL_FCH_HOR_INI_PRO", "SCMOL_FCH_HOR_FIN_PRO", "SCMOL_COC_EST",
   "SCMOL_VLR_TAM", "SCMOL_COC_UNI_MED_TAM", "SCMOL_GLS_DOS", "SCMOL_GLS_DES", "SCMOL_GLS_CLIENTE",
   "SCMOL_GLS_OBRA", "SCMOL_GLS_ESTRUCTURA", "SCMOL_GLS_NRO_REMITO_BOLETA", "SCMOL_FLAG_ENVIADO","SCD_IDE_ERROR_DESCRIPCION","SCD_ACCION")
   SELECT "SCMOL_IDE_LOTE_K", "SCMAP_IDE_PLAN_K",  "SCMPR_IDE_PROD_K", "SCMOL_COC_COL_PROD", "SCMTU_IDE_TURN_K",
	    "SCMOL_FCH_HOR_REG",  "SCMOL_FCH_HOR_INI_PRO", "SCMOL_FCH_HOR_FIN_PRO", "SCMOL_COC_EST",
		"SCMOL_VLR_TAM", "SCMOL_COC_UNI_MED_TAM", "SCMOL_GLS_DOS", "SCMOL_GLS_DES", "SCMOL_GLS_CLIENTE",
	    "SCMOL_GLS_OBRA", "SCMOL_GLS_ESTRUCTURA", "SCMOL_GLS_NRO_REMITO_BOLETA", "SCMOL_FLAG_ENVIADO",$2,$3
	    FROM "CPSAA"."GESAC_MOV_LOTE"
	    WHERE "SCMOL_IDE_LOTE_K"=$1;

  

  RETURN CANTIDAD;     
           
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION loteeliminadonoenviado(numeric, character varying, character) OWNER TO postgres;


------------------------------------------------------------------------------------------------------------------------------------------------


-- Function: enviar_lotes_prefabricados_sap(numeric, numeric, numeric, timestamp without time zone, timestamp without time zone, numeric, numeric, numeric, character, numeric, numeric)

-- DROP FUNCTION enviar_lotes_prefabricados_sap(numeric, numeric, numeric, timestamp without time zone, timestamp without time zone, numeric, numeric, numeric, character, numeric, numeric);

CREATE OR REPLACE FUNCTION enviar_lotes_prefabricados_sap(numeric, numeric, numeric, timestamp without time zone, timestamp without time zone, numeric, numeric, numeric, character, numeric, numeric)
  RETURNS character varying AS
$BODY$
DECLARE        
       CANTIDAD varchar;
 BEGIN   

  SELECT INTO CANTIDAD 	(SELECT
			ML."SCMOL_IDE_LOTE_K" as id,
			MP."SCMPR_NOM_PROD"  as "producto.nombre",
			ML."SCMOL_FCH_HOR_INI_PRO" as fechaInicioProduccion,
			MT."SCMTU_NOM_TURN" as "turno.nombre",
			ML."SCMOL_VLR_TAM" as tamano,
			ML."SCMOL_COC_UNI_MED_TAM" as codigoUnidadMedida,
			ML."SCMOL_COC_EST" as codigoEstado,
			ML."SCMOL_COC_COL_PROD" as codigoColor,
			ML."SCMOL_GLS_DES" as descripcion,
			ML."SCMOL_FCH_HOR_REG" as fechaRegistro,
			PL."SCMAP_IDE_PLAN_K" as "planta.id",
			EM."SCMAE_IDE_EMPR_K" as "planta.empresa.id",
                        ML."SCMOL_GLS_CLIENTE" as cliente,
			ML."SCMOL_GLS_OBRA" as obra,
			ML."SCMOL_GLS_ESTRUCTURA" as estructura,
			ML."SCMOL_GLS_NRO_REMITO_BOLETA" as nroRemitoBoletaDespacho,
			NE."SCMAN_IDE_NEGO_K" as "producto.lineaProducto.negocio.id"
							
		FROM
			"CPSAA"."GESAC_MOV_LOTE" ML,
			"CPSAA"."GESAC_MAE_TURN" MT,
			"CPSAA"."GESAC_MAE_PROD" MP,
			"CPSAA"."GESAC_MAE_EMPR" EM ,
			"CPSAA"."GESAC_MAE_LINE_PROD" LP ,
			"CPSAA"."GESAC_MAE_PLAN" PL,
			"CPSAA"."GESAC_MAE_NEGO" NE
			
		WHERE
		
		        MP."SCMPR_COC_EST"='ACT' 
		        AND ML."SCMTU_IDE_TURN_K" = MT."SCMTU_IDE_TURN_K"
			AND ML."SCMPR_IDE_PROD_K" = MP."SCMPR_IDE_PROD_K"
			AND MP."SCMLP_IDE_LINE_PROD_K" = LP."SCMLP_IDE_LINE_PROD_K"
			AND ML."SCMAP_IDE_PLAN_K"= PL."SCMAP_IDE_PLAN_K" 
			AND PL."SCMAE_IDE_EMPR_K"=EM."SCMAE_IDE_EMPR_K"
			AND NE."SCMAN_IDE_NEGO_K"=LP."SCMAN_IDE_NEGO_K"			
			AND ML."SCMOL_IDE_LOTE_K" = $1
			AND EM."SCMAE_IDE_EMPR_K" = $2
			AND ML."SCMAP_IDE_PLAN_K" = $3
			AND to_date(to_char(ML."SCMOL_FCH_HOR_INI_PRO", 'yyyy/mm/dd'), 'yyyy/mm/dd') >= $4
			AND to_date(to_char(ML."SCMOL_FCH_HOR_INI_PRO", 'yyyy/mm/dd'), 'yyyy/mm/dd') <= $5
			AND ML."SCMPR_IDE_PROD_K" = $6
			AND LP."SCMLP_IDE_LINE_PROD_K" = $7
			AND ML."SCMTU_IDE_TURN_K" = $8
			AND ML."SCMOL_COC_EST" = $9

		ORDER BY 
			ML."SCMOL_FCH_HOR_INI_PRO" DESC
		LIMIT
			$10
		OFFSET
			$11);	


  

  
  RETURN CANTIDAD;     
           
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION enviar_lotes_prefabricados_sap(numeric, numeric, numeric, timestamp without time zone, timestamp without time zone, numeric, numeric, numeric, character, numeric, numeric) OWNER TO postgres;






**********************************************************


-- Table: "CPSAA"."GESAC_AUX_ERROR_SAC_SAP"

-- DROP TABLE "CPSAA"."GESAC_AUX_ERROR_SAC_SAP";

CREATE TABLE "CPSAA"."GESAC_AUX_ERROR_SAC_SAP"
(
  "SCDA_IDE_ERROR" SERIAL,
  "SCD_IDE_ERROR_DESCRIPCION" character varying(500),
  "SCMOL_IDE_LOTE_K" numeric(10,0),
  "SCD_ACCION" character(3),
  "SCMAP_IDE_PLAN_K" numeric(10,0),
  "SCMPR_IDE_PROD_K" numeric(10,0),
  "SCMOL_COC_COL_PROD" character varying(3),
  "SCMTU_IDE_TURN_K" numeric(10,0),
  "SCMOL_COC_EST" character varying(3),
  "SCMOL_VLR_TAM" numeric(10,2),
  "SCMOL_COC_UNI_MED_TAM" character varying(3),
  "SCMOL_GLS_DOS" character varying(500),
  "SCMOL_GLS_DES" character varying(500),
  "SCMOL_GLS_CLIENTE" character varying(500),
  "SCMOL_GLS_OBRA" character varying(500),
  "SCMOL_GLS_NRO_REMITO_BOLETA" character varying(500),
  "SCMOL_FLAG_ENVIADO" numeric,
  "SCMOL_FCH_HOR_REG" timestamp without time zone,
  "SCMOL_FCH_HOR_INI_PRO" timestamp without time zone,
  "SCMOL_FCH_HOR_FIN_PRO" timestamp without time zone,
  "SCMOL_GLS_ESTRUCTURA" character varying(500),
  CONSTRAINT "PK_SCDA_IDE_ERROR" PRIMARY KEY ("SCDA_IDE_ERROR")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "CPSAA"."GESAC_AUX_ERROR_SAC_SAP" OWNER TO postgres;




*****************************************************



ALTER TABLE "CPSAA"."GESAC_MOV_LOTE" ADD COLUMN "SCMOL_FLAG_ENVIADO" numeric;
ALTER TABLE "CPSAA"."GESAC_MOV_LOTE" ALTER COLUMN "SCMOL_FLAG_ENVIADO" SET DEFAULT 0;


****************************************************


ALTER TABLE "CPSAA"."GESAC_MOV_LOTE" ADD COLUMN "SCMOL_FLAG_ENVIADO" numeric;
ALTER TABLE "CPSAA"."GESAC_MOV_LOTE" ALTER COLUMN "SCMOL_FLAG_ENVIADO" SET DEFAULT 0;

****************************************************


-- Column: "SCMPR_COD_MATERIAL_SAP"

-- ALTER TABLE "CPSAA"."GESAC_MAE_PROD" DROP COLUMN "SCMPR_COD_MATERIAL_SAP";

ALTER TABLE "CPSAA"."GESAC_MAE_PROD" ADD COLUMN "SCMPR_COD_MATERIAL_SAP" character varying(10);

*****************************************************

ALTER TABLE "CPSAA"."GESAC_MAE_PLAN" ADD COLUMN "SCMAP_COC_EST" character varying(3);

*****************************************************

ALTER TABLE "CPSAA"."GESAC_MAE_PLAN" ADD COLUMN "SCMAP_COD_CENTRO" character varying(10);


*************************************************

ALTER TABLE "CPSAA"."GESAC_MAE_PLAN" ADD COLUMN "SCMAP_COD_ALMACEN" character varying(10);


**********************************************

ALTER TABLE "CPSAA"."GESAC_MAE_PLAN" ADD COLUMN "SCMAP_COD_INPUTACION" character varying(10);


*******************************************

UPDATE "CPSAA"."GESAC_MAE_PLAN"
SET "SCMAP_COD_CENTRO"=1205, "SCMAP_COD_ALMACEN"=1267, "SCMAP_COD_INPUTACION"=51401 WHERE "SCMAP_IDE_PLAN_K" = 2;

UPDATE "CPSAA"."GESAC_MAE_PLAN"
SET "SCMAP_COD_CENTRO"=1211, "SCMAP_COD_ALMACEN"=1267, "SCMAP_COD_INPUTACION"=51401 WHERE "SCMAP_IDE_PLAN_K" = 5;

UPDATE "CPSAA"."GESAC_MAE_PLAN"
SET "SCMAP_COD_CENTRO"=1213, "SCMAP_COD_ALMACEN"=1267, "SCMAP_COD_INPUTACION"=51401 WHERE "SCMAP_IDE_PLAN_K" = 6;
 
 
 
 SELECT * FROM "CPSAA"."GESAC_MAE_PROD" WHERE "SCMPR_NOM_PROD" LIKE '%Pared 12 TMS%';
 SELECT * FROM "CPSAA"."GESAC_MAE_PROD" WHERE "SCMPR_NOM_PROD" LIKE '%Pared 14 TMS%';
 SELECT * FROM "CPSAA"."GESAC_MAE_PROD" WHERE "SCMPR_NOM_PROD" LIKE '%Adoquín 6 TMS%';
 SELECT * FROM "CPSAA"."GESAC_MAE_PROD" WHERE "SCMPR_NOM_PROD" LIKE '%Adoquín 8 TMS%';
 SELECT * FROM "CPSAA"."GESAC_MAE_PROD" WHERE "SCMPR_NOM_PROD" LIKE '%Adoquín 4 TMS%';
 SELECT * FROM "CPSAA"."GESAC_MAE_PROD" WHERE "SCMPR_NOM_PROD" LIKE '%Pared 9 TMS%';
 
  
 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '00400058' WHERE "SCMPR_NOM_PROD" = 'Pared 12 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '00400059' WHERE "SCMPR_NOM_PROD" = 'Pared 14 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '00400070' WHERE "SCMPR_NOM_PROD" = 'Adoquín 6 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '00400077' WHERE "SCMPR_NOM_PROD" = 'Adoquín 8 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '00400147' WHERE "SCMPR_NOM_PROD" = 'Pared 9 TMS'; 

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '00400213' WHERE "SCMPR_NOM_PROD" = 'Adoquín 4 TMS';



--GRANULOMETRIA



CREATE TABLE "CPSAA"."GESAC_MAE_ESPEC"
(
  "SCMAE_IDE_ESPEC_K" SERIAL,
  "SCMAE_DESCRIPCION" character varying(50),
  CONSTRAINT "PK_SCMAE_IDE_ESPEC" PRIMARY KEY ("SCMAE_IDE_ESPEC_K")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "CPSAA"."GESAC_MAE_ESPEC" OWNER TO postgres;





CREATE TABLE "CPSAA"."GESAC_DET_ESPEC"
(
  "SCDET_IDE_ESPEC_K" SERIAL,
  "SCMAE_IDE_ESPEC_K" integer,
  "SCMPC_MAX" numeric(10,0),
  "SCMPC_MIN" numeric(10,0),
  "SCMPC_A" numeric(10,0),
  "SCMPC_B" numeric(10,0),
  "SCMPC_C" numeric(10,0),
  "SCMPC_F" numeric(10,0),
  CONSTRAINT "PK_SCMAE_SCDET_IDE_ESPEC_K" PRIMARY KEY ("SCDET_IDE_ESPEC_K"),
  CONSTRAINT "FK_SCDET_IDE_ESPEC_K_GESAC_MAE_ESPEC" FOREIGN KEY ("SCMAE_IDE_ESPEC_K")
      REFERENCES "CPSAA"."GESAC_MAE_ESPEC" ("SCMAE_IDE_ESPEC_K") MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "CPSAA"."GESAC_DET_ESPEC" OWNER TO postgres;





INSERT INTO "CPSAA"."GESAC_MAE_ESPEC" ("SCMAE_IDE_ESPEC_K","SCMAE_DESCRIPCION") VALUES (1,'ACI 304');
INSERT INTO "CPSAA"."GESAC_MAE_ESPEC" ("SCMAE_IDE_ESPEC_K","SCMAE_DESCRIPCION") VALUES (2,'ESP DIN 1045');
INSERT INTO "CPSAA"."GESAC_MAE_ESPEC" ("SCMAE_IDE_ESPEC_K","SCMAE_DESCRIPCION") VALUES (3,'FULLER');

  

INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (1,1,100,100);   
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (2,1,100,100);        
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (3,1,100,100);   
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (4,1,100,100);        
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (5,1,80,88);       
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (6,1,63,75);        
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (7,1,55,70);        
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (8,1,40,57);        
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (9,1,28,47);       
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (10,1,18,35);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (11,1,12,25);        
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (12,1,7,15);     
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (13,1,3,8);      
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (14,1,0,0);       
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_MAX","SCMPC_MIN") VALUES (15,1,0,0);  


INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (16,2,100,100,100);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (17,2,100,100,100);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (18,2,100,100,100);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (19,2,82,90,95);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (20,2,70,84,92);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (21,2,53,73,84);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (22,2,44,66,79);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (23,2,26,50,67);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (24,2,16,38,55);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (25,2,10,30,44);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (26,2,6,20,32);   
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (27,2,2,10,18);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (28,2,1,4,8);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (29,2,0,0,0);    
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_A","SCMPC_B","SCMPC_C") VALUES (30,2,0,0,0);    


INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (31,3,100);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (32,3,100);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (33,3,100);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (34,3,100);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (35,3,86.6);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (36,3,70.7);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (37,3,61.2);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (38,3,43.2);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (39,3,30.6);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (40,3,21.6);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (41,3,15.3);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (42,3,10.8);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (43,3,7.7);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (44,3,5.4);
INSERT INTO "CPSAA"."GESAC_DET_ESPEC" ("SCDET_IDE_ESPEC_K","SCMAE_IDE_ESPEC_K","SCMPC_F") VALUES (45,3,0);
    
ALTER TABLE "CPSAA"."GESAC_MOV_UNID_MUES" ADD COLUMN "SCMUM_VLR_PES_INI"
numeric(10,4);



---------------------

ALTER TABLE "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" ALTER COLUMN "SCMGT_COC_HUS" TYPE character varying(4);
---


------------------------------------------------------------------------------------------------------------------------------------------

--select VALORES_TAMIZ()
CREATE OR REPLACE FUNCTION VALORES_TAMIZ()
  RETURNS character varying AS
$BODY$
 BEGIN
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=50.000 WHERE
"SCMTE_NOM_TIPO_ENSA"='2"';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=37.500 WHERE
"SCMTE_NOM_TIPO_ENSA"='1 1/2"';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=25.000 WHERE
"SCMTE_NOM_TIPO_ENSA"='1"';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=19.000 WHERE
"SCMTE_NOM_TIPO_ENSA"='3/4"';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=12.500 WHERE
"SCMTE_NOM_TIPO_ENSA"='1/2"';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=9.500 WHERE
"SCMTE_NOM_TIPO_ENSA"='3/8"';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=4.750 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°4';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=2.360 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°8';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=1.180 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°16';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=0.600 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°30';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=0.300 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°50';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=0.150 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°100';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=0.075 WHERE
"SCMTE_NOM_TIPO_ENSA"='N°200';
 UPDATE "CPSAA"."GESAC_MAE_TIPO_ENSA" SET "SCMTE_GLS_DES"=0 WHERE
"SCMTE_NOM_TIPO_ENSA"='Fondo';
  RETURN 'ok';

 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION VALORES_TAMIZ() OWNER TO postgres;

------------------------------------------------------------------------------------------------------------------------------------------

DATA HUSOS -- AUN NO HA SIDO EJECUTADA BACKUP LOCAL



INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'A.G. chancado TMN=1/2" a 3/4" - H4','H4','A.G. chancado TMN=1/2" a 3/4" - H4','AGR','ACT');	

INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'A.G. zarandeado TMN=1/2" a 3/4" - H4','H4','A.G. zarandeado TMN=1/2" a 3/4" - H4','AGR','ACT');
							  
INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'Agragado fino Chancado','AF','Agragado fino Chancado','AGR','ACT');
							  
INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'Agregado fino zarandeado','AF','Agregado fino zarandeado','AGR','ACT');							  
							  
INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'Agragado fino Chancado M','AF','Agragado fino Chancado M','AGR','ACT');
							  
INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'Agregado fino zarandeado M','AF','Agregado fino zarandeado M','AGR','ACT');

INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST")  
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'AfNat M.Albañ.','AN','AfNat M.Albañ.','AGR','ACT');     
 
INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST")  
                              VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_PRODUCTO"') from "CPSAA"."GESAC_SEQ_ID_PRODUCTO"),'AfMan M.Albañ.','AM','AfMan M.Albañ.','AGR','ACT');

UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_NOM_PROD"='A.G. chancado TMN=1 1/2" a No. 4 - H467' WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1 1/2 a No. 4 - H467';

UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1 1/2" a No. 4 - H467' WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1 1/2 a No. 4 - H467';
							  

-- Function: insertar_huso(numeric, numeric, numeric, character, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric)

-- DROP FUNCTION insertar_huso(numeric, numeric, numeric, character, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION insertar_huso(numeric, numeric, numeric, character, numeric, numeric, 
numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, 
numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric,
numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, 
numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric)
  RETURNS character varying AS
$BODY$
DECLARE        
       CANTIDAD varchar;
       idMatr numeric:=0;
       idGrupTip numeric:=0;
       idTipoEnsa numeric:=0;
       countMatr_Trat integer:=0;
       countGrupTip integer:=0;
 BEGIN     


  IF $5 = 1  THEN
   

   SELECT count(*) FROM  "CPSAA"."GESAC_MAE_MATR_TRAT"
                         WHERE "SCMPC_IDE_PROC_K"=$1
                         AND  "SCMPR_IDE_PROD_K"=$3  INTO countMatr_Trat;
  

   IF countMatr_Trat = 0  THEN
        SELECT nextval('"CPSAA"."GESAC_SEQ_ID_MATRIZT"') from "CPSAA"."GESAC_SEQ_ID_MATRIZT" INTO idMatr;      
        INSERT INTO "CPSAA"."GESAC_MAE_MATR_TRAT" ("SCMMT_IDE_MATR_TRAT_K","SCMPC_IDE_PROC_K","SCMPR_IDE_PROD_K",
                                                  "SCMMT_NOM_MATR_TRAT","SCMMT_GLS_DES","SCMGT_FLG_RES","SCMMT_COC_EST")  VALUES 
                                                  (idMatr,$1,$3,(SELECT "SCMPR_NOM_PROD" FROM "CPSAA"."GESAC_MAE_PROD" 
                                                          WHERE "SCMPR_IDE_PROD_K"=$3) ,'','N','ACT');
   ELSE
       SELECT "SCMMT_IDE_MATR_TRAT_K" FROM  "CPSAA"."GESAC_MAE_MATR_TRAT"
                                      WHERE "SCMPC_IDE_PROC_K"=$1
                                      AND  "SCMPR_IDE_PROD_K"=$3  INTO idMatr;
   END IF;



    SELECT count(*) FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO countGrupTip;

    IF countGrupTip = 0 THEN
                                                          
     SELECT nextval('"CPSAA"."GESAC_SEQ_ID_GRUPOTE"') from "CPSAA"."GESAC_SEQ_ID_GRUPOTE" INTO idGrupTip;  
     INSERT INTO "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" ("SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMMT_IDE_MATR_TRAT_K","SCMGT_NOM_GRUP_TIPO_ENSA",
				  	            "SCMGT_COC_CAT_TIPO_ENSA","SCMGT_COC_HUS","SCMGT_COC_EST","SCMGT_COC_TIPO_GRUP_TIPO_ENSA","SCMGT_FLG_HUS_GRA")  VALUES
					            (idGrupTip,idMatr,'Análisis Granulométrico','FIS',$4,'ACT','GRA','S');
    ELSE 
     SELECT "SCMMT_IDE_MATR_TRAT_K" FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO idGrupTip;

    END IF;



	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES 
	(idTipoEnsa,idGrupTip,51,'2"','50.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');
	
	
	
	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$20,$7);



											 
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,52,'1 1/2"','37.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$21,$8);											 
									 
											 
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,53,'1"','25.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$22,$9);
	

	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,54,'3/4"','19.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$23,$10);

	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,55,'1/2"','12.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$24,$11);

                               
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,56,'3/8"','9.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');


	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$25,$12);

                               
      SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,57,'N°4','4.750','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');


	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$26,$13);

                                  
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,58,'N°8','2.360','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$27,$14);

                            
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,59,'N°16','1.180','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$28,$15);

                                 
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,60,'N°30','0.600','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$29,$16);

                                 
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,61,'N°50','0.300','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$30,$17);

                             
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,62,'N°100','0.150','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$31,$18);

                            
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,63,'N°200','0.075','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',$32,$19);
                        
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,64,'Fondo','FONDO','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON',0,0);

                                             
	SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,65,'MF','','S',1,'N','N','','Asistente de Control de Calidad','S','N','N','N','S','S','S','N',2,'ACT','N','N','N');




   SELECT count(*) FROM  "CPSAA"."GESAC_MAE_MATR_TRAT"
                         WHERE "SCMPC_IDE_PROC_K"=$2
                         AND  "SCMPR_IDE_PROD_K"=$3  INTO countMatr_Trat;
  

   IF countMatr_Trat = 0  THEN
          SELECT nextval('"CPSAA"."GESAC_SEQ_ID_MATRIZT"') from "CPSAA"."GESAC_SEQ_ID_MATRIZT" INTO idMatr;                                                          
                  INSERT INTO "CPSAA"."GESAC_MAE_MATR_TRAT" ("SCMMT_IDE_MATR_TRAT_K","SCMPC_IDE_PROC_K","SCMPR_IDE_PROD_K",
                                                             "SCMMT_NOM_MATR_TRAT","SCMMT_GLS_DES","SCMGT_FLG_RES","SCMMT_COC_EST")  VALUES 
                                                             (idMatr,$2,$3,(SELECT "SCMPR_NOM_PROD" 
							       FROM "CPSAA"."GESAC_MAE_PROD" 
							        WHERE "SCMPR_IDE_PROD_K"=$3),'','N','ACT');
   ELSE
       SELECT "SCMMT_IDE_MATR_TRAT_K" FROM  "CPSAA"."GESAC_MAE_MATR_TRAT"
                                      WHERE "SCMPC_IDE_PROC_K"=$2
                                      AND  "SCMPR_IDE_PROD_K"=$3  INTO idMatr;
   END IF;



    END IF;



   
    IF $6 = 1  THEN					  

   
    SELECT count(*) FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO countGrupTip;

    IF countGrupTip =0 THEN
                                                          
     SELECT nextval('"CPSAA"."GESAC_SEQ_ID_GRUPOTE"') from "CPSAA"."GESAC_SEQ_ID_GRUPOTE" INTO idGrupTip;  
     INSERT INTO "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" ("SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMMT_IDE_MATR_TRAT_K","SCMGT_NOM_GRUP_TIPO_ENSA",
				  	            "SCMGT_COC_CAT_TIPO_ENSA","SCMGT_COC_HUS","SCMGT_COC_EST","SCMGT_COC_TIPO_GRUP_TIPO_ENSA","SCMGT_FLG_HUS_GRA")  VALUES
					            (idGrupTip,idMatr,'Análisis Granulométrico','FIS',$4,'ACT','GRA','S');
								
								
    ELSE 
     SELECT "SCMMT_IDE_MATR_TRAT_K" FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO idGrupTip;

    END IF;

                                                                                                           

					  

  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES 
 (idTipoEnsa,idGrupTip,51,'2"','50.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$46,$33);

                                   
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
 (idTipoEnsa,idGrupTip,52,'1 1/2"','37.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$47,$34);

                                     
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
 (idTipoEnsa,idGrupTip,53,'1"','25.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$48,$35);

                               
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,54,'3/4"','19.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$49,$36);

                                      
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,55,'1/2"','12.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$50,$37);

                                      
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,56,'3/8"','9.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$51,$38);

                                      
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,57,'N°4','4.750','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$52,$39);

                                         
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,58,'N°8','2.360','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$53,$40);

                                      
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,59,'N°16','1.180','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$54,$41);

                                        
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,60,'N°30','0.600','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$55,$42);

                                        
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,61,'N°50','0.300','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$56,$43);

                                           
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,62,'N°100','0.150','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$57,$44);

                                         
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,63,'N°200','0.075','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',$58,$45);

                                 
  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,64,'Fondo','FONDO','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT","SCMOC_VLR_CONT_SUP_PRO","SCMOC_VLR_CONT_INF_PRO") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON',0,0);


  SELECT nextval('"CPSAA"."GESAC_SEQ_ID_TIPOENSAYO"') from "CPSAA"."GESAC_SEQ_ID_TIPOENSAYO" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,65,'MF','','S',1,'N','N','','Asistente de Control de Calidad','S','N','N','N','S','S','S','N',2,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');
                                            
    
		

  END IF;					  

  RETURN '1';     
           
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION insertar_huso(numeric, numeric, numeric, character, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric, numeric) OWNER TO postgres;


-- Function: insertar_huso_x_planta(character, numeric, numeric, character, numeric, numeric, numeric, numeric)

-- DROP FUNCTION insertar_huso_x_planta(character, numeric, numeric, character, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION insertar_huso_x_planta(character, numeric, numeric, character, numeric, numeric, numeric, numeric)
  RETURNS character varying AS
$BODY$
DECLARE      
       idProceso1 numeric:=0;
       idProceso2 numeric:=0;

       idProducto1 numeric:=0;
       idProducto2 numeric:=0;
       idProducto3 numeric:=0;
       idProducto4 numeric:=0;
       idProducto5 numeric:=0;
       idProducto6 numeric:=0;
       idProducto7 numeric:=0;
       idProducto8 numeric:=0;
       idProducto9 numeric:=0;
       idProducto10 numeric:=0;
       idProducto11 numeric:=0;
       idProducto12 numeric:=0;
       idProducto13 numeric:=0;
       idProducto14 numeric:=0;
       idProducto15 numeric:=0;
       idProducto16 numeric:=0;
       idProducto17 numeric:=0;
       idProducto18 numeric:=0;
       idProducto19 numeric:=0;
       idProducto20 numeric:=0;
       idProducto21 numeric:=0;
       idProducto22 numeric:=0;
       idProducto23 numeric:=0;
       idProducto24 numeric:=0;
       idProducto25 numeric:=0;
       idProducto26 numeric:=0;
       idProducto27 numeric:=0;
       idProducto28 numeric:=0;
       idProducto29 numeric:=0;
	   idProducto30 numeric:=0;
idProducto31 numeric:=0;
idProducto32 numeric:=0;
       
       insert1 character;
       insert2 character;
       insert3 character;
       insert4 character;
       insert5 character;
       insert6 character;
       insert7 character;
       insert8 character;
       insert9 character;
       insert10 character;
       insert11 character;
       insert12 character;
       insert13 character;
       insert14 character;
       insert15 character;
       insert16 character;
       insert17 character;
       insert18 character;
       insert19 character;
       insert20 character;
       insert21 character;
       insert22 character;
       insert23 character;
       insert24 character;
       insert25 character;
       insert26 character;
       insert27 character;
       insert28 character;
       insert29 character;
	   insert30 character;
	   insert31 character;
	   insert32 character;
	   
	
		p1min2 numeric:=0;
		p1min112 numeric:=0;
		p1min1 numeric:=0;
		p1min34 numeric:=0;
		p1min12 numeric:=0;
		p1min38 numeric:=0;
		p1minN4 numeric:=0;
		p1minN8 numeric:=0;
		p1minN16 numeric:=0;
		p1minN30 numeric:=0;
		p1minN50 numeric:=0;
		p1minN100 numeric:=0;
		p1minN200 numeric:=0;

		p1max2 numeric:=0;
		p1max112 numeric:=0;
		p1max1 numeric:=0;
		p1max34 numeric:=0;
		p1max12 numeric:=0;
		p1max38 numeric:=0;
		p1maxN4 numeric:=0;
		p1maxN8 numeric:=0;
		p1maxN16 numeric:=0;
		p1maxN30 numeric:=0;
		p1maxN50 numeric:=0;
		p1maxN100 numeric:=0;
		p1maxN200 numeric:=0;
		
		p2min2 numeric:=0;
		p2min112 numeric:=0;
		p2min1 numeric:=0;
		p2min34 numeric:=0;
		p2min12 numeric:=0;
		p2min38 numeric:=0;
		p2minN4 numeric:=0;
		p2minN8 numeric:=0;
		p2minN16 numeric:=0;
		p2minN30 numeric:=0;
		p2minN50 numeric:=0;
		p2minN100 numeric:=0;
		p2minN200 numeric:=0;

		p2max2 numeric:=0;
		p2max112 numeric:=0;
		p2max1 numeric:=0;
		p2max34 numeric:=0;
		p2max12 numeric:=0;
		p2max38 numeric:=0;
		p2maxN4 numeric:=0;
		p2maxN8 numeric:=0;
		p2maxN16 numeric:=0;
		p2maxN30 numeric:=0;
		p2maxN50 numeric:=0;
		p2maxN100 numeric:=0;
		p2maxN200 numeric:=0;
	   
	   
 BEGIN     



		SELECT MPR2."SCMPC_IDE_PROC_K" FROM "CPSAA"."GESAC_MAE_PROC" MPR2  INNER JOIN "CPSAA"."GESAC_MAE_PROC" MPR
  		ON MPR."SCMPC_IDE_PROC_K"=MPR2."SCMPC_IDE_PROC_BASE_K" 
      	INNER JOIN "CPSAA"."GESAC_MAE_PLAN" MP	
     		ON MPR2."SCMAP_IDE_PLAN_K" = MP."SCMAP_IDE_PLAN_K"
  		WHERE "SCMAP_NOM_PLAN"=$1 AND MPR."SCMPC_NOM_PROC"='Recepción y almacenaje de M.P.' INTO idProceso1;

		SELECT MPR2."SCMPC_IDE_PROC_K" FROM "CPSAA"."GESAC_MAE_PROC" MPR2 INNER JOIN "CPSAA"."GESAC_MAE_PROC" MPR
    		ON MPR."SCMPC_IDE_PROC_K"=MPR2."SCMPC_IDE_PROC_BASE_K" 
     		INNER JOIN "CPSAA"."GESAC_MAE_PLAN" MP	
       	ON MPR2."SCMAP_IDE_PLAN_K" = MP."SCMAP_IDE_PLAN_K"
		WHERE "SCMAP_NOM_PLAN"=$1 AND MPR."SCMPC_NOM_PROC"='Zarandeo y chancado de agregados' INTO idProceso2;

				  

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1" a 1/2" - H5' INTO idProducto1;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1" a 1/2" - H5' INTO idProducto2;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD"
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=3/4" a 3/8" - H6' INTO idProducto3;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=3/4" a 3/8" - H6' INTO idProducto4;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1/2" a No. 4 - H7' INTO idProducto5;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1/2" a No. 4 - H7' INTO idProducto6;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=3/8" a No. 8 - H8' INTO idProducto7;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=3/8" a No. 8 - H8' INTO idProducto8;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='Agregado fino chancado - H9' INTO idProducto9;
	
	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='Agregado fino zarandeado - H9' INTO idProducto10;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=No. 4 a No. 16 - H9' INTO idProducto11;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=No. 4 a No. 16 - H9' INTO idProducto12;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1" a 3/8" - H56' INTO idProducto13;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1" a 3/8" - H56' INTO idProducto14;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1" a No. 4 - H57' INTO idProducto15;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1" a No. 4 - H57' INTO idProducto16;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado B TMN=1" a No. 4 - H57' INTO idProducto17;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=3/4" a No. 4 - H67' INTO idProducto18;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=3/4" a No. 4 - H67' INTO idProducto19;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado B TMN=3/4" a No. 4 - H67' INTO idProducto20;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=3/8" a No. 16 - H89' INTO idProducto21;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=3/8" a No. 16 - H89' INTO idProducto22;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1 1/2" a No. 4 - H467' INTO idProducto23;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1 1/2" a No. 4 - H467' INTO idProducto24;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. chancado TMN=1/2" a 3/4" - H4' INTO idProducto25;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='A.G. zarandeado TMN=1/2" a 3/4" - H4' INTO idProducto26;

    SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='Agragado fino Chancado' INTO idProducto27;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='Agregado fino zarandeado' INTO idProducto28;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='Agragado fino Chancado M' INTO idProducto29;

	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='Agregado fino zarandeado M' INTO idProducto30;
	
	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='AfNat M.Albañ.'  INTO idProducto31;
	
	SELECT "SCMPR_IDE_PROD_K" FROM "CPSAA"."GESAC_MAE_PROD" 
	WHERE "SCMPR_NOM_PROD"='AfMan M.Albañ.'  INTO idProducto32;
 

	  IF $4 ='H5' THEN
	  
	  --A.G. chancado H5
		p1min2=100;
		p1min112=100;
		p1min1=90;
		p1min34=20;
		p1min12=0;
		p1min38=0;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;
		
		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=55;
		p1max12=10;
		p1max38=5;
		p1maxN4=0;
		p1maxN8=0;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;

	  --A.G. zarandeado H5
		p2min2=100;
		p2min112=100;
		p2min1=90;
		p2min34=20;
		p2min12=0;
		p2min38=0;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;
		
		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=55;
		p2max12=10;
		p2max38=5;
		p2maxN4=0;
		p2maxN8=0;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;
	  
	    IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto1,'H5',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert1;
		END IF;
		
        IF $6 =1 THEN		
		SELECT insertar_huso(idProceso1,idProceso2,idProducto2,'H5',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert2;
	    END IF;
	 ELSIF $4 ='H6' THEN
	  
	    --A.G. chancado H6
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=90;
		p1min12=20;
		p1min38=0;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=55;
		p1max38=15;
		p1maxN4=5;
		p1maxN8=0;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;

		--A.G. zarandeado H6
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=90;
		p2min12=20;
		p2min38=0;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=55;
		p2max38=15;
		p2maxN4=5;
		p2maxN8=0;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;
		
		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto3,'H6',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert3; 
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto4,'H6',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert4; 
	    END IF;
	  
	  ELSIF $4 ='H7' THEN
	  
		--A.G. chancado H7
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=90;
		p1min38=40;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=70;
		p1maxN4=15;
		p1maxN8=5;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;

		--A.G. zarandeado H7
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=100;
		p2min12=90;
		p2min38=40;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=100;
		p2max38=70;
		p2maxN4=15;
		p2maxN8=5;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;
	  
	    IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto5,'H7',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert5;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto6,'H7',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert6;
	    END IF;
		
	  ELSIF $4 ='H8' THEN
	  
		--A.G. chancado H8
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=85;
		p1minN4=10;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=30;
		p1maxN8=10;
		p1maxN16=5;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;

	    --A.G. zarandeado H8
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=100;
		p2min12=100;
		p2min38=85;
		p2minN4=10;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=100;
		p2max38=100;
		p2maxN4=30;
		p2maxN8=10;
		p2maxN16=5;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto7,'H8',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert7;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto8,'H8',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert8;
	    END IF;
	  ELSIF $4 ='H9' THEN
	  
		--A.F. chancado H9
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=100;
		p1minN4=85;
		p1minN8=10;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=100;
		p1maxN8=40;
		p1maxN16=10;
		p1maxN30=6.5;
		p1maxN50=5;
		p1maxN100=0;
		p1maxN200=0;

		--A.F. zarandeado H9
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=100;
		p2min12=100;
		p2min38=100;
		p2minN4=85;
		p2minN8=10;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=100;
		p2max38=100;
		p2maxN4=100;
		p2maxN8=40;
		p2maxN16=10;
		p2maxN30=6.5;
		p2maxN50=5;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto9,'H9',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert9;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto10,'H9',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert10;
		END IF;
		
		IF $7 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto11,'H9',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert11;
		END IF;
		
		IF $8 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto12,'H9',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert12;
		END IF;
		
	  ELSIF $4 ='H56' THEN
	  
		--A.G. chancado H56
		p1min2=100;
		p1min112=100;
		p1min1=90;
		p1min34=40;
		p1min12=10;
		p1min38=0;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;


		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=85;
		p1max12=40;
		p1max38=15;
		p1maxN4=5;
		p1maxN8=0;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;

		--A.G. zarandeado H56
		p2min2=100;
		p2min112=100;
		p2min1=90;
		p2min34=40;
		p2min12=10;
		p2min38=0;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;


		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=85;
		p2max12=40;
		p2max38=15;
		p2maxN4=5;
		p2maxN8=0;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto13,'H56',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert13;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto14,'H56',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert14;
	    END IF;
	 ELSIF $4 ='H57' THEN
	  
	    --A.G. chancado H57
		p1min2=100;
		p1min112=100;
		p1min1=95;
		p1min34=65;
		p1min12=25;
		p1min38=18;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=85;
		p1max12=60;
		p1max38=44;
		p1maxN4=10;
		p1maxN8=5;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;
		
		--A.G. zarandeado H57
		p2min2=100;
		p2min112=100;
		p2min1=95;
		p2min34=65;
		p2min12=25;
		p2min38=18;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=85;
		p2max12=60;
		p2max38=44;
		p2maxN4=10;
		p2maxN8=5;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto15,'H57',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert15;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto16,'H57',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert16;
		END IF;
		
		IF $7 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto17,'H57',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert17;
	    END IF;
	  ELSIF $4 ='H67' THEN
	  
		--A.G. chancado H67
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=90;
		p1min12=47;
		p1min38=20;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=75;
		p1max38=55;
		p1maxN4=10;
		p1maxN8=5;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;
		
		--A.G. zarandeado H67
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=90;
		p2min12=47;
		p2min38=20;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;


		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=75;
		p2max38=55;
		p2maxN4=10;
		p2maxN8=5;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto18,'H67',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert18;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto19,'H67',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert19;
		END IF;
		
		IF $7 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto20,'H67',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert20;
	    END IF;
	  ELSIF $4 ='H89' THEN
	  
	  --A.G. chancado H89
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=90;
		p1minN4=20;
		p1minN8=5;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=55;
		p1maxN8=30;
		p1maxN16=10;
		p1maxN30=5;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;
		
		--A.G. zarandeado H89
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=100;
		p2min12=100;
		p2min38=90;
		p2minN4=20;
		p2minN8=5;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;


		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=100;
		p2max38=100;
		p2maxN4=55;
		p2maxN8=30;
		p2maxN16=10;
		p2maxN30=5;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;
	  
	    IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto21,'H89',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert21;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto22,'H89',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert22;
	    END IF;
	  ELSIF $4 ='H467' THEN
	  
	    --A.G. chancado H467
		p1min2=100;
		p1min112=95;
		p1min1=55;
		p1min34=35;
		p1min12=18;
		p1min38=10;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=85;
		p1max34=70;
		p1max12=46;
		p1max38=30;
		p1maxN4=5;
		p1maxN8=0;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;
		
		--A.G. zarandeado H467
		p2min2=100;
		p2min112=95;
		p2min1=55;
		p2min34=35;
		p2min12=18;
		p2min38=10;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=85;
		p2max34=70;
		p2max12=46;
		p2max38=30;
		p2maxN4=5;
		p2maxN8=0;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto23,'H467',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert23;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto24,'H467',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert24;
	    END IF;
	 ELSIF $4 ='H4' THEN
	  
		--A.G. chancado H4
		p1min2=100;
		p1min112=90;
		p1min1=20;
		p1min34=0;
		p1min12=0;
		p1min38=0;
		p1minN4=0;
		p1minN8=0;
		p1minN16=0;
		p1minN30=0;
		p1minN50=0;
		p1minN100=0;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=55;
		p1max34=15;
		p1max12=9;
		p1max38=5;
		p1maxN4=0;
		p1maxN8=0;
		p1maxN16=0;
		p1maxN30=0;
		p1maxN50=0;
		p1maxN100=0;
		p1maxN200=0;
		
		--A.G. zarandeado H4
		p2min2=100;
		p2min112=90;
		p2min1=20;
		p2min34=0;
		p2min12=0;
		p2min38=0;
		p2minN4=0;
		p2minN8=0;
		p2minN16=0;
		p2minN30=0;
		p2minN50=0;
		p2minN100=0;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=55;
		p2max34=15;
		p2max12=9;
		p2max38=5;
		p2maxN4=0;
		p2maxN8=0;
		p2maxN16=0;
		p2maxN30=0;
		p2maxN50=0;
		p2maxN100=0;
		p2maxN200=0;

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto25,'H4',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert25;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto26,'H4',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert26;
        END IF;
		
		ELSIF $4 ='AF' THEN
		  
		--Agregado fino Chancado
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=100;
		p1minN4=95;
		p1minN8=80;
		p1minN16=50;
		p1minN30=25;
		p1minN50=5;
		p1minN100=0;
		p1minN200=0;


		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=100;
		p1maxN8=100;
		p1maxN16=85;
		p1maxN30=60;
		p1maxN50=30;
		p1maxN100=10;
		p1maxN200=5;
		
		--Agregado fino zarandeado
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=100;
		p2min12=100;
		p2min38=100;
		p2minN4=95;
		p2minN8=80;
		p2minN16=50;
		p2minN30=25;
		p2minN50=5;
		p2minN100=0;
		p2minN200=0;


		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=100;
		p2max38=100;
		p2maxN4=100;
		p2maxN8=100;
		p2maxN16=85;
		p2maxN30=60;
		p2maxN50=30;
		p2maxN100=10;
		p2maxN200=5;


		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto27,'AF',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert27;
		END IF;
		
		IF $6 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto28,'AF',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert28;
		END IF;
		
		ELSIF $4 ='AFM' THEN

		--Agragado fino Chancado M
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=100;
		p1minN4=100;
		p1minN8=95;
		p1minN16=70;
		p1minN30=40;
		p1minN50=20;
		p1minN100=10;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=100;
		p1maxN8=100;
		p1maxN16=100;
		p1maxN30=75;
		p1maxN50=40;
		p1maxN100=25;
		p1maxN200=10;
		
		--Agregado fino zarandeado M
		p2min2=100;
		p2min112=100;
		p2min1=100;
		p2min34=100;
		p2min12=100;
		p2min38=100;
		p2minN4=100;
		p2minN8=95;
		p2minN16=70;
		p2minN30=40;
		p2minN50=10;
		p2minN100=2;
		p2minN200=0;

		p2max2=100;
		p2max112=100;
		p2max1=100;
		p2max34=100;
		p2max12=100;
		p2max38=100;
		p2maxN4=100;
		p2maxN8=100;
		p2maxN16=100;
		p2maxN30=75;
		p2maxN50=35;
		p2maxN100=15;
		p2maxN200=5;


		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto29,'AFM',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
        p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert29;
		END IF;
		
		IF $6 =1 THEN		
		SELECT insertar_huso(idProceso1,idProceso2,idProducto30,'AFM',$2,$3,		
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200,
		p2min2,p2min112,p2min1,p2min34,p2min12,p2min38,p2minN4,p2minN8,p2minN16,p2minN30,p2minN50,p2minN100,p2minN200,
		p2max2,p2max112,p2max1,p2max34,p2max12,p2max38,p2maxN4,p2maxN8,p2maxN16,p2maxN30,p2maxN50,p2maxN100,p2maxN200) INTO insert30;
	   END IF;
	    ELSIF $4 ='AN' THEN

		--AfNat M.Albañ. - AN
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=100;
		p1minN4=100;
		p1minN8=95;
		p1minN16=70;
		p1minN30=40;
		p1minN50=10;
		p1minN100=2;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=100;
		p1maxN8=100;
		p1maxN16=100;
		p1maxN30=75;
		p1maxN50=35;
		p1maxN100=15;
		p1maxN200=5;


		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto31,'AN',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
        p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert31;
		END IF;
		
        ELSIF $4 ='AM' THEN

		--AfMan M.Albañ. - AM
		p1min2=100;
		p1min112=100;
		p1min1=100;
		p1min34=100;
		p1min12=100;
		p1min38=100;
		p1minN4=100;
		p1minN8=95;
		p1minN16=70;
		p1minN30=40;
		p1minN50=20;
		p1minN100=10;
		p1minN200=0;

		p1max2=100;
		p1max112=100;
		p1max1=100;
		p1max34=100;
		p1max12=100;
		p1max38=100;
		p1maxN4=100;
		p1maxN8=100;
		p1maxN16=100;
		p1maxN30=75;
		p1maxN50=40;
		p1maxN100=25;
		p1maxN200=10;
		

		IF $5 =1 THEN
		SELECT insertar_huso(idProceso1,idProceso2,idProducto32,'AM',$2,$3,		
		p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200,
        p1min2,p1min112,p1min1,p1min34,p1min12,p1min38,p1minN4,p1minN8,p1minN16,p1minN30,p1minN50,p1minN100,p1minN200,
		p1max2,p1max112,p1max1,p1max34,p1max12,p1max38,p1maxN4,p1maxN8,p1maxN16,p1maxN30,p1maxN50,p1maxN100,p1maxN200) INTO insert32;


	   END IF;
	  END IF;

	RETURN '1';						  
   
           
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION insertar_huso_x_planta(character, numeric, numeric, character, numeric, numeric, numeric, numeric) OWNER TO postgres;



---------------------------------------------------------------------

-- Function: insertartodohusos()

-- DROP FUNCTION insertartodohusos();

CREATE OR REPLACE FUNCTION insertartodohusos()
  RETURNS character varying AS
$BODY$
DECLARE    

  insert1 numeric:=0;  
  

 BEGIN     

 --1.-'A.G. chancado TMN=1" a 1/2" - H5';
 --2.-'A.G. zarandeado TMN=1" a 1/2" - H5' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H5',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a 3/8" - H6'
 --2.-'A.G. zarandeado TMN=3/4" a 3/8" - H6' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H6',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1/2" a No. 4 - H7'  
 --2.-'A.G. zarandeado TMN=1/2" a No. 4 - H7'
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H7',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 8 - H8'  
 --2.-'A.G. zarandeado TMN=3/8" a No. 8 - H8' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H8',1,1,0,0) INTO insert1;
 --1.-'Agregado fino chancado - H9'
 --2.-'Agregado fino zarandeado - H9' 
 --3.-'A.G. chancado TMN=No. 4 a No. 16 - H9' 
 --4.-'A.G. zarandeado TMN=No. 4 a No. 16 - H9'
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H9',1,0,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a 3/8" - H56' 
 --2.-'A.G. zarandeado TMN=1" a 3/8" - H56' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H56',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1" a No. 4 - H57' 
 --2.-'A.G. zarandeado TMN=1" a No. 4 - H57' 
 --3.-'A.G. zarandeado B TMN=1" a No. 4 - H57' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H57',1,1,1,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a No. 4 - H67'    
 --2.-'A.G. zarandeado TMN=3/4" a No. 4 - H67'
 --3.-'A.G. zarandeado B TMN=3/4" a No. 4 - H67' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H67',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 16 - H89'   
 --2.-'A.G. zarandeado TMN=3/8" a No. 16 - H89' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H89',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1 1/2 a No. 4 - H467'  
 --2.-'A.G. zarandeado TMN=1 1/2 a No. 4 - H467'  
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H467',1,1,0,0) INTO insert1;
 --1.-'A. Grueso chancado TMN=1/2" a 3/4" - H4"' 
 --2.-'A. Grueso zarandeado TMN=1/2" a 3/4" - H4"'
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'H4',1,1,0,0) INTO insert1;
 --1.-'Agragado fino Chancado'   
 --2.-'Agregado fino zarandeado'
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'AF',1,1,0,0) INTO insert1;
 --1.-'Agragado fino Chancado M'  
 --2.-'Agregado fino zarandeado M' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'AFM',1,1,0,0) INTO insert1;
 --1.-'AfNat M.Albañ. - AN' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'AN',1,0,0,0) INTO insert1;
 --1.-'AfMan M.Albañ. - AM' 
SELECT insertar_huso_X_planta('Premezclados Cajamarca',1,1,'AM',1,0,0,0) INTO insert1;


 --1.-'A.G. chancado TMN=1" a 1/2" - H5';
 --2.-'A.G. zarandeado TMN=1" a 1/2" - H5' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H5',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a 3/8" - H6'
 --2.-'A.G. zarandeado TMN=3/4" a 3/8" - H6' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H6',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1/2" a No. 4 - H7'  
 --2.-'A.G. zarandeado TMN=1/2" a No. 4 - H7'
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H7',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 8 - H8'  
 --2.-'A.G. zarandeado TMN=3/8" a No. 8 - H8' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H8',1,1,0,0) INTO insert1;
 --1.-'Agregado fino chancado - H9'
 --2.-'Agregado fino zarandeado - H9' 
 --3.-'A.G. chancado TMN=No. 4 a No. 16 - H9' 
 --4.-'A.G. zarandeado TMN=No. 4 a No. 16 - H9'
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H9',1,0,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a 3/8" - H56' 
 --2.-'A.G. zarandeado TMN=1" a 3/8" - H56' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H56',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1" a No. 4 - H57' 
 --2.-'A.G. zarandeado TMN=1" a No. 4 - H57' 
 --3.-'A.G. zarandeado B TMN=1" a No. 4 - H57' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H57',1,1,10,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a No. 4 - H67'    
 --2.-'A.G. zarandeado TMN=3/4" a No. 4 - H67'
 --3.-'A.G. zarandeado B TMN=3/4" a No. 4 - H67' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H67',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 16 - H89'   
 --2.-'A.G. zarandeado TMN=3/8" a No. 16 - H89' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H89',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1 1/2 a No. 4 - H467'  
 --2.-'A.G. zarandeado TMN=1 1/2 a No. 4 - H467' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H467',1,1,0,0) INTO insert1;
 --1.-'A. Grueso chancado TMN=1/2" a 3/4" - H4"' 
 --2.-'A. Grueso zarandeado TMN=1/2" a 3/4" - H4"'
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'H4',1,1,0,0) INTO insert1;
 --1.-'Agragado fino Chancado'   
 --2.-'Agregado fino zarandeado'
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'AF',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado M'  
 --2.-'Agregado fino zarandeado M' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'AFM',1,1,0,0) INTO insert1; 
 --1.-'AfNat M.Albañ. - AN' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'AN',1,0,0,0) INTO insert1;
 --1.-'AfMan M.Albañ. - AM' 
SELECT insertar_huso_X_planta('Premezclados Chiclayo',1,1,'AM',1,0,0,0) INTO insert1;


 --1.-'A.G. chancado TMN=1" a 1/2" - H5';
 --2.-'A.G. zarandeado TMN=1" a 1/2" - H5' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H5',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a 3/8" - H6'
 --2.-'A.G. zarandeado TMN=3/4" a 3/8" - H6' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H6',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1/2" a No. 4 - H7'  
 --2.-'A.G. zarandeado TMN=1/2" a No. 4 - H7'
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H7',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 8 - H8'  
 --2.-'A.G. zarandeado TMN=3/8" a No. 8 - H8' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H8',1,1,0,0) INTO insert1;
 --1.-'Agregado fino chancado - H9'
 --2.-'Agregado fino zarandeado - H9' 
 --3.-'A.G. chancado TMN=No. 4 a No. 16 - H9' 
 --4.-'A.G. zarandeado TMN=No. 4 a No. 16 - H9'
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H9',1,0,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a 3/8" - H56' 
 --2.-'A.G. zarandeado TMN=1" a 3/8" - H56' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H56',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1" a No. 4 - H57' 
 --2.-'A.G. zarandeado TMN=1" a No. 4 - H57' 
 --3.-'A.G. zarandeado B TMN=1" a No. 4 - H57' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H57',1,1,1,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a No. 4 - H67'    
 --2.-'A.G. zarandeado TMN=3/4" a No. 4 - H67'
 --3.-'A.G. zarandeado B TMN=3/4" a No. 4 - H67' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H67',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 16 - H89'   
 --2.-'A.G. zarandeado TMN=3/8" a No. 16 - H89' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H89',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1 1/2 a No. 4 - H467'  
 --2.-'A.G. zarandeado TMN=1 1/2 a No. 4 - H467' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H467',1,1,0,0) INTO insert1;
 --1.-'A. Grueso chancado TMN=1/2" a 3/4" - H4"' 
 --2.-'A. Grueso zarandeado TMN=1/2" a 3/4" - H4"'
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'H4',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado'   
 --2.-'Agregado fino zarandeado'
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'AF',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado M'  
 --2.-'Agregado fino zarandeado M' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'AFM',1,1,0,0) INTO insert1;
 --1.-'AfNat M.Albañ. - AN' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'AN',1,0,0,0) INTO insert1;
 --1.-'AfMan M.Albañ. - AM' 
SELECT insertar_huso_X_planta('Premezclados Chimbote',1,1,'AM',1,0,0,0) INTO insert1;


 --1.-'A.G. chancado TMN=1" a 1/2" - H5';
 --2.-'A.G. zarandeado TMN=1" a 1/2" - H5' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H5',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a 3/8" - H6'
 --2.-'A.G. zarandeado TMN=3/4" a 3/8" - H6' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H6',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1/2" a No. 4 - H7'  
 --2.-'A.G. zarandeado TMN=1/2" a No. 4 - H7'
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H7',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 8 - H8'  
 --2.-'A.G. zarandeado TMN=3/8" a No. 8 - H8' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H8',1,1,0,0) INTO insert1;
 --1.-'Agregado fino chancado - H9'
 --2.-'Agregado fino zarandeado - H9' 
 --3.-'A.G. chancado TMN=No. 4 a No. 16 - H9' 
 --4.-'A.G. zarandeado TMN=No. 4 a No. 16 - H9'
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H9',1,0,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a 3/8" - H56' 
 --2.-'A.G. zarandeado TMN=1" a 3/8" - H56' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H56',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1" a No. 4 - H57' 
 --2.-'A.G. zarandeado TMN=1" a No. 4 - H57' 
 --3.-'A.G. zarandeado B TMN=1" a No. 4 - H57' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H57',1,1,1,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a No. 4 - H67'    
 --2.-'A.G. zarandeado TMN=3/4" a No. 4 - H67'
 --3.-'A.G. zarandeado B TMN=3/4" a No. 4 - H67' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H67',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 16 - H89'   
 --2.-'A.G. zarandeado TMN=3/8" a No. 16 - H89' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H89',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1 1/2 a No. 4 - H467'  
 --2.-'A.G. zarandeado TMN=1 1/2 a No. 4 - H467' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H467',1,1,0,0) INTO insert1;
 --1.-'A. Grueso chancado TMN=1/2" a 3/4" - H4"' 
 --2.-'A. Grueso zarandeado TMN=1/2" a 3/4" - H4"'
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'H4',1,1,0,0) INTO insert1;
 --1.-'Agragado fino Chancado'   
 --2.-'Agregado fino zarandeado'
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'AF',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado M'  
 --2.-'Agregado fino zarandeado M' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'AFM',1,1,0,0) INTO insert1;
 --1.-'AfNat M.Albañ. - AN' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'AN',1,0,0,0) INTO insert1;
 --1.-'AfMan M.Albañ. - AM' 
SELECT insertar_huso_X_planta('Premezclados Pacasmayo',1,1,'AM',1,0,0,0) INTO insert1;


 --1.-'A.G. chancado TMN=1" a 1/2" - H5';
 --2.-'A.G. zarandeado TMN=1" a 1/2" - H5' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H5',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a 3/8" - H6'
 --2.-'A.G. zarandeado TMN=3/4" a 3/8" - H6' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H6',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1/2" a No. 4 - H7'  
 --2.-'A.G. zarandeado TMN=1/2" a No. 4 - H7'
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H7',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 8 - H8'  
 --2.-'A.G. zarandeado TMN=3/8" a No. 8 - H8' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H8',1,1,0,0) INTO insert1;
 --1.-'Agregado fino chancado - H9'
 --2.-'Agregado fino zarandeado - H9' 
 --3.-'A.G. chancado TMN=No. 4 a No. 16 - H9' 
 --4.-'A.G. zarandeado TMN=No. 4 a No. 16 - H9'
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H9',1,0,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a 3/8" - H56' 
 --2.-'A.G. zarandeado TMN=1" a 3/8" - H56' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H56',1,1,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a No. 4 - H57' 
 --2.-'A.G. zarandeado TMN=1" a No. 4 - H57' 
 --3.-'A.G. zarandeado B TMN=1" a No. 4 - H57' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H57',1,1,1,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a No. 4 - H67'    
 --2.-'A.G. zarandeado TMN=3/4" a No. 4 - H67'
 --3.-'A.G. zarandeado B TMN=3/4" a No. 4 - H67' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H67',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 16 - H89'   
 --2.-'A.G. zarandeado TMN=3/8" a No. 16 - H89' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H89',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1 1/2 a No. 4 - H467'  
 --2.-'A.G. zarandeado TMN=1 1/2 a No. 4 - H467' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H467',1,1,0,0) INTO insert1;
 --1.-'A. Grueso chancado TMN=1/2" a 3/4" - H4"' 
 --2.-'A. Grueso zarandeado TMN=1/2" a 3/4" - H4"'
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'H4',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado'   
 --2.-'Agregado fino zarandeado'
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'AF',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado M'  
 --2.-'Agregado fino zarandeado M' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'AFM',1,1,0,0) INTO insert1; 
 --1.-'AfNat M.Albañ. - AN' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'AN',1,0,0,0) INTO insert1;
 --1.-'AfMan M.Albañ. - AM' 
SELECT insertar_huso_X_planta('Premezclados Piura',1,1,'AM',1,0,0,0) INTO insert1;


 --1.-'A.G. chancado TMN=1" a 1/2" - H5';
 --2.-'A.G. zarandeado TMN=1" a 1/2" - H5' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H5',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a 3/8" - H6'
 --2.-'A.G. zarandeado TMN=3/4" a 3/8" - H6' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H6',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1/2" a No. 4 - H7'  
 --2.-'A.G. zarandeado TMN=1/2" a No. 4 - H7'
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H7',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 8 - H8'  
 --2.-'A.G. zarandeado TMN=3/8" a No. 8 - H8' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H8',1,1,0,0) INTO insert1;
 --1.-'Agregado fino chancado - H9'
 --2.-'Agregado fino zarandeado - H9' 
 --3.-'A.G. chancado TMN=No. 4 a No. 16 - H9' 
 --4.-'A.G. zarandeado TMN=No. 4 a No. 16 - H9'
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H9',1,0,1,1) INTO insert1;
 --1.-'A.G. chancado TMN=1" a 3/8" - H56' 
 --2.-'A.G. zarandeado TMN=1" a 3/8" - H56' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H56',1,1,0,0) INTO insert1; 
 --1.-'A.G. chancado TMN=1" a No. 4 - H57' 
 --2.-'A.G. zarandeado TMN=1" a No. 4 - H57' 
 --3.-'A.G. zarandeado B TMN=1" a No. 4 - H57' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H57',1,1,1,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/4" a No. 4 - H67'    
 --2.-'A.G. zarandeado TMN=3/4" a No. 4 - H67'
 --3.-'A.G. zarandeado B TMN=3/4" a No. 4 - H67' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H67',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=3/8" a No. 16 - H89'   
 --2.-'A.G. zarandeado TMN=3/8" a No. 16 - H89' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H89',1,1,0,0) INTO insert1;
 --1.-'A.G. chancado TMN=1 1/2 a No. 4 - H467'  
 --2.-'A.G. zarandeado TMN=1 1/2 a No. 4 - H467' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H467',1,1,0,0) INTO insert1;
 --1.-'A. Grueso chancado TMN=1/2" a 3/4" - H4"' 
 --2.-'A. Grueso zarandeado TMN=1/2" a 3/4" - H4"'
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'H4',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado'   
 --2.-'Agregado fino zarandeado'
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'AF',1,1,0,0) INTO insert1; 
 --1.-'Agragado fino Chancado M'  
 --2.-'Agregado fino zarandeado M' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'AFM',1,1,0,0) INTO insert1; 				  
 --1.-'AfNat M.Albañ. - AN' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'AN',1,0,0,0) INTO insert1;
 --1.-'AfMan M.Albañ. - AM' 
SELECT insertar_huso_X_planta('Premezclados Trujillo',1,1,'AM',1,0,0,0) INTO insert1;

  RETURN '1';     
          
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION insertartodohusos() OWNER TO postgres;






--------------------------------------------------------------------


Select insertartodohusos();









-------------------------------------------------------------------------------------------------------------------------------------------------

--INSERTAR MAXIMOS Y MÍNIMOS DE TAMICES EXISTENTES
--------------------------------------------------

-- Function: insertar_max_min(numeric, numeric, numeric, numeric, character)

-- DROP FUNCTION insertar_max_min(numeric, numeric, numeric, numeric, character);

--CREATE OR REPLACE FUNCTION insertar_max_min(numeric, numeric, numeric, numeric, character)
 -- RETURNS character varying AS
--$BODY$
--DECLARE        

      -- idTipoEnsa numeric:=0;
-- BEGIN     



--	SELECT "SCMTE_IDE_TIPO_ENSA_K" FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" TE  
--	  LEFT JOIN "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" GE   ON TE."SCMGT_IDE_GRUP_TIPO_ENSA_K"=GE."SCMGT_IDE_GRUP_TIPO_ENSA_K"
--	  LEFT JOIN "CPSAA"."GESAC_MAE_MATR_TRAT" MT ON MT."SCMMT_IDE_MATR_TRAT_K"=GE."SCMMT_IDE_MATR_TRAT_K"  
--	  WHERE "SCMPR_IDE_PROD_K"=$1 AND "SCMPC_IDE_PROC_K"=$2
--	  AND "SCMTE_NOM_TIPO_ENSA" = $5 INTO idTipoEnsa;



--	UPDATE "CPSAA"."GESAC_MOV_CONT" 
--	SET "SCMOC_VLR_CONT_SUP_PRO"=$3,
--	    "SCMOC_VLR_CONT_INF_PRO"=$4
--	WHERE "SCMTE_IDE_TIPO_ENSA_K"=idTipoEnsa;

							  

 -- RETURN 'GAME OVER';     
           
-- END;
 --$BODY$
 -- LANGUAGE plpgsql VOLATILE
 -- COST 100;
--ALTER FUNCTION insertar_max_min(numeric, numeric, numeric, numeric, character) OWNER TO postgres;

-------------------------------------------------------------------------------------------------------------------------------------------

-----FUNCTION insertar_max_min(id_prod, id_proce, maximo, minimo, nombre_tipo_ensayo);
--select insertar_max_min(561, 50, 100, 100, '2"');
--select insertar_max_min(561, 50, 100, 100, '1 1/2"');
--select insertar_max_min(561, 50, 100, 100, '1"');
--select insertar_max_min(561, 50, 100, 100, '3/4"');
--select insertar_max_min(561, 50, 100, 100, '1/2"');
--select insertar_max_min(561, 50, 100, 100, '3/8"');
--select insertar_max_min(561, 50, 100, 95, 'N°4');
--select insertar_max_min(561, 50, 100, 80, 'N°8');
--select insertar_max_min(561, 50, 85, 50, 'N°16');
--select insertar_max_min(561, 50, 60, 25, 'N°30');
--select insertar_max_min(561, 50, 30, 5, 'N°50');
--select insertar_max_min(561, 50, 10, 0, 'N°100');
--select insertar_max_min(561, 50, 5, 0, 'N°200');
--select insertar_max_min(561, 50, 0, 0, 'Fondo');
