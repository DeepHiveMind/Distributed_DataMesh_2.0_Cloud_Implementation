USE pub_ecomm_product;

CREATE OR REPLACE VIEW product_aggr_v
AS
SELECT	prod.product.id 				AS id
, 		prod.product.name 				AS name
,       prod.product.productNumber		AS product_number
,       prod.product.makeFlag			AS make_flag
,		prod.product.finishedGoodsFlag 	AS finished_goods_flag
,		prod.product.color				AS color
,		prod.product.safetyStockLevel	AS safety_stock_level
,		prod.product.reorderPoint		AS reorder_point
,		prod.product.standardCost		AS standard_cost
,		prod.product.listPrice			AS list_price
,		prod.product.size				AS size
,		prod.product.weight				AS weight
,		prod.product.daysToManufacture	AS days_to_manufacture
,		prod.product.productLine		AS product_line
,		prod.product.class				AS class
,		prod.product.style				AS style
FROM product_state_t	prod;
