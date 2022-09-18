# Setup Showcase

## Pre-Requistes

On an Ubuntu Linux machine install both `docker` and `docker-compose`. 

Install various utilities

```bash
sudo apt install maven
sudo apt install curl
sudo apt install jq
sudo apt install httpie
sudo apt install unzip
```

## Provision the platform

First clone the GitHub Project

```bash
git clone http://github.com/trivadispf/data-mesh-hackathon
```

Navigate to the project folder

```bash
cd data-mesh-hackathon
```

Set the `DATAPLATFORM_HOME` environment variable to the `infra/platys` folder.

```bash
export DATAPLATFORM_HOME=${PWD}/infra/platys
```

Run the provision script to copy the data into the platys platform folder

```
./provision.sh
```

Start the platys platform

```
export PUBLIC_IP=xxxx
export DOCKER_HOST_IP=xxx

cd ./infra/platys
docker-compose up -d
```

wait for the platform to start

```
...
Creating hive-metastore-db          ... done
Creating zeppelin                   ... done
Creating kafka-connect-1            ... done
Creating akhq                       ... done
Creating file-browser               ... done
Creating kafka-1                    ... done
Creating kafka-3                    ... done
Creating kafka-2                    ... done
Creating ksqldb-cli                 ... done
Creating spark-worker-1             ... done
Creating spark-worker-2             ... done
docker@ubuntu ~/d/i/platys (main)>
```

Once the platform is started successfully, we can deploy the various artefacts. 

## Deploy the sample

The Kafka topics have been automatically created by `jikkou`. 

To deploy the Avro schemas to the schema registry, perform

```bash
export DATAPLATFORM_IP=${DOCKER_HOST_IP}

cd $DATAPLATFORM_HOME/../../implementation/global/java/ecommerce-meta/
mvn clean install schema-registry:register

cd $DATAPLATFORM_HOME/../../implementation/salesorder/java/ecommerce-salesorder-meta/
mvn clean install schema-registry:register
```

Now let's add the StreamSets pipelines. **First login to StreamSets and link the instance to a user.** After that you can deploy the StreamSets pipelines, perform

```bash
cd $DATAPLATFORM_HOME/../../implementation/scripts
./import-streamsets-pipelines.sh ${DATAPLATFORM_HOME}/../..
```

Finish the import script by hitting `<ENTER>`

To deploy the kafka connect connector instances

```bash
cd $DATAPLATFORM_HOME/../../implementation/scripts
./create-kafka-connect.sh ${DATAPLATFORM_HOME}/../..
```

Upload Avro Schemas to S3 for Hive tables

```bash
cd $DATAPLATFORM_HOME/../../implementation/scripts
./upload-avro-to-s3.sh ${DATAPLATFORM_HOME}/../..
```

To deploy the Hive tables for Trino

```bash
cd $DATAPLATFORM_HOME/../../implementation/scripts
./create-hive-tables.sh ${DATAPLATFORM_HOME}/../..
```

To deploy the Trino objects

```bash
cd $DATAPLATFORM_HOME/../../implementation/scripts
./create-trino-objects.sh ${DATAPLATFORM_HOME}/../..
```


To deploy the ksqlDB objects

```bash
cd $DATAPLATFORM_HOME/../../implementation/scripts
./create-ksql-objects.sh ${DATAPLATFORM_HOME}/../..
```


## Start the Sample

Navigate to Streamsets <http://dataplatform:18630> and first start the init pipelines (you may filter by label "init")

  * `ref_init`
  * `customer_init`
  * `salesorder_init`

These run only a few seconds and load the initial data. 

Now start the Pipelines (you may filter by label "dataflow")

  * `customer_customerstate-to-kafka`
  * `customer_customeraddresschanged-to-kafka`
  * `customer_replicate-country-from-ref`

These will remain running all the time

Now you can run the simulator pipelines (you may filter by label "simulator")
 
  * `product_simulate-product`
  * `customer_simulate-person-and-address`
  * `salesorder_simulate-order-online`

"salesorder_simulate-order-online" will run all the time. The others will terminate after a while.
