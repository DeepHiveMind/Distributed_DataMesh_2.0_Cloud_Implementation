package com.trivadis.ms.sample.person.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.ToString;
import lombok.Value;

@Value
@Builder
@ToString
public class EmailAddressApi {

	@JsonProperty(value = "id", required = true)
	private Long id;

	@JsonProperty(value = "emailAddress", required = false)
	private String emailAddress;

}
