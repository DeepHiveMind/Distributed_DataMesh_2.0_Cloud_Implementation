package com.trivadis.ms.sample.salesorder.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.ToString;
import lombok.Value;

@Value
@Builder
@ToString
public class CreditCardApi {
	@JsonProperty(value = "id", required = false)
	private Long id;

	@JsonProperty(value = "cardType", required = true)
	private String cardType;

	@JsonProperty(value = "cardNumber", required = true)
	private String cardNumber;

	@JsonProperty(value = "expMonth", required = true)
	private Integer expMonth;

	@JsonProperty(value = "expYear", required = true)
	private Integer expYear;

	@JsonProperty(value = "creditCardApprovalCode", required = true)
	private String creditCardApprovalCode;

}
