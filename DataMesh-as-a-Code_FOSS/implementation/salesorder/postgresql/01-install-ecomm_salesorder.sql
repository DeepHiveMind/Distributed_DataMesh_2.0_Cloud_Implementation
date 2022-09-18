DROP SCHEMA IF EXISTS ecomm_salesorder CASCADE;
CREATE SCHEMA ecomm_salesorder;
	
CREATE TABLE "ecomm_salesorder"."credit_card" (
	"salesorderid" bigint NOT NULL,
	"card_number" character varying(255),
	"card_type" character varying(255),
	"credit_card_approval_code" character varying(255),
	"exp_month" integer,
	"exp_year" integer,
	CONSTRAINT "credit_card_pkey" PRIMARY KEY ("salesorderid")
) WITH (oids = false);

CREATE TABLE "ecomm_salesorder"."sales_order_detail" (
	"salesorderid" bigint NOT NULL,
	"productid" bigint,
	"orderqty" integer,
	"specialofferid" bigint,
	"unit_price" double precision,
	"unitpricediscount" integer,
	"sales_order_salesorderid" bigint,
	CONSTRAINT "sales_order_detail_pkey" PRIMARY KEY ("salesorderid")
) WITH (oids = false);


CREATE TABLE "ecomm_salesorder"."sales_order_header" (
	"salesorderid" bigint NOT NULL,
	"account_number" character varying(255),
	"bill_to_address_id" bigint,
	"comment" character varying(255),
	"currency_rate_id" bigint,
	"customer_id" bigint,
	"due_date" timestamp,
	"freight" double precision,
	"online_channel" boolean,
	"order_date" timestamp,
	"purchase_order_number" character varying(255),
	"revision_number" integer,
	"sales_person_id" bigint,
	"ship_date" timestamp,
	"ship_method_id" bigint,
	"ship_to_address_id" bigint,
	"status" integer,
	"sub_total" double precision,
	"tax_amount" double precision,
	"territory_id" bigint,
	"total_due" double precision,
	"credit_card_salesorderid" bigint NOT NULL,
	CONSTRAINT "sales_order_header_pkey" PRIMARY KEY ("salesorderid")
) WITH (oids = false);


CREATE TABLE "ecomm_salesorder".sales_person(
	sales_person_id INT NOT NULL,
	territory_id INT NULL,
	sales_quota numeric NULL, -- money
	bonus numeric NOT NULL CONSTRAINT "DF_SalesPerson_Bonus" DEFAULT (0.00), -- money
	commission_pct numeric NOT NULL CONSTRAINT "DF_SalesPerson_CommissionPct" DEFAULT (0.00), -- smallmoney -- money
	sales_ytd numeric NOT NULL CONSTRAINT "DF_SalesPerson_SalesYTD" DEFAULT (0.00), -- money
	sales_last_year numeric NOT NULL CONSTRAINT "DF_SalesPerson_SalesLastYear" DEFAULT (0.00), -- money
	CONSTRAINT "CK_SalesPerson_SalesQuota" CHECK (sales_quota >= 0.00),
	CONSTRAINT "CK_SalesPerson_Bonus" CHECK (bonus >= 0.00),
	CONSTRAINT "CK_SalesPerson_CommissionPct" CHECK (commission_pct >= 0.00),
	CONSTRAINT "CK_SalesPerson_SalesYTD" CHECK (sales_ytd >= 0.00),
	CONSTRAINT "CK_SalesPerson_SalesLastYear" CHECK (sales_last_year >= 0.00)
  );


CREATE TABLE "ecomm_salesorder".sales_territory (
	territory_id SERIAL NOT NULL, -- int
	name varchar(50) NOT NULL,
	country_region_code varchar(3) NOT NULL,
	group_name varchar(50) NOT NULL, -- Group
	sales_ytd numeric NOT NULL CONSTRAINT "DF_SalesTerritory_SalesYTD" DEFAULT (0.00), -- money
	sales_last_year numeric NOT NULL CONSTRAINT "DF_SalesTerritory_SalesLastYear" DEFAULT (0.00), -- money
	cost_ytd numeric NOT NULL CONSTRAINT "DF_SalesTerritory_CostYTD" DEFAULT (0.00), -- money
	cost_last_year numeric NOT NULL CONSTRAINT "DF_SalesTerritory_CostLastYear" DEFAULT (0.00), -- money
	CONSTRAINT "CK_SalesTerritory_SalesYTD" CHECK (sales_ytd >= 0.00),
	CONSTRAINT "CK_SalesTerritory_SalesLastYear" CHECK (sales_last_year >= 0.00),
	CONSTRAINT "CK_SalesTerritory_CostYTD" CHECK (cost_ytd >= 0.00),
	CONSTRAINT "CK_SalesTerritory_CostLastYear" CHECK (cost_last_year >= 0.00)
  );


CREATE TABLE "ecomm_salesorder".special_offer(
	special_offer_id SERIAL NOT NULL, -- int
	description varchar(255) NOT NULL,
	discount_pct numeric NOT NULL CONSTRAINT "DF_SpecialOffer_DiscountPct" DEFAULT (0.00), -- smallmoney -- money
	type varchar(50) NOT NULL,
	category varchar(50) NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP NOT NULL,
	min_qty INT NOT NULL CONSTRAINT "DF_SpecialOffer_MinQty" DEFAULT (0),
	max_qty INT NULL,
	CONSTRAINT "CK_SpecialOffer_EndDate" CHECK (end_date >= start_date),
	CONSTRAINT "CK_SpecialOffer_DiscountPct" CHECK (discount_pct >= 0.00),
	CONSTRAINT "CK_SpecialOffer_MinQty" CHECK (min_qty >= 0),
	CONSTRAINT "CK_SpecialOffer_MaxQty"  CHECK (max_qty >= 0)
  );

CREATE TABLE "ecomm_salesorder".special_offer_product (
	special_offer_iD INT NOT NULL,
	product_id INT NOT NULL
);


