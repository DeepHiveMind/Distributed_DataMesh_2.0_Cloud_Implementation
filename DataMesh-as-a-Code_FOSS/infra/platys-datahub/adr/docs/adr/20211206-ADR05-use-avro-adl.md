# [ADR-05] Use Avro ADL for design of data contracts

- Status: accepted 
- Deciders: Guido Schmutz, Peter Welker, Frank Heilmann
- Date: 2021-12-06 
- Tags: avro, contract

## Context and Problem Statement

Apache Avro is the data serialization format we are using for data in motion as well as data at rest (raw layer). To define the contracts, we have to chose between one of 2 avaialble definition languages. 

## Decision Drivers <!-- optional -->

 * how easy it is to use
 * how well is it supported in tools
 * import of other artefacts for resuse
 * is it directly supported by Schema Registry

## Considered Options

- Option 1: [Avro IDL](https://avro.apache.org/docs/current/idl.html)
- Option 2: [Avro JSON Schema](https://avro.apache.org/docs/current/spec.html#schemas)

## Decision Outcome

Chosen option: **Option 1: Avro IDL**, because 

### Positive Consequences <!-- optional --> 
 
 * it supports importing of other artefacts
 * it is much easier to design and understand the schemas

### Negative Consequences <!-- optional -->

 * it is not directly usable in tools, an automatable transformation is necessary
 * it does not support all the Logical Types available in Option 2: Avro JSON Schema

## Links <!-- optional -->

- [Apache Avro](https://avro.apache.org/)