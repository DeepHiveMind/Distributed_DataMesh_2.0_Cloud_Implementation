DROP DATABASE IF EXISTS pub_ecomm_product CASCADE;
CREATE DATABASE pub_ecomm_product;

USE pub_ecomm_product;

DROP TABLE IF EXISTS product_state_t;

CREATE EXTERNAL TABLE product_state_t
PARTITIONED BY (year string, month string, day string, hour string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
  OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION 's3a://pub.ecomm.product-bucket/refined/product.state.v1/pub.ecomm.product.product.state.v1'
TBLPROPERTIES ('avro.schema.url'='s3a://pub.ecomm.meta-bucket/avro/pub.ecomm.product.product.state.v1-value.avsc','discover.partitions'='false');  

MSCK REPAIR TABLE product_state_t SYNC PARTITIONS;