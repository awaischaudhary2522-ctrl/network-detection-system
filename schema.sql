--
-- PostgreSQL database dump
--

\restrict BHptPGxESmAIcpqkMDGhu5Pjs9on5IQCrCuEoE6SmM2yMneacfEqxSHG4bgiu93

-- Dumped from database version 14.22 (Ubuntu 14.22-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.22 (Ubuntu 14.22-0ubuntu0.22.04.1)

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
-- Name: alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerts (
    id bigint NOT NULL,
    alert_type character varying(75),
    severity character varying(75),
    source_ip character varying(75),
    created_at timestamp without time zone,
    resolved boolean DEFAULT false
);


ALTER TABLE public.alerts OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alerts_id_seq OWNER TO postgres;

--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.devices (
    id bigint NOT NULL,
    ip_address character varying(50),
    mac_address character varying(50),
    hostname character varying(75),
    first_seen timestamp without time zone,
    last_seen timestamp without time zone
);


ALTER TABLE public.devices OWNER TO postgres;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.devices_id_seq OWNER TO postgres;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.devices_id_seq OWNED BY public.devices.id;


--
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id bigint NOT NULL,
    event character varying(75),
    created_at timestamp without time zone
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_id_seq OWNER TO postgres;

--
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- Name: ports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ports (
    id bigint NOT NULL,
    device_id integer,
    scan_id integer,
    port_number integer,
    service_name character varying(75),
    protocol character varying(75)
);


ALTER TABLE public.ports OWNER TO postgres;

--
-- Name: ports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ports_id_seq OWNER TO postgres;

--
-- Name: ports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ports_id_seq OWNED BY public.ports.id;


--
-- Name: scans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scans (
    id bigint NOT NULL,
    subnet_scanned character varying(100),
    scanned_at timestamp without time zone
);


ALTER TABLE public.scans OWNER TO postgres;

--
-- Name: scans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scans_id_seq OWNER TO postgres;

--
-- Name: scans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scans_id_seq OWNED BY public.scans.id;


--
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- Name: devices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices ALTER COLUMN id SET DEFAULT nextval('public.devices_id_seq'::regclass);


--
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- Name: ports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports ALTER COLUMN id SET DEFAULT nextval('public.ports_id_seq'::regclass);


--
-- Name: scans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scans ALTER COLUMN id SET DEFAULT nextval('public.scans_id_seq'::regclass);


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerts (id, alert_type, severity, source_ip, created_at, resolved) FROM stdin;
1	Dangerous	Threat	192.168.1.1	2026-02-19 00:00:00	t
2	Dangerous	Threat	192.168.1.1	2026-02-19 00:00:00	t
3	Anomalous Scan Detected on 27	high	N/A	2026-03-19 08:57:57.750699	f
4	Anomalous Scan Detected on 28	high	N/A	2026-03-19 08:59:04.773303	f
5	Anomalous Scan Detected on 29	high	N/A	2026-03-19 09:11:03.88069	f
6	Testing Port Open	Critical	192.168.0.1	2026-03-19 09:12:40.973657	f
7	Anomalous Scan Detected on 30	high	N/A	2026-03-19 09:12:41.063864	f
8	Anomalous Scan Detected on 31	high	N/A	2026-03-19 09:21:00.300096	f
9	Anomalous Scan Detected on 32	high	N/A	2026-03-19 09:27:44.536406	f
10	Anomalous Scan Detected on 33	high	N/A	2026-03-19 09:31:12.432722	f
11	Anomalous Scan Detected on 34	high	N/A	2026-03-19 09:34:07.017989	f
12	Anomalous Scan Detected on 35	high	N/A	2026-03-20 14:12:12.675171	f
13	Anomalous Scan Detected on 36	high	N/A	2026-03-20 14:15:11.53402	f
14	Anomalous Scan Detected on 37	high	N/A	2026-03-20 14:42:44.672849	f
15	Anomalous Scan Detected on 38	high	N/A	2026-03-20 14:49:01.709867	f
16	Anomalous Scan Detected on 39	high	N/A	2026-03-20 14:53:01.636913	f
17	Anomalous Scan Detected on 40	high	N/A	2026-03-20 14:55:18.799331	f
18	Anomalous Scan Detected on 41	high	N/A	2026-03-20 14:57:49.2904	f
19	Anomalous Scan Detected on 42	high	N/A	2026-03-20 16:00:23.683513	f
20	Anomalous Scan Detected on 43	high	N/A	2026-03-20 16:07:28.223839	f
21	Anomalous Scan Detected on 44	high	N/A	2026-03-20 16:42:15.615677	f
22	Anomalous Scan Detected on 45	high	N/A	2026-03-20 20:20:52.614255	f
\.


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.devices (id, ip_address, mac_address, hostname, first_seen, last_seen) FROM stdin;
2	192.168.0.1	255.255.255.0	Vergil	2026-01-19 00:00:00	2026-02-19 00:00:00
3	192.168.0.1	255.255.255.0	Vergil	2026-01-19 00:00:00	2026-02-19 00:00:00
4	192.168.0.1	255.255.255.0	Vergil	2026-01-19 00:00:00	2026-02-19 00:00:00
5	192.168.0.1	\N	_gateway	2026-03-07 16:36:19.381425	2026-03-07 16:36:19.381425
6	192.168.0.101	\N		2026-03-07 16:36:19.381436	2026-03-07 16:36:19.381436
7	192.168.0.102	\N		2026-03-07 16:36:19.381437	2026-03-07 16:36:19.381437
8	192.168.0.105	\N	pop-os	2026-03-07 16:36:19.381438	2026-03-07 16:36:19.381438
9	192.168.0.1	\N	_gateway	2026-03-07 16:36:40.357004	2026-03-07 16:36:40.357004
10	192.168.0.101	\N		2026-03-07 16:36:40.357016	2026-03-07 16:36:40.357016
11	192.168.0.102	\N		2026-03-07 16:36:40.357029	2026-03-07 16:36:40.357029
12	192.168.0.105	\N	pop-os	2026-03-07 16:36:40.357031	2026-03-07 16:36:40.357031
13	192.168.0.1	\N	_gateway	2026-03-08 07:26:33.956601	2026-03-08 07:26:33.956601
14	192.168.0.101	\N		2026-03-08 07:26:33.956611	2026-03-08 07:26:33.956611
15	192.168.0.105	\N	pop-os	2026-03-08 07:26:33.956612	2026-03-08 07:26:33.956612
16	192.168.0.1	\N	_gateway	2026-03-09 05:16:56.792716	2026-03-09 05:16:56.792716
17	192.168.0.105	\N	pop-os	2026-03-09 05:16:56.792764	2026-03-09 05:16:56.792764
18	192.168.100.1	\N	_gateway	2026-03-15 10:36:39.903687	2026-03-15 10:36:39.903687
19	192.168.100.3	\N		2026-03-15 10:36:39.903701	2026-03-15 10:36:39.903701
20	192.168.100.5	\N		2026-03-15 10:36:39.903703	2026-03-15 10:36:39.903703
21	192.168.100.133	\N	pop-os	2026-03-15 10:36:39.903704	2026-03-15 10:36:39.903704
22	192.168.100.1	\N	_gateway	2026-03-15 10:44:26.721978	2026-03-15 10:44:26.721978
23	192.168.100.2	\N		2026-03-15 10:44:26.722003	2026-03-15 10:44:26.722003
24	192.168.100.5	\N		2026-03-15 10:44:26.722006	2026-03-15 10:44:26.722006
25	192.168.100.133	\N	pop-os	2026-03-15 10:44:26.722008	2026-03-15 10:44:26.722008
26	192.168.100.1	\N	_gateway	2026-03-15 10:50:24.775036	2026-03-15 10:50:24.775036
27	192.168.100.3	\N		2026-03-15 10:50:24.775061	2026-03-15 10:50:24.775061
28	192.168.100.5	\N		2026-03-15 10:50:24.775065	2026-03-15 10:50:24.775065
29	192.168.100.133	\N	pop-os	2026-03-15 10:50:24.775069	2026-03-15 10:50:24.775069
30	192.168.100.1	\N	_gateway	2026-03-15 10:55:42.556191	2026-03-15 10:55:42.556191
31	192.168.100.2	\N		2026-03-15 10:55:42.556599	2026-03-15 10:55:42.556599
32	192.168.100.3	\N		2026-03-15 10:55:42.556607	2026-03-15 10:55:42.556607
33	192.168.100.5	\N		2026-03-15 10:55:42.556612	2026-03-15 10:55:42.556612
34	192.168.100.66	\N		2026-03-15 10:55:42.556616	2026-03-15 10:55:42.556616
35	192.168.100.70	\N		2026-03-15 10:55:42.556619	2026-03-15 10:55:42.556619
36	192.168.100.88	\N		2026-03-15 10:55:42.556623	2026-03-15 10:55:42.556623
37	192.168.100.133	\N	pop-os	2026-03-15 10:55:42.556631	2026-03-15 10:55:42.556631
38	192.168.100.1	\N	_gateway	2026-03-15 10:57:16.337992	2026-03-15 10:57:16.337992
39	192.168.100.3	\N		2026-03-15 10:57:16.338009	2026-03-15 10:57:16.338009
40	192.168.100.5	\N		2026-03-15 10:57:16.338011	2026-03-15 10:57:16.338011
41	192.168.100.66	\N		2026-03-15 10:57:16.338013	2026-03-15 10:57:16.338013
42	192.168.100.70	\N		2026-03-15 10:57:16.338015	2026-03-15 10:57:16.338015
43	192.168.100.88	\N		2026-03-15 10:57:16.338017	2026-03-15 10:57:16.338017
44	192.168.100.133	\N	pop-os	2026-03-15 10:57:16.338019	2026-03-15 10:57:16.338019
45	192.168.0.1	\N	_gateway	2026-03-15 11:03:43.755424	2026-03-15 11:03:43.755424
46	192.168.0.100	\N		2026-03-15 11:03:43.755448	2026-03-15 11:03:43.755448
47	192.168.0.105	\N	pop-os	2026-03-15 11:03:43.755452	2026-03-15 11:03:43.755452
48	192.168.0.1	\N	_gateway	2026-03-15 11:05:54.499919	2026-03-15 11:05:54.499919
49	192.168.0.100	\N		2026-03-15 11:05:54.499939	2026-03-15 11:05:54.499939
50	192.168.0.105	\N	pop-os	2026-03-15 11:05:54.499942	2026-03-15 11:05:54.499942
51	192.168.0.1	\N	_gateway	2026-03-16 14:50:53.906205	2026-03-16 14:50:53.906205
52	192.168.0.100	\N		2026-03-16 14:50:53.906225	2026-03-16 14:50:53.906225
53	192.168.0.101	\N		2026-03-16 14:50:53.906228	2026-03-16 14:50:53.906228
54	192.168.0.105	\N	pop-os	2026-03-16 14:50:53.906229	2026-03-16 14:50:53.906229
55	192.168.0.1	\N	_gateway	2026-03-19 08:17:40.439015	2026-03-19 08:17:40.439015
56	192.168.0.103	\N	pop-os	2026-03-19 08:17:40.439049	2026-03-19 08:17:40.439049
57	192.168.0.104	\N		2026-03-19 08:17:40.439052	2026-03-19 08:17:40.439052
58	192.168.0.1	\N	_gateway	2026-03-19 08:35:52.692357	2026-03-19 08:35:52.692357
59	192.168.0.104	\N		2026-03-19 08:35:52.69239	2026-03-19 08:35:52.69239
60	192.168.0.105	\N		2026-03-19 08:35:52.692396	2026-03-19 08:35:52.692396
61	192.168.0.103	\N	pop-os	2026-03-19 08:35:52.692402	2026-03-19 08:35:52.692402
62	192.168.100.133	\N	pop-os	2026-03-19 08:41:47.188041	2026-03-19 08:41:47.188041
63	192.168.0.1	\N	_gateway	2026-03-19 08:55:13.09915	2026-03-19 08:55:13.09915
64	192.168.0.104	\N		2026-03-19 08:55:13.099176	2026-03-19 08:55:13.099176
65	192.168.0.105	\N		2026-03-19 08:55:13.099182	2026-03-19 08:55:13.099182
66	192.168.0.103	\N	pop-os	2026-03-19 08:55:13.099187	2026-03-19 08:55:13.099187
67	192.168.0.1	\N	_gateway	2026-03-19 08:57:57.550941	2026-03-19 08:57:57.550941
68	192.168.0.103	\N	pop-os	2026-03-19 08:57:57.550958	2026-03-19 08:57:57.550958
69	192.168.0.1	\N	_gateway	2026-03-19 08:59:04.572522	2026-03-19 08:59:04.572522
70	192.168.0.104	\N		2026-03-19 08:59:04.572541	2026-03-19 08:59:04.572541
71	192.168.0.105	\N		2026-03-19 08:59:04.572544	2026-03-19 08:59:04.572544
72	192.168.0.103	\N	pop-os	2026-03-19 08:59:04.572546	2026-03-19 08:59:04.572546
73	192.168.0.1	\N	_gateway	2026-03-19 09:11:03.66935	2026-03-19 09:11:03.66935
74	192.168.0.103	\N	pop-os	2026-03-19 09:11:03.669429	2026-03-19 09:11:03.669429
75	192.168.0.104	\N		2026-03-19 09:11:03.669442	2026-03-19 09:11:03.669442
76	192.168.0.105	\N		2026-03-19 09:11:03.669445	2026-03-19 09:11:03.669445
77	192.168.0.1	\N	_gateway	2026-03-19 09:12:40.807529	2026-03-19 09:12:40.807529
78	192.168.0.103	\N	pop-os	2026-03-19 09:12:40.807553	2026-03-19 09:12:40.807553
79	192.168.0.104	\N		2026-03-19 09:12:40.807556	2026-03-19 09:12:40.807556
80	192.168.0.105	\N		2026-03-19 09:12:40.807558	2026-03-19 09:12:40.807558
81	192.168.0.1	\N	_gateway	2026-03-19 09:21:00.080664	2026-03-19 09:21:00.080664
82	192.168.0.103	\N	pop-os	2026-03-19 09:21:00.080685	2026-03-19 09:21:00.080685
83	192.168.0.104	\N		2026-03-19 09:21:00.080688	2026-03-19 09:21:00.080688
84	192.168.0.105	\N		2026-03-19 09:21:00.08069	2026-03-19 09:21:00.08069
85	192.168.0.1	\N	_gateway	2026-03-19 09:27:44.33919	2026-03-19 09:27:44.33919
86	192.168.0.104	\N		2026-03-19 09:27:44.339212	2026-03-19 09:27:44.339212
87	192.168.0.105	\N		2026-03-19 09:27:44.339215	2026-03-19 09:27:44.339215
88	192.168.0.103	\N	pop-os	2026-03-19 09:27:44.339217	2026-03-19 09:27:44.339217
89	192.168.0.1	\N	_gateway	2026-03-19 09:31:12.216224	2026-03-19 09:31:12.216224
90	192.168.0.104	\N		2026-03-19 09:31:12.216246	2026-03-19 09:31:12.216246
91	192.168.0.105	\N		2026-03-19 09:31:12.216249	2026-03-19 09:31:12.216249
92	192.168.0.103	\N	pop-os	2026-03-19 09:31:12.216251	2026-03-19 09:31:12.216251
93	192.168.0.1	\N	_gateway	2026-03-19 09:34:06.856517	2026-03-19 09:34:06.856517
94	192.168.0.104	\N		2026-03-19 09:34:06.85688	2026-03-19 09:34:06.85688
95	192.168.0.105	\N		2026-03-19 09:34:06.856913	2026-03-19 09:34:06.856913
96	192.168.0.103	\N	pop-os	2026-03-19 09:34:06.856968	2026-03-19 09:34:06.856968
97	192.168.0.1	\N	_gateway	2026-03-20 14:12:12.481116	2026-03-20 14:12:12.481116
98	192.168.0.103	\N	pop-os	2026-03-20 14:12:12.481142	2026-03-20 14:12:12.481142
99	192.168.0.1	\N	_gateway	2026-03-20 14:15:11.336913	2026-03-20 14:15:11.336913
100	192.168.0.104	\N		2026-03-20 14:15:11.336947	2026-03-20 14:15:11.336947
101	192.168.0.103	\N	pop-os	2026-03-20 14:15:11.336952	2026-03-20 14:15:11.336952
102	192.168.0.1	\N	_gateway	2026-03-20 14:42:44.496037	2026-03-20 14:42:44.496037
103	192.168.0.103	\N	pop-os	2026-03-20 14:42:44.496061	2026-03-20 14:42:44.496061
104	192.168.0.1	\N	_gateway	2026-03-20 14:49:01.525795	2026-03-20 14:49:01.525795
105	192.168.0.103	\N	pop-os	2026-03-20 14:49:01.525817	2026-03-20 14:49:01.525817
106	192.168.0.1	\N	_gateway	2026-03-20 14:53:01.455343	2026-03-20 14:53:01.455343
107	192.168.0.103	\N	pop-os	2026-03-20 14:53:01.455371	2026-03-20 14:53:01.455371
108	192.168.0.1	\N	_gateway	2026-03-20 14:55:18.628844	2026-03-20 14:55:18.628844
109	192.168.0.103	\N	pop-os	2026-03-20 14:55:18.628869	2026-03-20 14:55:18.628869
110	192.168.0.1	\N	_gateway	2026-03-20 14:57:49.111196	2026-03-20 14:57:49.111196
111	192.168.0.103	\N	pop-os	2026-03-20 14:57:49.11122	2026-03-20 14:57:49.11122
112	192.168.0.1	\N	_gateway	2026-03-20 16:00:23.451384	2026-03-20 16:00:23.451384
113	192.168.0.104	\N		2026-03-20 16:00:23.451407	2026-03-20 16:00:23.451407
114	192.168.0.105	\N		2026-03-20 16:00:23.451413	2026-03-20 16:00:23.451413
115	192.168.0.103	\N	pop-os	2026-03-20 16:00:23.451418	2026-03-20 16:00:23.451418
116	192.168.0.1	\N	_gateway	2026-03-20 16:07:27.998973	2026-03-20 16:07:27.998973
117	192.168.0.104	\N		2026-03-20 16:07:27.998995	2026-03-20 16:07:27.998995
118	192.168.0.105	\N		2026-03-20 16:07:27.998997	2026-03-20 16:07:27.998997
119	192.168.0.103	\N	pop-os	2026-03-20 16:07:27.999	2026-03-20 16:07:27.999
120	192.168.0.1	\N	_gateway	2026-03-20 16:42:15.390365	2026-03-20 16:42:15.390365
121	192.168.0.104	\N		2026-03-20 16:42:15.390389	2026-03-20 16:42:15.390389
122	192.168.0.105	\N		2026-03-20 16:42:15.390395	2026-03-20 16:42:15.390395
123	192.168.0.103	\N	pop-os	2026-03-20 16:42:15.390399	2026-03-20 16:42:15.390399
124	192.168.0.1	\N	_gateway	2026-03-20 20:20:52.453155	2026-03-20 20:20:52.453155
125	192.168.0.103	\N	pop-os	2026-03-20 20:20:52.453186	2026-03-20 20:20:52.453186
\.


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (id, event, created_at) FROM stdin;
1	Hii idkk	2026-02-20 00:00:00
2	Scan started for 192.168.0.1/24	2026-03-19 09:20:43.764084
3	Scan completed for 192.168.0.1/24	2026-03-19 09:21:00.319907
4	Scan started for 192.168.0.1/24	2026-03-19 09:27:28.867762
5	Scan completed for 192.168.0.1/24	2026-03-19 09:27:44.55014
6	Scan started for 192.168.0.1/24	2026-03-19 09:30:57.522293
7	Scan completed for 192.168.0.1/24	2026-03-19 09:31:12.452354
8	Scan started for 192.168.0.1/24	2026-03-19 09:33:51.004238
9	Scan completed for 192.168.0.1/24	2026-03-19 09:34:07.029474
10	Scan started for 192.168.0.1/24	2026-03-20 14:11:58.918019
11	Scan completed for 192.168.0.1/24	2026-03-20 14:12:12.687781
12	Scan started for 192.168.0.1/24	2026-03-20 14:14:45.227094
13	Scan completed for 192.168.0.1/24	2026-03-20 14:15:11.552062
14	Scan started for 192.168.0.1/24	2026-03-20 14:42:33.244049
15	Scan completed for 192.168.0.1/24	2026-03-20 14:42:44.683015
16	Scan started for 192.168.0.1/24	2026-03-20 14:48:50.363123
17	Scan completed for 192.168.0.1/24	2026-03-20 14:49:01.72276
18	Scan started for 192.168.0.1/24	2026-03-20 14:52:44.204687
19	Scan completed for 192.168.0.1/24	2026-03-20 14:53:01.646578
20	Scan started for 192.168.0.1/24	2026-03-20 14:55:00.989651
21	Scan completed for 192.168.0.1/24	2026-03-20 14:55:18.808752
22	Scan started for 192.168.0.1/24	2026-03-20 14:57:32.010759
23	Scan completed for 192.168.0.1/24	2026-03-20 14:57:49.29991
24	Scan started for 192.168.0.1/24	2026-03-20 15:59:17.435734
25	Scan completed for 192.168.0.1/24	2026-03-20 16:00:23.699011
26	Scan started for 192.168.0.1/24	2026-03-20 16:07:09.77184
27	Scan completed for 192.168.0.1/24	2026-03-20 16:07:28.237935
28	Scan started for 192.169.0.1/24	2026-03-20 16:40:42.330672
29	Scan started for 192.168.0.1/24	2026-03-20 16:41:02.477586
30	Scan completed for 192.168.0.1/24	2026-03-20 16:42:15.640324
31	Scan started for 192.168.0.1/24	2026-03-20 20:20:39.806011
32	Scan completed for 192.168.0.1/24	2026-03-20 20:20:52.626545
\.


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ports (id, device_id, scan_id, port_number, service_name, protocol) FROM stdin;
1	13	2	80	http	tcp
2	16	3	80	http	tcp
3	18	14	21	ftp	tcp
4	18	14	22	ssh	tcp
5	18	14	23	telnet	tcp
6	18	14	53	domain	tcp
7	18	14	80	http	tcp
8	22	15	21	ftp	tcp
9	22	15	22	ssh	tcp
10	22	15	23	telnet	tcp
11	22	15	53	domain	tcp
12	22	15	80	http	tcp
13	26	16	21	ftp	tcp
14	26	16	22	ssh	tcp
15	26	16	23	telnet	tcp
16	26	16	53	domain	tcp
17	26	16	80	http	tcp
18	30	17	21	ftp	tcp
19	30	17	22	ssh	tcp
20	30	17	23	telnet	tcp
21	30	17	53	domain	tcp
22	30	17	80	http	tcp
23	32	17	124	ansatrader	tcp
24	36	17	23	telnet	tcp
25	36	17	53	domain	tcp
26	36	17	113	ident	tcp
27	36	17	143	imap	tcp
28	36	17	199	smux	tcp
29	36	17	221	fln-spx	tcp
30	36	17	256	fw1-secureremote	tcp
31	36	17	257	fw1-mc-fwmodule	tcp
32	36	17	362	srssend	tcp
33	36	17	381	hp-collector	tcp
34	36	17	445	microsoft-ds	tcp
35	36	17	568	ms-shuttle	tcp
36	36	17	587	submission	tcp
37	36	17	748	ris-cm	tcp
38	36	17	867	unknown	tcp
39	38	18	21	ftp	tcp
40	38	18	22	ssh	tcp
41	38	18	23	telnet	tcp
42	38	18	53	domain	tcp
43	38	18	80	http	tcp
44	45	20	80	http	tcp
45	48	21	80	http	tcp
46	51	22	80	http	tcp
47	55	23	80	http	tcp
48	55	23	1980	http	tcp
49	58	24	80	http	tcp
50	58	24	1980	http	tcp
51	63	26	80	http	tcp
52	63	26	1980	http	tcp
53	67	27	80	http	tcp
54	67	27	1980	http	tcp
55	69	28	80	http	tcp
56	69	28	1980	http	tcp
57	73	29	80	http	tcp
58	73	29	1980	http	tcp
59	77	30	80	http	tcp
60	77	30	1980	http	tcp
61	81	31	80	http	tcp
62	81	31	1980	http	tcp
63	85	32	80	http	tcp
64	85	32	1980	http	tcp
65	89	33	80	http	tcp
66	89	33	1980	http	tcp
67	93	34	80	http	tcp
68	93	34	1980	http	tcp
69	97	35	80	http	tcp
70	97	35	1980	http	tcp
71	99	36	80	http	tcp
72	99	36	1980	http	tcp
73	102	37	80	http	tcp
74	102	37	1980	http	tcp
75	104	38	80	http	tcp
76	104	38	1980	http	tcp
77	106	39	80	http	tcp
78	106	39	1980	http	tcp
79	108	40	80	http	tcp
80	108	40	1980	http	tcp
81	110	41	80	http	tcp
82	110	41	1980	http	tcp
83	112	42	80	http	tcp
84	112	42	1980	http	tcp
85	116	43	80	http	tcp
86	116	43	1980	http	tcp
87	120	44	80	http	tcp
88	120	44	1980	http	tcp
89	124	45	80	http	tcp
90	124	45	1980	http	tcp
\.


--
-- Data for Name: scans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scans (id, subnet_scanned, scanned_at) FROM stdin;
1	Yo yo yo	2026-02-20 00:00:00
2	192.168.0.1/24	2026-03-08 07:26:33.956616
3	192.168.0.1/24	2026-03-09 05:16:56.792786
4	192.168.0.1/24	2026-03-09 09:02:21.553756
5	154.81.235.214/24	2026-03-09 09:04:40.967582
6	192.168.0.1/24	2026-03-09 09:05:30.730903
7	154.81.235.214/24	2026-03-09 09:05:55.232298
8	192.168.0.1/24	2026-03-15 09:27:34.653157
9	192.168.0.1/24	2026-03-15 09:39:57.988449
10	192.168.0.1/24	2026-03-15 10:00:28.132571
11	192.168.0.1/24	2026-03-15 10:04:52.472421
12	192.168.0.1/24	2026-03-15 10:21:51.172799
13	192.168.0.1/24	2026-03-15 10:33:54.433624
14	192.168.100.0/24	2026-03-15 10:36:39.90371
15	192.168.100.0/24	2026-03-15 10:44:26.722014
16	192.168.100.0/24	2026-03-15 10:50:24.775086
17	192.168.100.0/24	2026-03-15 10:55:42.556705
18	192.168.100.0/24	2026-03-15 10:57:16.338025
19	192.168.100.0/24	2026-03-15 11:01:16.45653
20	192.168.0.1/24	2026-03-15 11:03:43.75546
21	192.168.0.1/24	2026-03-15 11:05:54.499947
22	192.168.0.1/24	2026-03-16 14:50:53.906235
23	192.168.0.1/24	2026-03-19 08:17:40.439074
24	192.168.0.1/24	2026-03-19 08:35:52.692413
25	192.168.100.0/24	2026-03-19 08:41:47.188089
26	192.168.0.1/24	2026-03-19 08:55:13.099196
27	192.168.0.1/24	2026-03-19 08:57:57.550963
28	192.168.0.1/24	2026-03-19 08:59:04.572552
29	192.168.0.1/24	2026-03-19 09:11:03.669458
30	192.168.0.1/24	2026-03-19 09:12:40.807563
31	192.168.0.1/24	2026-03-19 09:21:00.080696
32	192.168.0.1/24	2026-03-19 09:27:44.339223
33	192.168.0.1/24	2026-03-19 09:31:12.216258
34	192.168.0.1/24	2026-03-19 09:34:06.857105
35	192.168.0.1/24	2026-03-20 14:12:12.481148
36	192.168.0.1/24	2026-03-20 14:15:11.336962
37	192.168.0.1/24	2026-03-20 14:42:44.49607
38	192.168.0.1/24	2026-03-20 14:49:01.525823
39	192.168.0.1/24	2026-03-20 14:53:01.455381
40	192.168.0.1/24	2026-03-20 14:55:18.628879
41	192.168.0.1/24	2026-03-20 14:57:49.11123
42	192.168.0.1/24	2026-03-20 16:00:23.451427
43	192.168.0.1/24	2026-03-20 16:07:27.999006
44	192.168.0.1/24	2026-03-20 16:42:15.390409
45	192.168.0.1/24	2026-03-20 20:20:52.453199
\.


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerts_id_seq', 22, true);


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.devices_id_seq', 125, true);


--
-- Name: logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_id_seq', 32, true);


--
-- Name: ports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ports_id_seq', 90, true);


--
-- Name: scans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scans_id_seq', 45, true);


--
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: devices devices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- Name: ports ports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pkey PRIMARY KEY (id);


--
-- Name: scans scans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scans
    ADD CONSTRAINT scans_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict BHptPGxESmAIcpqkMDGhu5Pjs9on5IQCrCuEoE6SmM2yMneacfEqxSHG4bgiu93

