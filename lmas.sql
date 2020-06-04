--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10
-- Dumped by pg_dump version 10.10

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: auth_role; Type: TABLE; Schema: public; Owner: User
--

CREATE TABLE public.auth_role (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    name character varying(50) NOT NULL,
    label character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public.auth_role OWNER TO "User";

--
-- Name: auth_role_id_seq; Type: SEQUENCE; Schema: public; Owner: User
--

CREATE SEQUENCE public.auth_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_role_id_seq OWNER TO "User";

--
-- Name: auth_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: User
--

ALTER SEQUENCE public.auth_role_id_seq OWNED BY public.auth_role.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: User
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    username character varying(128),
    email character varying(128) NOT NULL,
    password character varying(255),
    email_confirmed_at timestamp without time zone,
    active boolean
);


ALTER TABLE public.auth_user OWNER TO "User";

--
-- Name: auth_user_detail; Type: TABLE; Schema: public; Owner: User
--

CREATE TABLE public.auth_user_detail (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    user_id integer,
    last_name character varying(128) NOT NULL,
    first_name character varying(128),
    middle_name character varying(128),
    suffix character varying(20)
);


ALTER TABLE public.auth_user_detail OWNER TO "User";

--
-- Name: auth_user_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: User
--

CREATE SEQUENCE public.auth_user_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_detail_id_seq OWNER TO "User";

--
-- Name: auth_user_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: User
--

ALTER SEQUENCE public.auth_user_detail_id_seq OWNED BY public.auth_user_detail.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: User
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO "User";

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: User
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_roles; Type: TABLE; Schema: public; Owner: User
--

CREATE TABLE public.auth_user_roles (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    user_id integer,
    role_id integer
);


ALTER TABLE public.auth_user_roles OWNER TO "User";

--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: User
--

CREATE SEQUENCE public.auth_user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_roles_id_seq OWNER TO "User";

--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: User
--

ALTER SEQUENCE public.auth_user_roles_id_seq OWNED BY public.auth_user_roles.id;


--
-- Name: bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    short_name character varying(20) NOT NULL,
    name character varying(128) NOT NULL,
    active boolean
);


ALTER TABLE public.bank OWNER TO postgres;

--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bank_id_seq OWNER TO postgres;

--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bank_id_seq OWNED BY public.bank.id;


--
-- Name: loan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    service_id integer,
    user_id integer,
    amount numeric(15,2) NOT NULL,
    terms integer NOT NULL,
    previous_balance numeric(15,2),
    processing_fee numeric(15,2),
    net_proceeds numeric(15,2) NOT NULL,
    first_due_date date NOT NULL,
    last_due_date date,
    interest_rate numeric(15,2),
    memberbank_id integer,
    date_filed timestamp without time zone
);


ALTER TABLE public.loan OWNER TO postgres;

--
-- Name: loan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loan_id_seq OWNER TO postgres;

--
-- Name: loan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loan_id_seq OWNED BY public.loan.id;


--
-- Name: member_bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member_bank (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    bank_id integer,
    user_id integer,
    account_number character varying(128) NOT NULL,
    account_name character varying(128) NOT NULL
);


ALTER TABLE public.member_bank OWNER TO postgres;

--
-- Name: member_bank_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.member_bank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_bank_id_seq OWNER TO postgres;

--
-- Name: member_bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.member_bank_id_seq OWNED BY public.member_bank.id;


--
-- Name: service; Type: TABLE; Schema: public; Owner: User
--

CREATE TABLE public.service (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    name character varying(128) NOT NULL,
    description character varying(128),
    interest_rate numeric(15,2) NOT NULL,
    min_term integer NOT NULL,
    max_term integer NOT NULL,
    active boolean
);


ALTER TABLE public.service OWNER TO "User";

--
-- Name: service_id_seq; Type: SEQUENCE; Schema: public; Owner: User
--

CREATE SEQUENCE public.service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_id_seq OWNER TO "User";

--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: User
--

ALTER SEQUENCE public.service_id_seq OWNED BY public.service.id;


--
-- Name: auth_role id; Type: DEFAULT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_role ALTER COLUMN id SET DEFAULT nextval('public.auth_role_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_detail id; Type: DEFAULT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_detail ALTER COLUMN id SET DEFAULT nextval('public.auth_user_detail_id_seq'::regclass);


--
-- Name: auth_user_roles id; Type: DEFAULT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_roles ALTER COLUMN id SET DEFAULT nextval('public.auth_user_roles_id_seq'::regclass);


--
-- Name: bank id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank ALTER COLUMN id SET DEFAULT nextval('public.bank_id_seq'::regclass);


--
-- Name: loan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan ALTER COLUMN id SET DEFAULT nextval('public.loan_id_seq'::regclass);


--
-- Name: member_bank id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_bank ALTER COLUMN id SET DEFAULT nextval('public.member_bank_id_seq'::regclass);


--
-- Name: service id; Type: DEFAULT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.service ALTER COLUMN id SET DEFAULT nextval('public.service_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
c87937e64e86
\.


--
-- Data for Name: auth_role; Type: TABLE DATA; Schema: public; Owner: User
--

COPY public.auth_role (id, date_created, date_modified, name, label) FROM stdin;
1	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	admin	Admin
2	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	member	Member
3	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	checker	Checker
4	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	endorser	Endorser
5	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	committee	Committee
6	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	ceo	CEO
7	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	manager	Manager
8	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	processor	Processor
9	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	payroll	Payroll
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: User
--

COPY public.auth_user (id, date_created, date_modified, username, email, password, email_confirmed_at, active) FROM stdin;
1	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	admin	admin@example.com	$2b$12$U3ErCXGrWcEoyA61adslleTNoQGe6pHOveq8opJ2SOe8Gxp.iRwBG	2020-04-25 05:22:51.472815	t
2	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	member	member@example.com	$2b$12$YGX9Sl3KA/MsePaU6rS5n.TOftyGNgE2WQQOC/Fa.eU0.FMiRKz9a	2020-04-25 05:22:51.732287	t
4	2020-04-25 14:00:33	2020-05-04 15:15:28.829822	\N	jeffplata@yahoo.com	$2b$12$Jz74PgGZA8Jh4e6CfJTOHOaRI6lpZjsxO7OBSdRFkJp0POslJrs5C	2020-04-25 05:22:51	t
5	2020-04-26 10:50:50	2020-05-04 15:16:09.676687	\N	ian@yahoo.com	$2b$12$VNCoAxtVDEoWYxaYD55pVOROkNz9ZWBv.C1.rkQbOjYmcXIo7iCj2	2020-05-04 15:16:00	t
8	2020-05-04 17:44:35.714052	2020-05-04 17:44:35.714052	test2	test2@email.com	$2b$12$W1rsZxJKkh4UV4gjgvgJtunRmL6vZKwmQHrwRTw80qjh8.DhBLbqu	2020-05-04 17:44:35.714052	t
9	2020-05-04 17:49:24	2020-05-04 17:49:24	test3	test3@yahoo.com	$2b$12$E6qGt2Ci21JISnLULwgJ5OXhW0QXbt9zzsr.UQ6NXnK7dNso46jW.	2020-05-04 17:49:24	t
7	2020-05-04 17:42:40	2020-05-04 17:42:40	test	test@gmail.com	$2b$12$Mvt7YNO51L3qmF/i6Ieo4u3bjxiSxsE/sQSN7Z1JTjYUGiKs1uhbm	2020-05-04 17:42:40	t
10	2020-05-04 21:15:52.2467	2020-05-04 21:15:52.2467	\N	test4@gmail.com	$2b$12$s/zHvniDVAmlWIjHDW8EiuIAfvbQdn8LqM0iyJS/Pzd./os9cg6Wu	2020-05-04 21:15:52.2467	f
\.


--
-- Data for Name: auth_user_detail; Type: TABLE DATA; Schema: public; Owner: User
--

COPY public.auth_user_detail (id, date_created, date_modified, user_id, last_name, first_name, middle_name, suffix) FROM stdin;
1	\N	\N	4	Plata	Jeff	M	the Great
2	2020-05-04 01:01:16	2020-05-04 15:51:03.867823	5	Agana	Ian	O	Jr
3	2020-05-31 19:50:14.637292	2020-05-31 19:50:14.637292	7	Test Lastname	Test Firstname	Test Middle	\N
\.


--
-- Data for Name: auth_user_roles; Type: TABLE DATA; Schema: public; Owner: User
--

COPY public.auth_user_roles (id, date_created, date_modified, user_id, role_id) FROM stdin;
1	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	1	1
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank (id, date_created, date_modified, short_name, name, active) FROM stdin;
1	2020-05-25 16:22:41.871304	2020-05-25 16:25:15.039129	PNB	Philippine National Bank	t
2	2020-05-25 16:23:36.78958	2020-05-25 17:24:33.729407	LBP	Land Bank of the Philippines	t
\.


--
-- Data for Name: loan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan (id, date_created, date_modified, service_id, user_id, amount, terms, previous_balance, processing_fee, net_proceeds, first_due_date, last_due_date, interest_rate, memberbank_id, date_filed) FROM stdin;
1	2020-05-31 10:33:19.971434	2020-05-31 10:33:19.971434	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	8	\N
2	2020-05-31 12:02:12.646651	2020-05-31 12:02:12.646651	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	9	\N
3	2020-05-31 12:23:14.629017	2020-05-31 12:23:14.629017	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	10	\N
4	2020-05-31 12:41:09.265635	2020-05-31 12:41:09.265635	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	\N	\N
5	2020-05-31 13:44:05.03908	2020-05-31 13:44:05.03908	1	5	12000.00	24	5500.00	250.00	6250.00	2020-06-30	2022-05-30	1.00	13	\N
6	2020-05-31 14:28:21.090377	2020-05-31 14:28:21.090377	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	8	\N
7	2020-05-31 19:35:39.686816	2020-05-31 19:35:39.686816	2	5	51000.00	12	5500.00	250.00	45250.00	2020-06-30	2021-05-30	1.50	13	\N
8	2020-05-31 19:37:37.749687	2020-05-31 19:37:37.749687	2	5	51000.00	12	5500.00	250.00	45250.00	2020-06-30	2021-05-30	1.50	14	\N
9	2020-05-31 19:43:50.012939	2020-05-31 19:43:50.012939	1	5	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	13	\N
10	2020-05-31 22:35:10.915618	2020-05-31 22:35:10.915618	1	5	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	13	\N
11	2020-05-31 22:37:49.714409	2020-05-31 22:37:49.714409	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	15	\N
12	2020-06-02 22:39:18.720206	2020-06-02 22:39:18.720206	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	22	\N
13	2020-06-02 23:04:56.277377	2020-06-02 23:04:56.277377	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	8	\N
14	2020-06-02 23:05:15.970137	2020-06-02 23:05:15.970137	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	23	\N
15	2020-06-02 23:05:45.54732	2020-06-02 23:05:45.54732	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	8	\N
16	2020-06-03 00:30:52.710507	2020-06-03 00:30:52.710507	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-03	2023-06-03	1.00	24	\N
17	2020-06-03 18:06:04.271478	2020-06-03 18:06:04.271478	1	4	12000.00	24	5500.00	250.00	6250.00	2020-07-03	2022-06-03	1.00	8	\N
\.


--
-- Data for Name: member_bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member_bank (id, date_created, date_modified, bank_id, user_id, account_number, account_name) FROM stdin;
8	2020-05-31 10:33:19.971434	2020-05-31 10:33:19.971434	1	4	12345678	Jeff M Plata the Great
9	2020-05-31 12:02:12.646651	2020-05-31 12:02:12.646651	1	4	1080100	Jeff M Plata the Great
13	2020-05-31 13:44:05.03908	2020-05-31 13:44:05.03908	1	5	1080190	Ian O Agana Jr
14	2020-05-31 19:37:37.749687	2020-05-31 19:37:37.749687	2	5	1080190	Ian O Agana Jr
15	2020-05-31 22:37:49.714409	2020-05-31 22:37:49.714409	2	4	12345678	Jeff M Plata the Great
24	2020-06-03 00:30:52.710507	2020-06-03 00:30:52.710507	2	4	1234567890	Jeff M Plata
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: User
--

COPY public.service (id, date_created, date_modified, name, description, interest_rate, min_term, max_term, active) FROM stdin;
2	2020-05-03 20:22:27	2020-05-06 06:20:33	Special Loan	80% of Basic Pay\r\nOne time payment\r\nDue on May 30, 2020	1.50	12	12	t
1	2020-05-03 20:21:44	2020-05-04 14:20:21	Regular Loan	80% of TAV\r\n12-, 24-, 36-month terms\r\nRenewable after 25% payment	1.00	12	36	t
\.


--
-- Name: auth_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: User
--

SELECT pg_catalog.setval('public.auth_role_id_seq', 9, true);


--
-- Name: auth_user_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: User
--

SELECT pg_catalog.setval('public.auth_user_detail_id_seq', 3, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: User
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 10, true);


--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: User
--

SELECT pg_catalog.setval('public.auth_user_roles_id_seq', 1, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bank_id_seq', 2, true);


--
-- Name: loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_id_seq', 17, true);


--
-- Name: member_bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.member_bank_id_seq', 24, true);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: User
--

SELECT pg_catalog.setval('public.service_id_seq', 2, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: auth_role auth_role_name_key; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_name_key UNIQUE (name);


--
-- Name: auth_role auth_role_pkey; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_pkey PRIMARY KEY (id);


--
-- Name: auth_user_detail auth_user_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_detail
    ADD CONSTRAINT auth_user_detail_pkey PRIMARY KEY (id);


--
-- Name: auth_user auth_user_email_key; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_email_key UNIQUE (email);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_roles auth_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT auth_user_roles_pkey PRIMARY KEY (id);


--
-- Name: bank bank_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT bank_name_key UNIQUE (name);


--
-- Name: bank bank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT bank_pkey PRIMARY KEY (id);


--
-- Name: bank bank_short_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank
    ADD CONSTRAINT bank_short_name_key UNIQUE (short_name);


--
-- Name: loan loan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_pkey PRIMARY KEY (id);


--
-- Name: member_bank member_bank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_bank
    ADD CONSTRAINT member_bank_pkey PRIMARY KEY (id);


--
-- Name: service service_name_key; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_name_key UNIQUE (name);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: auth_user_detail auth_user_detail_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_detail
    ADD CONSTRAINT auth_user_detail_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- Name: auth_user_roles auth_user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT auth_user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id) ON DELETE CASCADE;


--
-- Name: auth_user_roles auth_user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: User
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT auth_user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- Name: loan loan_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_service_id_fkey FOREIGN KEY (service_id) REFERENCES public.service(id) ON DELETE CASCADE;


--
-- Name: loan loan_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- Name: member_bank member_bank_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_bank
    ADD CONSTRAINT member_bank_bank_id_fkey FOREIGN KEY (bank_id) REFERENCES public.bank(id) ON DELETE CASCADE;


--
-- Name: member_bank member_bank_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_bank
    ADD CONSTRAINT member_bank_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

