package com.trivadis.ms.sample.salesorder.outbox.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Type;

import javax.persistence.*;
import java.time.Instant;
import java.util.UUID;

/**
 * Entity that maps the Eventing OUTBOX table.
 *
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "outbox")
public class OutboxDO {

    @Id
    @Column(name = "id")
    private UUID id;

    @Column(name = "aggregate_id")
    private Long aggregateId;

    @Column(name = "event_type")
    private String eventType;

    @Column(name = "event_key")
    private Long eventKey;

    @Column(name = "payload_json", length = 5000)
    private String payloadJson;

    @Lob
    @Column(name="payload_avro")
    @Type(type = "org.hibernate.type.BinaryType")
    private byte[] payloadAvro;

    @Column(name = "createdAt")
    private Instant createdAt;
}
