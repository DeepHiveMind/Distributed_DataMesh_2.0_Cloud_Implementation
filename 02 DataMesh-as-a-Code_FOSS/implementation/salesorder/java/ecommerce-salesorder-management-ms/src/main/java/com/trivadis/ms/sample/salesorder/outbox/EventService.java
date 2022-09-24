package com.trivadis.ms.sample.salesorder.outbox;


import com.trivadis.ms.sample.salesorder.outbox.model.OutboxDO;
import com.trivadis.ms.sample.salesorder.outbox.model.OutboxEvent;
import com.trivadis.ms.sample.salesorder.outbox.repository.OutboxRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.UUID;

/**
 * Event Service responsible for persisting the event in the database.
 *
 */
@Service
@Slf4j
public class EventService {

    /**
     * Handle to the Data Access Layer.
     */
    private final OutboxRepository outboxRepository;

    /**
     * Autowired constructor.
     *
     * @param outboxRepository
     */
    @Autowired
    public EventService(OutboxRepository outboxRepository) {
        this.outboxRepository = outboxRepository;
    }

    /**
     * This method handles all the events fired by the 'EventPublisher'. The method listens to events
     * and persists them in the database.
     *
     * @param event
     */
    @EventListener
    public void handleOutboxEvent(OutboxEvent event) {

        UUID uuid = UUID.randomUUID();
        OutboxDO entity = new OutboxDO(
                uuid,
                event.getAggregateId(),
                event.getEventType(),
                event.getEventKey() != null ? event.getEventKey() : event.getAggregateId(),
                (event.getPayloadJson() != null) ? event.getPayloadJson().toString() : null,
                event.getPayloadAvro(),
                Instant.now()
        );

        log.info("Handling event : {}.", entity);

        outboxRepository.save(entity);

        /*
         * Delete the event once written, so that the outbox doesn't grow.
         * The CDC eventing polls the database log entry and not the table in the database.
         */
        //outboxRepository.delete(entity);
    }
}
