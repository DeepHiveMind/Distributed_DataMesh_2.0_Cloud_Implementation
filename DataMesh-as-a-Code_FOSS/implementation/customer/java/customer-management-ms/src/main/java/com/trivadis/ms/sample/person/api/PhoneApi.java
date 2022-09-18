package com.trivadis.ms.sample.person.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.ToString;
import lombok.Value;

@Value
@Builder
@ToString
public class PhoneApi {

	@JsonProperty(value = "phoneNumber", required = true)
	private String phoneNumber;

	@JsonProperty(value = "phoneNumberTypeId", required = false)
	private Long phoneNumberTypeId;

}
