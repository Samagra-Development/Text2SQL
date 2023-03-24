--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.19
-- Dumped by pg_dump version 15.1

-- Started on 2023-02-18 12:40:11 IST

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
-- TOC entry 8 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 5100 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 589 (class 1259 OID 277987391)
-- Name: sa_school_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sa_school_evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sa_school_evaluations_id_seq OWNER TO postgres;

SET default_tablespace = '';

--
-- TOC entry 588 (class 1259 OID 277987382)
-- Name: sa_school_evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sa_school_evaluations (
    id integer DEFAULT nextval('public.sa_school_evaluations_id_seq'::regclass) NOT NULL,
    school_id integer NOT NULL,
    evaluation_status boolean DEFAULT false NOT NULL,
    team_id integer NOT NULL,
    evaluation_date date NOT NULL,
    evaluator_ids character varying[],
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    nipun_status character varying DEFAULT 'PENDING'::character varying NOT NULL
);


ALTER TABLE public.sa_school_evaluations OWNER TO postgres;

--
-- TOC entry 702 (class 1255 OID 277987411)
-- Name: is_monitor_tracking_populated(public.sa_school_evaluations); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_monitor_tracking_populated(r public.sa_school_evaluations) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  select exists(select * from monitortracking where "schoolId"::int4 = r.school_id and "scheduleVisitDate" = r.evaluation_date and exists (select * from sa_team_evaluators where team_id = r.team_id and evaluator_id = "monitorId"))
$$;


ALTER FUNCTION public.is_monitor_tracking_populated(r public.sa_school_evaluations) OWNER TO postgres;

--
-- TOC entry 704 (class 1255 OID 21189852)
-- Name: set_current_timestamp_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;


ALTER FUNCTION public.set_current_timestamp_updated_at() OWNER TO postgres;

--
-- TOC entry 547 (class 1259 OID 252090402)
-- Name: Cluster_Wise_Data_2022; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Cluster_Wise_Data_2022" (
    district character varying(1000),
    block character varying(1000),
    cluster character varying(1000),
    school character varying(1000),
    udise character varying(1000)
);


ALTER TABLE public."Cluster_Wise_Data_2022" OWNER TO postgres;

CREATE TABLE public."LO_info" (
    assessment_id bigint,
    lobundle_id bigint,
    lo_code text,
    lo_name text,
    lo_subject text,
    subject_assessment text
);


ALTER TABLE public."LO_info" OWNER TO postgres;

--
-- TOC entry 333 (class 1259 OID 37713274)
-- Name: mystudent_testperformance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mystudent_testperformance (
    id integer,
    student_name character varying,
    stream character varying(255) DEFAULT '-'::character varying,
    udise integer,
    mobile character varying(255),
    school_name character varying(255),
    district character varying(255),
    block character varying(255),
    week integer,
    subject character varying(255),
    grade character varying(255),
    score integer,
    completed integer,
    p_key integer NOT NULL
);


ALTER TABLE public.mystudent_testperformance OWNER TO postgres;

CREATE TABLE public.stream (
    id integer NOT NULL,
    tag character varying(25),
    total_subjects integer NOT NULL,
    total_subjects_opt_1 integer NOT NULL,
    total_subjects_opt_2 integer NOT NULL,
    total_subjects_opt_3 integer NOT NULL,
    total_subjects_opt_4 integer NOT NULL,
    grade_number integer
);


ALTER TABLE public.stream OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 33200)
-- Name: Stream_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Stream_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Stream_id_seq" OWNER TO postgres;

--
-- TOC entry 5102 (class 0 OID 0)
-- Dependencies: 252
-- Name: Stream_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Stream_id_seq" OWNED BY public.stream.id;


--
-- TOC entry 251 (class 1259 OID 33194)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id integer NOT NULL,
    name character varying(100),
    section character varying(1) NOT NULL,
    grade_number integer NOT NULL,
    phone bigint,
    roll integer,
    father_name character varying(300),
    mother_name character varying(300),
    gender character varying(1) NOT NULL,
    school_id integer,
    category character varying(2) NOT NULL,
    is_cwsn boolean NOT NULL,
    admission_number integer,
    is_enabled boolean NOT NULL,
    previous_acad_year character varying(9) NOT NULL,
    previous_grade integer,
    grade_year_mapping character varying(20)[],
    created timestamp with time zone,
    updated timestamp with time zone,
    stream_tag character varying(50),
    aadhar character varying(12),
    academic_year text,
    disability_type text,
    dob date,
    email text,
    enrollment_type character varying(30),
    image text,
    is_bpl boolean,
    is_migrant boolean,
    medium text,
    ref_student_id text,
    religion character varying(20),
    student_status character varying(30),
    student_unique_id character varying(10)
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 33192)
-- Name: Student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Student_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Student_id_seq" OWNER TO postgres;

--
-- TOC entry 5103 (class 0 OID 0)
-- Dependencies: 250
-- Name: Student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Student_id_seq" OWNED BY public.student.id;


--
-- TOC entry 340 (class 1259 OID 37713598)
-- Name: cg_hp_teacher_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cg_hp_teacher_data (
    mobile character varying DEFAULT '-'::character varying,
    medium character varying(2) DEFAULT '-'::character varying,
    "UDISE" integer,
    name character varying DEFAULT '-'::character varying,
    block character varying DEFAULT '-'::character varying,
    district character varying DEFAULT '-'::character varying,
    school character varying DEFAULT '-'::character varying
);


ALTER TABLE public.cg_hp_teacher_data OWNER TO postgres;

CREATE TABLE public.school (
    id integer NOT NULL,
    udise integer NOT NULL,
    name character varying(250),
    type character varying(4) NOT NULL,
    session character varying(1) NOT NULL,
    location_id integer,
    enroll_count integer,
    is_active boolean NOT NULL,
    latitude double precision,
    longitude double precision
);


ALTER TABLE public.school OWNER TO postgres;

CREATE TABLE public.assessment (
    id integer NOT NULL,
    type character varying(8) NOT NULL,
    start timestamp with time zone,
    "end" timestamp with time zone,
    deadline_id integer,
    submission_type character varying(8),
    is_final boolean NOT NULL,
    is_enabled boolean,
    evaluation_params character varying(20),
    sms_template character varying(255),
    submission_type_v2_id integer,
    type_v2_id integer,
    builder_id integer,
    mapping_id integer,
    created timestamp with time zone,
    updated timestamp with time zone,
    overall_pass_percentage double precision,
    overall_total_marks integer
);


ALTER TABLE public.assessment OWNER TO postgres;

--
-- TOC entry 380 (class 1259 OID 154025412)
-- Name: assessment_au_lo_aggregate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_au_lo_aggregate (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    los_id integer NOT NULL
);


ALTER TABLE public.assessment_au_lo_aggregate OWNER TO postgres;

--
-- TOC entry 379 (class 1259 OID 154025410)
-- Name: assessment_au_lo_aggregate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_au_lo_aggregate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_au_lo_aggregate_id_seq OWNER TO postgres;

--
-- TOC entry 5104 (class 0 OID 0)
-- Dependencies: 379
-- Name: assessment_au_lo_aggregate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_au_lo_aggregate_id_seq OWNED BY public.assessment_au_lo_aggregate.id;


--
-- TOC entry 406 (class 1259 OID 154025531)
-- Name: assessment_au_lo_aggregate_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_au_lo_aggregate_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    students_cleared integer NOT NULL,
    assessment_id integer NOT NULL,
    grade_id integer NOT NULL,
    lo_id integer NOT NULL,
    school_id integer
);


ALTER TABLE public.assessment_au_lo_aggregate_submission OWNER TO postgres;

--
-- TOC entry 405 (class 1259 OID 154025529)
-- Name: assessment_au_lo_aggregate_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_au_lo_aggregate_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_au_lo_aggregate_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5105 (class 0 OID 0)
-- Dependencies: 405
-- Name: assessment_au_lo_aggregate_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_au_lo_aggregate_submission_id_seq OWNED BY public.assessment_au_lo_aggregate_submission.id;


--
-- TOC entry 404 (class 1259 OID 154025523)
-- Name: assessment_au_question_aggregate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_au_question_aggregate (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    question_id integer
);


ALTER TABLE public.assessment_au_question_aggregate OWNER TO postgres;

--
-- TOC entry 403 (class 1259 OID 154025521)
-- Name: assessment_au_question_aggregate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_au_question_aggregate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_au_question_aggregate_id_seq OWNER TO postgres;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 403
-- Name: assessment_au_question_aggregate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_au_question_aggregate_id_seq OWNED BY public.assessment_au_question_aggregate.id;


--
-- TOC entry 402 (class 1259 OID 154025515)
-- Name: assessment_au_question_aggregate_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_au_question_aggregate_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    students_cleared integer NOT NULL,
    assessment_id integer NOT NULL,
    grade_id integer NOT NULL,
    question_id integer NOT NULL,
    school_id integer
);


ALTER TABLE public.assessment_au_question_aggregate_submission OWNER TO postgres;

--
-- TOC entry 401 (class 1259 OID 154025513)
-- Name: assessment_au_question_aggregate_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_au_question_aggregate_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_au_question_aggregate_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 401
-- Name: assessment_au_question_aggregate_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_au_question_aggregate_submission_id_seq OWNED BY public.assessment_au_question_aggregate_submission.id;


--
-- TOC entry 488 (class 1259 OID 162820759)
-- Name: assessment_builder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_builder (
    id integer NOT NULL,
    xml_string text NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.assessment_builder OWNER TO postgres;

--
-- TOC entry 487 (class 1259 OID 162820757)
-- Name: assessment_builder_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_builder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_builder_id_seq OWNER TO postgres;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 487
-- Name: assessment_builder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_builder_id_seq OWNED BY public.assessment_builder.id;


--
-- TOC entry 354 (class 1259 OID 37714302)
-- Name: assessment_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_cache (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    assessment_id integer,
    school_id integer,
    class_progress jsonb,
    subject_progress jsonb,
    submission_data jsonb,
    los_data jsonb
);


ALTER TABLE public.assessment_cache OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 37714300)
-- Name: assessment_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_cache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_cache_id_seq OWNER TO postgres;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 353
-- Name: assessment_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_cache_id_seq OWNED BY public.assessment_cache.id;


--
-- TOC entry 519 (class 1259 OID 163512753)
-- Name: assessment_cache_v5; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_cache_v5 (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    class_submission_data jsonb,
    student_submission_data jsonb,
    meta_data jsonb,
    assessment_id integer NOT NULL,
    school_id integer NOT NULL,
    meta_data_byte bytea
);


ALTER TABLE public.assessment_cache_v5 OWNER TO postgres;

--
-- TOC entry 518 (class 1259 OID 163512751)
-- Name: assessment_cache_v5_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_cache_v5_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_cache_v5_id_seq OWNER TO postgres;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 518
-- Name: assessment_cache_v5_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_cache_v5_id_seq OWNED BY public.assessment_cache_v5.id;


--
-- TOC entry 448 (class 1259 OID 162820436)
-- Name: assessment_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_category (
    id integer NOT NULL,
    "desc" character varying(50),
    abbreviation character varying(15),
    name character varying(50) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.assessment_category OWNER TO postgres;

--
-- TOC entry 447 (class 1259 OID 162820434)
-- Name: assessment_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_category_id_seq OWNER TO postgres;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 447
-- Name: assessment_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_category_id_seq OWNED BY public.assessment_category.id;


--
-- TOC entry 191 (class 1259 OID 24887)
-- Name: assessment_classes_mapping_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_classes_mapping_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_classes_mapping_index_seq OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 33150)
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    id integer NOT NULL,
    district character varying(17) NOT NULL,
    block character varying(50),
    cluster character varying(50)
);


ALTER TABLE public.location OWNER TO postgres;

CREATE TABLE public.grade_assessment (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    form_id uuid NOT NULL,
    grade_number integer NOT NULL,
    signature character varying(250),
    assessment_id integer,
    school_id integer,
    section character varying(1) NOT NULL,
    streams_id integer
);


ALTER TABLE public.grade_assessment OWNER TO postgres;

CREATE TABLE public.assessment_components (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    components_id integer NOT NULL
);


ALTER TABLE public.assessment_components OWNER TO postgres;

--
-- TOC entry 479 (class 1259 OID 162820571)
-- Name: assessment_components_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_components_id_seq OWNER TO postgres;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 479
-- Name: assessment_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_components_id_seq OWNED BY public.assessment_components.id;


--
-- TOC entry 192 (class 1259 OID 24899)
-- Name: assessment_deadline_mapping_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_deadline_mapping_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_deadline_mapping_index_seq OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 154025420)
-- Name: assessment_ep_grade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_ep_grade (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    is_sms_enabled boolean NOT NULL,
    sms_template_id uuid,
    assessment_id integer NOT NULL,
    grade_mapping_id integer
);


ALTER TABLE public.assessment_ep_grade OWNER TO postgres;

--
-- TOC entry 381 (class 1259 OID 154025418)
-- Name: assessment_ep_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_ep_grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_ep_grade_id_seq OWNER TO postgres;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 381
-- Name: assessment_ep_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_ep_grade_id_seq OWNED BY public.assessment_ep_grade.id;


--
-- TOC entry 400 (class 1259 OID 154025507)
-- Name: assessment_ep_grade_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_ep_grade_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_grade character varying(1) NOT NULL,
    assessment_id integer NOT NULL,
    form_id integer,
    grade_id integer,
    sms_id integer,
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    school_id integer
);


ALTER TABLE public.assessment_ep_grade_submission OWNER TO postgres;

--
-- TOC entry 399 (class 1259 OID 154025505)
-- Name: assessment_ep_grade_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_ep_grade_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_ep_grade_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 399
-- Name: assessment_ep_grade_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_ep_grade_submission_id_seq OWNED BY public.assessment_ep_grade_submission.id;


--
-- TOC entry 384 (class 1259 OID 154025428)
-- Name: assessment_ep_marks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_ep_marks (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    is_sms_enabled boolean NOT NULL,
    sms_template_id uuid,
    max_marks integer NOT NULL,
    pass_percentage double precision NOT NULL,
    assessment_id integer NOT NULL,
    max_marks_range_id integer
);


ALTER TABLE public.assessment_ep_marks OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 154025426)
-- Name: assessment_ep_marks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_ep_marks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_ep_marks_id_seq OWNER TO postgres;

--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 383
-- Name: assessment_ep_marks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_ep_marks_id_seq OWNED BY public.assessment_ep_marks.id;


--
-- TOC entry 398 (class 1259 OID 154025499)
-- Name: assessment_ep_marks_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_ep_marks_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    marks double precision NOT NULL,
    assessment_id integer NOT NULL,
    form_id integer,
    grade_id integer,
    sms_id integer,
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    school_id integer
);


ALTER TABLE public.assessment_ep_marks_submission OWNER TO postgres;

--
-- TOC entry 397 (class 1259 OID 154025497)
-- Name: assessment_ep_marks_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_ep_marks_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_ep_marks_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 397
-- Name: assessment_ep_marks_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_ep_marks_submission_id_seq OWNED BY public.assessment_ep_marks_submission.id;


--
-- TOC entry 263 (class 1259 OID 33258)
-- Name: assessment_grade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_grade (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    grade_id integer NOT NULL
);


ALTER TABLE public.assessment_grade OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 33256)
-- Name: assessment_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_grade_id_seq OWNER TO postgres;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 262
-- Name: assessment_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_grade_id_seq OWNED BY public.assessment_grade.id;


--
-- TOC entry 386 (class 1259 OID 154025436)
-- Name: assessment_grade_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_grade_mapping (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    mapping jsonb NOT NULL
);


ALTER TABLE public.assessment_grade_mapping OWNER TO postgres;

--
-- TOC entry 385 (class 1259 OID 154025434)
-- Name: assessment_grade_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_grade_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_grade_mapping_id_seq OWNER TO postgres;

--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 385
-- Name: assessment_grade_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_grade_mapping_id_seq OWNED BY public.assessment_grade_mapping.id;


--
-- TOC entry 230 (class 1259 OID 33103)
-- Name: assessment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_id_seq OWNER TO postgres;

--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 230
-- Name: assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_id_seq OWNED BY public.assessment.id;


--
-- TOC entry 190 (class 1259 OID 24858)
-- Name: assessment_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_index_seq OWNER TO postgres;

--
-- TOC entry 482 (class 1259 OID 162820581)
-- Name: assessment_lo_bundles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_lo_bundles (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    lobundle_id integer NOT NULL
);


ALTER TABLE public.assessment_lo_bundles OWNER TO postgres;

--
-- TOC entry 481 (class 1259 OID 162820579)
-- Name: assessment_lo_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_lo_bundles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_lo_bundles_id_seq OWNER TO postgres;

--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 481
-- Name: assessment_lo_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_lo_bundles_id_seq OWNED BY public.assessment_lo_bundles.id;


--
-- TOC entry 193 (class 1259 OID 24935)
-- Name: assessment_master_assessment_code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_master_assessment_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_master_assessment_code_seq OWNER TO postgres;

--
-- TOC entry 484 (class 1259 OID 162820589)
-- Name: assessment_question_bundles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_question_bundles (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    questionbundle_id integer NOT NULL
);


ALTER TABLE public.assessment_question_bundles OWNER TO postgres;

--
-- TOC entry 483 (class 1259 OID 162820587)
-- Name: assessment_question_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_question_bundles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_question_bundles_id_seq OWNER TO postgres;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 483
-- Name: assessment_question_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_question_bundles_id_seq OWNED BY public.assessment_question_bundles.id;


--
-- TOC entry 546 (class 1259 OID 250061035)
-- Name: assessment_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_result (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    grade integer,
    student_id integer,
    section text,
    subject text,
    module_results text,
    status integer,
    school_id integer,
    student_name text,
    evaluator integer,
    last_test_grade integer,
    last_test_competency text,
    last_test_achievement integer,
    evaluated_by text
);


ALTER TABLE public.assessment_result OWNER TO postgres;

--
-- TOC entry 545 (class 1259 OID 250061033)
-- Name: assessment_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_result_id_seq OWNER TO postgres;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 545
-- Name: assessment_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_result_id_seq OWNED BY public.assessment_result.id;


--
-- TOC entry 551 (class 1259 OID 256741383)
-- Name: assessment_result_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.assessment_result_view AS
 SELECT t1.id,
    t1.created_at,
    t1.grade,
    t1.student_id,
    t1.section,
    t1.subject,
    t1.module_results,
    t1.status,
    t1.school_id,
    t1.student_name,
    t1.evaluator
   FROM (public.assessment_result t1
     LEFT JOIN public.assessment_result t2 ON (((t2.grade = t1.grade) AND (t2.student_id = t1.student_id) AND (t2.grade = t1.grade) AND (t2.school_id = t1.school_id) AND (t2.section = t1.section) AND (t2.subject = t1.subject) AND (t2.created_at > t1.created_at))));


ALTER TABLE public.assessment_result_view OWNER TO postgres;

--
-- TOC entry 552 (class 1259 OID 256744757)
-- Name: assessment_result_view1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.assessment_result_view1 AS
 SELECT t1.id,
    t1.created_at,
    t1.grade,
    t1.student_id,
    t1.section,
    t1.subject,
    t1.module_results,
    t1.status,
    t1.school_id,
    t1.student_name,
    t1.evaluator
   FROM (public.assessment_result t1
     LEFT JOIN public.assessment_result t2 ON (((t2.grade = t1.grade) AND (t2.student_id = t1.student_id) AND (t2.grade = t1.grade) AND (t2.school_id = t1.school_id) AND (t2.section = t1.section) AND (t2.subject = t1.subject) AND (t2.created_at > t1.created_at))));


ALTER TABLE public.assessment_result_view1 OWNER TO postgres;

--
-- TOC entry 496 (class 1259 OID 162820805)
-- Name: component_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_submission (
    id integer NOT NULL,
    assessment_percent double precision,
    is_present boolean NOT NULL,
    assessment_id integer,
    component_id integer,
    school_id integer,
    subject_id integer,
    assessment_marks double precision
);


ALTER TABLE public.component_submission OWNER TO postgres;

--
-- TOC entry 510 (class 1259 OID 162821684)
-- Name: student_submission_v2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_submission_v2 (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    grade_id integer,
    school_id integer,
    stream_id integer,
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    assessment_unit_id integer,
    grade_submissions_id integer
);


ALTER TABLE public.student_submission_v2 OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 33176)
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject (
    id integer NOT NULL,
    name character varying(100),
    grade_number integer NOT NULL
);


ALTER TABLE public.subject OWNER TO postgres;


CREATE TABLE public.assessment_stream (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    stream_id integer NOT NULL
);


ALTER TABLE public.assessment_stream OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 31837296)
-- Name: assessment_stream_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_stream_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_stream_id_seq OWNER TO postgres;

--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 320
-- Name: assessment_stream_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_stream_id_seq OWNED BY public.assessment_stream.id;


--
-- TOC entry 514 (class 1259 OID 162821980)
-- Name: assessment_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_subjects (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.assessment_subjects OWNER TO postgres;

--
-- TOC entry 513 (class 1259 OID 162821978)
-- Name: assessment_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_subject_id_seq OWNER TO postgres;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 513
-- Name: assessment_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_subject_id_seq OWNED BY public.assessment_subjects.id;


--
-- TOC entry 478 (class 1259 OID 162820565)
-- Name: assessment_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_type (
    id integer NOT NULL,
    "desc" character varying(50),
    abbreviation_old character varying(15),
    name character varying(50) NOT NULL,
    category_id integer,
    created timestamp with time zone,
    updated timestamp with time zone,
    abbreviation character varying(15)
);


ALTER TABLE public.assessment_type OWNER TO postgres;

--
-- TOC entry 477 (class 1259 OID 162820563)
-- Name: assessment_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_type_id_seq OWNER TO postgres;

--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 477
-- Name: assessment_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_type_id_seq OWNED BY public.assessment_type.id;


--
-- TOC entry 500 (class 1259 OID 162820821)
-- Name: assessment_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_unit (
    id integer NOT NULL,
    assessment_id integer,
    school_id integer,
    subject_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.assessment_unit OWNER TO postgres;

--
-- TOC entry 486 (class 1259 OID 162820597)
-- Name: assessment_unit_bundles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_unit_bundles (
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    unitbundle_id integer NOT NULL
);


ALTER TABLE public.assessment_unit_bundles OWNER TO postgres;

--
-- TOC entry 485 (class 1259 OID 162820595)
-- Name: assessment_unit_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_unit_bundles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_unit_bundles_id_seq OWNER TO postgres;

--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 485
-- Name: assessment_unit_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_unit_bundles_id_seq OWNED BY public.assessment_unit_bundles.id;


--
-- TOC entry 499 (class 1259 OID 162820819)
-- Name: assessment_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_unit_id_seq OWNER TO postgres;

--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 499
-- Name: assessment_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_unit_id_seq OWNED BY public.assessment_unit.id;


--
-- TOC entry 502 (class 1259 OID 162820829)
-- Name: assessment_unit_selected_lo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_unit_selected_lo (
    id integer NOT NULL,
    assessmentunit_id integer NOT NULL,
    lo_v2_id integer NOT NULL
);


ALTER TABLE public.assessment_unit_selected_lo OWNER TO postgres;

--
-- TOC entry 501 (class 1259 OID 162820827)
-- Name: assessment_unit_selected_lo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_unit_selected_lo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_unit_selected_lo_id_seq OWNER TO postgres;

--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 501
-- Name: assessment_unit_selected_lo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_unit_selected_lo_id_seq OWNED BY public.assessment_unit_selected_lo.id;


--
-- TOC entry 504 (class 1259 OID 162820837)
-- Name: assessment_unit_selected_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_unit_selected_question (
    id integer NOT NULL,
    assessmentunit_id integer NOT NULL,
    question_v2_id integer NOT NULL
);


ALTER TABLE public.assessment_unit_selected_question OWNER TO postgres;

--
-- TOC entry 503 (class 1259 OID 162820835)
-- Name: assessment_unit_selected_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_unit_selected_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_unit_selected_question_id_seq OWNER TO postgres;

--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 503
-- Name: assessment_unit_selected_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_unit_selected_question_id_seq OWNED BY public.assessment_unit_selected_question.id;


--
-- TOC entry 506 (class 1259 OID 162820845)
-- Name: assessment_unit_selected_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assessment_unit_selected_unit (
    id integer NOT NULL,
    assessmentunit_id integer NOT NULL,
    unit_v2_id integer NOT NULL
);


ALTER TABLE public.assessment_unit_selected_unit OWNER TO postgres;

--
-- TOC entry 505 (class 1259 OID 162820843)
-- Name: assessment_unit_selected_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assessment_unit_selected_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assessment_unit_selected_unit_id_seq OWNER TO postgres;

--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 505
-- Name: assessment_unit_selected_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assessment_unit_selected_unit_id_seq OWNED BY public.assessment_unit_selected_unit.id;


--
-- TOC entry 450 (class 1259 OID 162820444)
-- Name: component_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_type (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.component_type OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 33121)
-- Name: grade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grade (
    id integer NOT NULL,
    number integer NOT NULL,
    section character varying(1) NOT NULL,
    stream_id integer
);


ALTER TABLE public.grade OWNER TO postgres;

--
-- TOC entry 512 (class 1259 OID 162821692)
-- Name: student_submission_v2_marks_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_submission_v2_marks_submissions (
    id integer NOT NULL,
    studentsubmission_v2_id integer NOT NULL,
    componentsubmission_id integer NOT NULL
);


ALTER TABLE public.student_submission_v2_marks_submissions OWNER TO postgres;

CREATE TABLE public.attendance (
    created timestamp with time zone DEFAULT now(),
    updated timestamp with time zone DEFAULT now(),
    id integer NOT NULL,
    date date NOT NULL,
    temperature double precision,
    is_present boolean NOT NULL,
    student_id integer,
    taken_by_school_id integer
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 21223038)
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_id_seq OWNER TO postgres;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 302
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_id_seq OWNED BY public.attendance.id;


CREATE TABLE public.attendance_sms_logs (
    id integer NOT NULL,
    student_id integer NOT NULL,
    sms_type text,
    for_days integer,
    sent_date date
);


ALTER TABLE public.attendance_sms_logs OWNER TO postgres;

--
-- TOC entry 577 (class 1259 OID 277984530)
-- Name: attendance_sms_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_sms_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_sms_logs_id_seq OWNER TO postgres;

--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 577
-- Name: attendance_sms_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_sms_logs_id_seq OWNED BY public.attendance_sms_logs.id;


--
-- TOC entry 527 (class 1259 OID 170512766)
-- Name: attendance_teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_teacher (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    date date,
    is_present boolean,
    udise bigint,
    school_id integer,
    shift_id integer,
    exit_time timestamp with time zone,
    loc_latitude real,
    loc_longitude real,
    allowed_radius real,
    is_under_geofence boolean,
    distance_from_institution real,
    image text,
    teacher_id_mapped bigint,
    status text,
    entry_time timestamp with time zone,
    leave_start_date date,
    leave_end_date date,
    reason text,
    user_id uuid,
    teacher_id text
);


ALTER TABLE public.attendance_teacher OWNER TO postgres;

--
-- TOC entry 526 (class 1259 OID 170512764)
-- Name: attendance_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_teacher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_teacher_id_seq OWNER TO postgres;

--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 526
-- Name: attendance_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_teacher_id_seq OWNED BY public.attendance_teacher.id;


--
-- TOC entry 213 (class 1259 OID 32932)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 32930)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 212
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 215 (class 1259 OID 32942)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 32940)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 214
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 211 (class 1259 OID 32924)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 32922)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 210
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 217 (class 1259 OID 32950)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 32960)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32958)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 218
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 216 (class 1259 OID 32948)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 216
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 221 (class 1259 OID 32968)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 32966)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 220
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;

CREATE TABLE public.cdac_sms_input (
    id integer NOT NULL,
    "mobileNumber" text NOT NULL,
    body text NOT NULL,
    "templateId" text NOT NULL,
    status text DEFAULT 'False'::text NOT NULL
);


ALTER TABLE public.cdac_sms_input OWNER TO postgres;

--
-- TOC entry 537 (class 1259 OID 196048096)
-- Name: cdac_sms_input_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cdac_sms_input_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cdac_sms_input_id_seq OWNER TO postgres;

--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 537
-- Name: cdac_sms_input_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cdac_sms_input_id_seq OWNED BY public.cdac_sms_input.id;


--
-- TOC entry 521 (class 1259 OID 163754467)
-- Name: celery_duplicate_remove; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.celery_duplicate_remove (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    task_type integer NOT NULL,
    status character varying(20) NOT NULL,
    assessment_id integer NOT NULL,
    school_id integer NOT NULL
);


ALTER TABLE public.celery_duplicate_remove OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 37713474)
-- Name: cg_to_state_list; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cg_to_state_list (
    "Grade" integer,
    "Subject" character varying DEFAULT '-'::character varying,
    "State_LO_Code" character varying DEFAULT '-'::character varying,
    "State_LO_Code1" character varying DEFAULT '-'::character varying,
    "CG_LO_Code" character varying DEFAULT '-'::character varying,
    "CG_LO_Statement" character varying DEFAULT '-'::character varying,
    "CG_LO_Topic" character varying DEFAULT '-'::character varying,
    "CG_LO_Description" character varying DEFAULT '-'::character varying
);


ALTER TABLE public.cg_to_state_list OWNER TO postgres;

--
-- TOC entry 498 (class 1259 OID 162820813)
-- Name: class_level_component_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_level_component_submission (
    id integer NOT NULL,
    students_cleared integer NOT NULL,
    total_students_present integer NOT NULL,
    assessment_id integer,
    school_id integer,
    subject_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.class_level_component_submission OWNER TO postgres;

--
-- TOC entry 497 (class 1259 OID 162820811)
-- Name: class_level_component_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.class_level_component_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_level_component_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 497
-- Name: class_level_component_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.class_level_component_submission_id_seq OWNED BY public.class_level_component_submission.id;


--
-- TOC entry 508 (class 1259 OID 162821032)
-- Name: class_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_submission (
    id integer NOT NULL,
    assessment_id integer,
    grade_id integer,
    lo_id integer,
    question_id integer,
    school_id integer,
    subject_id integer,
    submission_id integer,
    unit_id integer,
    created timestamp with time zone,
    updated timestamp with time zone,
    au_type character varying(20)
);


ALTER TABLE public.class_submission OWNER TO postgres;

--
-- TOC entry 507 (class 1259 OID 162821030)
-- Name: class_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.class_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 507
-- Name: class_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.class_submission_id_seq OWNED BY public.class_submission.id;


--
-- TOC entry 194 (class 1259 OID 24952)
-- Name: classes_subject_mapping_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_subject_mapping_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classes_subject_mapping_index_seq OWNER TO postgres;

--
-- TOC entry 474 (class 1259 OID 162820549)
-- Name: component; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component (
    id integer NOT NULL,
    max_marks integer NOT NULL,
    passing_percentage double precision NOT NULL,
    component_type_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.component OWNER TO postgres;

--
-- TOC entry 473 (class 1259 OID 162820547)
-- Name: component_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.component_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.component_id_seq OWNER TO postgres;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 473
-- Name: component_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.component_id_seq OWNED BY public.component.id;


--
-- TOC entry 476 (class 1259 OID 162820557)
-- Name: component_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_subjects (
    id integer NOT NULL,
    components_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.component_subjects OWNER TO postgres;

--
-- TOC entry 475 (class 1259 OID 162820555)
-- Name: component_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.component_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.component_subjects_id_seq OWNER TO postgres;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 475
-- Name: component_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.component_subjects_id_seq OWNED BY public.component_subjects.id;


--
-- TOC entry 495 (class 1259 OID 162820803)
-- Name: component_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.component_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.component_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 495
-- Name: component_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.component_submission_id_seq OWNED BY public.component_submission.id;


--
-- TOC entry 449 (class 1259 OID 162820442)
-- Name: component_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.component_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.component_type_id_seq OWNER TO postgres;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 449
-- Name: component_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.component_type_id_seq OWNED BY public.component_type.id;


--
-- TOC entry 374 (class 1259 OID 153870417)
-- Name: corporate_donor_devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.corporate_donor_devices (
    company_id text,
    device_tracking_key text,
    delivery_status text,
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    recipient_school_id integer,
    recipient_name text,
    recipient_grade integer,
    recipient_student_id text
);


ALTER TABLE public.corporate_donor_devices OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 153870415)
-- Name: corporate_donor_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.corporate_donor_devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.corporate_donor_devices_id_seq OWNER TO postgres;

--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 373
-- Name: corporate_donor_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.corporate_donor_devices_id_seq OWNED BY public.corporate_donor_devices.id;


--
-- TOC entry 441 (class 1259 OID 162402514)
-- Name: dashboard_role_access_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_role_access_config (
    id uuid NOT NULL,
    permission text NOT NULL,
    enable_for_district boolean DEFAULT false NOT NULL,
    enable_for_block boolean DEFAULT false NOT NULL,
    enable_for_state boolean DEFAULT false NOT NULL,
    metabase_link text,
    enable_for_cluster boolean DEFAULT false NOT NULL
);


ALTER TABLE public.dashboard_role_access_config OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 33061)
-- Name: dashboard_userdashboardmodule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_userdashboardmodule (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    module character varying(255) NOT NULL,
    app_label character varying(255),
    "user" integer NOT NULL,
    "column" integer NOT NULL,
    "order" integer NOT NULL,
    settings text NOT NULL,
    children text NOT NULL,
    collapsed boolean NOT NULL,
    CONSTRAINT dashboard_userdashboardmodule_column_check CHECK (("column" >= 0)),
    CONSTRAINT dashboard_userdashboardmodule_user_check CHECK (("user" >= 0))
);


ALTER TABLE public.dashboard_userdashboardmodule OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 33059)
-- Name: dashboard_userdashboardmodule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboard_userdashboardmodule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dashboard_userdashboardmodule_id_seq OWNER TO postgres;

--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 224
-- Name: dashboard_userdashboardmodule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboard_userdashboardmodule_id_seq OWNED BY public.dashboard_userdashboardmodule.id;


--
-- TOC entry 233 (class 1259 OID 33113)
-- Name: deadline; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deadline (
    id integer NOT NULL,
    acad_year character varying(9) NOT NULL,
    date timestamp with time zone NOT NULL,
    district character varying(17) NOT NULL,
    session character varying(1) NOT NULL
);


ALTER TABLE public.deadline OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 33111)
-- Name: deadline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deadline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deadline_id_seq OWNER TO postgres;

--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 232
-- Name: deadline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deadline_id_seq OWNED BY public.deadline.id;


--
-- TOC entry 440 (class 1259 OID 162401968)
-- Name: designation_scope_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.designation_scope_mapping (
    id uuid NOT NULL,
    designation name NOT NULL,
    scope name NOT NULL
);


ALTER TABLE public.designation_scope_mapping OWNER TO postgres;

--
-- TOC entry 363 (class 1259 OID 130745906)
-- Name: device_demand_response; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_demand_response (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name text,
    phone_number text,
    district text,
    block text,
    school_name text,
    total_students integer,
    student_count_no_smartphone integer,
    student_details text,
    pincode text,
    declaration boolean,
    udise integer
);


ALTER TABLE public.device_demand_response OWNER TO postgres;

--
-- TOC entry 362 (class 1259 OID 130745904)
-- Name: device_demand_response_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_demand_response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_demand_response_id_seq OWNER TO postgres;

--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 362
-- Name: device_demand_response_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_demand_response_id_seq OWNED BY public.device_demand_response.id;


--
-- TOC entry 372 (class 1259 OID 153870314)
-- Name: device_donation_corporates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_donation_corporates (
    company_name text,
    poc_name text,
    poc_designation text,
    poc_phone_number text,
    poc_email text,
    delivery_initiated boolean,
    quantity_of_devices integer,
    company_id text NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.device_donation_corporates OWNER TO postgres;

--
-- TOC entry 375 (class 1259 OID 153941492)
-- Name: device_donation_corporates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_donation_corporates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_donation_corporates_id_seq OWNER TO postgres;

--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 375
-- Name: device_donation_corporates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_donation_corporates_id_seq OWNED BY public.device_donation_corporates.id;


--
-- TOC entry 361 (class 1259 OID 118521831)
-- Name: device_donation_donor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_donation_donor (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    name text,
    phone_number text,
    state_ut text,
    district text,
    other_district text,
    address text,
    landmark text,
    pincode text,
    delivery_mode text,
    declaration_acknowledgement text,
    device_company text,
    device_model text,
    device_other_model text,
    device_size text,
    device_condition text,
    call_function boolean,
    wa_function boolean,
    yt_function boolean,
    charger_available boolean,
    device_tracking_key text,
    is_device_received boolean,
    is_device_delivered boolean,
    "delivery_mode_outside_HP" text,
    final_declaration text,
    device_age integer,
    delivery_status text,
    block text,
    recipient_school_id integer,
    recipient_name text,
    recipient_grade integer,
    recipient_student_id text
);


ALTER TABLE public.device_donation_donor OWNER TO postgres;

--
-- TOC entry 360 (class 1259 OID 118521829)
-- Name: device_donation_donor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_donation_donor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_donation_donor_id_seq OWNER TO postgres;

--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 360
-- Name: device_donation_donor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_donation_donor_id_seq OWNED BY public.device_donation_donor.id;


--
-- TOC entry 424 (class 1259 OID 157858333)
-- Name: device_verification_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_verification_records (
    udise integer NOT NULL,
    verifier_name text,
    declaration boolean,
    photograph_url text,
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    transaction_id uuid NOT NULL,
    device_tracking_key_individual text,
    device_tracking_key_corporate text,
    verifier_phone_number text
);


ALTER TABLE public.device_verification_records OWNER TO postgres;

--
-- TOC entry 423 (class 1259 OID 157858331)
-- Name: device_verification_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_verification_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_verification_records_id_seq OWNER TO postgres;

--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 423
-- Name: device_verification_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_verification_records_id_seq OWNED BY public.device_verification_records.id;


--
-- TOC entry 223 (class 1259 OID 33028)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 33026)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 222
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 359 (class 1259 OID 37714523)
-- Name: django_celery_results_chordcounter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_celery_results_chordcounter (
    id integer NOT NULL,
    group_id character varying(255) NOT NULL,
    sub_tasks text NOT NULL,
    count integer NOT NULL,
    CONSTRAINT django_celery_results_chordcounter_count_check CHECK ((count >= 0))
);


ALTER TABLE public.django_celery_results_chordcounter OWNER TO postgres;

--
-- TOC entry 358 (class 1259 OID 37714521)
-- Name: django_celery_results_chordcounter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_celery_results_chordcounter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_results_chordcounter_id_seq OWNER TO postgres;

--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 358
-- Name: django_celery_results_chordcounter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_celery_results_chordcounter_id_seq OWNED BY public.django_celery_results_chordcounter.id;


--
-- TOC entry 523 (class 1259 OID 164149621)
-- Name: django_celery_results_groupresult; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_celery_results_groupresult (
    id integer NOT NULL,
    group_id character varying(255) NOT NULL,
    date_created timestamp with time zone NOT NULL,
    date_done timestamp with time zone NOT NULL,
    content_type character varying(128) NOT NULL,
    content_encoding character varying(64) NOT NULL,
    result text
);


ALTER TABLE public.django_celery_results_groupresult OWNER TO postgres;

--
-- TOC entry 522 (class 1259 OID 164149619)
-- Name: django_celery_results_groupresult_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_celery_results_groupresult_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_results_groupresult_id_seq OWNER TO postgres;

--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 522
-- Name: django_celery_results_groupresult_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_celery_results_groupresult_id_seq OWNED BY public.django_celery_results_groupresult.id;


--
-- TOC entry 357 (class 1259 OID 37714482)
-- Name: django_celery_results_taskresult; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_celery_results_taskresult (
    id integer NOT NULL,
    task_id character varying(255) NOT NULL,
    status character varying(50) NOT NULL,
    content_type character varying(128) NOT NULL,
    content_encoding character varying(64) NOT NULL,
    result text,
    date_done timestamp with time zone NOT NULL,
    traceback text,
    meta text,
    task_args text,
    task_kwargs text,
    task_name character varying(255),
    worker character varying(100),
    date_created timestamp with time zone NOT NULL
);


ALTER TABLE public.django_celery_results_taskresult OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 37714480)
-- Name: django_celery_results_taskresult_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_celery_results_taskresult_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_celery_results_taskresult_id_seq OWNER TO postgres;

--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 356
-- Name: django_celery_results_taskresult_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_celery_results_taskresult_id_seq OWNED BY public.django_celery_results_taskresult.id;


--
-- TOC entry 209 (class 1259 OID 32914)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 32912)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 208
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 207 (class 1259 OID 32903)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 32901)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 206
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 268 (class 1259 OID 33499)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 636 (class 1259 OID 278029835)
-- Name: document; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.document (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    type text NOT NULL,
    document text NOT NULL
);


ALTER TABLE public.document OWNER TO postgres;

--
-- TOC entry 635 (class 1259 OID 278029833)
-- Name: document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.document_id_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 635
-- Name: document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.document_id_seq OWNED BY public.document.id;

CREATE TABLE public.enrollment (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    acad_year character varying(9) NOT NULL,
    grade_number integer NOT NULL,
    section character varying(1) NOT NULL,
    school_id integer,
    student_id integer
);


ALTER TABLE public.enrollment OWNER TO postgres;

--
-- TOC entry 452 (class 1259 OID 162820452)
-- Name: evaluation_param; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluation_param (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    mapping character varying(20) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.evaluation_param OWNER TO postgres;

--
-- TOC entry 451 (class 1259 OID 162820450)
-- Name: evaluation_param_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluation_param_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluation_param_id_seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 451
-- Name: evaluation_param_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluation_param_id_seq OWNED BY public.evaluation_param.id;


--
-- TOC entry 638 (class 1259 OID 278029921)
-- Name: event_trail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_trail (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    status character varying(30),
    year text NOT NULL,
    grade integer NOT NULL,
    section character varying(1) NOT NULL,
    stream character varying(50),
    remakrs text,
    school_id integer,
    student_id integer,
    slc_generated boolean NOT NULL
);


ALTER TABLE public.event_trail OWNER TO postgres;

--
-- TOC entry 640 (class 1259 OID 278029932)
-- Name: event_trail_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_trail_documents (
    id integer NOT NULL,
    studenttrail_id integer NOT NULL,
    documents_id integer NOT NULL
);


ALTER TABLE public.event_trail_documents OWNER TO postgres;

--
-- TOC entry 639 (class 1259 OID 278029930)
-- Name: event_trail_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_trail_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_trail_documents_id_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 639
-- Name: event_trail_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_trail_documents_id_seq OWNED BY public.event_trail_documents.id;


--
-- TOC entry 637 (class 1259 OID 278029919)
-- Name: event_trail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_trail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_trail_id_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 637
-- Name: event_trail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_trail_id_seq OWNED BY public.event_trail.id;

CREATE SEQUENCE public.grade_assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grade_assessment_id_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 236
-- Name: grade_assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grade_assessment_id_seq OWNED BY public.grade_assessment.id;

CREATE SEQUENCE public.grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grade_id_seq OWNER TO postgres;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 234
-- Name: grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grade_id_seq OWNED BY public.grade.id;


--
-- TOC entry 581 (class 1259 OID 277987277)
-- Name: group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."group" (
    "groupId" uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "schoolId" text,
    name text,
    type text,
    section text,
    status text,
    "deactivationReason" text,
    "mediumOfInstruction" text,
    image text,
    "metaData" jsonb,
    option jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    "teacherId" text,
    "gradeLevel" text,
    updated_at timestamp with time zone DEFAULT now(),
    "parentId" uuid
);


ALTER TABLE public."group" OWNER TO postgres;

--
-- TOC entry 582 (class 1259 OID 277987296)
-- Name: groupmembership; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groupmembership (
    "groupMembershipId" uuid NOT NULL,
    "schoolId" text,
    "userId" text,
    role text,
    "groupId" uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text,
    updated_by text,
    status bpchar DEFAULT ''::text NOT NULL
);

CREATE TABLE public.school_wise_daily_enrolment (
    udise integer,
    block text NOT NULL,
    district text NOT NULL,
    students_enrolled integer NOT NULL,
    date date NOT NULL,
    name text,
    id bigint NOT NULL
);


ALTER TABLE public.school_wise_daily_enrolment OWNER TO postgres;

CREATE TABLE public.jet_bookmark (
    id integer NOT NULL,
    url character varying(200) NOT NULL,
    title character varying(255) NOT NULL,
    "user" integer NOT NULL,
    date_add timestamp with time zone NOT NULL,
    CONSTRAINT jet_bookmark_user_check CHECK (("user" >= 0))
);


ALTER TABLE public.jet_bookmark OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 33072)
-- Name: jet_bookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jet_bookmark_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jet_bookmark_id_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 226
-- Name: jet_bookmark_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jet_bookmark_id_seq OWNED BY public.jet_bookmark.id;


--
-- TOC entry 229 (class 1259 OID 33083)
-- Name: jet_pinnedapplication; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jet_pinnedapplication (
    id integer NOT NULL,
    app_label character varying(255) NOT NULL,
    "user" integer NOT NULL,
    date_add timestamp with time zone NOT NULL,
    CONSTRAINT jet_pinnedapplication_user_check CHECK (("user" >= 0))
);


ALTER TABLE public.jet_pinnedapplication OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 33081)
-- Name: jet_pinnedapplication_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jet_pinnedapplication_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jet_pinnedapplication_id_seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 228
-- Name: jet_pinnedapplication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jet_pinnedapplication_id_seq OWNED BY public.jet_pinnedapplication.id;


--
-- TOC entry 239 (class 1259 OID 33139)
-- Name: lo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lo (
    id integer NOT NULL,
    code character varying(8),
    name text NOT NULL,
    grade_number integer NOT NULL,
    subject_id integer,
    is_unit boolean NOT NULL
);


ALTER TABLE public.lo OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 34137)
-- Name: lo_assessment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lo_assessment (
    id integer NOT NULL,
    lo_id integer NOT NULL,
    assessment_id integer NOT NULL
);


ALTER TABLE public.lo_assessment OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 34135)
-- Name: lo_assessment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_assessment_id_seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 269
-- Name: lo_assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lo_assessment_id_seq OWNED BY public.lo_assessment.id;


--
-- TOC entry 196 (class 1259 OID 24988)
-- Name: lo_based_response_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_based_response_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_based_response_index_seq OWNER TO postgres;

--
-- TOC entry 470 (class 1259 OID 162820533)
-- Name: lo_bundle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lo_bundle (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    "desc" character varying(50) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    cache jsonb
);


ALTER TABLE public.lo_bundle OWNER TO postgres;

--
-- TOC entry 469 (class 1259 OID 162820531)
-- Name: lo_bundle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_bundle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_bundle_id_seq OWNER TO postgres;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 469
-- Name: lo_bundle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lo_bundle_id_seq OWNED BY public.lo_bundle.id;


--
-- TOC entry 472 (class 1259 OID 162820541)
-- Name: lo_bundle_los; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lo_bundle_los (
    id integer NOT NULL,
    lobundle_id integer NOT NULL,
    lo_v2_id integer NOT NULL
);


ALTER TABLE public.lo_bundle_los OWNER TO postgres;

--
-- TOC entry 471 (class 1259 OID 162820539)
-- Name: lo_bundle_lo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_bundle_lo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_bundle_lo_id_seq OWNER TO postgres;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 471
-- Name: lo_bundle_lo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lo_bundle_lo_id_seq OWNED BY public.lo_bundle_los.id;


--
-- TOC entry 238 (class 1259 OID 33137)
-- Name: lo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_id_seq OWNER TO postgres;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 238
-- Name: lo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lo_id_seq OWNED BY public.lo.id;


--
-- TOC entry 195 (class 1259 OID 24970)
-- Name: lo_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_index_seq OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 33250)
-- Name: lo_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lo_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    students_cleared integer NOT NULL,
    assessment_id integer NOT NULL,
    lo_id integer NOT NULL,
    school_id integer NOT NULL,
    grade_id integer NOT NULL
);


ALTER TABLE public.lo_submission OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 33248)
-- Name: lo_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 260
-- Name: lo_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lo_submission_id_seq OWNED BY public.lo_submission.id;


--
-- TOC entry 259 (class 1259 OID 33239)
-- Name: question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question (
    id integer NOT NULL,
    statement text NOT NULL,
    cutoff numeric(4,2),
    lo_id integer
);


ALTER TABLE public.question OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 33231)
-- Name: question_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    school_id integer NOT NULL,
    question_id integer NOT NULL,
    students_cleared integer NOT NULL,
    grade_id integer NOT NULL
);


ALTER TABLE public.question_submission OWNER TO postgres;
CREATE TABLE public.student_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_grade character varying(1) NOT NULL,
    grade_number integer NOT NULL,
    assessment_id integer NOT NULL,
    form_id integer,
    sms_id integer,
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    section character varying(1) NOT NULL,
    assessment_percent double precision
);


ALTER TABLE public.student_submission OWNER TO postgres;

CREATE TABLE public.lo_v2 (
    id integer NOT NULL,
    code character varying(8),
    name text NOT NULL,
    grade_number integer NOT NULL,
    is_unit boolean NOT NULL,
    subject_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.lo_v2 OWNER TO postgres;

--
-- TOC entry 453 (class 1259 OID 162820458)
-- Name: lo_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lo_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lo_v2_id_seq OWNER TO postgres;

--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 453
-- Name: lo_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lo_v2_id_seq OWNED BY public.lo_v2.id;


--
-- TOC entry 240 (class 1259 OID 33148)
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_id_seq OWNER TO postgres;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 240
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_id_seq OWNED BY public.location.id;


--
-- TOC entry 494 (class 1259 OID 162820789)
-- Name: mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mapping (
    id integer NOT NULL,
    mapping_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.mapping OWNER TO postgres;

--
-- TOC entry 490 (class 1259 OID 162820770)
-- Name: mapping_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mapping_details (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    mapping_fields jsonb NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.mapping_details OWNER TO postgres;

--
-- TOC entry 489 (class 1259 OID 162820768)
-- Name: mapping_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mapping_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mapping_details_id_seq OWNER TO postgres;

--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 489
-- Name: mapping_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mapping_details_id_seq OWNED BY public.mapping_details.id;


--
-- TOC entry 493 (class 1259 OID 162820787)
-- Name: mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mapping_id_seq OWNER TO postgres;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 493
-- Name: mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mapping_id_seq OWNED BY public.mapping.id;


--
-- TOC entry 492 (class 1259 OID 162820781)
-- Name: mapping_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mapping_submission (
    id integer NOT NULL,
    assessment_grade character varying(10) NOT NULL,
    is_present boolean NOT NULL,
    assessment_id integer,
    mapping_id integer,
    school_id integer,
    subject_id integer
);


ALTER TABLE public.mapping_submission OWNER TO postgres;

--
-- TOC entry 491 (class 1259 OID 162820779)
-- Name: mapping_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mapping_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mapping_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 491
-- Name: mapping_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mapping_submission_id_seq OWNED BY public.mapping_submission.id;

CREATE TABLE public.monitortracking (
    "monitorTrackingId" uuid DEFAULT public.gen_random_uuid() NOT NULL,
    "schoolId" text,
    "scheduleVisitDate" date,
    "visitDate" date,
    feedback text,
    status text,
    created_at timestamp with time zone DEFAULT now(),
    "monitorId" text,
    "lastVisited" date,
    updated_at timestamp with time zone DEFAULT now(),
    "groupId" uuid NOT NULL
);


ALTER TABLE public.monitortracking OWNER TO postgres;

--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 583
-- Name: COLUMN monitortracking."scheduleVisitDate"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.monitortracking."scheduleVisitDate" IS 'The date at which team is scheduled to arrive (sa_school_evaluations.evaluation_date, sa_school_evaluations.school_id, sa_school_evaluations.evaluator_ids to be matched)';


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 583
-- Name: COLUMN monitortracking."visitDate"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.monitortracking."visitDate" IS 'actual date of visit done by evaluator';


CREATE TABLE public.notification (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    token character varying(512) NOT NULL,
    text text NOT NULL,
    tries integer NOT NULL,
    last_try timestamp with time zone NOT NULL,
    "user" integer NOT NULL,
    status character varying(9) NOT NULL
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 215880)
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO postgres;

--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 271
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;

CREATE TABLE public.odk_submission (
    id integer NOT NULL,
    form_id character varying(50) NOT NULL,
    data text,
    status integer,
    form_name_id integer,
    school_udise integer NOT NULL,
    submission_date timestamp with time zone,
    xml text,
    is_duplicate boolean NOT NULL,
    is_duplicate_notification_sent boolean NOT NULL
);


ALTER TABLE public.odk_submission OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 33460)
-- Name: odk_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.odk_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.odk_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 266
-- Name: odk_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.odk_submission_id_seq OWNED BY public.odk_submission.id;


--
-- TOC entry 313 (class 1259 OID 22570234)
-- Name: old_assessment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.old_assessment (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    year character varying(9),
    udise character varying(12),
    clazz character varying(2),
    section character varying(2),
    subject character varying(20),
    roll character varying(10),
    student_id character varying(15),
    gender character varying(10),
    category character varying(10),
    cwsn character varying(5),
    sa1 integer NOT NULL,
    sa2 integer NOT NULL,
    total double precision NOT NULL,
    percentage double precision NOT NULL,
    grade character varying(1) NOT NULL,
    grade_ab double precision NOT NULL,
    district character varying(20) NOT NULL,
    block character varying(50),
    cluster character varying(50),
    school_name character varying(50),
    school_category character varying(50),
    summer_winter character varying(10)
);


ALTER TABLE public.old_assessment OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 22570232)
-- Name: old_assessment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.old_assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.old_assessment_id_seq OWNER TO postgres;

--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 312
-- Name: old_assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.old_assessment_id_seq OWNED BY public.old_assessment.id;


--
-- TOC entry 315 (class 1259 OID 22570243)
-- Name: old_lo_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.old_lo_master (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    year character varying(9),
    clazz character varying(2),
    subject character varying(20),
    code character varying(10),
    competency text NOT NULL
);


ALTER TABLE public.old_lo_master OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 22570241)
-- Name: old_lo_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.old_lo_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.old_lo_master_id_seq OWNER TO postgres;

--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 314
-- Name: old_lo_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.old_lo_master_id_seq OWNED BY public.old_lo_master.id;


--
-- TOC entry 317 (class 1259 OID 22570254)
-- Name: old_lo_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.old_lo_submissions (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    school_name character varying(50),
    clazz character varying(2),
    subject character varying(20),
    learning_outcome text NOT NULL,
    achievement_percent double precision NOT NULL
);


ALTER TABLE public.old_lo_submissions OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 22570252)
-- Name: old_lo_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.old_lo_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.old_lo_submissions_id_seq OWNER TO postgres;

--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 316
-- Name: old_lo_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.old_lo_submissions_id_seq OWNED BY public.old_lo_submissions.id;


--
-- TOC entry 319 (class 1259 OID 22570265)
-- Name: old_schools; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.old_schools (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    district character varying(50),
    block character varying(50),
    cluster character varying(50),
    udise character varying(15),
    name character varying(50),
    category character varying(50),
    session character varying(10)
);


ALTER TABLE public.old_schools OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 22570263)
-- Name: old_schools_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.old_schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.old_schools_id_seq OWNER TO postgres;

--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 318
-- Name: old_schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.old_schools_id_seq OWNED BY public.old_schools.id;


--
-- TOC entry 366 (class 1259 OID 153075129)
-- Name: pgbench_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pgbench_accounts (
    aid integer NOT NULL,
    bid integer,
    abalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_accounts OWNER TO postgres;

--
-- TOC entry 367 (class 1259 OID 153075132)
-- Name: pgbench_branches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pgbench_branches (
    bid integer NOT NULL,
    bbalance integer,
    filler character(88)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_branches OWNER TO postgres;

--
-- TOC entry 364 (class 1259 OID 153075123)
-- Name: pgbench_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pgbench_history (
    tid integer,
    bid integer,
    aid integer,
    delta integer,
    mtime timestamp without time zone,
    filler character(22)
);


ALTER TABLE public.pgbench_history OWNER TO postgres;

--
-- TOC entry 365 (class 1259 OID 153075126)
-- Name: pgbench_tellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pgbench_tellers (
    tid integer NOT NULL,
    bid integer,
    tbalance integer,
    filler character(84)
)
WITH (fillfactor='100');


ALTER TABLE public.pgbench_tellers OWNER TO postgres;


CREATE TABLE public.question_assessment (
    id integer NOT NULL,
    question_id integer NOT NULL,
    assessment_id integer NOT NULL
);


ALTER TABLE public.question_assessment OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 3378783)
-- Name: question_assessment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_assessment_id_seq OWNER TO postgres;

--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 273
-- Name: question_assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_assessment_id_seq OWNED BY public.question_assessment.id;


--
-- TOC entry 197 (class 1259 OID 24994)
-- Name: question_based_response_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_based_response_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_based_response_index_seq OWNER TO postgres;

--
-- TOC entry 466 (class 1259 OID 162820517)
-- Name: question_bundle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_bundle (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    "desc" character varying(50) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    cache jsonb
);


ALTER TABLE public.question_bundle OWNER TO postgres;

--
-- TOC entry 465 (class 1259 OID 162820515)
-- Name: question_bundle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_bundle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_bundle_id_seq OWNER TO postgres;

--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 465
-- Name: question_bundle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_bundle_id_seq OWNED BY public.question_bundle.id;


--
-- TOC entry 468 (class 1259 OID 162820525)
-- Name: question_bundle_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_bundle_questions (
    id integer NOT NULL,
    questionbundle_id integer NOT NULL,
    question_v2_id integer NOT NULL
);


ALTER TABLE public.question_bundle_questions OWNER TO postgres;

--
-- TOC entry 467 (class 1259 OID 162820523)
-- Name: question_bundle_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_bundle_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_bundle_question_id_seq OWNER TO postgres;

--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 467
-- Name: question_bundle_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_bundle_question_id_seq OWNED BY public.question_bundle_questions.id;


--
-- TOC entry 258 (class 1259 OID 33237)
-- Name: question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_id_seq OWNER TO postgres;

--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 258
-- Name: question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_id_seq OWNED BY public.question.id;


--
-- TOC entry 256 (class 1259 OID 33229)
-- Name: question_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 256
-- Name: question_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_submission_id_seq OWNED BY public.question_submission.id;


--
-- TOC entry 456 (class 1259 OID 162820471)
-- Name: question_v2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_v2 (
    id integer NOT NULL,
    statement text NOT NULL,
    cutoff numeric(4,2),
    lo_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.question_v2 OWNER TO postgres;

--
-- TOC entry 455 (class 1259 OID 162820469)
-- Name: question_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_v2_id_seq OWNER TO postgres;

--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 455
-- Name: question_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_v2_id_seq OWNED BY public.question_v2.id;


--
-- TOC entry 198 (class 1259 OID 25000)
-- Name: questions_question_code_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questions_question_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_question_code_seq OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 14701045)
-- Name: questions_submission_expanded; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questions_submission_expanded (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    acad_year character varying(9) NOT NULL,
    assessment_type character varying(9) NOT NULL,
    assessment_start timestamp with time zone,
    assessment_end timestamp with time zone,
    grade character varying(3) NOT NULL,
    subject character varying(20),
    lo_code character varying(8),
    lo_name text NOT NULL,
    students_cleared integer NOT NULL,
    grade_assessment_id integer NOT NULL,
    question_id integer NOT NULL,
    student_present integer NOT NULL,
    achievement_level double precision NOT NULL,
    school_udise integer NOT NULL,
    school_type character varying(4) NOT NULL,
    school_session character varying(1) NOT NULL,
    district character varying(17) NOT NULL,
    block character varying(50),
    cluster character varying(50)
);


ALTER TABLE public.questions_submission_expanded OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 25012)
-- Name: response_deadlines_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.response_deadlines_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.response_deadlines_index_seq OWNER TO postgres;

--
-- TOC entry 584 (class 1259 OID 277987334)
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    "roleId" uuid DEFAULT public.gen_random_uuid() NOT NULL,
    title text NOT NULL,
    "parentId" text NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- TOC entry 596 (class 1259 OID 277987484)
-- Name: sa_assessment_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sa_assessment_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sa_assessment_config_id_seq OWNER TO postgres;

--
-- TOC entry 593 (class 1259 OID 277987437)
-- Name: sa_class_evaluation_students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sa_class_evaluation_students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sa_class_evaluation_students_id_seq OWNER TO postgres;

--
-- TOC entry 592 (class 1259 OID 277987433)
-- Name: sa_class_students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sa_class_students (
    id integer DEFAULT nextval('public.sa_class_evaluation_students_id_seq'::regclass) NOT NULL,
    school_id integer NOT NULL,
    class integer NOT NULL,
    student_id integer NOT NULL,
    evaluation_date date NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sa_class_students OWNER TO postgres;

--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 592
-- Name: TABLE sa_class_students; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sa_class_students IS 'table to store list of students whose spot assessment will be conducted';


--
-- TOC entry 591 (class 1259 OID 277987420)
-- Name: sa_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sa_evaluations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sa_evaluations_id_seq OWNER TO postgres;

--
-- TOC entry 590 (class 1259 OID 277987414)
-- Name: sa_evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sa_evaluations (
    id integer DEFAULT nextval('public.sa_evaluations_id_seq'::regclass) NOT NULL,
    team_id integer NOT NULL,
    evaluator_id text NOT NULL,
    designation character varying NOT NULL,
    district character varying NOT NULL,
    block character varying NOT NULL,
    cluster character varying NOT NULL
);


ALTER TABLE public.sa_evaluations OWNER TO postgres;

--
-- TOC entry 595 (class 1259 OID 277987476)
-- Name: sa_orf_assessment_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sa_orf_assessment_config (
    id integer DEFAULT nextval('public.sa_assessment_config_id_seq'::regclass) NOT NULL,
    grade integer NOT NULL,
    subject character varying NOT NULL,
    competency_id integer NOT NULL,
    book_ids character varying[] NOT NULL,
    partner_code character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sa_orf_assessment_config OWNER TO postgres;

--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 595
-- Name: TABLE sa_orf_assessment_config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sa_orf_assessment_config IS 'Table to store mapping of grade vs book ids';


--
-- TOC entry 587 (class 1259 OID 277987368)
-- Name: sa_team_evaluators_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sa_team_evaluators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sa_team_evaluators_id_seq OWNER TO postgres;

--
-- TOC entry 586 (class 1259 OID 277987361)
-- Name: sa_team_evaluators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sa_team_evaluators (
    id integer DEFAULT nextval('public.sa_team_evaluators_id_seq'::regclass) NOT NULL,
    team_id integer NOT NULL,
    evaluator_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sa_team_evaluators OWNER TO postgres;

--
-- TOC entry 585 (class 1259 OID 277987350)
-- Name: sa_teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sa_teams (
    id integer NOT NULL,
    name character varying,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sa_teams OWNER TO postgres;

--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 585
-- Name: TABLE sa_teams; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sa_teams IS 'Teams who will go for spot assessments';


--
-- TOC entry 369 (class 1259 OID 153634764)
-- Name: sample_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sample_test (
    name text NOT NULL,
    count integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.sample_test OWNER TO postgres;

--
-- TOC entry 368 (class 1259 OID 153634762)
-- Name: sample_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sample_test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sample_test_id_seq OWNER TO postgres;

--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 368
-- Name: sample_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sample_test_id_seq OWNED BY public.sample_test.id;


--
-- TOC entry 597 (class 1259 OID 277987496)
-- Name: school_assessment_results_summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school_assessment_results_summary (
    school_id integer,
    udise integer,
    academic_year character varying(9),
    academic_year_ending text,
    grade_number integer,
    section character varying(1),
    teacher_id integer,
    assessment_id integer,
    assessment_type character varying(8),
    subject_id integer,
    subject_name character varying(20),
    total_students bigint,
    total_students_attempted bigint,
    approx_class_avg_pct double precision,
    approx_class_avg_grade character varying,
    class_prop_grade_a double precision,
    class_prop_grade_b double precision,
    class_prop_grade_c double precision,
    class_prop_grade_d double precision,
    class_prop_grade_e double precision
);


ALTER TABLE public.school_assessment_results_summary OWNER TO postgres;

--
-- TOC entry 598 (class 1259 OID 277987503)
-- Name: school_assessment_total_attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school_assessment_total_attendance (
    school_id integer,
    udise integer,
    grade_number integer,
    subject_id integer,
    assessment_id integer,
    total_students bigint
);


ALTER TABLE public.school_assessment_total_attendance OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 37714291)
-- Name: school_cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school_cache (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    stream_data jsonb,
    school_id integer
);


ALTER TABLE public.school_cache OWNER TO postgres;

--
-- TOC entry 351 (class 1259 OID 37714289)
-- Name: school_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.school_cache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_cache_id_seq OWNER TO postgres;

--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 351
-- Name: school_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.school_cache_id_seq OWNED BY public.school_cache.id;


--
-- TOC entry 245 (class 1259 OID 33168)
-- Name: school_grade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school_grade (
    id integer NOT NULL,
    school_id integer NOT NULL,
    grade_id integer NOT NULL
);


ALTER TABLE public.school_grade OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 33166)
-- Name: school_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.school_grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_grade_id_seq OWNER TO postgres;

--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 244
-- Name: school_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.school_grade_id_seq OWNED BY public.school_grade.id;


--
-- TOC entry 242 (class 1259 OID 33156)
-- Name: school_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.school_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_id_seq OWNER TO postgres;

--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 242
-- Name: school_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.school_id_seq OWNED BY public.school.id;


--
-- TOC entry 599 (class 1259 OID 277987507)
-- Name: school_lo_results_temp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school_lo_results_temp (
    lo_submission_id integer,
    school_id integer,
    udise integer,
    teacher_id integer,
    grade_id integer,
    grade_number integer,
    section character varying(1),
    stream_name character varying(25),
    assessment_id integer,
    assessment_type character varying(8),
    submission_type character varying(8),
    academic_year character varying(9),
    academic_year_ending text,
    school_session character varying(1),
    geo_district character varying(17),
    subject_id integer,
    subject_name character varying(20),
    lo_id integer,
    lo_code character varying(8),
    lo_name text,
    students_cleared integer,
    students_attempted bigint,
    pct_students_cleared double precision
);


ALTER TABLE public.school_lo_results_temp OWNER TO postgres;

--
-- TOC entry 575 (class 1259 OID 277977745)
-- Name: school_location_mapping; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school_location_mapping (
    school_id integer NOT NULL,
    location_id integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.school_location_mapping OWNER TO postgres;

--
-- TOC entry 574 (class 1259 OID 277977743)
-- Name: school_location_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.school_location_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_location_mapping_id_seq OWNER TO postgres;

--
-- TOC entry 5200 (class 0 OID 0)
-- Dependencies: 574
-- Name: school_location_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.school_location_mapping_id_seq OWNED BY public.school_location_mapping.id;

CREATE TABLE public.school_question_results_temp (
    question_submission_id integer,
    school_id integer,
    udise integer,
    teacher_id integer,
    grade_id integer,
    grade_number integer,
    section character varying(1),
    stream_name character varying(25),
    assessment_id integer,
    assessment_type character varying(8),
    submission_type character varying(8),
    academic_year character varying(9),
    academic_year_ending text,
    school_session character varying(1),
    geo_district character varying(17),
    subject_id integer,
    subject_name character varying(20),
    question_id integer,
    question_cutoff numeric(4,2),
    lo_id integer,
    lo_code character varying(8),
    lo_name text,
    students_cleared integer,
    students_attempted bigint,
    pct_students_cleared double precision
);


ALTER TABLE public.school_question_results_temp OWNER TO postgres;


CREATE SEQUENCE public.school_wise_daily_enrolment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_wise_daily_enrolment_id_seq OWNER TO postgres;

--
-- TOC entry 5201 (class 0 OID 0)
-- Dependencies: 516
-- Name: school_wise_daily_enrolment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.school_wise_daily_enrolment_id_seq OWNED BY public.school_wise_daily_enrolment.id;


--
-- TOC entry 520 (class 1259 OID 163754465)
-- Name: server_celeryduplicateremove_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_celeryduplicateremove_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_celeryduplicateremove_id_seq OWNER TO postgres;

--
-- TOC entry 5202 (class 0 OID 0)
-- Dependencies: 520
-- Name: server_celeryduplicateremove_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_celeryduplicateremove_id_seq OWNED BY public.celery_duplicate_remove.id;


--
-- TOC entry 281 (class 1259 OID 21198008)
-- Name: server_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_enrollment_id_seq OWNER TO postgres;

--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 281
-- Name: server_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_enrollment_id_seq OWNED BY public.enrollment.id;


--
-- TOC entry 394 (class 1259 OID 154025483)
-- Name: server_logroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.server_logroup (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.server_logroup OWNER TO postgres;

--
-- TOC entry 393 (class 1259 OID 154025481)
-- Name: server_logroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_logroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_logroup_id_seq OWNER TO postgres;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 393
-- Name: server_logroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_logroup_id_seq OWNED BY public.server_logroup.id;


--
-- TOC entry 396 (class 1259 OID 154025491)
-- Name: server_logroup_lo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.server_logroup_lo (
    id integer NOT NULL,
    logroup_id integer NOT NULL,
    lo_id integer NOT NULL
);


ALTER TABLE public.server_logroup_lo OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 154025489)
-- Name: server_logroup_lo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_logroup_lo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_logroup_lo_id_seq OWNER TO postgres;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 395
-- Name: server_logroup_lo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_logroup_lo_id_seq OWNED BY public.server_logroup_lo.id;


--
-- TOC entry 388 (class 1259 OID 154025447)
-- Name: server_marksrange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.server_marksrange (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    min integer NOT NULL,
    max integer NOT NULL
);


ALTER TABLE public.server_marksrange OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 154025445)
-- Name: server_marksrange_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_marksrange_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_marksrange_id_seq OWNER TO postgres;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 387
-- Name: server_marksrange_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_marksrange_id_seq OWNED BY public.server_marksrange.id;


--
-- TOC entry 390 (class 1259 OID 154025467)
-- Name: server_questiongroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.server_questiongroup (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.server_questiongroup OWNER TO postgres;

--
-- TOC entry 389 (class 1259 OID 154025465)
-- Name: server_questiongroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_questiongroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_questiongroup_id_seq OWNER TO postgres;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 389
-- Name: server_questiongroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_questiongroup_id_seq OWNED BY public.server_questiongroup.id;


--
-- TOC entry 392 (class 1259 OID 154025475)
-- Name: server_questiongroup_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.server_questiongroup_question (
    id integer NOT NULL,
    questiongroup_id integer NOT NULL,
    question_id integer NOT NULL
);


ALTER TABLE public.server_questiongroup_question OWNER TO postgres;

--
-- TOC entry 391 (class 1259 OID 154025473)
-- Name: server_questiongroup_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_questiongroup_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_questiongroup_question_id_seq OWNER TO postgres;

--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 391
-- Name: server_questiongroup_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_questiongroup_question_id_seq OWNED BY public.server_questiongroup_question.id;


--
-- TOC entry 276 (class 1259 OID 14701043)
-- Name: server_questionsubmissionview_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_questionsubmissionview_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_questionsubmissionview_id_seq OWNER TO postgres;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 276
-- Name: server_questionsubmissionview_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_questionsubmissionview_id_seq OWNED BY public.questions_submission_expanded.id;


--
-- TOC entry 408 (class 1259 OID 154025762)
-- Name: teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    user_id uuid NOT NULL,
    employment character varying(17),
    joining_date date,
    account_status character varying(20) NOT NULL,
    cadre character varying(30) NOT NULL,
    designation character varying(50),
    school_id integer,
    parent_id integer,
    role character varying(10) NOT NULL,
    deactivation_reason text
);


ALTER TABLE public.teacher OWNER TO postgres;

--
-- TOC entry 407 (class 1259 OID 154025760)
-- Name: server_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_teacher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_teacher_id_seq OWNER TO postgres;

--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 407
-- Name: server_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_teacher_id_seq OWNED BY public.teacher.id;


--
-- TOC entry 410 (class 1259 OID 154025770)
-- Name: teacher_subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_subjects (
    id integer NOT NULL,
    teacher_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.teacher_subjects OWNER TO postgres;

--
-- TOC entry 409 (class 1259 OID 154025768)
-- Name: server_teacher_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.server_teacher_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.server_teacher_subjects_id_seq OWNER TO postgres;

--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 409
-- Name: server_teacher_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.server_teacher_subjects_id_seq OWNED BY public.teacher_subjects.id;


--
-- TOC entry 305 (class 1259 OID 21223129)
-- Name: silk_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silk_profile (
    id integer NOT NULL,
    name character varying(300) NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone,
    time_taken double precision,
    file_path character varying(300) NOT NULL,
    line_num integer,
    end_line_num integer,
    func_name character varying(300) NOT NULL,
    exception_raised boolean NOT NULL,
    dynamic boolean NOT NULL,
    request_id character varying(36)
);


ALTER TABLE public.silk_profile OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 21223127)
-- Name: silk_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.silk_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.silk_profile_id_seq OWNER TO postgres;

--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 304
-- Name: silk_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.silk_profile_id_seq OWNED BY public.silk_profile.id;


--
-- TOC entry 311 (class 1259 OID 21223169)
-- Name: silk_profile_queries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silk_profile_queries (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    sqlquery_id integer NOT NULL
);


ALTER TABLE public.silk_profile_queries OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 21223167)
-- Name: silk_profile_queries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.silk_profile_queries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.silk_profile_queries_id_seq OWNER TO postgres;

--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 310
-- Name: silk_profile_queries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.silk_profile_queries_id_seq OWNED BY public.silk_profile_queries.id;


--
-- TOC entry 306 (class 1259 OID 21223138)
-- Name: silk_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silk_request (
    id character varying(36) NOT NULL,
    path character varying(190) NOT NULL,
    query_params text NOT NULL,
    raw_body text NOT NULL,
    body text NOT NULL,
    method character varying(10) NOT NULL,
    start_time timestamp with time zone NOT NULL,
    view_name character varying(190),
    end_time timestamp with time zone,
    time_taken double precision,
    encoded_headers text NOT NULL,
    meta_time double precision,
    meta_num_queries integer,
    meta_time_spent_queries double precision,
    pyprofile text NOT NULL,
    num_sql_queries integer NOT NULL,
    prof_file character varying(300) NOT NULL
);


ALTER TABLE public.silk_request OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 21223146)
-- Name: silk_response; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silk_response (
    id character varying(36) NOT NULL,
    status_code integer NOT NULL,
    raw_body text NOT NULL,
    body text NOT NULL,
    encoded_headers text NOT NULL,
    request_id character varying(36) NOT NULL
);


ALTER TABLE public.silk_response OWNER TO postgres;

--
-- TOC entry 309 (class 1259 OID 21223158)
-- Name: silk_sqlquery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.silk_sqlquery (
    id integer NOT NULL,
    query text NOT NULL,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    time_taken double precision,
    traceback text NOT NULL,
    request_id character varying(36),
    identifier integer NOT NULL,
    analysis text
);


ALTER TABLE public.silk_sqlquery OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 21223156)
-- Name: silk_sqlquery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.silk_sqlquery_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.silk_sqlquery_id_seq OWNER TO postgres;

--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 308
-- Name: silk_sqlquery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.silk_sqlquery_id_seq OWNED BY public.silk_sqlquery.id;


--
-- TOC entry 255 (class 1259 OID 33218)
-- Name: sms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sms (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    message_id character varying(50) NOT NULL,
    school integer NOT NULL,
    form_id character varying(50) NOT NULL,
    phone bigint,
    status character varying(25) NOT NULL,
    form_type character varying(15) NOT NULL,
    gupshup_updated timestamp with time zone,
    text text,
    response_code integer,
    tries integer NOT NULL,
    history jsonb,
    student_id integer,
    submitted timestamp with time zone NOT NULL
);


ALTER TABLE public.sms OWNER TO postgres;

--
-- TOC entry 525 (class 1259 OID 164353383)
-- Name: sms_dag_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sms_dag_reports (
    id integer NOT NULL,
    run_date text NOT NULL,
    dag_name text NOT NULL,
    successful_sms_count integer NOT NULL,
    total_records_present integer NOT NULL
);


ALTER TABLE public.sms_dag_reports OWNER TO postgres;

--
-- TOC entry 524 (class 1259 OID 164353381)
-- Name: sms_dag_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sms_dag_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_dag_reports_id_seq OWNER TO postgres;

--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 524
-- Name: sms_dag_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sms_dag_reports_id_seq OWNED BY public.sms_dag_reports.id;


--
-- TOC entry 254 (class 1259 OID 33216)
-- Name: sms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_id_seq OWNER TO postgres;

--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 254
-- Name: sms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sms_id_seq OWNED BY public.sms.id;


--
-- TOC entry 200 (class 1259 OID 25024)
-- Name: sms_template_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sms_template_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_template_index_seq OWNER TO postgres;

--
-- TOC entry 606 (class 1259 OID 278019753)
-- Name: sms_track; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sms_track (
    id integer NOT NULL,
    type text NOT NULL,
    phone_no text NOT NULL,
    user_id text NOT NULL,
    instance_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    status text NOT NULL,
    message_id text NOT NULL
);


ALTER TABLE public.sms_track OWNER TO postgres;

--
-- TOC entry 605 (class 1259 OID 278019751)
-- Name: sms_track_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sms_track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_track_id_seq OWNER TO postgres;

--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 605
-- Name: sms_track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sms_track_id_seq OWNED BY public.sms_track.id;


--
-- TOC entry 534 (class 1259 OID 180722155)
-- Name: ss_school_allocation_data; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ss_school_allocation_data (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    school_id integer NOT NULL,
    is_visited boolean DEFAULT false NOT NULL,
    date_of_visit date,
    username text NOT NULL,
    quarter integer NOT NULL
);


ALTER TABLE public.ss_school_allocation_data OWNER TO postgres;

--
-- TOC entry 533 (class 1259 OID 180722153)
-- Name: ss_school_allocation_data_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ss_school_allocation_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ss_school_allocation_data_id_seq OWNER TO postgres;

--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 533
-- Name: ss_school_allocation_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ss_school_allocation_data_id_seq OWNED BY public.ss_school_allocation_data.id;


--
-- TOC entry 532 (class 1259 OID 180722091)
-- Name: ss_school_allocation_quarter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ss_school_allocation_quarter (
    id integer NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    month1 text NOT NULL,
    month2 text NOT NULL,
    month3 text NOT NULL,
    year integer NOT NULL,
    quarter_id integer NOT NULL
);


ALTER TABLE public.ss_school_allocation_quarter OWNER TO postgres;

--
-- TOC entry 531 (class 1259 OID 180722089)
-- Name: ss_school_allocation_quarter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ss_school_allocation_quarter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ss_school_allocation_quarter_id_seq OWNER TO postgres;

--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 531
-- Name: ss_school_allocation_quarter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ss_school_allocation_quarter_id_seq OWNED BY public.ss_school_allocation_quarter.id;


CREATE TABLE public.state_lo_list (
    "Grade" integer DEFAULT 0,
    "Subject" character varying DEFAULT '-'::character varying,
    "Chapter_number" integer DEFAULT 0,
    "Chapter_Name" character varying DEFAULT '-'::character varying,
    "State_LO_Code" character varying DEFAULT '-'::character varying
);


ALTER TABLE public.state_lo_list OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 21222958)
-- Name: static; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.static (
    id integer NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    current_acad_year character varying(9) NOT NULL
);


ALTER TABLE public.static OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 21222956)
-- Name: static_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.static_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.static_id_seq OWNER TO postgres;

--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 300
-- Name: static_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.static_id_seq OWNED BY public.static.id;


--
-- TOC entry 284 (class 1259 OID 21198044)
-- Name: stream_common_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stream_common_subject (
    id integer NOT NULL,
    stream_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.stream_common_subject OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 21198042)
-- Name: stream_common_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stream_common_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stream_common_subject_id_seq OWNER TO postgres;

--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 283
-- Name: stream_common_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stream_common_subject_id_seq OWNED BY public.stream_common_subject.id;


--
-- TOC entry 286 (class 1259 OID 21198052)
-- Name: stream_optional_subjects_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stream_optional_subjects_1 (
    id integer NOT NULL,
    stream_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.stream_optional_subjects_1 OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 21198050)
-- Name: stream_optional_subjects_1_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stream_optional_subjects_1_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stream_optional_subjects_1_id_seq OWNER TO postgres;

--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 285
-- Name: stream_optional_subjects_1_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stream_optional_subjects_1_id_seq OWNED BY public.stream_optional_subjects_1.id;


--
-- TOC entry 288 (class 1259 OID 21198060)
-- Name: stream_optional_subjects_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stream_optional_subjects_2 (
    id integer NOT NULL,
    stream_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.stream_optional_subjects_2 OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 21198058)
-- Name: stream_optional_subjects_2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stream_optional_subjects_2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stream_optional_subjects_2_id_seq OWNER TO postgres;

--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 287
-- Name: stream_optional_subjects_2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stream_optional_subjects_2_id_seq OWNED BY public.stream_optional_subjects_2.id;


--
-- TOC entry 290 (class 1259 OID 21198068)
-- Name: stream_optional_subjects_3; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stream_optional_subjects_3 (
    id integer NOT NULL,
    stream_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.stream_optional_subjects_3 OWNER TO postgres;

--
-- TOC entry 289 (class 1259 OID 21198066)
-- Name: stream_optional_subjects_3_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stream_optional_subjects_3_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stream_optional_subjects_3_id_seq OWNER TO postgres;

--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 289
-- Name: stream_optional_subjects_3_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stream_optional_subjects_3_id_seq OWNED BY public.stream_optional_subjects_3.id;


--
-- TOC entry 292 (class 1259 OID 21198076)
-- Name: stream_optional_subjects_4; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stream_optional_subjects_4 (
    id integer NOT NULL,
    stream_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.stream_optional_subjects_4 OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 21198074)
-- Name: stream_optional_subjects_4_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stream_optional_subjects_4_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stream_optional_subjects_4_id_seq OWNER TO postgres;

--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 291
-- Name: stream_optional_subjects_4_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stream_optional_subjects_4_id_seq OWNED BY public.stream_optional_subjects_4.id;


CREATE TABLE public.student_assessments_temp (
    student_submission_id integer,
    student_id integer,
    school_id integer,
    udise integer,
    teacher_id integer,
    grade_number integer,
    section character varying(1),
    assessment_id integer,
    assessment_grade character varying(1),
    assessment_pct_bin character varying,
    assessment_pct_avg double precision,
    assessment_percent double precision,
    attendance_absent integer,
    subject_id integer,
    subject_name character varying(20),
    assessment_type character varying(8),
    submission_type character varying(8),
    academic_year character varying(9),
    academic_year_ending text,
    school_session character varying(1),
    geo_district character varying(17)
);


ALTER TABLE public.student_assessments_temp OWNER TO postgres;

CREATE SEQUENCE public.student_based_response_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_based_response_index_seq OWNER TO postgres;

--
-- TOC entry 529 (class 1259 OID 171077450)
-- Name: student_content_share; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_content_share (
    id integer NOT NULL,
    student_name text NOT NULL,
    content_link text NOT NULL,
    phone_number text NOT NULL,
    student_id integer,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    grade_number integer,
    subject text,
    sms_status text DEFAULT 'not_sent'::text
);


ALTER TABLE public.student_content_share OWNER TO postgres;

--
-- TOC entry 528 (class 1259 OID 171077448)
-- Name: student_content_share_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_content_share_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_content_share_id_seq OWNER TO postgres;

--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 528
-- Name: student_content_share_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_content_share_id_seq OWNED BY public.student_content_share.id;


--
-- TOC entry 204 (class 1259 OID 25092)
-- Name: student_data_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_data_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_data_index_seq OWNER TO postgres;
CREATE TABLE public.student_document (
    id integer NOT NULL,
    student_id integer NOT NULL,
    documents_id integer NOT NULL
);


ALTER TABLE public.student_document OWNER TO postgres;

--
-- TOC entry 641 (class 1259 OID 278029938)
-- Name: student_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_document_id_seq OWNER TO postgres;

--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 641
-- Name: student_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_document_id_seq OWNED BY public.student_document.id;


CREATE TABLE public.student_subject (
    id integer NOT NULL,
    student_id integer NOT NULL,
    subject_id integer NOT NULL
);


ALTER TABLE public.student_subject OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 21198107)
-- Name: student_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_subject_id_seq OWNER TO postgres;

--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 293
-- Name: student_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_subject_id_seq OWNED BY public.student_subject.id;

CREATE SEQUENCE public.student_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 264
-- Name: student_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_submission_id_seq OWNED BY public.student_submission.id;


--
-- TOC entry 509 (class 1259 OID 162821682)
-- Name: student_submission_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_submission_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_submission_v2_id_seq OWNER TO postgres;

--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 509
-- Name: student_submission_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_submission_v2_id_seq OWNED BY public.student_submission_v2.id;


--
-- TOC entry 511 (class 1259 OID 162821690)
-- Name: student_submission_v2_marks_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_submission_v2_marks_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_submission_v2_marks_submissions_id_seq OWNER TO postgres;

--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 511
-- Name: student_submission_v2_marks_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_submission_v2_marks_submissions_id_seq OWNED BY public.student_submission_v2_marks_submissions.id;

CREATE SEQUENCE public.subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subject_id_seq OWNER TO postgres;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 246
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_id_seq OWNED BY public.subject.id;


--
-- TOC entry 323 (class 1259 OID 32010072)
-- Name: subject_submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_submission (
    created timestamp with time zone,
    updated timestamp with time zone,
    id integer NOT NULL,
    assessment_id integer NOT NULL,
    school_id integer NOT NULL,
    subject_id integer NOT NULL,
    stream_id integer,
    grade_id integer
);


ALTER TABLE public.subject_submission OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 32010070)
-- Name: subject_submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subject_submission_id_seq OWNER TO postgres;

--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 322
-- Name: subject_submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_submission_id_seq OWNED BY public.subject_submission.id;


--
-- TOC entry 325 (class 1259 OID 32010086)
-- Name: subject_submission_selected_lo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject_submission_selected_lo (
    id integer NOT NULL,
    subjectsubmission_id integer NOT NULL,
    lo_id integer NOT NULL
);


ALTER TABLE public.subject_submission_selected_lo OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 32010084)
-- Name: subject_submission_selected_lo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_submission_selected_lo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subject_submission_selected_lo_id_seq OWNER TO postgres;

--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 324
-- Name: subject_submission_selected_lo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_submission_selected_lo_id_seq OWNED BY public.subject_submission_selected_lo.id;


--
-- TOC entry 608 (class 1259 OID 278019768)
-- Name: submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submission (
    id integer NOT NULL,
    xml_string xml NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    type text NOT NULL,
    status text DEFAULT 'QUEUED'::text NOT NULL,
    remarks text,
    instance_id uuid NOT NULL,
    user_id text NOT NULL
);


ALTER TABLE public.submission OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 25036)
-- Name: submission_form_mapping_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submission_form_mapping_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submission_form_mapping_index_seq OWNER TO postgres;

--
-- TOC entry 607 (class 1259 OID 278019766)
-- Name: submission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submission_id_seq OWNER TO postgres;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 607
-- Name: submission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submission_id_seq OWNED BY public.submission.id;


--
-- TOC entry 249 (class 1259 OID 33186)
-- Name: submission_summary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submission_summary (
    id integer NOT NULL,
    percentage integer NOT NULL,
    sms_status boolean NOT NULL,
    school integer NOT NULL,
    assessment_id integer
);


ALTER TABLE public.submission_summary OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 33184)
-- Name: submission_summary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submission_summary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submission_summary_id_seq OWNER TO postgres;

--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 248
-- Name: submission_summary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submission_summary_id_seq OWNED BY public.submission_summary.id;


--
-- TOC entry 458 (class 1259 OID 162820482)
-- Name: submission_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submission_type (
    id integer NOT NULL,
    category character varying(50) NOT NULL,
    aggregation character varying(50) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.submission_type OWNER TO postgres;

--
-- TOC entry 457 (class 1259 OID 162820480)
-- Name: submission_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submission_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submission_type_id_seq OWNER TO postgres;

--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 457
-- Name: submission_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submission_type_id_seq OWNED BY public.submission_type.id;


--
-- TOC entry 205 (class 1259 OID 25153)
-- Name: submissions_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submissions_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submissions_index_seq OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 25048)
-- Name: submissions_summary_index_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submissions_summary_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submissions_summary_index_seq OWNER TO postgres;

--
-- TOC entry 530 (class 1259 OID 175264524)
-- Name: teacher_attendance_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_attendance_status (
    name text NOT NULL,
    label text NOT NULL,
    value text NOT NULL,
    is_present integer NOT NULL,
    reason_required boolean NOT NULL
);


ALTER TABLE public.teacher_attendance_status OWNER TO postgres;

--
-- TOC entry 421 (class 1259 OID 157789624)
-- Name: teacher_registration_compliance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_registration_compliance (
    udise integer NOT NULL,
    teachercount integer NOT NULL,
    id integer NOT NULL
);


ALTER TABLE public.teacher_registration_compliance OWNER TO postgres;

--
-- TOC entry 422 (class 1259 OID 157801449)
-- Name: teacher_registration_compliance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_registration_compliance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_registration_compliance_id_seq OWNER TO postgres;

--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 422
-- Name: teacher_registration_compliance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_registration_compliance_id_seq OWNED BY public.teacher_registration_compliance.id;


CREATE TABLE public.test_ku (
    sss integer NOT NULL
);


ALTER TABLE public.test_ku OWNER TO postgres;

CREATE TABLE public.test_ss_allocation_update (
    quarter text,
    school_id text,
    username text
);


ALTER TABLE public.test_ss_allocation_update OWNER TO postgres;

--
-- TOC entry 371 (class 1259 OID 153776041)
-- Name: test_telemetry; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_telemetry (
    id integer NOT NULL,
    telemetry_object jsonb NOT NULL
);


ALTER TABLE public.test_telemetry OWNER TO postgres;

--
-- TOC entry 370 (class 1259 OID 153776039)
-- Name: test_telemetry_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_telemetry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_telemetry_id_seq OWNER TO postgres;

--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 370
-- Name: test_telemetry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_telemetry_id_seq OWNED BY public.test_telemetry.id;


--
-- TOC entry 594 (class 1259 OID 277987456)
-- Name: trackassessment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trackassessment (
    "trackAssessmentId" uuid DEFAULT public.gen_random_uuid() NOT NULL,
    filter text,
    type text,
    questions text,
    source text,
    score text,
    "totalScore" text,
    "studentId" text NOT NULL,
    "teacherId" text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    answersheet text,
    subject text,
    date date DEFAULT now(),
    status text,
    "groupId" uuid,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.trackassessment OWNER TO postgres;

CREATE TABLE public.unit_bundle (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    "desc" character varying(50) NOT NULL,
    created timestamp with time zone,
    updated timestamp with time zone,
    cache jsonb
);


ALTER TABLE public.unit_bundle OWNER TO postgres;

--
-- TOC entry 461 (class 1259 OID 162820499)
-- Name: unit_bundle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unit_bundle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unit_bundle_id_seq OWNER TO postgres;

--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 461
-- Name: unit_bundle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unit_bundle_id_seq OWNED BY public.unit_bundle.id;


--
-- TOC entry 464 (class 1259 OID 162820509)
-- Name: unit_bundle_units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unit_bundle_units (
    id integer NOT NULL,
    unitbundle_id integer NOT NULL,
    unit_v2_id integer NOT NULL
);


ALTER TABLE public.unit_bundle_units OWNER TO postgres;

--
-- TOC entry 463 (class 1259 OID 162820507)
-- Name: unit_bundle_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unit_bundle_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unit_bundle_unit_id_seq OWNER TO postgres;

--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 463
-- Name: unit_bundle_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unit_bundle_unit_id_seq OWNED BY public.unit_bundle_units.id;

CREATE TABLE public.unit_v2 (
    id integer NOT NULL,
    code character varying(8),
    name text NOT NULL,
    grade_number integer NOT NULL,
    is_unit boolean NOT NULL,
    subject_id integer,
    created timestamp with time zone,
    updated timestamp with time zone
);


ALTER TABLE public.unit_v2 OWNER TO postgres;

--
-- TOC entry 459 (class 1259 OID 162820488)
-- Name: unit_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unit_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unit_v2_id_seq OWNER TO postgres;

--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 459
-- Name: unit_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unit_v2_id_seq OWNED BY public.unit_v2.id;


--
-- TOC entry 643 (class 1259 OID 278029986)
-- Name: vc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vc (
    created timestamp with time zone,
    updated timestamp with time zone,
    id uuid NOT NULL,
    type text NOT NULL,
    vc text NOT NULL,
    academic_year text,
    remakrs text,
    school_id integer,
    student_id integer,
    link text
);


ALTER TABLE public.vc OWNER TO postgres;

--
-- TOC entry 3725 (class 2604 OID 33108)
-- Name: assessment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment ALTER COLUMN id SET DEFAULT nextval('public.assessment_id_seq'::regclass);


--
-- TOC entry 3803 (class 2604 OID 154025415)
-- Name: assessment_au_lo_aggregate id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate ALTER COLUMN id SET DEFAULT nextval('public.assessment_au_lo_aggregate_id_seq'::regclass);


--
-- TOC entry 3816 (class 2604 OID 154025534)
-- Name: assessment_au_lo_aggregate_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate_submission ALTER COLUMN id SET DEFAULT nextval('public.assessment_au_lo_aggregate_submission_id_seq'::regclass);


--
-- TOC entry 3815 (class 2604 OID 154025526)
-- Name: assessment_au_question_aggregate id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate ALTER COLUMN id SET DEFAULT nextval('public.assessment_au_question_aggregate_id_seq'::regclass);


--
-- TOC entry 3814 (class 2604 OID 154025518)
-- Name: assessment_au_question_aggregate_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate_submission ALTER COLUMN id SET DEFAULT nextval('public.assessment_au_question_aggregate_submission_id_seq'::regclass);


--
-- TOC entry 3847 (class 2604 OID 162820762)
-- Name: assessment_builder id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_builder ALTER COLUMN id SET DEFAULT nextval('public.assessment_builder_id_seq'::regclass);


--
-- TOC entry 3789 (class 2604 OID 37714305)
-- Name: assessment_cache id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache ALTER COLUMN id SET DEFAULT nextval('public.assessment_cache_id_seq'::regclass);


--
-- TOC entry 3862 (class 2604 OID 163512756)
-- Name: assessment_cache_v5 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache_v5 ALTER COLUMN id SET DEFAULT nextval('public.assessment_cache_v5_id_seq'::regclass);


--
-- TOC entry 3827 (class 2604 OID 162820439)
-- Name: assessment_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_category ALTER COLUMN id SET DEFAULT nextval('public.assessment_category_id_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 162820576)
-- Name: assessment_components id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_components ALTER COLUMN id SET DEFAULT nextval('public.assessment_components_id_seq'::regclass);


--
-- TOC entry 3804 (class 2604 OID 154025423)
-- Name: assessment_ep_grade id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade ALTER COLUMN id SET DEFAULT nextval('public.assessment_ep_grade_id_seq'::regclass);


--
-- TOC entry 3813 (class 2604 OID 154025510)
-- Name: assessment_ep_grade_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission ALTER COLUMN id SET DEFAULT nextval('public.assessment_ep_grade_submission_id_seq'::regclass);


--
-- TOC entry 3805 (class 2604 OID 154025431)
-- Name: assessment_ep_marks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks ALTER COLUMN id SET DEFAULT nextval('public.assessment_ep_marks_id_seq'::regclass);


--
-- TOC entry 3812 (class 2604 OID 154025502)
-- Name: assessment_ep_marks_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission ALTER COLUMN id SET DEFAULT nextval('public.assessment_ep_marks_submission_id_seq'::regclass);


--
-- TOC entry 3741 (class 2604 OID 33261)
-- Name: assessment_grade id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade ALTER COLUMN id SET DEFAULT nextval('public.assessment_grade_id_seq'::regclass);


--
-- TOC entry 3806 (class 2604 OID 154025439)
-- Name: assessment_grade_mapping id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade_mapping ALTER COLUMN id SET DEFAULT nextval('public.assessment_grade_mapping_id_seq'::regclass);


--
-- TOC entry 3844 (class 2604 OID 162820584)
-- Name: assessment_lo_bundles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_lo_bundles ALTER COLUMN id SET DEFAULT nextval('public.assessment_lo_bundles_id_seq'::regclass);


--
-- TOC entry 3845 (class 2604 OID 162820592)
-- Name: assessment_question_bundles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_question_bundles ALTER COLUMN id SET DEFAULT nextval('public.assessment_question_bundles_id_seq'::regclass);


--
-- TOC entry 3882 (class 2604 OID 250061038)
-- Name: assessment_result id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_result ALTER COLUMN id SET DEFAULT nextval('public.assessment_result_id_seq'::regclass);


--
-- TOC entry 3766 (class 2604 OID 31837301)
-- Name: assessment_stream id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_stream ALTER COLUMN id SET DEFAULT nextval('public.assessment_stream_id_seq'::regclass);


--
-- TOC entry 3860 (class 2604 OID 162821983)
-- Name: assessment_subjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_subjects ALTER COLUMN id SET DEFAULT nextval('public.assessment_subject_id_seq'::regclass);


--
-- TOC entry 3842 (class 2604 OID 162820568)
-- Name: assessment_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_type ALTER COLUMN id SET DEFAULT nextval('public.assessment_type_id_seq'::regclass);


--
-- TOC entry 3853 (class 2604 OID 162820824)
-- Name: assessment_unit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit ALTER COLUMN id SET DEFAULT nextval('public.assessment_unit_id_seq'::regclass);


--
-- TOC entry 3846 (class 2604 OID 162820600)
-- Name: assessment_unit_bundles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_bundles ALTER COLUMN id SET DEFAULT nextval('public.assessment_unit_bundles_id_seq'::regclass);


--
-- TOC entry 3854 (class 2604 OID 162820832)
-- Name: assessment_unit_selected_lo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_lo ALTER COLUMN id SET DEFAULT nextval('public.assessment_unit_selected_lo_id_seq'::regclass);


--
-- TOC entry 3855 (class 2604 OID 162820840)
-- Name: assessment_unit_selected_question id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_question ALTER COLUMN id SET DEFAULT nextval('public.assessment_unit_selected_question_id_seq'::regclass);


--
-- TOC entry 3856 (class 2604 OID 162820848)
-- Name: assessment_unit_selected_unit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_unit ALTER COLUMN id SET DEFAULT nextval('public.assessment_unit_selected_unit_id_seq'::regclass);


--
-- TOC entry 3758 (class 2604 OID 21223043)
-- Name: attendance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN id SET DEFAULT nextval('public.attendance_id_seq'::regclass);


--
-- TOC entry 3885 (class 2604 OID 277984535)
-- Name: attendance_sms_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_sms_logs ALTER COLUMN id SET DEFAULT nextval('public.attendance_sms_logs_id_seq'::regclass);


--
-- TOC entry 3866 (class 2604 OID 170512769)
-- Name: attendance_teacher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_teacher ALTER COLUMN id SET DEFAULT nextval('public.attendance_teacher_id_seq'::regclass);


--
-- TOC entry 3716 (class 2604 OID 32935)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 3717 (class 2604 OID 32945)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 3715 (class 2604 OID 32927)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 3718 (class 2604 OID 32953)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 3719 (class 2604 OID 32963)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 3720 (class 2604 OID 32971)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 3880 (class 2604 OID 196048101)
-- Name: cdac_sms_input id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cdac_sms_input ALTER COLUMN id SET DEFAULT nextval('public.cdac_sms_input_id_seq'::regclass);


--
-- TOC entry 3863 (class 2604 OID 163754470)
-- Name: celery_duplicate_remove id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.celery_duplicate_remove ALTER COLUMN id SET DEFAULT nextval('public.server_celeryduplicateremove_id_seq'::regclass);


--
-- TOC entry 3852 (class 2604 OID 162820816)
-- Name: class_level_component_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_level_component_submission ALTER COLUMN id SET DEFAULT nextval('public.class_level_component_submission_id_seq'::regclass);


--
-- TOC entry 3857 (class 2604 OID 162821035)
-- Name: class_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission ALTER COLUMN id SET DEFAULT nextval('public.class_submission_id_seq'::regclass);


--
-- TOC entry 3840 (class 2604 OID 162820552)
-- Name: component id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component ALTER COLUMN id SET DEFAULT nextval('public.component_id_seq'::regclass);


--
-- TOC entry 3841 (class 2604 OID 162820560)
-- Name: component_subjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_subjects ALTER COLUMN id SET DEFAULT nextval('public.component_subjects_id_seq'::regclass);


--
-- TOC entry 3851 (class 2604 OID 162820808)
-- Name: component_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_submission ALTER COLUMN id SET DEFAULT nextval('public.component_submission_id_seq'::regclass);


--
-- TOC entry 3828 (class 2604 OID 162820447)
-- Name: component_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_type ALTER COLUMN id SET DEFAULT nextval('public.component_type_id_seq'::regclass);


--
-- TOC entry 3801 (class 2604 OID 153870420)
-- Name: corporate_donor_devices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_donor_devices ALTER COLUMN id SET DEFAULT nextval('public.corporate_donor_devices_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 33064)
-- Name: dashboard_userdashboardmodule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_userdashboardmodule ALTER COLUMN id SET DEFAULT nextval('public.dashboard_userdashboardmodule_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 33116)
-- Name: deadline id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deadline ALTER COLUMN id SET DEFAULT nextval('public.deadline_id_seq'::regclass);


--
-- TOC entry 3795 (class 2604 OID 130745910)
-- Name: device_demand_response id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_demand_response ALTER COLUMN id SET DEFAULT nextval('public.device_demand_response_id_seq'::regclass);


--
-- TOC entry 3800 (class 2604 OID 153941494)
-- Name: device_donation_corporates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_donation_corporates ALTER COLUMN id SET DEFAULT nextval('public.device_donation_corporates_id_seq'::regclass);


--
-- TOC entry 3792 (class 2604 OID 118521834)
-- Name: device_donation_donor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_donation_donor ALTER COLUMN id SET DEFAULT nextval('public.device_donation_donor_id_seq'::regclass);


--
-- TOC entry 3820 (class 2604 OID 157858336)
-- Name: device_verification_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records ALTER COLUMN id SET DEFAULT nextval('public.device_verification_records_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 33031)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 3791 (class 2604 OID 37714526)
-- Name: django_celery_results_chordcounter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_chordcounter ALTER COLUMN id SET DEFAULT nextval('public.django_celery_results_chordcounter_id_seq'::regclass);


--
-- TOC entry 3864 (class 2604 OID 164149624)
-- Name: django_celery_results_groupresult id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_groupresult ALTER COLUMN id SET DEFAULT nextval('public.django_celery_results_groupresult_id_seq'::regclass);


--
-- TOC entry 3790 (class 2604 OID 37714485)
-- Name: django_celery_results_taskresult id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_taskresult ALTER COLUMN id SET DEFAULT nextval('public.django_celery_results_taskresult_id_seq'::regclass);


--
-- TOC entry 3714 (class 2604 OID 32917)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 3713 (class 2604 OID 32906)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 3921 (class 2604 OID 278029838)
-- Name: document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document ALTER COLUMN id SET DEFAULT nextval('public.document_id_seq'::regclass);


--
-- TOC entry 3748 (class 2604 OID 21198013)
-- Name: enrollment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment ALTER COLUMN id SET DEFAULT nextval('public.server_enrollment_id_seq'::regclass);


--
-- TOC entry 3829 (class 2604 OID 162820455)
-- Name: evaluation_param id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_param ALTER COLUMN id SET DEFAULT nextval('public.evaluation_param_id_seq'::regclass);


--
-- TOC entry 3922 (class 2604 OID 278029924)
-- Name: event_trail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail ALTER COLUMN id SET DEFAULT nextval('public.event_trail_id_seq'::regclass);


--
-- TOC entry 3923 (class 2604 OID 278029935)
-- Name: event_trail_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail_documents ALTER COLUMN id SET DEFAULT nextval('public.event_trail_documents_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 33124)
-- Name: grade id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade ALTER COLUMN id SET DEFAULT nextval('public.grade_id_seq'::regclass);


--
-- TOC entry 3728 (class 2604 OID 33132)
-- Name: grade_assessment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_assessment ALTER COLUMN id SET DEFAULT nextval('public.grade_assessment_id_seq'::regclass);


--
-- TOC entry 3723 (class 2604 OID 33077)
-- Name: jet_bookmark id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jet_bookmark ALTER COLUMN id SET DEFAULT nextval('public.jet_bookmark_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 33086)
-- Name: jet_pinnedapplication id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jet_pinnedapplication ALTER COLUMN id SET DEFAULT nextval('public.jet_pinnedapplication_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 33142)
-- Name: lo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo ALTER COLUMN id SET DEFAULT nextval('public.lo_id_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 34140)
-- Name: lo_assessment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_assessment ALTER COLUMN id SET DEFAULT nextval('public.lo_assessment_id_seq'::regclass);


--
-- TOC entry 3838 (class 2604 OID 162820536)
-- Name: lo_bundle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle ALTER COLUMN id SET DEFAULT nextval('public.lo_bundle_id_seq'::regclass);


--
-- TOC entry 3839 (class 2604 OID 162820544)
-- Name: lo_bundle_los id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle_los ALTER COLUMN id SET DEFAULT nextval('public.lo_bundle_lo_id_seq'::regclass);


--
-- TOC entry 3740 (class 2604 OID 33253)
-- Name: lo_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_submission ALTER COLUMN id SET DEFAULT nextval('public.lo_submission_id_seq'::regclass);


--
-- TOC entry 3830 (class 2604 OID 162820463)
-- Name: lo_v2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_v2 ALTER COLUMN id SET DEFAULT nextval('public.lo_v2_id_seq'::regclass);


--
-- TOC entry 3730 (class 2604 OID 33153)
-- Name: location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN id SET DEFAULT nextval('public.location_id_seq'::regclass);


--
-- TOC entry 3850 (class 2604 OID 162820792)
-- Name: mapping id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping ALTER COLUMN id SET DEFAULT nextval('public.mapping_id_seq'::regclass);


--
-- TOC entry 3848 (class 2604 OID 162820773)
-- Name: mapping_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_details ALTER COLUMN id SET DEFAULT nextval('public.mapping_details_id_seq'::regclass);


--
-- TOC entry 3849 (class 2604 OID 162820784)
-- Name: mapping_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_submission ALTER COLUMN id SET DEFAULT nextval('public.mapping_submission_id_seq'::regclass);


--
-- TOC entry 3745 (class 2604 OID 215885)
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- TOC entry 3743 (class 2604 OID 33465)
-- Name: odk_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odk_submission ALTER COLUMN id SET DEFAULT nextval('public.odk_submission_id_seq'::regclass);


--
-- TOC entry 3762 (class 2604 OID 22570237)
-- Name: old_assessment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_assessment ALTER COLUMN id SET DEFAULT nextval('public.old_assessment_id_seq'::regclass);


--
-- TOC entry 3763 (class 2604 OID 22570246)
-- Name: old_lo_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_lo_master ALTER COLUMN id SET DEFAULT nextval('public.old_lo_master_id_seq'::regclass);


--
-- TOC entry 3764 (class 2604 OID 22570257)
-- Name: old_lo_submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_lo_submissions ALTER COLUMN id SET DEFAULT nextval('public.old_lo_submissions_id_seq'::regclass);


--
-- TOC entry 3765 (class 2604 OID 22570268)
-- Name: old_schools id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_schools ALTER COLUMN id SET DEFAULT nextval('public.old_schools_id_seq'::regclass);


--
-- TOC entry 3739 (class 2604 OID 33242)
-- Name: question id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question ALTER COLUMN id SET DEFAULT nextval('public.question_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 3378788)
-- Name: question_assessment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_assessment ALTER COLUMN id SET DEFAULT nextval('public.question_assessment_id_seq'::regclass);


--
-- TOC entry 3836 (class 2604 OID 162820520)
-- Name: question_bundle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle ALTER COLUMN id SET DEFAULT nextval('public.question_bundle_id_seq'::regclass);


--
-- TOC entry 3837 (class 2604 OID 162820528)
-- Name: question_bundle_questions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle_questions ALTER COLUMN id SET DEFAULT nextval('public.question_bundle_question_id_seq'::regclass);


--
-- TOC entry 3738 (class 2604 OID 33234)
-- Name: question_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_submission ALTER COLUMN id SET DEFAULT nextval('public.question_submission_id_seq'::regclass);


--
-- TOC entry 3831 (class 2604 OID 162820474)
-- Name: question_v2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_v2 ALTER COLUMN id SET DEFAULT nextval('public.question_v2_id_seq'::regclass);


--
-- TOC entry 3747 (class 2604 OID 14701048)
-- Name: questions_submission_expanded id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions_submission_expanded ALTER COLUMN id SET DEFAULT nextval('public.server_questionsubmissionview_id_seq'::regclass);


--
-- TOC entry 3798 (class 2604 OID 153634767)
-- Name: sample_test id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_test ALTER COLUMN id SET DEFAULT nextval('public.sample_test_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 33161)
-- Name: school id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school ALTER COLUMN id SET DEFAULT nextval('public.school_id_seq'::regclass);


--
-- TOC entry 3788 (class 2604 OID 37714294)
-- Name: school_cache id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_cache ALTER COLUMN id SET DEFAULT nextval('public.school_cache_id_seq'::regclass);


--
-- TOC entry 3732 (class 2604 OID 33171)
-- Name: school_grade id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_grade ALTER COLUMN id SET DEFAULT nextval('public.school_grade_id_seq'::regclass);


--
-- TOC entry 3884 (class 2604 OID 277977748)
-- Name: school_location_mapping id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_location_mapping ALTER COLUMN id SET DEFAULT nextval('public.school_location_mapping_id_seq'::regclass);


--
-- TOC entry 3861 (class 2604 OID 163012206)
-- Name: school_wise_daily_enrolment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_wise_daily_enrolment ALTER COLUMN id SET DEFAULT nextval('public.school_wise_daily_enrolment_id_seq'::regclass);


--
-- TOC entry 3810 (class 2604 OID 154025486)
-- Name: server_logroup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup ALTER COLUMN id SET DEFAULT nextval('public.server_logroup_id_seq'::regclass);


--
-- TOC entry 3811 (class 2604 OID 154025494)
-- Name: server_logroup_lo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup_lo ALTER COLUMN id SET DEFAULT nextval('public.server_logroup_lo_id_seq'::regclass);


--
-- TOC entry 3807 (class 2604 OID 154025450)
-- Name: server_marksrange id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_marksrange ALTER COLUMN id SET DEFAULT nextval('public.server_marksrange_id_seq'::regclass);


--
-- TOC entry 3808 (class 2604 OID 154025470)
-- Name: server_questiongroup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup ALTER COLUMN id SET DEFAULT nextval('public.server_questiongroup_id_seq'::regclass);


--
-- TOC entry 3809 (class 2604 OID 154025478)
-- Name: server_questiongroup_question id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup_question ALTER COLUMN id SET DEFAULT nextval('public.server_questiongroup_question_id_seq'::regclass);


--
-- TOC entry 3759 (class 2604 OID 21223132)
-- Name: silk_profile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile ALTER COLUMN id SET DEFAULT nextval('public.silk_profile_id_seq'::regclass);


--
-- TOC entry 3761 (class 2604 OID 21223172)
-- Name: silk_profile_queries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile_queries ALTER COLUMN id SET DEFAULT nextval('public.silk_profile_queries_id_seq'::regclass);


--
-- TOC entry 3760 (class 2604 OID 21223161)
-- Name: silk_sqlquery id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_sqlquery ALTER COLUMN id SET DEFAULT nextval('public.silk_sqlquery_id_seq'::regclass);


--
-- TOC entry 3737 (class 2604 OID 33221)
-- Name: sms id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms ALTER COLUMN id SET DEFAULT nextval('public.sms_id_seq'::regclass);


--
-- TOC entry 3865 (class 2604 OID 164353386)
-- Name: sms_dag_reports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_dag_reports ALTER COLUMN id SET DEFAULT nextval('public.sms_dag_reports_id_seq'::regclass);


--
-- TOC entry 3916 (class 2604 OID 278019756)
-- Name: sms_track id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_track ALTER COLUMN id SET DEFAULT nextval('public.sms_track_id_seq'::regclass);


--
-- TOC entry 3876 (class 2604 OID 180722158)
-- Name: ss_school_allocation_data id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_data ALTER COLUMN id SET DEFAULT nextval('public.ss_school_allocation_data_id_seq'::regclass);


--
-- TOC entry 3873 (class 2604 OID 180722094)
-- Name: ss_school_allocation_quarter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_quarter ALTER COLUMN id SET DEFAULT nextval('public.ss_school_allocation_quarter_id_seq'::regclass);


--
-- TOC entry 3755 (class 2604 OID 21222961)
-- Name: static id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.static ALTER COLUMN id SET DEFAULT nextval('public.static_id_seq'::regclass);


--
-- TOC entry 3736 (class 2604 OID 33205)
-- Name: stream id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream ALTER COLUMN id SET DEFAULT nextval('public."Stream_id_seq"'::regclass);


--
-- TOC entry 3749 (class 2604 OID 21198047)
-- Name: stream_common_subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_common_subject ALTER COLUMN id SET DEFAULT nextval('public.stream_common_subject_id_seq'::regclass);


--
-- TOC entry 3750 (class 2604 OID 21198055)
-- Name: stream_optional_subjects_1 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_1 ALTER COLUMN id SET DEFAULT nextval('public.stream_optional_subjects_1_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 21198063)
-- Name: stream_optional_subjects_2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_2 ALTER COLUMN id SET DEFAULT nextval('public.stream_optional_subjects_2_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 21198071)
-- Name: stream_optional_subjects_3 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_3 ALTER COLUMN id SET DEFAULT nextval('public.stream_optional_subjects_3_id_seq'::regclass);


--
-- TOC entry 3753 (class 2604 OID 21198079)
-- Name: stream_optional_subjects_4 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_4 ALTER COLUMN id SET DEFAULT nextval('public.stream_optional_subjects_4_id_seq'::regclass);


--
-- TOC entry 3735 (class 2604 OID 33197)
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public."Student_id_seq"'::regclass);


--
-- TOC entry 3869 (class 2604 OID 171077453)
-- Name: student_content_share id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_content_share ALTER COLUMN id SET DEFAULT nextval('public.student_content_share_id_seq'::regclass);


--
-- TOC entry 3924 (class 2604 OID 278029943)
-- Name: student_document id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_document ALTER COLUMN id SET DEFAULT nextval('public.student_document_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 21198112)
-- Name: student_subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject ALTER COLUMN id SET DEFAULT nextval('public.student_subject_id_seq'::regclass);


--
-- TOC entry 3742 (class 2604 OID 33427)
-- Name: student_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission ALTER COLUMN id SET DEFAULT nextval('public.student_submission_id_seq'::regclass);


--
-- TOC entry 3858 (class 2604 OID 162821687)
-- Name: student_submission_v2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2 ALTER COLUMN id SET DEFAULT nextval('public.student_submission_v2_id_seq'::regclass);


--
-- TOC entry 3859 (class 2604 OID 162821695)
-- Name: student_submission_v2_marks_submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2_marks_submissions ALTER COLUMN id SET DEFAULT nextval('public.student_submission_v2_marks_submissions_id_seq'::regclass);


--
-- TOC entry 3733 (class 2604 OID 33179)
-- Name: subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject ALTER COLUMN id SET DEFAULT nextval('public.subject_id_seq'::regclass);


--
-- TOC entry 3767 (class 2604 OID 32010075)
-- Name: subject_submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission ALTER COLUMN id SET DEFAULT nextval('public.subject_submission_id_seq'::regclass);


--
-- TOC entry 3768 (class 2604 OID 32010089)
-- Name: subject_submission_selected_lo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission_selected_lo ALTER COLUMN id SET DEFAULT nextval('public.subject_submission_selected_lo_id_seq'::regclass);


--
-- TOC entry 3918 (class 2604 OID 278019771)
-- Name: submission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission ALTER COLUMN id SET DEFAULT nextval('public.submission_id_seq'::regclass);


--
-- TOC entry 3734 (class 2604 OID 33189)
-- Name: submission_summary id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_summary ALTER COLUMN id SET DEFAULT nextval('public.submission_summary_id_seq'::regclass);


--
-- TOC entry 3832 (class 2604 OID 162820485)
-- Name: submission_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_type ALTER COLUMN id SET DEFAULT nextval('public.submission_type_id_seq'::regclass);


--
-- TOC entry 3817 (class 2604 OID 154025765)
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.server_teacher_id_seq'::regclass);


--
-- TOC entry 3819 (class 2604 OID 157801451)
-- Name: teacher_registration_compliance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_registration_compliance ALTER COLUMN id SET DEFAULT nextval('public.teacher_registration_compliance_id_seq'::regclass);


--
-- TOC entry 3818 (class 2604 OID 154025773)
-- Name: teacher_subjects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects ALTER COLUMN id SET DEFAULT nextval('public.server_teacher_subjects_id_seq'::regclass);


--
-- TOC entry 3799 (class 2604 OID 153776044)
-- Name: test_telemetry id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_telemetry ALTER COLUMN id SET DEFAULT nextval('public.test_telemetry_id_seq'::regclass);


--
-- TOC entry 3834 (class 2604 OID 162820504)
-- Name: unit_bundle id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle ALTER COLUMN id SET DEFAULT nextval('public.unit_bundle_id_seq'::regclass);


--
-- TOC entry 3835 (class 2604 OID 162820512)
-- Name: unit_bundle_units id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle_units ALTER COLUMN id SET DEFAULT nextval('public.unit_bundle_unit_id_seq'::regclass);


--
-- TOC entry 3833 (class 2604 OID 162820493)
-- Name: unit_v2 id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_v2 ALTER COLUMN id SET DEFAULT nextval('public.unit_v2_id_seq'::regclass);


--
-- TOC entry 4032 (class 2606 OID 33207)
-- Name: stream Stream_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream
    ADD CONSTRAINT "Stream_pkey" PRIMARY KEY (id);


--
-- TOC entry 4023 (class 2606 OID 33199)
-- Name: student Student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "Student_pkey" PRIMARY KEY (id);


--
-- TOC entry 4266 (class 2606 OID 154025417)
-- Name: assessment_au_lo_aggregate assessment_au_lo_aggregate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate
    ADD CONSTRAINT assessment_au_lo_aggregate_pkey PRIMARY KEY (id);


--
-- TOC entry 4327 (class 2606 OID 154025536)
-- Name: assessment_au_lo_aggregate_submission assessment_au_lo_aggregate_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate_submission
    ADD CONSTRAINT assessment_au_lo_aggregate_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4322 (class 2606 OID 154025528)
-- Name: assessment_au_question_aggregate assessment_au_question_aggregate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate
    ADD CONSTRAINT assessment_au_question_aggregate_pkey PRIMARY KEY (id);


--
-- TOC entry 4317 (class 2606 OID 154025520)
-- Name: assessment_au_question_aggregate_submission assessment_au_question_aggregate_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate_submission
    ADD CONSTRAINT assessment_au_question_aggregate_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4429 (class 2606 OID 162820767)
-- Name: assessment_builder assessment_builder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_builder
    ADD CONSTRAINT assessment_builder_pkey PRIMARY KEY (id);


--
-- TOC entry 4221 (class 2606 OID 37714310)
-- Name: assessment_cache assessment_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache
    ADD CONSTRAINT assessment_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 70660927)
-- Name: assessment_cache assessment_cache_school_id_assessment_id_9084dd95_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache
    ADD CONSTRAINT assessment_cache_school_id_assessment_id_9084dd95_uniq UNIQUE (school_id, assessment_id);


--
-- TOC entry 4514 (class 2606 OID 163928068)
-- Name: assessment_cache_v5 assessment_cache_v5_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache_v5
    ADD CONSTRAINT assessment_cache_v5_pkey PRIMARY KEY (assessment_id, school_id);


--
-- TOC entry 4516 (class 2606 OID 163512773)
-- Name: assessment_cache_v5 assessment_cache_v5_school_id_assessment_id_7820243f_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache_v5
    ADD CONSTRAINT assessment_cache_v5_school_id_assessment_id_7820243f_uniq UNIQUE (school_id, assessment_id);


--
-- TOC entry 4352 (class 2606 OID 162820441)
-- Name: assessment_category assessment_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_category
    ADD CONSTRAINT assessment_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4405 (class 2606 OID 162820700)
-- Name: assessment_components assessment_components_assessment_id_components_id_d6f08a1a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_components
    ADD CONSTRAINT assessment_components_assessment_id_components_id_d6f08a1a_uniq UNIQUE (assessment_id, components_id);


--
-- TOC entry 4409 (class 2606 OID 162820578)
-- Name: assessment_components assessment_components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_components
    ADD CONSTRAINT assessment_components_pkey PRIMARY KEY (id);


--
-- TOC entry 4270 (class 2606 OID 154025425)
-- Name: assessment_ep_grade assessment_ep_grade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade
    ADD CONSTRAINT assessment_ep_grade_pkey PRIMARY KEY (id);


--
-- TOC entry 4308 (class 2606 OID 154025512)
-- Name: assessment_ep_grade_submission assessment_ep_grade_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4274 (class 2606 OID 154025433)
-- Name: assessment_ep_marks assessment_ep_marks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks
    ADD CONSTRAINT assessment_ep_marks_pkey PRIMARY KEY (id);


--
-- TOC entry 4299 (class 2606 OID 154025504)
-- Name: assessment_ep_marks_submission assessment_ep_marks_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4064 (class 2606 OID 33419)
-- Name: assessment_grade assessment_grade_assessment_id_grade_id_0e2a0f97_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade
    ADD CONSTRAINT assessment_grade_assessment_id_grade_id_0e2a0f97_uniq UNIQUE (assessment_id, grade_id);


--
-- TOC entry 4276 (class 2606 OID 154025444)
-- Name: assessment_grade_mapping assessment_grade_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade_mapping
    ADD CONSTRAINT assessment_grade_mapping_pkey PRIMARY KEY (id);


--
-- TOC entry 4067 (class 2606 OID 33263)
-- Name: assessment_grade assessment_grade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade
    ADD CONSTRAINT assessment_grade_pkey PRIMARY KEY (id);


--
-- TOC entry 4412 (class 2606 OID 162820714)
-- Name: assessment_lo_bundles assessment_lo_bundles_assessment_id_lobundle_id_d09ea9cb_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_lo_bundles
    ADD CONSTRAINT assessment_lo_bundles_assessment_id_lobundle_id_d09ea9cb_uniq UNIQUE (assessment_id, lobundle_id);


--
-- TOC entry 4415 (class 2606 OID 162820586)
-- Name: assessment_lo_bundles assessment_lo_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_lo_bundles
    ADD CONSTRAINT assessment_lo_bundles_pkey PRIMARY KEY (id);


--
-- TOC entry 3984 (class 2606 OID 33110)
-- Name: assessment assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT assessment_pkey PRIMARY KEY (id);


--
-- TOC entry 4417 (class 2606 OID 162820728)
-- Name: assessment_question_bundles assessment_question_bund_assessment_id_questionbu_6389e572_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_question_bundles
    ADD CONSTRAINT assessment_question_bund_assessment_id_questionbu_6389e572_uniq UNIQUE (assessment_id, questionbundle_id);


--
-- TOC entry 4420 (class 2606 OID 162820594)
-- Name: assessment_question_bundles assessment_question_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_question_bundles
    ADD CONSTRAINT assessment_question_bundles_pkey PRIMARY KEY (id);


--
-- TOC entry 4548 (class 2606 OID 250061044)
-- Name: assessment_result assessment_result_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_result
    ADD CONSTRAINT assessment_result_pkey PRIMARY KEY (id);


--
-- TOC entry 4194 (class 2606 OID 31837356)
-- Name: assessment_stream assessment_stream_assessment_id_stream_id_da8a2d6c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_stream
    ADD CONSTRAINT assessment_stream_assessment_id_stream_id_da8a2d6c_uniq UNIQUE (assessment_id, stream_id);


--
-- TOC entry 4196 (class 2606 OID 31837303)
-- Name: assessment_stream assessment_stream_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_stream
    ADD CONSTRAINT assessment_stream_pkey PRIMARY KEY (id);


--
-- TOC entry 4504 (class 2606 OID 162821997)
-- Name: assessment_subjects assessment_subject_assessment_id_subject_id_c9fe3209_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_subjects
    ADD CONSTRAINT assessment_subject_assessment_id_subject_id_c9fe3209_uniq UNIQUE (assessment_id, subject_id);


--
-- TOC entry 4506 (class 2606 OID 162821985)
-- Name: assessment_subjects assessment_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_subjects
    ADD CONSTRAINT assessment_subject_pkey PRIMARY KEY (id);


--
-- TOC entry 4403 (class 2606 OID 162820570)
-- Name: assessment_type assessment_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_type
    ADD CONSTRAINT assessment_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4424 (class 2606 OID 162820754)
-- Name: assessment_unit_bundles assessment_unit_bundles_assessment_id_unitbundle_4b6c5068_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_bundles
    ADD CONSTRAINT assessment_unit_bundles_assessment_id_unitbundle_4b6c5068_uniq UNIQUE (assessment_id, unitbundle_id);


--
-- TOC entry 4426 (class 2606 OID 162820602)
-- Name: assessment_unit_bundles assessment_unit_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_bundles
    ADD CONSTRAINT assessment_unit_bundles_pkey PRIMARY KEY (id);


--
-- TOC entry 4454 (class 2606 OID 162820826)
-- Name: assessment_unit assessment_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit
    ADD CONSTRAINT assessment_unit_pkey PRIMARY KEY (id);


--
-- TOC entry 4458 (class 2606 OID 162820972)
-- Name: assessment_unit_selected_lo assessment_unit_selected_assessmentunit_id_lo_v2__45982108_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_lo
    ADD CONSTRAINT assessment_unit_selected_assessmentunit_id_lo_v2__45982108_uniq UNIQUE (assessmentunit_id, lo_v2_id);


--
-- TOC entry 4464 (class 2606 OID 162820986)
-- Name: assessment_unit_selected_question assessment_unit_selected_assessmentunit_id_questi_d9463f4c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_question
    ADD CONSTRAINT assessment_unit_selected_assessmentunit_id_questi_d9463f4c_uniq UNIQUE (assessmentunit_id, question_v2_id);


--
-- TOC entry 4470 (class 2606 OID 162821000)
-- Name: assessment_unit_selected_unit assessment_unit_selected_assessmentunit_id_unit_v_5fb9cf49_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_unit
    ADD CONSTRAINT assessment_unit_selected_assessmentunit_id_unit_v_5fb9cf49_uniq UNIQUE (assessmentunit_id, unit_v2_id);


--
-- TOC entry 4462 (class 2606 OID 162820834)
-- Name: assessment_unit_selected_lo assessment_unit_selected_lo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_lo
    ADD CONSTRAINT assessment_unit_selected_lo_pkey PRIMARY KEY (id);


--
-- TOC entry 4467 (class 2606 OID 162820842)
-- Name: assessment_unit_selected_question assessment_unit_selected_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_question
    ADD CONSTRAINT assessment_unit_selected_question_pkey PRIMARY KEY (id);


--
-- TOC entry 4473 (class 2606 OID 162820850)
-- Name: assessment_unit_selected_unit assessment_unit_selected_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_unit
    ADD CONSTRAINT assessment_unit_selected_unit_pkey PRIMARY KEY (id);


--
-- TOC entry 4151 (class 2606 OID 21223045)
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- TOC entry 4562 (class 2606 OID 277984541)
-- Name: attendance_sms_logs attendance_sms_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_sms_logs
    ADD CONSTRAINT attendance_sms_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4154 (class 2606 OID 67193219)
-- Name: attendance attendance_student_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_date_key UNIQUE (student_id, date);


--
-- TOC entry 4534 (class 2606 OID 170512776)
-- Name: attendance_teacher attendance_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_teacher
    ADD CONSTRAINT attendance_teacher_pkey PRIMARY KEY (id);


--
-- TOC entry 3944 (class 2606 OID 33057)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 3949 (class 2606 OID 32994)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 3952 (class 2606 OID 32947)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3946 (class 2606 OID 32937)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3939 (class 2606 OID 32980)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 3941 (class 2606 OID 32929)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3960 (class 2606 OID 32965)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3963 (class 2606 OID 33009)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 3954 (class 2606 OID 32955)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3966 (class 2606 OID 32973)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3969 (class 2606 OID 33023)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 3957 (class 2606 OID 33051)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 4546 (class 2606 OID 196048106)
-- Name: cdac_sms_input cdac_sms_input_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cdac_sms_input
    ADD CONSTRAINT cdac_sms_input_pkey PRIMARY KEY (id);


--
-- TOC entry 4449 (class 2606 OID 162820818)
-- Name: class_level_component_submission class_level_component_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_level_component_submission
    ADD CONSTRAINT class_level_component_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4480 (class 2606 OID 162821037)
-- Name: class_submission class_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4394 (class 2606 OID 162820554)
-- Name: component component_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT component_pkey PRIMARY KEY (id);


--
-- TOC entry 4397 (class 2606 OID 162820680)
-- Name: component_subjects component_subjects_components_id_subject_id_7e9365e9_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_subjects
    ADD CONSTRAINT component_subjects_components_id_subject_id_7e9365e9_uniq UNIQUE (components_id, subject_id);


--
-- TOC entry 4399 (class 2606 OID 162820562)
-- Name: component_subjects component_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_subjects
    ADD CONSTRAINT component_subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 4444 (class 2606 OID 162820810)
-- Name: component_submission component_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_submission
    ADD CONSTRAINT component_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4354 (class 2606 OID 162820449)
-- Name: component_type component_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_type
    ADD CONSTRAINT component_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4260 (class 2606 OID 157858362)
-- Name: corporate_donor_devices corporate_donor_devices_device_tracking_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_donor_devices
    ADD CONSTRAINT corporate_donor_devices_device_tracking_key_key UNIQUE (device_tracking_key);


--
-- TOC entry 4262 (class 2606 OID 153870425)
-- Name: corporate_donor_devices corporate_donor_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_donor_devices
    ADD CONSTRAINT corporate_donor_devices_pkey PRIMARY KEY (id);


--
-- TOC entry 4350 (class 2606 OID 162402524)
-- Name: dashboard_role_access_config dashboard_role_access_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_role_access_config
    ADD CONSTRAINT dashboard_role_access_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3975 (class 2606 OID 33071)
-- Name: dashboard_userdashboardmodule dashboard_userdashboardmodule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_userdashboardmodule
    ADD CONSTRAINT dashboard_userdashboardmodule_pkey PRIMARY KEY (id);


--
-- TOC entry 3988 (class 2606 OID 33118)
-- Name: deadline deadline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deadline
    ADD CONSTRAINT deadline_pkey PRIMARY KEY (id);


--
-- TOC entry 4348 (class 2606 OID 162401972)
-- Name: designation_scope_mapping designation_scope_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designation_scope_mapping
    ADD CONSTRAINT designation_scope_mapping_pkey PRIMARY KEY (id);


--
-- TOC entry 4246 (class 2606 OID 130745920)
-- Name: device_demand_response device_demand_response_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_demand_response
    ADD CONSTRAINT device_demand_response_pkey PRIMARY KEY (id);


--
-- TOC entry 4258 (class 2606 OID 153870323)
-- Name: device_donation_corporates device_donation_corporates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_donation_corporates
    ADD CONSTRAINT device_donation_corporates_pkey PRIMARY KEY (company_id);


--
-- TOC entry 4242 (class 2606 OID 120264413)
-- Name: device_donation_donor device_donation_donor_device_tracking_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_donation_donor
    ADD CONSTRAINT device_donation_donor_device_tracking_id_key UNIQUE (device_tracking_key);


--
-- TOC entry 4244 (class 2606 OID 118521841)
-- Name: device_donation_donor device_donation_donor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_donation_donor
    ADD CONSTRAINT device_donation_donor_pkey PRIMARY KEY (id);


--
-- TOC entry 4342 (class 2606 OID 157858345)
-- Name: device_verification_records device_verification_records_device_tracking_key_corporate_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records
    ADD CONSTRAINT device_verification_records_device_tracking_key_corporate_key UNIQUE (device_tracking_key_corporate);


--
-- TOC entry 4344 (class 2606 OID 157858347)
-- Name: device_verification_records device_verification_records_device_tracking_key_individual_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records
    ADD CONSTRAINT device_verification_records_device_tracking_key_individual_key UNIQUE (device_tracking_key_individual);


--
-- TOC entry 4346 (class 2606 OID 157858343)
-- Name: device_verification_records device_verification_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records
    ADD CONSTRAINT device_verification_records_pkey PRIMARY KEY (id);


--
-- TOC entry 3972 (class 2606 OID 33037)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4238 (class 2606 OID 37714534)
-- Name: django_celery_results_chordcounter django_celery_results_chordcounter_group_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_chordcounter
    ADD CONSTRAINT django_celery_results_chordcounter_group_id_key UNIQUE (group_id);


--
-- TOC entry 4240 (class 2606 OID 37714532)
-- Name: django_celery_results_chordcounter django_celery_results_chordcounter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_chordcounter
    ADD CONSTRAINT django_celery_results_chordcounter_pkey PRIMARY KEY (id);


--
-- TOC entry 4528 (class 2606 OID 164149631)
-- Name: django_celery_results_groupresult django_celery_results_groupresult_group_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_groupresult
    ADD CONSTRAINT django_celery_results_groupresult_group_id_key UNIQUE (group_id);


--
-- TOC entry 4530 (class 2606 OID 164149629)
-- Name: django_celery_results_groupresult django_celery_results_groupresult_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_groupresult
    ADD CONSTRAINT django_celery_results_groupresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4232 (class 2606 OID 37714490)
-- Name: django_celery_results_taskresult django_celery_results_taskresult_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_taskresult
    ADD CONSTRAINT django_celery_results_taskresult_pkey PRIMARY KEY (id);


--
-- TOC entry 4235 (class 2606 OID 37714492)
-- Name: django_celery_results_taskresult django_celery_results_taskresult_task_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_celery_results_taskresult
    ADD CONSTRAINT django_celery_results_taskresult_task_id_key UNIQUE (task_id);


--
-- TOC entry 3934 (class 2606 OID 32921)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 3936 (class 2606 OID 32919)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3932 (class 2606 OID 32911)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4085 (class 2606 OID 33506)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 4604 (class 2606 OID 278029843)
-- Name: document document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- TOC entry 4106 (class 2606 OID 21223120)
-- Name: enrollment enrollment_student_id_acad_year_df65ef62_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT enrollment_student_id_acad_year_df65ef62_uniq UNIQUE (student_id, acad_year);


--
-- TOC entry 4356 (class 2606 OID 162820457)
-- Name: evaluation_param evaluation_param_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_param
    ADD CONSTRAINT evaluation_param_pkey PRIMARY KEY (id);


--
-- TOC entry 4611 (class 2606 OID 278029937)
-- Name: event_trail_documents event_trail_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail_documents
    ADD CONSTRAINT event_trail_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4614 (class 2606 OID 278029969)
-- Name: event_trail_documents event_trail_documents_studenttrail_id_document_52f60416_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail_documents
    ADD CONSTRAINT event_trail_documents_studenttrail_id_document_52f60416_uniq UNIQUE (studenttrail_id, documents_id);


--
-- TOC entry 4606 (class 2606 OID 278029929)
-- Name: event_trail event_trail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail
    ADD CONSTRAINT event_trail_pkey PRIMARY KEY (id);


--
-- TOC entry 3994 (class 2606 OID 33136)
-- Name: grade_assessment grade_assessment_formId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_assessment
    ADD CONSTRAINT "grade_assessment_formId_key" UNIQUE (form_id);


--
-- TOC entry 3996 (class 2606 OID 33134)
-- Name: grade_assessment grade_assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_assessment
    ADD CONSTRAINT grade_assessment_pkey PRIMARY KEY (id);


--
-- TOC entry 3990 (class 2606 OID 33126)
-- Name: grade grade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT grade_pkey PRIMARY KEY (id);


--
-- TOC entry 4565 (class 2606 OID 277987287)
-- Name: group group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY ("groupId");


--
-- TOC entry 4567 (class 2606 OID 277987306)
-- Name: groupmembership groupmembership_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groupmembership
    ADD CONSTRAINT groupmembership_pkey PRIMARY KEY ("groupMembershipId");


--
-- TOC entry 3977 (class 2606 OID 33080)
-- Name: jet_bookmark jet_bookmark_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jet_bookmark
    ADD CONSTRAINT jet_bookmark_pkey PRIMARY KEY (id);


--
-- TOC entry 3979 (class 2606 OID 33089)
-- Name: jet_pinnedapplication jet_pinnedapplication_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jet_pinnedapplication
    ADD CONSTRAINT jet_pinnedapplication_pkey PRIMARY KEY (id);


--
-- TOC entry 4089 (class 2606 OID 34154)
-- Name: lo_assessment lo_assessment_lo_id_assessment_id_f2d05033_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_assessment
    ADD CONSTRAINT lo_assessment_lo_id_assessment_id_f2d05033_uniq UNIQUE (lo_id, assessment_id);


--
-- TOC entry 4092 (class 2606 OID 34142)
-- Name: lo_assessment lo_assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_assessment
    ADD CONSTRAINT lo_assessment_pkey PRIMARY KEY (id);


--
-- TOC entry 4389 (class 2606 OID 162820660)
-- Name: lo_bundle_los lo_bundle_lo_lobundle_id_lo_v2_id_f4fc4856_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle_los
    ADD CONSTRAINT lo_bundle_lo_lobundle_id_lo_v2_id_f4fc4856_uniq UNIQUE (lobundle_id, lo_v2_id);


--
-- TOC entry 4391 (class 2606 OID 162820546)
-- Name: lo_bundle_los lo_bundle_lo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle_los
    ADD CONSTRAINT lo_bundle_lo_pkey PRIMARY KEY (id);


--
-- TOC entry 4385 (class 2606 OID 162820538)
-- Name: lo_bundle lo_bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle
    ADD CONSTRAINT lo_bundle_pkey PRIMARY KEY (id);


--
-- TOC entry 4000 (class 2606 OID 33147)
-- Name: lo lo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo
    ADD CONSTRAINT lo_pkey PRIMARY KEY (id);


--
-- TOC entry 4060 (class 2606 OID 33255)
-- Name: lo_submission lo_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_submission
    ADD CONSTRAINT lo_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4358 (class 2606 OID 162820468)
-- Name: lo_v2 lo_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_v2
    ADD CONSTRAINT lo_v2_pkey PRIMARY KEY (id);


--
-- TOC entry 4003 (class 2606 OID 33155)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- TOC entry 4431 (class 2606 OID 162820778)
-- Name: mapping_details mapping_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_details
    ADD CONSTRAINT mapping_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4440 (class 2606 OID 162820794)
-- Name: mapping mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping
    ADD CONSTRAINT mapping_pkey PRIMARY KEY (id);


--
-- TOC entry 4435 (class 2606 OID 162820786)
-- Name: mapping_submission mapping_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_submission
    ADD CONSTRAINT mapping_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4569 (class 2606 OID 277987325)
-- Name: monitortracking monitortracking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitortracking
    ADD CONSTRAINT monitortracking_pkey PRIMARY KEY ("monitorTrackingId");


--
-- TOC entry 4214 (class 2606 OID 37713282)
-- Name: mystudent_testperformance mystudent_testperformance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mystudent_testperformance
    ADD CONSTRAINT mystudent_testperformance_pkey PRIMARY KEY (p_key);


--
-- TOC entry 4094 (class 2606 OID 215890)
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- TOC entry 4082 (class 2606 OID 33470)
-- Name: odk_submission odk_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.odk_submission
    ADD CONSTRAINT odk_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4185 (class 2606 OID 22570239)
-- Name: old_assessment old_assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_assessment
    ADD CONSTRAINT old_assessment_pkey PRIMARY KEY (id);


--
-- TOC entry 4187 (class 2606 OID 22570251)
-- Name: old_lo_master old_lo_master_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_lo_master
    ADD CONSTRAINT old_lo_master_pkey PRIMARY KEY (id);


--
-- TOC entry 4189 (class 2606 OID 22570262)
-- Name: old_lo_submissions old_lo_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_lo_submissions
    ADD CONSTRAINT old_lo_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4191 (class 2606 OID 22570270)
-- Name: old_schools old_schools_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.old_schools
    ADD CONSTRAINT old_schools_pkey PRIMARY KEY (id);


--
-- TOC entry 4250 (class 2606 OID 153075144)
-- Name: pgbench_accounts pgbench_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgbench_accounts
    ADD CONSTRAINT pgbench_accounts_pkey PRIMARY KEY (aid);


--
-- TOC entry 4252 (class 2606 OID 153075140)
-- Name: pgbench_branches pgbench_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgbench_branches
    ADD CONSTRAINT pgbench_branches_pkey PRIMARY KEY (bid);


--
-- TOC entry 4248 (class 2606 OID 153075142)
-- Name: pgbench_tellers pgbench_tellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pgbench_tellers
    ADD CONSTRAINT pgbench_tellers_pkey PRIMARY KEY (tid);


--
-- TOC entry 4097 (class 2606 OID 3378790)
-- Name: question_assessment question_assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_assessment
    ADD CONSTRAINT question_assessment_pkey PRIMARY KEY (id);


--
-- TOC entry 4099 (class 2606 OID 3378803)
-- Name: question_assessment question_assessment_question_id_assessment_id_ea71dde4_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_assessment
    ADD CONSTRAINT question_assessment_question_id_assessment_id_ea71dde4_uniq UNIQUE (question_id, assessment_id);


--
-- TOC entry 4377 (class 2606 OID 162820522)
-- Name: question_bundle question_bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle
    ADD CONSTRAINT question_bundle_pkey PRIMARY KEY (id);


--
-- TOC entry 4379 (class 2606 OID 162820530)
-- Name: question_bundle_questions question_bundle_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle_questions
    ADD CONSTRAINT question_bundle_question_pkey PRIMARY KEY (id);


--
-- TOC entry 4383 (class 2606 OID 162820646)
-- Name: question_bundle_questions question_bundle_question_questionbundle_id_questi_c71f2308_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle_questions
    ADD CONSTRAINT question_bundle_question_questionbundle_id_questi_c71f2308_uniq UNIQUE (questionbundle_id, question_v2_id);


--
-- TOC entry 4055 (class 2606 OID 33247)
-- Name: question question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);


--
-- TOC entry 4050 (class 2606 OID 33236)
-- Name: question_submission question_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_submission
    ADD CONSTRAINT question_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4362 (class 2606 OID 162820479)
-- Name: question_v2 question_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_v2
    ADD CONSTRAINT question_v2_pkey PRIMARY KEY (id);


--
-- TOC entry 4571 (class 2606 OID 277987344)
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY ("roleId");


--
-- TOC entry 4573 (class 2606 OID 277987346)
-- Name: role role_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_title_key UNIQUE (title);


--
-- TOC entry 4596 (class 2606 OID 277987488)
-- Name: sa_orf_assessment_config sa_assessment_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_orf_assessment_config
    ADD CONSTRAINT sa_assessment_config_pkey PRIMARY KEY (id);


--
-- TOC entry 4589 (class 2606 OID 277987441)
-- Name: sa_class_students sa_class_evaluation_students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_class_students
    ADD CONSTRAINT sa_class_evaluation_students_pkey PRIMARY KEY (id);


--
-- TOC entry 4591 (class 2606 OID 277987443)
-- Name: sa_class_students sa_class_evaluation_students_school_id_class_student_id_eva_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_class_students
    ADD CONSTRAINT sa_class_evaluation_students_school_id_class_student_id_eva_key UNIQUE (school_id, class, student_id, evaluation_date);


--
-- TOC entry 4586 (class 2606 OID 277987424)
-- Name: sa_evaluations sa_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_evaluations
    ADD CONSTRAINT sa_evaluations_pkey PRIMARY KEY (id);


--
-- TOC entry 4598 (class 2606 OID 277987490)
-- Name: sa_orf_assessment_config sa_orf_assessment_config_competency_id_grade_subject_partner_co; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_orf_assessment_config
    ADD CONSTRAINT sa_orf_assessment_config_competency_id_grade_subject_partner_co UNIQUE (competency_id, grade, subject, partner_code);


--
-- TOC entry 4581 (class 2606 OID 277987395)
-- Name: sa_school_evaluations sa_school_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_school_evaluations
    ADD CONSTRAINT sa_school_evaluations_pkey PRIMARY KEY (id);


--
-- TOC entry 4583 (class 2606 OID 277987397)
-- Name: sa_school_evaluations sa_school_evaluations_school_id_team_id_evaluation_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_school_evaluations
    ADD CONSTRAINT sa_school_evaluations_school_id_team_id_evaluation_date_key UNIQUE (school_id, team_id, evaluation_date);


--
-- TOC entry 4577 (class 2606 OID 277987372)
-- Name: sa_team_evaluators sa_team_evaluators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_team_evaluators
    ADD CONSTRAINT sa_team_evaluators_pkey PRIMARY KEY (id);


--
-- TOC entry 4579 (class 2606 OID 277987374)
-- Name: sa_team_evaluators sa_team_evaluators_team_id_evaluator_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_team_evaluators
    ADD CONSTRAINT sa_team_evaluators_team_id_evaluator_id_key UNIQUE (team_id, evaluator_id);


--
-- TOC entry 4575 (class 2606 OID 277987358)
-- Name: sa_teams sa_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_teams
    ADD CONSTRAINT sa_teams_pkey PRIMARY KEY (id);


--
-- TOC entry 4254 (class 2606 OID 153634772)
-- Name: sample_test sample_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sample_test
    ADD CONSTRAINT sample_test_pkey PRIMARY KEY (id);


--
-- TOC entry 4216 (class 2606 OID 37714299)
-- Name: school_cache school_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_cache
    ADD CONSTRAINT school_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4218 (class 2606 OID 37714331)
-- Name: school_cache school_cache_school_id_23741c3c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_cache
    ADD CONSTRAINT school_cache_school_id_23741c3c_uniq UNIQUE (school_id);


--
-- TOC entry 4011 (class 2606 OID 33173)
-- Name: school_grade school_grade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_grade
    ADD CONSTRAINT school_grade_pkey PRIMARY KEY (id);


--
-- TOC entry 4014 (class 2606 OID 33293)
-- Name: school_grade school_grade_school_id_grade_id_37387cad_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_grade
    ADD CONSTRAINT school_grade_school_id_grade_id_37387cad_uniq UNIQUE (school_id, grade_id);


--
-- TOC entry 4558 (class 2606 OID 277977750)
-- Name: school_location_mapping school_location_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_location_mapping
    ADD CONSTRAINT school_location_mapping_pkey PRIMARY KEY (id);


--
-- TOC entry 4006 (class 2606 OID 33163)
-- Name: school school_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_pkey PRIMARY KEY (id);


--
-- TOC entry 4008 (class 2606 OID 33165)
-- Name: school school_udise_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_udise_key UNIQUE (udise);


--
-- TOC entry 4509 (class 2606 OID 163012208)
-- Name: school_wise_daily_enrolment school_wise_daily_enrolment_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_wise_daily_enrolment
    ADD CONSTRAINT school_wise_daily_enrolment_id_key UNIQUE (id);


--
-- TOC entry 4511 (class 2606 OID 163012219)
-- Name: school_wise_daily_enrolment school_wise_daily_enrolment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_wise_daily_enrolment
    ADD CONSTRAINT school_wise_daily_enrolment_pkey PRIMARY KEY (id);


--
-- TOC entry 4519 (class 2606 OID 163932392)
-- Name: celery_duplicate_remove server_celeryduplicatere_school_id_assessment_id_df78e671_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.celery_duplicate_remove
    ADD CONSTRAINT server_celeryduplicatere_school_id_assessment_id_df78e671_uniq UNIQUE (school_id, assessment_id);


--
-- TOC entry 4522 (class 2606 OID 163936660)
-- Name: celery_duplicate_remove server_celeryduplicateremove_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.celery_duplicate_remove
    ADD CONSTRAINT server_celeryduplicateremove_pkey PRIMARY KEY (assessment_id, school_id);


--
-- TOC entry 4108 (class 2606 OID 21198015)
-- Name: enrollment server_enrollment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT server_enrollment_pkey PRIMARY KEY (id);


--
-- TOC entry 4292 (class 2606 OID 154025562)
-- Name: server_logroup_lo server_logroup_lo_logroup_id_lo_id_b89be6c0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup_lo
    ADD CONSTRAINT server_logroup_lo_logroup_id_lo_id_b89be6c0_uniq UNIQUE (logroup_id, lo_id);


--
-- TOC entry 4294 (class 2606 OID 154025496)
-- Name: server_logroup_lo server_logroup_lo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup_lo
    ADD CONSTRAINT server_logroup_lo_pkey PRIMARY KEY (id);


--
-- TOC entry 4288 (class 2606 OID 154025488)
-- Name: server_logroup server_logroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup
    ADD CONSTRAINT server_logroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4278 (class 2606 OID 154025452)
-- Name: server_marksrange server_marksrange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_marksrange
    ADD CONSTRAINT server_marksrange_pkey PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 154025472)
-- Name: server_questiongroup server_questiongroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup
    ADD CONSTRAINT server_questiongroup_pkey PRIMARY KEY (id);


--
-- TOC entry 4282 (class 2606 OID 154025548)
-- Name: server_questiongroup_question server_questiongroup_que_questiongroup_id_questio_ce11f00d_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup_question
    ADD CONSTRAINT server_questiongroup_que_questiongroup_id_questio_ce11f00d_uniq UNIQUE (questiongroup_id, question_id);


--
-- TOC entry 4284 (class 2606 OID 154025480)
-- Name: server_questiongroup_question server_questiongroup_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup_question
    ADD CONSTRAINT server_questiongroup_question_pkey PRIMARY KEY (id);


--
-- TOC entry 4103 (class 2606 OID 14701053)
-- Name: questions_submission_expanded server_questionsubmissionview_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questions_submission_expanded
    ADD CONSTRAINT server_questionsubmissionview_pkey PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 154025767)
-- Name: teacher server_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT server_teacher_pkey PRIMARY KEY (id);


--
-- TOC entry 4334 (class 2606 OID 154025775)
-- Name: teacher_subjects server_teacher_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT server_teacher_subjects_pkey PRIMARY KEY (id);


--
-- TOC entry 4338 (class 2606 OID 154025793)
-- Name: teacher_subjects server_teacher_subjects_teacher_id_subject_id_3e14a2f9_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT server_teacher_subjects_teacher_id_subject_id_3e14a2f9_uniq UNIQUE (teacher_id, subject_id);


--
-- TOC entry 4157 (class 2606 OID 21223137)
-- Name: silk_profile silk_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile
    ADD CONSTRAINT silk_profile_pkey PRIMARY KEY (id);


--
-- TOC entry 4179 (class 2606 OID 21223174)
-- Name: silk_profile_queries silk_profile_queries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile_queries
    ADD CONSTRAINT silk_profile_queries_pkey PRIMARY KEY (id);


--
-- TOC entry 4182 (class 2606 OID 21223206)
-- Name: silk_profile_queries silk_profile_queries_profile_id_sqlquery_id_b2403d9b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile_queries
    ADD CONSTRAINT silk_profile_queries_profile_id_sqlquery_id_b2403d9b_uniq UNIQUE (profile_id, sqlquery_id);


--
-- TOC entry 4164 (class 2606 OID 21223145)
-- Name: silk_request silk_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_request
    ADD CONSTRAINT silk_request_pkey PRIMARY KEY (id);


--
-- TOC entry 4170 (class 2606 OID 21223153)
-- Name: silk_response silk_response_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_response
    ADD CONSTRAINT silk_response_pkey PRIMARY KEY (id);


--
-- TOC entry 4173 (class 2606 OID 21223155)
-- Name: silk_response silk_response_request_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_response
    ADD CONSTRAINT silk_response_request_id_key UNIQUE (request_id);


--
-- TOC entry 4175 (class 2606 OID 21223166)
-- Name: silk_sqlquery silk_sqlquery_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_sqlquery
    ADD CONSTRAINT silk_sqlquery_pkey PRIMARY KEY (id);


--
-- TOC entry 4532 (class 2606 OID 164353391)
-- Name: sms_dag_reports sms_dag_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_dag_reports
    ADD CONSTRAINT sms_dag_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4040 (class 2606 OID 33228)
-- Name: sms sms_messageId_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms
    ADD CONSTRAINT "sms_messageId_key" UNIQUE (message_id);


--
-- TOC entry 4042 (class 2606 OID 33226)
-- Name: sms sms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms
    ADD CONSTRAINT sms_pkey PRIMARY KEY (id);


--
-- TOC entry 4600 (class 2606 OID 278019762)
-- Name: sms_track sms_track_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms_track
    ADD CONSTRAINT sms_track_pkey PRIMARY KEY (id);


--
-- TOC entry 4544 (class 2606 OID 180722165)
-- Name: ss_school_allocation_data ss_school_allocation_data_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_data
    ADD CONSTRAINT ss_school_allocation_data_pkey PRIMARY KEY (id);


--
-- TOC entry 4540 (class 2606 OID 180722101)
-- Name: ss_school_allocation_quarter ss_school_allocation_quarter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_quarter
    ADD CONSTRAINT ss_school_allocation_quarter_pkey PRIMARY KEY (id);


--
-- TOC entry 4542 (class 2606 OID 180722151)
-- Name: ss_school_allocation_quarter ss_school_allocation_quarter_quarter_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_quarter
    ADD CONSTRAINT ss_school_allocation_quarter_quarter_id_key UNIQUE (quarter_id);


--
-- TOC entry 4148 (class 2606 OID 21222963)
-- Name: static static_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.static
    ADD CONSTRAINT static_pkey PRIMARY KEY (id);


--
-- TOC entry 4112 (class 2606 OID 21198049)
-- Name: stream_common_subject stream_common_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_common_subject
    ADD CONSTRAINT stream_common_subject_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 21198126)
-- Name: stream_common_subject stream_common_subject_stream_id_subject_id_da4abd3e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_common_subject
    ADD CONSTRAINT stream_common_subject_stream_id_subject_id_da4abd3e_uniq UNIQUE (stream_id, subject_id);


--
-- TOC entry 4118 (class 2606 OID 21198057)
-- Name: stream_optional_subjects_1 stream_optional_subjects_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_1
    ADD CONSTRAINT stream_optional_subjects_1_pkey PRIMARY KEY (id);


--
-- TOC entry 4121 (class 2606 OID 21198140)
-- Name: stream_optional_subjects_1 stream_optional_subjects_1_stream_id_subject_id_fd5a86e1_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_1
    ADD CONSTRAINT stream_optional_subjects_1_stream_id_subject_id_fd5a86e1_uniq UNIQUE (stream_id, subject_id);


--
-- TOC entry 4124 (class 2606 OID 21198065)
-- Name: stream_optional_subjects_2 stream_optional_subjects_2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_2
    ADD CONSTRAINT stream_optional_subjects_2_pkey PRIMARY KEY (id);


--
-- TOC entry 4127 (class 2606 OID 21198154)
-- Name: stream_optional_subjects_2 stream_optional_subjects_2_stream_id_subject_id_f8d9242a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_2
    ADD CONSTRAINT stream_optional_subjects_2_stream_id_subject_id_f8d9242a_uniq UNIQUE (stream_id, subject_id);


--
-- TOC entry 4130 (class 2606 OID 21198073)
-- Name: stream_optional_subjects_3 stream_optional_subjects_3_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_3
    ADD CONSTRAINT stream_optional_subjects_3_pkey PRIMARY KEY (id);


--
-- TOC entry 4133 (class 2606 OID 21198168)
-- Name: stream_optional_subjects_3 stream_optional_subjects_3_stream_id_subject_id_62d65ad9_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_3
    ADD CONSTRAINT stream_optional_subjects_3_stream_id_subject_id_62d65ad9_uniq UNIQUE (stream_id, subject_id);


--
-- TOC entry 4136 (class 2606 OID 21198081)
-- Name: stream_optional_subjects_4 stream_optional_subjects_4_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_4
    ADD CONSTRAINT stream_optional_subjects_4_pkey PRIMARY KEY (id);


--
-- TOC entry 4139 (class 2606 OID 21198182)
-- Name: stream_optional_subjects_4 stream_optional_subjects_4_stream_id_subject_id_ce0aac6e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_4
    ADD CONSTRAINT stream_optional_subjects_4_stream_id_subject_id_ce0aac6e_uniq UNIQUE (stream_id, subject_id);


--
-- TOC entry 4536 (class 2606 OID 171077458)
-- Name: student_content_share student_content_share_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_content_share
    ADD CONSTRAINT student_content_share_pkey PRIMARY KEY (id);


--
-- TOC entry 4617 (class 2606 OID 278029945)
-- Name: student_document student_document_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_document
    ADD CONSTRAINT student_document_pkey PRIMARY KEY (id);


--
-- TOC entry 4620 (class 2606 OID 278029983)
-- Name: student_document student_document_student_id_documents_id_ca8eb818_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_document
    ADD CONSTRAINT student_document_student_id_documents_id_ca8eb818_uniq UNIQUE (student_id, documents_id);


--
-- TOC entry 4142 (class 2606 OID 21198114)
-- Name: student_subject student_subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject_pkey PRIMARY KEY (id);


--
-- TOC entry 4145 (class 2606 OID 21198196)
-- Name: student_subject student_subject_student_id_subject_id_cc31a1e6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject_student_id_subject_id_cc31a1e6_uniq UNIQUE (student_id, subject_id);


--
-- TOC entry 4074 (class 2606 OID 33429)
-- Name: student_submission student_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission
    ADD CONSTRAINT student_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4497 (class 2606 OID 162821757)
-- Name: student_submission_v2_marks_submissions student_submission_v2_ma_studentsubmission_v2_id__87a3f7fd_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2_marks_submissions
    ADD CONSTRAINT student_submission_v2_ma_studentsubmission_v2_id__87a3f7fd_uniq UNIQUE (studentsubmission_v2_id, componentsubmission_id);


--
-- TOC entry 4501 (class 2606 OID 162821697)
-- Name: student_submission_v2_marks_submissions student_submission_v2_marks_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2_marks_submissions
    ADD CONSTRAINT student_submission_v2_marks_submissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4491 (class 2606 OID 162821689)
-- Name: student_submission_v2 student_submission_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_pkey PRIMARY KEY (id);


--
-- TOC entry 4016 (class 2606 OID 157769191)
-- Name: subject subject_name_grade_number_a273f33e_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_name_grade_number_a273f33e_uniq UNIQUE (name, grade_number);


--
-- TOC entry 4018 (class 2606 OID 33181)
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- TOC entry 4201 (class 2606 OID 32010077)
-- Name: subject_submission subject_submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission
    ADD CONSTRAINT subject_submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4206 (class 2606 OID 32010148)
-- Name: subject_submission_selected_lo subject_submission_selec_subjectsubmission_id_lo__28ea8eb6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission_selected_lo
    ADD CONSTRAINT subject_submission_selec_subjectsubmission_id_lo__28ea8eb6_uniq UNIQUE (subjectsubmission_id, lo_id);


--
-- TOC entry 4209 (class 2606 OID 32010091)
-- Name: subject_submission_selected_lo subject_submission_selected_lo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission_selected_lo
    ADD CONSTRAINT subject_submission_selected_lo_pkey PRIMARY KEY (id);


--
-- TOC entry 4602 (class 2606 OID 278019778)
-- Name: submission submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_pkey PRIMARY KEY (id);


--
-- TOC entry 4021 (class 2606 OID 33191)
-- Name: submission_summary submission_summary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_summary
    ADD CONSTRAINT submission_summary_pkey PRIMARY KEY (id);


--
-- TOC entry 4364 (class 2606 OID 162820487)
-- Name: submission_type submission_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_type
    ADD CONSTRAINT submission_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4538 (class 2606 OID 175264531)
-- Name: teacher_attendance_status teacher_attendance_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_attendance_status
    ADD CONSTRAINT teacher_attendance_status_pkey PRIMARY KEY (value);


--
-- TOC entry 4340 (class 2606 OID 157887996)
-- Name: teacher_registration_compliance teacher_registration_compliance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_registration_compliance
    ADD CONSTRAINT teacher_registration_compliance_pkey PRIMARY KEY (id, udise);


--
-- TOC entry 4560 (class 2606 OID 277984421)
-- Name: test_ku test_ku_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_ku
    ADD CONSTRAINT test_ku_pkey PRIMARY KEY (sss);


--
-- TOC entry 4256 (class 2606 OID 153776051)
-- Name: test_telemetry test_telemetry_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_telemetry
    ADD CONSTRAINT test_telemetry_pkey PRIMARY KEY (id);


--
-- TOC entry 4593 (class 2606 OID 277987467)
-- Name: trackassessment trackassessment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trackassessment
    ADD CONSTRAINT trackassessment_pkey PRIMARY KEY ("trackAssessmentId");


--
-- TOC entry 4369 (class 2606 OID 162820506)
-- Name: unit_bundle unit_bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle
    ADD CONSTRAINT unit_bundle_pkey PRIMARY KEY (id);


--
-- TOC entry 4371 (class 2606 OID 162820514)
-- Name: unit_bundle_units unit_bundle_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle_units
    ADD CONSTRAINT unit_bundle_unit_pkey PRIMARY KEY (id);


--
-- TOC entry 4375 (class 2606 OID 162820632)
-- Name: unit_bundle_units unit_bundle_unit_unitbundle_id_unit_v2_id_0a1b44f9_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle_units
    ADD CONSTRAINT unit_bundle_unit_unitbundle_id_unit_v2_id_0a1b44f9_uniq UNIQUE (unitbundle_id, unit_v2_id);


--
-- TOC entry 4366 (class 2606 OID 162820498)
-- Name: unit_v2 unit_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_v2
    ADD CONSTRAINT unit_v2_pkey PRIMARY KEY (id);


--
-- TOC entry 4622 (class 2606 OID 278029994)
-- Name: vc vc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vc
    ADD CONSTRAINT vc_pkey PRIMARY KEY (id);


--
-- TOC entry 4024 (class 1259 OID 33308)
-- Name: Student_school_id_87dda7cd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "Student_school_id_87dda7cd" ON public.student USING btree (school_id);


--
-- TOC entry 4263 (class 1259 OID 154025721)
-- Name: assessment_au_lo_aggregate_assessment_id_c9116bb9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_lo_aggregate_assessment_id_c9116bb9 ON public.assessment_au_lo_aggregate USING btree (assessment_id);


--
-- TOC entry 4264 (class 1259 OID 154025727)
-- Name: assessment_au_lo_aggregate_los_id_37199e71; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_lo_aggregate_los_id_37199e71 ON public.assessment_au_lo_aggregate USING btree (los_id);


--
-- TOC entry 4323 (class 1259 OID 154025717)
-- Name: assessment_au_lo_aggregate_submission_assessment_id_70b49f0a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_lo_aggregate_submission_assessment_id_70b49f0a ON public.assessment_au_lo_aggregate_submission USING btree (assessment_id);


--
-- TOC entry 4324 (class 1259 OID 154025718)
-- Name: assessment_au_lo_aggregate_submission_grade_id_f0d66c68; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_lo_aggregate_submission_grade_id_f0d66c68 ON public.assessment_au_lo_aggregate_submission USING btree (grade_id);


--
-- TOC entry 4325 (class 1259 OID 154025719)
-- Name: assessment_au_lo_aggregate_submission_lo_id_b090a0c5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_lo_aggregate_submission_lo_id_b090a0c5 ON public.assessment_au_lo_aggregate_submission USING btree (lo_id);


--
-- TOC entry 4328 (class 1259 OID 154025720)
-- Name: assessment_au_lo_aggregate_submission_school_id_8f365921; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_lo_aggregate_submission_school_id_8f365921 ON public.assessment_au_lo_aggregate_submission USING btree (school_id);


--
-- TOC entry 4313 (class 1259 OID 154025681)
-- Name: assessment_au_question_agg_assessment_id_e5a4b584; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_question_agg_assessment_id_e5a4b584 ON public.assessment_au_question_aggregate_submission USING btree (assessment_id);


--
-- TOC entry 4314 (class 1259 OID 154025683)
-- Name: assessment_au_question_agg_question_id_ca4feed0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_question_agg_question_id_ca4feed0 ON public.assessment_au_question_aggregate_submission USING btree (question_id);


--
-- TOC entry 4319 (class 1259 OID 154025695)
-- Name: assessment_au_question_aggregate_assessment_id_e34a737c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_question_aggregate_assessment_id_e34a737c ON public.assessment_au_question_aggregate USING btree (assessment_id);


--
-- TOC entry 4320 (class 1259 OID 154025696)
-- Name: assessment_au_question_aggregate_los_id_a423c848; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_question_aggregate_los_id_a423c848 ON public.assessment_au_question_aggregate USING btree (question_id);


--
-- TOC entry 4315 (class 1259 OID 154025682)
-- Name: assessment_au_question_aggregate_submission_grade_id_dd72165f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_question_aggregate_submission_grade_id_dd72165f ON public.assessment_au_question_aggregate_submission USING btree (grade_id);


--
-- TOC entry 4318 (class 1259 OID 154025684)
-- Name: assessment_au_question_aggregate_submission_school_id_cce03782; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_au_question_aggregate_submission_school_id_cce03782 ON public.assessment_au_question_aggregate_submission USING btree (school_id);


--
-- TOC entry 3980 (class 1259 OID 162821003)
-- Name: assessment_builder_id_5b99d1cf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_builder_id_5b99d1cf ON public.assessment USING btree (builder_id);


--
-- TOC entry 4219 (class 1259 OID 37714327)
-- Name: assessment_cache_assessment_id_5b0b6eaa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_cache_assessment_id_5b0b6eaa ON public.assessment_cache USING btree (assessment_id);


--
-- TOC entry 4224 (class 1259 OID 37714328)
-- Name: assessment_cache_school_id_e18b77ad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_cache_school_id_e18b77ad ON public.assessment_cache USING btree (school_id);


--
-- TOC entry 4512 (class 1259 OID 163512774)
-- Name: assessment_cache_v5_assessment_id_dbbfbcf0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_cache_v5_assessment_id_dbbfbcf0 ON public.assessment_cache_v5 USING btree (assessment_id);


--
-- TOC entry 4517 (class 1259 OID 163512775)
-- Name: assessment_cache_v5_school_id_f95f1c50; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_cache_v5_school_id_f95f1c50 ON public.assessment_cache_v5 USING btree (school_id);


--
-- TOC entry 4406 (class 1259 OID 162820701)
-- Name: assessment_components_assessment_id_e6751dea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_components_assessment_id_e6751dea ON public.assessment_components USING btree (assessment_id);


--
-- TOC entry 4407 (class 1259 OID 162820702)
-- Name: assessment_components_components_id_7f56cb42; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_components_components_id_7f56cb42 ON public.assessment_components USING btree (components_id);


--
-- TOC entry 3981 (class 1259 OID 33402)
-- Name: assessment_deadline_id_e035e5a1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_deadline_id_e035e5a1 ON public.assessment USING btree (deadline_id);


--
-- TOC entry 4267 (class 1259 OID 154025649)
-- Name: assessment_ep_grade_assessment_id_9d58eb40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_assessment_id_9d58eb40 ON public.assessment_ep_grade USING btree (assessment_id);


--
-- TOC entry 4268 (class 1259 OID 154025655)
-- Name: assessment_ep_grade_grade_mapping_id_c90e34d3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_grade_mapping_id_c90e34d3 ON public.assessment_ep_grade USING btree (grade_mapping_id);


--
-- TOC entry 4304 (class 1259 OID 154025643)
-- Name: assessment_ep_grade_submission_assessment_id_db6661c3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_assessment_id_db6661c3 ON public.assessment_ep_grade_submission USING btree (assessment_id);


--
-- TOC entry 4305 (class 1259 OID 154025644)
-- Name: assessment_ep_grade_submission_form_id_677b1020; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_form_id_677b1020 ON public.assessment_ep_grade_submission USING btree (form_id);


--
-- TOC entry 4306 (class 1259 OID 154025645)
-- Name: assessment_ep_grade_submission_grade_id_99152754; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_grade_id_99152754 ON public.assessment_ep_grade_submission USING btree (grade_id);


--
-- TOC entry 4309 (class 1259 OID 154025748)
-- Name: assessment_ep_grade_submission_school_id_e260c95a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_school_id_e260c95a ON public.assessment_ep_grade_submission USING btree (school_id);


--
-- TOC entry 4310 (class 1259 OID 154025646)
-- Name: assessment_ep_grade_submission_sms_id_990c901a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_sms_id_990c901a ON public.assessment_ep_grade_submission USING btree (sms_id);


--
-- TOC entry 4311 (class 1259 OID 154025647)
-- Name: assessment_ep_grade_submission_student_id_80b4178f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_student_id_80b4178f ON public.assessment_ep_grade_submission USING btree (student_id);


--
-- TOC entry 4312 (class 1259 OID 154025648)
-- Name: assessment_ep_grade_submission_subject_id_67959872; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_grade_submission_subject_id_67959872 ON public.assessment_ep_grade_submission USING btree (subject_id);


--
-- TOC entry 4271 (class 1259 OID 154025601)
-- Name: assessment_ep_marks_assessment_id_6cb9567c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_assessment_id_6cb9567c ON public.assessment_ep_marks USING btree (assessment_id);


--
-- TOC entry 4272 (class 1259 OID 154025607)
-- Name: assessment_ep_marks_max_marks_range_id_43ea07b0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_max_marks_range_id_43ea07b0 ON public.assessment_ep_marks USING btree (max_marks_range_id);


--
-- TOC entry 4295 (class 1259 OID 154025595)
-- Name: assessment_ep_marks_submission_assessment_id_9eb88b11; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_assessment_id_9eb88b11 ON public.assessment_ep_marks_submission USING btree (assessment_id);


--
-- TOC entry 4296 (class 1259 OID 154025596)
-- Name: assessment_ep_marks_submission_form_id_edd4db41; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_form_id_edd4db41 ON public.assessment_ep_marks_submission USING btree (form_id);


--
-- TOC entry 4297 (class 1259 OID 154025597)
-- Name: assessment_ep_marks_submission_grade_id_daf2aabc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_grade_id_daf2aabc ON public.assessment_ep_marks_submission USING btree (grade_id);


--
-- TOC entry 4300 (class 1259 OID 154025754)
-- Name: assessment_ep_marks_submission_school_id_41e5151b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_school_id_41e5151b ON public.assessment_ep_marks_submission USING btree (school_id);


--
-- TOC entry 4301 (class 1259 OID 154025598)
-- Name: assessment_ep_marks_submission_sms_id_5c707015; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_sms_id_5c707015 ON public.assessment_ep_marks_submission USING btree (sms_id);


--
-- TOC entry 4302 (class 1259 OID 154025599)
-- Name: assessment_ep_marks_submission_student_id_655549b1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_student_id_655549b1 ON public.assessment_ep_marks_submission USING btree (student_id);


--
-- TOC entry 4303 (class 1259 OID 154025600)
-- Name: assessment_ep_marks_submission_subject_id_d5f06734; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_ep_marks_submission_subject_id_d5f06734 ON public.assessment_ep_marks_submission USING btree (subject_id);


--
-- TOC entry 4062 (class 1259 OID 33420)
-- Name: assessment_grade_assessment_id_c8c6f85c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_grade_assessment_id_c8c6f85c ON public.assessment_grade USING btree (assessment_id);


--
-- TOC entry 4065 (class 1259 OID 33421)
-- Name: assessment_grade_grade_id_081af151; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_grade_grade_id_081af151 ON public.assessment_grade USING btree (grade_id);


--
-- TOC entry 4410 (class 1259 OID 162820715)
-- Name: assessment_lo_bundles_assessment_id_e7ebfe13; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_lo_bundles_assessment_id_e7ebfe13 ON public.assessment_lo_bundles USING btree (assessment_id);


--
-- TOC entry 4413 (class 1259 OID 162820716)
-- Name: assessment_lo_bundles_lobundle_id_1ac9fb13; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_lo_bundles_lobundle_id_1ac9fb13 ON public.assessment_lo_bundles USING btree (lobundle_id);


--
-- TOC entry 3982 (class 1259 OID 162821257)
-- Name: assessment_mapping_id_c61f4e3e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_mapping_id_c61f4e3e ON public.assessment USING btree (mapping_id);


--
-- TOC entry 4418 (class 1259 OID 162820729)
-- Name: assessment_question_bundles_assessment_id_45055a4d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_question_bundles_assessment_id_45055a4d ON public.assessment_question_bundles USING btree (assessment_id);


--
-- TOC entry 4421 (class 1259 OID 162820730)
-- Name: assessment_question_bundles_questionbundle_id_38154f6d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_question_bundles_questionbundle_id_38154f6d ON public.assessment_question_bundles USING btree (questionbundle_id);


--
-- TOC entry 4192 (class 1259 OID 31837369)
-- Name: assessment_stream_assessment_id_bc516271; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_stream_assessment_id_bc516271 ON public.assessment_stream USING btree (assessment_id);


--
-- TOC entry 4197 (class 1259 OID 31837374)
-- Name: assessment_stream_stream_id_65834252; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_stream_stream_id_65834252 ON public.assessment_stream USING btree (stream_id);


--
-- TOC entry 4502 (class 1259 OID 162821998)
-- Name: assessment_subject_assessment_id_588fd08d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_subject_assessment_id_588fd08d ON public.assessment_subjects USING btree (assessment_id);


--
-- TOC entry 4507 (class 1259 OID 162821999)
-- Name: assessment_subject_subject_id_8deedaa4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_subject_subject_id_8deedaa4 ON public.assessment_subjects USING btree (subject_id);


--
-- TOC entry 3985 (class 1259 OID 162820731)
-- Name: assessment_submission_type_v2_id_4e47c34d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_submission_type_v2_id_4e47c34d ON public.assessment USING btree (submission_type_v2_id);


--
-- TOC entry 4401 (class 1259 OID 162820688)
-- Name: assessment_type_category_id_5618089c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_type_category_id_5618089c ON public.assessment_type USING btree (category_id);


--
-- TOC entry 3986 (class 1259 OID 162820737)
-- Name: assessment_type_v2_id_50640959; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_type_v2_id_50640959 ON public.assessment USING btree (type_v2_id);


--
-- TOC entry 4452 (class 1259 OID 162820958)
-- Name: assessment_unit_assessment_id_548def6a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_assessment_id_548def6a ON public.assessment_unit USING btree (assessment_id);


--
-- TOC entry 4422 (class 1259 OID 162820755)
-- Name: assessment_unit_bundles_assessment_id_68af8422; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_bundles_assessment_id_68af8422 ON public.assessment_unit_bundles USING btree (assessment_id);


--
-- TOC entry 4427 (class 1259 OID 162820756)
-- Name: assessment_unit_bundles_unitbundle_id_3c4f62eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_bundles_unitbundle_id_3c4f62eb ON public.assessment_unit_bundles USING btree (unitbundle_id);


--
-- TOC entry 4455 (class 1259 OID 162820959)
-- Name: assessment_unit_school_id_c6de07f8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_school_id_c6de07f8 ON public.assessment_unit USING btree (school_id);


--
-- TOC entry 4459 (class 1259 OID 162820973)
-- Name: assessment_unit_selected_lo_assessmentunit_id_d4fd7d44; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_selected_lo_assessmentunit_id_d4fd7d44 ON public.assessment_unit_selected_lo USING btree (assessmentunit_id);


--
-- TOC entry 4460 (class 1259 OID 162820974)
-- Name: assessment_unit_selected_lo_lo_v2_id_b37cb2ec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_selected_lo_lo_v2_id_b37cb2ec ON public.assessment_unit_selected_lo USING btree (lo_v2_id);


--
-- TOC entry 4465 (class 1259 OID 162820987)
-- Name: assessment_unit_selected_question_assessmentunit_id_0103a060; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_selected_question_assessmentunit_id_0103a060 ON public.assessment_unit_selected_question USING btree (assessmentunit_id);


--
-- TOC entry 4468 (class 1259 OID 162820988)
-- Name: assessment_unit_selected_question_question_v2_id_9b993835; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_selected_question_question_v2_id_9b993835 ON public.assessment_unit_selected_question USING btree (question_v2_id);


--
-- TOC entry 4471 (class 1259 OID 162821001)
-- Name: assessment_unit_selected_unit_assessmentunit_id_9ee175c8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_selected_unit_assessmentunit_id_9ee175c8 ON public.assessment_unit_selected_unit USING btree (assessmentunit_id);


--
-- TOC entry 4474 (class 1259 OID 162821002)
-- Name: assessment_unit_selected_unit_unit_v2_id_deb8754c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_selected_unit_unit_v2_id_deb8754c ON public.assessment_unit_selected_unit USING btree (unit_v2_id);


--
-- TOC entry 4456 (class 1259 OID 162820960)
-- Name: assessment_unit_subject_id_7790c503; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX assessment_unit_subject_id_7790c503 ON public.assessment_unit USING btree (subject_id);


--
-- TOC entry 4149 (class 1259 OID 277958618)
-- Name: attendance_date_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_date_idx ON public.attendance USING btree (date DESC NULLS LAST);


--
-- TOC entry 4549 (class 1259 OID 277958628)
-- Name: attendance_mv_block_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_mv_block_idx ON public.attendance_mv USING btree (block);


--
-- TOC entry 4550 (class 1259 OID 277958633)
-- Name: attendance_mv_cluster_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_mv_cluster_idx ON public.attendance_mv USING btree (cluster);


--
-- TOC entry 4551 (class 1259 OID 277958634)
-- Name: attendance_mv_date_district_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_mv_date_district_idx ON public.attendance_mv USING btree (date DESC NULLS LAST, district);


--
-- TOC entry 4552 (class 1259 OID 277958632)
-- Name: attendance_mv_date_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_mv_date_idx ON public.attendance_mv USING btree (date DESC NULLS LAST);


--
-- TOC entry 4553 (class 1259 OID 277958631)
-- Name: attendance_mv_district_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_mv_district_idx ON public.attendance_mv USING btree (district);


--
-- TOC entry 4563 (class 1259 OID 278027848)
-- Name: attendance_sms_logs_student_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_sms_logs_student_id_idx ON public.attendance_sms_logs USING btree (student_id);


--
-- TOC entry 4152 (class 1259 OID 21223058)
-- Name: attendance_student_id_d55196c7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_student_id_d55196c7 ON public.attendance USING btree (student_id);


--
-- TOC entry 4155 (class 1259 OID 21223059)
-- Name: attendance_taken_by_school_id_5cadefc1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX attendance_taken_by_school_id_5cadefc1 ON public.attendance USING btree (taken_by_school_id);


--
-- TOC entry 3942 (class 1259 OID 33058)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 3947 (class 1259 OID 32995)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 3950 (class 1259 OID 32996)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 3937 (class 1259 OID 32981)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 3958 (class 1259 OID 33011)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3961 (class 1259 OID 33010)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3964 (class 1259 OID 33025)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3967 (class 1259 OID 33024)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3955 (class 1259 OID 33052)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 4225 (class 1259 OID 38340144)
-- Name: cache_idx_ass_school; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_idx_ass_school ON public.assessment_cache USING btree (assessment_id, school_id);


--
-- TOC entry 4447 (class 1259 OID 162820939)
-- Name: class_level_component_submission_assessment_id_6d89f4c1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_level_component_submission_assessment_id_6d89f4c1 ON public.class_level_component_submission USING btree (assessment_id);


--
-- TOC entry 4450 (class 1259 OID 162820941)
-- Name: class_level_component_submission_school_id_1e2dddb4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_level_component_submission_school_id_1e2dddb4 ON public.class_level_component_submission USING btree (school_id);


--
-- TOC entry 4451 (class 1259 OID 162820942)
-- Name: class_level_component_submission_subject_id_4ab260ef; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_level_component_submission_subject_id_4ab260ef ON public.class_level_component_submission USING btree (subject_id);


--
-- TOC entry 4475 (class 1259 OID 164121245)
-- Name: class_submission_ass_school_grade_subject; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_ass_school_grade_subject ON public.class_submission USING btree (assessment_id, school_id, grade_id, subject_id);


--
-- TOC entry 4476 (class 1259 OID 162821124)
-- Name: class_submission_assessment_id_b8eb4160; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_assessment_id_b8eb4160 ON public.class_submission USING btree (assessment_id);


--
-- TOC entry 4477 (class 1259 OID 162821125)
-- Name: class_submission_grade_id_328ba948; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_grade_id_328ba948 ON public.class_submission USING btree (grade_id);


--
-- TOC entry 4478 (class 1259 OID 162821126)
-- Name: class_submission_lo_id_cc2f57c8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_lo_id_cc2f57c8 ON public.class_submission USING btree (lo_id);


--
-- TOC entry 4481 (class 1259 OID 162821127)
-- Name: class_submission_question_id_d75abaee; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_question_id_d75abaee ON public.class_submission USING btree (question_id);


--
-- TOC entry 4482 (class 1259 OID 162821128)
-- Name: class_submission_school_id_08310adc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_school_id_08310adc ON public.class_submission USING btree (school_id);


--
-- TOC entry 4483 (class 1259 OID 162821129)
-- Name: class_submission_subject_id_6746f684; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_subject_id_6746f684 ON public.class_submission USING btree (subject_id);


--
-- TOC entry 4484 (class 1259 OID 162821130)
-- Name: class_submission_submission_id_766fedbc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_submission_id_766fedbc ON public.class_submission USING btree (submission_id);


--
-- TOC entry 4485 (class 1259 OID 162821131)
-- Name: class_submission_unit_id_95152f45; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX class_submission_unit_id_95152f45 ON public.class_submission USING btree (unit_id);


--
-- TOC entry 4392 (class 1259 OID 162820668)
-- Name: component_component_type_id_c1de0061; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_component_type_id_c1de0061 ON public.component USING btree (component_type_id);


--
-- TOC entry 4395 (class 1259 OID 162820681)
-- Name: component_subjects_components_id_1de3ab7f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_subjects_components_id_1de3ab7f ON public.component_subjects USING btree (components_id);


--
-- TOC entry 4400 (class 1259 OID 162820682)
-- Name: component_subjects_subject_id_379d1d06; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_subjects_subject_id_379d1d06 ON public.component_subjects USING btree (subject_id);


--
-- TOC entry 4441 (class 1259 OID 162820915)
-- Name: component_submission_assessment_id_106861f5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_submission_assessment_id_106861f5 ON public.component_submission USING btree (assessment_id);


--
-- TOC entry 4442 (class 1259 OID 162820916)
-- Name: component_submission_component_id_4e513345; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_submission_component_id_4e513345 ON public.component_submission USING btree (component_id);


--
-- TOC entry 4445 (class 1259 OID 162820917)
-- Name: component_submission_school_id_4607fe6c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_submission_school_id_4607fe6c ON public.component_submission USING btree (school_id);


--
-- TOC entry 4446 (class 1259 OID 162820918)
-- Name: component_submission_subject_id_244ce57e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX component_submission_subject_id_244ce57e ON public.component_submission USING btree (subject_id);


--
-- TOC entry 3970 (class 1259 OID 33048)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3973 (class 1259 OID 33049)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 4524 (class 1259 OID 164149637)
-- Name: django_cele_date_cr_bd6c1d_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_date_cr_bd6c1d_idx ON public.django_celery_results_groupresult USING btree (date_created);


--
-- TOC entry 4226 (class 1259 OID 164149635)
-- Name: django_cele_date_cr_f04a50_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_date_cr_f04a50_idx ON public.django_celery_results_taskresult USING btree (date_created);


--
-- TOC entry 4525 (class 1259 OID 164149638)
-- Name: django_cele_date_do_caae0e_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_date_do_caae0e_idx ON public.django_celery_results_groupresult USING btree (date_done);


--
-- TOC entry 4227 (class 1259 OID 164149636)
-- Name: django_cele_date_do_f59aad_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_date_do_f59aad_idx ON public.django_celery_results_taskresult USING btree (date_done);


--
-- TOC entry 4228 (class 1259 OID 164149633)
-- Name: django_cele_status_9b6201_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_status_9b6201_idx ON public.django_celery_results_taskresult USING btree (status);


--
-- TOC entry 4229 (class 1259 OID 164149632)
-- Name: django_cele_task_na_08aec9_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_task_na_08aec9_idx ON public.django_celery_results_taskresult USING btree (task_name);


--
-- TOC entry 4230 (class 1259 OID 164149634)
-- Name: django_cele_worker_d54dd8_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_cele_worker_d54dd8_idx ON public.django_celery_results_taskresult USING btree (worker);


--
-- TOC entry 4236 (class 1259 OID 37714535)
-- Name: django_celery_results_chordcounter_group_id_1f70858c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_celery_results_chordcounter_group_id_1f70858c_like ON public.django_celery_results_chordcounter USING btree (group_id varchar_pattern_ops);


--
-- TOC entry 4526 (class 1259 OID 164149639)
-- Name: django_celery_results_groupresult_group_id_a085f1a9_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_celery_results_groupresult_group_id_a085f1a9_like ON public.django_celery_results_groupresult USING btree (group_id varchar_pattern_ops);


--
-- TOC entry 4233 (class 1259 OID 37714493)
-- Name: django_celery_results_taskresult_task_id_de0d95bf_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_celery_results_taskresult_task_id_de0d95bf_like ON public.django_celery_results_taskresult USING btree (task_id varchar_pattern_ops);


--
-- TOC entry 4083 (class 1259 OID 33508)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 4086 (class 1259 OID 33507)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 4609 (class 1259 OID 278029971)
-- Name: event_trail_documents_documents_id_a992d720; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX event_trail_documents_documents_id_a992d720 ON public.event_trail_documents USING btree (documents_id);


--
-- TOC entry 4612 (class 1259 OID 278029970)
-- Name: event_trail_documents_studenttrail_id_67b26f69; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX event_trail_documents_studenttrail_id_67b26f69 ON public.event_trail_documents USING btree (studenttrail_id);


--
-- TOC entry 4607 (class 1259 OID 278029956)
-- Name: event_trail_school_id_1205c6b9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX event_trail_school_id_1205c6b9 ON public.event_trail USING btree (school_id);


--
-- TOC entry 4608 (class 1259 OID 278029957)
-- Name: event_trail_student_id_a2424067; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX event_trail_student_id_a2424067 ON public.event_trail USING btree (student_id);


--
-- TOC entry 3992 (class 1259 OID 33269)
-- Name: grade_assessment_assessment_id_6beb2bec; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX grade_assessment_assessment_id_6beb2bec ON public.grade_assessment USING btree (assessment_id);


--
-- TOC entry 3997 (class 1259 OID 33390)
-- Name: grade_assessment_school_id_944f75c5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX grade_assessment_school_id_944f75c5 ON public.grade_assessment USING btree (school_id);


--
-- TOC entry 3998 (class 1259 OID 31837271)
-- Name: grade_assessment_streams_id_6ca61f38; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX grade_assessment_streams_id_6ca61f38 ON public.grade_assessment USING btree (streams_id);


--
-- TOC entry 3991 (class 1259 OID 33396)
-- Name: grade_stream_id_26a85b82; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX grade_stream_id_26a85b82 ON public.grade USING btree (stream_id);


--
-- TOC entry 4087 (class 1259 OID 34156)
-- Name: lo_assessment_assessment_id_524ce752; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_assessment_assessment_id_524ce752 ON public.lo_assessment USING btree (assessment_id);


--
-- TOC entry 4090 (class 1259 OID 34155)
-- Name: lo_assessment_lo_id_e71eb10d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_assessment_lo_id_e71eb10d ON public.lo_assessment USING btree (lo_id);


--
-- TOC entry 4386 (class 1259 OID 162820662)
-- Name: lo_bundle_lo_lo_v2_id_79826828; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_bundle_lo_lo_v2_id_79826828 ON public.lo_bundle_los USING btree (lo_v2_id);


--
-- TOC entry 4387 (class 1259 OID 162820661)
-- Name: lo_bundle_lo_lobundle_id_9d4d3903; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_bundle_lo_lobundle_id_9d4d3903 ON public.lo_bundle_los USING btree (lobundle_id);


--
-- TOC entry 4001 (class 1259 OID 33384)
-- Name: lo_subject_id_a35d6fc1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_subject_id_a35d6fc1 ON public.lo USING btree (subject_id);


--
-- TOC entry 4056 (class 1259 OID 33381)
-- Name: lo_submission_assessment_id_77d7b852; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_submission_assessment_id_77d7b852 ON public.lo_submission USING btree (assessment_id);


--
-- TOC entry 4057 (class 1259 OID 66431)
-- Name: lo_submission_grade_id_4aad3970; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_submission_grade_id_4aad3970 ON public.lo_submission USING btree (grade_id);


--
-- TOC entry 4058 (class 1259 OID 33382)
-- Name: lo_submission_lo_id_ab3f2b69; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_submission_lo_id_ab3f2b69 ON public.lo_submission USING btree (lo_id);


--
-- TOC entry 4061 (class 1259 OID 33383)
-- Name: lo_submission_school_id_6b790f30; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_submission_school_id_6b790f30 ON public.lo_submission USING btree (school_id);


--
-- TOC entry 4359 (class 1259 OID 162820608)
-- Name: lo_v2_subject_id_8728ccda; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX lo_v2_subject_id_8728ccda ON public.lo_v2 USING btree (subject_id);


--
-- TOC entry 4438 (class 1259 OID 162820880)
-- Name: mapping_mapping_id_4e953268; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mapping_mapping_id_4e953268 ON public.mapping USING btree (mapping_id);


--
-- TOC entry 4432 (class 1259 OID 162820871)
-- Name: mapping_submission_assessment_id_0c00a42a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mapping_submission_assessment_id_0c00a42a ON public.mapping_submission USING btree (assessment_id);


--
-- TOC entry 4433 (class 1259 OID 162820872)
-- Name: mapping_submission_mapping_id_5073f161; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mapping_submission_mapping_id_5073f161 ON public.mapping_submission USING btree (mapping_id);


--
-- TOC entry 4436 (class 1259 OID 162820873)
-- Name: mapping_submission_school_id_b4b16ddf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mapping_submission_school_id_b4b16ddf ON public.mapping_submission USING btree (school_id);


--
-- TOC entry 4437 (class 1259 OID 162820874)
-- Name: mapping_submission_subject_id_e82161e3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mapping_submission_subject_id_e82161e3 ON public.mapping_submission USING btree (subject_id);


--
-- TOC entry 4211 (class 1259 OID 37713558)
-- Name: mt_grade_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mt_grade_idx ON public.mystudent_testperformance USING btree (grade);


--
-- TOC entry 4212 (class 1259 OID 37713559)
-- Name: mt_week_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX mt_week_idx ON public.mystudent_testperformance USING btree (week);


--
-- TOC entry 4078 (class 1259 OID 9199671)
-- Name: odk-status-idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "odk-status-idx" ON public.odk_submission USING btree (status);


--
-- TOC entry 4079 (class 1259 OID 9199406)
-- Name: odk-sub-formid-idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "odk-sub-formid-idx" ON public.odk_submission USING btree (form_id);


--
-- TOC entry 4080 (class 1259 OID 9150465)
-- Name: odk-sub-school-idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "odk-sub-school-idx" ON public.odk_submission USING btree (school_udise);


--
-- TOC entry 4101 (class 1259 OID 65997871)
-- Name: qse_grade-ass-id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "qse_grade-ass-id_idx" ON public.questions_submission_expanded USING btree (grade_assessment_id DESC NULLS LAST);


--
-- TOC entry 4095 (class 1259 OID 3378806)
-- Name: question_assessment_assessment_id_f775e63a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_assessment_assessment_id_f775e63a ON public.question_assessment USING btree (assessment_id);


--
-- TOC entry 4100 (class 1259 OID 3378805)
-- Name: question_assessment_question_id_e5f228be; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_assessment_question_id_e5f228be ON public.question_assessment USING btree (question_id);


--
-- TOC entry 4380 (class 1259 OID 162820648)
-- Name: question_bundle_question_question_v2_id_cad3fcd9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_bundle_question_question_v2_id_cad3fcd9 ON public.question_bundle_questions USING btree (question_v2_id);


--
-- TOC entry 4381 (class 1259 OID 162820647)
-- Name: question_bundle_question_questionbundle_id_eb59316b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_bundle_question_questionbundle_id_eb59316b ON public.question_bundle_questions USING btree (questionbundle_id);


--
-- TOC entry 4053 (class 1259 OID 33365)
-- Name: question_lo_id_fad5517d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_lo_id_fad5517d ON public.question USING btree (lo_id);


--
-- TOC entry 4047 (class 1259 OID 33355)
-- Name: question_submission_assessment_id_fbc07e0f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_submission_assessment_id_fbc07e0f ON public.question_submission USING btree (assessment_id);


--
-- TOC entry 4048 (class 1259 OID 66437)
-- Name: question_submission_grade_id_f716969f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_submission_grade_id_f716969f ON public.question_submission USING btree (grade_id);


--
-- TOC entry 4051 (class 1259 OID 57357)
-- Name: question_submission_question_id_540e4dd4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_submission_question_id_540e4dd4 ON public.question_submission USING btree (question_id);


--
-- TOC entry 4052 (class 1259 OID 57344)
-- Name: question_submission_school_id_d78b85ed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_submission_school_id_d78b85ed ON public.question_submission USING btree (school_id);


--
-- TOC entry 4360 (class 1259 OID 162820614)
-- Name: question_v2_lo_id_13802219; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX question_v2_lo_id_13802219 ON public.question_v2 USING btree (lo_id);


--
-- TOC entry 4594 (class 1259 OID 277987491)
-- Name: sa_assessment_config_grade_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sa_assessment_config_grade_index ON public.sa_orf_assessment_config USING btree (grade);


--
-- TOC entry 4587 (class 1259 OID 277987425)
-- Name: sa_evaluator_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sa_evaluator_id_index ON public.sa_evaluations USING btree (evaluator_id);


--
-- TOC entry 4584 (class 1259 OID 277988091)
-- Name: school_evaluation_date_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX school_evaluation_date_index ON public.sa_school_evaluations USING btree (school_id, evaluation_date);


--
-- TOC entry 4009 (class 1259 OID 33295)
-- Name: school_grade_grade_id_400c027b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX school_grade_grade_id_400c027b ON public.school_grade USING btree (grade_id);


--
-- TOC entry 4012 (class 1259 OID 33294)
-- Name: school_grade_school_id_9bd71438; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX school_grade_school_id_9bd71438 ON public.school_grade USING btree (school_id);


--
-- TOC entry 4004 (class 1259 OID 33281)
-- Name: school_location_id_429307ea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX school_location_id_429307ea ON public.school USING btree (location_id);


--
-- TOC entry 4520 (class 1259 OID 163754486)
-- Name: server_celeryduplicateremove_assessment_id_c9f756f1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_celeryduplicateremove_assessment_id_c9f756f1 ON public.celery_duplicate_remove USING btree (assessment_id);


--
-- TOC entry 4523 (class 1259 OID 163754487)
-- Name: server_celeryduplicateremove_school_id_a6b700f3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_celeryduplicateremove_school_id_a6b700f3 ON public.celery_duplicate_remove USING btree (school_id);


--
-- TOC entry 4109 (class 1259 OID 21198026)
-- Name: server_enrollment_school_id_0c7af6d1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_enrollment_school_id_0c7af6d1 ON public.enrollment USING btree (school_id);


--
-- TOC entry 4110 (class 1259 OID 21198027)
-- Name: server_enrollment_student_id_a1c25d7b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_enrollment_student_id_a1c25d7b ON public.enrollment USING btree (student_id);


--
-- TOC entry 4289 (class 1259 OID 154025564)
-- Name: server_logroup_lo_lo_id_c501b552; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_logroup_lo_lo_id_c501b552 ON public.server_logroup_lo USING btree (lo_id);


--
-- TOC entry 4290 (class 1259 OID 154025563)
-- Name: server_logroup_lo_logroup_id_117a092c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_logroup_lo_logroup_id_117a092c ON public.server_logroup_lo USING btree (logroup_id);


--
-- TOC entry 4285 (class 1259 OID 154025550)
-- Name: server_questiongroup_question_question_id_3e90dc7f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_questiongroup_question_question_id_3e90dc7f ON public.server_questiongroup_question USING btree (question_id);


--
-- TOC entry 4286 (class 1259 OID 154025549)
-- Name: server_questiongroup_question_questiongroup_id_4e7f6396; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_questiongroup_question_questiongroup_id_4e7f6396 ON public.server_questiongroup_question USING btree (questiongroup_id);


--
-- TOC entry 4104 (class 1259 OID 14701056)
-- Name: server_questionsubmissionview_subject_79f68f78_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_questionsubmissionview_subject_79f68f78_like ON public.questions_submission_expanded USING btree (subject varchar_pattern_ops);


--
-- TOC entry 4331 (class 1259 OID 154025781)
-- Name: server_teacher_school_id_81199ae6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_teacher_school_id_81199ae6 ON public.teacher USING btree (school_id);


--
-- TOC entry 4335 (class 1259 OID 154025795)
-- Name: server_teacher_subjects_subject_id_9fb2c7a9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_teacher_subjects_subject_id_9fb2c7a9 ON public.teacher_subjects USING btree (subject_id);


--
-- TOC entry 4336 (class 1259 OID 154025794)
-- Name: server_teacher_subjects_teacher_id_bd301b11; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX server_teacher_subjects_teacher_id_bd301b11 ON public.teacher_subjects USING btree (teacher_id);


--
-- TOC entry 4180 (class 1259 OID 21223207)
-- Name: silk_profile_queries_profile_id_a3d76db8; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_profile_queries_profile_id_a3d76db8 ON public.silk_profile_queries USING btree (profile_id);


--
-- TOC entry 4183 (class 1259 OID 21223208)
-- Name: silk_profile_queries_sqlquery_id_155df455; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_profile_queries_sqlquery_id_155df455 ON public.silk_profile_queries USING btree (sqlquery_id);


--
-- TOC entry 4158 (class 1259 OID 21223209)
-- Name: silk_profile_request_id_7b81bd69; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_profile_request_id_7b81bd69 ON public.silk_profile USING btree (request_id);


--
-- TOC entry 4159 (class 1259 OID 21223210)
-- Name: silk_profile_request_id_7b81bd69_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_profile_request_id_7b81bd69_like ON public.silk_profile USING btree (request_id varchar_pattern_ops);


--
-- TOC entry 4160 (class 1259 OID 21223175)
-- Name: silk_request_id_5a356c4f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_request_id_5a356c4f_like ON public.silk_request USING btree (id varchar_pattern_ops);


--
-- TOC entry 4161 (class 1259 OID 21223176)
-- Name: silk_request_path_9f3d798e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_request_path_9f3d798e ON public.silk_request USING btree (path);


--
-- TOC entry 4162 (class 1259 OID 21223177)
-- Name: silk_request_path_9f3d798e_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_request_path_9f3d798e_like ON public.silk_request USING btree (path varchar_pattern_ops);


--
-- TOC entry 4165 (class 1259 OID 21223178)
-- Name: silk_request_start_time_1300bc58; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_request_start_time_1300bc58 ON public.silk_request USING btree (start_time);


--
-- TOC entry 4166 (class 1259 OID 21223179)
-- Name: silk_request_view_name_68559f7b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_request_view_name_68559f7b ON public.silk_request USING btree (view_name);


--
-- TOC entry 4167 (class 1259 OID 21223180)
-- Name: silk_request_view_name_68559f7b_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_request_view_name_68559f7b_like ON public.silk_request USING btree (view_name varchar_pattern_ops);


--
-- TOC entry 4168 (class 1259 OID 21223186)
-- Name: silk_response_id_dda88710_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_response_id_dda88710_like ON public.silk_response USING btree (id varchar_pattern_ops);


--
-- TOC entry 4171 (class 1259 OID 21223187)
-- Name: silk_response_request_id_1e8e2776_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_response_request_id_1e8e2776_like ON public.silk_response USING btree (request_id varchar_pattern_ops);


--
-- TOC entry 4176 (class 1259 OID 21223193)
-- Name: silk_sqlquery_request_id_6f8f0527; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_sqlquery_request_id_6f8f0527 ON public.silk_sqlquery USING btree (request_id);


--
-- TOC entry 4177 (class 1259 OID 21223194)
-- Name: silk_sqlquery_request_id_6f8f0527_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX silk_sqlquery_request_id_6f8f0527_like ON public.silk_sqlquery USING btree (request_id varchar_pattern_ops);


--
-- TOC entry 4033 (class 1259 OID 9371232)
-- Name: sms-idx-created-status-tries-code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sms-idx-created-status-tries-code" ON public.sms USING btree (created, tries, response_code, status);


--
-- TOC entry 4034 (class 1259 OID 9530771)
-- Name: sms-idx-msg-id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sms-idx-msg-id" ON public.sms USING btree (message_id);


--
-- TOC entry 4035 (class 1259 OID 9375608)
-- Name: sms-idx-status-tries; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sms-idx-status-tries" ON public.sms USING btree (status, tries);


--
-- TOC entry 4036 (class 1259 OID 9207829)
-- Name: sms-text-phone-idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sms-text-phone-idx" ON public.sms USING btree (text, phone);


--
-- TOC entry 4037 (class 1259 OID 9150464)
-- Name: sms_formid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sms_formid_idx ON public.sms USING btree (form_id);


--
-- TOC entry 4038 (class 1259 OID 33328)
-- Name: sms_messageId_564a7374_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "sms_messageId_564a7374_like" ON public.sms USING btree (message_id varchar_pattern_ops);


--
-- TOC entry 4043 (class 1259 OID 21206380)
-- Name: sms_school_formtype_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sms_school_formtype_idx ON public.sms USING btree (school, form_type);


--
-- TOC entry 4044 (class 1259 OID 9150467)
-- Name: sms_school_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sms_school_status_idx ON public.sms USING btree (status, school);


--
-- TOC entry 4045 (class 1259 OID 9150466)
-- Name: sms_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sms_status_idx ON public.sms USING btree (status);


--
-- TOC entry 4046 (class 1259 OID 33329)
-- Name: sms_student_id_d1cd8632; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sms_student_id_d1cd8632 ON public.sms USING btree (student_id);


--
-- TOC entry 4113 (class 1259 OID 21198127)
-- Name: stream_common_subject_stream_id_fb6b2029; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_common_subject_stream_id_fb6b2029 ON public.stream_common_subject USING btree (stream_id);


--
-- TOC entry 4116 (class 1259 OID 21198128)
-- Name: stream_common_subject_subject_id_23a05ba7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_common_subject_subject_id_23a05ba7 ON public.stream_common_subject USING btree (subject_id);


--
-- TOC entry 4119 (class 1259 OID 21198141)
-- Name: stream_optional_subjects_1_stream_id_1352a099; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_1_stream_id_1352a099 ON public.stream_optional_subjects_1 USING btree (stream_id);


--
-- TOC entry 4122 (class 1259 OID 21198142)
-- Name: stream_optional_subjects_1_subject_id_d4248bf6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_1_subject_id_d4248bf6 ON public.stream_optional_subjects_1 USING btree (subject_id);


--
-- TOC entry 4125 (class 1259 OID 21198155)
-- Name: stream_optional_subjects_2_stream_id_6adb5b26; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_2_stream_id_6adb5b26 ON public.stream_optional_subjects_2 USING btree (stream_id);


--
-- TOC entry 4128 (class 1259 OID 21198156)
-- Name: stream_optional_subjects_2_subject_id_0b734bff; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_2_subject_id_0b734bff ON public.stream_optional_subjects_2 USING btree (subject_id);


--
-- TOC entry 4131 (class 1259 OID 21198169)
-- Name: stream_optional_subjects_3_stream_id_3a3ca88d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_3_stream_id_3a3ca88d ON public.stream_optional_subjects_3 USING btree (stream_id);


--
-- TOC entry 4134 (class 1259 OID 21198170)
-- Name: stream_optional_subjects_3_subject_id_3e44c320; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_3_subject_id_3e44c320 ON public.stream_optional_subjects_3 USING btree (subject_id);


--
-- TOC entry 4137 (class 1259 OID 21198183)
-- Name: stream_optional_subjects_4_stream_id_989cd299; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_4_stream_id_989cd299 ON public.stream_optional_subjects_4 USING btree (stream_id);


--
-- TOC entry 4140 (class 1259 OID 21198184)
-- Name: stream_optional_subjects_4_subject_id_ce1acd7d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stream_optional_subjects_4_subject_id_ce1acd7d ON public.stream_optional_subjects_4 USING btree (subject_id);


--
-- TOC entry 4025 (class 1259 OID 21182632)
-- Name: stud_cat_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_cat_idx ON public.student USING btree (category);


--
-- TOC entry 4026 (class 1259 OID 21182633)
-- Name: stud_cwsn_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_cwsn_idx ON public.student USING btree (is_cwsn);


--
-- TOC entry 4027 (class 1259 OID 21182630)
-- Name: stud_gen_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_gen_idx ON public.student USING btree (gender);


--
-- TOC entry 4028 (class 1259 OID 21182631)
-- Name: stud_grade_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_grade_idx ON public.student USING btree (grade_number);


--
-- TOC entry 4068 (class 1259 OID 21182629)
-- Name: stud_sub_ass_grade_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_sub_ass_grade_idx ON public.student_submission USING btree (assessment_grade);


--
-- TOC entry 4069 (class 1259 OID 65928338)
-- Name: stud_sub_ass_school_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_sub_ass_school_idx ON public.student_submission USING btree (assessment_id, grade_number, section);


--
-- TOC entry 4070 (class 1259 OID 65928426)
-- Name: stud_sub_subject_ass_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX stud_sub_subject_ass_idx ON public.student_submission USING btree (subject_id, assessment_id);


--
-- TOC entry 4554 (class 1259 OID 277958663)
-- Name: student_data_mv_district_block_cluster_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_data_mv_district_block_cluster_idx ON public.student_data_mv USING btree (district, block, cluster);


--
-- TOC entry 4555 (class 1259 OID 277958659)
-- Name: student_data_mv_district_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_data_mv_district_idx ON public.student_data_mv USING btree (district);


--
-- TOC entry 4556 (class 1259 OID 277958662)
-- Name: student_data_mv_is_enabled; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_data_mv_is_enabled ON public.student_data_mv USING btree (is_enabled);


--
-- TOC entry 4615 (class 1259 OID 278029985)
-- Name: student_document_documents_id_b433dd62; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_document_documents_id_b433dd62 ON public.student_document USING btree (documents_id);


--
-- TOC entry 4618 (class 1259 OID 278029984)
-- Name: student_document_student_id_3e104445; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_document_student_id_3e104445 ON public.student_document USING btree (student_id);


--
-- TOC entry 4029 (class 1259 OID 21206381)
-- Name: student_is_enabled_school_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_is_enabled_school_idx ON public.student USING btree (is_enabled, school_id);


--
-- TOC entry 4030 (class 1259 OID 65928523)
-- Name: student_school_grade_is_enabled; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_school_grade_is_enabled ON public.student USING btree (school_id, is_enabled, grade_number);


--
-- TOC entry 4143 (class 1259 OID 21198197)
-- Name: student_subject_student_id_fc398bf1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_subject_student_id_fc398bf1 ON public.student_subject USING btree (student_id);


--
-- TOC entry 4146 (class 1259 OID 21198198)
-- Name: student_subject_subject_id_771923a7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_subject_subject_id_771923a7 ON public.student_subject USING btree (subject_id);


--
-- TOC entry 4071 (class 1259 OID 33455)
-- Name: student_submission_assessment_id_c664e230; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_assessment_id_c664e230 ON public.student_submission USING btree (assessment_id);


--
-- TOC entry 4072 (class 1259 OID 33456)
-- Name: student_submission_form_id_d4a337f2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_form_id_d4a337f2 ON public.student_submission USING btree (form_id);


--
-- TOC entry 4075 (class 1259 OID 33457)
-- Name: student_submission_sms_id_9a525bbc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_sms_id_9a525bbc ON public.student_submission USING btree (sms_id);


--
-- TOC entry 4076 (class 1259 OID 33458)
-- Name: student_submission_student_id_904b832b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_student_id_904b832b ON public.student_submission USING btree (student_id);


--
-- TOC entry 4077 (class 1259 OID 33459)
-- Name: student_submission_subject_id_966da6e3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_subject_id_966da6e3 ON public.student_submission USING btree (subject_id);


--
-- TOC entry 4486 (class 1259 OID 162821738)
-- Name: student_submission_v2_assessment_id_bdac128e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_assessment_id_bdac128e ON public.student_submission_v2 USING btree (assessment_id);


--
-- TOC entry 4487 (class 1259 OID 162821812)
-- Name: student_submission_v2_assessment_unit_id_cdfde6a5; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_assessment_unit_id_cdfde6a5 ON public.student_submission_v2 USING btree (assessment_unit_id);


--
-- TOC entry 4488 (class 1259 OID 162821740)
-- Name: student_submission_v2_grade_id_30f0325e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_grade_id_30f0325e ON public.student_submission_v2 USING btree (grade_id);


--
-- TOC entry 4489 (class 1259 OID 162821818)
-- Name: student_submission_v2_grade_submissions_id_6d14a9ca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_grade_submissions_id_6d14a9ca ON public.student_submission_v2 USING btree (grade_submissions_id);


--
-- TOC entry 4498 (class 1259 OID 162821759)
-- Name: student_submission_v2_mark_componentsubmission_id_53d56d87; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_mark_componentsubmission_id_53d56d87 ON public.student_submission_v2_marks_submissions USING btree (componentsubmission_id);


--
-- TOC entry 4499 (class 1259 OID 162821758)
-- Name: student_submission_v2_mark_studentsubmission_v2_id_c6619625; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_mark_studentsubmission_v2_id_c6619625 ON public.student_submission_v2_marks_submissions USING btree (studentsubmission_v2_id);


--
-- TOC entry 4492 (class 1259 OID 162821742)
-- Name: student_submission_v2_school_id_9c916e5f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_school_id_9c916e5f ON public.student_submission_v2 USING btree (school_id);


--
-- TOC entry 4493 (class 1259 OID 162821743)
-- Name: student_submission_v2_stream_id_7893d7e7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_stream_id_7893d7e7 ON public.student_submission_v2 USING btree (stream_id);


--
-- TOC entry 4494 (class 1259 OID 162821744)
-- Name: student_submission_v2_student_id_f5a60c8a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_student_id_f5a60c8a ON public.student_submission_v2 USING btree (student_id);


--
-- TOC entry 4495 (class 1259 OID 162821745)
-- Name: student_submission_v2_subject_id_4e435475; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX student_submission_v2_subject_id_4e435475 ON public.student_submission_v2 USING btree (subject_id);


--
-- TOC entry 4198 (class 1259 OID 32010123)
-- Name: subject_submission_assessment_id_1b067946; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_assessment_id_1b067946 ON public.subject_submission USING btree (assessment_id);


--
-- TOC entry 4199 (class 1259 OID 37043567)
-- Name: subject_submission_grade_id_0f0162e0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_grade_id_0f0162e0 ON public.subject_submission USING btree (grade_id);


--
-- TOC entry 4202 (class 1259 OID 32010125)
-- Name: subject_submission_school_id_3893a9b3; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_school_id_3893a9b3 ON public.subject_submission USING btree (school_id);


--
-- TOC entry 4207 (class 1259 OID 32010162)
-- Name: subject_submission_selected_lo_lo_id_5954b7a1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_selected_lo_lo_id_5954b7a1 ON public.subject_submission_selected_lo USING btree (lo_id);


--
-- TOC entry 4210 (class 1259 OID 32010156)
-- Name: subject_submission_selected_lo_subjectsubmission_id_f6bd3bb0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_selected_lo_subjectsubmission_id_f6bd3bb0 ON public.subject_submission_selected_lo USING btree (subjectsubmission_id);


--
-- TOC entry 4203 (class 1259 OID 36772669)
-- Name: subject_submission_stream_id_eaac1347; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_stream_id_eaac1347 ON public.subject_submission USING btree (stream_id);


--
-- TOC entry 4204 (class 1259 OID 32010130)
-- Name: subject_submission_subject_id_fd20acbd; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX subject_submission_subject_id_fd20acbd ON public.subject_submission USING btree (subject_id);


--
-- TOC entry 4019 (class 1259 OID 33302)
-- Name: submission_summary_assessment_id_5985453c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX submission_summary_assessment_id_5985453c ON public.submission_summary USING btree (assessment_id);


--
-- TOC entry 4332 (class 1259 OID 154025796)
-- Name: teacher_parent_id_2a1680a7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX teacher_parent_id_2a1680a7 ON public.teacher USING btree (parent_id);


--
-- TOC entry 4372 (class 1259 OID 162820634)
-- Name: unit_bundle_unit_unit_v2_id_a5f9cc7a; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unit_bundle_unit_unit_v2_id_a5f9cc7a ON public.unit_bundle_units USING btree (unit_v2_id);


--
-- TOC entry 4373 (class 1259 OID 162820633)
-- Name: unit_bundle_unit_unitbundle_id_68137e40; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unit_bundle_unit_unitbundle_id_68137e40 ON public.unit_bundle_units USING btree (unitbundle_id);


--
-- TOC entry 4367 (class 1259 OID 162820620)
-- Name: unit_v2_subject_id_fc0bd89d; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX unit_v2_subject_id_fc0bd89d ON public.unit_v2 USING btree (subject_id);


--
-- TOC entry 4623 (class 1259 OID 278030005)
-- Name: vc_school_id_35b48dd4; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vc_school_id_35b48dd4 ON public.vc USING btree (school_id);


--
-- TOC entry 4624 (class 1259 OID 278030006)
-- Name: vc_student_id_20cd21b0; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vc_student_id_20cd21b0 ON public.vc USING btree (student_id);


--
-- TOC entry 4854 (class 2620 OID 278035983)
-- Name: submission notify_hasura_insert_submission_INSERT; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "notify_hasura_insert_submission_INSERT" AFTER INSERT ON public.submission FOR EACH ROW EXECUTE PROCEDURE hdb_catalog."notify_hasura_insert_submission_INSERT"();


--
-- TOC entry 4842 (class 2620 OID 170512782)
-- Name: attendance_teacher set_public_attendance_teacher_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_attendance_teacher_updated_at BEFORE UPDATE ON public.attendance_teacher FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 4842
-- Name: TRIGGER set_public_attendance_teacher_updated_at ON attendance_teacher; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_attendance_teacher_updated_at ON public.attendance_teacher IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4839 (class 2620 OID 130745921)
-- Name: device_demand_response set_public_device_demand_response_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_device_demand_response_updated_at BEFORE UPDATE ON public.device_demand_response FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 4839
-- Name: TRIGGER set_public_device_demand_response_updated_at ON device_demand_response; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_device_demand_response_updated_at ON public.device_demand_response IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4838 (class 2620 OID 118521842)
-- Name: device_donation_donor set_public_device_donation_donor_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_device_donation_donor_updated_at BEFORE UPDATE ON public.device_donation_donor FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 4838
-- Name: TRIGGER set_public_device_donation_donor_updated_at ON device_donation_donor; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_device_donation_donor_updated_at ON public.device_donation_donor IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4841 (class 2620 OID 157858358)
-- Name: device_verification_records set_public_device_verification_records_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_device_verification_records_updated_at BEFORE UPDATE ON public.device_verification_records FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 4841
-- Name: TRIGGER set_public_device_verification_records_updated_at ON device_verification_records; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_device_verification_records_updated_at ON public.device_verification_records IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4846 (class 2620 OID 277987288)
-- Name: group set_public_group_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_group_updated_at BEFORE UPDATE ON public."group" FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 4846
-- Name: TRIGGER set_public_group_updated_at ON "group"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_group_updated_at ON public."group" IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4847 (class 2620 OID 277987307)
-- Name: groupmembership set_public_groupmembership_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_groupmembership_updated_at BEFORE UPDATE ON public.groupmembership FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 4847
-- Name: TRIGGER set_public_groupmembership_updated_at ON groupmembership; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_groupmembership_updated_at ON public.groupmembership IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4848 (class 2620 OID 277987326)
-- Name: monitortracking set_public_monitortracking_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_monitortracking_updated_at BEFORE UPDATE ON public.monitortracking FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 4848
-- Name: TRIGGER set_public_monitortracking_updated_at ON monitortracking; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_monitortracking_updated_at ON public.monitortracking IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4849 (class 2620 OID 277987347)
-- Name: role set_public_role_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_role_updated_at BEFORE UPDATE ON public.role FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 4849
-- Name: TRIGGER set_public_role_updated_at ON role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_role_updated_at ON public.role IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4852 (class 2620 OID 277987492)
-- Name: sa_orf_assessment_config set_public_sa_assessment_config_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_sa_assessment_config_updated_at BEFORE UPDATE ON public.sa_orf_assessment_config FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 4852
-- Name: TRIGGER set_public_sa_assessment_config_updated_at ON sa_orf_assessment_config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_sa_assessment_config_updated_at ON public.sa_orf_assessment_config IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4853 (class 2620 OID 277987493)
-- Name: sa_orf_assessment_config set_public_sa_orf_assessment_config_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_sa_orf_assessment_config_updated_at BEFORE UPDATE ON public.sa_orf_assessment_config FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 4853
-- Name: TRIGGER set_public_sa_orf_assessment_config_updated_at ON sa_orf_assessment_config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_sa_orf_assessment_config_updated_at ON public.sa_orf_assessment_config IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4850 (class 2620 OID 277987398)
-- Name: sa_school_evaluations set_public_sa_school_evaluations_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_sa_school_evaluations_updated_at BEFORE UPDATE ON public.sa_school_evaluations FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 4850
-- Name: TRIGGER set_public_sa_school_evaluations_updated_at ON sa_school_evaluations; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_sa_school_evaluations_updated_at ON public.sa_school_evaluations IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4845 (class 2620 OID 180722176)
-- Name: ss_school_allocation_data set_public_ss_school_allocation_data_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_ss_school_allocation_data_updated_at BEFORE UPDATE ON public.ss_school_allocation_data FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 4845
-- Name: TRIGGER set_public_ss_school_allocation_data_updated_at ON ss_school_allocation_data; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_ss_school_allocation_data_updated_at ON public.ss_school_allocation_data IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4844 (class 2620 OID 180722102)
-- Name: ss_school_allocation_quarter set_public_ss_school_allocation_quarter_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_ss_school_allocation_quarter_updated_at BEFORE UPDATE ON public.ss_school_allocation_quarter FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 4844
-- Name: TRIGGER set_public_ss_school_allocation_quarter_updated_at ON ss_school_allocation_quarter; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_ss_school_allocation_quarter_updated_at ON public.ss_school_allocation_quarter IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4843 (class 2620 OID 171197589)
-- Name: student_content_share set_public_student_content_share_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_student_content_share_updated_at BEFORE UPDATE ON public.student_content_share FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 4843
-- Name: TRIGGER set_public_student_content_share_updated_at ON student_content_share; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_student_content_share_updated_at ON public.student_content_share IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4840 (class 2620 OID 153776052)
-- Name: test_telemetry set_public_test_telemetry_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_test_telemetry_updated_at BEFORE UPDATE ON public.test_telemetry FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 4840
-- Name: TRIGGER set_public_test_telemetry_updated_at ON test_telemetry; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_test_telemetry_updated_at ON public.test_telemetry IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4851 (class 2620 OID 277987468)
-- Name: trackassessment set_public_trackassessment_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_public_trackassessment_updated_at BEFORE UPDATE ON public.trackassessment FOR EACH ROW EXECUTE PROCEDURE public.set_current_timestamp_updated_at();


--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 4851
-- Name: TRIGGER set_public_trackassessment_updated_at ON trackassessment; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER set_public_trackassessment_updated_at ON public.trackassessment IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- TOC entry 4648 (class 2606 OID 33303)
-- Name: student Student_school_id_87dda7cd_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT "Student_school_id_87dda7cd_fk_school_id" FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4736 (class 2606 OID 154025697)
-- Name: assessment_au_lo_aggregate_submission assessment_au_lo_agg_assessment_id_70b49f0a_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate_submission
    ADD CONSTRAINT assessment_au_lo_agg_assessment_id_70b49f0a_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment_au_lo_aggregate(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4706 (class 2606 OID 154025722)
-- Name: assessment_au_lo_aggregate assessment_au_lo_agg_assessment_id_c9116bb9_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate
    ADD CONSTRAINT assessment_au_lo_agg_assessment_id_c9116bb9_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4737 (class 2606 OID 154025702)
-- Name: assessment_au_lo_aggregate_submission assessment_au_lo_agg_grade_id_f0d66c68_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate_submission
    ADD CONSTRAINT assessment_au_lo_agg_grade_id_f0d66c68_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4738 (class 2606 OID 154025738)
-- Name: assessment_au_lo_aggregate_submission assessment_au_lo_agg_school_id_8f365921_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate_submission
    ADD CONSTRAINT assessment_au_lo_agg_school_id_8f365921_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4707 (class 2606 OID 154025728)
-- Name: assessment_au_lo_aggregate assessment_au_lo_aggregate_los_id_37199e71_fk_server_logroup_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate
    ADD CONSTRAINT assessment_au_lo_aggregate_los_id_37199e71_fk_server_logroup_id FOREIGN KEY (los_id) REFERENCES public.server_logroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4739 (class 2606 OID 154025707)
-- Name: assessment_au_lo_aggregate_submission assessment_au_lo_aggregate_submission_lo_id_b090a0c5_fk_lo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_lo_aggregate_submission
    ADD CONSTRAINT assessment_au_lo_aggregate_submission_lo_id_b090a0c5_fk_lo_id FOREIGN KEY (lo_id) REFERENCES public.lo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4734 (class 2606 OID 154025685)
-- Name: assessment_au_question_aggregate assessment_au_questi_assessment_id_e34a737c_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate
    ADD CONSTRAINT assessment_au_questi_assessment_id_e34a737c_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4730 (class 2606 OID 154025661)
-- Name: assessment_au_question_aggregate_submission assessment_au_questi_assessment_id_e5a4b584_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate_submission
    ADD CONSTRAINT assessment_au_questi_assessment_id_e5a4b584_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4731 (class 2606 OID 154025666)
-- Name: assessment_au_question_aggregate_submission assessment_au_questi_grade_id_dd72165f_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate_submission
    ADD CONSTRAINT assessment_au_questi_grade_id_dd72165f_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4735 (class 2606 OID 154025733)
-- Name: assessment_au_question_aggregate assessment_au_questi_question_id_8ed0f963_fk_server_qu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate
    ADD CONSTRAINT assessment_au_questi_question_id_8ed0f963_fk_server_qu FOREIGN KEY (question_id) REFERENCES public.server_questiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4732 (class 2606 OID 154025671)
-- Name: assessment_au_question_aggregate_submission assessment_au_questi_question_id_ca4feed0_fk_question_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate_submission
    ADD CONSTRAINT assessment_au_questi_question_id_ca4feed0_fk_question_ FOREIGN KEY (question_id) REFERENCES public.question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4733 (class 2606 OID 154025743)
-- Name: assessment_au_question_aggregate_submission assessment_au_questi_school_id_cce03782_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_au_question_aggregate_submission
    ADD CONSTRAINT assessment_au_questi_school_id_cce03782_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4634 (class 2606 OID 162821283)
-- Name: assessment assessment_builder_id_5b99d1cf_fk_assessment_builder_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT assessment_builder_id_5b99d1cf_fk_assessment_builder_id FOREIGN KEY (builder_id) REFERENCES public.assessment_builder(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4701 (class 2606 OID 37714317)
-- Name: assessment_cache assessment_cache_assessment_id_5b0b6eaa_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache
    ADD CONSTRAINT assessment_cache_assessment_id_5b0b6eaa_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4702 (class 2606 OID 37714322)
-- Name: assessment_cache assessment_cache_school_id_e18b77ad_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache
    ADD CONSTRAINT assessment_cache_school_id_e18b77ad_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4810 (class 2606 OID 163512762)
-- Name: assessment_cache_v5 assessment_cache_v5_assessment_id_dbbfbcf0_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache_v5
    ADD CONSTRAINT assessment_cache_v5_assessment_id_dbbfbcf0_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4811 (class 2606 OID 163512767)
-- Name: assessment_cache_v5 assessment_cache_v5_school_id_f95f1c50_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_cache_v5
    ADD CONSTRAINT assessment_cache_v5_school_id_f95f1c50_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4761 (class 2606 OID 162820689)
-- Name: assessment_components assessment_components_assessment_id_e6751dea_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_components
    ADD CONSTRAINT assessment_components_assessment_id_e6751dea_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4762 (class 2606 OID 162820694)
-- Name: assessment_components assessment_components_components_id_7f56cb42_fk_component_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_components
    ADD CONSTRAINT assessment_components_components_id_7f56cb42_fk_component_id FOREIGN KEY (components_id) REFERENCES public.component(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4635 (class 2606 OID 33403)
-- Name: assessment assessment_deadline_id_e035e5a1_fk_deadline_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT assessment_deadline_id_e035e5a1_fk_deadline_id FOREIGN KEY (deadline_id) REFERENCES public.deadline(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4723 (class 2606 OID 154025613)
-- Name: assessment_ep_grade_submission assessment_ep_grade__assessment_id_db6661c3_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade__assessment_id_db6661c3_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment_ep_grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4724 (class 2606 OID 154025618)
-- Name: assessment_ep_grade_submission assessment_ep_grade__form_id_677b1020_fk_grade_ass; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade__form_id_677b1020_fk_grade_ass FOREIGN KEY (form_id) REFERENCES public.grade_assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4725 (class 2606 OID 154025633)
-- Name: assessment_ep_grade_submission assessment_ep_grade__student_id_80b4178f_fk_student_i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade__student_id_80b4178f_fk_student_i FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4726 (class 2606 OID 154025638)
-- Name: assessment_ep_grade_submission assessment_ep_grade__subject_id_67959872_fk_subject_i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade__subject_id_67959872_fk_subject_i FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4708 (class 2606 OID 154025650)
-- Name: assessment_ep_grade assessment_ep_grade_assessment_id_9d58eb40_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade
    ADD CONSTRAINT assessment_ep_grade_assessment_id_9d58eb40_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4709 (class 2606 OID 154025656)
-- Name: assessment_ep_grade assessment_ep_grade_grade_mapping_id_c90e34d3_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade
    ADD CONSTRAINT assessment_ep_grade_grade_mapping_id_c90e34d3_fk_assessmen FOREIGN KEY (grade_mapping_id) REFERENCES public.assessment_grade_mapping(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4727 (class 2606 OID 154025623)
-- Name: assessment_ep_grade_submission assessment_ep_grade_submission_grade_id_99152754_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade_submission_grade_id_99152754_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4728 (class 2606 OID 154025749)
-- Name: assessment_ep_grade_submission assessment_ep_grade_submission_school_id_e260c95a_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade_submission_school_id_e260c95a_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4729 (class 2606 OID 154025628)
-- Name: assessment_ep_grade_submission assessment_ep_grade_submission_sms_id_990c901a_fk_sms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_grade_submission
    ADD CONSTRAINT assessment_ep_grade_submission_sms_id_990c901a_fk_sms_id FOREIGN KEY (sms_id) REFERENCES public.sms(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4716 (class 2606 OID 154025565)
-- Name: assessment_ep_marks_submission assessment_ep_marks__assessment_id_9eb88b11_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks__assessment_id_9eb88b11_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment_ep_marks(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4717 (class 2606 OID 154025570)
-- Name: assessment_ep_marks_submission assessment_ep_marks__form_id_edd4db41_fk_grade_ass; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks__form_id_edd4db41_fk_grade_ass FOREIGN KEY (form_id) REFERENCES public.grade_assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4718 (class 2606 OID 154025585)
-- Name: assessment_ep_marks_submission assessment_ep_marks__student_id_655549b1_fk_student_i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks__student_id_655549b1_fk_student_i FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4719 (class 2606 OID 154025590)
-- Name: assessment_ep_marks_submission assessment_ep_marks__subject_id_d5f06734_fk_subject_i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks__subject_id_d5f06734_fk_subject_i FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4710 (class 2606 OID 154025602)
-- Name: assessment_ep_marks assessment_ep_marks_assessment_id_6cb9567c_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks
    ADD CONSTRAINT assessment_ep_marks_assessment_id_6cb9567c_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4711 (class 2606 OID 154025608)
-- Name: assessment_ep_marks assessment_ep_marks_max_marks_range_id_43ea07b0_fk_server_ma; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks
    ADD CONSTRAINT assessment_ep_marks_max_marks_range_id_43ea07b0_fk_server_ma FOREIGN KEY (max_marks_range_id) REFERENCES public.server_marksrange(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4720 (class 2606 OID 154025575)
-- Name: assessment_ep_marks_submission assessment_ep_marks_submission_grade_id_daf2aabc_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks_submission_grade_id_daf2aabc_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4721 (class 2606 OID 154025755)
-- Name: assessment_ep_marks_submission assessment_ep_marks_submission_school_id_41e5151b_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks_submission_school_id_41e5151b_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4722 (class 2606 OID 154025580)
-- Name: assessment_ep_marks_submission assessment_ep_marks_submission_sms_id_5c707015_fk_sms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_ep_marks_submission
    ADD CONSTRAINT assessment_ep_marks_submission_sms_id_5c707015_fk_sms_id FOREIGN KEY (sms_id) REFERENCES public.sms(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4659 (class 2606 OID 31837340)
-- Name: assessment_grade assessment_grade_assessment_id_c8c6f85c_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade
    ADD CONSTRAINT assessment_grade_assessment_id_c8c6f85c_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4660 (class 2606 OID 31837325)
-- Name: assessment_grade assessment_grade_grade_id_081af151_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_grade
    ADD CONSTRAINT assessment_grade_grade_id_081af151_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4763 (class 2606 OID 162821268)
-- Name: assessment_lo_bundles assessment_lo_bundles_assessment_id_e7ebfe13_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_lo_bundles
    ADD CONSTRAINT assessment_lo_bundles_assessment_id_e7ebfe13_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4764 (class 2606 OID 162821263)
-- Name: assessment_lo_bundles assessment_lo_bundles_lobundle_id_1ac9fb13_fk_lo_bundle_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_lo_bundles
    ADD CONSTRAINT assessment_lo_bundles_lobundle_id_1ac9fb13_fk_lo_bundle_id FOREIGN KEY (lobundle_id) REFERENCES public.lo_bundle(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4636 (class 2606 OID 162821288)
-- Name: assessment assessment_mapping_id_c61f4e3e_fk_mapping_details_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT assessment_mapping_id_c61f4e3e_fk_mapping_details_id FOREIGN KEY (mapping_id) REFERENCES public.mapping_details(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4765 (class 2606 OID 162821298)
-- Name: assessment_question_bundles assessment_question__assessment_id_45055a4d_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_question_bundles
    ADD CONSTRAINT assessment_question__assessment_id_45055a4d_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4766 (class 2606 OID 162821293)
-- Name: assessment_question_bundles assessment_question__questionbundle_id_38154f6d_fk_question_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_question_bundles
    ADD CONSTRAINT assessment_question__questionbundle_id_38154f6d_fk_question_ FOREIGN KEY (questionbundle_id) REFERENCES public.question_bundle(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4691 (class 2606 OID 31837345)
-- Name: assessment_stream assessment_stream_assessment_id_bc516271_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_stream
    ADD CONSTRAINT assessment_stream_assessment_id_bc516271_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4692 (class 2606 OID 31837350)
-- Name: assessment_stream assessment_stream_stream_id_65834252_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_stream
    ADD CONSTRAINT assessment_stream_stream_id_65834252_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4808 (class 2606 OID 162822005)
-- Name: assessment_subjects assessment_subjects_assessment_id_a474d938_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_subjects
    ADD CONSTRAINT assessment_subjects_assessment_id_a474d938_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4809 (class 2606 OID 162822000)
-- Name: assessment_subjects assessment_subjects_subject_id_7f8a3945_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_subjects
    ADD CONSTRAINT assessment_subjects_subject_id_7f8a3945_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4637 (class 2606 OID 162820732)
-- Name: assessment assessment_submission_type_v2_id_4e47c34d_fk_submission_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT assessment_submission_type_v2_id_4e47c34d_fk_submission_type_id FOREIGN KEY (submission_type_v2_id) REFERENCES public.submission_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4760 (class 2606 OID 162820683)
-- Name: assessment_type assessment_type_category_id_5618089c_fk_assessment_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_type
    ADD CONSTRAINT assessment_type_category_id_5618089c_fk_assessment_category_id FOREIGN KEY (category_id) REFERENCES public.assessment_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4638 (class 2606 OID 162820738)
-- Name: assessment assessment_type_v2_id_50640959_fk_assessment_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment
    ADD CONSTRAINT assessment_type_v2_id_50640959_fk_assessment_type_id FOREIGN KEY (type_v2_id) REFERENCES public.assessment_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4781 (class 2606 OID 162820943)
-- Name: assessment_unit assessment_unit_assessment_id_548def6a_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit
    ADD CONSTRAINT assessment_unit_assessment_id_548def6a_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4767 (class 2606 OID 162821273)
-- Name: assessment_unit_bundles assessment_unit_bund_unitbundle_id_3c4f62eb_fk_unit_bund; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_bundles
    ADD CONSTRAINT assessment_unit_bund_unitbundle_id_3c4f62eb_fk_unit_bund FOREIGN KEY (unitbundle_id) REFERENCES public.unit_bundle(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4768 (class 2606 OID 162821278)
-- Name: assessment_unit_bundles assessment_unit_bundles_assessment_id_68af8422_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_bundles
    ADD CONSTRAINT assessment_unit_bundles_assessment_id_68af8422_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4782 (class 2606 OID 162820948)
-- Name: assessment_unit assessment_unit_school_id_c6de07f8_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit
    ADD CONSTRAINT assessment_unit_school_id_c6de07f8_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4786 (class 2606 OID 162820975)
-- Name: assessment_unit_selected_question assessment_unit_sele_assessmentunit_id_0103a060_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_question
    ADD CONSTRAINT assessment_unit_sele_assessmentunit_id_0103a060_fk_assessmen FOREIGN KEY (assessmentunit_id) REFERENCES public.assessment_unit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4788 (class 2606 OID 162820989)
-- Name: assessment_unit_selected_unit assessment_unit_sele_assessmentunit_id_9ee175c8_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_unit
    ADD CONSTRAINT assessment_unit_sele_assessmentunit_id_9ee175c8_fk_assessmen FOREIGN KEY (assessmentunit_id) REFERENCES public.assessment_unit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4784 (class 2606 OID 162820961)
-- Name: assessment_unit_selected_lo assessment_unit_sele_assessmentunit_id_d4fd7d44_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_lo
    ADD CONSTRAINT assessment_unit_sele_assessmentunit_id_d4fd7d44_fk_assessmen FOREIGN KEY (assessmentunit_id) REFERENCES public.assessment_unit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4787 (class 2606 OID 162820980)
-- Name: assessment_unit_selected_question assessment_unit_sele_question_v2_id_9b993835_fk_question_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_question
    ADD CONSTRAINT assessment_unit_sele_question_v2_id_9b993835_fk_question_ FOREIGN KEY (question_v2_id) REFERENCES public.question_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4785 (class 2606 OID 162820966)
-- Name: assessment_unit_selected_lo assessment_unit_selected_lo_lo_v2_id_b37cb2ec_fk_lo_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_lo
    ADD CONSTRAINT assessment_unit_selected_lo_lo_v2_id_b37cb2ec_fk_lo_v2_id FOREIGN KEY (lo_v2_id) REFERENCES public.lo_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4789 (class 2606 OID 162820994)
-- Name: assessment_unit_selected_unit assessment_unit_selected_unit_unit_v2_id_deb8754c_fk_unit_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit_selected_unit
    ADD CONSTRAINT assessment_unit_selected_unit_unit_v2_id_deb8754c_fk_unit_v2_id FOREIGN KEY (unit_v2_id) REFERENCES public.unit_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4783 (class 2606 OID 162820953)
-- Name: assessment_unit assessment_unit_subject_id_7790c503_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assessment_unit
    ADD CONSTRAINT assessment_unit_subject_id_7790c503_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4819 (class 2606 OID 277984542)
-- Name: attendance_sms_logs attendance_sms_logs_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_sms_logs
    ADD CONSTRAINT attendance_sms_logs_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4684 (class 2606 OID 21223048)
-- Name: attendance attendance_student_id_d55196c7_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_d55196c7_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4685 (class 2606 OID 21223053)
-- Name: attendance attendance_taken_by_school_id_5cadefc1_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_taken_by_school_id_5cadefc1_fk_school_id FOREIGN KEY (taken_by_school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4814 (class 2606 OID 175266689)
-- Name: attendance_teacher attendance_teacher_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_teacher
    ADD CONSTRAINT attendance_teacher_status_fkey FOREIGN KEY (status) REFERENCES public.teacher_attendance_status(value);


--
-- TOC entry 4815 (class 2606 OID 170512777)
-- Name: attendance_teacher attendance_teacher_udise_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_teacher
    ADD CONSTRAINT attendance_teacher_udise_fkey FOREIGN KEY (udise) REFERENCES public.school(udise);


--
-- TOC entry 4626 (class 2606 OID 32988)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4627 (class 2606 OID 32983)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4625 (class 2606 OID 32974)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4628 (class 2606 OID 33003)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4629 (class 2606 OID 32998)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4630 (class 2606 OID 33017)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4631 (class 2606 OID 33012)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4778 (class 2606 OID 162821347)
-- Name: class_level_component_submission class_level_componen_assessment_id_6d89f4c1_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_level_component_submission
    ADD CONSTRAINT class_level_componen_assessment_id_6d89f4c1_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4779 (class 2606 OID 162821357)
-- Name: class_level_component_submission class_level_componen_school_id_1e2dddb4_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_level_component_submission
    ADD CONSTRAINT class_level_componen_school_id_1e2dddb4_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4780 (class 2606 OID 162821362)
-- Name: class_level_component_submission class_level_componen_subject_id_4ab260ef_fk_subject_i; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_level_component_submission
    ADD CONSTRAINT class_level_componen_subject_id_4ab260ef_fk_subject_i FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4790 (class 2606 OID 162821367)
-- Name: class_submission class_submission_assessment_id_b8eb4160_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_assessment_id_b8eb4160_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4791 (class 2606 OID 162821372)
-- Name: class_submission class_submission_grade_id_328ba948_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_grade_id_328ba948_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4792 (class 2606 OID 162821377)
-- Name: class_submission class_submission_lo_id_cc2f57c8_fk_lo_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_lo_id_cc2f57c8_fk_lo_v2_id FOREIGN KEY (lo_id) REFERENCES public.lo_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4793 (class 2606 OID 162821382)
-- Name: class_submission class_submission_question_id_d75abaee_fk_question_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_question_id_d75abaee_fk_question_v2_id FOREIGN KEY (question_id) REFERENCES public.question_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4794 (class 2606 OID 162821387)
-- Name: class_submission class_submission_school_id_08310adc_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_school_id_08310adc_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4795 (class 2606 OID 162821392)
-- Name: class_submission class_submission_subject_id_6746f684_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_subject_id_6746f684_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4796 (class 2606 OID 162821397)
-- Name: class_submission class_submission_submission_id_766fedbc_fk_class_lev; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_submission_id_766fedbc_fk_class_lev FOREIGN KEY (submission_id) REFERENCES public.class_level_component_submission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4797 (class 2606 OID 162821402)
-- Name: class_submission class_submission_unit_id_95152f45_fk_unit_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_submission
    ADD CONSTRAINT class_submission_unit_id_95152f45_fk_unit_v2_id FOREIGN KEY (unit_id) REFERENCES public.unit_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4757 (class 2606 OID 162820663)
-- Name: component component_component_type_id_c1de0061_fk_component_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT component_component_type_id_c1de0061_fk_component_type_id FOREIGN KEY (component_type_id) REFERENCES public.component_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4758 (class 2606 OID 162820669)
-- Name: component_subjects component_subjects_components_id_1de3ab7f_fk_component_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_subjects
    ADD CONSTRAINT component_subjects_components_id_1de3ab7f_fk_component_id FOREIGN KEY (components_id) REFERENCES public.component(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4759 (class 2606 OID 162820674)
-- Name: component_subjects component_subjects_subject_id_379d1d06_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_subjects
    ADD CONSTRAINT component_subjects_subject_id_379d1d06_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4774 (class 2606 OID 162820895)
-- Name: component_submission component_submission_assessment_id_106861f5_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_submission
    ADD CONSTRAINT component_submission_assessment_id_106861f5_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4775 (class 2606 OID 162820900)
-- Name: component_submission component_submission_component_id_4e513345_fk_component_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_submission
    ADD CONSTRAINT component_submission_component_id_4e513345_fk_component_id FOREIGN KEY (component_id) REFERENCES public.component(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4776 (class 2606 OID 162820905)
-- Name: component_submission component_submission_school_id_4607fe6c_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_submission
    ADD CONSTRAINT component_submission_school_id_4607fe6c_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4777 (class 2606 OID 162820910)
-- Name: component_submission component_submission_subject_id_244ce57e_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_submission
    ADD CONSTRAINT component_submission_subject_id_244ce57e_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4704 (class 2606 OID 153870434)
-- Name: corporate_donor_devices corporate_donor_devices_corporate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_donor_devices
    ADD CONSTRAINT corporate_donor_devices_corporate_id_fkey FOREIGN KEY (company_id) REFERENCES public.device_donation_corporates(company_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4705 (class 2606 OID 153941898)
-- Name: corporate_donor_devices corporate_donor_devices_recipient_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.corporate_donor_devices
    ADD CONSTRAINT corporate_donor_devices_recipient_school_id_fkey FOREIGN KEY (recipient_school_id) REFERENCES public.school(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4703 (class 2606 OID 154027319)
-- Name: device_donation_donor device_donation_donor_recipient_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_donation_donor
    ADD CONSTRAINT device_donation_donor_recipient_school_id_fkey FOREIGN KEY (recipient_school_id) REFERENCES public.school(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4745 (class 2606 OID 157858364)
-- Name: device_verification_records device_verification_records_device_tracking_key_corporate_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records
    ADD CONSTRAINT device_verification_records_device_tracking_key_corporate_fk FOREIGN KEY (device_tracking_key_corporate) REFERENCES public.corporate_donor_devices(device_tracking_key) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4746 (class 2606 OID 157858353)
-- Name: device_verification_records device_verification_records_device_tracking_key_individual_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records
    ADD CONSTRAINT device_verification_records_device_tracking_key_individual_fkey FOREIGN KEY (device_tracking_key_individual) REFERENCES public.device_donation_donor(device_tracking_key) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4747 (class 2606 OID 157858348)
-- Name: device_verification_records device_verification_records_udise_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_verification_records
    ADD CONSTRAINT device_verification_records_udise_fkey FOREIGN KEY (udise) REFERENCES public.school(udise) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4632 (class 2606 OID 33038)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4633 (class 2606 OID 33043)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4832 (class 2606 OID 278029958)
-- Name: event_trail_documents event_trail_document_studenttrail_id_67b26f69_fk_event_tra; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail_documents
    ADD CONSTRAINT event_trail_document_studenttrail_id_67b26f69_fk_event_tra FOREIGN KEY (studenttrail_id) REFERENCES public.event_trail(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4833 (class 2606 OID 278029963)
-- Name: event_trail_documents event_trail_documents_documents_id_a992d720_fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail_documents
    ADD CONSTRAINT event_trail_documents_documents_id_a992d720_fk_document_id FOREIGN KEY (documents_id) REFERENCES public.document(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4830 (class 2606 OID 278029946)
-- Name: event_trail event_trail_school_id_1205c6b9_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail
    ADD CONSTRAINT event_trail_school_id_1205c6b9_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4831 (class 2606 OID 278029951)
-- Name: event_trail event_trail_student_id_a2424067_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_trail
    ADD CONSTRAINT event_trail_student_id_a2424067_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4640 (class 2606 OID 33264)
-- Name: grade_assessment grade_assessment_assessment_id_6beb2bec_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_assessment
    ADD CONSTRAINT grade_assessment_assessment_id_6beb2bec_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4641 (class 2606 OID 33391)
-- Name: grade_assessment grade_assessment_school_id_944f75c5_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_assessment
    ADD CONSTRAINT grade_assessment_school_id_944f75c5_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4642 (class 2606 OID 31837272)
-- Name: grade_assessment grade_assessment_streams_id_6ca61f38_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade_assessment
    ADD CONSTRAINT grade_assessment_streams_id_6ca61f38_fk_stream_id FOREIGN KEY (streams_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4639 (class 2606 OID 33397)
-- Name: grade grade_stream_id_26a85b82_fk_Stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT "grade_stream_id_26a85b82_fk_Stream_id" FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4820 (class 2606 OID 277987289)
-- Name: group group_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT "group_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."group"("groupId") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4821 (class 2606 OID 277987308)
-- Name: groupmembership groupmembership_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groupmembership
    ADD CONSTRAINT "groupmembership_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."group"("groupId") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4666 (class 2606 OID 21206360)
-- Name: lo_assessment lo_assessment_assessment_id_524ce752_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_assessment
    ADD CONSTRAINT lo_assessment_assessment_id_524ce752_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4667 (class 2606 OID 21206365)
-- Name: lo_assessment lo_assessment_lo_id_e71eb10d_fk_lo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_assessment
    ADD CONSTRAINT lo_assessment_lo_id_e71eb10d_fk_lo_id FOREIGN KEY (lo_id) REFERENCES public.lo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4755 (class 2606 OID 162821212)
-- Name: lo_bundle_los lo_bundle_los_lo_v2_id_077b941e_fk_lo_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle_los
    ADD CONSTRAINT lo_bundle_los_lo_v2_id_077b941e_fk_lo_v2_id FOREIGN KEY (lo_v2_id) REFERENCES public.lo_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4756 (class 2606 OID 162821217)
-- Name: lo_bundle_los lo_bundle_los_lobundle_id_939b6279_fk_lo_bundle_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_bundle_los
    ADD CONSTRAINT lo_bundle_los_lobundle_id_939b6279_fk_lo_bundle_id FOREIGN KEY (lobundle_id) REFERENCES public.lo_bundle(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4643 (class 2606 OID 33385)
-- Name: lo lo_subject_id_a35d6fc1_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo
    ADD CONSTRAINT lo_subject_id_a35d6fc1_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4655 (class 2606 OID 65561)
-- Name: lo_submission lo_submission_assessment_id_77d7b852_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_submission
    ADD CONSTRAINT lo_submission_assessment_id_77d7b852_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4656 (class 2606 OID 66432)
-- Name: lo_submission lo_submission_grade_id_4aad3970_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_submission
    ADD CONSTRAINT lo_submission_grade_id_4aad3970_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4657 (class 2606 OID 65567)
-- Name: lo_submission lo_submission_lo_id_ab3f2b69_fk_lo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_submission
    ADD CONSTRAINT lo_submission_lo_id_ab3f2b69_fk_lo_id FOREIGN KEY (lo_id) REFERENCES public.lo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4658 (class 2606 OID 65573)
-- Name: lo_submission lo_submission_school_id_6b790f30_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_submission
    ADD CONSTRAINT lo_submission_school_id_6b790f30_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4748 (class 2606 OID 162820603)
-- Name: lo_v2 lo_v2_subject_id_8728ccda_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lo_v2
    ADD CONSTRAINT lo_v2_subject_id_8728ccda_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4773 (class 2606 OID 162820875)
-- Name: mapping mapping_mapping_id_4e953268_fk_mapping_details_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping
    ADD CONSTRAINT mapping_mapping_id_4e953268_fk_mapping_details_id FOREIGN KEY (mapping_id) REFERENCES public.mapping_details(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4769 (class 2606 OID 162820851)
-- Name: mapping_submission mapping_submission_assessment_id_0c00a42a_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_submission
    ADD CONSTRAINT mapping_submission_assessment_id_0c00a42a_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4770 (class 2606 OID 162821407)
-- Name: mapping_submission mapping_submission_mapping_id_5073f161_fk_mapping_details_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_submission
    ADD CONSTRAINT mapping_submission_mapping_id_5073f161_fk_mapping_details_id FOREIGN KEY (mapping_id) REFERENCES public.mapping_details(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4771 (class 2606 OID 162820861)
-- Name: mapping_submission mapping_submission_school_id_b4b16ddf_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_submission
    ADD CONSTRAINT mapping_submission_school_id_b4b16ddf_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4772 (class 2606 OID 162820866)
-- Name: mapping_submission mapping_submission_subject_id_e82161e3_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mapping_submission
    ADD CONSTRAINT mapping_submission_subject_id_e82161e3_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4822 (class 2606 OID 277987327)
-- Name: monitortracking monitortracking_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monitortracking
    ADD CONSTRAINT "monitortracking_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."group"("groupId") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4668 (class 2606 OID 3378796)
-- Name: question_assessment question_assessment_assessment_id_f775e63a_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_assessment
    ADD CONSTRAINT question_assessment_assessment_id_f775e63a_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4669 (class 2606 OID 3378791)
-- Name: question_assessment question_assessment_question_id_e5f228be_fk_question_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_assessment
    ADD CONSTRAINT question_assessment_question_id_e5f228be_fk_question_id FOREIGN KEY (question_id) REFERENCES public.question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4753 (class 2606 OID 162821222)
-- Name: question_bundle_questions question_bundle_ques_question_v2_id_97715300_fk_question_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle_questions
    ADD CONSTRAINT question_bundle_ques_question_v2_id_97715300_fk_question_ FOREIGN KEY (question_v2_id) REFERENCES public.question_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4754 (class 2606 OID 162821227)
-- Name: question_bundle_questions question_bundle_ques_questionbundle_id_1bd94382_fk_question_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_bundle_questions
    ADD CONSTRAINT question_bundle_ques_questionbundle_id_1bd94382_fk_question_ FOREIGN KEY (questionbundle_id) REFERENCES public.question_bundle(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4654 (class 2606 OID 33360)
-- Name: question question_lo_id_fad5517d_fk_lo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_lo_id_fad5517d_fk_lo_id FOREIGN KEY (lo_id) REFERENCES public.lo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4650 (class 2606 OID 65579)
-- Name: question_submission question_submission_assessment_id_fbc07e0f_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_submission
    ADD CONSTRAINT question_submission_assessment_id_fbc07e0f_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4651 (class 2606 OID 66438)
-- Name: question_submission question_submission_grade_id_f716969f_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_submission
    ADD CONSTRAINT question_submission_grade_id_f716969f_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4652 (class 2606 OID 65585)
-- Name: question_submission question_submission_question_id_540e4dd4_fk_question_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_submission
    ADD CONSTRAINT question_submission_question_id_540e4dd4_fk_question_id FOREIGN KEY (question_id) REFERENCES public.question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4653 (class 2606 OID 65591)
-- Name: question_submission question_submission_school_id_d78b85ed_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_submission
    ADD CONSTRAINT question_submission_school_id_d78b85ed_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4749 (class 2606 OID 162820609)
-- Name: question_v2 question_v2_lo_id_13802219_fk_lo_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_v2
    ADD CONSTRAINT question_v2_lo_id_13802219_fk_lo_v2_id FOREIGN KEY (lo_id) REFERENCES public.lo_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4827 (class 2606 OID 277987444)
-- Name: sa_class_students sa_class_evaluation_students_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_class_students
    ADD CONSTRAINT sa_class_evaluation_students_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4828 (class 2606 OID 277987449)
-- Name: sa_class_students sa_class_evaluation_students_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_class_students
    ADD CONSTRAINT sa_class_evaluation_students_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4826 (class 2606 OID 277987426)
-- Name: sa_evaluations sa_evaluations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_evaluations
    ADD CONSTRAINT sa_evaluations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.sa_teams(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4824 (class 2606 OID 277987399)
-- Name: sa_school_evaluations sa_school_evaluations_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_school_evaluations
    ADD CONSTRAINT sa_school_evaluations_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4825 (class 2606 OID 277987404)
-- Name: sa_school_evaluations sa_school_evaluations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_school_evaluations
    ADD CONSTRAINT sa_school_evaluations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.sa_teams(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4823 (class 2606 OID 277987375)
-- Name: sa_team_evaluators sa_team_evaluators_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sa_team_evaluators
    ADD CONSTRAINT sa_team_evaluators_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.sa_teams(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4700 (class 2606 OID 37714332)
-- Name: school_cache school_cache_school_id_23741c3c_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_cache
    ADD CONSTRAINT school_cache_school_id_23741c3c_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4645 (class 2606 OID 33287)
-- Name: school_grade school_grade_grade_id_400c027b_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_grade
    ADD CONSTRAINT school_grade_grade_id_400c027b_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4646 (class 2606 OID 33282)
-- Name: school_grade school_grade_school_id_9bd71438_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school_grade
    ADD CONSTRAINT school_grade_school_id_9bd71438_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4644 (class 2606 OID 33276)
-- Name: school school_location_id_429307ea_fk_location_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_location_id_429307ea_fk_location_id FOREIGN KEY (location_id) REFERENCES public.location(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4812 (class 2606 OID 163754476)
-- Name: celery_duplicate_remove server_celeryduplica_assessment_id_c9f756f1_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.celery_duplicate_remove
    ADD CONSTRAINT server_celeryduplica_assessment_id_c9f756f1_fk_assessmen FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4813 (class 2606 OID 163754481)
-- Name: celery_duplicate_remove server_celeryduplicateremove_school_id_a6b700f3_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.celery_duplicate_remove
    ADD CONSTRAINT server_celeryduplicateremove_school_id_a6b700f3_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4670 (class 2606 OID 21198016)
-- Name: enrollment server_enrollment_school_id_0c7af6d1_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT server_enrollment_school_id_0c7af6d1_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4671 (class 2606 OID 21198021)
-- Name: enrollment server_enrollment_student_id_a1c25d7b_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollment
    ADD CONSTRAINT server_enrollment_student_id_a1c25d7b_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4714 (class 2606 OID 154025556)
-- Name: server_logroup_lo server_logroup_lo_lo_id_c501b552_fk_lo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup_lo
    ADD CONSTRAINT server_logroup_lo_lo_id_c501b552_fk_lo_id FOREIGN KEY (lo_id) REFERENCES public.lo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4715 (class 2606 OID 154025551)
-- Name: server_logroup_lo server_logroup_lo_logroup_id_117a092c_fk_server_logroup_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_logroup_lo
    ADD CONSTRAINT server_logroup_lo_logroup_id_117a092c_fk_server_logroup_id FOREIGN KEY (logroup_id) REFERENCES public.server_logroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4712 (class 2606 OID 154025542)
-- Name: server_questiongroup_question server_questiongroup_question_id_3e90dc7f_fk_question_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup_question
    ADD CONSTRAINT server_questiongroup_question_id_3e90dc7f_fk_question_ FOREIGN KEY (question_id) REFERENCES public.question(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4713 (class 2606 OID 154025537)
-- Name: server_questiongroup_question server_questiongroup_questiongroup_id_4e7f6396_fk_server_qu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_questiongroup_question
    ADD CONSTRAINT server_questiongroup_questiongroup_id_4e7f6396_fk_server_qu FOREIGN KEY (questiongroup_id) REFERENCES public.server_questiongroup(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4740 (class 2606 OID 154025776)
-- Name: teacher server_teacher_school_id_81199ae6_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT server_teacher_school_id_81199ae6_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4742 (class 2606 OID 154025782)
-- Name: teacher_subjects server_teacher_subje_teacher_id_bd301b11_fk_server_te; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT server_teacher_subje_teacher_id_bd301b11_fk_server_te FOREIGN KEY (teacher_id) REFERENCES public.teacher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4743 (class 2606 OID 154025787)
-- Name: teacher_subjects server_teacher_subjects_subject_id_9fb2c7a9_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT server_teacher_subjects_subject_id_9fb2c7a9_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4689 (class 2606 OID 21223195)
-- Name: silk_profile_queries silk_profile_queries_profile_id_a3d76db8_fk_silk_profile_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile_queries
    ADD CONSTRAINT silk_profile_queries_profile_id_a3d76db8_fk_silk_profile_id FOREIGN KEY (profile_id) REFERENCES public.silk_profile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4690 (class 2606 OID 21223200)
-- Name: silk_profile_queries silk_profile_queries_sqlquery_id_155df455_fk_silk_sqlquery_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile_queries
    ADD CONSTRAINT silk_profile_queries_sqlquery_id_155df455_fk_silk_sqlquery_id FOREIGN KEY (sqlquery_id) REFERENCES public.silk_sqlquery(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4686 (class 2606 OID 21223211)
-- Name: silk_profile silk_profile_request_id_7b81bd69_fk_silk_request_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_profile
    ADD CONSTRAINT silk_profile_request_id_7b81bd69_fk_silk_request_id FOREIGN KEY (request_id) REFERENCES public.silk_request(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4687 (class 2606 OID 21223181)
-- Name: silk_response silk_response_request_id_1e8e2776_fk_silk_request_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_response
    ADD CONSTRAINT silk_response_request_id_1e8e2776_fk_silk_request_id FOREIGN KEY (request_id) REFERENCES public.silk_request(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4688 (class 2606 OID 21223188)
-- Name: silk_sqlquery silk_sqlquery_request_id_6f8f0527_fk_silk_request_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.silk_sqlquery
    ADD CONSTRAINT silk_sqlquery_request_id_6f8f0527_fk_silk_request_id FOREIGN KEY (request_id) REFERENCES public.silk_request(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4649 (class 2606 OID 33323)
-- Name: sms sms_student_id_d1cd8632_fk_Student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sms
    ADD CONSTRAINT "sms_student_id_d1cd8632_fk_Student_id" FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4817 (class 2606 OID 180722166)
-- Name: ss_school_allocation_data ss_school_allocation_data_quarter_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_data
    ADD CONSTRAINT ss_school_allocation_data_quarter_fkey FOREIGN KEY (quarter) REFERENCES public.ss_school_allocation_quarter(quarter_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4818 (class 2606 OID 180722171)
-- Name: ss_school_allocation_data ss_school_allocation_data_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ss_school_allocation_data
    ADD CONSTRAINT ss_school_allocation_data_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4672 (class 2606 OID 21198115)
-- Name: stream_common_subject stream_common_subject_stream_id_fb6b2029_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_common_subject
    ADD CONSTRAINT stream_common_subject_stream_id_fb6b2029_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4673 (class 2606 OID 21198120)
-- Name: stream_common_subject stream_common_subject_subject_id_23a05ba7_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_common_subject
    ADD CONSTRAINT stream_common_subject_subject_id_23a05ba7_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4674 (class 2606 OID 21206325)
-- Name: stream_optional_subjects_1 stream_optional_subjects_1_stream_id_1352a099_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_1
    ADD CONSTRAINT stream_optional_subjects_1_stream_id_1352a099_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4675 (class 2606 OID 21206320)
-- Name: stream_optional_subjects_1 stream_optional_subjects_1_subject_id_d4248bf6_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_1
    ADD CONSTRAINT stream_optional_subjects_1_subject_id_d4248bf6_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4676 (class 2606 OID 21206335)
-- Name: stream_optional_subjects_2 stream_optional_subjects_2_stream_id_6adb5b26_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_2
    ADD CONSTRAINT stream_optional_subjects_2_stream_id_6adb5b26_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4677 (class 2606 OID 21206330)
-- Name: stream_optional_subjects_2 stream_optional_subjects_2_subject_id_0b734bff_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_2
    ADD CONSTRAINT stream_optional_subjects_2_subject_id_0b734bff_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4678 (class 2606 OID 21206345)
-- Name: stream_optional_subjects_3 stream_optional_subjects_3_stream_id_3a3ca88d_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_3
    ADD CONSTRAINT stream_optional_subjects_3_stream_id_3a3ca88d_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4679 (class 2606 OID 21206340)
-- Name: stream_optional_subjects_3 stream_optional_subjects_3_subject_id_3e44c320_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_3
    ADD CONSTRAINT stream_optional_subjects_3_subject_id_3e44c320_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4680 (class 2606 OID 21206355)
-- Name: stream_optional_subjects_4 stream_optional_subjects_4_stream_id_989cd299_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_4
    ADD CONSTRAINT stream_optional_subjects_4_stream_id_989cd299_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4681 (class 2606 OID 21206350)
-- Name: stream_optional_subjects_4 stream_optional_subjects_4_subject_id_ce1acd7d_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stream_optional_subjects_4
    ADD CONSTRAINT stream_optional_subjects_4_subject_id_ce1acd7d_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4816 (class 2606 OID 171199497)
-- Name: student_content_share student_content_share_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_content_share
    ADD CONSTRAINT student_content_share_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4834 (class 2606 OID 278029977)
-- Name: student_document student_document_documents_id_b433dd62_fk_document_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_document
    ADD CONSTRAINT student_document_documents_id_b433dd62_fk_document_id FOREIGN KEY (documents_id) REFERENCES public.document(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4835 (class 2606 OID 278029972)
-- Name: student_document student_document_student_id_3e104445_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_document
    ADD CONSTRAINT student_document_student_id_3e104445_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4682 (class 2606 OID 21198185)
-- Name: student_subject student_subject_student_id_fc398bf1_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject_student_id_fc398bf1_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4683 (class 2606 OID 21198190)
-- Name: student_subject student_subject_subject_id_771923a7_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject_subject_id_771923a7_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4661 (class 2606 OID 65549)
-- Name: student_submission student_submission_assessment_id_c664e230_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission
    ADD CONSTRAINT student_submission_assessment_id_c664e230_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4662 (class 2606 OID 33435)
-- Name: student_submission student_submission_form_id_d4a337f2_fk_grade_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission
    ADD CONSTRAINT student_submission_form_id_d4a337f2_fk_grade_assessment_id FOREIGN KEY (form_id) REFERENCES public.grade_assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4663 (class 2606 OID 33440)
-- Name: student_submission student_submission_sms_id_9a525bbc_fk_sms_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission
    ADD CONSTRAINT student_submission_sms_id_9a525bbc_fk_sms_id FOREIGN KEY (sms_id) REFERENCES public.sms(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4664 (class 2606 OID 65543)
-- Name: student_submission student_submission_student_id_904b832b_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission
    ADD CONSTRAINT student_submission_student_id_904b832b_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4665 (class 2606 OID 65555)
-- Name: student_submission student_submission_subject_id_966da6e3_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission
    ADD CONSTRAINT student_submission_subject_id_966da6e3_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4798 (class 2606 OID 162821698)
-- Name: student_submission_v2 student_submission_v2_assessment_id_bdac128e_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_assessment_id_bdac128e_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4799 (class 2606 OID 162821708)
-- Name: student_submission_v2 student_submission_v2_grade_id_30f0325e_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_grade_id_30f0325e_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4800 (class 2606 OID 162821718)
-- Name: student_submission_v2 student_submission_v2_school_id_9c916e5f_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_school_id_9c916e5f_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4801 (class 2606 OID 162821723)
-- Name: student_submission_v2 student_submission_v2_stream_id_7893d7e7_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_stream_id_7893d7e7_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4802 (class 2606 OID 162821728)
-- Name: student_submission_v2 student_submission_v2_student_id_f5a60c8a_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_student_id_f5a60c8a_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4803 (class 2606 OID 162821733)
-- Name: student_submission_v2 student_submission_v2_subject_id_4e435475_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v2_subject_id_4e435475_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4804 (class 2606 OID 162821813)
-- Name: student_submission_v2 student_submission_v_assessment_unit_id_cdfde6a5_fk_assessmen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v_assessment_unit_id_cdfde6a5_fk_assessmen FOREIGN KEY (assessment_unit_id) REFERENCES public.assessment_unit(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4806 (class 2606 OID 162821751)
-- Name: student_submission_v2_marks_submissions student_submission_v_componentsubmission__53d56d87_fk_component; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2_marks_submissions
    ADD CONSTRAINT student_submission_v_componentsubmission__53d56d87_fk_component FOREIGN KEY (componentsubmission_id) REFERENCES public.component_submission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4805 (class 2606 OID 162821819)
-- Name: student_submission_v2 student_submission_v_grade_submissions_id_6d14a9ca_fk_mapping_s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2
    ADD CONSTRAINT student_submission_v_grade_submissions_id_6d14a9ca_fk_mapping_s FOREIGN KEY (grade_submissions_id) REFERENCES public.mapping_submission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4807 (class 2606 OID 162821746)
-- Name: student_submission_v2_marks_submissions student_submission_v_studentsubmission_v2_c6619625_fk_student_s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_submission_v2_marks_submissions
    ADD CONSTRAINT student_submission_v_studentsubmission_v2_c6619625_fk_student_s FOREIGN KEY (studentsubmission_v2_id) REFERENCES public.student_submission_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4693 (class 2606 OID 32010100)
-- Name: subject_submission subject_submission_assessment_id_1b067946_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission
    ADD CONSTRAINT subject_submission_assessment_id_1b067946_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4694 (class 2606 OID 37043568)
-- Name: subject_submission subject_submission_grade_id_0f0162e0_fk_grade_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission
    ADD CONSTRAINT subject_submission_grade_id_0f0162e0_fk_grade_id FOREIGN KEY (grade_id) REFERENCES public.grade(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4698 (class 2606 OID 32010136)
-- Name: subject_submission_selected_lo subject_submission_s_subjectsubmission_id_f6bd3bb0_fk_subject_s; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission_selected_lo
    ADD CONSTRAINT subject_submission_s_subjectsubmission_id_f6bd3bb0_fk_subject_s FOREIGN KEY (subjectsubmission_id) REFERENCES public.subject_submission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4695 (class 2606 OID 32010106)
-- Name: subject_submission subject_submission_school_id_3893a9b3_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission
    ADD CONSTRAINT subject_submission_school_id_3893a9b3_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4699 (class 2606 OID 32010142)
-- Name: subject_submission_selected_lo subject_submission_selected_lo_lo_id_5954b7a1_fk_lo_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission_selected_lo
    ADD CONSTRAINT subject_submission_selected_lo_lo_id_5954b7a1_fk_lo_id FOREIGN KEY (lo_id) REFERENCES public.lo(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4696 (class 2606 OID 36772671)
-- Name: subject_submission subject_submission_stream_id_eaac1347_fk_stream_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission
    ADD CONSTRAINT subject_submission_stream_id_eaac1347_fk_stream_id FOREIGN KEY (stream_id) REFERENCES public.stream(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4697 (class 2606 OID 32010114)
-- Name: subject_submission subject_submission_subject_id_fd20acbd_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject_submission
    ADD CONSTRAINT subject_submission_subject_id_fd20acbd_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4647 (class 2606 OID 33297)
-- Name: submission_summary submission_summary_assessment_id_5985453c_fk_assessment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission_summary
    ADD CONSTRAINT submission_summary_assessment_id_5985453c_fk_assessment_id FOREIGN KEY (assessment_id) REFERENCES public.assessment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4741 (class 2606 OID 154025797)
-- Name: teacher teacher_parent_id_2a1680a7_fk_teacher_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_parent_id_2a1680a7_fk_teacher_id FOREIGN KEY (parent_id) REFERENCES public.teacher(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4744 (class 2606 OID 157789632)
-- Name: teacher_registration_compliance teacher_registration_compliance_udise_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_registration_compliance
    ADD CONSTRAINT teacher_registration_compliance_udise_fkey FOREIGN KEY (udise) REFERENCES public.school(udise) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 4829 (class 2606 OID 277987469)
-- Name: trackassessment trackassessment_groupId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trackassessment
    ADD CONSTRAINT "trackassessment_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES public."group"("groupId") ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 4751 (class 2606 OID 162821232)
-- Name: unit_bundle_units unit_bundle_units_unit_v2_id_6c4eed4f_fk_unit_v2_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle_units
    ADD CONSTRAINT unit_bundle_units_unit_v2_id_6c4eed4f_fk_unit_v2_id FOREIGN KEY (unit_v2_id) REFERENCES public.unit_v2(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4752 (class 2606 OID 162821237)
-- Name: unit_bundle_units unit_bundle_units_unitbundle_id_83bf271c_fk_unit_bundle_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_bundle_units
    ADD CONSTRAINT unit_bundle_units_unitbundle_id_83bf271c_fk_unit_bundle_id FOREIGN KEY (unitbundle_id) REFERENCES public.unit_bundle(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4750 (class 2606 OID 162820615)
-- Name: unit_v2 unit_v2_subject_id_fc0bd89d_fk_subject_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unit_v2
    ADD CONSTRAINT unit_v2_subject_id_fc0bd89d_fk_subject_id FOREIGN KEY (subject_id) REFERENCES public.subject(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4836 (class 2606 OID 278029995)
-- Name: vc vc_school_id_35b48dd4_fk_school_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vc
    ADD CONSTRAINT vc_school_id_35b48dd4_fk_school_id FOREIGN KEY (school_id) REFERENCES public.school(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4837 (class 2606 OID 278030000)
-- Name: vc vc_student_id_20cd21b0_fk_student_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vc
    ADD CONSTRAINT vc_student_id_20cd21b0_fk_student_id FOREIGN KEY (student_id) REFERENCES public.student(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 5101 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-02-18 12:40:34 IST

--
-- PostgreSQL database dump complete
--

