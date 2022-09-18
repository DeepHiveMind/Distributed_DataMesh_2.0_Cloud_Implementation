#!/bin/bash

if [ -z "$1" ]
  then
    echo 'Please specify the home directory of the Data Mesh project!'
    exit 1
fi

echo -e "\n--\n+> Creating Trino Views"

docker cp $1/implementation/salesorder/trino/trino-salesorder.sql trino-cli:/tmp
docker exec -ti trino-cli trino --server trino-1:8080 --catalog minio --progress -f /tmp/trino-salesorder.sql

docker cp $1/implementation/customer/trino/trino-customer.sql trino-cli:/tmp
docker exec -ti trino-cli trino --server trino-1:8080 --catalog minio --progress -f /tmp/trino-customer.sql

docker cp $1/implementation/product/trino/trino-product.sql trino-cli:/tmp
docker exec -ti trino-cli trino --server trino-1:8080 --catalog minio --progress -f /tmp/trino-product.sql

