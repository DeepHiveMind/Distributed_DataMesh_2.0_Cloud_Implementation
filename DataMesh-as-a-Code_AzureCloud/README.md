---
page_type: sample


Description: "Code samples showcasing how to apply Data Mesh concepts with DevOps with Modern Data Warehouse Architecture leveraging different Azure Sevices."

High Level Technology View:
- Azure
- Azure-Data-factory
- Azure-Databricks
- Azure-Stream-Analytics
- Azure-Data-Lake-Gen2
- Azure-Function-&-Azure-App-Logic
- Azure Synapse Analytics	
- Azure CosmosDB	
- Azure Data Lake			
- Azure Stream Analytics
- Azure Data Explorer		
- Presidio
- IaC ARM Templates	
- Azure Vnet & SubNet	
- Azure DevOps 		
- Azure Key Valut		
- Azure App Insight 	
- WebOntology & Protege
- Istio on AKS

## Single Technology Samples

- [Azure Purview](single_tech_samples/purview/)
  - [IaC - Azure Purview](single_tech_samples/purview/)
- [Data Factory](single_tech_samples/datafactory/)
  - [CI/CD - ADF](single_tech_samples/datafactory/)
- [Azure Databricks](single_tech_samples/databricks/)
  - [IaC - Basic Azure Databricks deployment](single_tech_samples/databricks/sample1_basic_azure_databricks_environment/)
  - [IaC - Enterprise Security and Data Exfiltration Protection Deployment](single_tech_samples/databricks/sample2_enterprise_azure_databricks_environment/)
  - [IaC - Cluster Provisioning and Secure Data Access](single_tech_samples/databricks/sample3_cluster_provisioning_and_data_access/)
- [Stream Analytics](single_tech_samples/streamanalytics/)
- [Azure SQL](single_tech_samples/azuresql/)
 - [CI/CD - AzureSQL](single_tech_samples/azuresql/)

## End to End samples



- [**Parking Sensor Solution**](e2e_samples/parking_sensors/) - This demonstrates batch, end-to-end data pipeline following the MDW architecture, along with a corresponding CI/CD process. See [here](https://www.youtube.com/watch?v=Xs1-OU5cmsw) for the presentation which includes a detailed walk-through of the solution.
![Architecture](docs/images/CI_CD_process_simplified.PNG?raw=true "Architecture")
- [**Temperature Events Solution**](e2e_samples/temperature_events) - This demonstrate a high-scale event-driven data pipeline with a focus on how to implement Observability and Load Testing.
![Architecture](e2e_samples/temperature_events/images/temperature-events-architecture.png?raw=true "Architecture")
- [**Dataset Versioning Solution**](e2e_samples/dataset_versioning) - This demonstrates how to use DataFactory to Orchestrate DataFlow, to do DeltaLoads into DeltaLake On DataLake(DoDDDoD).
- [**MDW Data Governance and PII data detection**](e2e_samples/mdw_governance) - This sample demonstrates how to deploy the Infrastructure of an end-to-end MDW Pipeline using [Azure DevOps pipelines](https://azure.microsoft.com/en-au/services/devops/pipelines/) along with a focus around Data Governance and PII data detection.
  - *Technology stack*: Azure DevOps, Azure Data Factory, Azure Databricks, Azure Purview, [Presidio](https://github.com/microsoft/presidio)

- Infrastructure as Code (IaC)
- Build and Release Pipelines (CI/CD)
- Testing
- Observability / Monitoring

## Code-of-Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).

