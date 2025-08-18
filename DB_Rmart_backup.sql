--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Homebrew)
-- Dumped by pg_dump version 14.18 (Homebrew)

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
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    nama character varying(100),
    email character varying(100),
    password character varying(255)
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: barang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.barang (
    id integer NOT NULL,
    nama_barang text NOT NULL,
    jenis_id integer,
    harga_jual numeric(10,2),
    stok integer,
    gambar_url text,
    gambar text
);


ALTER TABLE public.barang OWNER TO postgres;

--
-- Name: barang_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.barang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.barang_id_seq OWNER TO postgres;

--
-- Name: barang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.barang_id_seq OWNED BY public.barang.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    description character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    nama character varying(100),
    email character varying(100),
    is_member boolean,
    password character varying(100)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customer_id_seq OWNER TO postgres;

--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_id_seq OWNED BY public.customer.id;


--
-- Name: detail_transaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detail_transaksi (
    id integer NOT NULL,
    transaksi_id integer,
    barang_id integer,
    jumlah integer,
    subtotal numeric(10,2)
);


ALTER TABLE public.detail_transaksi OWNER TO postgres;

--
-- Name: detail_transaksi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detail_transaksi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.detail_transaksi_id_seq OWNER TO postgres;

--
-- Name: detail_transaksi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detail_transaksi_id_seq OWNED BY public.detail_transaksi.id;


--
-- Name: diskon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.diskon (
    id integer NOT NULL,
    barang_id integer,
    persentase numeric(5,2),
    tanggal_mulai date,
    tanggal_akhir date
);


ALTER TABLE public.diskon OWNER TO postgres;

--
-- Name: diskon_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.diskon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.diskon_id_seq OWNER TO postgres;

--
-- Name: diskon_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.diskon_id_seq OWNED BY public.diskon.id;


--
-- Name: expense; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.expense (
    id integer NOT NULL,
    deskripsi character varying(255),
    jumlah numeric(19,2),
    kategori character varying(255),
    tanggal date
);


ALTER TABLE public.expense OWNER TO postgres;

--
-- Name: expense_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.expense_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.expense_id_seq OWNER TO postgres;

--
-- Name: expense_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.expense_id_seq OWNED BY public.expense.id;


--
-- Name: harga_beli; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.harga_beli (
    id integer NOT NULL,
    barang_id integer,
    supplier_id integer,
    harga numeric(10,2),
    tanggal date
);


ALTER TABLE public.harga_beli OWNER TO postgres;

--
-- Name: harga_beli_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.harga_beli_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.harga_beli_id_seq OWNER TO postgres;

--
-- Name: harga_beli_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.harga_beli_id_seq OWNED BY public.harga_beli.id;


--
-- Name: jenis_barang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_barang (
    id integer NOT NULL,
    nama_jenis character varying(50) NOT NULL,
    image text,
    icon_color character varying(20),
    icon character varying(10)
);


ALTER TABLE public.jenis_barang OWNER TO postgres;

--
-- Name: jenis_barang_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jenis_barang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jenis_barang_id_seq OWNER TO postgres;

--
-- Name: jenis_barang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jenis_barang_id_seq OWNED BY public.jenis_barang.id;


--
-- Name: keranjang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keranjang (
    id integer NOT NULL,
    customer_id integer,
    barang_id integer,
    jumlah integer
);


ALTER TABLE public.keranjang OWNER TO postgres;

--
-- Name: keranjang_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.keranjang_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.keranjang_id_seq OWNER TO postgres;

--
-- Name: keranjang_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.keranjang_id_seq OWNED BY public.keranjang.id;


--
-- Name: kuliner; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kuliner (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    daerah character varying(255) NOT NULL,
    deskripsi text,
    gambar_url character varying(255),
    kategori character varying(255) NOT NULL,
    nama character varying(255) NOT NULL,
    rating double precision,
    updated_at timestamp(6) without time zone
);


ALTER TABLE public.kuliner OWNER TO postgres;

--
-- Name: kuliner_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kuliner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kuliner_id_seq OWNER TO postgres;

--
-- Name: kuliner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kuliner_id_seq OWNED BY public.kuliner.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    price numeric(38,2) NOT NULL,
    quantity integer NOT NULL,
    subtotal numeric(38,2) NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    total_amount numeric(38,2) NOT NULL,
    user_id bigint NOT NULL,
    status character varying(255) NOT NULL,
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'PROCESSING'::character varying, 'SHIPPED'::character varying, 'DELIVERED'::character varying, 'CANCELLED'::character varying])::text[])))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: point_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point_member (
    id integer NOT NULL,
    customer_id integer,
    total_point integer
);


ALTER TABLE public.point_member OWNER TO postgres;

--
-- Name: point_member_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.point_member_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.point_member_id_seq OWNER TO postgres;

--
-- Name: point_member_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.point_member_id_seq OWNED BY public.point_member.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    description character varying(1000),
    image_url character varying(255),
    name character varying(255) NOT NULL,
    price numeric(38,2) NOT NULL,
    stock integer NOT NULL,
    category character varying(255),
    active boolean NOT NULL,
    category_id bigint,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: purchase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase (
    id integer NOT NULL,
    keterangan character varying(255),
    tanggal date,
    total_harga numeric(19,2),
    supplier_id integer
);


ALTER TABLE public.purchase OWNER TO postgres;

--
-- Name: restoran; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restoran (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone,
    deskripsi text,
    gambar_url character varying(255),
    jam_buka character varying(255),
    jam_tutup character varying(255),
    jenis_menu character varying(255),
    lokasi character varying(255) NOT NULL,
    nama character varying(255) NOT NULL,
    range_harga character varying(255),
    rating double precision,
    updated_at timestamp(6) without time zone
);


ALTER TABLE public.restoran OWNER TO postgres;

--
-- Name: restoran_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restoran_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.restoran_id_seq OWNER TO postgres;

--
-- Name: restoran_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restoran_id_seq OWNED BY public.restoran.id;


--
-- Name: shift_kerja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shift_kerja (
    id integer NOT NULL,
    nama_shift character varying(20),
    jam_mulai time without time zone,
    jam_selesai time without time zone
);


ALTER TABLE public.shift_kerja OWNER TO postgres;

--
-- Name: shift_kerja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shift_kerja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shift_kerja_id_seq OWNER TO postgres;

--
-- Name: shift_kerja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shift_kerja_id_seq OWNED BY public.shift_kerja.id;


--
-- Name: stok_keluar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stok_keluar (
    id integer NOT NULL,
    barang_id integer,
    jumlah integer,
    tanggal date
);


ALTER TABLE public.stok_keluar OWNER TO postgres;

--
-- Name: stok_keluar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stok_keluar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stok_keluar_id_seq OWNER TO postgres;

--
-- Name: stok_keluar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stok_keluar_id_seq OWNED BY public.stok_keluar.id;


--
-- Name: stok_masuk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stok_masuk (
    id integer NOT NULL,
    barang_id integer,
    jumlah integer,
    tanggal date
);


ALTER TABLE public.stok_masuk OWNER TO postgres;

--
-- Name: stok_masuk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stok_masuk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stok_masuk_id_seq OWNER TO postgres;

--
-- Name: stok_masuk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stok_masuk_id_seq OWNED BY public.stok_masuk.id;


--
-- Name: supplier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supplier (
    id integer NOT NULL,
    nama_supplier character varying(100),
    kontak character varying(20)
);


ALTER TABLE public.supplier OWNER TO postgres;

--
-- Name: supplier_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supplier_id_seq OWNER TO postgres;

--
-- Name: supplier_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supplier_id_seq OWNED BY public.supplier.id;


--
-- Name: target_penjualan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.target_penjualan (
    id integer NOT NULL,
    barang_id integer,
    bulan integer,
    tahun integer,
    jumlah_target integer
);


ALTER TABLE public.target_penjualan OWNER TO postgres;

--
-- Name: target_penjualan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.target_penjualan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.target_penjualan_id_seq OWNER TO postgres;

--
-- Name: target_penjualan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.target_penjualan_id_seq OWNED BY public.target_penjualan.id;


--
-- Name: tenaga_kerja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenaga_kerja (
    id integer NOT NULL,
    nama character varying(100),
    shift_id integer,
    password character varying(100),
    username character varying(50)
);


ALTER TABLE public.tenaga_kerja OWNER TO postgres;

--
-- Name: tenaga_kerja_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tenaga_kerja_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tenaga_kerja_id_seq OWNER TO postgres;

--
-- Name: tenaga_kerja_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tenaga_kerja_id_seq OWNED BY public.tenaga_kerja.id;


--
-- Name: test_connection; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test_connection (
    id bigint NOT NULL,
    name character varying(255)
);


ALTER TABLE public.test_connection OWNER TO postgres;

--
-- Name: test_connection_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.test_connection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.test_connection_id_seq OWNER TO postgres;

--
-- Name: test_connection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.test_connection_id_seq OWNED BY public.test_connection.id;


--
-- Name: transaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaksi (
    id integer NOT NULL,
    customer_id integer,
    tanggal date,
    total_harga numeric(10,2)
);


ALTER TABLE public.transaksi OWNER TO postgres;

--
-- Name: transaksi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaksi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaksi_id_seq OWNER TO postgres;

--
-- Name: transaksi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaksi_id_seq OWNED BY public.transaksi.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    active boolean NOT NULL,
    full_name character varying(255),
    last_login timestamp(6) without time zone,
    username character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: barang id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.barang ALTER COLUMN id SET DEFAULT nextval('public.barang_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer ALTER COLUMN id SET DEFAULT nextval('public.customer_id_seq'::regclass);


--
-- Name: detail_transaksi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transaksi ALTER COLUMN id SET DEFAULT nextval('public.detail_transaksi_id_seq'::regclass);


--
-- Name: diskon id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diskon ALTER COLUMN id SET DEFAULT nextval('public.diskon_id_seq'::regclass);


--
-- Name: expense id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expense ALTER COLUMN id SET DEFAULT nextval('public.expense_id_seq'::regclass);


--
-- Name: harga_beli id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harga_beli ALTER COLUMN id SET DEFAULT nextval('public.harga_beli_id_seq'::regclass);


--
-- Name: jenis_barang id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_barang ALTER COLUMN id SET DEFAULT nextval('public.jenis_barang_id_seq'::regclass);


--
-- Name: keranjang id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keranjang ALTER COLUMN id SET DEFAULT nextval('public.keranjang_id_seq'::regclass);


--
-- Name: kuliner id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuliner ALTER COLUMN id SET DEFAULT nextval('public.kuliner_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: point_member id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_member ALTER COLUMN id SET DEFAULT nextval('public.point_member_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: restoran id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restoran ALTER COLUMN id SET DEFAULT nextval('public.restoran_id_seq'::regclass);


--
-- Name: shift_kerja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_kerja ALTER COLUMN id SET DEFAULT nextval('public.shift_kerja_id_seq'::regclass);


--
-- Name: stok_keluar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_keluar ALTER COLUMN id SET DEFAULT nextval('public.stok_keluar_id_seq'::regclass);


--
-- Name: stok_masuk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_masuk ALTER COLUMN id SET DEFAULT nextval('public.stok_masuk_id_seq'::regclass);


--
-- Name: supplier id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier ALTER COLUMN id SET DEFAULT nextval('public.supplier_id_seq'::regclass);


--
-- Name: target_penjualan id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.target_penjualan ALTER COLUMN id SET DEFAULT nextval('public.target_penjualan_id_seq'::regclass);


--
-- Name: tenaga_kerja id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenaga_kerja ALTER COLUMN id SET DEFAULT nextval('public.tenaga_kerja_id_seq'::regclass);


--
-- Name: test_connection id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_connection ALTER COLUMN id SET DEFAULT nextval('public.test_connection_id_seq'::regclass);


--
-- Name: transaksi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaksi ALTER COLUMN id SET DEFAULT nextval('public.transaksi_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, nama, email, password) FROM stdin;
1	Admin1	admin1@mail.com	12345678
\.


--
-- Data for Name: barang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.barang (id, nama_barang, jenis_id, harga_jual, stok, gambar_url, gambar) FROM stdin;
1	mentos Permen Mint Roll 37 g	2	5400.00	231	/uploads/images/mentos.png	/uploads/images/mentos.png
2	Adem Sari Ching Ku Lemon Botol 350 ml	1	9700.00	322	/uploads/images/1748518514491_ademsari.png	/uploads/images/1748518514491_ademsari.png
3	Piattos Snack Kentang Sapi Panggang 68 g	2	11600.00	435	/uploads/images/1748518564562_piattos.png	/uploads/images/1748518564562_piattos.png
4	ABC Minuman Kopi Susu 200 ml	1	4500.00	196	/uploads/images/1748518597240_kopiabc.png	/uploads/images/1748518597240_kopiabc.png
5	Ekonomi Sabun Cuci Piring Jeruk Nipis 650 ml	4	9500.00	76	/uploads/images/1748518703813_ekonomicucipiring.png	/uploads/images/1748518703813_ekonomicucipiring.png
6	Bango Kecap Manis Refill 700 g	4	26500.00	311	/uploads/images/1748518740273_kecapbango.png	/uploads/images/1748518740273_kecapbango.png
7	Indomilk Susu Cair Rasa Stroberi 190 ml	1	5000.00	438	/uploads/images/1748518815555_indomilkstroberi.png	/uploads/images/1748518815555_indomilkstroberi.png
10	Mie sedap korean chicken	2	3500.00	453	/uploads/images/1748518974080_miesedapkoreanchicken.png	/uploads/images/1748518974080_miesedapkoreanchicken.png
11	Oops Pops Crackers Rasa Keju Cheesy 80 g	2	5000.00	252	/uploads/images/1748519022326_oopscreckers.png	/uploads/images/1748519022326_oopscreckers.png
12	Vixal Cairan Pembersih Kamar Mandi Ekstra Kuat 360 ml	4	9000.00	23	/uploads/images/1748519706250_vixallantai.png	/uploads/images/1748519706250_vixallantai.png
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, description, name) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, nama, email, is_member, password) FROM stdin;
1	Budi	budi@mail.com	t	12345678
2	ari	ari@mail.com	t	1234
\.


--
-- Data for Name: detail_transaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detail_transaksi (id, transaksi_id, barang_id, jumlah, subtotal) FROM stdin;
\.


--
-- Data for Name: diskon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.diskon (id, barang_id, persentase, tanggal_mulai, tanggal_akhir) FROM stdin;
\.


--
-- Data for Name: expense; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expense (id, deskripsi, jumlah, kategori, tanggal) FROM stdin;
\.


--
-- Data for Name: harga_beli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.harga_beli (id, barang_id, supplier_id, harga, tanggal) FROM stdin;
\.


--
-- Data for Name: jenis_barang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jenis_barang (id, nama_jenis, image, icon_color, icon) FROM stdin;
1	Minuman	https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400	#FF6B6B	🥤
2	Makanan	https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400	#4ECDC4	🍽️
3	Perawatan	https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400	#45B7D1	🧴
4	Kebutuhan Rumah Tangga	https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400	#96CEB4	🏠
\.


--
-- Data for Name: keranjang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keranjang (id, customer_id, barang_id, jumlah) FROM stdin;
\.


--
-- Data for Name: kuliner; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kuliner (id, created_at, daerah, deskripsi, gambar_url, kategori, nama, rating, updated_at) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, price, quantity, subtotal, order_id, product_id) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, created_at, total_amount, user_id, status) FROM stdin;
\.


--
-- Data for Name: point_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point_member (id, customer_id, total_point) FROM stdin;
1	1	120
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, description, image_url, name, price, stock, category, active, category_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: purchase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase (id, keterangan, tanggal, total_harga, supplier_id) FROM stdin;
\.


--
-- Data for Name: restoran; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restoran (id, created_at, deskripsi, gambar_url, jam_buka, jam_tutup, jenis_menu, lokasi, nama, range_harga, rating, updated_at) FROM stdin;
\.


--
-- Data for Name: shift_kerja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shift_kerja (id, nama_shift, jam_mulai, jam_selesai) FROM stdin;
1	Pagi	08:00:00	16:00:00
2	Malam	16:00:00	00:00:00
\.


--
-- Data for Name: stok_keluar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stok_keluar (id, barang_id, jumlah, tanggal) FROM stdin;
\.


--
-- Data for Name: stok_masuk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stok_masuk (id, barang_id, jumlah, tanggal) FROM stdin;
\.


--
-- Data for Name: supplier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supplier (id, nama_supplier, kontak) FROM stdin;
1	PT Sumber Sejahtera	021-12345678
\.


--
-- Data for Name: target_penjualan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.target_penjualan (id, barang_id, bulan, tahun, jumlah_target) FROM stdin;
\.


--
-- Data for Name: tenaga_kerja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenaga_kerja (id, nama, shift_id, password, username) FROM stdin;
1	Andi	1	\N	\N
\.


--
-- Data for Name: test_connection; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test_connection (id, name) FROM stdin;
\.


--
-- Data for Name: transaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaksi (id, customer_id, tanggal, total_harga) FROM stdin;
1	1	2025-05-21	10000.00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, name, password, role, created_at, active, full_name, last_login, username) FROM stdin;
5	admin@test.com	Admin User	$2a$10$N9qo8uLOickgx2ZMRZoMye/Ci/AB2hdxvFuv3iHzO6Js4GC5FLGW6	admin	2025-08-10 13:42:41.226152	t	\N	\N	admin
6	admin@admin.com	Admin	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	admin	2025-08-10 13:46:08.685703	t	\N	\N	admin2
7	admin@rmart.com	Administrator	admin123	admin	2025-08-10 13:52:22.973231	t	\N	\N	administrator
\.


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 1, false);


--
-- Name: barang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.barang_id_seq', 13, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 1, false);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_id_seq', 2, true);


--
-- Name: detail_transaksi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detail_transaksi_id_seq', 1, false);


--
-- Name: diskon_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.diskon_id_seq', 1, false);


--
-- Name: expense_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.expense_id_seq', 1, false);


--
-- Name: harga_beli_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.harga_beli_id_seq', 1, false);


--
-- Name: jenis_barang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jenis_barang_id_seq', 1, false);


--
-- Name: keranjang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.keranjang_id_seq', 1, false);


--
-- Name: kuliner_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kuliner_id_seq', 1, false);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: point_member_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.point_member_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 1, false);


--
-- Name: restoran_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restoran_id_seq', 1, false);


--
-- Name: shift_kerja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shift_kerja_id_seq', 1, false);


--
-- Name: stok_keluar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stok_keluar_id_seq', 1, false);


--
-- Name: stok_masuk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stok_masuk_id_seq', 1, false);


--
-- Name: supplier_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supplier_id_seq', 1, false);


--
-- Name: target_penjualan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.target_penjualan_id_seq', 1, false);


--
-- Name: tenaga_kerja_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tenaga_kerja_id_seq', 1, false);


--
-- Name: test_connection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.test_connection_id_seq', 1, false);


--
-- Name: transaksi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaksi_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: barang barang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.barang
    ADD CONSTRAINT barang_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (id);


--
-- Name: detail_transaksi detail_transaksi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transaksi
    ADD CONSTRAINT detail_transaksi_pkey PRIMARY KEY (id);


--
-- Name: diskon diskon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diskon
    ADD CONSTRAINT diskon_pkey PRIMARY KEY (id);


--
-- Name: expense expense_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expense
    ADD CONSTRAINT expense_pkey PRIMARY KEY (id);


--
-- Name: harga_beli harga_beli_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harga_beli
    ADD CONSTRAINT harga_beli_pkey PRIMARY KEY (id);


--
-- Name: jenis_barang jenis_barang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jenis_barang
    ADD CONSTRAINT jenis_barang_pkey PRIMARY KEY (id);


--
-- Name: keranjang keranjang_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keranjang
    ADD CONSTRAINT keranjang_pkey PRIMARY KEY (id);


--
-- Name: kuliner kuliner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kuliner
    ADD CONSTRAINT kuliner_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: point_member point_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_member
    ADD CONSTRAINT point_member_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: purchase purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT purchase_pkey PRIMARY KEY (id);


--
-- Name: restoran restoran_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restoran
    ADD CONSTRAINT restoran_pkey PRIMARY KEY (id);


--
-- Name: shift_kerja shift_kerja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift_kerja
    ADD CONSTRAINT shift_kerja_pkey PRIMARY KEY (id);


--
-- Name: stok_keluar stok_keluar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_keluar
    ADD CONSTRAINT stok_keluar_pkey PRIMARY KEY (id);


--
-- Name: stok_masuk stok_masuk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_masuk
    ADD CONSTRAINT stok_masuk_pkey PRIMARY KEY (id);


--
-- Name: supplier supplier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supplier
    ADD CONSTRAINT supplier_pkey PRIMARY KEY (id);


--
-- Name: target_penjualan target_penjualan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.target_penjualan
    ADD CONSTRAINT target_penjualan_pkey PRIMARY KEY (id);


--
-- Name: tenaga_kerja tenaga_kerja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenaga_kerja
    ADD CONSTRAINT tenaga_kerja_pkey PRIMARY KEY (id);


--
-- Name: test_connection test_connection_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.test_connection
    ADD CONSTRAINT test_connection_pkey PRIMARY KEY (id);


--
-- Name: transaksi transaksi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaksi
    ADD CONSTRAINT transaksi_pkey PRIMARY KEY (id);


--
-- Name: users uk_6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- Name: tenaga_kerja uk_6ollrtyns8uiagehh18gg6mv3; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenaga_kerja
    ADD CONSTRAINT uk_6ollrtyns8uiagehh18gg6mv3 UNIQUE (username);


--
-- Name: users uk_r43af9ap4edm43mmtq01oddj6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk_r43af9ap4edm43mmtq01oddj6 UNIQUE (username);


--
-- Name: categories uk_t8o6pivur7nn124jehx7cygw5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT uk_t8o6pivur7nn124jehx7cygw5 UNIQUE (name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: barang barang_jenis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.barang
    ADD CONSTRAINT barang_jenis_id_fkey FOREIGN KEY (jenis_id) REFERENCES public.jenis_barang(id);


--
-- Name: detail_transaksi detail_transaksi_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transaksi
    ADD CONSTRAINT detail_transaksi_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: detail_transaksi detail_transaksi_transaksi_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detail_transaksi
    ADD CONSTRAINT detail_transaksi_transaksi_id_fkey FOREIGN KEY (transaksi_id) REFERENCES public.transaksi(id);


--
-- Name: diskon diskon_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.diskon
    ADD CONSTRAINT diskon_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: orders fk32ql8ubntj5uh44ph9659tiih; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk32ql8ubntj5uh44ph9659tiih FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: purchase fk8omm6fki86s9oqk0o9s6w43h5; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase
    ADD CONSTRAINT fk8omm6fki86s9oqk0o9s6w43h5 FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: order_items fkbioxgbv59vetrxe0ejfubep1w; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fkbioxgbv59vetrxe0ejfubep1w FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items fkocimc7dtr037rh4ls4l95nlfi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fkocimc7dtr037rh4ls4l95nlfi FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products fkog2rp4qthbtt2lfyhfo32lsw9; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fkog2rp4qthbtt2lfyhfo32lsw9 FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: harga_beli harga_beli_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harga_beli
    ADD CONSTRAINT harga_beli_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: harga_beli harga_beli_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.harga_beli
    ADD CONSTRAINT harga_beli_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.supplier(id);


--
-- Name: keranjang keranjang_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keranjang
    ADD CONSTRAINT keranjang_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: keranjang keranjang_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keranjang
    ADD CONSTRAINT keranjang_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: point_member point_member_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_member
    ADD CONSTRAINT point_member_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: stok_keluar stok_keluar_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_keluar
    ADD CONSTRAINT stok_keluar_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: stok_masuk stok_masuk_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stok_masuk
    ADD CONSTRAINT stok_masuk_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: target_penjualan target_penjualan_barang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.target_penjualan
    ADD CONSTRAINT target_penjualan_barang_id_fkey FOREIGN KEY (barang_id) REFERENCES public.barang(id);


--
-- Name: tenaga_kerja tenaga_kerja_shift_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenaga_kerja
    ADD CONSTRAINT tenaga_kerja_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shift_kerja(id);


--
-- Name: transaksi transaksi_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaksi
    ADD CONSTRAINT transaksi_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- PostgreSQL database dump complete
--

