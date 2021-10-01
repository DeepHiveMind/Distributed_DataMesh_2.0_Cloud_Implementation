# Distributed Data Mesh 2.0 

> DataMesh-as-a-Code on Cloud | Curated list of Data Mesh Artefacts.



**[Data Mesh]** is a new paradigm to data architecture that follows 5 main principles: 
1. Domain-oriented data and compute 
2. Data as a product
3. Self-serve data platform (Data-as-a-Service)
4. Federated computational governance
5. Service Mesh powered Data Governance & Data Management


## Contents

- [Distributed Data Mesh]
	
	- [DataMesh-as-a-Code on Azure Cloud](#DataMesh-as-a-Code-on-Azure-Cloud)
	
	- [DataMesh-as-a-Code on AWS Cloud](#DataMesh-as-a-Code-on-AWS-Cloud)
	
	- [Reference Technical Blogs](#Reference-Technical-Blogs)
	- [Reference Training Courses](#Reference-training-courses)
	
	- [Books](#books)
	- [Community Resources](#community-resources)
	- [Conferences](#conferences)
	- [License](#license)

Contents
## DataMesh-as-a-Code on Azure Cloud

> DataMesh-as-a-Code on Azure Cloud sample implementation  

	- Modern Domain Driven Data Warehouse on DataOps
	
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
		
	- Yet to be implemented Tools & Technology
		-- Domain Ontology on CosmosDB			[Knowledge Graph]		
		-- WebOntology & Protege
		-- Azure AKS for Data Domain KnowledgeGraph			[Azure Managed K8S Services for managing ontology services]
		-- Istio on AKS 				[Service Mesh for Service Independence, Dynamic Service discovery, circuit breaking, mTLS b/w service-to-service communication] 
		
## DataMesh-as-a-Code on AWS Cloud
[DataMesh on AWS Cloud with AWS Glue & AWS LakeFormation](https://aws.amazon.com/blogs/big-data/design-a-data-mesh-architecture-using-aws-lake-formation-and-aws-glue/)

## Data Mesh in Practice with DataBricks
[Data Mesh in Practice with DataBricks](https://databricks.com/session_na20/data-mesh-in-practice-how-europes-leading-online-platform-for-fashion-goes-beyond-the-data-lake)

## Reference Technical Blogs

- [How to Move Beyond a Monolithic Data Lake to a Distributed Data Mesh by Martin Fowler](https://martinfowler.com/articles/data-monolith-to-mesh.html) - First article on data mesh that started whole concept.
- [Data Mesh Principles and Logical Architecture by Martin Fowler](https://martinfowler.com/articles/data-mesh-principles.html) - second article by by Martin Fowler about principles of data mesh.
- [There is more than one kind of data mesh: three types of data mesh](https://towardsdatascience.com/theres-more-than-one-kind-of-data-mesh-three-types-of-data-meshes-7cb346dc2819) - article on three variations of data meshes.
- [What is a Data Mesh — and How Not to Mesh it Up](https://towardsdatascience.com/what-is-a-data-mesh-and-how-not-to-mesh-it-up-210710bb41e0) - A beginner’s guide to implementing the latest industry trend: a data mesh.
- [Data mesh: it's not just about tech, it's about ownership and communication](https://www.thoughtworks.com/insights/blog/data-mesh-its-not-about-tech-its-about-ownership-and-communication) - article about ownership in Data Mesh.


## Reference Training Courses

- [Data Mesh Paradigm Shift in Data Platform Architecture](https://www.youtube.com/watch?v=52MCFe4v0UU) - Zhamak Dehghani overview of Data Mesh. 
- [Data Mesh Paradigm Shift in Data Platform Architecture - Arif Wider - DDD Europe 2020](https://www.youtube.com/watch?v=Iqbl9AS03VU&t=1s) - DDD Europe talk about Data Mesh.
- [Zhamak Dehghani | Kafka Summit Europe 2021 Keynote: How to Build the Data Mesh Foundation](https://www.youtube.com/watch?v=QF41q10NSAs) - Kafka Summit talk about building the foundations for Data Mesh.
- [Data Mesh - Domain-Oriented Data](https://training.dddeurope.com/data-mesh-zhamak-dheghani/) - Public Workshops by Zhamak Dehghani.



## Books

- [Data Management at Scale](https://www.oreilly.com/library/view/data-management-at/9781492054771/) - Book about Enterprise Data Architecture called Scaled Architecture. Data Mesh is only mentioned in this book, but Scaled Architecture follows all principles of Data Mesh. Book describes in details its implementation.

## Community Resources

- [Data Mesh Slack community](data-mesh.slack.com) - Active slack community about Data Mesh, Scaled Architecture and related topics.


## Conferences

- [Domain-Driven Design Europe](https://dddeurope.com) - The Leading DDD conference - Data Mesh included (online during COVID19)


## License


To the extent possible under law, [Deep Hive Mind](https://DeepHiveMind.io) has waived all copyright and related or neighboring rights to this work.
