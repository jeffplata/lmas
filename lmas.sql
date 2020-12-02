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
-- Name: auth_role; Type: TABLE; Schema: public; Owner: jeff
--

CREATE TABLE public.auth_role (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    name character varying(50) NOT NULL,
    label character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public.auth_role OWNER TO jeff;

--
-- Name: auth_role_id_seq; Type: SEQUENCE; Schema: public; Owner: jeff
--

CREATE SEQUENCE public.auth_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_role_id_seq OWNER TO jeff;

--
-- Name: auth_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jeff
--

ALTER SEQUENCE public.auth_role_id_seq OWNED BY public.auth_role.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: jeff
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


ALTER TABLE public.auth_user OWNER TO jeff;

--
-- Name: auth_user_detail; Type: TABLE; Schema: public; Owner: jeff
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


ALTER TABLE public.auth_user_detail OWNER TO jeff;

--
-- Name: auth_user_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: jeff
--

CREATE SEQUENCE public.auth_user_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_detail_id_seq OWNER TO jeff;

--
-- Name: auth_user_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jeff
--

ALTER SEQUENCE public.auth_user_detail_id_seq OWNED BY public.auth_user_detail.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: jeff
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO jeff;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jeff
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_roles; Type: TABLE; Schema: public; Owner: jeff
--

CREATE TABLE public.auth_user_roles (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    user_id integer,
    role_id integer
);


ALTER TABLE public.auth_user_roles OWNER TO jeff;

--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: jeff
--

CREATE SEQUENCE public.auth_user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_roles_id_seq OWNER TO jeff;

--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jeff
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
    date_filed timestamp without time zone,
    status character varying(20)
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
-- Name: loan_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan_payment (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    batch_id integer,
    loan_id integer NOT NULL,
    amount_paid numeric(15,2)
);


ALTER TABLE public.loan_payment OWNER TO postgres;

--
-- Name: loan_payment_batch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan_payment_batch (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    trans_date date,
    description character varying(128)
);


ALTER TABLE public.loan_payment_batch OWNER TO postgres;

--
-- Name: loan_payment_batch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loan_payment_batch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loan_payment_batch_id_seq OWNER TO postgres;

--
-- Name: loan_payment_batch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loan_payment_batch_id_seq OWNED BY public.loan_payment_batch.id;


--
-- Name: loan_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loan_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loan_payment_id_seq OWNER TO postgres;

--
-- Name: loan_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loan_payment_id_seq OWNED BY public.loan_payment.id;


--
-- Name: loan_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loan_status (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    status character varying(20),
    role_required character varying(50)
);


ALTER TABLE public.loan_status OWNER TO postgres;

--
-- Name: loan_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.loan_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.loan_status_id_seq OWNER TO postgres;

--
-- Name: loan_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.loan_status_id_seq OWNED BY public.loan_status.id;


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
-- Name: member_salary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member_salary (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    effective_date date,
    sg integer,
    step integer,
    user_detail_id integer,
    salary numeric(15,2)
);


ALTER TABLE public.member_salary OWNER TO postgres;

--
-- Name: member_salary_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.member_salary_history (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    user_detail_id integer,
    effective_date date,
    sg integer,
    step integer,
    salary numeric(15,2)
);


ALTER TABLE public.member_salary_history OWNER TO postgres;

--
-- Name: member_salary_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.member_salary_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_salary_history_id_seq OWNER TO postgres;

--
-- Name: member_salary_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.member_salary_history_id_seq OWNED BY public.member_salary_history.id;


--
-- Name: member_salary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.member_salary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.member_salary_id_seq OWNER TO postgres;

--
-- Name: member_salary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.member_salary_id_seq OWNED BY public.member_salary.id;


--
-- Name: salary_grade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salary_grade (
    id integer NOT NULL,
    date_created timestamp without time zone,
    date_modified timestamp without time zone,
    sg integer NOT NULL,
    step integer NOT NULL,
    salary numeric(15,2),
    group_name character varying(128),
    active boolean
);


ALTER TABLE public.salary_grade OWNER TO postgres;

--
-- Name: salary_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.salary_grade_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.salary_grade_id_seq OWNER TO postgres;

--
-- Name: salary_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.salary_grade_id_seq OWNED BY public.salary_grade.id;


--
-- Name: service; Type: TABLE; Schema: public; Owner: jeff
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


ALTER TABLE public.service OWNER TO jeff;

--
-- Name: service_id_seq; Type: SEQUENCE; Schema: public; Owner: jeff
--

CREATE SEQUENCE public.service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_id_seq OWNER TO jeff;

--
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jeff
--

ALTER SEQUENCE public.service_id_seq OWNED BY public.service.id;


--
-- Name: auth_role id; Type: DEFAULT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_role ALTER COLUMN id SET DEFAULT nextval('public.auth_role_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_detail id; Type: DEFAULT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_detail ALTER COLUMN id SET DEFAULT nextval('public.auth_user_detail_id_seq'::regclass);


--
-- Name: auth_user_roles id; Type: DEFAULT; Schema: public; Owner: jeff
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
-- Name: loan_payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_payment ALTER COLUMN id SET DEFAULT nextval('public.loan_payment_id_seq'::regclass);


--
-- Name: loan_payment_batch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_payment_batch ALTER COLUMN id SET DEFAULT nextval('public.loan_payment_batch_id_seq'::regclass);


--
-- Name: loan_status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_status ALTER COLUMN id SET DEFAULT nextval('public.loan_status_id_seq'::regclass);


--
-- Name: member_bank id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_bank ALTER COLUMN id SET DEFAULT nextval('public.member_bank_id_seq'::regclass);


--
-- Name: member_salary id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary ALTER COLUMN id SET DEFAULT nextval('public.member_salary_id_seq'::regclass);


--
-- Name: member_salary_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary_history ALTER COLUMN id SET DEFAULT nextval('public.member_salary_history_id_seq'::regclass);


--
-- Name: salary_grade id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_grade ALTER COLUMN id SET DEFAULT nextval('public.salary_grade_id_seq'::regclass);


--
-- Name: service id; Type: DEFAULT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.service ALTER COLUMN id SET DEFAULT nextval('public.service_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
693414269f42
\.


--
-- Data for Name: auth_role; Type: TABLE DATA; Schema: public; Owner: jeff
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
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: jeff
--

COPY public.auth_user (id, date_created, date_modified, username, email, password, email_confirmed_at, active) FROM stdin;
1	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	admin	admin@example.com	$2b$12$U3ErCXGrWcEoyA61adslleTNoQGe6pHOveq8opJ2SOe8Gxp.iRwBG	2020-04-25 05:22:51.472815	t
2	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	member	member@example.com	$2b$12$YGX9Sl3KA/MsePaU6rS5n.TOftyGNgE2WQQOC/Fa.eU0.FMiRKz9a	2020-04-25 05:22:51.732287	t
4	2020-04-25 14:00:33	2020-05-04 15:15:28.829822	\N	jeffplata@yahoo.com	$2b$12$Jz74PgGZA8Jh4e6CfJTOHOaRI6lpZjsxO7OBSdRFkJp0POslJrs5C	2020-04-25 05:22:51	t
5	2020-04-26 10:50:50	2020-05-04 15:16:09.676687	\N	ian@yahoo.com	$2b$12$VNCoAxtVDEoWYxaYD55pVOROkNz9ZWBv.C1.rkQbOjYmcXIo7iCj2	2020-05-04 15:16:00	t
8	2020-05-04 17:44:35.714052	2020-05-04 17:44:35.714052	test2	test2@email.com	$2b$12$W1rsZxJKkh4UV4gjgvgJtunRmL6vZKwmQHrwRTw80qjh8.DhBLbqu	2020-05-04 17:44:35.714052	t
9	2020-05-04 17:49:24	2020-05-04 17:49:24	test3	test3@yahoo.com	$2b$12$E6qGt2Ci21JISnLULwgJ5OXhW0QXbt9zzsr.UQ6NXnK7dNso46jW.	2020-05-04 17:49:24	t
10	2020-05-04 21:15:52.2467	2020-05-04 21:15:52.2467	\N	test4@gmail.com	$2b$12$s/zHvniDVAmlWIjHDW8EiuIAfvbQdn8LqM0iyJS/Pzd./os9cg6Wu	2020-05-04 21:15:52.2467	f
18	2020-06-09 07:35:00.748267	2020-06-09 07:35:00.748267	\N	sfsd@email.com	$2b$12$u1BdHfelGZywrkifDhqmgeGTmbfA8ytm565HoRzyaYeyMtqUnN7U.	2020-06-08 23:35:00.754902	t
46	2020-06-11 23:15:56.97009	2020-06-11 23:17:41.391481	\N	new@email.com	$2b$12$aIAD1wsrkGtTXrG89CXWs.zDeV7KHbjlKfiJGabFaxUnmhHvduJ8S	2020-06-11 15:15:57.322203	t
47	2020-06-11 23:37:21.885985	2020-06-11 23:37:53.181038	\N	roxani@gmail.com	$2b$12$uMCZ/yFu6jA68Y3DidRN8eGzdQZjejISEQp5dmtmg9o8UbJGS/8uy	2020-06-11 15:37:22.231064	t
48	2020-06-23 03:41:38.334094	2020-06-23 03:41:38.334094	\N	newuser@email.com	$2b$12$Io.cQ64latF9uz15F78qleuuli8c9RbFzscSj1yqF6Fot5raY3yOa	2020-06-22 19:41:38.701729	t
56	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	checker	checker@example.com	$2b$12$2bjDdah4bf4pSMb2vydqWeyBo1QZAdrWYtWwfjGSFZuQTIMOJ6Om.	2020-07-10 00:25:55.116912	t
57	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	endorser	endorser@example.com	$2b$12$4GNvfMTFYiwhO5c2GzNLMuQrWHsDTgAwhfB29PTidlcw82u3tdzqO	2020-07-10 00:25:55.430136	t
58	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	committee	committee@example.com	$2b$12$BR2fZAsYA720jDA7I5QJkuPtz.BUoSYrgpdecTwNSZvQmPLMs.3JW	2020-07-10 00:25:55.741371	t
59	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	ceo	ceo@example.com	$2b$12$0z.eL00aUGmcg7kHkfhCe.Mh4R3c.fA1IfgJEyZbf44LV0kwN.vR6	2020-07-10 00:25:56.053574	t
60	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	manager	manager@example.com	$2b$12$Vn7qaNh7GreIgBsoWuf.Je4AfGslaPmbfHnIbp2tOUi5WnT2BPruK	2020-07-10 00:25:56.362792	t
61	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	processor	processor@example.com	$2b$12$3vcWZXlPSn8/GGUfwao6qerhlbXnyjgq8m7JpnnDo/r/0S.7/JxYu	2020-07-10 00:25:56.67201	t
62	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	payroll	payroll@example.com	$2b$12$8lNrHy1mF3PF.R24an2DdeMne5YucRCNvEVjoacYVVc4p/PiyM6EK	2020-07-10 00:25:56.980233	t
\.


--
-- Data for Name: auth_user_detail; Type: TABLE DATA; Schema: public; Owner: jeff
--

COPY public.auth_user_detail (id, date_created, date_modified, user_id, last_name, first_name, middle_name, suffix) FROM stdin;
2	2020-05-04 01:01:16	2020-06-23 03:32:46.452967	5	Agana	Ian	O	Jr
1	\N	2020-06-23 03:33:09.358036	4	Plata	Jeff	M	the Great
13	2020-06-11 23:37:21.885985	2020-06-23 03:34:07.789265	47	Roxani	Super		Bebe
14	2020-06-23 03:41:38.334094	2020-06-23 03:41:38.334094	48	new last name	new first name	new middle	
6	2020-06-09 07:35:00.748267	2020-06-18 21:36:07.584048	46	Plata	Joeffrey		
3	2020-05-31 19:50:14.637292	2020-06-18 21:36:26.068111	10	Test Lastname	Test Firstname	Test Middle	
\.


--
-- Data for Name: auth_user_roles; Type: TABLE DATA; Schema: public; Owner: jeff
--

COPY public.auth_user_roles (id, date_created, date_modified, user_id, role_id) FROM stdin;
1	2020-04-25 13:22:51.180363	2020-04-25 13:22:51.180363	1	1
9	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	56	3
10	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	57	4
11	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	58	5
12	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	59	6
13	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	60	7
14	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	61	8
15	2020-07-10 08:25:54.753623	2020-07-10 08:25:54.753623	62	9
\.


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank (id, date_created, date_modified, short_name, name, active) FROM stdin;
2	2020-05-25 16:23:36.78958	2020-05-25 17:24:33.729407	LBP	Land Bank of the Philippines	t
1	2020-05-25 16:22:41.871304	2020-06-07 14:32:22.495986	PNB	Philippine National Bank	t
\.


--
-- Data for Name: loan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan (id, date_created, date_modified, service_id, user_id, amount, terms, previous_balance, processing_fee, net_proceeds, first_due_date, last_due_date, interest_rate, memberbank_id, date_filed, status) FROM stdin;
1	2020-05-31 10:33:19.971434	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	8	2020-05-30 00:00:00	submitted
2	2020-05-31 12:02:12.646651	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	9	2020-05-30 00:00:00	submitted
3	2020-05-31 12:23:14.629017	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	10	2020-05-30 00:00:00	submitted
4	2020-05-31 12:41:09.265635	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	\N	2020-05-30 00:00:00	submitted
5	2020-05-31 13:44:05.03908	2020-06-05 05:52:59.302095	1	5	12000.00	24	5500.00	250.00	6250.00	2020-06-30	2022-05-30	1.00	13	2020-05-30 00:00:00	submitted
6	2020-05-31 14:28:21.090377	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	8	2020-05-30 00:00:00	submitted
7	2020-05-31 19:35:39.686816	2020-06-05 05:52:59.302095	2	5	51000.00	12	5500.00	250.00	45250.00	2020-06-30	2021-05-30	1.50	13	2020-05-30 00:00:00	submitted
8	2020-05-31 19:37:37.749687	2020-06-05 05:52:59.302095	2	5	51000.00	12	5500.00	250.00	45250.00	2020-06-30	2021-05-30	1.50	14	2020-05-30 00:00:00	submitted
9	2020-05-31 19:43:50.012939	2020-06-05 05:52:59.302095	1	5	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	13	2020-05-30 00:00:00	submitted
10	2020-05-31 22:35:10.915618	2020-06-05 05:52:59.302095	1	5	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	13	2020-05-30 00:00:00	submitted
11	2020-05-31 22:37:49.714409	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-06-30	2023-05-30	1.00	15	2020-05-30 00:00:00	submitted
12	2020-06-02 22:39:18.720206	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	22	2020-06-02 00:00:00	submitted
13	2020-06-02 23:04:56.277377	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	8	2020-06-02 00:00:00	submitted
14	2020-06-02 23:05:15.970137	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	23	2020-06-02 00:00:00	submitted
15	2020-06-02 23:05:45.54732	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-02	2023-06-02	1.00	8	2020-06-02 00:00:00	submitted
16	2020-06-03 00:30:52.710507	2020-06-05 05:52:59.302095	1	4	51000.00	36	5500.00	250.00	45250.00	2020-07-03	2023-06-03	1.00	24	2020-06-03 00:00:00	submitted
17	2020-06-03 18:06:04.271478	2020-06-05 05:52:59.302095	1	4	12000.00	24	5500.00	250.00	6250.00	2020-07-03	2022-06-03	1.00	8	2020-06-03 00:00:00	submitted
\.


--
-- Data for Name: loan_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan_payment (id, date_created, date_modified, batch_id, loan_id, amount_paid) FROM stdin;
\.


--
-- Data for Name: loan_payment_batch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan_payment_batch (id, date_created, date_modified, trans_date, description) FROM stdin;
\.


--
-- Data for Name: loan_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.loan_status (id, date_created, date_modified, status, role_required) FROM stdin;
1	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	submitted	\N
2	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	checked	checker
3	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	endorsed	endorser
4	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	verified	committee
5	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	approved	ceo
6	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	processed	processor
7	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	released	\N
8	2020-07-06 21:04:57.747612	2020-07-06 21:04:57.747612	denied	\N
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
-- Data for Name: member_salary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member_salary (id, date_created, date_modified, effective_date, sg, step, user_detail_id, salary) FROM stdin;
10	2020-06-23 03:32:46.452967	2020-06-23 03:32:46.452967	2020-06-22	3	1	2	12466.00
9	2020-06-23 03:07:51.526126	2020-06-23 03:33:09.358036	2020-06-22	20	1	1	51155.00
11	2020-06-23 03:34:07.789265	2020-06-23 03:34:07.789265	2020-06-22	9	1	13	17975.00
12	2020-06-23 03:41:38.334094	2020-06-23 03:41:38.334094	2020-06-22	11	1	14	20754.00
\.


--
-- Data for Name: member_salary_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.member_salary_history (id, date_created, date_modified, user_detail_id, effective_date, sg, step, salary) FROM stdin;
\.


--
-- Data for Name: salary_grade; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salary_grade (id, date_created, date_modified, sg, step, salary, group_name, active) FROM stdin;
51	2020-06-07 06:34:50.064401	2020-06-07 17:15:00.865685	4	1	13214.00	SSL 4 TRANCHE 4	t
52	2020-06-07 06:34:50.064401	2020-06-07 17:15:00.865685	5	1	14007.00	SSL 4 TRANCHE 4	t
53	2020-06-07 06:34:50.064401	2020-06-07 17:15:00.865685	6	1	14847.00	SSL 4 TRANCHE 4	t
54	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	1	15738.00	SSL 4 TRANCHE 4	t
55	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	1	16758.00	SSL 4 TRANCHE 4	t
56	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	1	17975.00	SSL 4 TRANCHE 4	t
57	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	1	19233.00	SSL 4 TRANCHE 4	t
58	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	1	20754.00	SSL 4 TRANCHE 4	t
59	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	1	22938.00	SSL 4 TRANCHE 4	t
60	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	1	25232.00	SSL 4 TRANCHE 4	t
61	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	1	27755.00	SSL 4 TRANCHE 4	t
62	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	1	30531.00	SSL 4 TRANCHE 4	t
63	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	1	33584.00	SSL 4 TRANCHE 4	t
64	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	1	36942.00	SSL 4 TRANCHE 4	t
65	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	1	40637.00	SSL 4 TRANCHE 4	t
66	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	1	45269.00	SSL 4 TRANCHE 4	t
67	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	1	51155.00	SSL 4 TRANCHE 4	t
68	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	1	57805.00	SSL 4 TRANCHE 4	t
69	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	1	65319.00	SSL 4 TRANCHE 4	t
70	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	1	73811.00	SSL 4 TRANCHE 4	t
71	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	1	83406.00	SSL 4 TRANCHE 4	t
72	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	1	95083.00	SSL 4 TRANCHE 4	t
73	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	1	107444.00	SSL 4 TRANCHE 4	t
74	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	1	121411.00	SSL 4 TRANCHE 4	t
75	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	1	137195.00	SSL 4 TRANCHE 4	t
76	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	1	155030.00	SSL 4 TRANCHE 4	t
77	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	1	175184.00	SSL 4 TRANCHE 4	t
78	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	1	257809.00	SSL 4 TRANCHE 4	t
79	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	1	307365.00	SSL 4 TRANCHE 4	t
80	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	33	1	388096.00	SSL 4 TRANCHE 4	t
81	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	2	11160.00	SSL 4 TRANCHE 4	t
82	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	2	11851.00	SSL 4 TRANCHE 4	t
83	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	2	12562.00	SSL 4 TRANCHE 4	t
84	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	2	13316.00	SSL 4 TRANCHE 4	t
85	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	2	14115.00	SSL 4 TRANCHE 4	t
86	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	2	14961.00	SSL 4 TRANCHE 4	t
87	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	2	15859.00	SSL 4 TRANCHE 4	t
88	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	2	16910.00	SSL 4 TRANCHE 4	t
89	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	2	18125.00	SSL 4 TRANCHE 4	t
90	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	2	19394.00	SSL 4 TRANCHE 4	t
91	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	2	21038.00	SSL 4 TRANCHE 4	t
92	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	2	23222.00	SSL 4 TRANCHE 4	t
93	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	2	25545.00	SSL 4 TRANCHE 4	t
94	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	2	28099.00	SSL 4 TRANCHE 4	t
95	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	2	30909.00	SSL 4 TRANCHE 4	t
96	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	2	34000.00	SSL 4 TRANCHE 4	t
97	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	2	37400.00	SSL 4 TRANCHE 4	t
98	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	2	41140.00	SSL 4 TRANCHE 4	t
99	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	2	46008.00	SSL 4 TRANCHE 4	t
100	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	2	51989.00	SSL 4 TRANCHE 4	t
101	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	2	58748.00	SSL 4 TRANCHE 4	t
102	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	2	66385.00	SSL 4 TRANCHE 4	t
103	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	2	75015.00	SSL 4 TRANCHE 4	t
104	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	2	84767.00	SSL 4 TRANCHE 4	t
105	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	2	96635.00	SSL 4 TRANCHE 4	t
106	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	2	109197.00	SSL 4 TRANCHE 4	t
107	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	2	123393.00	SSL 4 TRANCHE 4	t
108	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	2	139434.00	SSL 4 TRANCHE 4	t
109	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	2	157561.00	SSL 4 TRANCHE 4	t
110	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	2	178043.00	SSL 4 TRANCHE 4	t
111	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	2	262844.00	SSL 4 TRANCHE 4	t
112	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	2	313564.00	SSL 4 TRANCHE 4	t
113	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	33	2	399739.00	SSL 4 TRANCHE 4	t
114	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	3	11254.00	SSL 4 TRANCHE 4	t
115	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	3	11942.00	SSL 4 TRANCHE 4	t
116	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	3	12658.00	SSL 4 TRANCHE 4	t
117	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	3	13418.00	SSL 4 TRANCHE 4	t
118	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	3	14223.00	SSL 4 TRANCHE 4	t
119	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	3	15076.00	SSL 4 TRANCHE 4	t
120	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	3	15981.00	SSL 4 TRANCHE 4	t
121	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	3	17063.00	SSL 4 TRANCHE 4	t
122	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	3	18277.00	SSL 4 TRANCHE 4	t
123	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	3	19556.00	SSL 4 TRANCHE 4	t
124	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	3	21327.00	SSL 4 TRANCHE 4	t
125	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	3	23510.00	SSL 4 TRANCHE 4	t
126	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	3	25861.00	SSL 4 TRANCHE 4	t
127	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	3	28447.00	SSL 4 TRANCHE 4	t
128	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	3	31292.00	SSL 4 TRANCHE 4	t
129	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	3	34421.00	SSL 4 TRANCHE 4	t
130	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	3	37863.00	SSL 4 TRANCHE 4	t
131	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	3	41650.00	SSL 4 TRANCHE 4	t
132	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	3	46759.00	SSL 4 TRANCHE 4	t
133	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	3	52838.00	SSL 4 TRANCHE 4	t
134	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	3	59707.00	SSL 4 TRANCHE 4	t
135	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	3	67469.00	SSL 4 TRANCHE 4	t
136	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	3	76240.00	SSL 4 TRANCHE 4	t
137	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	3	86151.00	SSL 4 TRANCHE 4	t
138	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	3	98212.00	SSL 4 TRANCHE 4	t
139	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	3	110980.00	SSL 4 TRANCHE 4	t
140	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	3	125407.00	SSL 4 TRANCHE 4	t
141	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	3	141710.00	SSL 4 TRANCHE 4	t
142	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	3	160132.00	SSL 4 TRANCHE 4	t
143	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	3	180949.00	SSL 4 TRANCHE 4	t
144	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	3	267978.00	SSL 4 TRANCHE 4	t
145	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	3	319887.00	SSL 4 TRANCHE 4	t
146	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	4	11348.00	SSL 4 TRANCHE 4	t
147	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	4	12034.00	SSL 4 TRANCHE 4	t
148	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	4	12756.00	SSL 4 TRANCHE 4	t
149	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	4	13521.00	SSL 4 TRANCHE 4	t
150	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	4	14332.00	SSL 4 TRANCHE 4	t
151	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	4	15192.00	SSL 4 TRANCHE 4	t
152	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	4	16104.00	SSL 4 TRANCHE 4	t
153	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	4	17217.00	SSL 4 TRANCHE 4	t
154	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	4	18430.00	SSL 4 TRANCHE 4	t
155	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	4	19720.00	SSL 4 TRANCHE 4	t
156	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	4	21619.00	SSL 4 TRANCHE 4	t
157	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	4	23801.00	SSL 4 TRANCHE 4	t
158	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	4	26181.00	SSL 4 TRANCHE 4	t
159	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	4	28800.00	SSL 4 TRANCHE 4	t
160	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	4	31680.00	SSL 4 TRANCHE 4	t
161	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	4	34847.00	SSL 4 TRANCHE 4	t
162	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	4	38332.00	SSL 4 TRANCHE 4	t
163	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	4	42165.00	SSL 4 TRANCHE 4	t
164	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	4	47522.00	SSL 4 TRANCHE 4	t
165	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	4	53700.00	SSL 4 TRANCHE 4	t
166	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	4	60681.00	SSL 4 TRANCHE 4	t
167	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	4	68570.00	SSL 4 TRANCHE 4	t
168	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	4	77484.00	SSL 4 TRANCHE 4	t
169	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	4	87557.00	SSL 4 TRANCHE 4	t
170	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	4	99815.00	SSL 4 TRANCHE 4	t
171	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	4	112791.00	SSL 4 TRANCHE 4	t
172	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	4	127454.00	SSL 4 TRANCHE 4	t
173	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	4	144023.00	SSL 4 TRANCHE 4	t
174	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	4	162746.00	SSL 4 TRANCHE 4	t
175	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	4	183903.00	SSL 4 TRANCHE 4	t
176	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	4	273212.00	SSL 4 TRANCHE 4	t
177	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	4	326338.00	SSL 4 TRANCHE 4	t
50	2020-06-07 06:34:50.064401	2020-06-07 17:15:00.865685	3	1	12466.00	SSL 4 TRANCHE 4	t
178	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	5	11443.00	SSL 4 TRANCHE 4	t
179	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	5	12126.00	SSL 4 TRANCHE 4	t
180	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	5	12854.00	SSL 4 TRANCHE 4	t
181	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	5	13625.00	SSL 4 TRANCHE 4	t
182	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	5	14442.00	SSL 4 TRANCHE 4	t
183	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	5	15309.00	SSL 4 TRANCHE 4	t
184	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	5	16227.00	SSL 4 TRANCHE 4	t
185	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	5	17372.00	SSL 4 TRANCHE 4	t
186	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	5	18584.00	SSL 4 TRANCHE 4	t
187	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	5	19884.00	SSL 4 TRANCHE 4	t
188	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	5	21915.00	SSL 4 TRANCHE 4	t
189	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	5	24096.00	SSL 4 TRANCHE 4	t
190	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	5	26506.00	SSL 4 TRANCHE 4	t
191	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	5	29156.00	SSL 4 TRANCHE 4	t
192	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	5	32072.00	SSL 4 TRANCHE 4	t
193	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	5	35279.00	SSL 4 TRANCHE 4	t
194	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	5	38807.00	SSL 4 TRANCHE 4	t
195	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	5	42688.00	SSL 4 TRANCHE 4	t
196	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	5	48298.00	SSL 4 TRANCHE 4	t
197	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	5	54577.00	SSL 4 TRANCHE 4	t
198	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	5	61672.00	SSL 4 TRANCHE 4	t
199	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	5	69689.00	SSL 4 TRANCHE 4	t
200	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	5	78749.00	SSL 4 TRANCHE 4	t
201	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	5	88986.00	SSL 4 TRANCHE 4	t
202	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	5	101444.00	SSL 4 TRANCHE 4	t
203	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	5	114632.00	SSL 4 TRANCHE 4	t
204	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	5	129534.00	SSL 4 TRANCHE 4	t
205	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	5	146373.00	SSL 4 TRANCHE 4	t
206	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	5	165402.00	SSL 4 TRANCHE 4	t
207	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	5	186904.00	SSL 4 TRANCHE 4	t
208	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	5	278549.00	SSL 4 TRANCHE 4	t
209	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	5	332919.00	SSL 4 TRANCHE 4	t
210	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	6	11538.00	SSL 4 TRANCHE 4	t
211	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	6	12219.00	SSL 4 TRANCHE 4	t
212	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	6	12952.00	SSL 4 TRANCHE 4	t
213	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	6	13729.00	SSL 4 TRANCHE 4	t
214	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	6	14553.00	SSL 4 TRANCHE 4	t
215	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	6	15426.00	SSL 4 TRANCHE 4	t
216	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	6	16352.00	SSL 4 TRANCHE 4	t
217	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	6	17529.00	SSL 4 TRANCHE 4	t
218	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	6	18739.00	SSL 4 TRANCHE 4	t
219	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	6	20051.00	SSL 4 TRANCHE 4	t
220	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	6	22216.00	SSL 4 TRANCHE 4	t
221	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	6	24395.00	SSL 4 TRANCHE 4	t
222	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	6	26834.00	SSL 4 TRANCHE 4	t
223	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	6	29517.00	SSL 4 TRANCHE 4	t
224	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	6	32469.00	SSL 4 TRANCHE 4	t
225	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	6	35716.00	SSL 4 TRANCHE 4	t
226	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	6	39288.00	SSL 4 TRANCHE 4	t
227	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	6	43217.00	SSL 4 TRANCHE 4	t
228	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	6	49086.00	SSL 4 TRANCHE 4	t
229	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	6	55468.00	SSL 4 TRANCHE 4	t
230	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	6	62678.00	SSL 4 TRANCHE 4	t
231	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	6	70827.00	SSL 4 TRANCHE 4	t
232	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	6	80034.00	SSL 4 TRANCHE 4	t
233	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	6	90439.00	SSL 4 TRANCHE 4	t
234	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	6	103100.00	SSL 4 TRANCHE 4	t
235	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	6	116503.00	SSL 4 TRANCHE 4	t
236	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	6	131648.00	SSL 4 TRANCHE 4	t
237	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	6	148763.00	SSL 4 TRANCHE 4	t
238	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	6	168102.00	SSL 4 TRANCHE 4	t
239	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	6	189955.00	SSL 4 TRANCHE 4	t
240	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	6	283989.00	SSL 4 TRANCHE 4	t
241	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	6	339633.00	SSL 4 TRANCHE 4	t
242	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	7	11635.00	SSL 4 TRANCHE 4	t
243	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	7	12313.00	SSL 4 TRANCHE 4	t
244	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	7	13052.00	SSL 4 TRANCHE 4	t
245	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	7	13835.00	SSL 4 TRANCHE 4	t
246	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	7	14665.00	SSL 4 TRANCHE 4	t
247	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	7	15545.00	SSL 4 TRANCHE 4	t
248	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	7	16477.00	SSL 4 TRANCHE 4	t
249	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	7	17688.00	SSL 4 TRANCHE 4	t
250	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	7	18896.00	SSL 4 TRANCHE 4	t
251	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	7	20218.00	SSL 4 TRANCHE 4	t
252	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	7	22520.00	SSL 4 TRANCHE 4	t
253	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	7	24697.00	SSL 4 TRANCHE 4	t
254	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	7	27166.00	SSL 4 TRANCHE 4	t
255	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	7	29883.00	SSL 4 TRANCHE 4	t
256	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	7	32871.00	SSL 4 TRANCHE 4	t
257	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	7	36159.00	SSL 4 TRANCHE 4	t
258	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	7	39774.00	SSL 4 TRANCHE 4	t
259	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	7	43752.00	SSL 4 TRANCHE 4	t
260	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	7	49888.00	SSL 4 TRANCHE 4	t
261	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	7	56373.00	SSL 4 TRANCHE 4	t
262	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	7	63701.00	SSL 4 TRANCHE 4	t
263	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	7	71983.00	SSL 4 TRANCHE 4	t
264	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	7	81340.00	SSL 4 TRANCHE 4	t
265	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	7	91915.00	SSL 4 TRANCHE 4	t
266	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	7	104783.00	SSL 4 TRANCHE 4	t
267	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	7	118404.00	SSL 4 TRANCHE 4	t
268	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	7	133797.00	SSL 4 TRANCHE 4	t
269	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	7	151191.00	SSL 4 TRANCHE 4	t
270	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	7	170845.00	SSL 4 TRANCHE 4	t
271	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	7	193055.00	SSL 4 TRANCHE 4	t
272	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	7	289536.00	SSL 4 TRANCHE 4	t
273	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	7	346483.00	SSL 4 TRANCHE 4	t
274	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	1	8	11732.00	SSL 4 TRANCHE 4	t
275	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	2	8	12407.00	SSL 4 TRANCHE 4	t
276	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	3	8	13152.00	SSL 4 TRANCHE 4	t
277	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	4	8	13941.00	SSL 4 TRANCHE 4	t
278	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	5	8	14777.00	SSL 4 TRANCHE 4	t
279	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	6	8	15664.00	SSL 4 TRANCHE 4	t
280	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	7	8	16604.00	SSL 4 TRANCHE 4	t
281	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	8	8	17848.00	SSL 4 TRANCHE 4	t
282	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	9	8	19054.00	SSL 4 TRANCHE 4	t
283	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	10	8	20387.00	SSL 4 TRANCHE 4	t
284	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	11	8	22829.00	SSL 4 TRANCHE 4	t
285	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	12	8	25003.00	SSL 4 TRANCHE 4	t
286	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	13	8	27503.00	SSL 4 TRANCHE 4	t
287	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	14	8	30253.00	SSL 4 TRANCHE 4	t
288	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	15	8	33279.00	SSL 4 TRANCHE 4	t
289	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	16	8	36606.00	SSL 4 TRANCHE 4	t
290	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	17	8	40267.00	SSL 4 TRANCHE 4	t
291	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	18	8	44294.00	SSL 4 TRANCHE 4	t
292	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	19	8	50702.00	SSL 4 TRANCHE 4	t
293	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	20	8	57293.00	SSL 4 TRANCHE 4	t
294	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	21	8	64741.00	SSL 4 TRANCHE 4	t
295	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	22	8	73157.00	SSL 4 TRANCHE 4	t
296	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	23	8	82668.00	SSL 4 TRANCHE 4	t
297	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	24	8	93415.00	SSL 4 TRANCHE 4	t
298	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	25	8	106493.00	SSL 4 TRANCHE 4	t
299	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	26	8	120337.00	SSL 4 TRANCHE 4	t
300	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	27	8	135981.00	SSL 4 TRANCHE 4	t
301	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	28	8	153658.00	SSL 4 TRANCHE 4	t
302	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	29	8	173634.00	SSL 4 TRANCHE 4	t
303	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	30	8	196206.00	SSL 4 TRANCHE 4	t
304	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	31	8	295191.00	SSL 4 TRANCHE 4	t
305	2020-06-07 06:34:50.064401	2020-06-07 06:34:50.064401	32	8	353470.00	SSL 4 TRANCHE 4	t
49	2020-06-07 06:34:50.064401	2020-06-12 06:12:14.871849	2	1	11761.00	SSL 4 TRANCHE 4	t
48	2020-06-07 06:34:50.064401	2020-06-12 06:13:51.107357	1	1	11068.00	SSL 4 TRANCHE 4	t
\.


--
-- Data for Name: service; Type: TABLE DATA; Schema: public; Owner: jeff
--

COPY public.service (id, date_created, date_modified, name, description, interest_rate, min_term, max_term, active) FROM stdin;
2	2020-05-03 20:22:27	2020-05-06 06:20:33	Special Loan	80% of Basic Pay\r\nOne time payment\r\nDue on May 30, 2020	1.50	12	12	t
1	2020-05-03 20:21:44	2020-05-04 14:20:21	Regular Loan	80% of TAV\r\n12-, 24-, 36-month terms\r\nRenewable after 25% payment	1.00	12	36	t
\.


--
-- Name: auth_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jeff
--

SELECT pg_catalog.setval('public.auth_role_id_seq', 9, true);


--
-- Name: auth_user_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jeff
--

SELECT pg_catalog.setval('public.auth_user_detail_id_seq', 14, true);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jeff
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 62, true);


--
-- Name: auth_user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jeff
--

SELECT pg_catalog.setval('public.auth_user_roles_id_seq', 15, true);


--
-- Name: bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bank_id_seq', 2, true);


--
-- Name: loan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_id_seq', 17, true);


--
-- Name: loan_payment_batch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_payment_batch_id_seq', 1, false);


--
-- Name: loan_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_payment_id_seq', 1, true);


--
-- Name: loan_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.loan_status_id_seq', 9, true);


--
-- Name: member_bank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.member_bank_id_seq', 24, true);


--
-- Name: member_salary_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.member_salary_history_id_seq', 7, true);


--
-- Name: member_salary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.member_salary_id_seq', 12, true);


--
-- Name: salary_grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.salary_grade_id_seq', 305, true);


--
-- Name: service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jeff
--

SELECT pg_catalog.setval('public.service_id_seq', 2, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: auth_role auth_role_name_key; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_name_key UNIQUE (name);


--
-- Name: auth_role auth_role_pkey; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_role
    ADD CONSTRAINT auth_role_pkey PRIMARY KEY (id);


--
-- Name: auth_user_detail auth_user_detail_last_name_first_name_middle_name_suffix_key; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_detail
    ADD CONSTRAINT auth_user_detail_last_name_first_name_middle_name_suffix_key UNIQUE (last_name, first_name, middle_name, suffix);


--
-- Name: auth_user_detail auth_user_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_detail
    ADD CONSTRAINT auth_user_detail_pkey PRIMARY KEY (id);


--
-- Name: auth_user_detail auth_user_detail_user_id_key; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_detail
    ADD CONSTRAINT auth_user_detail_user_id_key UNIQUE (user_id);


--
-- Name: auth_user auth_user_email_key; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_email_key UNIQUE (email);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_roles auth_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: jeff
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
-- Name: loan_payment_batch loan_payment_batch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_payment_batch
    ADD CONSTRAINT loan_payment_batch_pkey PRIMARY KEY (id);


--
-- Name: loan_payment loan_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_payment
    ADD CONSTRAINT loan_payment_pkey PRIMARY KEY (id);


--
-- Name: loan loan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan
    ADD CONSTRAINT loan_pkey PRIMARY KEY (id);


--
-- Name: loan_status loan_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_status
    ADD CONSTRAINT loan_status_pkey PRIMARY KEY (id);


--
-- Name: loan_status loan_status_status_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_status
    ADD CONSTRAINT loan_status_status_key UNIQUE (status);


--
-- Name: member_bank member_bank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_bank
    ADD CONSTRAINT member_bank_pkey PRIMARY KEY (id);


--
-- Name: member_salary_history member_salary_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary_history
    ADD CONSTRAINT member_salary_history_pkey PRIMARY KEY (id);


--
-- Name: member_salary member_salary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary
    ADD CONSTRAINT member_salary_pkey PRIMARY KEY (id);


--
-- Name: member_salary member_salary_user_detail_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary
    ADD CONSTRAINT member_salary_user_detail_id_key UNIQUE (user_detail_id);


--
-- Name: salary_grade salary_grade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.salary_grade
    ADD CONSTRAINT salary_grade_pkey PRIMARY KEY (id);


--
-- Name: service service_name_key; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_name_key UNIQUE (name);


--
-- Name: service service_pkey; Type: CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- Name: auth_user_detail auth_user_detail_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_detail
    ADD CONSTRAINT auth_user_detail_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- Name: auth_user_roles auth_user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT auth_user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.auth_role(id) ON DELETE CASCADE;


--
-- Name: auth_user_roles auth_user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jeff
--

ALTER TABLE ONLY public.auth_user_roles
    ADD CONSTRAINT auth_user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- Name: loan_payment loan_payment_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_payment
    ADD CONSTRAINT loan_payment_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES public.loan_payment_batch(id) ON DELETE CASCADE;


--
-- Name: loan_payment loan_payment_loan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loan_payment
    ADD CONSTRAINT loan_payment_loan_id_fkey FOREIGN KEY (loan_id) REFERENCES public.loan(id) ON DELETE CASCADE;


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
-- Name: member_salary_history member_salary_history_user_detail_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary_history
    ADD CONSTRAINT member_salary_history_user_detail_id_fkey FOREIGN KEY (user_detail_id) REFERENCES public.auth_user_detail(id) ON DELETE CASCADE;


--
-- Name: member_salary member_salary_user_detail_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.member_salary
    ADD CONSTRAINT member_salary_user_detail_id_fkey FOREIGN KEY (user_detail_id) REFERENCES public.auth_user_detail(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

