lotes y ensayos
--AGREGO LAS 2 COLUMNAS PARA GUARDAR LOS IDS MAXIMOS POR A�O TANTO DE LOTE COMO DE 

ENSAYO
alter table "CPSAA"."GESAC_MOV_HIS_ID" add "SCMID_IDE_LOTE" numeric(10,0);
alter table "CPSAA"."GESAC_MOV_HIS_ID" add "SCMID_IDE_ENSA" numeric(10,0);

--ACTUALIZO LA TABLA "CPSAA"."GESAC_MOV_HIS_ID"
UPDATE "CPSAA"."GESAC_MOV_HIS_ID"
SET
	"SCMID_IDE_LOTE" = (SELECT currval('"CPSAA"."GESAC_SEQ_ID_LOT"') from "CPSAA"."GESAC_SEQ_ID_LOT")
				FROM
					"CPSAA"."GESAC_MOV_LOTE"
				WHERE
					to_timestamp(to_char("SCMOL_FCH_HOR_REG",'yyyy/mm/dd HH24:MI'), 'yyyy/mm/dd HH24:MI') <= '2012-01-01 07:00:00'),
	"SCMID_IDE_ENSA" = (SELECT currval('"CPSAA"."GESAC_SEQ_ID_ENS"') from "CPSAA"."GESAC_SEQ_ID_ENS")
				FROM
					"CPSAA"."GESAC_MOV_ENSA"
				WHERE
					to_timestamp(to_char("SCMOE_FCH_HRA_REG",'yyyy/mm/dd HH24:MI'), 'yyyy/mm/dd HH24:MI') <= '2012-01-01 07:00:00')
WHERE "SCMID_VLR_ANIO_K" = 2011;

--AGREGO LA COLUMNA DE FECHA DE REGISTRO A LA MATRIZ DE TRATAMIENTO
alter table "CPSAA"."GESAC_MAE_MATR_TRAT" add "SCMMT_FCH_HOR_REG" timestamp without time zone;

--AGREGO LA COLUMNA DE FECHA DE REGISTRO AL MAESTRO TIPO GRUPO DE ENSAYO
alter table "CPSAA"."GESAC_MAE_GRUP_TIPO_ENSA" add "SCMMT_FCH_HOR_REG" timestamp without time zone;


--SE CREA EL PERMISO PARA LA OPCION DE LOTE PNC
INSERT INTO "CPSAA"."GESAC_MAE_PERM"(
            "SCMAP_IDE_PERM_K", "SCMAP_COC_PERM", "SCMAP_NOM_PERM", "SCMAP_GLS_DES", 
            "SCMAP_GLS_MOD_FUN", "SCMAP_GLS_CAS_USO", "SCMAP_COC_EST")
    VALUES ((SELECT coalesce(max(PER."SCMAP_IDE_PERM_K"),0) + 1 FROM "CPSAA"."GESAC_MAE_PERM" PER), 'CAL010_PER_001', 'LOTE PNC - Inicio', 'Permite ingresar a la pantalla principal lote','CAL', 'CAL010', 'ACT');



--AMARRO EL PERMISO CON EL ROL
INSERT INTO "CPSAA"."GESAC_DET_PERM_ROL"(
            "SCDPR_IDE_PERM_ROL_K", "SCMAP_IDE_PERM_K", "SCMAR_IDE_ROL_K", 
            "SCDPR_FLG_ELI", "SCDPR_COC_EST")
    VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_DET_PERM_ROL"') from "CPSAA"."GESAC_SEQ_ID_DET_PERM_ROL"), (SELECT MAX("SCMAP_IDE_PERM_K") FROM "CPSAA"."GESAC_MAE_PERM"), 11,'N', 'ACT');


--CREO EL PARAMETRO A�O, QUE SIRVE PARA GUIARME SI ES QUE SE DA FORMATO AL ID DEL LOTE Y ID DEL ENSAYO
INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR")
    VALUES ( (SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR),'PARAMETRO_ANIO_REINICIO_ID_LOTE_Y_ENSAYO', 'Anio para reinicio de id de Lote y Ensayo', '2012');

	
CREATE TABLE "CPSAA"."GESAC_MOV_LOTE_PNC"
(
  "SCMOL_IDE_NUM_PNC_K" numeric(10,0) NOT NULL,
  "SCMOL_GLS_DES_NO_CONF" character varying(500),
  "SCMTR_IDE_TRAT_K" numeric(10,0),
  "SCMOL_GLS_AUT_POR" character varying(500),
  "SCMOL_FCH_HOR_REG" timestamp without time zone NOT NULL,
  "SCMOL_IDE_LOTE_K" numeric(10,0) NOT NULL,
  "SCMOL_GLS_CARGO" character varying(500),
  "SCMPC_IDE_PROC_K" numeric(10,0),
  "SCMOL_FCH_REG_TRAT" timestamp without time zone,
  "SCMAP_IDE_PLAN_K" numeric(10,0) NOT NULL,
  "SCMOL_NOM_TRAT" character varying(100),
  "SCMOL_NUM_SAC" character varying(10),
  CONSTRAINT "GESAC_MOV_LOTE_PNC_pkey" PRIMARY KEY ("SCMOL_IDE_NUM_PNC_K"),
  CONSTRAINT "FK_GESAC_MAE_PLAN_GESAC_MOV_LOTE_PNC" FOREIGN KEY ("SCMAP_IDE_PLAN_K")
      REFERENCES "CPSAA"."GESAC_MAE_PLAN" ("SCMAP_IDE_PLAN_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE "CPSAA"."GESAC_MOV_ACC_EJEC"
(
  "SCMOA_IDE_ACCI_K" numeric(10,0) NOT NULL,
  "SCMOA_FCH_HOR" timestamp without time zone NOT NULL,
  "SCMAR_IDE_ROL_K" numeric(10,0) NOT NULL,
  "SCMOA_GLS_DES" character varying(500),
  "SCMOA_VLR_SAL" numeric(10,2),
  "SCMOA_VLR_STO" numeric(10,2),
  "SCMOA_COC_UNI_MED_STO" character varying(3),
  "SCMOL_IDE_NUM_PNC_K" numeric(10,0),
  CONSTRAINT "GESAC_MOV_ACC_EJEC_pkey" PRIMARY KEY ("SCMOA_IDE_ACCI_K"),
  CONSTRAINT "FK_GESAC_MAE_ROL_GESAC_MOV_ACC_EJEC" FOREIGN KEY ("SCMAR_IDE_ROL_K")
      REFERENCES "CPSAA"."GESAC_MAE_ROL" ("SCMAR_IDE_ROL_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "FK_GESAC_MOV_LOTE_PNC_GESAC_MOV_ACC_EJEC" FOREIGN KEY 

("SCMOL_IDE_NUM_PNC_K")
      REFERENCES "CPSAA"."GESAC_MOV_LOTE_PNC" ("SCMOL_IDE_NUM_PNC_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE "CPSAA"."GESAC_MOV_RESU"
(
  "SCMOR_IDE_RES_K" numeric(10,0) NOT NULL,
  "SCMOR_FCH_HOR" timestamp without time zone NOT NULL,
  "SCMOR_GLS_DES" character varying(500),
  "SCMAR_IDE_ROL_K" numeric(10,0) NOT NULL,
  "SCMOR_GSL_OBS" character varying(500),
  "SCMOL_IDE_NUM_PNC_K" numeric(10,0) NOT NULL,
  CONSTRAINT "GESAC_MOV_RESU_pkey" PRIMARY KEY ("SCMOR_IDE_RES_K"),
  CONSTRAINT "FK_GESAC_MAE_ROL_GESAC_MOV_RESU" FOREIGN KEY ("SCMAR_IDE_ROL_K")
      REFERENCES "CPSAA"."GESAC_MAE_ROL" ("SCMAR_IDE_ROL_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT "FK_GESAC_MOV_LOTE_PNC_GESAC_MOV_RESU" FOREIGN KEY 

("SCMOL_IDE_NUM_PNC_K")
      REFERENCES "CPSAA"."GESAC_MOV_LOTE_PNC" ("SCMOL_IDE_NUM_PNC_K") MATCH SIMPLE
      ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE "CPSAA"."GESAC_MOV_TRAT"
(
  "SCMOT_IDE_TRAT_K" numeric(10,0) NOT NULL,
  "SCMOT_GLS_DES" character varying(500),
  CONSTRAINT "GESAC_MOV_TRAT_pkey" PRIMARY KEY ("SCMOT_IDE_TRAT_K")
);

--INSERTO DATA A LA TABLA MOV_TRAT
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (1,'Reproceso');
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (2,'Reclasificaci�n para usos alternativos');
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (3,'Desechado');
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (4,'Aceptaci�n por personal autorizado');
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (5,'Aceptaci�n por concesi�n del cliente');
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (6,'Reensayo para evaluar conformidad');
INSERT INTO "CPSAA"."GESAC_MOV_TRAT"("SCMOT_IDE_TRAT_K", "SCMOT_GLS_DES") VALUES (7,'Otro');


-- Function: nombretipoensayoesresistenciacompresion28dias(character varying)

-- DROP FUNCTION nombretipoensayoesresistenciacompresion28dias(character varying);

CREATE OR REPLACE FUNCTION nombretipoensayoesresistenciacompresion28dias(character 

varying)
  RETURNS integer AS
$BODY$

/**********************************************
FECHA		: 21-03-2012
DESCRIPCION	: VALIDA SI EL NOMBRE TIPO ENSAYO QUE SE PASA COMO PARAMETRO CONTIENE 

LAS PALABRAS: RESISTENCIA, COMPRESI�N o COMPRESION Y 28
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
	IF(posicion > 0) THEN select position('COMPRESI�N' in upper(nombreTipoEnsayo)) into posicion;
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
ALTER FUNCTION nombretipoensayoesresistenciacompresion28dias(character varying) OWNER 

TO postgres;




-- Function: existeresistenciacompresion28dias(numeric)

-- DROP FUNCTION existeresistenciacompresion28dias(numeric);

CREATE OR REPLACE FUNCTION existeresistenciacompresion28dias(numeric)
  RETURNS integer AS
$BODY$	
/**********************************************
FECHA		: 23-03-2012
DESCRIPCION	: BUSCA EN TODOS LOS ENSAYOS QUE PERTENECEN A UNA MUESTRA SI EXISTE 

ENTRE ELLOS UN ENSAYO QUE TENGA
		  COMO NOMBRE TIPO ENSAYO = RESISTENCIA COMPRESION 28 DIAS Y VALIDA SU 

ESTADO
DEVUELVE	: 1 = SI EXISTE UN ENSAYO CON NOMBRE TIPO DE ENSAYO RESISTENCIA 

COMPRESION 28 DIAS Y SU ESTADO ES = 'NOC'
		  2 = SI EXISTE UN ENSAYO CON NOMBRE TIPO DE ENSAYO RESISTENCIA 

COMPRESION 28 DIAS Y SU ESTADO ES != 'NOC'
		  0 = SI NO EXISTE ENSAYO CON NOMBRE TIPO DE ENSAYO RESISTENCIA 

COMPRESION 28 DIAS
AUTOR		: David Vivar Quinteros - CSTI
**********************************************/

	DECLARE 
	resultado integer := 0;
	estadoEnsayo character varying(3);
	esResistencia28Dias integer := 0;
	nombreTipoEnsayo character varying(100); 
	
	micursor CURSOR FOR SELECT 
					MAE."SCMTE_NOM_TIPO_ENSA", MOV."SCMOE_COC_EST_TRA"--, MAE."SCMTE_NOM_TIPO_ENSA", MOV."SCMOE_COC_EST_TRA"
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
				ELSE
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



--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Function: verificarlotepnc()

-- DROP FUNCTION verificarlotepnc();

CREATE OR REPLACE FUNCTION verificarlotepnc()
  RETURNS trigger AS
$BODY$

/**********************************************
FECHA		: 21-03-2012
DESCRIPCION	: CAMBIA DE ESTADO EL LOTE A NO CONFORME E INSERTA EN LA TABLA LOTE_PNC
AUTOR		: DVQ
**********************************************/

    DECLARE
	
	idLote numeric(10,0); --GUARDA EL ID DEL LOTE PARA REALIZAR EL UPDATE Y EL INSERT
	nombreTipoEnsayo character varying(100);
	insertoLotePNC integer := 0;
	contadorEstadoNOC integer := 0;
	idPlanta numeric(10,0); --GUARDA EL ID DE LA PLANTA DEL LOTE
	--DVQ 22-03-2012
	--existeResistenciaCompresion integer := 0; --> 0: SI NO EXISTE RESISTENCIA COMPRESION 28 DIAS, 1: SI EXISTE Y SU ESTADO ES 'NOC', 2: SI EXISTE Y SU ESTADO ES DIFERENTE A 'NOC'
	contadorLoteEnLotePNC integer := 0; --> SIRVE PARA SABER SI EN LA TABLA DE LOTE_PNC YA HAY UN REGISTRO CON EL IDLOTE (PARA NO REGISTRAR 2 VECES CON EL MISMO ID LOTE)
	esResistencia28Dias integer := 0; --> GUARDA EL FLAG PARA SABER SI EL NOMBRE DEL TIPO DE ENSAYO ES DE RESISTENCIA COMPRESION 28 DIAS, 1 = ES DE RESISTENCIA COMPRESION, 0 = NO ES
    BEGIN
	
	-- OBTENGO EL ID DEL LOTE AL QUE ESTA ASOCIADO ESE ENSAYO
	  SELECT 
		LOTE."SCMOL_IDE_LOTE_K" INTO idLote
	  FROM
		"CPSAA"."GESAC_MOV_LOTE" LOTE INNER JOIN
		"CPSAA"."GESAC_MOV_MUES" MUESTRA ON
		LOTE."SCMOL_IDE_LOTE_K" = MUESTRA."SCMOL_IDE_LOTE_K" INNER JOIN
		"CPSAA"."GESAC_MOV_ENSA" ENSAYO ON
		ENSAYO."SCMOM_IDE_MUES_K" = MUESTRA."SCMOM_IDE_MUES_K"
	  WHERE
		ENSAYO."SCMOE_IDE_ENSA_K" = NEW."SCMOE_IDE_ENSA_K";
			
	--VERIFICO QUE idLote NO SEA NULO
	IF idLote IS NOT NULL THEN

		--VERIFICO QUE EL ID LOTE NO EXISTA EN LA TABLA DE LOTE_PNC, SI YA EXISTE ENTONCES NO HAGO NADA
		SELECT 
			COUNT(*) INTO contadorLoteEnLotePNC
		FROM 
			"CPSAA"."GESAC_MOV_LOTE_PNC"
		WHERE
			"SCMOL_IDE_LOTE_K" = idLote;

		--SI EL contadorLoteEnLotePNC ES 0 --> HAGO LA LOGICA, SINO NO HAGO NADA PORQUE ESE LOTE YA EXISTE EN LA TABLA LOTE_PNC
		IF (contadorLoteEnLotePNC = 0) THEN
		
			--OBTENGO EL NOMBRE DEL TIPO DE ENSAYO
			SELECT 
				MAE."SCMTE_NOM_TIPO_ENSA" INTO nombreTipoEnsayo
			FROM
				"CPSAA"."GESAC_MOV_ENSA" MOV INNER JOIN
				"CPSAA"."GESAC_MAE_TIPO_ENSA" MAE ON
				MOV."SCMTE_IDE_TIPO_ENSA_K" = MAE."SCMTE_IDE_TIPO_ENSA_K"
			WHERE
				MOV."SCMOE_IDE_ENSA_K" = NEW."SCMOE_IDE_ENSA_K";
						
			--OBTENGO EL ID DE LA PLANTA ASOCIADA A ESE LOTE
			  SELECT LOTE."SCMAP_IDE_PLAN_K" INTO idPlanta
			  FROM
				"CPSAA"."GESAC_MOV_LOTE" LOTE 
			  WHERE
				LOTE."SCMOL_IDE_LOTE_K" = idLote;

			--VERIFICO SI EL TIPO DE ENSAYO DE ESE REGISTRO ES DE RESISTENCIA COMPRESION A 28 DIAS
			IF nombreTipoEnsayo IS NOT NULL THEN
				--IF(nombreTipoEnsayo = 'Resistencia Compresi�n a 28d�as' OR nombreTipoEnsayo = 'Resistencia Compresi�n 28d�as') THEN 			
				select nombreTipoEnsayoEsResistenciaCompresion28Dias(nombreTipoEnsayo) INTO esResistencia28Dias;
				IF (esResistencia28Dias = 1) THEN
					--VERIFICO SI EL ESTADO DEL REGISTRO QUE SE HA INSERTADO ES IGUAL A 'NOC'
					IF (NEW."SCMOE_COC_EST_TRA" = 'NOC') THEN					
						--ACTUALIZO EL ESTADO DEL LOTE
						--UPDATE "CPSAA"."GESAC_MOV_LOTE"
						--SET
							--"SCMOL_COC_EST" = 'NCO'
						--WHERE
							--"SCMOL_IDE_LOTE_K" = idLote;
						
						--INSERTO UN REGISTRO EN LA TABLA LOTE_PNC
						INSERT INTO "CPSAA"."GESAC_MOV_LOTE_PNC"(
							"SCMOL_IDE_NUM_PNC_K", "SCMOL_FCH_HOR_REG", "SCMOL_IDE_LOTE_K", "SCMAP_IDE_PLAN_K")
						VALUES ( (SELECT
								coalesce(max(LOTE_PNC."SCMOL_IDE_NUM_PNC_K"),0) + 1
							FROM
								"CPSAA"."GESAC_MOV_LOTE_PNC" LOTE_PNC),(SELECT TIMESTAMP WITHOUT TIME ZONE 'now'), idLote, idPlanta);
						
					ELSE
						--VERIFICO SI HAY ENTRE TODOS LOS ENSAYOS POR LO MENOS UN ENSAYO CON ESTADO NO CONFORME (NOC)
						  SELECT COUNT(*) INTO contadorEstadoNOC
						FROM 
							"CPSAA"."GESAC_MOV_ENSA"
						WHERE
							"SCMOM_IDE_MUES_K" = NEW."SCMOM_IDE_MUES_K"
						AND
							"SCMOE_COC_EST_TRA" = 'NOC';
										
						IF (contadorEstadoNOC > 0) THEN
						--TENGO QUE ACTUALIZAR Y TENGO QUE INSERTAR EN LA TABLA LOTE_PNC
							IF idLote IS NOT NULL THEN
							--ACTUALIZO EL ESTADO DEL LOTE
								UPDATE "CPSAA"."GESAC_MOV_LOTE"
								SET
									"SCMOL_COC_EST" = 'NCO'
								WHERE
									"SCMOL_IDE_LOTE_K" = idLote;

							--INSERTO UN REGISTRO EN LA TABLA LOTE_PNC
								INSERT INTO "CPSAA"."GESAC_MOV_LOTE_PNC"(
									"SCMOL_IDE_NUM_PNC_K", "SCMOL_FCH_HOR_REG", "SCMOL_IDE_LOTE_K", "SCMAP_IDE_PLAN_K")
								VALUES ( (SELECT
										coalesce(max(LOTE_PNC."SCMOL_IDE_NUM_PNC_K"),0) + 1
									   FROM
									   "CPSAA"."GESAC_MOV_LOTE_PNC" LOTE_PNC),(SELECT TIMESTAMP WITHOUT TIME ZONE 'now'), idLote, idPlanta);
							END IF;				
						END IF;
					END IF;
				--SI EL ENSAYO QUE SE VA A INSERTAR NO ES DE RESISTENCIA COMPRESION A 28 DIAS, VALIDO QUE EXISTA EN LOS DEMAS ENSAYOS UNO DE RESISTENCIA COMPRESION A 28 DIAS
				ELSE 
					SELECT existeResistenciaCompresion28Dias(NEW."SCMOM_IDE_MUES_K") INTO esResistencia28Dias;
					IF (esResistencia28Dias = 2) THEN--SI ES 2 --> EXISTE RESISTENCIA COMPRESION 28 DIAS PERO SU ESTADO NO ES 'NOC'
						--VERIFICO SI HAY ENTRE TODOS LOS ENSAYOS POR LO MENOS UN ENSAYO CON ESTADO NO CONFORME (NOC)
						  SELECT COUNT(*) INTO contadorEstadoNOC
						FROM 
							"CPSAA"."GESAC_MOV_ENSA"
						WHERE
							"SCMOM_IDE_MUES_K" = NEW."SCMOM_IDE_MUES_K"
						AND
							"SCMOE_COC_EST_TRA" = 'NOC';
					
						IF (contadorEstadoNOC > 0) THEN
							--TENGO QUE ACTUALIZAR Y TENGO QUE INSERTAR EN LA TABLA LOTE_PNC
							--ACTUALIZO EL ESTADO DEL LOTE
							UPDATE "CPSAA"."GESAC_MOV_LOTE"
							SET
								"SCMOL_COC_EST" = 'NCO'
							WHERE
								"SCMOL_IDE_LOTE_K" = idLote;

							--INSERTO UN REGISTRO EN LA TABLA LOTE_PNC
							INSERT INTO "CPSAA"."GESAC_MOV_LOTE_PNC"(
								"SCMOL_IDE_NUM_PNC_K", "SCMOL_FCH_HOR_REG", "SCMOL_IDE_LOTE_K", "SCMAP_IDE_PLAN_K")
							VALUES ( (SELECT
									coalesce(max(LOTE_PNC."SCMOL_IDE_NUM_PNC_K"),0) + 1
								   FROM
								   "CPSAA"."GESAC_MOV_LOTE_PNC" LOTE_PNC),(SELECT TIMESTAMP WITHOUT TIME ZONE 'now'), idLote, idPlanta);

						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;
	RETURN NULL;  
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION verificarlotepnc() OWNER TO postgres;



--------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE TRIGGER validarlotepnc
  AFTER INSERT OR UPDATE
  ON "CPSAA"."GESAC_MOV_ENSA"
  FOR EACH ROW
  EXECUTE PROCEDURE verificarlotepnc();

  INSERT INTO "CPSAA"."GESAC_MAE_PERM"(
            "SCMAP_IDE_PERM_K", "SCMAP_COC_PERM", "SCMAP_NOM_PERM", "SCMAP_GLS_DES", 
            "SCMAP_GLS_MOD_FUN", "SCMAP_GLS_CAS_USO", "SCMAP_COC_EST")
    VALUES ((SELECT coalesce(max(PER."SCMAP_IDE_PERM_K"),0) + 1 FROM "CPSAA"."GESAC_MAE_PERM" PER), 'CAL009_PER_001', 'Registrar Lote, Muestras, Trazabilidad y Ensayos','Permite ingresar a la pantalla de registrar Lote, Muestras, Trazabilidad y Ensayos','CAL', 'CAL009', 'ACT');


INSERT INTO "CPSAA"."GESAC_DET_PERM_ROL"(
            "SCDPR_IDE_PERM_ROL_K", "SCMAP_IDE_PERM_K", "SCMAR_IDE_ROL_K", 
            "SCDPR_FLG_ELI", "SCDPR_COC_EST")
    VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_DET_PERM_ROL"') from "CPSAA"."GESAC_SEQ_ID_DET_PERM_ROL"), (SELECT MAX("SCMAP_IDE_PERM_K") FROM "CPSAA"."GESAC_MAE_PERM"), 11,'N', 'ACT');
			
-- 29-03-2012: A�ADE PARAMETRO QUE INDICA CUANTOS TURNOS SE A�ADIRAN PARA EL MANTENIMIENTO DE ADMINISTRAR TURNO
INSERT INTO "CPSAA"."GESAC_PAR_SIS"(
            "SCPAS_IDE_PAR_SIS_K", "SCPAS_NOM_PAR", "SCPAS_GLS_DES", "SCPAS_GLS_VLR")
    VALUES ((SELECT coalesce(max(PAR."SCPAS_IDE_PAR_SIS_K"),0) + 1 FROM "CPSAA"."GESAC_PAR_SIS" PAR),'PARAMETRO_NUMERO_TURNOS_ADICIONALES', 'Numero de turnos a aumentar en la pantalla de Administrar Turnos', '5');
	
	
--SE AGREGA COLUMNA DE ESTADO PARA ACTIVAR Y DESACTIVAR X LA APLICACION
alter table "CPSAA"."GESAC_MAE_GRUP_MUES" add "SCMGM_COC_EST" character varying(3);

update "CPSAA"."GESAC_MAE_GRUP_MUES" set "SCMGM_COC_EST" = 'ACT';

--09-04-2012: SE AGREGA COLUMNA DE ESTADO PARA ACTIVAR Y DESACTIVAR X LA APLICACION
alter table "CPSAA"."GESAC_MAE_TURN" add "SCMTU_COC_EST" character varying(3);

update "CPSAA"."GESAC_MAE_TURN" set "SCMTU_COC_EST" = 'ACT';

--11-04-2012: SE AGREGA COLUMNA DE ESTADO PARA ACTIVAR Y DESACTIVAR X LA APLICACION
alter table "CPSAA"."GESAC_MAE_LINE_PROD" add "SCMLP_COC_EST" character varying(3);

update "CPSAA"."GESAC_MAE_LINE_PROD" set "SCMLP_COC_EST" = 'ACT';

alter table "CPSAA"."GESAC_MAE_TIPO_ENSA" add "SCMTE_FLG_REP_PRO_PON" character (1) NOT NULL DEFAULT 'N'::bpchar;

update "CPSAA"."GESAC_MAE_NEGO" set "SCMAN_COC_EST" = 'ACT';


------


INSERT INTO "CPSAA"."GESAC_MAE_ROL"(
            "SCMAR_IDE_ROL_K", "SCMAR_NOM_ROL", "SCMAR_GLS_DES", "SCMAR_COC_EST")
    VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_ROL"') from "CPSAA"."GESAC_SEQ_ID_ROL"), 'Responsable de Administraci�n de Datos', 'Tendr� acceso a todos los mantenimientos del Administrar Datos', 'ACT');



-- 16-05-2012: SE AGREGA UN PERMISO PARA AMARRAR AL ROL CREADO ANTERIORMENTE
INSERT INTO "CPSAA"."GESAC_MAE_PERM"(
"SCMAP_IDE_PERM_K", "SCMAP_COC_PERM", "SCMAP_NOM_PERM", "SCMAP_GLS_DES", 
"SCMAP_GLS_MOD_FUN", "SCMAP_GLS_CAS_USO", "SCMAP_COC_EST")
VALUES ((SELECT coalesce(max(PER."SCMAP_IDE_PERM_K"),0) + 1 FROM "CPSAA"."GESAC_MAE_PERM" PER), 'SIS003_PER_002', 'Administrar Datos', 
'Tendr� acceso a todos los mantenimientos del Administrar Datos', 'SIS', 'CAL002', 'ACT');


-- AMARRO EL ROL CON EL PERMISO
INSERT INTO "CPSAA"."GESAC_DET_PERM_ROL"(
            "SCDPR_IDE_PERM_ROL_K", "SCMAP_IDE_PERM_K", "SCMAR_IDE_ROL_K", 
            "SCDPR_FLG_ELI", "SCDPR_COC_EST")
    VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_DET_PERM_ROL"') from "CPSAA"."GESAC_SEQ_ID_DET_PERM_ROL"), (SELECT MAX("SCMAP_IDE_PERM_K") FROM "CPSAA"."GESAC_MAE_PERM"), (SELECT currval('"CPSAA"."GESAC_SEQ_ID_ROL"') from "CPSAA"."GESAC_SEQ_ID_ROL"), 
            'N', 'ACT');

INSERT INTO "CPSAA"."GESAC_DET_ROL_PUE_TRA"(
            "SCDRP_IDE_ROL_PUE_TRA_K", "SCMAR_IDE_ROL_K", "SCDRP_COC_PUE_TRA", 
            "SCDRP_FLG_ELI", "SCMAP_COC_EST")
    VALUES ((SELECT nextval('"CPSAA"."GESAC_SEQ_ID_ROLPUESTOTRABAJO"') from "CPSAA"."GESAC_SEQ_ID_ROLPUESTOTRABAJO"), (SELECT currval('"CPSAA"."GESAC_SEQ_ID_ROL"') from "CPSAA"."GESAC_SEQ_ID_ROL"), 'A102', 
            'N', 'ACT');

alter table "CPSAA"."GESAC_DET_NEGO_PLAN" add "SCDNP_COC_EST" character varying(3);

update "CPSAA"."GESAC_DET_NEGO_PLAN" SET "SCDNP_COC_EST" = 'ACT';