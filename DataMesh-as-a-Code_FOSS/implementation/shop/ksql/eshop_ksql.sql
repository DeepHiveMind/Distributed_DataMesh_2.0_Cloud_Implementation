-- Create eShop Content
--
-- docker exec -it ksqldb-cli ksql http://ksqldb-server-1:8088
--

-------------------------------------------------------------------------------
-- PERSON
-------------------------------------------------------------------------------

SET 'auto.offset.reset' = 'earliest';

drop table IF EXISTS aw_person_tab delete topic;
drop table IF EXISTS aw_address_tab delete topic;

drop stream IF EXISTS aw_cdc_order_stream;
drop stream IF EXISTS aw_cdc_person_stream;
drop stream IF EXISTS aw_cdc_address_stream;

-- Get Order, Person, Address Streams
CREATE OR REPLACE STREAM aw_cdc_order_stream
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='aw-cdc-order',
		  VALUE_FORMAT='AVRO');

CREATE OR REPLACE STREAM aw_cdc_orderitem_stream
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='aw-cdc-orderitem',
		  VALUE_FORMAT='AVRO');

CREATE OR REPLACE STREAM aw_cdc_person_stream
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='aw-cdc-person',
		  VALUE_FORMAT='AVRO');

CREATE OR REPLACE STREAM aw_cdc_address_stream
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='aw-cdc-address',
		  VALUE_FORMAT='AVRO');


-- Create Table for Person lookups
CREATE OR REPLACE TABLE aw_person_tab
	(ID VARCHAR PRIMARY KEY)
	WITH (KAFKA_TOPIC='aw-cdc-person',
		  VALUE_FORMAT='AVRO') 
/*		  
AS
	SELECT	ID,
			LATEST_BY_OFFSET(PERSONTYPE     ) AS PERSONTYPE,    
			LATEST_BY_OFFSET(NAMESTYLE      ) AS NAMESTYLE,     
			LATEST_BY_OFFSET(FIRSTNAME      ) AS FIRSTNAME,     
			LATEST_BY_OFFSET(MIDDLENAME     ) AS MIDDLENAME,    
			LATEST_BY_OFFSET(LASTNAME       ) AS LASTNAME,      
			LATEST_BY_OFFSET(PERSONID       ) AS PERSONID,      
			LATEST_BY_OFFSET(EVENTTIMESTAMP ) AS EVENTTIMESTAMP
	FROM	aw_cdc_person_stream
	GROUP BY ID;
*/

-- Create Table for Address lookups
CREATE OR REPLACE TABLE aw_address_tab
	(ID VARCHAR PRIMARY KEY)
	WITH (KAFKA_TOPIC='aw-cdc-address',
		  VALUE_FORMAT='AVRO');

/*
AS
	SELECT	ID,
			LATEST_BY_OFFSET(ADDRESSLINE1    ) AS ADDRESSLINE1,    
			LATEST_BY_OFFSET(CITY            ) AS CITY,            
			LATEST_BY_OFFSET(STATEPROVINCEID ) AS STATEPROVINCEID, 
			LATEST_BY_OFFSET(POSTALCODE      ) AS POSTALCODE,      
			LATEST_BY_OFFSET(PERSONID        ) AS PERSONID,        
			LATEST_BY_OFFSET(EVENTTIMESTAMP  ) AS EVENTTIMESTAMP 
	FROM	aw_cdc_address_stream
	GROUP BY ID;
*/
		  
-- Join order stream with person and address
/*
select	*
from	aw_cdc_order_stream o left join aw_person_tab p on (o.BUSINESSENTITYID = p.ID)
							  left join aw_address_tab ba on (o.BILLTOADDRESSID = ba.ID)
emit changes
limit 10;
*/



------------------------------
-- shop-user.state
------------------------------
drop stream IF EXISTS shop_user_state;

/*
CREATE OR REPLACE TAB shop_user_state
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='public.ecommerce.shop.shop-user.state.v1',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopUserState',
		  VALUE_FORMAT='AVRO',
		  value_schema_id=25,
		  partitions=8,
		  replicas=3)
*/

CREATE OR REPLACE STREAM shop_user_state
	WITH (KAFKA_TOPIC='public.ecommerce.shop.shop-user.state.ksql',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopUserState.ksql',
		  VALUE_FORMAT='AVRO',
		  partitions=8,
		  replicas=3)
	AS
	select  p.ID as ID,
			STRUCT(`eventId` := uuid(), `idempotenceId` := uuid(), `created` := FROM_UNIXTIME(UNIX_TIMESTAMP())) as `identity`,
			STRUCT(`profileId` := p.ID, `firstName` := p.firstname, `lastName` := p.lastname, `addresses` := array[
				STRUCT(`id` := CAST(o.BILLTOADDRESSID as BIGINT), `street` := ba.addressline1, `city` := ba.city, `zipCode` := ba.postalcode)
			]) as `user`,
			FROM_UNIXTIME(UNIX_TIMESTAMP()) as `when`
	from	aw_cdc_order_stream o inner join aw_person_tab p on (o.BUSINESSENTITYID = p.ID)
								  left join aw_address_tab ba on (o.BILLTOADDRESSID = ba.ID)
	partition by p.ID;

		  
------------------------------
-- search-performed.event
------------------------------
drop stream IF EXISTS search_performed_event;

/*
CREATE OR REPLACE STREAM search_performed_event
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='public.ecommerce.shop.search-performed.event.v1',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopSearchPerformedEvent',
		  VALUE_FORMAT='AVRO',
		  value_schema_id=23);
*/

CREATE OR REPLACE STREAM search_performed_event
	WITH (KAFKA_TOPIC='public.ecommerce.shop.search-performed.event.ksql',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopSearchPerformedEvent.ksql',
		  VALUE_FORMAT='AVRO',
		  partitions=8,
		  replicas=3)
	AS
	select	oi.ID as ID,
			STRUCT(`eventId` := uuid(), `idempotenceId` := uuid(), `created` := FROM_UNIXTIME(UNIX_TIMESTAMP())) as `identity`,
			o.BUSINESSENTITYID as `uniqueVisitorId`,
			FROM_UNIXTIME(UNIX_TIMESTAMP()) as `requestTimestamp`,
			oi.name as `searchTerm`
	FROM	AW_CDC_ORDERITEM_STREAM oi join aw_cdc_order_stream o WITHIN 1 minutes on (oi.orderid = o.orderid)
	PARTITION BY oi.ID;
		  
------------------------------
-- product-order-issued.event
------------------------------
/*
drop table AW_CDC_ORDERITEM_TAB;
create table AW_CDC_ORDERITEM_TAB
	WITH (KAFKA_TOPIC='aw-orderitem-tab',
		  VALUE_FORMAT='AVRO') AS
	SELECT	ID,
			LATEST_BY_OFFSET(DELAY_FROM_START_MS) AS DELAY_FROM_START_MS,
			LATEST_BY_OFFSET(TABLENAME          ) AS TABLENAME          ,
			LATEST_BY_OFFSET(PRODUCTID          ) AS PRODUCTID          ,
			LATEST_BY_OFFSET(NAME               ) AS NAME               ,
			LATEST_BY_OFFSET(PRODUCTNUMBER      ) AS PRODUCTNUMBER      ,
			LATEST_BY_OFFSET(MAKEFLAG           ) AS MAKEFLAG           ,
			LATEST_BY_OFFSET(FINISHEDGOODSFLAG  ) AS FINISHEDGOODSFLAG  ,
			LATEST_BY_OFFSET(COLOR              ) AS COLOR              ,
			LATEST_BY_OFFSET(SAFETYSTOCKLEVEL   ) AS SAFETYSTOCKLEVEL   ,
			LATEST_BY_OFFSET(REORDERPOINT       ) AS REORDERPOINT       ,
			LATEST_BY_OFFSET(STANDARDCOST       ) AS STANDARDCOST       ,
			LATEST_BY_OFFSET(LISTPRICE          ) AS LISTPRICE          ,
			LATEST_BY_OFFSET(DAYSTOMANUFACTURE  ) AS DAYSTOMANUFACTURE  ,
			LATEST_BY_OFFSET(SELLSTARTDATE      ) AS SELLSTARTDATE      ,
			LATEST_BY_OFFSET(ROWGUID            ) AS ROWGUID            ,
			LATEST_BY_OFFSET(MODIFIEDDATE       ) AS MODIFIEDDATE       ,
			LATEST_BY_OFFSET(ORDERID            ) AS ORDERID            ,
			LATEST_BY_OFFSET(EVENTTIMESTAMP     ) AS EVENTTIMESTAMP     
	FROM	AW_CDC_ORDERITEM_STREAM
	GROUP BY ID;
*/

drop stream IF EXISTS product_order_issued_persist delete topic;

/*
CREATE OR REPLACE STREAM product_order_issued_persist
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='public.ecommerce.shop.product-order-issued.event.v1',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopUserState.ksql',
		  value_schema_id=8,
		  VALUE_FORMAT='AVRO');
*/

		  
CREATE OR REPLACE STREAM product_order_issued_persist
	WITH (KAFKA_TOPIC='public.ecommerce.shop.product-order-issued.event.ksql',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.OrderIssued.ksql',
		  VALUE_FORMAT='AVRO',
		  partitions=8,
		  replicas=3) AS 
SELECT	o.ORDERID as OID,
		oi.ID as IID,
		o.BUSINESSENTITYID as `uniqueVisitorId`,
		FROM_UNIXTIME(UNIX_TIMESTAMP()) as `requestTimestamp`,
		o.ID as `transactionId`,
		oi.productnumber as partnumber,
		oi.Name as partname,
		oi.LISTPRICE as price
	FROM	AW_CDC_ORDERITEM_STREAM oi join aw_cdc_order_stream o WITHIN 1 minutes on (oi.orderid = o.orderid);
	  
		  
------------------------------
-- page-navigated.event
------------------------------
drop stream IF EXISTS page_navigated_event;

/*
CREATE OR REPLACE STREAM page_navigated_event
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='public.ecommerce.shop.page-navigated.event.v1',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopPageNavigatedEvent',
		  VALUE_FORMAT='AVRO',
		  value_schema_id=26);
*/

CREATE OR REPLACE STREAM page_navigated_event
	WITH (KAFKA_TOPIC='public.ecommerce.shop.page-navigated.event.ksql',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopPageNavigatedEvent.ksql',
		  VALUE_FORMAT='AVRO',
		  partitions=8,
		  replicas=3)
	AS
	-- (ID, `identity`, `uniqueVisitorId`, `page`, `requestTimestamp`, `referringUrl`)
	SELECT	oi.ID as ID,
			STRUCT(`eventId` := uuid(), `idempotenceId` := uuid(), `created` := FROM_UNIXTIME(UNIX_TIMESTAMP())) as `identity`,
			o.BUSINESSENTITYID as `uniqueVisitorId`,
			STRUCT(`id` := oi.PRODUCTNUMBER, `name` := concat('P_', oi.PRODUCTNUMBER), `skz` := '???', `url` := concat('https://eshop.com/product_detail/p?', oi.PRODUCTNUMBER), 
					`product` := STRUCT(`partNumber` := oi.PRODUCTNUMBER, `name` := oi.NAME, `price` := cast(oi.LISTPRICE as double))) as `page`,
			FROM_UNIXTIME(UNIX_TIMESTAMP()) as `requestTimestamp`,
			'https://eshop.com/product_search' as `referringUrl`
	FROM	AW_CDC_ORDERITEM_STREAM oi join aw_cdc_order_stream o WITHIN 1 minutes on (oi.orderid = o.orderid)
	PARTITION BY oi.ID;

		  
------------------------------
-- cart-action-occurred.event
------------------------------
drop stream IF EXISTS cart_action_occurred_event;
/*
CREATE OR REPLACE STREAM cart_action_occurred_event
	(ID STRING KEY)
	WITH (KAFKA_TOPIC='public.ecommerce.shop.cart-action-occurred.event.v1',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopCartActionOccurredEvent',
		  VALUE_FORMAT='AVRO',
		  value_schema_id=27);
*/

CREATE OR REPLACE STREAM cart_action_occurred_event
	WITH (KAFKA_TOPIC='public.ecommerce.shop.cart-action-occurred.event.ksql',
		  VALUE_AVRO_SCHEMA_FULL_NAME='com.trivadis.ecommerce.shop.avro.ShopCartActionOccurredEvent.ksql',
		  VALUE_FORMAT='AVRO',
		  partitions=8,
		  replicas=3) AS
	-- (ID, `identity`, `uniqueVisitorId`, `requestTimestamp`, `cartAction`, `partNumber`, `quantity`)
	SELECT	oi.ID as ID,
			STRUCT(`eventId` := uuid(), `idempotenceId` := uuid(), `created` := FROM_UNIXTIME(UNIX_TIMESTAMP())) as `identity`,
			o.BUSINESSENTITYID as `uniqueVisitorId`,
			FROM_UNIXTIME(UNIX_TIMESTAMP()) as `requestTimestamp`,
			'ADD_ITEM' as `cartAction`,
			oi.PRODUCTNUMBER as `partNumber`,
			1 as `quantity`
	FROM	AW_CDC_ORDERITEM_STREAM oi join aw_cdc_order_stream o WITHIN 1 minutes on (oi.orderid = o.orderid)
	PARTITION BY oi.ID;
	
	
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- 
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

DROP CONNECTOR IF EXISTS ora_ordersissued;

CREATE SINK CONNECTOR ora_ordersissued
   WITH("connector.class"='io.confluent.connect.jdbc.JdbcSinkConnector',
		"connection.url"='jdbc:oracle:thin:@oracledb-xe:1521:XE',
		"connection.user"='SHOP_PRIV',
		"connection.password"='shop_priv',
		"insert.mode"='insert',
		"table.name.format" = 'PRODUCTORDERISSUED',
		"topics" = 'public.ecommerce.shop.product-order-issued.event.ksql',
		"auto.create"=false,
		"pk.mode"='none');
