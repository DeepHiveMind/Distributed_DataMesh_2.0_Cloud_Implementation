package com.trivadis.ms.sample.salesorder.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Setter;
import lombok.ToString;
import lombok.Value;

import javax.persistence.Column;
import java.util.List;

@Value
@Builder
@ToString
public class SalesOrderApi {

    @JsonProperty(value = "id", required = true)
	private Long id;

	@JsonProperty(value = "shipMethodId", required = true)
	private Long shipMethodId;

	@JsonProperty(value = "revisionNumber", required = true)
	private Integer revisionNumber;

	@JsonProperty(value = "onlineChannel", required = true)
	private Boolean onlineChannel;

	@JsonProperty(value = "purchaseOrderNumber§§", required = false)
	private String purchaseOrderNumber;

	@JsonProperty(value = "accountNumber", required = false)
	private String accountNumber;

	@JsonProperty(value = "customerId", required = false)
	private Long customerId;

	@JsonProperty(value = "salesPersonId", required = false)
	private Long salesPersonId;

	@JsonProperty(value = "territoryId", required = true)
	private Long territoryId;

	@JsonProperty(value = "billToAddressId", required = true)
	private Long billToAddressId;

	@JsonProperty(value = "shipToAddressId", required = true)
	private Long shipToAddressId;

	@JsonProperty(value = "currencyRateId", required = true)
	private Long currencyRateId;

	@JsonProperty(value = "currencyCode", required = true)
	private String currencyCode;

	@JsonProperty(value = "subTotal", required = true)
	private Double subTotal;

	@JsonProperty(value = "taxAmount", required = true)
	private Double taxAmount;

	@JsonProperty(value = "freight", required = true)
	private Double freight;

	@JsonProperty(value = "totalDue", required = true)
	private Double totalDue;

	@JsonProperty(value = "comment", required = false)
	private String comment;

    @JsonProperty(value = "orderDetails", required = false)
    private List<SalesOrderDetailApi> salesOrderDetails;

	@JsonProperty(value = "creditCard", required = false)
	private CreditCardApi creditCard;
}
