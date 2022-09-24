---
technoglogies:      kafka,jikkou
version:				1.14.0
validated-at:			2.2.2022
---

# Automate managment of Kafka topics on the platform

This recipe will show how automate the management of Kafka topics using the jikkou tool, which is part of the platform.

## Initialise data platform

First [initialise a platys-supported data platform](../documentation/getting-started) with the following services enabled

```
platys init --enable-services KAFKA,AKHQ,JIKKOU -s trivadis/platys-modern-data-platform -w 1.14.0
```

Now generate and start the platform

```bash
export DATAPLATFORM_HOME=${PWD}

platys gen

docker-compose up -d
```

## Automate initial Kafka topic creation

In this recipe we will create to topics

 * `topic-1` - with 8 paritions, replication-factor 3 and min.insync.replicas = 2
 * `topic-2` - with 1 partition, replication-factor 3 as a log-compacted topic

In the `scripts/jikkou` folder, create a file named `topic-specs.yml` and add the following content

```yml
version: 1
specs:
  topics:
  - name: '{{ labels.topic.prefix | default('') }}topic-1'
    partitions: 8
    replication_factor: 3
    configs:
      min.insync.replicas: 2
  - name: '{{ labels.topic.prefix | default('') }}topic-2'
    partitions: 1
    replication_factor: 3
    configs:
      cleanup.policy: compact
```

With the file in place, execute once again

```bash
docker-compose up -d
```

To see what Jikkou has done you can visit the log file of the `jikkou` service:

```bash
docker logs -f jikkou
```

you should see an output similar to the one below

```bash
20:34:59.775 [kafka-admin-client-thread | adminclient-1] WARN  o.apache.kafka.clients.NetworkClient - [AdminClient clientId=adminclient-1] Connection to node -1 (kafka-1/172.18.0.8:19092) could not be established. Broker may not be available.
Can't read specification from file '/jikkou/topic-specs.yml': /jikkou/topic-specs.yml (No such file or directory)
TASK [CREATE] Create a new topic topic-2 (partitions=1, replicas=3) - CHANGED ***************************
TASK [CREATE] Create a new topic topic-1 (partitions=8, replicas=3) - CHANGED ***************************
EXECUTION in 2s 884ms 
ok : 0, created : 2, altered : 0, deleted : 0 failed : 0
```

The first two lines are from the initial startup, where there was not yet a file in the folder. The last 3 lines show that the two new topics have been created.

The topic creation would also work if done initially when first starting the platform. 

## Add a new and alter an existing Kafka topic

Edit the file `scripts/jikkou/topic-specs.yml` file and add a new topic `topic-3` and change the data retention of `topic-1` to unlimited (`-1`):  

```yml
version: 1
specs:
  topics:
  - name: '{{ labels.topic.prefix | default('') }}topic-1'
    partitions: 8
    replication_factor: 3
    configs:
      min.insync.replicas: 2
      retention.ms: -1
  - name: '{{ labels.topic.prefix | default('') }}topic-2'
    partitions: 1
    replication_factor: 3
    configs:
      cleanup.policy: compact
  - name: '{{ labels.topic.prefix | default('') }}topic-3'
    partitions: 8
    replication_factor: 3
```

Now perform again

```
docker-compose up -d
```

and visit the log. You should see the following additional lines

```bash
TASK [CREATE] Create a new topic topic-3 (partitions=8, replicas=3) - CHANGED ***************************
TASK [ALTER] Alter topic topic-1 - CHANGED *************************************************************
TASK [NONE] Unchanged topic topic-2  - OK ********************************************************
EXECUTION in 2s 371ms 
ok : 1, created : 1, altered : 1, deleted : 0 failed : 0
```

## Set the label `topic.prefix`

For the names of the topics in the `topic-specs.yml`, we have used the label `topic.prefix` to specify a prefix for the topic names. So far the prefix is empty, as we have not yet specified it. 

We can do that by adding it to the `JIKKOU_set_labels` property. 

Edit the `config.yml` and add te follwing line right after `JIKKOU_enable: true`:

```bash
      JIKKOU_set_labels: 'topic.prefix=dev-'
```

Regenerate the platform and again run `docker-compose`

```bash
platys gen
docker-compose up -d
```

View the log 

```bash
docker logs -f jikkou
```

and see that the old topics have been removed and the new ones with the prefix `dev-` were created.

```bash
TASK [CREATE] Create a new topic dev-topic-3 (partitions=8, replicas=3) - CHANGED ***********************
TASK [DELETE] Delete topic topic-1  - CHANGED ***********************************************************
TASK [CREATE] Create a new topic dev-topic-2 (partitions=1, replicas=3) - CHANGED ***********************
TASK [DELETE] Delete topic topic-2  - CHANGED ***********************************************************
TASK [CREATE] Create a new topic dev-topic-1 (partitions=8, replicas=3) - CHANGED ***********************
TASK [DELETE] Delete topic topic-3  - CHANGED ***********************************************************
EXECUTION in 3s 51ms 
ok : 0, created : 3, altered : 0, deleted : 3 failed : 0
```



