package com.trivadis.ms.sample.salesorder.api;

import com.google.common.base.Preconditions;
import com.trivadis.ecommerce.salesorder.command.avro.CreateOrderCommand;
import com.trivadis.ms.sample.salesorder.command.CreateOrderCommandProducer;
import com.trivadis.ms.sample.salesorder.converter.SalesOrderCommandConverter;
import com.trivadis.ms.sample.salesorder.converter.SalesOrderConverter;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.service.SalesOrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;

@RestController()
public class SalesOrderController {

    private static final Logger LOGGER = LoggerFactory.getLogger(SalesOrderController.class);

    @Autowired
    private SalesOrderService salesOrderService;

    @Autowired
    private CreateOrderCommandProducer commandProducer;
    
    private void submitNewOrder(SalesOrderApi salesOrderApi) throws ParseException {
        SalesOrderDO salesOrderDO = SalesOrderConverter.convert(salesOrderApi);
        salesOrderService.submitNewOnlineOrder(salesOrderDO);
        LOGGER.info("Sales Order created: " + salesOrderDO);
    }

    @RequestMapping(value= "/api/salesOrders",
            method = RequestMethod.POST,
            consumes = "application/json")
    public void postCustomer(@RequestBody SalesOrderApi salesOrderApi) throws ParseException {
        Preconditions.checkNotNull(salesOrderApi);

        //submitNewOrder(salesOrderApi);

        CreateOrderCommand createOrderCommand = SalesOrderCommandConverter.convert(salesOrderApi, true);
        commandProducer.produce(salesOrderApi.getId(), createOrderCommand);
    }

}