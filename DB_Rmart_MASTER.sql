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

--
-- Name: payment_method_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_method_type AS ENUM (
    'bank_transfer',
    'credit_card',
    'ewallet',
    'cod'
);


ALTER TYPE public.payment_method_type OWNER TO postgres;

--
-- Name: payment_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status_type AS ENUM (
    'pending',
    'paid',
    'failed',
    'refunded'
);


ALTER TYPE public.payment_status_type OWNER TO postgres;

--
-- Name: transaction_status_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transaction_status_type AS ENUM (
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
    'completed'
);


ALTER TYPE public.transaction_status_type OWNER TO postgres;

--
-- Name: user_role_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role_type AS ENUM (
    'admin',
    'customer'
);


ALTER TYPE public.user_role_type OWNER TO postgres;

--
-- Name: update_poin_customer(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_poin_customer() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Tambah poin ke customer berdasarkan total_harga (misal: 1 poin per Rp1000)
    UPDATE customer
    SET poin = poin + NEW.poin_diperoleh
    WHERE id = NEW.customer_id;
    
    -- Kurangi poin jika poin digunakan dalam transaksi
    IF NEW.poin_digunakan > 0 THEN
        UPDATE customer
        SET poin = poin - NEW.poin_digunakan
        WHERE id = NEW.customer_id;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_poin_customer() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    user_id bigint,
    name character varying(255),
    phone character varying(20),
    street text,
    city character varying(100),
    province character varying(100),
    postal_code character varying(10),
    is_default boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO postgres;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    nama character varying(100),
    email character varying(100)
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
    nama_barang character varying(100) NOT NULL,
    jenis_id integer,
    harga_jual numeric(10,2),
    stok integer,
    gambar character varying(255),
    gambar_url text
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
-- Name: cart_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_items (
    id bigint NOT NULL,
    cart_id bigint,
    product_id bigint,
    quantity integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT cart_items_quantity_check CHECK ((quantity > 0))
);


ALTER TABLE public.cart_items OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cart_items_id_seq OWNER TO postgres;

--
-- Name: cart_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_items_id_seq OWNED BY public.cart_items.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    id bigint NOT NULL,
    user_id bigint,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.carts_id_seq OWNER TO postgres;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: jenis_barang; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jenis_barang (
    id integer NOT NULL,
    nama_jenis character varying(50) NOT NULL,
    image character varying(255),
    icon_color character varying(7),
    icon character varying(100)
);


ALTER TABLE public.jenis_barang OWNER TO postgres;

--
-- Name: categories; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.categories AS
 SELECT j.id,
    j.nama_jenis AS name,
    'default_category.jpg'::text AS image,
    '#007bff'::text AS icon_color,
    NULL::text AS parent_id,
    now() AS created_at
   FROM public.jenis_barang j;


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories_backup (
    id bigint,
    name character varying(100),
    image character varying(500),
    icon_color character varying(7),
    parent_id bigint,
    created_at timestamp without time zone
);


ALTER TABLE public.categories_backup OWNER TO postgres;

--
-- Name: coupons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupons (
    id bigint NOT NULL,
    code character varying(20),
    discount_type character varying(10),
    discount_value numeric(10,2),
    valid_from timestamp without time zone,
    valid_to timestamp without time zone,
    usage_limit integer,
    used_count integer DEFAULT 0,
    CONSTRAINT coupons_discount_type_check CHECK (((discount_type)::text = ANY ((ARRAY['percent'::character varying, 'fixed'::character varying])::text[])))
);


ALTER TABLE public.coupons OWNER TO postgres;

--
-- Name: coupons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupons_id_seq OWNER TO postgres;

--
-- Name: coupons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupons_id_seq OWNED BY public.coupons.id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    id integer NOT NULL,
    nama character varying(100),
    email character varying(100),
    is_member boolean,
    poin integer DEFAULT 0
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
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint,
    product_id bigint,
    quantity integer,
    price numeric(15,2),
    subtotal numeric(15,2) GENERATED ALWAYS AS (((quantity)::numeric * price)) STORED,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT order_items_price_check CHECK ((price >= (0)::numeric)),
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0))
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
    user_id bigint,
    total_amount numeric(15,2) NOT NULL,
    shipping_cost numeric(12,2) DEFAULT 0,
    status public.transaction_status_type DEFAULT 'pending'::public.transaction_status_type,
    shipping_address_id bigint,
    shipping_address text,
    phone_number character varying(20),
    notes text,
    payment_method public.payment_method_type,
    payment_status public.payment_status_type DEFAULT 'pending'::public.payment_status_type,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
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
-- Name: product_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_images (
    id bigint NOT NULL,
    product_id bigint,
    url character varying(500),
    is_primary boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.product_images OWNER TO postgres;

--
-- Name: product_images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_images_id_seq OWNER TO postgres;

--
-- Name: product_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_images_id_seq OWNED BY public.product_images.id;


--
-- Name: products; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.products AS
 SELECT b.id,
    b.nama_barang AS name,
    b.harga_jual AS price,
    b.harga_jual AS original_price,
    0 AS discount,
    b.stok AS stock,
    0 AS sold,
    4.5 AS rating,
    'Produk berkualitas'::text AS description,
    b.gambar AS image,
    b.jenis_id AS category_id,
    now() AS created_at,
    now() AS updated_at
   FROM public.barang b;


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    product_id bigint,
    user_id bigint,
    rating numeric(2,1),
    comment text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT reviews_rating_check CHECK (((rating >= (1)::numeric) AND (rating <= (5)::numeric)))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reviews_id_seq OWNER TO postgres;

--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


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
    shift_id integer
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
-- Name: transaksi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaksi (
    id integer NOT NULL,
    customer_id integer,
    tanggal date,
    total_harga numeric(10,2),
    poin_digunakan integer DEFAULT 0,
    poin_diperoleh integer DEFAULT 0
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
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    avatar character varying(500),
    phone character varying(20),
    marital_status character varying(20),
    birth_date date,
    gender character varying(10),
    profile_image character varying(500),
    role character varying(20) DEFAULT 'customer'::public.user_role_type,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    active boolean DEFAULT true,
    full_name character varying(255),
    last_login timestamp without time zone,
    username character varying(255)
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
-- Name: wishlists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wishlists (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.wishlists OWNER TO postgres;

--
-- Name: wishlists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wishlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wishlists_id_seq OWNER TO postgres;

--
-- Name: wishlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wishlists_id_seq OWNED BY public.wishlists.id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: barang id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.barang ALTER COLUMN id SET DEFAULT nextval('public.barang_id_seq'::regclass);


--
-- Name: cart_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items ALTER COLUMN id SET DEFAULT nextval('public.cart_items_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: coupons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons ALTER COLUMN id SET DEFAULT nextval('public.coupons_id_seq'::regclass);


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
-- Name: product_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images ALTER COLUMN id SET DEFAULT nextval('public.product_images_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


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
-- Name: transaksi id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaksi ALTER COLUMN id SET DEFAULT nextval('public.transaksi_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: wishlists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists ALTER COLUMN id SET DEFAULT nextval('public.wishlists_id_seq'::regclass);


--
-- Name: 106967; Type: BLOB; Schema: -; Owner: user
--

SELECT pg_catalog.lo_create('106967');


ALTER LARGE OBJECT 106967 OWNER TO "user";

--
-- Name: 106968; Type: BLOB; Schema: -; Owner: user
--

SELECT pg_catalog.lo_create('106968');


ALTER LARGE OBJECT 106968 OWNER TO "user";

--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (id, user_id, name, phone, street, city, province, postal_code, is_default, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, nama, email) FROM stdin;
1	Admin1	admin1@mail.com
\.


--
-- Data for Name: barang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.barang (id, nama_barang, jenis_id, harga_jual, stok, gambar, gambar_url) FROM stdin;
1	Aqua Botol 600ml	1	4000.00	100	aqua_600ml.jpg	\N
2	Indomie Goreng	2	3000.00	200	indomie_goreng.jpg	\N
3	Rinso 1kg	4	18000.00	50	rinso_1kg.jpg	\N
4	Shampoo Lifebuoy	3	15000.00	70	lifebuoy_shampoo.jpg	\N
5	Test Product Baru	6	25000.00	10	https://example.com/image.jpg	\N
6	Test Product Final	6	20000.00	8	https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400	\N
7	Test Product Long URL	6	25000.00	10	https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80	\N
8	Produk Test Final dengan Nama yang Sangat Panjang untuk Testing Database Column Length	6	30000.00	15	https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80&very=long&url=parameter	\N
9	106968	6	35000.00	8	106967	\N
14	Aqua Botol 600ml	6	4000.00	100	aqua_600ml.jpg	aqua_600ml.jpg
15	Indomie Goreng	5	3000.00	200	indomie_goreng.jpg	indomie_goreng.jpg
16	Rinso 1kg	4	18000.00	50	rinso_1kg.jpg	rinso_1kg.jpg
17	Shampoo Lifebuoy	3	15000.00	70	lifebuoy_shampoo.jpg	lifebuoy_shampoo.jpg
\.


--
-- Data for Name: cart_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_items (id, cart_id, product_id, quantity, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: categories_backup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories_backup (id, name, image, icon_color, parent_id, created_at) FROM stdin;
1	Kebutuhan Dapur	https://cdn-icons-png.flaticon.com/512/3595/3595455.png	#FF6B35	\N	2025-07-29 17:36:02.081809
2	Kebutuhan Ibu & Anak	https://cdn-icons-png.flaticon.com/512/2917/2917995.png	#FF69B4	\N	2025-07-29 17:36:02.081809
3	Kebutuhan Rumah	https://cdn-icons-png.flaticon.com/512/1946/1946488.png	#4CAF50	\N	2025-07-29 17:36:02.081809
4	Makanan	https://cdn-icons-png.flaticon.com/512/1046/1046784.png	#FFA726	\N	2025-07-29 17:36:02.081809
5	Minuman	https://cdn-icons-png.flaticon.com/512/924/924514.png	#42A5F5	\N	2025-07-29 17:36:02.081809
6	Produk Segar & Beku	https://cdn-icons-png.flaticon.com/512/2515/2515183.png	#66BB6A	\N	2025-07-29 17:36:02.081809
7	Personal Care	https://cdn-icons-png.flaticon.com/512/3004/3004458.png	#AB47BC	\N	2025-07-29 17:36:02.081809
8	Kebutuhan Kesehatan	https://cdn-icons-png.flaticon.com/512/2382/2382533.png	#EF5350	\N	2025-07-29 17:36:02.081809
9	Lifestyle	https://cdn-icons-png.flaticon.com/512/3176/3176366.png	#26C6DA	\N	2025-07-29 17:36:02.081809
10	Pet Foods	https://cdn-icons-png.flaticon.com/512/2138/2138440.png	#8D6E63	\N	2025-07-29 17:36:02.081809
\.


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupons (id, code, discount_type, discount_value, valid_from, valid_to, usage_limit, used_count) FROM stdin;
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (id, nama, email, is_member, poin) FROM stdin;
1	Budi	budi@mail.com	t	120
2	Budi	budi@mail.com	t	120
\.


--
-- Data for Name: detail_transaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detail_transaksi (id, transaksi_id, barang_id, jumlah, subtotal) FROM stdin;
1	1	1	1	4000.00
2	1	2	2	6000.00
\.


--
-- Data for Name: diskon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.diskon (id, barang_id, persentase, tanggal_mulai, tanggal_akhir) FROM stdin;
1	2	10.00	2025-05-10	2025-05-20
\.


--
-- Data for Name: harga_beli; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.harga_beli (id, barang_id, supplier_id, harga, tanggal) FROM stdin;
1	1	1	3000.00	2025-05-01
2	2	1	2000.00	2025-05-01
\.


--
-- Data for Name: jenis_barang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jenis_barang (id, nama_jenis, image, icon_color, icon) FROM stdin;
7	Minuman	https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400	#42A5F5	🥤
8	Produk Segar & Beku	https://images.unsplash.com/photo-1542838132-92c53300491e?w=400	#66BB6A	🥬
9	Kebutuhan Kesehatan	https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400	#EF5350	💊
10	Lifestyle	https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400	#5C6BC0	✨
11	Pet Foods	https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400	#8D6E63	🐕
12	Kebutuhan Dapur	https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400	#FF6B35	🍳
13	Kebutuhan Ibu & Anak	https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400	#FF69B4	👶
14	Personal Care	https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400	#AB47BC	🧴
15	Kebutuhan Rumah	https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400	#4CAF50	🏠
16	Makanan	https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400	#FFA726	🍽️
17	Minuman	https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400	#42A5F5	🥤
18	Produk Segar & Beku	https://images.unsplash.com/photo-1542838132-92c53300491e?w=400	#66BB6A	🥬
19	Kebutuhan Kesehatan	https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400	#EF5350	💊
20	Lifestyle	https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400	#5C6BC0	✨
21	Pet Foods	https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400	#8D6E63	🐕
1	Kebutuhan Dapur	https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400	#FF6B35	🍳
2	Kebutuhan Ibu & Anak	https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400	#FF69B4	👶
3	Personal Care	https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400	#AB47BC	🧴
4	Kebutuhan Rumah	https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400	#4CAF50	🏠
5	Makanan	https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400	#FFA726	🍽️
6	Minuman	https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400	#42A5F5	🥤
\.


--
-- Data for Name: keranjang; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keranjang (id, customer_id, barang_id, jumlah) FROM stdin;
1	1	2	3
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, price, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, user_id, total_amount, shipping_cost, status, shipping_address_id, shipping_address, phone_number, notes, payment_method, payment_status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: point_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point_member (id, customer_id, total_point) FROM stdin;
1	1	120
\.


--
-- Data for Name: product_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_images (id, product_id, url, is_primary, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (id, product_id, user_id, rating, comment, created_at, updated_at) FROM stdin;
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
1	2	20	2025-05-06
\.


--
-- Data for Name: stok_masuk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stok_masuk (id, barang_id, jumlah, tanggal) FROM stdin;
1	1	50	2025-05-05
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
1	1	5	2025	500
\.


--
-- Data for Name: tenaga_kerja; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenaga_kerja (id, nama, shift_id) FROM stdin;
1	Andi	1
\.


--
-- Data for Name: transaksi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaksi (id, customer_id, tanggal, total_harga, poin_digunakan, poin_diperoleh) FROM stdin;
1	1	2025-05-21	10000.00	0	10
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, password, avatar, phone, marital_status, birth_date, gender, profile_image, role, created_at, updated_at, active, full_name, last_login, username) FROM stdin;
1	Test User	testuser@example.com	password123	\N	\N	\N	\N	\N	\N	customer	2025-07-29 20:16:05.862434	2025-07-29 20:16:05.862434	t	\N	\N	\N
2	rezki	rezki@mail.com	1234	\N	\N	\N	\N	\N	\N	customer	2025-07-29 20:19:38.910168	2025-07-29 20:19:38.910168	t	\N	\N	\N
3	New Test User	newuser@example.com	$2a$10$w6ir3kF.LtG/veQ5cb05AOC5ZpdO2sTgFQ/IHKA1R.XUl8c4Ihr9q	\N	\N	\N	\N	\N	\N	customer	2025-07-29 20:25:54.912638	2025-07-29 20:25:54.912638	t	\N	\N	\N
6	Customer User	customer@example.com	customer123	\N	\N	\N	\N	\N	\N	customer	2025-07-29 20:46:15.14216	2025-07-29 20:46:15.14216	t	\N	\N	\N
7	New User Test	newuser@test.com	$2a$10$T5MSwkl2HH/fdKcN12mgHe2SIe5x0zZtN/N9rayhU07SoooSTFHxq	\N	\N	\N	\N	\N	\N	customer	2025-07-29 20:57:11.081148	2025-07-29 20:57:11.08131	t	\N	\N	\N
40	Test User	test@example.com	$2a$10$oVy0jWtMwGia.5mEjBh52Ol4MP64c.4QKXCQQyF3eZHgLLB0WeM6i	\N	\N	\N	\N	\N	\N	customer	2025-08-04 13:20:05.689582	2025-08-04 13:20:05.689599	t	\N	\N	\N
41	Brand New User	brandnew@example.com	$2a$10$cKVgJDYICLGerKr9cgh2m.VcEwQpwtlUKeESpzAcsg1Q2r3O3oYta	\N	\N	\N	\N	\N	\N	customer	2025-08-04 13:20:37.811814	2025-08-04 13:20:37.811828	t	\N	\N	\N
42	Test Registration Fix	testfix@example.com	$2a$10$w6tKMJbQF1bxqGYQ28xmke5rgdRn5XA5Wr0BbauyWIgeyqNoVf.i.	\N	\N	\N	\N	\N	\N	customer	2025-08-04 13:25:37.720003	2025-08-04 13:25:37.72002	t	\N	\N	\N
43	Test User 1754285179	user1754285179@example.com	$2a$10$AVHukpDfsHrXmUesAUF5h.6153pxx7PfzVsheB60xeC/TX7cKV7F6	\N	\N	\N	\N	\N	\N	customer	2025-08-04 13:26:19.655575	2025-08-04 13:26:19.65559	t	\N	\N	\N
44	rezki	rezki@gmail.com	$2a$10$5pdd5mxuixp3zcLdJUZ2zuE04KyhQZJDMJy27xVDOiCxG8rB0c0xe	\N	\N	\N	\N	\N	\N	customer	2025-08-04 13:29:25.188091	2025-08-04 13:29:25.188109	t	\N	\N	\N
5	Admin User	admin@rmart.com	admin123	\N	\N	\N	\N	\N	\N	admin	2025-07-29 20:40:00.244592	2025-08-10 15:01:53.50223	t	\N	\N	\N
\.


--
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wishlists (id, user_id, product_id, created_at) FROM stdin;
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 1, false);


--
-- Name: barang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.barang_id_seq', 17, true);


--
-- Name: cart_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_items_id_seq', 1, false);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.carts_id_seq', 1, false);


--
-- Name: coupons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupons_id_seq', 1, false);


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
-- Name: harga_beli_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.harga_beli_id_seq', 1, false);


--
-- Name: jenis_barang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jenis_barang_id_seq', 21, true);


--
-- Name: keranjang_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.keranjang_id_seq', 1, false);


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
-- Name: product_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_images_id_seq', 1, false);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


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
-- Name: transaksi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaksi_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 45, true);


--
-- Name: wishlists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wishlists_id_seq', 1, false);


--
-- Data for Name: BLOBS; Type: BLOBS; Schema: -; Owner: -
--

BEGIN;

SELECT pg_catalog.lo_open('106967', 131072);
SELECT pg_catalog.lowrite(0, '\x646174613a696d6167652f6a7065673b6261736536342c2f396a2f34414151536b5a4a5267414241514141415141424141442f3277424441415945425159464241594742515948427759494368414b43676b4a4368514f44777751467851594742635546685961485355664768736a48425957494377674979596e4b536f70475238744d43306f4d43556f4b536a2f327742444151634842776f4943684d4b43684d6f476859614b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b43676f4b436a2f7741415243414142414145444153494141684542417845422f3851414651414241514141414141414141414141414141414141414141762f784141554541454141414141414141414141414141414141414141412f3851414651454241514141414141414141414141414141414141414141582f784141554551454141414141414141414141414141414141414141412f396f4144414d4241414952417845415077436441426d582f396b3d');
SELECT pg_catalog.lo_close(0);

SELECT pg_catalog.lo_open('106968', 131072);
SELECT pg_catalog.lowrite(0, '\x546573742050726f647563742064656e67616e204e616d612053616e6761742050616e6a616e6720756e74756b2054657374696e672044617461626173652064616e2042617365363420496d61676520537570706f7274');
SELECT pg_catalog.lo_close(0);

COMMIT;

--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


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
-- Name: cart_items cart_items_cart_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_cart_id_product_id_key UNIQUE (cart_id, product_id);


--
-- Name: cart_items cart_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: carts carts_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_key UNIQUE (user_id);


--
-- Name: coupons coupons_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_code_key UNIQUE (code);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


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
-- Name: product_images product_images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_images
    ADD CONSTRAINT product_images_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


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
-- Name: transaksi transaksi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaksi
    ADD CONSTRAINT transaksi_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- Name: wishlists wishlists_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- Name: addresses trg_addresses_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_addresses_updated_at BEFORE UPDATE ON public.addresses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: cart_items trg_cart_items_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_cart_items_updated_at BEFORE UPDATE ON public.cart_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: carts trg_carts_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_carts_updated_at BEFORE UPDATE ON public.carts FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: order_items trg_order_items_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_order_items_updated_at BEFORE UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: orders trg_orders_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_orders_updated_at BEFORE UPDATE ON public.orders FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: product_images trg_product_images_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_product_images_updated_at BEFORE UPDATE ON public.product_images FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: reviews trg_reviews_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_reviews_updated_at BEFORE UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: transaksi trigger_update_poin; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_poin AFTER INSERT ON public.transaksi FOR EACH ROW EXECUTE FUNCTION public.update_poin_customer();


--
-- Name: addresses addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: barang barang_jenis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.barang
    ADD CONSTRAINT barang_jenis_id_fkey FOREIGN KEY (jenis_id) REFERENCES public.jenis_barang(id);


--
-- Name: cart_items cart_items_cart_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_items
    ADD CONSTRAINT cart_items_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES public.carts(id) ON DELETE CASCADE;


--
-- Name: carts carts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_shipping_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_shipping_address_id_fkey FOREIGN KEY (shipping_address_id) REFERENCES public.addresses(id) ON DELETE SET NULL;


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: point_member point_member_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_member
    ADD CONSTRAINT point_member_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(id);


--
-- Name: reviews reviews_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: wishlists wishlists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

