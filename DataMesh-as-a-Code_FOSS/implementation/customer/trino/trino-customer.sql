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

