package com.trivadis.ms.sample.person.model;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class PhoneDO {

    private String phoneNumber;
    private Long phoneNumberTypeId;
}
