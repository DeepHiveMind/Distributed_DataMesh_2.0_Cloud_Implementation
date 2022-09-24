CREATE OR REPLACE VIEW V_PRODUCT AS 
  SELECT 
        PRODUCT_ID,
        NAME,
        PRODUCT_NUMBER,
        COLOR,
        CAST(STANDARD_COST AS Float)  AS STANDARD_COST , 
        CAST(LIST_PRICE AS Float)     AS LIST_PRICE ,
        TO_NUMBER(safety_stock_level) AS safety_stock_level,
        CASE MAKE_FLAG           WHEN 'True' THEN 1 ELSE 0 END AS manufactured_in_house,
        CASE FINISHED_GOODS_FLAG WHEN 'True' THEN 1 ELSE 0 END AS is_active,
        MODIFIED_DATE,
        SELL_START_DATE,
        SUBSTR(PRODUCT_NUMBER,1,2)    AS productfamiliy,
        TO_NUMBER(event_timestamp)    AS event_timestamp 
FROM PRODUCT;

CREATE TABLE product_sales AS
SELECT * FROM product;

create or replace TRIGGER tr_product_B_IU
   BEFORE INSERT OR UPDATE
   ON product
   FOR EACH ROW
BEGIN
    IF  1=2
     OR     :old.PRODUCT_ID <> :new.PRODUCT_ID
     OR NVL(:old.PRODUCT_ID,          '-1') <> NVL(:new.PRODUCT_ID,          '-1')
     OR NVL(:old.NAME,                '-1') <> NVL(:new.NAME,                '-1')
     OR NVL(:old.PRODUCT_NUMBER,      '-1') <> NVL(:new.PRODUCT_NUMBER,      '-1')
     OR NVL(:old.COLOR,               '-1') <> NVL(:new.COLOR,               '-1')
     OR NVL(:old.STANDARD_COST,       '-1') <> NVL(:new.STANDARD_COST,       '-1')
     OR NVL(:old.LIST_PRICE,          '-1') <> NVL(:new.LIST_PRICE,          '-1')
     OR NVL(:old.SAFETY_STOCK_LEVEL,  '-1') <> NVL(:new.SAFETY_STOCK_LEVEL,  '-1')
     OR NVL(:old.MAKE_FLAG,           '-1') <> NVL(:new.MAKE_FLAG,           '-1')
     OR NVL(:old.FINISHED_GOODS_FLAG, '-1') <> NVL(:new.FINISHED_GOODS_FLAG, '-1')
     OR :old.MODIFIED_DATE   <> :new.MODIFIED_DATE
     OR :old.SELL_START_DATE <> :new.SELL_START_DATE
     --OR :old.EVENT_TIMESTAMP <> :new.EVENT_TIMESTAMP
      THEN 
         INSERT into product_history VALUES (
              :new.PRODUCT_ID
            , :new.NAME
            , :new.PRODUCT_NUMBER
            , :new.COLOR
            , :new.STANDARD_COST
            , :new.LIST_PRICE
            , :new.SAFETY_STOCK_LEVEL
            , :new.MAKE_FLAG
            , :new.FINISHED_GOODS_FLAG
            , :new.MODIFIED_DATE
            , :new.SELL_START_DATE
            , :new.EVENT_TIMESTAMP
            );
    END IF;
END;
/

CREATE TABLE ORDER_COMPLETED (
    ORDER_NUMBER    VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	ORDER_DATE      DATE NOT          NULL ENABLE, 
	CURRENCY        VARCHAR2( 3 CHAR) NOT NULL ENABLE, 
	ITEM_PRODUCT_ID NUMBER            NOT NULL ENABLE, 
	ITEM_PRICE      NUMBER(10,2)      NOT NULL ENABLE, 
	ITEM_QUANTITY   NUMBER(*,0)       NOT NULL ENABLE
);

CREATE INDEX ORDER_COMPLETED_IX ON ORDER_COMPLETED (ITEM_PRODUCT_ID) ;

-- =========================================================
CREATE USER PRODUCT_OUT IDENTIFIED BY abc;

GRANT connect, resource TO PRODUCT_OUT;
GRANT create view       TO PRODUCT_OUT;

GRANT select ON v_product_history TO PRODUCT_OUT;
GRANT select ON product_history   TO PRODUCT_OUT;

-- =========================================================
CONNECT PRODUCT_OUT

CREATE OR REPLACE VIEW PRODUCT_OUT.V_PRODUCT_SALES AS 
  SELECT
        date_id,
        product_id,
        product_family,
        SUM(total_sales)    total_sales,
        SUM(total_quantity) total_quantity,
        list_price,
        currency
    FROM (
            SELECT
                t1.order_date                    date_id,
                t2.product_id                    product_id,
                substr(t2.product_number, 1, 2)  product_family,
                t1.item_price * t1.item_quantity total_sales,
                t1.item_price                    list_price,
                t1.item_quantity                 total_quantity,
                t1.currency                      currency
            FROM
                product.order_completed t1
            INNER JOIN
                v_product_history       t2 ON t1.item_product_id = t2.product_id
        )
    GROUP BY
        date_id,
        product_id,
        product_family,
        list_price,
        currency;

CREATE OR REPLACE VIEW PRODUCT_OUT.V_PRODUCT_HISTORY AS 
  SELECT
    product_id,
    modified_date as valid_from,
    NVL(LEAD(modified_date) OVER (PARTITION BY product_id ORDER BY modified_date, event_timestamp), to_date('31.12.9999', 'DD.MM.YYYY')) AS valid_to,
    name,
    product_number,
    color,
    standard_cost,
    list_price,
    safety_stock_level,
    make_flag,
    finished_goods_flag,
    sell_start_date
  FROM
    product.product_history;
