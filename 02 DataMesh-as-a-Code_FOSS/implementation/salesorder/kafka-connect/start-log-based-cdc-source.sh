curl -X PUT \
  "http://$DOCKER_HOST_IP:8083/connectors/ecomm.salesorder.dbzsrc.cdc/config" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
  "tasks.max": "1",
  "database.server.name": "postgresql",
  "database.port": "5432",
  "database.user": "postgres",
  "database.password": "abc123!",  
  "database.dbname": "postgres",
  "schema.include.list": "ecomm_salesorder",
  "table.include.list": "salesorder.sales_order_detail,salesorder.sales_order_header,salesorder.credit_card",
  "plugin.name": "pgoutput",
  "tombstones.on.delete": "false",
  "database.hostname": "postgresql",
  "topic.creation.default.replication.factor": 3,
  "topic.creation.default.partitions": 8,
  "topic.creation.default.cleanup.policy": "compact"
}'