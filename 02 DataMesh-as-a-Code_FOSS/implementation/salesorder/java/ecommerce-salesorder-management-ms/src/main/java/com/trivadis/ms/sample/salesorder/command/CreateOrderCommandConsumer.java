package com.trivadis.ms.sample.salesorder.command;

import com.trivadis.ecommerce.salesorder.command.avro.CreateOrderCommand;
import com.trivadis.ms.sample.salesorder.api.SalesOrderApi;
import com.trivadis.ms.sample.salesorder.api.SalesOrderController;
import com.trivadis.ms.sample.salesorder.converter.SalesOrderCommandConverter;
import com.trivadis.ms.sample.salesorder.converter.SalesOrderConverter;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.service.SalesOrderService;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import java.text.ParseException;

@Component
public class CreateOrderCommandConsumer {
    private static final Logger LOGGER = LoggerFactory.getLogger(CreateOrderCommandConsumer.class);

    @Autowired
    private SalesOrderService salesOrderService;

    private void submitNewOrder(SalesOrderDO salesOrderDO) throws ParseException {
        salesOrderService.submitNewOnlineOrder(salesOrderDO);
        LOGGER.info("Sales Order created: " + salesOrderDO);
    }

    @KafkaListener(topics = "${topic.command.create-order.name}", groupId = "create-order-command-cg")
    public void receive(ConsumerRecord<Long, CreateOrderCommand> consumerRecord) throws ParseException {
        CreateOrderCommand value = consumerRecord.value();
        Long key = consumerRecord.key();

        SalesOrderDO salesOrderDO = SalesOrderCommandConverter.convert(consumerRecord.value());
        submitNewOrder(salesOrderDO);
    }
}
