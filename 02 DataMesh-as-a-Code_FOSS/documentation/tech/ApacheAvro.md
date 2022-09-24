# Apache Avro

For the definition of the raw data (both for batch- and stream-ingestion use cases we decided) to use the Apache Avro data serialisation framework (see ADR-02).

With Avro we have two options for defining the Schemas, the first one using a JSON-based language (avsc extension) and the second using a specific IDL language (avdl extension), a higher-level language for authoring Avro schemata. For the OYM Data Store we decided to use the IDL-based option (see ADR-05). The main reason for using the IDL format is its simplicity and conciseness plus the option to import other definitions, which allows us to modularize the schemas.

Because some components only support the JSON-based (avsc) definitions (most importantly the Schema Registry), we use a Maven plugin to generate the JSON-based Schemas from the IDL.

## Defining Schemas

There is a central Maven project in Azure DevOps (`schemas/avro-meta`) which currently holds the master of all the schema files. Later this could be changed to a more domain-oriented way of organizing the schemas using separate projects for each domain. 

The IDL files are held in the src/main/avdl folder. If you use an IDE such as IntelliJ, you can install a plugin to get some intellisense for editing the Avro IDL files. As a sample, here is one of the schemas we defined for the Cardio Devices usecase.

```
@namespace("com.trivadis.ecommerce.sales.avro")
protocol OrderProtocol {
	import idl "OrderStatusEnum.avdl";
	import idl "Currency.avdl";
	import idl "OrderProduct.avdl";
	import idl "OrderCustomer.avdl";
	import idl "OrderAddress.avdl";

	record OrderItems{
		timestamp_ms createdAt;
		int quantity;
		double unitPrice;
		OrderProduct product;
	}

	record Order {
		long id;

		string orderNo;

		timestamp_ms orderDate;

		OrderStatus orderStatus;
		com.trivadis.ecommerce.ref.avro.Currency currency;

		OrderAddress billingAddress;
		OrderAddress shippingAddress;

		OrderCustomer customer;

		OrderItems items;
	}
}
```

An IDL always starts with a Namespace, followed by the protocol wrapper. The Namespace is important, as it makes sure that definitions are unique. Within the protocol wrapper, there can be one or more record definitions, which define the objects. As you can see the `OrderItems` definition is re-used inside the TrainingConcept2 definition. If a field in a record should be mandatory, you need to use a union with null and the type the field should be off, as you can see with the AthleteID field. 

##Generating the AVSC files

Once you are finished with your IDL definition, you need to generate the AVSC files, which are then used by most of the components. This can be done using Maven. Just perform the following command in the root of the avro-meta project.

```
mvn clean package
```

This generates the AVSC files into the folder `src/main/avro`. Usually the generated code would be stored under /target/generated-sources, but because we want the generated code to be held in Azure DevOps as well, we decided to use the src folder.

The generator also generates Java classes for all the schemas. They would be helpful if using Java to work with Avro. In that case you would just work with the Java classes and the serialization/deserialization to/from Avro would be done transparently. To provide these classes to a Java programmer, we would create a JAR-file (a library), which happens with the package phase of the mvn command. Therefore the java classes are just an intermediate step and we don’t need to keep them in Azure DevOps. That’s why they are generated into the `target/generated-sources/avro` folder. They are regenerated whenever you build the project.

