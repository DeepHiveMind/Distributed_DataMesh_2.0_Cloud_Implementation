Table "credit_card" {
  "salesorderid" bigint [pk, not null]
  "card_number" "character varying(255)"
  "card_type" "character varying(255)"
  "credit_card_approval_code" "character varying(255)"
  "exp_month" integer
  "exp_year" integer
}

Table "outbox" {
  "uuid" uuid [pk, not null]
  "aggregate_id" bigint
  "created_on" timestamp
  "event_type" "character varying(255)"
  "payload" "character varying(4000)"
}

Table "sales_order_detail" {
  "salesorderid" bigint [pk, not null]
  "productid" bigint
  "orderqty" integer
  "specialofferid" bigint
  "unit_price" double
  "unitpricediscount" integer
  "sales_order_salesorderid" bigint
}

Table "sales_order_header" {
  "salesorderid" bigint [pk, not null]
  "account_number" "character varying(255)"
  "bill_to_address_id" bigint
  "comment" "character varying(255)"
  "currency_rate_id" bigint
  "customer_id" bigint
  "due_date" timestamp
  "freight" double
  "online_channel" boolean
  "order_date" timestamp
  "purchase_order_number" "character varying(255)"
  "revision_number" integer
  "sales_person_id" bigint
  "ship_date" timestamp
  "ship_method_id" bigint
  "ship_to_address_id" bigint
  "status" integer
  "sub_total" double
  "tax_amount" double
  "territory_id" bigint
  "total_due" double
  "credit_card_salesorderid" bigint [not null]
}

Table "sales_person" {
  "sales_person_id" INT [not null]
  "territory_id" INT
  "sales_quota" numeric
  "bonus" numeric [not null, default: `0.00`]
  "commission_pct" numeric [not null, default: `0.00`]
  "sales_ytd" numeric [not null, default: `0.00`]
  "sales_last_year" numeric [not null, default: `0.00`]
}

Table "sales_territory" {
  "territory_id" int [not null, increment]
  "name" varchar(50) [not null]
  "country_region_code" varchar(3) [not null]
  "group_name" varchar(50) [not null]
  "sales_ytd" numeric [not null, default: `0.00`]
  "sales_last_year" numeric [not null, default: `0.00`]
  "cost_ytd" numeric [not null, default: `0.00`]
  "cost_last_year" numeric [not null, default: `0.00`]
}

Table "special_offer" {
  "special_offer_id" int [not null, increment]
  "description" varchar(255) [not null]
  "discount_pct" numeric [not null, default: `0.00`]
  "type" varchar(50) [not null]
  "category" varchar(50) [not null]
  "start_date" timestamp [not null]
  "end_date" timestamp [not null]
  "min_qty" INT [not null, default: `0`]
  "max_qty" INT
}

Table "special_offer_product" {
  "special_offer_iD" INT [not null]
  "product_id" INT [not null]
}


Ref: "sales_order_header"."salesorderid" < "sales_order_detail"."salesorderid"



Ref: "credit_card"."salesorderid" < "sales_order_header"."salesorderid"



Ref: "sales_person"."sales_person_id" < "sales_order_header"."sales_person_id"

Ref: "sales_territory"."territory_id" < "sales_person"."territory_id"

Ref: "special_offer"."special_offer_id" < "special_offer_product"."special_offer_iD"

Ref: "special_offer_product"."special_offer_iD" < "sales_order_detail"."specialofferid"