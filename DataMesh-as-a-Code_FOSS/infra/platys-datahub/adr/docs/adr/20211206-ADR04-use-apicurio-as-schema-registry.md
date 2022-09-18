# [ADR-04] Use Confluent Schema Registry as the Schema Registry

- Status: accepted 
- Deciders: Guido Schmutz, Peter Welker, Frank Heilmann
- Date: 2021-12-06 
- Tags: avro, schema-registry

## Context and Problem Statement

In order to work with Avro we need a schema registry both at design as well as runtime to store and provide the Avro schemas.

## Decision Drivers <!-- optional -->

 * is Confluent API compliant, allowing us to use any tool which can work with the Confluent schema registry
 * is it a managed service
 * does it support other schema dialects (among Avro)
 * does it offer other storage options than Kafka (necessary, because with Azure Event Storage does not support Log Compacted Topics, which is needed when using Kafka storage option)
 * can it be secured
 * does it support compatiblity checks when registering a schema

## Considered Options

- Option 1: [Confluent Schema Registry](https://docs.confluent.io/platform/current/schema-registry/index.html)
- Option 2: [Apicurio Registry](https://www.apicur.io/registry/)

## Decision Outcome

Chosen option: **Option 1: Confluent Schema Registry**, because 

### Positive Consequences <!-- optional --> 
 
- Good, because it is the "reference" implementation of a schema registry
- Good, because it supports Avro, Protobuf and Json Schemas
- Good, because it supports checking for compatibility of newly registered schemas

### Negative Consequences <!-- optional -->

- Bad, because it only offers storage in Kafka and won't work with Azure Event Hub

## Links <!-- optional -->

