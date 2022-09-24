curl -X "POST" "$DOCKER_HOST_IP:8083/connectors" \
     -H "Content-Type: application/json" \
     --data '{
  "name": "ecomm.salesorder.s3.sink",
  "config": {
      "connector.class": "io.confluent.connect.s3.S3SinkConnector",
      "partitioner.class": "io.confluent.connect.storage.partitioner.HourlyPartitioner",
      "partition.duration.ms": "300000",
      "rotate.schedule.interval.ms": "20000",
      "flush.size": "2000",
      "topics": "pub.ecomm.salesorder.order-completed.event.v1",
      "tasks.max": "1",
      "timezone": "Europe/Zurich",
      "locale": "en",
      "schema.generator.class": "io.confluent.connect.storage.hive.schema.DefaultSchemaGenerator",
      "storage.class": "io.confluent.connect.s3.storage.S3Storage",
      "format.class": "io.confluent.connect.s3.format.avro.AvroFormat",
      "s3.region": "us-east-1",
      "s3.bucket.name": "pub.ecomm.salesorder-bucket",
      "topics.dir": "refined/salesorder.state.v1",
      "s3.part.size": "5242880",
      "store.url": "http://minio-1:9000",
      "key.converter": "org.apache.kafka.connect.storage.StringConverter"
  }
}'
