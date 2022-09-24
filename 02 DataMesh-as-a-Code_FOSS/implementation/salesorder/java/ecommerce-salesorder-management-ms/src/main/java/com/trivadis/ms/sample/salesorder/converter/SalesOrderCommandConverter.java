package com.trivadis.ms.sample.salesorder.converter;

import com.trivadis.ecommerce.salesorder.command.avro.CreateOrderCommand;
import com.trivadis.ecommerce.salesorder.command.avro.SalesOrderDetail;
import com.trivadis.ecommerce.salesorder.priv.avro.CreditCard;
import com.trivadis.ecommerce.salesorder.priv.avro.SalesOrder;
import com.trivadis.ms.sample.salesorder.api.CreditCardApi;
import com.trivadis.ms.sample.salesorder.api.SalesOrderApi;
import com.trivadis.ms.sample.salesorder.api.SalesOrderDetailApi;
import com.trivadis.ms.sample.salesorder.model.CreditCardDO;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDetailDO;

import java.util.ArrayList;
import java.util.HashSet;

public class SalesOrderCommandConverter {

	public static CreateOrderCommand convert (SalesOrderApi salesOrder, boolean isOnlineOrder) {
		CreateOrderCommand value = CreateOrderCommand.newBuilder()
				.setId(salesOrder.getId())
				.setShipMethodId(salesOrder.getShipMethodId())
				.setRevisionNumber(salesOrder.getRevisionNumber())
				.setOnlineChannel(isOnlineOrder)
				.setPurchaseOrderNumber(salesOrder.getPurchaseOrderNumber())
				.setAccountNumber(salesOrder.getAccountNumber())
				.setCustomerId(salesOrder.getCustomerId())
				.setSalesPersonId(salesOrder.getSalesPersonId())
				.setTerritoryId(salesOrder.getTerritoryId())
				.setBillToAddressId(salesOrder.getBillToAddressId())
				.setShipToAddressId(salesOrder.getShipToAddressId())
				.setCurrencyRateId(salesOrder.getCurrencyRateId())
				.setCurrencyCode(salesOrder.getCurrencyCode())
				.setSubTotal(salesOrder.getSubTotal())
				.setTaxAmount(salesOrder.getTaxAmount())
				.setFreight(salesOrder.getFreight())
				.setTotalDue(salesOrder.getTotalDue())
				.setComment(salesOrder.getComment())
				.setCreditCard(null)
				.setSalesOrderDetails(new ArrayList<>())
				.build();

		if (salesOrder.getCreditCard() != null &&  salesOrder.getCreditCard().getId() != null) {
				value.setCreditCard(com.trivadis.ecommerce.salesorder.command.avro.CreditCard.newBuilder()
					.setId(salesOrder.getCreditCard().getId())
					.setCardType(salesOrder.getCreditCard().getCardType())
					.setCardNumber(salesOrder.getCreditCard().getCardNumber())
					.setExpMonth(salesOrder.getCreditCard().getExpMonth())
					.setExpYear(salesOrder.getCreditCard().getExpYear())
					.setCreditCardApprovalCode(salesOrder.getCreditCard().getCreditCardApprovalCode())
					.build());
		}

		com.trivadis.ecommerce.salesorder.command.avro.SalesOrderDetail valueSalesOrderDetail;
		if (salesOrder.getSalesOrderDetails() != null) {
			for (SalesOrderDetailApi salesOrderDetail : salesOrder.getSalesOrderDetails()) {
				valueSalesOrderDetail = com.trivadis.ecommerce.salesorder.command.avro.SalesOrderDetail.newBuilder()
						.setId(salesOrderDetail.getId())
						.setQuantity(salesOrderDetail.getQuantity())
						.setProductId(salesOrderDetail.getProductId())
						.setSpecialOfferId(salesOrderDetail.getSpecialOfferId())
						.setUnitPrice(salesOrderDetail.getUnitPrice())
						.setUnitPriceDiscount(salesOrderDetail.getUnitPriceDiscount())
						.build();

				value.getSalesOrderDetails().add(valueSalesOrderDetail);
			}
		}

		return value;
	}

	public static SalesOrderDO convert (CreateOrderCommand createOrderCommand) {
		SalesOrderDO value = SalesOrderDO.builder()
				.id(createOrderCommand.getId())
				.shipMethodId(createOrderCommand.getShipMethodId())
				.revisionNumber(createOrderCommand.getRevisionNumber())
				.onlineChannel(createOrderCommand.getOnlineChannel())
				.purchaseOrderNumber(createOrderCommand.getPurchaseOrderNumber())
				.accountNumber(createOrderCommand.getAccountNumber())
				.customerId(createOrderCommand.getCustomerId())
				.salesPersonId(createOrderCommand.getSalesPersonId())
				.territoryId(createOrderCommand.getTerritoryId())
				.billToAddressId(createOrderCommand.getBillToAddressId())
				.shipToAddressId(createOrderCommand.getShipToAddressId())
				.currencyRateId(createOrderCommand.getCurrencyRateId())
				.currencyCode(createOrderCommand.getCurrencyCode())
				.subTotal(createOrderCommand.getSubTotal())
				.taxAmount(createOrderCommand.getTaxAmount())
				.freight(createOrderCommand.getFreight())
				.totalDue(createOrderCommand.getTotalDue())
				.comment(createOrderCommand.getComment())
				.creditCard(CreditCardDO.builder()
						.id(createOrderCommand.getCreditCard().getId())
						.cardType(createOrderCommand.getCreditCard().getCardType())
						.cardNumber(createOrderCommand.getCreditCard().getCardNumber())
						.expMonth(createOrderCommand.getCreditCard().getExpMonth())
						.expYear(createOrderCommand.getCreditCard().getExpYear())
						.creditCardApprovalCode(createOrderCommand.getCreditCard().getCreditCardApprovalCode())
						.build())
				.salesOrderDetails(new HashSet<>())
				.build();

		SalesOrderDetailDO valueSalesOrderDetail;
		if (createOrderCommand.getSalesOrderDetails() != null) {
			for (SalesOrderDetail salesOrderDetail : createOrderCommand.getSalesOrderDetails()) {
				valueSalesOrderDetail = SalesOrderDetailDO.builder()
						.id(salesOrderDetail.getId())
						.quantity(salesOrderDetail.getQuantity())
						.productId(salesOrderDetail.getProductId())
						.specialOfferId(salesOrderDetail.getSpecialOfferId())
						.unitPrice(salesOrderDetail.getUnitPrice())
						.unitPriceDiscount(salesOrderDetail.getUnitPriceDiscount())
						.build();

				value.getSalesOrderDetails().add(valueSalesOrderDetail);
			}
		}

		return value;
	}
}
