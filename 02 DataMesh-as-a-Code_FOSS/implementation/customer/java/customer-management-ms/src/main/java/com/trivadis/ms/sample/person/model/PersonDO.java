package com.trivadis.ms.sample.person.model;

import lombok.Builder;
import lombok.ToString;
import lombok.Value;

import java.util.List;

@Value
@Builder
@ToString
public class PersonDO {

    private Long businessEntityId;
	private String personType;
    private Boolean nameStyle;
    private String title;
    private String firstName;
    private String middleName;
    private String lastName;
    private String suffix;
    private Integer emailPromotion;
    private List<AddressDO> addresses;
    private List<PhoneDO> phones;
    private List<EmailAddressDO> emailAddresses;

}
