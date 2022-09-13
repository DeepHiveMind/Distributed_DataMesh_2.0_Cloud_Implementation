Description: 
- Code samples showcasing how to apply Data Mesh concepts with DevOps with Modern Data Warehouse Architecture leveraging different Azure Sevices.

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

> DataMesh-as-a-Code on Azure Cloud - sample implementation  

	- Technology & Tools 

		-- Azure Purview	[Data Provenance engine]
		-- Azure Synapse Analytics	[Node on Domain driven storage- Azure MPP DWH]
		-- Azure CosmosDB			[Node on Domain driven storage- MultiDomain NOSQL DB ]
		-- Azure Data Lake			[Node on Domain driven storage- Data Lake Storage]
		-- Azure Stream Analytics	[Stream Analytics engine]
		-- Azure Data Explorer		[Data Exploration Service]
		-- Presidio					[ Data Protection and PII Anonymization API]
		
		-- Azure Data Factory [Data Ingestion engine]
		-- Azure DataBricks [Data Integration engine]

		-- Azure Function & Azure App Logic [MicroService Serverless engine & MicroService Serverless Orachsteration engine]
		
		-- IaC ARM Templates				[IaC engine]
		-- Azure Vnet & SubNet		[Azure Networking]
		-- Azure DevOps 			[DevOps Service]
		-- Azure Key Valut			[Key Security]
		-- Azure App Insight 	[Azure Application Monitoring & Telemetry Service engine]
		-- Modern Domain Driven Data Warehouse on DataOps
		
	- Yet to be implemented Tools & Technology
		-- Domain Ontology on CosmosDB			[Knowledge Graph]		
		-- WebOntology & Protege
		-- Azure AKS for Data Domain KnowledgeGraph			[Azure Managed K8S Services for managing ontology services]
		-- Istio on AKS 				[Service Mesh for Service Independence, Dynamic Service discovery, circuit breaking, mTLS b/w service-to-service communication] 


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

- [**Dataset Versioning Solution**](e2e_samples/dataset_versioning) - This demonstrates how to use DataFactory to Orchestrate DataFlow, to do DeltaLoads into DeltaLake On DataLake.

- [**MDW Data Governance and PII data detection**](e2e_samples/mdw_governance) - This sample demonstrates how to deploy the Infrastructure of an end-to-end MDW Pipeline using [Azure DevOps pipelines](https://azure.microsoft.com/en-au/services/devops/pipelines/) along with a focus around Data Governance and PII data detection.
  
  - *Technology stack*: Azure DevOps, Azure Data Factory, Azure Databricks, Azure Purview, [Presidio](https://github.com/microsoft/presidio)
  - Infrastructure as Code (IaC)
  - Build and Release Pipelines (CI/CD)
  - Testing
  - Observability / Monitoring


