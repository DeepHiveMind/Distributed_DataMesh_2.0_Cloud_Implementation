# Concepts 

## DataMesh_Industrialization_Context

  * Public Domain Event (a.k.a. Integration Domain Event)
    * used in `customer` domain for `adress-changed` event 

  * Transactional Outbox Pattern using log-based CDC with **Debezium & Kafka Connect**
    * used in `salesorder` domain for `order-completed` event 
    * on Postgresql

  * "Virtual" Transactional Outbox Pattern using polling-based CDC with **StreamSets**
    * used in `customer` domain for `customer` product 
    * used in `customer` domain to get changes on `person` & `address` table

  * Asynchronous Command (Command Sourcing)
    * use for `sales order` domain for submitting the new orders   


  * Query Virtualisation with Trino
    * over all Data Products from all domains
    * inside one Data Product to retrieve data on demand to provide a given Data Product (instead of replicating data) 

  * use log-based CDC with Debezium from Oracle/PostgreSQL from legacy system
    * use it in `product` domain? 
 
  * CDC Events to Aggregate
    * use it in `product` domain? 

  * Redis Materialized View with bootstrap from Kafka Compacted Log Topic
    * use it for `currency-rates`?
    * use it for `stock-values`? 

    
  * Streaming ETL with later move persistent zone
 
     
  * Materialized View with Materialize with option to Query
  
  * Keep Materialized Copy of a Kafka based Data Product from another domain
    * use it in `sales-order` domain to copy data from `customer` domain
    * keep Billing and Shipping Address as concatenated object (address) in a key/value store 
  

  * History tables
    * SCD2 
  * Version Data with lakeFS
  * Real-Time Data Marts with Pinot

  * Integrating External Systems
    * integrate [Exchange Rates API](https://exchangeratesapi.io/)

  * Event Broker & Event Sourcing
    * use for `inventory` domain

  * Concurrency and Ordering with Partitioning
    * use for inventory managment => each ordered product is used as the key when processing inventory management 
  
  * Bulkhead 
    * in `payment` domain when there is a problem with external service, stop the event consumption 

  * Future modification of an object (valid from in the future)
    * Future modification of an address is only published to the `customer.state` topic by the `customer` domain once address becomes valid
    * `address-changed` event will be published once the change is known, if it is not yet valid

