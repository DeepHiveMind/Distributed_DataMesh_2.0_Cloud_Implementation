# [ADR-02] Use Avro for message serialization

- Status: accepted
- Deciders: Guido Schmutz, Peter Welker, Frank Heilmann
- Date: 2021-11-09 
- Tags: message-format, message-serialization

## Context and Problem Statement

As both Azure Event Hub and Azure Blob Storage/Azure Data Lake Storage Gen2 offer schema-on-read model, a serialization format is needed so that data (messages) can be serialized into a binary object, which is used either as a message in Kafka or an object in object storage. The serialization should be as fast and compact as possible.

## Decision Drivers <!-- optional -->

- how compact is the serialization?
- how fast is the serialization?
- interoperability of the serialization (can it be used by Java, Python as well as other programming environment)?
- support for forward and backward compatibility
- does it have schema support for defining a valid message

## Considered Options

- Option 1: [Apache Avro](http://avro.apache.org)
- Option 2: [Protocol Buffers](https://developers.google.com/protocol-buffers)
- Option 3: [JSON](https://www.json.org/json-en.html)

## Decision Outcome

Chosen option: **Option 1: Avro**, because

- Avro is the the most compact serialization format out of the 3 options
- it offers backward- and/or forward-compatibility
- it has a schema language
- it is supported by many programming languages such as Java, Python, C, C++ as well as Apache Spark
- it can generate classes from the Avro schema for easys serialization and deserialization
- it is very well integrated with both Kafka ecosystem and Big Data ecosystem

## Links <!-- optional -->

- [Apache Avro](http://avro.apache.org) <!-- example: Refined by [xxx](yyyymmdd-xxx.md) -->
- [Kafka with AVRO vs., Kafka with Protobuf vs., Kafka with JSON Schema](https://simon-aubury.medium.com/kafka-with-avro-vs-kafka-with-protobuf-vs-kafka-with-json-schema-667494cbb2af)
- [Big Data, Data Lake, Fast Data - Dataserialiation-Formats](https://es.slideshare.net/gschmutz/big-data-data-lake-datenserialisierungsformate)
