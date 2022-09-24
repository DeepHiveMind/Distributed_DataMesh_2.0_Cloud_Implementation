#!/bin/bash

# Upload customer

export TOPIC=pub.ecomm.customer.customer.state.v1
curl http://$DATAPLATFORM_IP:8081/subjects/$TOPIC-value/versions/latest | jq -r '.schema|fromjson' > $TOPIC-value.avsc

docker cp $TOPIC-value.avsc awscli:/tmp/$TOPIC-value.avsc
docker exec -ti awscli s3cmd put /tmp/$TOPIC-value.avsc s3://pub.ecomm.meta-bucket/avro/

# Upload product

export TOPIC=pub.ecomm.product.product.state.v1
curl http://$DATAPLATFORM_IP:8081/subjects/$TOPIC-value/versions/latest | jq -r '.schema|fromjson' > $TOPIC-value.avsc

docker cp $TOPIC-value.avsc awscli:/tmp/$TOPIC-value.avsc
docker exec -ti awscli s3cmd put /tmp/$TOPIC-value.avsc s3://pub.ecomm.meta-bucket/avro/


# Upload salesorder

export TOPIC=pub.ecomm.salesorder.order-completed.event.v1
curl http://$DATAPLATFORM_IP:8081/subjects/$TOPIC-value/versions/latest | jq -r '.schema|fromjson' > $TOPIC-value.avsc

docker cp $TOPIC-value.avsc awscli:/tmp/$TOPIC-value.avsc
docker exec -ti awscli s3cmd put /tmp/$TOPIC-value.avsc s3://pub.ecomm.meta-bucket/avro/


