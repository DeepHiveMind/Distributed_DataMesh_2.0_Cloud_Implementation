package com.trivadis.ms.sample.person.model;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class EmailAddressDO {

    private Long id;
    private String emailAddress;
}
