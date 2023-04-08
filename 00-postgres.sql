--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

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
-- Name: schema_holder; Type: TABLE; Schema: public; Owner: postgresql
--

CREATE TABLE public.schema_holder (
    schema_id uuid NOT NULL UNIQUE,
    schema text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    schema_type text NOT NULL,
    schema_name text
);


ALTER TABLE public.schema_holder OWNER TO postgresql;

--
-- Name: prompts; Type: TABLE; Schema: public; Owner: postgresql
--

CREATE TABLE public.prompts (
    schema_id uuid NOT NULL REFERENCES public.schema_holder(schema_id),
    prompt text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.prompts OWNER TO postgresql;