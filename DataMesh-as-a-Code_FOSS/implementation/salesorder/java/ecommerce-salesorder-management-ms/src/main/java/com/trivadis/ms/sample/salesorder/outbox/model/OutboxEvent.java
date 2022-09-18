package com.trivadis.ms.sample.salesorder.outbox.model;

import com.fasterxml.jackson.databind.JsonNode;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * POJO for holding the OutboxEvent to be published.
 *
 */
@Data
@AllArgsConstructor
public class OutboxEvent {

    private Long aggregateId;
    private String eventType;
    private Long eventKey;
    private JsonNode payloadJson;
    private byte[] payloadAvro;
}
