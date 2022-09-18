CONNECT ecomm_customer_pub_v1/abc123!@//localhost/XEPDB1

CREATE OR REPLACE VIEW customer_state_v as
SELECT per.business_entity_id AS "aggregate_id"  
    , JSON_OBJECT ('eventId' value sys_guid(), 'idempotenceId' value sys_guid(), 'created' value ROUND((cast(sys_extract_utc(per.created_date) as date) - TO_DATE('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')) * 86400 * 1000)) as "identity"  
	, JSON_OBJECT ('id' VALUE per.business_entity_id
                            , 'personType' VALUE per.person_type
                            , 'nameStyle' VALUE per.name_style
                            , 'title' VALUE per.title
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
                                                ,   'country' VALUE JSON_OBJECT('isoCode2' VALUE couc.alpha_2
                                                							, 'isoCode3' VALUE couc.alpha_3
                                                							, 'numericCode' VALUE couc.country_code
                                                							, 'shortName' VALUE couc.name
                                                						) 
                                                ,   'lastChangeTimestamp' VALUE adr.modified_date
                                                )
                                            )
                                        FROM ecomm_customer_priv.person_address_v peradr
                                        LEFT JOIN ecomm_customer_priv.address_v   adr 
                                            ON ( peradr.address_id = adr.address_id )
                                    	LEFT JOIN ecomm_customer_priv.state_province_v	stap
                                    	    ON ( adr.state_province_id = stap.state_province_id )
                                    	LEFT JOIN ecomm_customer_priv.country_code_v	couc
                                    	    ON ( stap.country_region_code = couc.alpha_2 )
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

        
CREATE OR REPLACE VIEW customer_adresschanged_v as
SELECT  peradr.business_entity_id as "aggregate_id"
,       peradr.business_entity_id as "customerId"
,		JSON_OBJECT ('eventId' value sys_guid(), 'idempotenceId' value sys_guid(), 'created' value ROUND((cast(sys_extract_utc(adr.created_date) as date) - TO_DATE('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')) * 86400 * 1000)) as "identity"   
,       JSON_OBJECT('addressTypeId' VALUE peradr.address_type_id
                ,   'id' VALUE adr.address_id
                ,   'addressLine1' VALUE adr.address_line_1
                ,   'addressLine2' VALUE adr.address_line_2
                ,   'city' VALUE adr.city
                ,   'stateProvinceId' VALUE adr.state_province_id
                ,   'postalCode' VALUE adr.postal_code
                ,   'country' VALUE JSON_OBJECT('isoCode2' VALUE couc.alpha_2
                                            , 'isoCode3' VALUE couc.alpha_3
                                            , 'numericCode' VALUE couc.country_code
                                            , 'shortName' VALUE couc.name
                                        )     
                ,   'lastChangeTimestamp' VALUE adr.modified_date
                ) as "address"
, 		adr.modified_date  AS "last_change"                                                
, 		ROUND((cast(sys_extract_utc(adr.modified_date) as date) - TO_DATE('1970-01-01 00:00:00','YYYY-MM-DD HH24:MI:SS')) * 86400 * 1000) AS "last_change_ms"
FROM ecomm_customer_priv.person_address_v peradr
LEFT JOIN ecomm_customer_priv.address_v   adr 
    ON ( peradr.address_id = adr.address_id )
LEFT JOIN ecomm_customer_priv.state_province_v	stap
    ON ( adr.state_province_id = stap.state_province_id )
LEFT JOIN ecomm_customer_priv.country_code_v	couc
    ON ( stap.country_region_code = couc.alpha_2 );