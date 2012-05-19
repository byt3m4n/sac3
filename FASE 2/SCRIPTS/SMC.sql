
-- Function: registro_sac_sap(numeric, numeric, numeric)

-- DROP FUNCTION registro_sac_sap(numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION registro_sac_sap(numeric, numeric, numeric)
  RETURNS character varying AS
$BODY$
DECLARE
       resultado  varchar:='0-0';
       estadoPrueba28  varchar:='0';
       esResistencia28Dias Integer := 0;
       otrasPruebasEstadoNOC Integer := 0;
       otrasPruebasEstadoCON Integer := 0;
       otrasPruebas          numeric := 0;
       idMuestra             numeric:=0;
       idLote numeric(10,0);

 BEGIN

    SELECT "SCMOM_IDE_MUES_K" FROM "CPSAA"."GESAC_MOV_MUES" WHERE "SCMOL_IDE_LOTE_K"=$3  INTO idMuestra;

    SELECT existeResistenciaCompresion28Dias(idMuestra) INTO esResistencia28Dias;

    SELECT COUNT(*) FROM "CPSAA"."GESAC_MOV_ENSA"
          WHERE "SCMOM_IDE_MUES_K" = idMuestra
          AND   "SCMOE_COC_EST_TRA" = 'NOC' INTO otrasPruebasEstadoNOC;
    SELECT COUNT(*) FROM  "CPSAA"."GESAC_MOV_ENSA"
          WHERE "SCMOM_IDE_MUES_K" = idMuestra
          AND   "SCMOE_COC_EST_TRA" = 'CON' INTO otrasPruebasEstadoCON;
   IF(esResistencia28Dias=1) THEN
     SELECT INTO estadoPrueba28 'NCO';
    ELSIF(esResistencia28Dias=2) THEN
     SELECT INTO estadoPrueba28  'CON';
    END IF;

    IF(otrasPruebasEstadoNOC>0) THEN
      SELECT INTO resultado estadoPrueba28 || '-NCO';
    ELSIF(otrasPruebasEstadoCON>0)  THEN
      SELECT estadoPrueba28 || '-CON' INTO resultado;
    ELSE
      SELECT estadoPrueba28 || '-0' INTO resultado;
    END IF;


  RETURN  resultado;


 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION registro_sac_sap(numeric, numeric, numeric) OWNER TO postgres;




*********************************************************************

-- Function: nombretipoensayoesresistenciacompresion28dias(character varying)

-- DROP FUNCTION nombretipoensayoesresistenciacompresion28dias(character varying);

CREATE OR REPLACE FUNCTION nombretipoensayoesresistenciacompresion28dias(character varying)
  RETURNS integer AS
$BODY$

/**********************************************
FECHA		: 21-03-2012
DESCRIPCION	: VALIDA SI EL NOMBRE TIPO ENSAYO QUE SE PASA COMO PARAMETRO CONTIENE LAS PALABRAS: RESISTENCIA, COMPRESIÓN o COMPRESION Y 28
DEVUELVE	: 1 = SI CUMPLE 
		  2 = NO CUMPLE		  
AUTOR		: David Vivar Quinteros - CSTI
**********************************************/

DECLARE
	resultado integer := 0;
	posicion integer := 0;
	nombreTipoEnsayo character varying(100);
    BEGIN
	nombreTipoEnsayo := $1;
	
	select position('RESISTENCIA' in upper(nombreTipoEnsayo)) into posicion;	
	IF(posicion > 0) THEN		
		select position('COMPRESIÓN' in upper(nombreTipoEnsayo)) into posicion;
		IF(posicion > 0) THEN 
			select position('28' in upper(nombreTipoEnsayo)) into posicion;
			IF(posicion > 0) THEN
				resultado := 1;
			ELSE
				resultado := 0;
			END IF;
		ELSE
			select position('COMPRESION' in upper(nombreTipoEnsayo)) into posicion;	
			IF(posicion > 0) THEN 
				select position('28' in upper(nombreTipoEnsayo)) into posicion;
				IF(posicion > 0) THEN
					resultado := 1;
				ELSE
					resultado := 0;
				END IF;
			ELSE
				resultado := 0;
			END IF;	
		END IF;
		
	ELSE
		resultado := 0;
	END IF;
	
	return resultado;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION nombretipoensayoesresistenciacompresion28dias(character varying) OWNER TO postgres;


**********************************************************************

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




*************************************************

-- Function: existeresistenciacompresion28dias(numeric)

-- DROP FUNCTION existeresistenciacompresion28dias(numeric);

CREATE OR REPLACE FUNCTION existeresistenciacompresion28dias(numeric)
  RETURNS integer AS
$BODY$	
/**********************************************
FECHA		: 23-03-2012
DESCRIPCION	: BUSCA EN TODOS LOS ENSAYOS QUE PERTENECEN A UNA MUESTRA SI EXISTE ENTRE ELLOS UN ENSAYO QUE TENGA
		  COMO NOMBRE TIPO ENSAYO = RESISTENCIA COMPRESION 28 DIAS Y VALIDA SU ESTADO
DEVUELVE	: 1 = SI EXISTE UN ENSAYO CON NOMBRE TIPO DE ENSAYO RESISTENCIA COMPRESION 28 DIAS Y SU ESTADO ES = 'NOC'
		  2 = SI EXISTE UN ENSAYO CON NOMBRE TIPO DE ENSAYO RESISTENCIA COMPRESION 28 DIAS Y SU ESTADO ES != 'NOC'
		  0 = SI NO EXISTE ENSAYO CON NOMBRE TIPO DE ENSAYO RESISTENCIA COMPRESION 28 DIAS
AUTOR		: David Vivar Quinteros - CSTI
**********************************************/

	DECLARE 
	resultado integer := 0;
	estadoEnsayo character varying(3);
	esResistencia28Dias integer := 0;
	nombreTipoEnsayo character varying(100); 
	
	micursor CURSOR FOR SELECT 
					MAE."SCMTE_NOM_TIPO_ENSA", MOV."SCMOE_COC_EST_TRA"
					--, MAE."SCMTE_NOM_TIPO_ENSA", MOV."SCMOE_COC_EST_TRA"
				FROM
					"CPSAA"."GESAC_MOV_ENSA" MOV INNER JOIN
					"CPSAA"."GESAC_MAE_TIPO_ENSA" MAE ON
					MOV."SCMTE_IDE_TIPO_ENSA_K" = MAE."SCMTE_IDE_TIPO_ENSA_K"
				WHERE
					MOV."SCMOM_IDE_MUES_K" = $1;

	
				
	BEGIN
		OPEN micursor;
		LOOP			
			FETCH NEXT IN micursor INTO nombreTipoEnsayo, estadoEnsayo;
			EXIT WHEN NOT FOUND;

			--FUNCION QUE VALIDA SI EL NOMBRETIPOENSAYO ES RESISTENCIA COMPRESION 28 DIAS (1= ES RESISTENCIA COMPRESION 28 DIAS, 0 = NO ES)
			select nombreTipoEnsayoEsResistenciaCompresion28Dias(nombreTipoEnsayo) INTO esResistencia28Dias;
			
			IF(esResistencia28Dias = 1) THEN
				IF(estadoEnsayo = 'NOC') THEN
					resultado := 1;
				ELSIF(estadoEnsayo = 'CON') THEN
					resultado := 2;
				END IF;
				
				EXIT;
			END IF;			
		END LOOP;
		CLOSE micursor;
		return resultado;
	END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION existeresistenciacompresion28dias(numeric) OWNER TO postgres;



***************************************************************


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
 
  
 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '004-00058' WHERE "SCMPR_NOM_PROD" = 'Pared 12 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '004-00059' WHERE "SCMPR_NOM_PROD" = 'Pared 14 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '004-00070' WHERE "SCMPR_NOM_PROD" = 'Adoquín 6 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '004-00077' WHERE "SCMPR_NOM_PROD" = 'Adoquín 8 TMS';

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '004-00147' WHERE "SCMPR_NOM_PROD" = 'Pared 9 TMS'; 

 UPDATE "CPSAA"."GESAC_MAE_PROD" SET "SCMPR_COD_MATERIAL_SAP" = '004-00213' WHERE "SCMPR_NOM_PROD" = 'Adoquín 4 TMS';



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
    
ALTER TABLE "CPSAA"."GESAC_MOV_UNID_MUES" ALTER COLUMN "SCMUM_VLR_PES_INI"
numeric(10,4);



---------------------

ALTER TABLE "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" ALTER COLUMN "SCMGT_COC_HUS" TYPE character varying(4);
---


CREATE OR REPLACE FUNCTION insertar_huso(numeric, numeric,numeric,character)
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


   SELECT count(*) FROM  "CPSAA"."GESAC_MAE_MATR_TRAT"
                         WHERE "SCMPC_IDE_PROC_K"=$1
                         AND  "SCMPR_IDE_PROD_K"=$3  INTO countMatr_Trat;
  

   IF countMatr_Trat = 0  THEN
        SELECT MAX("SCMMT_IDE_MATR_TRAT_K")+1 FROM "CPSAA"."GESAC_MAE_MATR_TRAT" INTO idMatr;      
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
                                                          
     SELECT MAX("SCMGT_IDE_GRUP_TIPO_ENSA_K")+1 FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" INTO idGrupTip;  
     INSERT INTO "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" ("SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMMT_IDE_MATR_TRAT_K","SCMGT_NOM_GRUP_TIPO_ENSA",
				  	            "SCMGT_COC_CAT_TIPO_ENSA","SCMGT_COC_HUS","SCMGT_COC_EST","SCMGT_COC_TIPO_GRUP_TIPO_ENSA","SCMGT_FLG_HUS_GRA")  VALUES
					            (idGrupTip,idMatr,'Análisis Granulométrico','FIS',$4,'ACT','GRA','S');
    ELSE 
     SELECT "SCMMT_IDE_MATR_TRAT_K" FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO idGrupTip;

    END IF;



	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES 
	(idTipoEnsa,idGrupTip,51,'2"','50.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');
	
	
	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,52,'1 1/2"','37.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');											 
											 
											 
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,53,'1"','25.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');
	
	
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,54,'3/4"','19.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,55,'1/2"','12.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,56,'3/8"','9.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');


	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
        SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,57,'N°4','4.750','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');


	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,58,'N°8','2.360','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,59,'N°16','1.180','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,60,'N°30','0.600','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,61,'N°50','0.300','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,62,'N°100','0.150','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,63,'N°200','0.075','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,64,'Fondo','FONDO','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

	INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
                                              "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
                                             ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
                                             idTipoEnsa,'N','N','S','N','CON');

                                             
	SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
	INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
	"SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
	"SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
	"SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
	(idTipoEnsa,idGrupTip,65,'MF','','S',1,'N','N','','Asistente de Control de Calidad','S','N','N','N','S','S','S','N',2,'ACT','N','N','N');




   SELECT count(*) FROM  "CPSAA"."GESAC_MAE_MATR_TRAT"
                         WHERE "SCMPC_IDE_PROC_K"=$2
                         AND  "SCMPR_IDE_PROD_K"=$3  INTO countMatr_Trat;
  

   IF countMatr_Trat = 0  THEN
          SELECT MAX("SCMMT_IDE_MATR_TRAT_K")+1 FROM "CPSAA"."GESAC_MAE_MATR_TRAT" INTO idMatr;                                                          
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

					  
					  

   
    SELECT count(*) FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO countGrupTip;

    IF countGrupTip =0 THEN
                                                          
     SELECT MAX("SCMGT_IDE_GRUP_TIPO_ENSA_K")+1 FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" INTO idGrupTip;  
     INSERT INTO "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" ("SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMMT_IDE_MATR_TRAT_K","SCMGT_NOM_GRUP_TIPO_ENSA",
				  	            "SCMGT_COC_CAT_TIPO_ENSA","SCMGT_COC_HUS","SCMGT_COC_EST","SCMGT_COC_TIPO_GRUP_TIPO_ENSA","SCMGT_FLG_HUS_GRA")  VALUES
					            (idGrupTip,idMatr,'Análisis Granulométrico','FIS',$4,'ACT','GRA','S');
								
								
    ELSE 
     SELECT "SCMMT_IDE_MATR_TRAT_K" FROM  "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" WHERE "SCMMT_IDE_MATR_TRAT_K"=idMatr INTO idGrupTip;

    END IF;

                                                                                                           

					  

  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES 
 (idTipoEnsa,idGrupTip,51,'2"','50.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
 (idTipoEnsa,idGrupTip,52,'1 1/2"','37.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
 (idTipoEnsa,idGrupTip,53,'1"','25.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,54,'3/4"','19.000','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,55,'1/2"','12.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,56,'3/8"','9.500','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
   SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,57,'N°4','4.750','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,58,'N°8','2.360','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,59,'N°16','1.180','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,60,'N°30','0.600','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,61,'N°50','0.300','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,62,'N°100','0.150','S',1,'N','N','POR','Asistente de Control de Calidad','N','S','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,63,'N°200','0.075','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');

                                             
  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,64,'Fondo','FONDO','S',1,'N','N','POR','Asistente de Control de Calidad','N','N','N','N','S','S','S','N',1,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');


  SELECT MAX("SCMTE_IDE_TIPO_ENSA_K")+1 FROM "CPSAA"."GESAC_MAE_TIPO_ENSA" INTO idTipoEnsa;
  INSERT INTO "CPSAA"."GESAC_MAE_TIPO_ENSA" ("SCMTE_IDE_TIPO_ENSA_K","SCMGT_IDE_GRUP_TIPO_ENSA_K","SCMTE_NRO_ORD","SCMTE_NOM_TIPO_ENSA",
  "SCMTE_GLS_DES","SCMTE_FLG_UNI_MUE","SCMTE_NRO_UNI_MUE","SCMTE_FLG_NRO_AMB_ACU","SCMTE_FLG_VAL_ACE","SCMTE_COC_UNI_MED","SCMTE_GLS_RES",
  "SCMTE_FLG_MOD_FIN","SCMTE_FLG_FOR_MOD_FIN","SCMTE_FLG_LTE_NO_CON","SCMTE_FLG_LTE_CON","SCMTE_FLG_ESC_PROC","SCMTE_FLG_ESC_PLAN",
  "SCMTE_FLG_ESC_EMPR","SCMTE_FLG_CERT_CAL","SCMTE_NRO_POS_DECI","SCMTE_COC_EST","SMCTE_FLG_PRO_CAL","SCMTE_FLG_REP_PMZ","SCMTE_FLG_REP_PRO_PON") VALUES
  (idTipoEnsa,idGrupTip,65,'MF','','S',1,'N','N','','Asistente de Control de Calidad','S','N','N','N','S','S','S','N',2,'ACT','N','N','N');

  INSERT INTO  "CPSAA"."GESAC_MOV_CONT" ("SCMOC_IDE_CONT_K","SCMTE_IDE_TIPO_ENSA_K","SCMOC_FLG_CONT_INF_UM","SCMOC_FLG_CONT_SUP_UM",
				      "SCMOC_FLG_CONT_INF_PRO","SCMOC_FLG_CONT_SUP_PRO","SCMOC_COC_TIPO_CONT") VALUES
				     ((SELECT MAX("SCMOC_IDE_CONT_K")+1 FROM "CPSAA"."GESAC_MOV_CONT"),
				     idTipoEnsa,'N','N','S','N','CON');
                                            
    
							  

  RETURN 'INSERTO CON EXITO ;-)';     
           
 END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION insertar_huso(numeric, numeric, numeric, character) OWNER TO postgres;

INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT coalesce(max(PROD."SCMPR_IDE_PROD_K"),0) + 1  from  "CPSAA"."GESAC_MAE_PROD" PROD),'A.G. chancado TMN=1/2" a 3/4" - H4','AGC1.H4','A. Grueso chancado TMN=1/2" a 3/4" - H4"','AGR','ACT');

--SELECT insertar_huso(50,58,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(32,57,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(51,59,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(53,61,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(49,56,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(52,60,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');

INSERT INTO "CPSAA"."GESAC_MAE_PROD" ("SCMPR_IDE_PROD_K","SCMPR_NOM_PROD","SCMPR_GLS_SIG","SCMPR_GLS_DES","SCMPR_COC_TIP_PROD","SCMPR_COC_EST") 
                              VALUES ((SELECT coalesce(max(PROD."SCMPR_IDE_PROD_K"),0) + 1  from  "CPSAA"."GESAC_MAE_PROD" PROD),'A.G. zarandeado TMN=1/2" a 3/4" - H4','AGZ1.H4','A. Grueso zarandeado TMN=1/2" a 3/4" - H4"','AGR','ACT');

--SELECT insertar_huso(50,58,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(32,57,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(51,59,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(53,61,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(49,56,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');
SELECT insertar_huso(52,60,(SELECT MAX("SCMPR_IDE_PROD_K") FROM "CPSAA"."GESAC_MAE_PROD"),'H4');




--CAJAMAR->RE(50),ZA(58)

SELECT insertar_huso(50,58,363,'H5');
SELECT insertar_huso(50,58,373,'H5');
SELECT insertar_huso(50,58,366,'H6');
SELECT insertar_huso(50,58,368,'H7');
SELECT insertar_huso(50,58,380,'H7');
SELECT insertar_huso(50,58,381,'H8');
SELECT insertar_huso(50,58,369,'H8');
SELECT insertar_huso(50,58,361,'H9');
SELECT insertar_huso(50,58,371,'H9');
SELECT insertar_huso(50,58,383,'H9');
SELECT insertar_huso(50,58,364,'H56');
SELECT insertar_huso(50,58,374,'H56');
SELECT insertar_huso(50,58,364,'H57');
SELECT insertar_huso(50,58,374,'H57');
SELECT insertar_huso(50,58,367,'H67');
SELECT insertar_huso(50,58,378,'H67');
SELECT insertar_huso(50,58,379,'H67');
SELECT insertar_huso(50,58,370,'H89');
SELECT insertar_huso(50,58,382,'H89');
SELECT insertar_huso(50,58,362,'H467');
SELECT insertar_huso(50,58,372,'H467');

--CHICLA-->RE(32),ZA(57)

SELECT insertar_huso(32,57,363,'H5');
SELECT insertar_huso(32,57,373,'H5');
SELECT insertar_huso(32,57,366,'H6');
SELECT insertar_huso(32,57,368,'H7');
SELECT insertar_huso(32,57,380,'H7');
SELECT insertar_huso(32,57,381,'H8');
SELECT insertar_huso(32,57,369,'H8');
SELECT insertar_huso(32,57,361,'H9');
SELECT insertar_huso(32,57,371,'H9');
SELECT insertar_huso(32,57,383,'H9');
SELECT insertar_huso(32,57,364,'H56');
SELECT insertar_huso(32,57,374,'H56');
SELECT insertar_huso(32,57,364,'H57');
SELECT insertar_huso(32,57,374,'H57');
SELECT insertar_huso(32,57,367,'H67');
SELECT insertar_huso(32,57,378,'H67');
SELECT insertar_huso(32,57,379,'H67');
SELECT insertar_huso(32,57,370,'H89');
SELECT insertar_huso(32,57,382,'H89');
SELECT insertar_huso(32,57,362,'H467');
SELECT insertar_huso(32,57,372,'H467');

--CHIMBO-->RE(53),ZA(61)


SELECT insertar_huso(53,61,363,'H5');
SELECT insertar_huso(53,61,373,'H5');
SELECT insertar_huso(53,61,366,'H6');
SELECT insertar_huso(53,61,368,'H7');
SELECT insertar_huso(53,61,380,'H7');
SELECT insertar_huso(53,61,381,'H8');
SELECT insertar_huso(53,61,369,'H8');
SELECT insertar_huso(53,61,361,'H9');
SELECT insertar_huso(53,61,371,'H9');
SELECT insertar_huso(53,61,383,'H9');
SELECT insertar_huso(53,61,364,'H56');
SELECT insertar_huso(53,61,374,'H56');
SELECT insertar_huso(53,61,364,'H57');
SELECT insertar_huso(53,61,374,'H57');
SELECT insertar_huso(53,61,367,'H67');
SELECT insertar_huso(53,61,378,'H67');
SELECT insertar_huso(53,61,379,'H67');
SELECT insertar_huso(53,61,370,'H89');
SELECT insertar_huso(53,61,382,'H89');
SELECT insertar_huso(53,61,362,'H467');
SELECT insertar_huso(53,61,372,'H467');

--PACASMA-->RE(51),ZA(59)


SELECT insertar_huso(51,59,363,'H5');
SELECT insertar_huso(51,59,373,'H5');
SELECT insertar_huso(51,59,366,'H6');
SELECT insertar_huso(51,59,368,'H7');
SELECT insertar_huso(51,59,380,'H7');
SELECT insertar_huso(51,59,381,'H8');
SELECT insertar_huso(51,59,369,'H8');
SELECT insertar_huso(51,59,361,'H9');
SELECT insertar_huso(51,59,371,'H9');
SELECT insertar_huso(51,59,383,'H9');
SELECT insertar_huso(51,59,364,'H56');
SELECT insertar_huso(51,59,374,'H56');
SELECT insertar_huso(51,59,364,'H57');
SELECT insertar_huso(51,59,374,'H57');
SELECT insertar_huso(51,59,367,'H67');
SELECT insertar_huso(51,59,378,'H67');
SELECT insertar_huso(51,59,379,'H67');
SELECT insertar_huso(51,59,370,'H89');
SELECT insertar_huso(51,59,382,'H89');
SELECT insertar_huso(51,59,362,'H467');
SELECT insertar_huso(51,59,372,'H467');

--PIURA-->RE(49),ZA(56)


SELECT insertar_huso(49,56,363,'H5');
SELECT insertar_huso(49,56,373,'H5');
SELECT insertar_huso(49,56,366,'H6');
SELECT insertar_huso(49,56,368,'H7');
SELECT insertar_huso(49,56,380,'H7');
SELECT insertar_huso(49,56,381,'H8');
SELECT insertar_huso(49,56,369,'H8');
SELECT insertar_huso(49,56,361,'H9');
SELECT insertar_huso(49,56,371,'H9');
SELECT insertar_huso(49,56,383,'H9');
SELECT insertar_huso(49,56,364,'H56');
SELECT insertar_huso(49,56,374,'H56');
SELECT insertar_huso(49,56,364,'H57');
SELECT insertar_huso(49,56,374,'H57');
SELECT insertar_huso(49,56,367,'H67');
SELECT insertar_huso(49,56,378,'H67');
SELECT insertar_huso(49,56,379,'H67');
SELECT insertar_huso(49,56,370,'H89');
SELECT insertar_huso(49,56,382,'H89');
SELECT insertar_huso(49,56,362,'H467');
SELECT insertar_huso(49,56,372,'H467');

--TRUJI-->RE(52),ZA(60)


SELECT insertar_huso(52,60,363,'H5');
SELECT insertar_huso(52,60,373,'H5');
SELECT insertar_huso(52,60,366,'H6');
SELECT insertar_huso(52,60,368,'H7');
SELECT insertar_huso(52,60,380,'H7');
SELECT insertar_huso(52,60,381,'H8');
SELECT insertar_huso(52,60,369,'H8');
SELECT insertar_huso(52,60,361,'H9');
SELECT insertar_huso(52,60,371,'H9');
SELECT insertar_huso(52,60,383,'H9');
SELECT insertar_huso(52,60,364,'H56');
SELECT insertar_huso(52,60,374,'H56');
SELECT insertar_huso(52,60,364,'H57');
SELECT insertar_huso(52,60,374,'H57');
SELECT insertar_huso(52,60,367,'H67');
SELECT insertar_huso(52,60,378,'H67');
SELECT insertar_huso(52,60,379,'H67');
SELECT insertar_huso(52,60,370,'H89');
SELECT insertar_huso(52,60,382,'H89');
SELECT insertar_huso(52,60,362,'H467');
SELECT insertar_huso(52,60,372,'H467');
