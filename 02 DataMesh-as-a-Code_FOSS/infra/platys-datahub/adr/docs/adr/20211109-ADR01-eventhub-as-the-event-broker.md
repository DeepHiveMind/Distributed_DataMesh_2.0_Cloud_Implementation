# [ADR-01] Use Apache Kafka as the Event Broker 

- Status: accepted
- Deciders: Guido Schmutz, Peter Welker, Frank Heilmann
- Date: 2021-11-09 
- Tags: event-broker

## Context and Problem Statement

We want to use an Event Broker to get capabilities for passing events/messages using a publish/subscribe pattern. The Event Broker should be as cloud-agnostic as possible and needs to be linked with the IoT Hub solution provided by the gvien cloud provider. 

## Decision Drivers <!-- optional -->

- how cloud-agostic is the Event Broker solution?
- how long can the data be kept in the Event Broker? Is there a data rentention after it has been consumed?
- how interoperable is the Event Broker solution? what programming languages can work with it?
- how mature is the solution?
- is it following a industry standard?
- is Kafka as the de-facto standard for Event Borkers supported?
- is it an open source solution?
- how scalable is the Event Broker solution?
- how does it integrate with the streaming and bigdata ecosystem?
- in which Azure region is the service availble

## Considered Options

- Option 1: [Apache Kafka](http://kafka.apache.org)
- Option 2: [Confluent Cloud](https://www.confluent.io/confluent-cloud)

## Decision Outcome

Chosen option: **Option 4: Apache Kafka**, because 

### Positive Consequences <!-- optional -->

- it offers a managed service with a true pay-for-use model
- it is truely scalable in a serverless manner
- it supports a configurable data retention (depending on the service used)
- it integrates very well with the Azure streaming and big data ecosystem
- it offers a Kafka compliant API
- it offers with Azure Capture and easy way to integrate with Azure Data Lake Storage Gen2
- it offers an integrated Schema Registry

### Negative Consequences <!-- optional -->

- it is not cloud-agnostic and it is not available on-premises
- less know how/experience available than with a true Kafka
- it is not availabe as Open Source Software
- it is not fully compatible with Apache Kafka and therefore some design patterns of Kafka will not be usable (all around Log compacted topics) as well as some Kafka ecosystem solutions (ksqlDB, Kafka Streams, Confluent Schema Registry)

## Pros and Cons of the Options <!-- optional -->

### Option 1: Apache Kafka

Use the [Apache Kafka](http://kafka.apache.org) open source software to self-managed a Kafka Cluster on Azure infrastructure, such as virtual machines or container services (Azure Kubernetes). 

- Good, because it is a true Kafka cluster
- Good, because we can run the same infrastruture on-prem as well if needed
- Good, because it integrates with a lot of software which supports Apache Kafka (ksqlDB, Kafka Streams, Kafka Connect)
- Good, because it is scalable
- Bad, because it is not a managed service
- Bad, because no serverless option avaialble
- Bad, because it has a high upfront cost (engineering efforts as well as cloud consumption)

### Option 2: Confluent Cloud

Use the [Confluent Cloud](https://www.confluent.io/confluent-cloud) managed service on Azure cloud. 

- Good, because it is a true Kafka cluster
- Good, because it is a serverless, fully-managed Kafka service offered by Confluent (the people behind Apache Kafka)
- Good, because it is scalable
- Good, because it is cloud agnostic (could be run in AWS and Google Cloud)
- Good, because it is based on an Open Source core (could run it on premises as well)
- Good, because it integrates with a lot of software which supports Apache Kafka (ksqlDB, Kafka Streams, Kafka Connect)
- Good, because it brings Kafka Connect (for integration), ksqlDB (for Stream Processing) and Schema Registry (for schema governance) as part of the managed service
- Bad, because it is not as integrated with Azure as Azure Event Hub
- Bad, because it is more expensive as Azure Event Hub
- Bad, because it does not yet run in Azure Switzerland Region



- [Apache Kafka](http://kafka.apache.org)
