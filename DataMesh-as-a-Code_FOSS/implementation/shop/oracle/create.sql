-- USER SQL
CREATE USER SHOP_PRIV IDENTIFIED BY shop_priv;

-- QUOTAS
ALTER USER SHOP_PRIV QUOTA UNLIMITED ON USERS;

-- ROLES
GRANT "DBA" TO SHOP_PRIV ;
GRANT "CONNECT" TO SHOP_PRIV ;
GRANT "RESOURCE" TO SHOP_PRIV ;


-- USER SQL
CREATE USER CUSTOMER_PUB IDENTIFIED BY customer_pub;

-- QUOTAS
ALTER USER CUSTOMER_PUB QUOTA UNLIMITED ON USERS;

-- ROLES
GRANT "DBA" TO CUSTOMER_PUB ;
GRANT "CONNECT" TO CUSTOMER_PUB ;
GRANT "RESOURCE" TO CUSTOMER_PUB ;


---------------------------
drop table CUSTOMER_PUB.CUSTOMER;

create table CUSTOMER_PUB.CUSTOMER (
	"BusinessEntityID"    INTEGER     PRIMARY KEY,
    "FirstName"           VARCHAR(100),
    "LastName"            VARCHAR(100),
    "EventTimestamp"      NUMBER(38));
    
drop table CUSTOMER_PUB.ADDRESS;

create table CUSTOMER_PUB.ADDRESS (
    "AddressID"         INTEGER     PRIMARY KEY,
    "AddressLine1"      VARCHAR(200),
    "City"              VARCHAR(200),
    "PostalCode"        VARCHAR(50),
    "EventTimestamp"    NUMBER(38));
   
drop table CUSTOMER_PUB.CUST2ADDR;

create table CUSTOMER_PUB.CUST2ADDR (
    "BillToAddressID"   INTEGER,
    "businessEntityID"  INTEGER,
    "EventTimestamp"    NUMBER(38),
    CONSTRAINT CUST2ADDR_PK PRIMARY KEY ("BillToAddressID", "businessEntityID"));








drop table SHOP_PRIV.PRODUCTORDERISSUED;

-- SYSTEM PRIVILEGES
create table SHOP_PRIV.PRODUCTORDERISSUED (
	IID					varchar(254),
	"uniqueVisitorId" 	varchar2(40),
	"requestTimestamp" 	timestamp,
	"transactionId"		varchar2(40),
	partnumber			varchar2(50),
	partname			varchar2(1000),
	price				number);
    
create index SHOP_PRIV.I1 on SHOP_PRIV.PRODUCTORDERISSUED ("requestTimestamp");

create index SHOP_PRIV.I2 on SHOP_PRIV.PRODUCTORDERISSUED ("transactionId");
    
    
-- Format the output to a nested structure
create or replace view Shop_priv.V_PRODORDERISSUED as
select  "identity",
        "uniqueVisitorId",
        "requestTimestamp",
        "transactionId",
        "numberOfPositions",
        "items",
        "total",
        "requestTimestamp" INCCOL
from (  select  r.*,
                max (counter) over (partition by "transactionId") as countover
        from (  select  json_object('eventId' value sys_guid(), 'idempotenceId' value sys_guid(), 'created' value "requestTimestamp") as "identity",
                        "uniqueVisitorId",
                        "requestTimestamp",
                        "transactionId",
                        count(*) as "numberOfPositions",
                        json_arrayagg(json_object('product' value json_object('partNumber' value partnumber, 'name' value partname, 'price' value price))) as "items",
                        json_object('discountCoupon' value 'none', 'currency' value 'EUR', 'priceWithoutTax' value sum(price) / 1.19, 'total' value sum(price)) as "total",
                        count(*) counter
                from    SHOP_PRIV.PRODUCTORDERISSUED
                where   "requestTimestamp" < systimestamp - interval '10' second
                group by "uniqueVisitorId",
                        "requestTimestamp",
                        "transactionId") r)
where   counter = countover
order by "transactionId";
        
