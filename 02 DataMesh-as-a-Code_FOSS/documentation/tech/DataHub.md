# Data Hub 

Data Hub is the Data Catalog we are using for this Hackathon. It is installed in a separate environment using docker-compose (Platys-based configuration in `infra/platys-datahub`).

You can find the Data Catalog UI here: <http://dataplatform-gov:28144>. Login with User `datahub` and Password `datahub`. 


## Metadata Ingestion (Harvesting)

Data Hub provides a [Metadata Ingestion](https://datahubproject.io/docs/metadata-ingestion) system, which is written in Python. It provides a rich [set of sources](https://datahubproject.io/docs/metadata-ingestion#installing-plugins). 

With the latest release Data Hub the ingestion can be controlled over the GUI. Navigate to <http://dataplatform-gov:28144/ingestion> to see the existing ingestion pipelines and create new ones.

For the Sink we can use the REST API of the GMS service, which in the dockerized environment is `http://datahub-gms:8080`. To access the Core Dataplatform, you can use the `dataplatform` alias.

### Kafka

To ingest the metadata of the Kafka, perform:

```
source:
    type: kafka
    config:
        connection:
            bootstrap: 'dataplatform:9092'
            schema_registry_url: 'http://dataplatform:8081'
sink:
    type: datahub-rest
    config:
        server: 'http://datahub-gms:8080'
        token: null
```

### Business Glossary

The business glossary is defined by the following file in GitHub: `source/datahub/glossary/business_glossary.yml`. 

It needs to be copied into `data-transfer/datahub/glossary` before running the ingestion job.

```
source:
  type: datahub-business-glossary
  config:
    # Coordinates
    file: /data-transfer/datahub/glossary/business_glossary.yml

sink:
  type: datahub-rest
  config:
    server: "http://datahub-gms:8080"
```