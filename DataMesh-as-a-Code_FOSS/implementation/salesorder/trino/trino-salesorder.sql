USE pub_ecomm_salesorder;

CREATE OR REPLACE VIEW order_aggr_v
AS
SELECT	o."order".id 			AS id
,	o."order".orderNo			AS order_no
,	o."order".orderDate			AS order_date
,	o."order".orderStatus		AS order_status
,	o."order".currencyCode		AS currency_code
,	o."order".billingAddress	AS billing_address
,	o."order".shippingAddress	AS shipping_address
,	o."order".customer			AS customer
,	o."order".items				AS items
FROM salesorder_completed_event_t o;


CREATE OR REPLACE VIEW order_v
AS
SELECT	o."order".id 			AS id
,	o."order".orderNo			AS order_no
,	o."order".orderDate			AS order_date
,	o."order".orderStatus		AS order_status
,	o."order".currencyCode		AS currency_code
,	o."order".billingAddress.id	AS billing_address_id
,	o."order".billingAddress.salutation	AS billing_address_salutation
,	o."order".billingAddress.firstName	AS billing_address_first_name
,	o."order".billingAddress.lastName	AS billing_address_last_name
,	o."order".billingAddress.additionaladdressline1	AS billing_address_additional_address_line1
,	o."order".billingAddress.additionaladdressline2	AS billing_address_additional_address_line2
,	o."order".billingAddress.street	AS billing_address_street
,	o."order".billingAddress.zipcode	AS billing_address_zipcode
,	o."order".billingAddress.city	AS billing_address_city
,	o."order".billingAddress.country.shortName	AS billing_address_country_name
,	o."order".shippingAddress	AS shipping_address
,	o."order".customer.id		AS customer_id
,   o."order".customer.name		AS customer_name
FROM salesorder_completed_event_t o;

CREATE OR REPLACE VIEW order_line_v
AS
SELECT	o."order".id	AS order_id
,   i.created_at
,	i.quantity
,	i.unit_price
,   i.product.productId		AS product_id
, 	i.product.name			AS product_name
FROM salesorder_completed_event_t	AS o
CROSS JOIN UNNEST (o."order".items) AS i(created_at,quantity,unit_price,product);

