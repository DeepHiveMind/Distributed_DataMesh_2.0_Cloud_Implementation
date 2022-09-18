# Apache Kafka

Apache Kafka is the Event Broker to use for reliable and scalable Publish/Subscribe. 

## Important Urls

Service | Internal Url | External Url
------------- | -------------| -------------
Kafka Bootstrap | kafka-1:19092, kafka-2:19093 | ${PUBLIC_IP}:9092, ${PUBLIC_IP}:9093 
Schema Registry Url | http://schema-registry-1:8081 | http://${PUBLIC_IP}:8081

## List of Topics

The following topics are available:

Sub-Domain  | Topic Name | Retention | Avro Schema |
------------- | -------------| -------------| -------------
Shop  | `public.ecommerce.shop.shop-visited.state.v1` |  compacted-log | `ShopVisitedState.avsc`
Shop  | `public.ecommerce.shop.shop-user.state.v1` |  compacted-log | `ShopUserState.avsc`
Shop  | `public.ecommerce.shop.search-performed.event.v1` |  time | `ShopSearchPerformedEvent.avsc`
Shop  | `public.ecommerce.shop.user-logged-in.event.v1` |  time | `ShopUserLoggedInEvent.avsc`
Shop  | `public.ecommerce.shop.page-navigated.event.v1` |  time | `ShopPageNavigatedEvent.avsc`
Shop  | `public.ecommerce.shop.cart-action-occurred.event.v1` |  time | `ShopCartActionOccurredEvent.avsc`
Shop  | `public.ecommerce.shop.product-order-issued.event.v1` |  time | `ShopProductOrderIssuedEvent.avsc`
Order Processing  | `public.ecommerce.orderproc.order-confirmed.event.v1` |  time | `OrderConfirmedEvent.avsc`
Order Cancelled  | `public.ecommerce.orderproc.order-cancelled.event.v1` |  time | `OrderCancelledEvent.avsc`
Order Processing  | `public.ecommerce.orderproc.order-completed.event.v1` |  time | `OrderCompletedEvent.avsc`


These topics are created automatically usin [Jikkou](https://github.com/streamthoughts/jikkou). The config file can be found here: `/infra/platys/script/jikkou/ecommerce-topic-specs.yml`.
