--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2025-08-14 22:23:44

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 33335)
-- Name: configuracao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuracao (
    id_configuracao integer NOT NULL,
    tema smallint,
    CONSTRAINT configuracao_tema_check CHECK ((tema = ANY (ARRAY[1, 2, 3])))
);


ALTER TABLE public.configuracao OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 33334)
-- Name: configuracao_id_configuracao_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.configuracao_id_configuracao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.configuracao_id_configuracao_seq OWNER TO postgres;

--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 219
-- Name: configuracao_id_configuracao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.configuracao_id_configuracao_seq OWNED BY public.configuracao.id_configuracao;


--
-- TOC entry 218 (class 1259 OID 33245)
-- Name: detalhes_tarefa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalhes_tarefa (
    id_detalhe integer NOT NULL,
    fk_tarefa integer NOT NULL,
    descricao text,
    data_conclusao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.detalhes_tarefa OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 33244)
-- Name: detalhes_tarefa_id_detalhe_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalhes_tarefa_id_detalhe_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalhes_tarefa_id_detalhe_seq OWNER TO postgres;

--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 217
-- Name: detalhes_tarefa_id_detalhe_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalhes_tarefa_id_detalhe_seq OWNED BY public.detalhes_tarefa.id_detalhe;


--
-- TOC entry 216 (class 1259 OID 16843)
-- Name: tarefas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarefas (
    id_tarefa integer NOT NULL,
    titulo character varying(100) NOT NULL,
    descricao text,
    status character varying(20) DEFAULT 'pendente'::character varying,
    prioridade character varying(10),
    responsavel character varying(100) DEFAULT 'Desconhecido'::character varying NOT NULL,
    data_criacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    data_conclusao timestamp without time zone,
    ativo boolean DEFAULT true NOT NULL,
    CONSTRAINT tarefas_prioridade_check CHECK (((prioridade)::text = ANY ((ARRAY['baixa'::character varying, 'media'::character varying, 'alta'::character varying])::text[])))
);


ALTER TABLE public.tarefas OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16842)
-- Name: tarefas_id_tarefas_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarefas_id_tarefas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarefas_id_tarefas_seq OWNER TO postgres;

--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 215
-- Name: tarefas_id_tarefas_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarefas_id_tarefas_seq OWNED BY public.tarefas.id_tarefa;


--
-- TOC entry 4753 (class 2604 OID 33338)
-- Name: configuracao id_configuracao; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracao ALTER COLUMN id_configuracao SET DEFAULT nextval('public.configuracao_id_configuracao_seq'::regclass);


--
-- TOC entry 4750 (class 2604 OID 33248)
-- Name: detalhes_tarefa id_detalhe; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalhes_tarefa ALTER COLUMN id_detalhe SET DEFAULT nextval('public.detalhes_tarefa_id_detalhe_seq'::regclass);


--
-- TOC entry 4745 (class 2604 OID 16846)
-- Name: tarefas id_tarefa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarefas ALTER COLUMN id_tarefa SET DEFAULT nextval('public.tarefas_id_tarefas_seq'::regclass);


--
-- TOC entry 4911 (class 0 OID 33335)
-- Dependencies: 220
-- Data for Name: configuracao; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuracao (id_configuracao, tema) FROM stdin;
1	3
\.


--
-- TOC entry 4909 (class 0 OID 33245)
-- Dependencies: 218
-- Data for Name: detalhes_tarefa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalhes_tarefa (id_detalhe, fk_tarefa, descricao, data_conclusao, ativo) FROM stdin;
238	116	zxfgsf	2025-08-14 14:02:46.92033	t
239	116	asfasdf	2025-08-14 14:02:48.055565	t
240	116	asfasdf	2025-08-14 14:02:49.076531	t
241	116	asdfasdf	2025-08-14 14:02:50.282915	t
242	116	asfasdf	2025-08-14 14:02:51.322137	t
243	116	asdfasdf	2025-08-14 14:02:52.396038	t
219	115	MUDAR O SUBTAREFAS PARA DETALHES DA TAREFA	2025-08-14 00:57:27.819127	t
220	115	COLOCAR TAREFAS ATIVAS E INATIVAS COMO GUIAS	2025-08-14 00:57:42.075199	t
221	115	ARRUMAR TEMA CLARO E ESCURO	2025-08-14 00:57:53.754057	t
222	115	SAVAR E FORMATAR AS DATAS	2025-08-14 00:58:14.673464	t
\.


--
-- TOC entry 4907 (class 0 OID 16843)
-- Dependencies: 216
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarefas (id_tarefa, titulo, descricao, status, prioridade, responsavel, data_criacao, data_conclusao, ativo) FROM stdin;
118	TAREFA	TAREFA	\N	alta	FLAVIOQ	2025-08-14 16:10:01.132976	2025-08-14 00:00:00	f
116	NOVA	ADFASDFAS	\N	baixa	OOO	2025-08-13 23:40:26.223288	2025-08-28 00:00:00	f
117	NOVA TAREFA	NOVA TARFA PRO FULANO	pendente	media	FULANO	2025-08-14 14:42:29.39248	2025-08-15 00:00:00	t
115	ATIVIDADE DE CASA	TAREFA COM AULA PRESENCIAL COM ANDRÉ	\N	alta	FLAVIO	2025-08-13 23:40:08.392091	2025-08-14 00:00:00	t
\.


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 219
-- Name: configuracao_id_configuracao_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuracao_id_configuracao_seq', 2, true);


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 217
-- Name: detalhes_tarefa_id_detalhe_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalhes_tarefa_id_detalhe_seq', 246, true);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 215
-- Name: tarefas_id_tarefas_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarefas_id_tarefas_seq', 118, true);


--
-- TOC entry 4761 (class 2606 OID 33341)
-- Name: configuracao configuracao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracao
    ADD CONSTRAINT configuracao_pkey PRIMARY KEY (id_configuracao);


--
-- TOC entry 4759 (class 2606 OID 33252)
-- Name: detalhes_tarefa detalhes_tarefa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalhes_tarefa
    ADD CONSTRAINT detalhes_tarefa_pkey PRIMARY KEY (id_detalhe);


--
-- TOC entry 4757 (class 2606 OID 16854)
-- Name: tarefas tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id_tarefa);


--
-- TOC entry 4762 (class 2606 OID 33253)
-- Name: detalhes_tarefa detalhes_tarefa_fk_tarefa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalhes_tarefa
    ADD CONSTRAINT detalhes_tarefa_fk_tarefa_fkey FOREIGN KEY (fk_tarefa) REFERENCES public.tarefas(id_tarefa) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2025-08-14 22:23:44

--
-- PostgreSQL database dump complete
--

