/*
 * Copyright 2019-2021 StreamThoughts.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.trivadis.ecommerce.orderproc;

import com.trivadis.ecommerce.customer.avro.Customer;
import com.trivadis.ecommerce.customer.avro.CustomerState;
import com.trivadis.ecommerce.product.avro.ProductState;
import com.trivadis.ecommerce.ref.avro.Currency;
import com.trivadis.ecommerce.salesorder.avro.Order;
import com.trivadis.ecommerce.salesorder.avro.OrderItem;
import com.trivadis.ecommerce.salesorder.avro.OrderStatus;
import com.trivadis.ecommerce.salesorder.event.avro.OrderCompletedEvent;
import com.trivadis.ecommerce.salesorder.priv.avro.*;
import io.confluent.kafka.serializers.AbstractKafkaAvroSerDeConfig;
import io.confluent.kafka.streams.serdes.avro.SpecificAvroSerde;
import io.streamthoughts.azkarra.api.annotations.Component;
import io.streamthoughts.azkarra.api.annotations.TopologyInfo;
import io.streamthoughts.azkarra.api.config.Conf;
import io.streamthoughts.azkarra.api.config.Configurable;
import io.streamthoughts.azkarra.api.events.EventStreamSupport;
import io.streamthoughts.azkarra.api.streams.TopologyProvider;
import org.apache.avro.specific.SpecificRecord;
import org.apache.kafka.common.serialization.Serdes;
import org.apache.kafka.streams.StreamsBuilder;
import org.apache.kafka.streams.Topology;
import org.apache.kafka.streams.kstream.*;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;


@Component
@javax.inject.Named("ProductOrderIssuedTopology")
@TopologyInfo(description = "Product Orader Issued to Order Completed")
public class ProductOrderIssuedTopology extends EventStreamSupport implements TopologyProvider, Configurable {

    private static <VT extends SpecificRecord> SpecificAvroSerde<VT> createSerde(String schemaRegistryUrl) {
        SpecificAvroSerde<VT> serde = new SpecificAvroSerde<>();
        Map<String, String> serdeConfig = Collections.singletonMap(AbstractKafkaAvroSerDeConfig.SCHEMA_REGISTRY_URL_CONFIG, schemaRegistryUrl);
        serde.configure(serdeConfig, false);
        return serde;
    }

    private String schemaRegistryUrl;

    private String orderTopicSource;
    private String customerTopicSource;

    private String productTopicSource;

    private String gameStartTopicSource;
    private String topicSink;
    private String stateStoreName;

    public void configure(final Conf conf) {
        orderTopicSource = conf.getOptionalString("topic.source").orElse("priv.ecomm.salesorder.order-created.event.v1");
        customerTopicSource = conf.getOptionalString("customer.topic.source").orElse("pub.ecomm.customer.customer.state.v1");
        productTopicSource = conf.getOptionalString("product.topic.source").orElse("pub.ecomm.product.product.state.v1");
        topicSink = conf.getOptionalString("topic.sink").orElse("pub.ecomm.salesorder.order-completed.event.v1");
        schemaRegistryUrl = conf.getOptionalString("streams.schema.registry.url").orElse("must-be-defined-in-conf");
    }

    @Override
    public String version() {
        return Version.getVersion();
    }

    private OrderStatus convert (int status) {
        OrderStatus returnValue = OrderStatus.CONFIRMED;
        return returnValue;
    }

    private Address getAddress (Customer customer, long addressId) {
        Address address = null;
        for (com.trivadis.ecommerce.customer.avro.Address adr : customer.getAddresses()) {
            if (adr.getId() == addressId) {
                Country country = Country.newBuilder()
                                .setNumericCode(adr.getCountry().getNumericCode())
                                .setIsoCode2(adr.getCountry().getIsoCode2())
                                .setIsoCode3(adr.getCountry().getIsoCode3())
                                .setShortName(adr.getCountry().getShortName())
                        .build();
                address = Address.newBuilder()
                        .setId(adr.getId())
                        .setSalutation(customer.getTitle())
                        .setAdditionalAddressLine1(adr.getAddressLine1())
                        .setAdditionalAddressLine2(adr.getAddressLine2())
                        .setStreet(adr.getAddressLine1())
                        .setCity(adr.getCity())
                        .setZipcode(adr.getPostalCode())
                        .setFirstName(customer.getFirstName())
                        .setLastName(customer.getLastName())
                        .setCountry(country)
                        .build();

            }
        }
        return address;
    }

    private com.trivadis.ecommerce.salesorder.priv.avro.Customer getCustomer(Customer customer) {
        return com.trivadis.ecommerce.salesorder.priv.avro.Customer.newBuilder().setId(customer.getId()).setName(customer.getFirstName() + " " + customer.getLastName()).build();
    }

    private com.trivadis.ecommerce.salesorder.priv.avro.Product getProduct(com.trivadis.ecommerce.product.avro.Product product) {
        return com.trivadis.ecommerce.salesorder.priv.avro.Product.newBuilder().setProductId(product.getId()).setName(product.getName()).build();
    }

    /*
    private com.trivadis.ecommerce.salesorder.priv.avro.Currency getCurrency(Currency currency) {
        return com.trivadis.ecommerce.salesorder.priv.avro.Currency.newBuilder()
                .setEntity(currency.getEntity())
                .setCurrency(currency.getCurrency())
                .setAlphabeticCode(currency.getAlphabeticCode())
                .setNumericCode(currency.getNumericCode())
                .setMinorUnit(currency.getMinorUnit())
                .setWithdrawlDate(currency.getWithdrawlDate())
                .build();
    }
    */

    @Override
    public Topology topology() {
        final SpecificAvroSerde<SalesOrderCreatedEvent> salesOrderCreatedEventSerde = createSerde(schemaRegistryUrl);
        final SpecificAvroSerde<CustomerState> customerStateSerde = createSerde(schemaRegistryUrl);
        final SpecificAvroSerde<ProductState> productStateSerde = createSerde(schemaRegistryUrl);
        final SpecificAvroSerde<SalesOrderEnriched> salesOrderEnrichedSerde = createSerde(schemaRegistryUrl);
//        final SpecificAvroSerde<CustomerState> currencyStateSerde = createSerde(schemaRegistryUrl);
        final SpecificAvroSerde<OrderCompletedEvent> orderCompletedSerde = createSerde(schemaRegistryUrl);

        final StreamsBuilder builder = new StreamsBuilder();

        final KStream<String, SalesOrderCreatedEvent> source = builder.stream(orderTopicSource);
        final KTable<String, CustomerState> customerTable = builder.table(customerTopicSource);
        //final GlobalKTable<String,ProductState> productTable = builder.globalTable(productTopicSource);

        Joined<String, SalesOrderCreatedEvent, CustomerState> salesOrderCustomerJoinParams = Joined.with(Serdes.String(), salesOrderCreatedEventSerde, customerStateSerde);
        ValueJoiner<SalesOrderCreatedEvent, CustomerState, SalesOrderEnriched> salesOrderCustomerJoiner = (salesOrderCreatedEvent, customerState) ->  SalesOrderEnriched.newBuilder()
                .setSalesOrder(salesOrderCreatedEvent.getSalesOrder())
                .setCustomer(getCustomer(customerState.getCustomer()))
                .setBillingAddress(getAddress(customerState.getCustomer(), salesOrderCreatedEvent.getSalesOrder().getBillToAddressId()))
                .setShippingAddress(getAddress(customerState.getCustomer(), salesOrderCreatedEvent.getSalesOrder().getBillToAddressId())).build();

        KStream<String, SalesOrderEnriched> salesOrderWithCustomer = source.join(customerTable,
                                                        salesOrderCustomerJoiner,
                                                        salesOrderCustomerJoinParams);

        KStream<String, OrderCompletedEvent> salesOrderCreatedEventStream = salesOrderWithCustomer.mapValues(v -> {
            List<OrderItem> items = new ArrayList<>();
            for (SalesOrderDetail detail : v.getSalesOrder().getSalesOrderDetails()) {
                items.add(OrderItem.newBuilder()
                        .setCreatedAt(Instant.now())
                        .setQuantity(detail.getQuantity())
                        .setUnitPrice(detail.getUnitPrice())
                        .setProduct(com.trivadis.ecommerce.salesorder.avro.Product.newBuilder().setProductId(detail.getProductId()).setName("to be done").build())
                        .build());
            }

            OrderCompletedEvent oce = OrderCompletedEvent.newBuilder()
                    .setOrder(Order.newBuilder()
                            .setId(v.getSalesOrder().getId())
                            .setOrderNo(v.getSalesOrder().getPurchaseOrderNumber())
                            .setOrderDate(v.getSalesOrder().getOrderDate())
                            .setOrderStatus(OrderStatus.COMPLETED)
                            .setCurrencyCode(v.getSalesOrder().getCurrencyCode())
                            .setBillingAddress(com.trivadis.ecommerce.salesorder.avro.Address.newBuilder()
                                    .setId(v.getBillingAddress().getId())
                                    .setSalutation(v.getBillingAddress().getSalutation())
                                    .setFirstName(v.getBillingAddress().getFirstName())
                                    .setLastName(v.getBillingAddress().getLastName())
                                    .setAdditionalAddressLine1(v.getBillingAddress().getAdditionalAddressLine1())
                                    .setAdditionalAddressLine2(v.getBillingAddress().getAdditionalAddressLine2())
                                    .setStreet(v.getBillingAddress().getStreet())
                                    .setZipcode(v.getBillingAddress().getZipcode())
                                    .setCity(v.getBillingAddress().getCity())
                                    .setCountry(com.trivadis.ecommerce.salesorder.avro.Country.newBuilder()
                                            .setIsoCode2(v.getBillingAddress().getCountry().getIsoCode2())
                                            .setIsoCode3(v.getBillingAddress().getCountry().getIsoCode3())
                                            .setNumericCode(v.getBillingAddress().getCountry().getNumericCode())
                                            .setShortName(v.getBillingAddress().getCountry().getShortName())
                                            .build())
                                    .build())
                            .setShippingAddress(com.trivadis.ecommerce.salesorder.avro.Address.newBuilder()
                                    .setId(v.getShippingAddress().getId())
                                    .setSalutation(v.getShippingAddress().getSalutation())
                                    .setFirstName(v.getShippingAddress().getFirstName())
                                    .setLastName(v.getShippingAddress().getLastName())
                                    .setAdditionalAddressLine1(v.getShippingAddress().getAdditionalAddressLine1())
                                    .setAdditionalAddressLine2(v.getShippingAddress().getAdditionalAddressLine2())
                                    .setStreet(v.getShippingAddress().getStreet())
                                    .setZipcode(v.getShippingAddress().getZipcode())
                                    .setCity(v.getShippingAddress().getCity())
                                    .setCountry(com.trivadis.ecommerce.salesorder.avro.Country.newBuilder()
                                            .setIsoCode2(v.getShippingAddress().getCountry().getIsoCode2())
                                            .setIsoCode3(v.getShippingAddress().getCountry().getIsoCode3())
                                            .setNumericCode(v.getShippingAddress().getCountry().getNumericCode())
                                            .setShortName(v.getShippingAddress().getCountry().getShortName())
                                            .build())
                                    .build())
                            .setCustomer(com.trivadis.ecommerce.salesorder.avro.Customer.newBuilder()
                                    .setId(v.getCustomer().getId())
                                    .setName(v.getCustomer().getName())
                                    .build())
                            .setItems(items)
                            .build())
                    .build();
            return oce;

        });

        /*
        ValueJoiner<SalesOrderJoinedWithCustomerAndCurrency, Currency, SalesOrderJoinedWithCustomerAndCurrency> salesOrderCurrencyJoiner = (orderJoined, currency) -> SalesOrderJoinedWithCustomerAndCurrency.newBuilder(orderJoined)
                .setCurrency(getCurrency(currency))
                .build();

        KStream<String, SalesOrderJoinedWithCustomerAndCurrency> salesOrderWithCustomerAndRef = salesOrderWithCustomer.join(currencyTable,
                                                        (k, salesOrderValue) -> String.valueOf(salesOrderValue.getSalesOrder().getCurrencyCode()),
                                                        salesOrderCurrencyJoiner);
        */
        salesOrderCreatedEventStream.to(topicSink);

        return builder.build();
    }


}