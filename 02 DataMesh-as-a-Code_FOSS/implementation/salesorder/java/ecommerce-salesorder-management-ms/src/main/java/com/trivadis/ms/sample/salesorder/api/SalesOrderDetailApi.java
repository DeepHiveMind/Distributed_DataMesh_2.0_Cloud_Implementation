package com.trivadis.ms.sample.salesorder.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.ToString;
import lombok.Value;

@Value
@Builder
@ToString
public class SalesOrderDetailApi {

    @JsonProperty(value = "id", required = true)
    private Long id;

    @JsonProperty(value = "quantity", required = true)
    private Integer quantity;

	@JsonProperty(value = "productId", required = true)
    private Long productId;

    @JsonProperty(value = "specialOfferId", required = true)
    private Long specialOfferId;

    @JsonProperty(value = "unitPrice", required = true)
    private Double unitPrice;

    @JsonProperty(value = "unitPriceDiscount", required = true)
    private Integer unitPriceDiscount;

}
