--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.3
-- Dumped by pg_dump version 12.2 (Ubuntu 12.2-1.pgdg18.04+1)

-- Started on 2020-02-20 14:17:29 -04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 9 (class 2615 OID 413172)
-- Name: intranet; Type: SCHEMA; Schema: -; Owner: sisdesa
--

CREATE SCHEMA intranet;


ALTER SCHEMA intranet OWNER TO sisdesa;

--
-- TOC entry 2 (class 3079 OID 413167)
-- Name: postgres_fdw; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgres_fdw WITH SCHEMA public;


--
-- TOC entry 2182 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgres_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgres_fdw IS 'foreign-data wrapper for remote PostgreSQL servers';


--
-- TOC entry 217 (class 1255 OID 642514)
-- Name: gac_before_ins_tac_actas(); Type: FUNCTION; Schema: public; Owner: sisdesa
--

CREATE FUNCTION public.gac_before_ins_tac_actas() RETURNS trigger
    LANGUAGE plpgsql STRICT
    AS $$
  DECLARE correlativo INTEGER;
BEGIN
  SELECT MAX(numero_acta) + 1
    INTO correlativo
    FROM tac_actas;
  NEW.numero_acta := COALESCE(correlativo, 1);
  RETURN NEW;
end;
$$;


ALTER FUNCTION public.gac_before_ins_tac_actas() OWNER TO sisdesa;

--
-- TOC entry 218 (class 1255 OID 822749)
-- Name: monto_escrito(double precision); Type: FUNCTION; Schema: public; Owner: sisdesa
--

CREATE FUNCTION public.monto_escrito(double precision) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
-- select monto_escrito(2468);
declare
  numero   alias for $1;
  entero   numeric;
  retorno  varchar;
  terna    int2;
  cadena   varchar;
  unidades int2;
  decenas  int2;
  centenas int2;
  fraccion numeric;
  moneda   varchar := '';
  unida    varchar[] := array['','uno ','dos ','tres ','cuatro ','cinco ','seis ','siete ','ocho ','nueve '];
  unidá    varchar[] := array['','ún ','dós ','trés ','cuatro ','cinco ','séis ','siete ','ocho ','nueve '];
  bsf      varchar := '';
  bsfs     varchar := '';

begin
  entero   := TRUNC(ABS(numero));
  fraccion := ROUND((ABS(numero) - entero) * 100);
  retorno  := '';
  terna    := 1;

  IF now() BETWEEN '2008-01-01' AND '2008-06-30' THEN
     bsf := ' fuerte';
     bsfs := ' fuertes';
  END IF;

/*
  IF entero = 1 THEN
     moneda = ' bolívar' || bsf;
  ELSE
     IF entero > 999999  AND  (entero % 1000000 = 0) then
        moneda = ' de bolívares' || bsfs;
     ELSE
        moneda = ' bolívares' || bsfs;
     END IF;
  END IF;
*/

  IF entero = 1 THEN
    RETURN 'primero';
  END IF;

  WHILE entero > 0 LOOP
  -- Se recorre terna x terna
    unidades := entero % 10;
    entero   := TRUNC(entero / 10);
    decenas  := entero % 10;
    entero   := TRUNC(entero / 10);
    centenas := entero % 10;
    entero   := TRUNC(entero / 10);

  -- Se asignan las unidades
    cadena := lower(unida[unidades + 1]);
--cadena := (unida[unidades + 1]);

  -- Se analizan las decenas
    SELECT
      CASE WHEN decenas = 1 THEN
             (SELECT
                CASE WHEN unidades = 0 THEN 'diez '
                     WHEN unidades = 1 THEN 'once '
                     WHEN unidades = 2 THEN 'doce '
                     WHEN unidades = 3 THEN 'trece '
                     WHEN unidades = 4 THEN 'catorce '
                     WHEN unidades = 5 THEN 'quince '
                     ELSE 'dieci' || lower(unidá[unidades + 1])
                END)
           WHEN (decenas = 2 AND unidades  = 0) THEN 'veinte '
           WHEN (decenas = 2 AND unidades != 0) THEN 'veinte y '     || unida[unidades + 1]
           WHEN (decenas = 3 AND unidades  = 0) THEN 'treinta '
           WHEN (decenas = 3 AND unidades != 0) THEN 'treinta y '    || unida[unidades + 1]
           WHEN (decenas = 4 AND unidades  = 0) THEN 'cuarenta '
           WHEN (decenas = 4 AND unidades != 0) THEN 'cuarenta y '   || unida[unidades + 1]
           WHEN (decenas = 5 AND unidades  = 0) THEN 'cincuenta '
           WHEN (decenas = 5 AND unidades != 0) THEN 'cincuenta y '  || unida[unidades + 1]
           WHEN (decenas = 6 AND unidades  = 0) THEN 'sesenta '
           WHEN (decenas = 6 AND unidades != 0) THEN 'sesenta y '    || unida[unidades + 1]
           WHEN (decenas = 7 AND unidades  = 0) THEN 'setenta '
           WHEN (decenas = 7 AND unidades != 0) THEN 'setenta y '    || unida[unidades + 1]
           WHEN (decenas = 8 AND unidades  = 0) THEN 'ochenta '
           WHEN (decenas = 8 AND unidades != 0) THEN 'ochenta y '    || unida[unidades + 1]
           WHEN (decenas = 9 AND unidades  = 0) THEN 'noventa '
           WHEN (decenas = 9 AND unidades != 0) THEN 'noventa y '    || unida[unidades + 1]
/*
           WHEN (decenas = 2 AND unidades  = 0) THEN 'veinte '
           WHEN (decenas = 2 AND unidades != 0) THEN 'veinti'     || unidá[unidades + 1]
           WHEN (decenas = 3 AND unidades  = 0) THEN 'treinta '
           WHEN (decenas = 3 AND unidades != 0) THEN 'treinti'    || unidá[unidades + 1]
           WHEN (decenas = 4 AND unidades  = 0) THEN 'cuarenta '
           WHEN (decenas = 4 AND unidades != 0) THEN 'cuarenti'   || unidá[unidades + 1]
           WHEN (decenas = 5 AND unidades  = 0) THEN 'cincuenta '
           WHEN (decenas = 5 AND unidades != 0) THEN 'cincuenti'  || unidá[unidades + 1]
           WHEN (decenas = 6 AND unidades  = 0) THEN 'sesenta '
           WHEN (decenas = 6 AND unidades != 0) THEN 'sesenti'    || unidá[unidades + 1]
           WHEN (decenas = 7 AND unidades  = 0) THEN 'setenta '
           WHEN (decenas = 7 AND unidades != 0) THEN 'setenti'    || unidá[unidades + 1]
           WHEN (decenas = 8 AND unidades  = 0) THEN 'ochenta '
           WHEN (decenas = 8 AND unidades != 0) THEN 'ochenti'    || unidá[unidades + 1]
           WHEN (decenas = 9 AND unidades  = 0) THEN 'noventa '
           WHEN (decenas = 9 AND unidades != 0) THEN 'noventi'    || unidá[unidades + 1]
*/
           ELSE cadena
      END
      INTO cadena;

--   raise notice ' cadena_decena_%', cadena;

  -- Se analizan las decenas
    SELECT
      CASE WHEN (centenas = 1 AND unidades = 0 AND decenas = 0)       THEN 'cien '          || cadena
           WHEN (centenas = 1 AND NOT (unidades = 0 AND decenas = 0)) THEN 'ciento '        || cadena
           WHEN  centenas = 2                                         THEN 'doscientos '    || cadena
           WHEN  centenas = 3                                         THEN 'trescientos '   || cadena
           WHEN  centenas = 4                                         THEN 'cuatrocientos ' || cadena
           WHEN  centenas = 5                                         THEN 'quinientos '    || cadena
           WHEN  centenas = 6                                         THEN 'seiscientos '   || cadena
           WHEN  centenas = 7                                         THEN 'setecientos '   || cadena
           WHEN  centenas = 8                                         THEN 'ochocientos '   || cadena
           WHEN  centenas = 9                                         THEN 'novecientos '   || cadena
           ELSE  cadena
      END
      INTO cadena;


  -- Se analiza la terna
    IF terna = 2 THEN
       IF (unidades + decenas + centenas) != 0 THEN
          cadena := cadena || 'mil ';
       END IF;
    ELSIF terna = 3 THEN
       IF (unidades = 1 AND decenas = 0 and centenas = 0) THEN
          cadena := cadena || 'millón ';
       ELSIF (unidades + decenas + centenas) != 0 AND NOT (unidades = 1 AND decenas = 0 and centenas = 0) THEN
          cadena := cadena || 'millones ';
       END IF;
    ELSIF terna = 4 THEN
       IF (unidades + decenas + centenas) != 0 THEN
          cadena := cadena || 'mil millones ';
       END IF;
    ELSIF terna > 4 THEN
       cadena := 'ERROR: NÚMERO DEMASIADO GRANDE ';
    END IF;
   
  -- Se arma el retorno terna a terna
    retorno := cadena || retorno;
    terna := terna + 1;

  END LOOP;



  IF terna = 1 THEN
     retorno := 'cero';
  END IF;

  IF fraccion = 0 THEN
     cadena := TRIM(retorno) || moneda;

--'4_id_trabajador_%',recTrabajadores1.id_trabajador
  ELSE

     
       cadena := TRIM(retorno) || moneda || ' con ' ||
   --    SUBSTRING (monto_escrito(fraccion) FROM 1 FOR 1) || lower(SUBSTRING(monto_escrito(fraccion) FROM 2 ));
       SUBSTRING(monto_escrito(fraccion) FROM 1 FOR 1) || REPLACE (SUBSTRING(monto_escrito(fraccion) FROM 2 ),'bolívares','céntimos') ;                 
       
     --REPLACE('bolívares',lower(monto_escrito(fraccion)),'céntimos';
  END IF;

--  cadena := lower(SUBSTRING(cadena FROM 1 FOR 1)) || lower(SUBSTRING(cadena FROM 2 FOR POSITION(' ' in cadena)-1)) || SUBSTRING(cadena FROM POSITION(' ' in cadena)+1);


  unidades := POSITION(' ' in cadena);
  IF entero > 0 THEN
    cadena := lower(SUBSTRING(cadena FROM 1 FOR 1)) || lower(SUBSTRING(cadena FROM 2 FOR unidades-1)) || SUBSTRING(cadena FROM unidades+1);
  END IF;
  
  RETURN cadena;
END
$_$;


ALTER FUNCTION public.monto_escrito(double precision) OWNER TO sisdesa;

--
-- TOC entry 216 (class 1255 OID 519667)
-- Name: suma(); Type: FUNCTION; Schema: public; Owner: sisdesa
--

CREATE FUNCTION public.suma() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE correlativo integer;
        BEGIN
                SELECT MAX(numero_acta) +001 INTO correlativo   FROM tac_actas;
                RETURN correlativo;
                INSERT INTO tac_actas (numero_acta) VALUES(correlativo);
                IF correlativo < 13 THEN
                RAISE EXCEPTION 'Pasando por aqui!!!';
                END IF;       
        END;
$$;


ALTER FUNCTION public.suma() OWNER TO sisdesa;

--
-- TOC entry 1645 (class 1417 OID 413171)
-- Name: serv_intranet; Type: SERVER; Schema: -; Owner: sisdesa
--

CREATE SERVER serv_intranet FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'intranet',
    host 'huachamacare',
    port '9992'
);


ALTER SERVER serv_intranet OWNER TO sisdesa;

--
-- TOC entry 2183 (class 0 OID 0)
-- Name: USER MAPPING sisdesa SERVER serv_intranet; Type: USER MAPPING; Schema: -; Owner: sisdesa
--

CREATE USER MAPPING FOR sisdesa SERVER serv_intranet OPTIONS (
    password '12qwaszx',
    "user" 'sisdesa'
);


--
-- TOC entry 1646 (class 1417 OID 454095)
-- Name: serv_intranet_produccion; Type: SERVER; Schema: -; Owner: sisdesa
--

CREATE SERVER serv_intranet_produccion FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'intranet',
    host 'yuruanitepuy',
    port '9992'
);


ALTER SERVER serv_intranet_produccion OWNER TO sisdesa;

--
-- TOC entry 2184 (class 0 OID 0)
-- Name: USER MAPPING sisdesa SERVER serv_intranet_produccion; Type: USER MAPPING; Schema: -; Owner: sisdesa
--

CREATE USER MAPPING FOR sisdesa SERVER serv_intranet_produccion OPTIONS (
    password '12qwaszx',
    "user" 'sisdesa'
);


--
-- TOC entry 1647 (class 1417 OID 454109)
-- Name: serv_intranet_prueba; Type: SERVER; Schema: -; Owner: sisdesa
--

CREATE SERVER serv_intranet_prueba FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'intranet',
    host 'huachamacare',
    port '5432'
);


ALTER SERVER serv_intranet_prueba OWNER TO sisdesa;

--
-- TOC entry 1648 (class 1417 OID 454110)
-- Name: serv_intranet_pruebas; Type: SERVER; Schema: -; Owner: sisdesa
--

CREATE SERVER serv_intranet_pruebas FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    dbname 'intranet',
    host 'huachamacare',
    port '5433'
);


ALTER SERVER serv_intranet_pruebas OWNER TO sisdesa;

--
-- TOC entry 2185 (class 0 OID 0)
-- Name: USER MAPPING sisdesa SERVER serv_intranet_pruebas; Type: USER MAPPING; Schema: -; Owner: sisdesa
--

CREATE USER MAPPING FOR sisdesa SERVER serv_intranet_pruebas OPTIONS (
    password '12qwaszx',
    "user" 'sisdesa'
);


SET default_tablespace = '';

--
-- TOC entry 181 (class 1259 OID 454106)
-- Name: tia_competencias; Type: FOREIGN TABLE; Schema: intranet; Owner: sisdesa
--

CREATE FOREIGN TABLE intranet.tia_competencias (
    id integer NOT NULL,
    acronimo character varying(3) NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text NOT NULL,
    tia_materia_id integer[] NOT NULL,
    tia_ley_id integer[] NOT NULL,
    estatus boolean NOT NULL,
    buscar_en_dependencia character varying[],
    tiene_delito boolean
)
SERVER serv_intranet_produccion
OPTIONS (
    schema_name 'actuacion_procesal',
    table_name 'tia_competencias'
);


ALTER FOREIGN TABLE intranet.tia_competencias OWNER TO sisdesa;

--
-- TOC entry 183 (class 1259 OID 454124)
-- Name: tin_sedes; Type: FOREIGN TABLE; Schema: intranet; Owner: sisdesa
--

CREATE FOREIGN TABLE intranet.tin_sedes (
    id integer NOT NULL,
    sig_sede_id integer,
    tin_ciudad_id integer,
    cod_sede character varying(100),
    descripcion character varying(150),
    direccion text
)
SERVER serv_intranet_pruebas
OPTIONS (
    schema_name 'public',
    table_name 'tin_sedes'
);


ALTER FOREIGN TABLE intranet.tin_sedes OWNER TO sisdesa;

--
-- TOC entry 178 (class 1259 OID 413159)
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO sisdesa;

--
-- TOC entry 177 (class 1259 OID 413151)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO sisdesa;

--
-- TOC entry 180 (class 1259 OID 445905)
-- Name: tac_actas; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_actas (
    id integer NOT NULL,
    numero_acta smallint NOT NULL,
    creado_el timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    sede character varying NOT NULL,
    tac_firmante_id integer,
    para timestamp with time zone,
    estatus boolean DEFAULT true
);


ALTER TABLE public.tac_actas OWNER TO sisdesa;

--
-- TOC entry 179 (class 1259 OID 445903)
-- Name: tac_actas_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_actas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_actas_id_seq OWNER TO sisdesa;

--
-- TOC entry 2186 (class 0 OID 0)
-- Dependencies: 179
-- Name: tac_actas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_actas_id_seq OWNED BY public.tac_actas.id;


--
-- TOC entry 189 (class 1259 OID 536018)
-- Name: tac_cargos; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_cargos (
    id integer NOT NULL,
    cargos character varying
);


ALTER TABLE public.tac_cargos OWNER TO sisdesa;

--
-- TOC entry 188 (class 1259 OID 536016)
-- Name: tac_cargos_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_cargos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_cargos_id_seq OWNER TO sisdesa;

--
-- TOC entry 2187 (class 0 OID 0)
-- Dependencies: 188
-- Name: tac_cargos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_cargos_id_seq OWNED BY public.tac_cargos.id;


--
-- TOC entry 199 (class 1259 OID 994791)
-- Name: tac_competencias; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_competencias (
    id integer NOT NULL,
    competencia character varying(100)
);


ALTER TABLE public.tac_competencias OWNER TO sisdesa;

--
-- TOC entry 198 (class 1259 OID 994789)
-- Name: tac_competencias_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_competencias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_competencias_id_seq OWNER TO sisdesa;

--
-- TOC entry 2188 (class 0 OID 0)
-- Dependencies: 198
-- Name: tac_competencias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_competencias_id_seq OWNED BY public.tac_competencias.id;


--
-- TOC entry 197 (class 1259 OID 970226)
-- Name: tac_extensiones_sedes; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_extensiones_sedes (
    id integer NOT NULL,
    coordinaciones_extensiones character varying(100),
    tac_unidade_id integer
);


ALTER TABLE public.tac_extensiones_sedes OWNER TO sisdesa;

--
-- TOC entry 196 (class 1259 OID 970224)
-- Name: tac_extensiones_sedes_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_extensiones_sedes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_extensiones_sedes_id_seq OWNER TO sisdesa;

--
-- TOC entry 2189 (class 0 OID 0)
-- Dependencies: 196
-- Name: tac_extensiones_sedes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_extensiones_sedes_id_seq OWNED BY public.tac_extensiones_sedes.id;


--
-- TOC entry 187 (class 1259 OID 527826)
-- Name: tac_firmantes; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_firmantes (
    id integer NOT NULL,
    titulo character varying(5),
    primer_nombre character varying(20),
    segundo_nombre character varying(20),
    primer_apellido character varying(20),
    segundo_apellido character varying(20),
    nombre_completo character varying(60),
    cargo character varying(50),
    nombramiento character varying(500)
);


ALTER TABLE public.tac_firmantes OWNER TO sisdesa;

--
-- TOC entry 186 (class 1259 OID 527824)
-- Name: tac_firmantes_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_firmantes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_firmantes_id_seq OWNER TO sisdesa;

--
-- TOC entry 2190 (class 0 OID 0)
-- Dependencies: 186
-- Name: tac_firmantes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_firmantes_id_seq OWNED BY public.tac_firmantes.id;


--
-- TOC entry 185 (class 1259 OID 470499)
-- Name: tac_juramentados; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_juramentados (
    id integer NOT NULL,
    primer_nombre character varying(15) NOT NULL,
    segundo_nombre character varying(15),
    primer_apellido character varying(15) NOT NULL,
    segundo_apellido character varying(15),
    cedula character varying(9) NOT NULL,
    cargo character varying NOT NULL,
    resolucion character varying NOT NULL,
    tac_acta_id integer,
    fecha_resolucion date,
    tac_unidade_id integer NOT NULL,
    tac_extensiones_sedes_id integer,
    tac_competencia_id integer,
    tac_materia_id integer
);


ALTER TABLE public.tac_juramentados OWNER TO sisdesa;

--
-- TOC entry 184 (class 1259 OID 470495)
-- Name: tac_juramentados_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_juramentados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_juramentados_id_seq OWNER TO sisdesa;

--
-- TOC entry 2191 (class 0 OID 0)
-- Dependencies: 184
-- Name: tac_juramentados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_juramentados_id_seq OWNED BY public.tac_juramentados.id;


--
-- TOC entry 201 (class 1259 OID 994799)
-- Name: tac_materias; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_materias (
    id integer NOT NULL,
    materia character varying(150) NOT NULL,
    tac_competencia_id integer NOT NULL
);


ALTER TABLE public.tac_materias OWNER TO sisdesa;

--
-- TOC entry 200 (class 1259 OID 994797)
-- Name: tac_materias_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_materias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_materias_id_seq OWNER TO sisdesa;

--
-- TOC entry 2192 (class 0 OID 0)
-- Dependencies: 200
-- Name: tac_materias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_materias_id_seq OWNED BY public.tac_materias.id;


--
-- TOC entry 191 (class 1259 OID 577033)
-- Name: tac_pre_juramentados; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_pre_juramentados (
    id integer NOT NULL,
    primer_nombre character varying(15) NOT NULL,
    segundo_nombre character varying(15),
    primer_apellido character varying(15) NOT NULL,
    segundo_apellido character varying(15),
    cedula character varying(9) NOT NULL,
    cargo character varying NOT NULL,
    sede character varying NOT NULL,
    resolucion character varying NOT NULL,
    competencia character varying NOT NULL,
    id_numero_acta integer NOT NULL
);


ALTER TABLE public.tac_pre_juramentados OWNER TO sisdesa;

--
-- TOC entry 190 (class 1259 OID 577031)
-- Name: tac_pre_juramentados_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_pre_juramentados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_pre_juramentados_id_seq OWNER TO sisdesa;

--
-- TOC entry 2193 (class 0 OID 0)
-- Dependencies: 190
-- Name: tac_pre_juramentados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_pre_juramentados_id_seq OWNED BY public.tac_pre_juramentados.id;


--
-- TOC entry 195 (class 1259 OID 970218)
-- Name: tac_unidades; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.tac_unidades (
    id integer NOT NULL,
    coordinaciones_regionales character varying(100) NOT NULL
);


ALTER TABLE public.tac_unidades OWNER TO sisdesa;

--
-- TOC entry 194 (class 1259 OID 970216)
-- Name: tac_unidades_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.tac_unidades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tac_unidades_id_seq OWNER TO sisdesa;

--
-- TOC entry 2194 (class 0 OID 0)
-- Dependencies: 194
-- Name: tac_unidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.tac_unidades_id_seq OWNED BY public.tac_unidades.id;


--
-- TOC entry 182 (class 1259 OID 454118)
-- Name: tin_sedes; Type: FOREIGN TABLE; Schema: public; Owner: sisdesa
--

CREATE FOREIGN TABLE public.tin_sedes (
    id integer NOT NULL,
    descripcion character varying NOT NULL,
    estatus boolean NOT NULL,
    pdf_content_type character varying,
    pdf_file_name character varying,
    pdf_file_size integer,
    pdf_updated_at timestamp without time zone
)
SERVER serv_intranet_pruebas;


ALTER FOREIGN TABLE public.tin_sedes OWNER TO sisdesa;

--
-- TOC entry 176 (class 1259 OID 413138)
-- Name: users; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO sisdesa;

--
-- TOC entry 175 (class 1259 OID 413136)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO sisdesa;

--
-- TOC entry 2195 (class 0 OID 0)
-- Dependencies: 175
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 193 (class 1259 OID 716266)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: sisdesa
--

CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.usuarios OWNER TO sisdesa;

--
-- TOC entry 192 (class 1259 OID 716264)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: sisdesa
--

CREATE SEQUENCE public.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usuarios_id_seq OWNER TO sisdesa;

--
-- TOC entry 2196 (class 0 OID 0)
-- Dependencies: 192
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sisdesa
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 1991 (class 2604 OID 445908)
-- Name: tac_actas id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_actas ALTER COLUMN id SET DEFAULT nextval('public.tac_actas_id_seq'::regclass);


--
-- TOC entry 1996 (class 2604 OID 536021)
-- Name: tac_cargos id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_cargos ALTER COLUMN id SET DEFAULT nextval('public.tac_cargos_id_seq'::regclass);


--
-- TOC entry 2003 (class 2604 OID 994794)
-- Name: tac_competencias id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_competencias ALTER COLUMN id SET DEFAULT nextval('public.tac_competencias_id_seq'::regclass);


--
-- TOC entry 2002 (class 2604 OID 970229)
-- Name: tac_extensiones_sedes id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_extensiones_sedes ALTER COLUMN id SET DEFAULT nextval('public.tac_extensiones_sedes_id_seq'::regclass);


--
-- TOC entry 1995 (class 2604 OID 527829)
-- Name: tac_firmantes id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_firmantes ALTER COLUMN id SET DEFAULT nextval('public.tac_firmantes_id_seq'::regclass);


--
-- TOC entry 1994 (class 2604 OID 470502)
-- Name: tac_juramentados id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_juramentados ALTER COLUMN id SET DEFAULT nextval('public.tac_juramentados_id_seq'::regclass);


--
-- TOC entry 2004 (class 2604 OID 994802)
-- Name: tac_materias id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_materias ALTER COLUMN id SET DEFAULT nextval('public.tac_materias_id_seq'::regclass);


--
-- TOC entry 1997 (class 2604 OID 577036)
-- Name: tac_pre_juramentados id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_pre_juramentados ALTER COLUMN id SET DEFAULT nextval('public.tac_pre_juramentados_id_seq'::regclass);


--
-- TOC entry 2001 (class 2604 OID 970221)
-- Name: tac_unidades id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_unidades ALTER COLUMN id SET DEFAULT nextval('public.tac_unidades_id_seq'::regclass);


--
-- TOC entry 1988 (class 2604 OID 413141)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 1998 (class 2604 OID 716269)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 2155 (class 0 OID 413159)
-- Dependencies: 178
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.ar_internal_metadata VALUES ('environment', 'development', '2019-07-10 14:18:34.516161', '2019-07-10 14:18:34.516161');


--
-- TOC entry 2154 (class 0 OID 413151)
-- Dependencies: 177
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.schema_migrations VALUES ('20190704155156');
INSERT INTO public.schema_migrations VALUES ('20191030151545');
INSERT INTO public.schema_migrations VALUES ('20191030155651');


--
-- TOC entry 2157 (class 0 OID 445905)
-- Dependencies: 180
-- Data for Name: tac_actas; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_actas VALUES (59, 1, '2020-01-27 17:11:00.439091', 'AVENIDA PERIMETRAL, AL LADO DE LA C.V.G., EDF. CIRCUITO JUDICIAL DEL ESTADO AMAZONAS, PLANTA BAJA', 3, '2020-01-21 12:00:00+00', true);
INSERT INTO public.tac_actas VALUES (60, 2, '2020-02-20 15:38:49.134291', 'AVENIDA PERIMETRAL, AL LADO DE LA C.V.G., EDF. CIRCUITO JUDICIAL DEL ESTADO AMAZONAS, PLANTA BAJA', 1, '2020-02-20 15:39:00+00', true);


--
-- TOC entry 2163 (class 0 OID 536018)
-- Dependencies: 189
-- Data for Name: tac_cargos; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_cargos VALUES (1, 'Defensor (a) Público Provisorio (a)');
INSERT INTO public.tac_cargos VALUES (2, 'Defensor (a) Público Auxiliar');


--
-- TOC entry 2173 (class 0 OID 994791)
-- Dependencies: 199
-- Data for Name: tac_competencias; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_competencias VALUES (1, 'Competencias en materia Civil');
INSERT INTO public.tac_competencias VALUES (2, 'Competencias ante el Tribunal Supremo de Justicia');
INSERT INTO public.tac_competencias VALUES (3, 'Competencias en materia Penal');


--
-- TOC entry 2171 (class 0 OID 970226)
-- Dependencies: 197
-- Data for Name: tac_extensiones_sedes; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_extensiones_sedes VALUES (1, 'Extensión el Tigre', 2);
INSERT INTO public.tac_extensiones_sedes VALUES (2, 'Extensión Guasgualito', 3);
INSERT INTO public.tac_extensiones_sedes VALUES (3, 'Extensión Puerto Ordaz', 6);
INSERT INTO public.tac_extensiones_sedes VALUES (4, 'Extensión Puerto Cabello', 7);
INSERT INTO public.tac_extensiones_sedes VALUES (5, 'Sede Central', 10);
INSERT INTO public.tac_extensiones_sedes VALUES (6, 'Extensión Centro', 10);
INSERT INTO public.tac_extensiones_sedes VALUES (7, 'Extensión Tucacas', 11);
INSERT INTO public.tac_extensiones_sedes VALUES (8, 'Extensión Punto Fijo', 11);
INSERT INTO public.tac_extensiones_sedes VALUES (9, 'Extensión Calabozo', 12);
INSERT INTO public.tac_extensiones_sedes VALUES (10, 'Extensión Valle de la Pascua', 12);
INSERT INTO public.tac_extensiones_sedes VALUES (11, 'Extensión Carora', 13);
INSERT INTO public.tac_extensiones_sedes VALUES (12, 'Extensión Vigía', 14);
INSERT INTO public.tac_extensiones_sedes VALUES (13, 'Extensión Guarenas-Guatire', 15);
INSERT INTO public.tac_extensiones_sedes VALUES (14, 'Extensión Valle del Tuy', 15);
INSERT INTO public.tac_extensiones_sedes VALUES (15, 'Extensión Acarigua', 18);
INSERT INTO public.tac_extensiones_sedes VALUES (16, 'Extensión Carúpano', 19);
INSERT INTO public.tac_extensiones_sedes VALUES (17, 'Extensión Cabimas', 24);
INSERT INTO public.tac_extensiones_sedes VALUES (18, 'Extensión Santa Bárbara', 24);


--
-- TOC entry 2161 (class 0 OID 527826)
-- Dependencies: 187
-- Data for Name: tac_firmantes; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_firmantes VALUES (1, 'Abg', 'Carmen', 'Marisela', 'Castro', 'Gilly', 'Carmen Marisela Castro Gilly', 'Defensora Pública General', 'Designada mediante Acuerdo de la Asamblea Nacional Constituyente, de fecha 08 de Enero de 2019, publicado en la gaceta oficial de la República Bolivariana de Venezuela N° 41.559, de fecha 06 de enero de 2019.');
INSERT INTO public.tac_firmantes VALUES (3, 'Abg', 'Daniel', 'Augusto', 'Ramirez', 'Herrera', 'Daniel Augusto  Ramirez Herrera', 'Cordinador General  de la Defensa Pública', 'Coordinador General de la Defensa Pública, designado mediante Resolución  DPG-2019-015 de fecha 15 de enero de 2019,

y publicada en la Gaceta Oficial de la República Bolivariana de Venezuela Nº 41.567 de fecha 18 de enero de 2019');


--
-- TOC entry 2159 (class 0 OID 470499)
-- Dependencies: 185
-- Data for Name: tac_juramentados; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_juramentados VALUES (69, 'Angelica', 'Del Pilar', 'Ortega', 'Perez', '18265594', 'Defensor (a) Público Provisorio (a)', 'Dpg-200', 59, '2020-02-18', 14, 12, 3, 41);
INSERT INTO public.tac_juramentados VALUES (70, 'Carlos', 'Eduardo', 'Torrealba', 'Ramirez', '22390662', 'Defensor (a) Público Auxiliar', 'Dpg-200', 59, '2020-02-18', 15, 14, 2, 18);
INSERT INTO public.tac_juramentados VALUES (67, 'Carlos', 'Eduardo', 'Torrealba', 'Ramirez', '22390662', 'Defensor (a) Público Provisorio (a)', 'Dpg-200', 59, '2020-02-18', 16, 0, NULL, NULL);
INSERT INTO public.tac_juramentados VALUES (68, 'Carlos', 'Eduardo', 'Torrealba', 'Ramirez', '22390662', 'Defensor (a) Público Provisorio (a)', 'Dpg-200', 59, '2020-02-13', 10, 5, 1, 10);


--
-- TOC entry 2175 (class 0 OID 994799)
-- Dependencies: 201
-- Data for Name: tac_materias; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_materias VALUES (1, 'de Protección de Niños, Niñas y Adolescentes', 1);
INSERT INTO public.tac_materias VALUES (18, 'para actuar ante la Sala Social (Protección de Niños, Niñas, y Adolescentes, Laboral y Agraria). del Tribunal Supremo de Justicia', 2);
INSERT INTO public.tac_materias VALUES (6, 'Agraria
Defensor Público Auxiliar con competencia en materia Agra', 1);
INSERT INTO public.tac_materias VALUES (8, 'Civil, Mercantil y Transito', 1);
INSERT INTO public.tac_materias VALUES (10, 'Laboral', 1);
INSERT INTO public.tac_materias VALUES (16, 'Indígena', 1);
INSERT INTO public.tac_materias VALUES (21, 'para actuar ante la Sala Civil del Tribunal Supremo de Justicia', 2);
INSERT INTO public.tac_materias VALUES (27, 'para actuar ante la Sala Electoral del Tribunal Supremo de Justicia', 2);
INSERT INTO public.tac_materias VALUES (30, 'para actuar ante la Sala Constitucional del Tribunal Supremo de Justicia', 2);
INSERT INTO public.tac_materias VALUES (32, 'para actuar ante la Sala Plena del Tribunal Supremo de Justicia', 2);
INSERT INTO public.tac_materias VALUES (33, 'Penal Ordinario e Indígena – Fase Proceso', 3);
INSERT INTO public.tac_materias VALUES (35, 'Penal Ordinario -Fase Ejecución', 3);
INSERT INTO public.tac_materias VALUES (37, 'de Responsabilidad Penal del Adolescente', 3);
INSERT INTO public.tac_materias VALUES (39, 'Especial de Delitos de Violencia Contra la Mujer', 3);
INSERT INTO public.tac_materias VALUES (41, 'Penal Municipal', 3);
INSERT INTO public.tac_materias VALUES (14, 'Contencioso Administrativo', 1);
INSERT INTO public.tac_materias VALUES (3, 'Civil y Administrativa Especial Inquilinaria y para la Defensa del Derecho a la Vivienda', 1);
INSERT INTO public.tac_materias VALUES (26, 'para actuar ante la Sala Político Administrativo del Tribunal Supremo de Justicia', 2);
INSERT INTO public.tac_materias VALUES (43, 'Administrativa, Contencioso Administrativo y Penal, para los Funcionarios y Funcionaria Policiales', 3);


--
-- TOC entry 2165 (class 0 OID 577033)
-- Dependencies: 191
-- Data for Name: tac_pre_juramentados; Type: TABLE DATA; Schema: public; Owner: sisdesa
--



--
-- TOC entry 2169 (class 0 OID 970218)
-- Dependencies: 195
-- Data for Name: tac_unidades; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.tac_unidades VALUES (1, 'Unidad Regional de la Defensa Pública del estado Amazonas');
INSERT INTO public.tac_unidades VALUES (2, 'Unidad Regional de la Defensa Pública del estado Anzoátegui');
INSERT INTO public.tac_unidades VALUES (3, 'Unidad Regional de la Defensa Pública del estado Apure');
INSERT INTO public.tac_unidades VALUES (4, 'Unidad Regional de la Defensa Pública del estado Aragua');
INSERT INTO public.tac_unidades VALUES (5, 'Unidad Regional de la Defensa Pública del estado Barinas');
INSERT INTO public.tac_unidades VALUES (6, 'Unidad Regional de la Defensa Pública del estado Bolívar');
INSERT INTO public.tac_unidades VALUES (7, 'Unidad Regional de la Defensa Pública del estado Carabobo');
INSERT INTO public.tac_unidades VALUES (8, 'Unidad Regional de la Defensa Pública del estado Cojedes');
INSERT INTO public.tac_unidades VALUES (9, 'Unidad Regional de la Defensa Pública del estado Delta Amacuro');
INSERT INTO public.tac_unidades VALUES (10, 'Unidad Regional de la Defensa Pública del Área Metropolitana de Caracas');
INSERT INTO public.tac_unidades VALUES (11, 'Unidad Regional de la Defensa Pública del estado Falcón');
INSERT INTO public.tac_unidades VALUES (12, 'Unidad Regional de la Defensa Pública del estado Guárico');
INSERT INTO public.tac_unidades VALUES (13, 'Unidad Regional de la Defensa Pública del estado Lara');
INSERT INTO public.tac_unidades VALUES (14, 'Unidad Regional de la Defensa Pública del estado Mérida');
INSERT INTO public.tac_unidades VALUES (15, 'Unidad Regional de la Defensa Pública del estado Miranda');
INSERT INTO public.tac_unidades VALUES (16, 'Unidad Regional de la Defensa Pública del estado Monágas');
INSERT INTO public.tac_unidades VALUES (17, 'Unidad Regional de la Defensa Pública del estado Nueva Esparta');
INSERT INTO public.tac_unidades VALUES (18, 'Unidad Regional de la Defensa Pública del estado Portuguesa');
INSERT INTO public.tac_unidades VALUES (19, 'Unidad Regional de la Defensa Pública del estado Sucre');
INSERT INTO public.tac_unidades VALUES (20, 'Unidad Regional de la Defensa Pública del estado Táchira');
INSERT INTO public.tac_unidades VALUES (21, 'Unidad Regional de la Defensa Pública del estado Trujillo');
INSERT INTO public.tac_unidades VALUES (22, 'Unidad Regional de la Defensa Pública del estado La Guaira');
INSERT INTO public.tac_unidades VALUES (23, 'Unidad Regional de la Defensa Pública del estado Yaracuy');
INSERT INTO public.tac_unidades VALUES (24, 'Unidad Regional de la Defensa Pública del estado Zulia');


--
-- TOC entry 2153 (class 0 OID 413138)
-- Dependencies: 176
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.users VALUES (1, 'c.torrealba.662@defensapublica.gob.ve', '$2a$11$DZWNNRJ.xEOwQJ5tNWzjLOyXvcYq8kS1evDtn6BKg8.Nt/m4RDG3m', NULL, NULL, NULL, '2019-07-10 14:20:45.612467', '2019-07-10 14:20:45.612467');


--
-- TOC entry 2167 (class 0 OID 716266)
-- Dependencies: 193
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: sisdesa
--

INSERT INTO public.usuarios VALUES (1, 'c.torrealba.662@defensapublica.gob.ve', '$2a$11$DR9AAzgleb.KKsT9I2M4EeZAHzOU69wsVL3doldRSIs.1FNaXSth6', NULL, NULL, NULL, '2019-10-30 16:33:47.145849', '2019-10-30 16:33:47.145849');
INSERT INTO public.usuarios VALUES (2, 'maikin.colmenares@defensapublica.gob.ve', '$2a$11$RuQZf5UCylnTCWOJPMJZJucIB/06dWgfeTJ/3IIK.S/pp/EWirQ36', NULL, NULL, NULL, '2020-01-29 18:32:23.244794', '2020-01-29 18:32:23.244794');


--
-- TOC entry 2197 (class 0 OID 0)
-- Dependencies: 179
-- Name: tac_actas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_actas_id_seq', 60, true);


--
-- TOC entry 2198 (class 0 OID 0)
-- Dependencies: 188
-- Name: tac_cargos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_cargos_id_seq', 2, true);


--
-- TOC entry 2199 (class 0 OID 0)
-- Dependencies: 198
-- Name: tac_competencias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_competencias_id_seq', 3, true);


--
-- TOC entry 2200 (class 0 OID 0)
-- Dependencies: 196
-- Name: tac_extensiones_sedes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_extensiones_sedes_id_seq', 18, true);


--
-- TOC entry 2201 (class 0 OID 0)
-- Dependencies: 186
-- Name: tac_firmantes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_firmantes_id_seq', 4, true);


--
-- TOC entry 2202 (class 0 OID 0)
-- Dependencies: 184
-- Name: tac_juramentados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_juramentados_id_seq', 70, true);


--
-- TOC entry 2203 (class 0 OID 0)
-- Dependencies: 200
-- Name: tac_materias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_materias_id_seq', 44, true);


--
-- TOC entry 2204 (class 0 OID 0)
-- Dependencies: 190
-- Name: tac_pre_juramentados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_pre_juramentados_id_seq', 75, true);


--
-- TOC entry 2205 (class 0 OID 0)
-- Dependencies: 194
-- Name: tac_unidades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.tac_unidades_id_seq', 24, true);


--
-- TOC entry 2206 (class 0 OID 0)
-- Dependencies: 175
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- TOC entry 2207 (class 0 OID 0)
-- Dependencies: 192
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sisdesa
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 2, true);


--
-- TOC entry 2012 (class 2606 OID 413166)
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- TOC entry 2010 (class 2606 OID 413158)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 2014 (class 2606 OID 593365)
-- Name: tac_actas tac_actas_numero_acta_key; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_actas
    ADD CONSTRAINT tac_actas_numero_acta_key UNIQUE (numero_acta);


--
-- TOC entry 2016 (class 2606 OID 445910)
-- Name: tac_actas tac_actas_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_actas
    ADD CONSTRAINT tac_actas_pkey PRIMARY KEY (id);


--
-- TOC entry 2022 (class 2606 OID 536026)
-- Name: tac_cargos tac_cargos_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_cargos
    ADD CONSTRAINT tac_cargos_pkey PRIMARY KEY (id);


--
-- TOC entry 2034 (class 2606 OID 994796)
-- Name: tac_competencias tac_competencias_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_competencias
    ADD CONSTRAINT tac_competencias_pkey PRIMARY KEY (id);


--
-- TOC entry 2032 (class 2606 OID 970231)
-- Name: tac_extensiones_sedes tac_extensiones_sedes_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_extensiones_sedes
    ADD CONSTRAINT tac_extensiones_sedes_pkey PRIMARY KEY (id);


--
-- TOC entry 2020 (class 2606 OID 527834)
-- Name: tac_firmantes tac_firmantes_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_firmantes
    ADD CONSTRAINT tac_firmantes_pkey PRIMARY KEY (id);


--
-- TOC entry 2018 (class 2606 OID 470508)
-- Name: tac_juramentados tac_juramentados_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_juramentados
    ADD CONSTRAINT tac_juramentados_pkey PRIMARY KEY (id);


--
-- TOC entry 2036 (class 2606 OID 994804)
-- Name: tac_materias tac_materias_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_materias
    ADD CONSTRAINT tac_materias_pkey PRIMARY KEY (id);


--
-- TOC entry 2024 (class 2606 OID 577041)
-- Name: tac_pre_juramentados tac_pre_juramentados_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_pre_juramentados
    ADD CONSTRAINT tac_pre_juramentados_pkey PRIMARY KEY (id);


--
-- TOC entry 2030 (class 2606 OID 970223)
-- Name: tac_unidades tac_unidades_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_unidades
    ADD CONSTRAINT tac_unidades_pkey PRIMARY KEY (id);


--
-- TOC entry 2008 (class 2606 OID 413148)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2028 (class 2606 OID 716276)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 2005 (class 1259 OID 413149)
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: sisdesa
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- TOC entry 2006 (class 1259 OID 413150)
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: sisdesa
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- TOC entry 2025 (class 1259 OID 716277)
-- Name: index_usuarios_on_email; Type: INDEX; Schema: public; Owner: sisdesa
--

CREATE UNIQUE INDEX index_usuarios_on_email ON public.usuarios USING btree (email);


--
-- TOC entry 2026 (class 1259 OID 716278)
-- Name: index_usuarios_on_reset_password_token; Type: INDEX; Schema: public; Owner: sisdesa
--

CREATE UNIQUE INDEX index_usuarios_on_reset_password_token ON public.usuarios USING btree (reset_password_token);


--
-- TOC entry 2042 (class 2620 OID 642515)
-- Name: tac_actas before_ins_tac_actas; Type: TRIGGER; Schema: public; Owner: sisdesa
--

CREATE TRIGGER before_ins_tac_actas BEFORE INSERT ON public.tac_actas FOR EACH ROW EXECUTE PROCEDURE public.gac_before_ins_tac_actas();


--
-- TOC entry 2037 (class 2606 OID 675289)
-- Name: tac_actas tac_actas_id_firmante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_actas
    ADD CONSTRAINT tac_actas_id_firmante_fkey FOREIGN KEY (tac_firmante_id) REFERENCES public.tac_firmantes(id);


--
-- TOC entry 2040 (class 2606 OID 970232)
-- Name: tac_extensiones_sedes tac_extensiones_sedes_tac_unidades_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_extensiones_sedes
    ADD CONSTRAINT tac_extensiones_sedes_tac_unidades_id_fkey FOREIGN KEY (tac_unidade_id) REFERENCES public.tac_unidades(id);


--
-- TOC entry 2038 (class 2606 OID 749017)
-- Name: tac_juramentados tac_juramentados_tac_acta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_juramentados
    ADD CONSTRAINT tac_juramentados_tac_acta_id_fkey FOREIGN KEY (tac_acta_id) REFERENCES public.tac_actas(id);


--
-- TOC entry 2041 (class 2606 OID 994805)
-- Name: tac_materias tac_materias_tac_competencias_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_materias
    ADD CONSTRAINT tac_materias_tac_competencias_id_fkey FOREIGN KEY (tac_competencia_id) REFERENCES public.tac_competencias(id);


--
-- TOC entry 2039 (class 2606 OID 642566)
-- Name: tac_pre_juramentados tac_pre_juramentados_id_numero_acta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sisdesa
--

ALTER TABLE ONLY public.tac_pre_juramentados
    ADD CONSTRAINT tac_pre_juramentados_id_numero_acta_fkey FOREIGN KEY (id_numero_acta) REFERENCES public.tac_actas(numero_acta);


--
-- TOC entry 2181 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2020-02-20 14:17:29 -04

--
-- PostgreSQL database dump complete
--

