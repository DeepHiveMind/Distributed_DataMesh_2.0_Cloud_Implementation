
CONNECT ecomm_customer/abc123!@//localhost/XEPDB1

DROP TABLE person_t IF EXISTS;

CREATE TABLE person_t (
	business_entity_id     	INTEGER     PRIMARY KEY,
    person_type            	VARCHAR2(100),
    name_style             	VARCHAR2(1),
    title					VARCHAR2(20),
    first_name             	VARCHAR2(100),
    middle_name            	VARCHAR2(100),
    last_name              	VARCHAR2(100),
    email_promotion        	NUMBER(10),
    demographics			VARCHAR2(2000),
    created_date			TIMESTAMP,
    modified_date         	TIMESTAMP);
    
DROP TABLE address_t;

CREATE TABLE address_t (
    address_id         		INTEGER     PRIMARY KEY,
    address_line_1      	VARCHAR2(200),
    address_line_2      	VARCHAR2(200),
    city              		VARCHAR2(200),
    state_province_id     	INTEGER,
    postal_code        		VARCHAR2(50),
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP);

DROP TABLE person_address_t;

CREATE TABLE person_address_t (
    business_entity_id  	INTEGER,
    address_id  			INTEGER,
    address_type_id			INTEGER,
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP,
    CONSTRAINT person_address_pk PRIMARY KEY (business_entity_id, address_id, address_type_id));

DROP TABLE email_address_t;

CREATE TABLE email_address_t (
    business_entity_id      INTEGER,
    email_address_id      	INTEGER,
    email_address      	    VARCHAR2(200),
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP,
    CONSTRAINT email_address_pk PRIMARY KEY (business_entity_id, email_address_id));

DROP TABLE person_phone_t;

CREATE TABLE person_phone_t (
    business_entity_id      INTEGER,
    phone_number      	    VARCHAR2(50),
    phone_number_type_id    INTEGER,
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP,
    CONSTRAINT person_phone_pk PRIMARY KEY (business_entity_id, phone_number, phone_number_type_id));
   
DROP TABLE password_t;

CREATE TABLE password_t (
    business_entity_id  	INTEGER PRIMARY KEY,
    password_hash  			VARCHAR2(100),
    password_salt  			VARCHAR2(100),
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP);    
    

DROP TABLE state_province_t;

CREATE TABLE state_province_t (
    state_province_id  					INTEGER PRIMARY KEY,
    state_province_code  				VARCHAR2(3),
    country_region_code	  				VARCHAR2(2),
    is_only_state_province_flag			VARCHAR2(1),
    name								VARCHAR2(50),
    territory_id						INTEGER,
    created_date		    			TIMESTAMP,
    modified_date    					TIMESTAMP);
    

DROP TABLE country_region_t;

CREATE TABLE country_region_t (
    country_region_code  	VARCHAR2(2) PRIMARY KEY,
    name  					VARCHAR2(50),
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP);
    
    
DROP TABLE phone_number_type_t;

CREATE TABLE phone_number_type_t (
    phone_number_type_id  	INTEGER PRIMARY KEY,
    name  					VARCHAR2(20),
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP);
    
DROP TABLE address_type_t;

CREATE TABLE address_type_t (
    address_type_id  		INTEGER PRIMARY KEY,
    name  					VARCHAR2(20),
    created_date		    TIMESTAMP,
    modified_date    		TIMESTAMP);    
    
    
GRANT SELECT ON person_t TO ecomm_customer_priv WITH GRANT OPTION;
GRANT SELECT ON person_address_t TO ecomm_customer_priv WITH GRANT OPTION;
GRANT SELECT ON address_t TO ecomm_customer_priv WITH GRANT OPTION;
GRANT SELECT ON person_phone_t TO ecomm_customer_priv WITH GRANT OPTION;
GRANT SELECT ON email_address_t TO ecomm_customer_priv WITH GRANT OPTION;
GRANT SELECT ON phone_number_type_t TO ecomm_customer_priv WITH GRANT OPTION;
GRANT SELECT ON state_province_t TO ecomm_customer_priv WITH GRANT OPTION;