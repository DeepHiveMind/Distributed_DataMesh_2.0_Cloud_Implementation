# Querying data in Minio (S3) from Presto

This tutorial will show how to query Minio with Hive and Presto. 

## Initialise a platform

First [initialise a platys-supported data platform](../../getting-started) with the following services enabled in the `condfig.yml`

```
      HIVE_METASTORE_enable: true
      MINIO_enable: true
      AWSCLI_enable: true
      PRESTO_enable: true
      HUE_enable: true
```

Now generate and start the data platform. 

## Create Data in Minio

```
docker exec -ti awscli s3cmd mb s3://flight-bucket
```

```
docker exec -ti awscli s3cmd put /data-transfer/samples/flight-data/airports.json s3://flight-bucket/landing/airports/airports.json

docker exec -ti awscli s3cmd put /data-transfer/samples/flight-data/plane-data.json s3://flight-bucket/landing/plane/plane-data.json
```

## Create a table in Hive

On the docker host, start the Hive CLI 

```
docker exec -ti hive-metastore hive
```

and create a new database `flight_db` and in that database a table `plane_t`:

```
create database flight_db;
use flight_db;

CREATE EXTERNAL TABLE plane_t (tailnum string
									, type string
									, manufacturer string									, issue_date string
									, model string
									, status string
									, aircraft_type string
									, engine_type string
									, year string									 )
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
LOCATION 's3a://flight-bucket/landing/plane';
```


## Query Table from Presto

Next let's query the data from Presto. Connect to the Presto CLI using

```
docker exec -it presto presto-cli
```

Now on the Presto command prompt, switch to the right database. 

```
use minio.flight_db;
```

Let's see that there is one table available:

```
show tables;
```

We can see the `plane_t` table we created in the Hive Metastore before

```
presto:default> show tables;
     Table
---------------
 plane_t
(1 row)
```

```
SELECT * FROM plane_t;
```

```
SELECT year, count(*)
FROM plane_t
GROUP BY year;
```