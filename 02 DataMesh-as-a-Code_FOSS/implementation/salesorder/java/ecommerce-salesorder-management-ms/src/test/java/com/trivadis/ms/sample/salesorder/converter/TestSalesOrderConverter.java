package com.trivadis.ms.sample.salesorder.converter;

import com.trivadis.ecommerce.salesorder.priv.avro.SalesOrder;
import com.trivadis.ms.sample.salesorder.model.CreditCardDO;
import com.trivadis.ms.sample.salesorder.model.OrderStatusEnum;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDetailDO;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.util.HashSet;
import java.util.Set;


public class TestSalesOrderConverter {

    @Test
    public void testConvertToAvro() {
        Set<SalesOrderDetailDO> salesOrderDetails = new HashSet<>();
        salesOrderDetails.add(SalesOrderDetailDO.builder()
                        .id(492L)
                        .quantity(1)
                        .productId(761L)
                        .specialOfferId(1L)
                        .unitPrice(699.0982)
                        .unitPriceDiscount(0)
                        .build());

        SalesOrderDO salesOrderDO = SalesOrderDO.builder()
                .id(43836L)
                .shipMethodId(1L)
                .revisionNumber(8)
                .orderDate(Instant.now())
                .dueDate(Instant.now())
                .shipDate(Instant.now())
                .status(OrderStatusEnum.APPROVED)
                .onlineChannel(true)
                .accountNumber("10-4030-026620")
                .customerId(26620L)
                .territoryId(6L)
                .billToAddressId(19261L)
                .shipToAddressId(19621L)
                .currencyRateId(381L)
                .subTotal(699.0982)
                .taxAmount(55.9279)
                .freight(17.4775)
                .totalDue(772.5036)
                .creditCard(CreditCardDO.builder()
                        .id(6966L)
                        .cardType("Distinguish")
                        .cardNumber("55556839566975")
                        .expMonth(4)
                        .expYear(2008)
                        .creditCardApprovalCode("233797Vi36226")
                        .build())
                .salesOrderDetails(salesOrderDetails)
                .build();
        SalesOrder salesOrderPriv = SalesOrderConverter.convertToAvro(salesOrderDO);
        System.out.println(salesOrderPriv);
    }
}
