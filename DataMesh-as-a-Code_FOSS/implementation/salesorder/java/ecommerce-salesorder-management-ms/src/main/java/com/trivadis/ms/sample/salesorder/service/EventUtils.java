package com.trivadis.ms.sample.salesorder.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.trivadis.ecommerce.salesorder.priv.avro.SalesOrder;
import com.trivadis.ecommerce.salesorder.priv.avro.SalesOrderCreatedEvent;
import com.trivadis.ms.sample.salesorder.command.CreateOrderCommandProducer;
import com.trivadis.ms.sample.salesorder.converter.SalesOrderConverter;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.outbox.model.OutboxEvent;
import io.confluent.kafka.schemaregistry.client.CachedSchemaRegistryClient;
import io.confluent.kafka.schemaregistry.client.SchemaRegistryClient;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import io.confluent.kafka.serializers.KafkaAvroSerializerConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * Utility class to help the service in building event payloads.
 *
 * @author Sohan
 */
@Component
public class EventUtils {
    private static final Logger LOGGER = LoggerFactory.getLogger(EventUtils.class);

    @Value("${spring.kafka.properties.schema.registry.url}")
    private String schemaRegistryUrl;

    @Value("${outbox.serialization.type}")
    private String serializationType;

    private OutboxEvent createSalesOrderCreatedEventJson(SalesOrderDO salesOrderDO) {
        ObjectMapper mapper = JsonMapper.builder()
                .findAndAddModules()
                .build();
        JsonNode jsonNode = mapper.convertValue(salesOrderDO, JsonNode.class);

        return new OutboxEvent(
                salesOrderDO.getId(),
                "order-created",
                salesOrderDO.getCustomerId(),       // use customerId for the Kafka key
                jsonNode,
                null
        );
    }

    private OutboxEvent createSalesOrderCreatedEventAvro(SalesOrderDO salesOrderDO) {

        SchemaRegistryClient schemaRegistryClient = new CachedSchemaRegistryClient(schemaRegistryUrl, 10);
        Map<String, Object> props = new HashMap<>();
        // send correct schemas to the registry, without "avro.java.string"
        props.put(KafkaAvroSerializerConfig.AVRO_REMOVE_JAVA_PROPS_CONFIG, true);
        props.put("schema.registry.url", schemaRegistryUrl);
        KafkaAvroSerializer ser = new KafkaAvroSerializer(schemaRegistryClient, props);

        LOGGER.info("Creating Sales Order: " + salesOrderDO);

        SalesOrder salesOrder = SalesOrderConverter.convertToAvro(salesOrderDO);
        SalesOrderCreatedEvent salesOrderCreatedEvent = SalesOrderCreatedEvent.newBuilder().setSalesOrder(salesOrder).build();

        return new OutboxEvent(
                salesOrderDO.getId(),
                "order-created",
                salesOrderDO.getCustomerId(),       // use customerId for the Kafka key
                null,
                ser.serialize("priv.ecomm.salesorder.order-created.event.v1", salesOrderCreatedEvent)
        );
    }

    public OutboxEvent createSalesOrderSubmitEvent(SalesOrderDO salesOrderDO) {
        OutboxEvent outboxEvent = null;
        if (serializationType.equalsIgnoreCase("json")) {
            outboxEvent = createSalesOrderCreatedEventJson(salesOrderDO);
        } else {
            outboxEvent = createSalesOrderCreatedEventAvro(salesOrderDO);
        }
        return outboxEvent;
    }

}
