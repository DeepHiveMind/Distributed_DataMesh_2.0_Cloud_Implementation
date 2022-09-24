# Modern Data Platform Cookbooks

Inhere we are documenting cookbooks on how to use the platform:

 * **Airflow**
   * [Schedule and Run Simple Python Application](./recipes/airflow-schedule-python-app/README) - `1.12.0`

 * **Trino (Formerly Presto SQL)**
   * [Trino, Spark and Delta Lake (Spark 2.4.7 & Delta Lake 0.6.1)](./recipes/delta-lake-and-trino-spark2.4/README) - `1.11.0`
   * [Trino, Spark and Delta Lake (Spark 3.0.1 & Delta Lake 0.7.0)](./recipes/delta-lake-and-trino-spark3.0/README) - `1.11.0`
   * [Querying S3 data (MinIO) using MinIO](./recipes/querying-minio-with-trino/README) - `1.11.0`
   * [Querying PostgreSQL data (MinIO) using MinIO](./recipes/querying-postgresql-with-trino/README) - `1.11.0`
   * [Querying Kafka data using Trino](./recipes/querying-kafka-with-trino/README) - `1.13.0` 
   * [Querying HDFS data using Trino](./recipes/querying-hdfs-with-presto/README) - `1.11.0`
   * Joining data between RDBMS and MinIO

 * **MQTT**
   * [Using Confluent MQTT Proxy](./recipes/using-mqtt-proxy/README)
   * [Using HiveMQ with Kafka Extensions](./recipes/using-hivemq-with-kafka-extension/README) - `1.12.0`

 * **Spark**
   * [Run Java Spark Application using `spark-submit`](./recipes/run-spark-simple-app-java-submit/README)
   * [Run Java Spark Application using Docker](./recipes/run-spark-simple-app-java-docker/README)
   * [Run Scala Spark Application using `spark-submit`](./recipes/run-spark-simple-app-scala-submit/README)
   * [Run Scala Spark Application using Docker](./recipes/run-spark-simple-app-scala-docker/README)
   * [Run Python Spark Application using `spark-submit`](./recipes/run-spark-simple-app-python-submit/README)
   * [Run Python Spark Application using Docker](./recipes/run-spark-simple-app-python-docker/README)   
   * [Spark and Hive Metastore](./recipes/spark-and-hive-metastore/README)
   * [Spark with internal S3 (using on minIO)](./recipes/spark-with-internal-s3/README)
   * [Spark with external S3](./recipes/spark-with-external-s3/README)
   * [Spark with PostgreSQL](./recipes/spark-with-postgresql/README) - `1.11.0`

 * **Hadoop HDFS**
   * [Querying HDFS data using Presto](./recipes/querying-hdfs-with-presto/README)
   * [Using HDFS data with Spark Data Frame](./recipes/using-hdfs-with-spark/README)
 
 * **Livy**
   * [Submit Spark Application over Livy](./recipes/run-spark-simple-app-scala-livy/README)

 * **StreamSets Data Collector**
   * [Support StreamSets Data Collector Activation](./recipes/streamsets-oss-activation/README) - `1.13.0` 
   * [Consume a binary file and send it as Kafka message](./recipes/streamsets-binary-file-to-kafka/README) 
   * [Using Dev Simulator Origin to simulate streaming data](./recipes/using-dev-simulator-origin/README) - `1.12.0` 
 * **Kafka**
   * [Simulated Multi-DC Setup on one machine](./recipes/simulated-multi-dc-setup/README) 
 
 * **Confluent Enterprise Platform**
   * [Using Confluent Enterprise Tiered Storage](./recipes/confluent-tiered-storage/README) 

 * **ksqlDB**
   * [Connecting through ksqlDB CLI](./recipes/connecting-through-ksqldb-cli/README)    
   * [Custom UDF and ksqlDB](./recipes/custom-udf-and-ksqldb/README)    

 * **Kafka Connect**
   * [Using additional Kafka Connect Connector](./recipes/using-additional-kafka-connect-connector/README)    

 * **APICurio Registry**
   * [APICurio Registry with SQL Storage (PostgreSQL)](./recipes/apicurio-with-database-storage/README)    

 * **Jikkou**
   * [Automate managment of Kafka topics on the platform](./recipes/jikkou-automate-kafka-topics-management/README)    

 * **Oracle RDMBS**
   * [Using private (Trivadis) Oracle EE image](./recipes/using-private-oracle-ee-image/README) - `1.13.0`    
   * [Using public Oracle XE image](./recipes/using-public-oracle-xe-image/README) - `1.13.0`    

 * **Architecture Decision Records (ADR)**
   * [Creating and visualizing ADRs with log4brains](./recipes/creating-adr-with-log4brains/README) - `1.12.0`    
