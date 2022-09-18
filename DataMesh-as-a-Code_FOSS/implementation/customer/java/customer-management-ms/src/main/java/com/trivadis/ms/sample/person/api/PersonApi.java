package com.trivadis.ms.sample.person.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.ToString;
import lombok.Value;

import java.util.List;

@Value
@Builder
@ToString
public class PersonApi {

    @JsonProperty(value = "businessEntityId", required = true)
	private Long businessEntityId;

	@JsonProperty(value = "personType", required = true)
	private String personType;

	@JsonProperty(value = "nameStyle", required = false)
	private Boolean nameStyle;

	@JsonProperty(value = "title", required = false)
	private String title;

	@JsonProperty(value = "firstName", required = true)
	private String firstName;

	@JsonProperty(value = "middleName", required = false)
	private String middleName;

	@JsonProperty(value = "lastName", required = true)
	private String lastName;
    
    @JsonProperty(value = "suffix", required = false)
	private String suffix;

	@JsonProperty(value = "emailPromotion", required = false)
	private Integer emailPromotion;

    @JsonProperty(value = "addresses", required = false)
    private List<AddressApi> addresses;

	@JsonProperty(value = "phones", required = false)
	private List<PhoneApi> phones;

	@JsonProperty(value = "emailAddresses", required = false)
	private List<EmailAddressApi> emailAddresses;
}
