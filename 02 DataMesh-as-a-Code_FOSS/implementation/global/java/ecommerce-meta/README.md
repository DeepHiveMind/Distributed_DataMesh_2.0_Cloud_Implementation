# Avro Schemas

This project holds all the Avro schemas of the Microservices demo. 

Put a new schema in the folder /src/main/avro. 

To get the generated Java classes for serializing/deserialzing from/to Avro in Java, run the following command from maven:

```bash
mvn package install
```

To register the schemas with the Confluent Schema Registry perform:

```bash
export DATAPLATFORM_IP=xxx.xxx.xxx.xxx
mvn schema-registry:register
```

**Note:** make sure to set the correct IP of the schema registry (port is assumed to be 8081)

