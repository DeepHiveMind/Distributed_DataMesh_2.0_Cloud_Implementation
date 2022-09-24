package com.trivadis.ms.sample.salesorder.converter;

import com.trivadis.ecommerce.salesorder.priv.avro.CreditCard;
import com.trivadis.ecommerce.salesorder.priv.avro.SalesOrder;
import com.trivadis.ecommerce.salesorder.priv.avro.SalesOrderDetail;
import com.trivadis.ms.sample.salesorder.api.SalesOrderDetailApi;
import com.trivadis.ms.sample.salesorder.api.SalesOrderApi;
import com.trivadis.ms.sample.salesorder.api.CreditCardApi;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDetailDO;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.model.CreditCardDO;

import java.util.ArrayList;
import java.util.HashSet;

public class SalesOrderConverter {
	
	public static SalesOrderApi convert (SalesOrderDO salesOrder) {

		SalesOrderApi value = SalesOrderApi.builder()
				.id(salesOrder.getId())
				.shipMethodId(salesOrder.getShipMethodId())
				.revisionNumber(salesOrder.getRevisionNumber())
				.onlineChannel(salesOrder.getOnlineChannel())
				.purchaseOrderNumber(salesOrder.getPurchaseOrderNumber())
				.accountNumber(salesOrder.getAccountNumber())
				.customerId(salesOrder.getCustomerId())
				.salesPersonId(salesOrder.getSalesPersonId())
				.territoryId(salesOrder.getTerritoryId())
				.billToAddressId(salesOrder.getBillToAddressId())
				.shipToAddressId(salesOrder.getShipToAddressId())
				.currencyRateId(salesOrder.getCurrencyRateId())
				.currencyCode(salesOrder.getCurrencyCode())
				.subTotal(salesOrder.getSubTotal())
				.taxAmount(salesOrder.getTaxAmount())
				.freight(salesOrder.getFreight())
				.totalDue(salesOrder.getTotalDue())
				.comment(salesOrder.getComment())
				.salesOrderDetails(new ArrayList<>())
				.creditCard(
						CreditCardApi.builder()
								.id(salesOrder.getCreditCard().getId())
								.cardType(salesOrder.getCreditCard().getCardType())
								.cardNumber(salesOrder.getCreditCard().getCardNumber())
								.expMonth(salesOrder.getCreditCard().getExpMonth())
								.expYear(salesOrder.getCreditCard().getExpYear())
								.creditCardApprovalCode(salesOrder.getCreditCard().getCreditCardApprovalCode())
								.build()
				)
				.build();

		SalesOrderDetailApi valueSalesOrderDetail;
		if (salesOrder.getSalesOrderDetails() != null) {
			for (SalesOrderDetailDO salesOrderDetail : salesOrder.getSalesOrderDetails()) {
				valueSalesOrderDetail = SalesOrderDetailApi.builder()
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
	
	public static SalesOrderDO convert (SalesOrderApi salesOrder) {
		SalesOrderDO value = SalesOrderDO.builder()
				.id(salesOrder.getId())
				.shipMethodId(salesOrder.getShipMethodId())
				.revisionNumber(salesOrder.getRevisionNumber())
				.onlineChannel(salesOrder.getOnlineChannel())
				.purchaseOrderNumber(salesOrder.getPurchaseOrderNumber())
				.accountNumber(salesOrder.getAccountNumber())
				.customerId(salesOrder.getCustomerId())
				.salesPersonId(salesOrder.getSalesPersonId())
				.territoryId(salesOrder.getTerritoryId())
				.billToAddressId(salesOrder.getBillToAddressId())
				.shipToAddressId(salesOrder.getShipToAddressId())
				.currencyRateId(salesOrder.getCurrencyRateId())
				.currencyCode(salesOrder.getCurrencyCode())
				.subTotal(salesOrder.getSubTotal())
				.taxAmount(salesOrder.getTaxAmount())
				.freight(salesOrder.getFreight())
				.totalDue(salesOrder.getTotalDue())
				.comment(salesOrder.getComment())
				.creditCard(CreditCardDO.builder()
						.id(salesOrder.getCreditCard().getId())
						.cardType(salesOrder.getCreditCard().getCardType())
						.cardNumber(salesOrder.getCreditCard().getCardNumber())
						.expMonth(salesOrder.getCreditCard().getExpMonth())
						.expYear(salesOrder.getCreditCard().getExpYear())
						.creditCardApprovalCode(salesOrder.getCreditCard().getCreditCardApprovalCode())
						.build())
				.salesOrderDetails(new HashSet<>())
				.build();

		SalesOrderDetailDO valueSalesOrderDetail;
		if (salesOrder.getSalesOrderDetails() != null) {
			for (SalesOrderDetailApi salesOrderDetail : salesOrder.getSalesOrderDetails()) {
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

	public static SalesOrder convertToAvro(SalesOrderDO salesOrderDO) {
		CreditCard creditCard = CreditCard.newBuilder()
				.setId(salesOrderDO.getCreditCard().getId())
				.setCardType(salesOrderDO.getCreditCard().getCardType())
				.setCardNumber(salesOrderDO.getCreditCard().getCardNumber())
				.setExpMonth(salesOrderDO.getCreditCard().getExpMonth())
				.setExpYear(salesOrderDO.getCreditCard().getExpYear())
				.setCreditCardApprovalCode(salesOrderDO.getCreditCard().getCreditCardApprovalCode())
				.build();

		SalesOrder salesOrder = SalesOrder.newBuilder()
								.setId(salesOrderDO.getId())
								.setShipMethodId(salesOrderDO.getShipMethodId())
				.setRevisonNumber(salesOrderDO.getRevisionNumber())
				.setOrderDate(salesOrderDO.getOrderDate())
				.setDueDate(salesOrderDO.getDueDate())
				.setShipDate(salesOrderDO.getShipDate())
				.setStatus(salesOrderDO.getStatus().getID())
				.setOnlineChannel(salesOrderDO.getOnlineChannel())
				.setPurchaseOrderNumber(salesOrderDO.getPurchaseOrderNumber())
				.setCustomerId(salesOrderDO.getCustomerId())
				.setSalesPersonId(salesOrderDO.getSalesPersonId())
				.setAccountNumber(salesOrderDO.getAccountNumber())
				.setTerritoryId(salesOrderDO.getTerritoryId())
				.setBillToAddressId(salesOrderDO.getBillToAddressId())
				.setShipToAddressId(salesOrderDO.getShipToAddressId())
				.setCurrencyRateId(salesOrderDO.getCurrencyRateId())
				.setCurrencyCode(salesOrderDO.getCurrencyCode())
				.setSubTotal(salesOrderDO.getSubTotal())
				.setTaxAmount(salesOrderDO.getTaxAmount())
				.setFreight(salesOrderDO.getFreight())
				.setTotalDue(salesOrderDO.getTotalDue())
				.setComment(salesOrderDO.getComment())
				.setSalesOrderDetails(new ArrayList<>())
				.setCreditCard(creditCard)
									.build();

		SalesOrderDetail salesOrderDetail;
		if (salesOrder.getSalesOrderDetails() != null) {
			for (SalesOrderDetailDO salesOrderDetailDO : salesOrderDO.getSalesOrderDetails()) {
				salesOrderDetail = SalesOrderDetail.newBuilder()
						.setId(salesOrderDetailDO.getId())
						.setQuantity(salesOrderDetailDO.getQuantity())
						.setProductId(salesOrderDetailDO.getProductId())
						.setSpecialOfferId(salesOrderDetailDO.getSpecialOfferId())
						.setUnitPrice(salesOrderDetailDO.getUnitPrice())
						.setUnitPriceDiscount(salesOrderDetailDO.getUnitPriceDiscount())
						.build();

				salesOrder.getSalesOrderDetails().add(salesOrderDetail);
			}
		}

		return salesOrder;
	}

}
