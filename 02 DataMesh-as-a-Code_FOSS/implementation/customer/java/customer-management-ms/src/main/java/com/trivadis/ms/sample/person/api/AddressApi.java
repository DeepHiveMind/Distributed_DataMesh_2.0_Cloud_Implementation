package com.trivadis.ms.sample.person.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.ToString;
import lombok.Value;

@Value
@Builder
@ToString
public class AddressApi {

    @JsonProperty(value = "id", required = true)
    private Long id;

    @JsonProperty(value = "addressTypeId", required = true)
    private Long addressTypeId;

    @JsonProperty(value = "addressLine1", required = true)
    private String addressLine1;

	@JsonProperty(value = "addressLine2", required = true)
    private String addressLine2;

    @JsonProperty(value = "city", required = true)
    private String city;

	@JsonProperty(value = "stateProvinceId", required = true)
    private Long stateProvinceId;

    @JsonProperty(value = "postalCode", required = true)
    private String postalCode;
    
}
