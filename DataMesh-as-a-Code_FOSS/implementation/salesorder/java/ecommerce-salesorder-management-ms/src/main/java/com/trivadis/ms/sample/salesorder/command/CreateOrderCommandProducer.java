package com.trivadis.ms.sample.salesorder.command;

import com.trivadis.ecommerce.salesorder.command.avro.CreateOrderCommand;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.stereotype.Component;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;


@Component
public class CreateOrderCommandProducer {
    private static final Logger LOGGER = LoggerFactory.getLogger(CreateOrderCommandProducer.class);

    @Autowired
    private KafkaTemplate<Long, CreateOrderCommand> kafkaTemplate;

    @Value("${topic.command.create-order.name}")
    String kafkaTopic;

    public void produce(Long key, CreateOrderCommand createOrderCommand) {

        SendResult<Long, CreateOrderCommand> result = null;
        try {
            result = kafkaTemplate.send(kafkaTopic, key, createOrderCommand).get(10, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        } catch (TimeoutException e) {
            e.printStackTrace();
        }

    }
}
