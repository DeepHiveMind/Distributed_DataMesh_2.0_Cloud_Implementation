curl -X PUT \
  "http://$DOCKER_HOST_IP:8083/connectors/ecomm.product.dbzsrc.cdc/config" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
  "tasks.max": "1",
  "slot.name": "debezium1",
  "database.server.name": "postgresql",
  "database.port": "5432",
  "database.user": "postgres",
  "database.password": "abc123!",  
  "database.dbname": "postgres",
  "schema.include.list": "ecomm_product",
  "table.include.list": "ecomm_product.product,ecomm_product.product_document,ecomm_product.product_photo,ecomm_product.product_model,ecomm_product.product_category,ecomm_product.product_sub_category,ecomm_product.unit_measure",
  "plugin.name": "pgoutput",
  "tombstones.on.delete": "false",
  "database.hostname": "postgresql",
  "key.converter":"org.apache.kafka.connect.storage.StringConverter",
  "key.converter.schemas.enable": "false",
  "transforms":"unwrap,dropPrefix", 
  "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
  "transforms.unwrap.drop.tombstones": "false",
  "transforms.unwrap.delete.handling.mode": "rewrite",
  "transforms.unwrap.add.headers": "table,lsn,txId",   
  "transforms.dropPrefix.type": "org.apache.kafka.connect.transforms.RegexRouter",  
  "transforms.dropPrefix.regex": "postgresql.ecomm_product.(.*)",  
  "transforms.dropPrefix.replacement": "priv.ecomm.product.$1.cdc.v1",
  "topic.creation.default.replication.factor": 3,
  "topic.creation.default.partitions": 8,
  "topic.creation.default.cleanup.policy": "compact"
}'