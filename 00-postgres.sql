--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Name: prompts; Type: TABLE; Schema: public; Owner: postgresql
--

CREATE TABLE public.prompts (
    schema_id uuid NOT NULL,
    prompt text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.prompts OWNER TO postgresql;

--
-- Name: schema_holder; Type: TABLE; Schema: public; Owner: postgresql
--

CREATE TABLE public.schema_holder (
    schema_id uuid NOT NULL,
    schema text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    schema_type text NOT NULL
);


ALTER TABLE public.schema_holder OWNER TO postgresql;

--
-- Name: hdb_action_log hdb_action_log_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_action_log
    ADD CONSTRAINT hdb_action_log_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_cron_events hdb_cron_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_events
    ADD CONSTRAINT hdb_cron_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_pkey PRIMARY KEY (id);


--
-- Name: hdb_metadata hdb_metadata_resource_version_key; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_metadata
    ADD CONSTRAINT hdb_metadata_resource_version_key UNIQUE (resource_version);


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_pkey PRIMARY KEY (id);


--
-- Name: hdb_scheduled_events hdb_scheduled_events_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_events
    ADD CONSTRAINT hdb_scheduled_events_pkey PRIMARY KEY (id);


--
-- Name: hdb_schema_notifications hdb_schema_notifications_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_schema_notifications
    ADD CONSTRAINT hdb_schema_notifications_pkey PRIMARY KEY (id);


--
-- Name: hdb_version hdb_version_pkey; Type: CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_version
    ADD CONSTRAINT hdb_version_pkey PRIMARY KEY (hasura_uuid);


--
-- Name: prompts prompts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresql
--

ALTER TABLE ONLY public.prompts
    ADD CONSTRAINT prompts_pkey PRIMARY KEY (schema_id, prompt, created_at);


--
-- Name: schema_holder schema_holder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgresql
--

ALTER TABLE ONLY public.schema_holder
    ADD CONSTRAINT schema_holder_pkey PRIMARY KEY (schema_id);


--
-- Name: hdb_cron_event_invocation_event_id; Type: INDEX; Schema: hdb_catalog; Owner: postgresql
--

CREATE INDEX hdb_cron_event_invocation_event_id ON hdb_catalog.hdb_cron_event_invocation_logs USING btree (event_id);


--
-- Name: hdb_cron_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgresql
--

CREATE INDEX hdb_cron_event_status ON hdb_catalog.hdb_cron_events USING btree (status);


--
-- Name: hdb_cron_events_unique_scheduled; Type: INDEX; Schema: hdb_catalog; Owner: postgresql
--

CREATE UNIQUE INDEX hdb_cron_events_unique_scheduled ON hdb_catalog.hdb_cron_events USING btree (trigger_name, scheduled_time) WHERE (status = 'scheduled'::text);


--
-- Name: hdb_scheduled_event_status; Type: INDEX; Schema: hdb_catalog; Owner: postgresql
--

CREATE INDEX hdb_scheduled_event_status ON hdb_catalog.hdb_scheduled_events USING btree (status);


--
-- Name: hdb_version_one_row; Type: INDEX; Schema: hdb_catalog; Owner: postgresql
--

CREATE UNIQUE INDEX hdb_version_one_row ON hdb_catalog.hdb_version USING btree (((version IS NOT NULL)));


--
-- Name: prompts set_public_prompts_updated_at; Type: TRIGGER; Schema: public; Owner: postgresql
--

CREATE TRIGGER set_public_prompts_updated_at BEFORE UPDATE ON public.prompts FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_prompts_updated_at ON prompts; Type: COMMENT; Schema: public; Owner: postgresql
--

COMMENT ON TRIGGER set_public_prompts_updated_at ON public.prompts IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: schema_holder set_public_schema_holder_updated_at; Type: TRIGGER; Schema: public; Owner: postgresql
--

CREATE TRIGGER set_public_schema_holder_updated_at BEFORE UPDATE ON public.schema_holder FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();


--
-- Name: TRIGGER set_public_schema_holder_updated_at ON schema_holder; Type: COMMENT; Schema: public; Owner: postgresql
--

COMMENT ON TRIGGER set_public_schema_holder_updated_at ON public.schema_holder IS 'trigger to set value of column "updated_at" to current timestamp on row update';


--
-- Name: hdb_cron_event_invocation_logs hdb_cron_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_cron_event_invocation_logs
    ADD CONSTRAINT hdb_cron_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_cron_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hdb_scheduled_event_invocation_logs hdb_scheduled_event_invocation_logs_event_id_fkey; Type: FK CONSTRAINT; Schema: hdb_catalog; Owner: postgresql
--

ALTER TABLE ONLY hdb_catalog.hdb_scheduled_event_invocation_logs
    ADD CONSTRAINT hdb_scheduled_event_invocation_logs_event_id_fkey FOREIGN KEY (event_id) REFERENCES hdb_catalog.hdb_scheduled_events(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

