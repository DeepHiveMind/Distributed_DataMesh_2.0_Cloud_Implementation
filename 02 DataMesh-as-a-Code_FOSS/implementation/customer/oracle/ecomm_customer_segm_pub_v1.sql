-- USER SQL
CREATE USER customer_segm_dp IDENTIFIED BY "customer_segm_dp"  
DEFAULT TABLESPACE "USERS"
TEMPORARY TABLESPACE "TEMP";

-- QUOTAS

ALTER USER customer_segm_dp QUOTA UNLIMITED ON "USERS";


-- ROLES
GRANT "CONNECT" TO customer_segm_dp ;
GRANT "RESOURCE" TO customer_segm_dp ;
ALTER USER customer_segm_dp DEFAULT ROLE "CONNECT","RESOURCE";

-- SYSTEM PRIVILEGES
---
GRANT SELECt ANY TABLE to customer_segm_dp;
GRANT CREATE VIEW TO customer_segm_dp;


-- Views 

create or replace view  customer_segm_dp.CUSTOMER_SEGMENTATION as
SELECT c.customerid "CustomerID"
,      case mod(c.customerid,3) 
           when 0 then 'A' 
           when 1 then 'B' 
           when 2 then 'C' 
       end as "CustomerSegment"
FROM   customer_int.customer c ;


create or replace view  customer_segm_dp.V_CUSTOMER_SEGMENTATION as
SELECT c.customerid "CustomerID"
,      case
           when c.salesvolume > 150 then 'A' 
           when c.salesvolume between 100 and 150 then 'B' 
           else 'C' 
       end as "CustomerSegment"
FROM   customer_int.v_customer_sales c ;