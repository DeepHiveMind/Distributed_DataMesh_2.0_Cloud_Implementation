# Customer Subdomain - Customer Data Product

## Data Product Canvas

For the Customer Data Product the following canvas has been defined

![Customer Domain](./../images/customer-dp.png)

## Exposed Ports
 
 * Kafka 
   * `pub.ecomm.customer.customer.state.v1` - a log compacted topic (keyed by `customerId`
   * `pub.ecomm.customer.address-changed.event.v1` - an event topic with each change of an address for a data retention of 1 week
 * Object Storage
   * `pub.ecomm.customer.bucket`  
 * Trino
   * `pub_ecomm_customer` 

## Implementation

The following diagram shows the internal working of the Customer Domain with the Customer Data Product:

![](../images/customer-customer-dp-impl.png)


## (1) Initialise static data

The following StreamSets Pipelines are handling the initialisation of some static data at simulation time zero.

 * **customer_init** - Initialises the static datasets

The data for the init has to be provided in `data-transfer/data-mesh-poc/simulator/customer/init`

## (2) Simulator

The following StreamSets Pipelines are simulating the data

 * **customer_simulate-person-and-address** - simulate Person and Address inserts and updates

The data for the simulator has to be provided in `data-transfer/data-mesh-poc/simulator/customer`.

`person_obj_events.csv`

```bash
descriminator,delay_from_start_ms,person
Person,191,'{"businessEntityId":2970,"personType":"IN","nameStyle":false,"firstName":"Katherine","middleName":"E","lastName":"Patterson","emailPromotion":0,"addresses":[{"id":11992,"addressTypeId":2,"addressLine1":"7306 Pastime Drive","city":"Long Beach","stateProvinceId":9,"postalCode":"90802"}],"emailAddresses":[{"id":2165,"emailAddress":"katherine36@adventure-works.com"}],"phones":[{"phoneNumber":"670-555-0187","phoneNumberTypeId":2}]}'
Person,381,'{"businessEntityId":4068,"personType":"IN","nameStyle":false,"firstName":"Cedric","middleName":"J","lastName":"Chande","emailPromotion":2,"addresses":[{"id":13102,"addressTypeId":2,"addressLine1":"70, rue de l´Esplanade","city":"Tremblay-en-France","stateProvinceId":179,"postalCode":"93290"}],"emailAddresses":[{"id":3263,"emailAddress":"cedric33@adventure-works.com"}],"phones":[{"phoneNumber":"1 (11) 500 555-0147","phoneNumberTypeId":1}]}'
...
```

## (3) Customer Management Service

The Customer Management Service is implemented as a Microservice using Spring Boot.

### REST API

The RESTAPI is deployed on <http://dataplatform:48080>

A `POST` on `/api/customers` with a JSON document similar to the one below will add a new Person with addresses, emails and phones:

```json
{
  "businessEntityId" : 20036,
  "personType" : "IN",
  "nameStyle" : false,
  "firstName" : "Destiny",
  "lastName" : "Ward",
  "emailPromotion" : 1,
  "addresses" : [ {
    "id" : 29138,
    "addressTypeId": 1,
    "addressLine1" : "3935 Hawkins Street",
    "city" : "Langford",
    "stateProvinceId" : 7,
    "postalCode" : "V9"
  } ],
  "emailAddresses" : [ {
    "id" : 19231,
    "emailAddress" : "destiny38@adventure-works.com"
  } ],
  "phones" : [ {
    "phoneNumber" : "141-555-0193",
    "phoneNumberTypeId" : 1
  } ]
}
```

### Data Model for Customer Domain

The internal Data Model of the Customer operational system is shown in the diagram below.

![](../images/customer-dbmodel-priv.png)

It runs on Oracle in the schema `ecomm_customer`.

### Persistence

The persistence mapping of the domain object to the legacy data model is done using JDBC Template with a set of Insert statements. This is done because JPA mapping is not doable due to the mismatch between the traditional database model and the domain object model.

`PersonRepositoryImpl.java`

```java
    public void save (PersonDO customer) {
        System.out.println(customer);

        // Insert into PERSON_T
        jdbcTemplate.update("INSERT INTO person_t (business_entity_id, person_type, name_style, first_name, middle_name, last_name, email_promotion, created_date, modified_date) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)"
                        , customer.getBusinessEntityId(), customer.getPersonType(), customer.getNameStyle(), customer.getFirstName(), customer.getMiddleName(), customer.getLastName(), customer.getEmailPromotion()
                    );
        for (AddressDO address : customer.getAddresses()) {
            // Insert into ADDRESS_T
            jdbcTemplate.update("INSERT INTO address_t (address_id, address_line_1, address_line_2, city, state_province_id, postal_code, created_date, modified_date) " +
                                "VALUES (?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)"
                    , address.getAddressId(), address.getAddressLine1(), address.getAddressLine2(), address.getCity(), address.getStateProvinceId(), address.getPostalcode()
                    );

            // Insert into PERSON_ADDRESS_T
            jdbcTemplate.update("INSERT INTO person_address_t (business_entity_id, address_id, address_type_id, created_date, modified_date) " +
                            "VALUES (?, ?, ?, current_timestamp, current_timestamp)"
                    , customer.getBusinessEntityId(), address.getAddressId(), address.getAddressTypeId()
            );
        }

        for (PhoneDO phone : customer.getPhones()) {
            // Insert into PERSON_PHONE_T
            jdbcTemplate.update("INSERT INTO person_phone_t (business_entity_id, phone_number, phone_number_type_id, created_date, modified_date) " +
                            "VALUES (?, ?, ?, current_timestamp, current_timestamp)"
                    , customer.getBusinessEntityId(), phone.getPhoneNumber(), phone.getPhoneNumberTypeId()
            );
        }

        for (EmailAddressDO emailAddress : customer.getEmailAddresses()) {
            // Insert into EMAIL_ADDRESS_T
            jdbcTemplate.update("INSERT INTO email_address_t (business_entity_id, email_address_id, email_address, created_date, modified_date) " +
                            "VALUES (?, ?, ?, current_timestamp, current_timestamp)"
                    , customer.getBusinessEntityId(), emailAddress.getId(), emailAddress.getEmailAddress()
            );
        }
```

## (4) Consuming Reference Data Product Country

The Country data product is consumed from topic `pub.ecomm.ref.country-code.state.v1` by the StreamSets Pipeline `customer_replicate-country-from-ref` and stored in the Oracle schema `ecomm_customer_priv` in table `COUNTRY_CODE_T`.

![](../images/customer-ingest-ref-code.png)

## (5) Exposing the Customer Data Product using Oracle Json Views

### Private View Layer

A View layer for each table to be exposed in the data product is held in the Oracle schema `ecomm_customer_priv`. This is so that we have an indirection where we can fix potential compatibility issues in the future between the product exposed over the JSON View and the underlying data model in `ecomm_customer`. 

```sql
CREATE OR REPLACE VIEW person_v
AS
SELECT *
FROM ecomm_customer.person_t;

...
```

### Data Product View

The JSON views are held in the Oracle schema `ecom_customer_pub_v1` and as the name reflects are currently deployed in version 1. This view acts as part of the contract and it should be held stable.

```sql
CREATE OR REPLACE 
VIEW "ECOMM_CUSTOMER_PUB_V1"."CUSTOMER_STATE_V" ("identity", "customer", "last_change", "last_change_ms") 
AS 
SELECT  JSON_OBJECT ('eventId' value sys_guid(), 'idempotenceId' value sys_guid(), 'created' value ROUND((cast(sys_extract_utc(per.created_date) as date) - TO_DATE('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')) * 86400 * 1000)) as "identity"
	, JSON_OBJECT ('id' VALUE per.business_entity_id
                            , 'personType' VALUE per.person_type
                            , 'nameStyle' VALUE per.name_style
                            , 'firstName' VALUE per.first_name
                            , 'middleName' VALUE per.middle_name
                            , 'lastName' VALUE per.last_name
                            , 'emailPromotion' VALUE per.email_promotion
                            , 'addresses' VALUE (
                                        SELECT
                                            JSON_ARRAYAGG(
                                                JSON_OBJECT('addressTypeId' VALUE peradr.address_type_id
                                                ,   'id' VALUE adr.address_id
                                                ,   'addressLine1' VALUE adr.address_line_1
                                                ,   'addressLine2' VALUE adr.address_line_2
                                                ,   'city' VALUE adr.city
                                                ,   'stateProvinceId' VALUE adr.state_province_id
                                                ,   'postalCode' VALUE adr.postal_code
                                                ,   'lastChangeTimestamp' VALUE adr.modified_date
                                                )
                                            )
                                        FROM ecomm_customer_priv.person_address_v peradr
                                        LEFT JOIN ecomm_customer_priv.address_v   adr
                                            ON ( peradr.address_id = adr.address_id )
                                        WHERE per.business_entity_id = peradr.business_entity_id
                                    )
                            , 'phones' VALUE (
                                        SELECT
                                            JSON_ARRAYAGG(
                                                JSON_OBJECT('phoneNumber' VALUE perp.phone_number
                                                ,   'phoneNumberTypeId' VALUE perp.phone_number_type_id
                                                ,   'phoneNumberType' VALUE phot.name
                                                )
                                            )
                                        FROM ecomm_customer_priv.person_phone_v perp
                                        LEFT JOIN ecomm_customer_priv.phone_number_type_v phot
                                    		ON (perp.phone_number_type_id = phot.phone_number_type_id)
                                        WHERE per.business_entity_id = perp.business_entity_id
                                    )
                            , 'emailAddresses' VALUE (
                                        SELECT
                                            JSON_ARRAYAGG(
                                                JSON_OBJECT('id' VALUE ema.email_address_id
                                                ,   'emailAddress' VALUE ema.email_address
                                                )
                                            )
                                        FROM ecomm_customer_priv.email_address_v ema
                                        WHERE per.business_entity_id = ema.business_entity_id
                                    )
                    ) AS "customer"
                    , modified_date  AS "last_change"
                    , ROUND((cast(sys_extract_utc(per.modified_date) as date) - TO_DATE('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')) * 86400 * 1000) AS "last_change_ms"
FROM ecomm_customer_priv.person_v per;
```

## (6) StreamSets Pipeline with query-based CDC

A StreamSets Pipeline is implementing a query-based CDC, by periodically querying the JSON view for new data. 

There is one such pipeline for each JSON View.

 * **customer_customerstate-to-kafka**: reads from `ecomm_customer_pub_v1.CUSTOMER_STATE_V` and publishes the data to the Kafka topic `public.ecommerce.customer.customer.state.v1`
 * **customer_customeraddresschanged-to-kafka**: reads from `ecomm_customer_pub_v1.CUSTOMER_ADDRESSCHANGED_V` and publishes the data to the Kafka topic `public.ecommerce.customer.address-changed.event.v1`

The diagram below shows the implementation of `customer_customerstate-to-kafka`.

![](./images/customer_dp_streamsets-1.png)


## (7) Kafka Topics

The following topics are part of the public API

 * `public.ecommerce.customer.customer.state.v1` - a log compacted topic (keyed by `customerId`
 * `public.ecommerce.customer.address-changed.event.v1` - an event topic with each change of an address for a data retention of 1 week.


## (8) Provide Topic data in Object Storage

Data is written to Minio S3-like object storage using Kafka Connect

```bash
curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     --data '{
  "name": "ecomm.customer.s3.sink",
  "config": {
      "connector.class": "io.confluent.connect.s3.S3SinkConnector",
      "partitioner.class": "io.confluent.connect.storage.partitioner.HourlyPartitioner",
      "partition.duration.ms": "300000",
      "flush.size": "200",
      "topics": "pub.ecomm.customer.customer.state.v1",
      "rotate.schedule.interval.ms": "20000",
      "tasks.max": "1",
      "timezone": "Europe/Zurich",
      "locale": "en",
      "schema.generator.class": "io.confluent.connect.storage.hive.schema.DefaultSchemaGenerator",
      "storage.class": "io.confluent.connect.s3.storage.S3Storage",
      "format.class": "io.confluent.connect.s3.format.avro.AvroFormat",
      "s3.region": "us-east-1",
      "s3.bucket.name": "pub.ecomm.customer-bucket",
      "topics.dir": "refined/customer.state.v1",
      "s3.part.size": "5242880",
      "store.url": "http://minio-1:9000",
      "key.converter": "org.apache.kafka.connect.storage.StringConverter"
  }
}'
```

## (9) Expose Data Product in Trino

A Hive table is created in hive for the customer DP

```sql
DROP DATABASE IF EXISTS pub_ecomm_customer CASCADE;
CREATE DATABASE pub_ecomm_customer;

USE pub_ecomm_customer;

DROP TABLE IF EXISTS customer_state_t;

CREATE EXTERNAL TABLE customer_state_t
PARTITIONED BY (year string, month string, day string, hour string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION 's3a://pub.ecomm.customer-bucket/refined/customer.state.v1/pub.ecomm.customer.customer.state.v1'
TBLPROPERTIES ('avro.schema.url'='s3a://pub.ecomm.meta-bucket/avro/pub.ecomm.customer.customer.state.v1-value.avsc','discover.partitions'='false');  

MSCK REPAIR TABLE customer_state_t SYNC PARTITIONS;
```

Using Trino Views, the data is restructured in a more SQL friendly way, first still representing the customer aggregate

```sql
USE pub_ecomm_customer;

CREATE OR REPLACE VIEW customer_aggr_v
AS
SELECT	customer.id 		AS id
,	customer.personType		AS person_type
,	customer.nameStyle		AS name_style
,	customer.title 			AS title
,	customer.firstName		AS first_name
,	customer.middleName		AS middle_name
,	customer.lastName		AS last_name
,	customer.emailPromotion	AS email_promotion
,	customer.addresses		AS addresses
,	customer.phones			AS phones
,	customer.emailAddresses	AS email_addresses
FROM customer_state_t;
```

and then also in a "realational" way

```sql
CREATE OR REPLACE VIEW customer_v
AS
SELECT	customer.id 		AS id
,	customer.personType		AS person_type
,	customer.nameStyle		AS name_style
,	customer.title 			AS title
,	customer.firstName		AS first_name
,	customer.middleName		AS middle_name
,	customer.lastName		AS last_name
,	customer.emailPromotion	AS email_promotion
FROM customer_state_t;

CREATE OR REPLACE VIEW address_v
AS
SELECT	c.customer.id	AS customer_id
,   a.id
,	a.address_type_id
,	a.address_line_1
,   a.address_line_2
,	a.city
,	a.state_province_id
,	a.postal_code
,	a.country.shortName		country
FROM customer_state_t	AS c
CROSS JOIN UNNEST (c.customer.addresses) AS a(id,address_type_id, address_line_1, address_line_2, city, state_province_id, postal_code, country);


CREATE OR REPLACE VIEW phone_v
AS
SELECT	c.customer.id	AS customer_id
,	p.phone_number
,	p.phone_number_type_id
,	p.phone_number_type
FROM customer_state_t	AS c
CROSS JOIN UNNEST (c.customer.phones) AS p(phone_number,phone_number_type_id,phone_number_type);

CREATE OR REPLACE VIEW email_address_v
AS
SELECT	c.customer.id	AS customer_id
,	e.id
,	e.email_address
FROM customer_state_t	AS c
CROSS JOIN UNNEST (c.customer.emailAddresses) AS e(id,email_address);
```

## Possible demos

### Truncate tables to perform reload

```sql
truncate table address_t;
truncate table email_address_t;
truncate table person_address_t;
truncate table person_phone_t;
truncate table person_t;
```

### Perform update on `customer_t`

```sql
UPDATE address_t SET city = UPPER(city), modified_date = CURRENT_TIMESTAMP
WHERE address_id = 15978;

SELECT * FROM address_t where address_id = 15978;

SELECT * FROM person_t WHERE business_entity_id = 6943;

UPDATE person_t SET first_name = UPPER(first_name), modified_date = CURRENT_TIMESTAMP
WHERE business_entity_id = 6943;
```

Revert back

```sql
UPDATE address_t SET city = 'Long Beach', modified_date = CURRENT_TIMESTAMP
WHERE address_id = 15978;
```



