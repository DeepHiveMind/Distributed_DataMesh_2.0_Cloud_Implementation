DROP TABLE IF EXISTS "ecomm_salesorder"."outbox";
CREATE TABLE "ecomm_salesorder"."outbox" (
    "id" uuid NOT NULL,
    "topic_key" bigint,
    "aggregate_id" bigint,
    "created_at" timestamp,
    "event_type" character varying(255),
    "event_key" bigint,
    "payload_avro" bytea,
    "payload_json" character varying(5000),
    CONSTRAINT "outbox_pkey" PRIMARY KEY ("id")
) WITH (oids = false);
