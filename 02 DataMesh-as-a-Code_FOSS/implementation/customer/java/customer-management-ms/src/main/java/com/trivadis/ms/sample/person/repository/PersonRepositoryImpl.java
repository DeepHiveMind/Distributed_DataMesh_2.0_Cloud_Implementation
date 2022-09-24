package com.trivadis.ms.sample.person.repository;

import com.trivadis.ms.sample.person.model.AddressDO;
import com.trivadis.ms.sample.person.model.PersonDO;
import com.trivadis.ms.sample.person.model.EmailAddressDO;
import com.trivadis.ms.sample.person.model.PhoneDO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class PersonRepositoryImpl implements PersonRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public PersonDO findById(Long id) {
        Map<String,Object> result = jdbcTemplate.queryForMap("select * from person.person where businessentityid = ?", id);

        PersonDO customer = PersonDO.builder()
                .businessEntityId(((Integer) result.get("businessentityid")).longValue())
                .personType((String)result.get("personType"))
                .nameStyle((Boolean)result.get("nameStyle"))
                .title((String)result.get("title"))
                .firstName((String)result.get("firstname"))
                .middleName((String)result.get("middlename"))
                .lastName((String)result.get("lastname"))
                .suffix((String)result.get("suffix"))
                .emailPromotion((Integer)result.get("emailPromotion"))
                .addresses(new ArrayList<>())
                .build();

        List<Map<String,Object>> addresses = jdbcTemplate.queryForList(
                "select * from person.address adr JOIN person.businessentityaddress ba ON (ba.addressid = adr.addressid) where ba.businessentityid = ?", id);

        System.out.println(addresses);

        return customer;
    }

    public void save (PersonDO customer) {
        System.out.println(customer);

        // Insert into PERSON_T
        jdbcTemplate.update("INSERT INTO person_t (business_entity_id, person_type, name_style, title, first_name, middle_name, last_name, email_promotion, created_date, modified_date) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)"
                        , customer.getBusinessEntityId(), customer.getPersonType(), customer.getNameStyle(), customer.getTitle(), customer.getFirstName(), customer.getMiddleName(), customer.getLastName(), customer.getEmailPromotion()
                    );
        for (AddressDO address : customer.getAddresses()) {
            // Insert into ADDRESS_T
            jdbcTemplate.update("INSERT INTO address_t (address_id, address_line_1, address_line_2, city, state_province_id, postal_code, created_date, modified_date) " +
                                "VALUES (?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)"
                    , address.getAddressId(), address.getAddressLine1(), address.getAddressLine2(), address.getCity(), address.getStateProvinceId(), address.getPostalcode()
                    );

            // Insert into PERSON_ADDRESS_T
            jdbcTemplate.update("INSERT INTO person_address_t (business_entity_id, address_id, address_type_id, created_date, modified_date) " +
                            "VALUES (?, ?, ?, current_timestamp, current_timestamp)"
                    , customer.getBusinessEntityId(), address.getAddressId(), address.getAddressTypeId()
            );
        }

        for (PhoneDO phone : customer.getPhones()) {
            // Insert into PERSON_PHONE_T
            jdbcTemplate.update("INSERT INTO person_phone_t (business_entity_id, phone_number, phone_number_type_id, created_date, modified_date) " +
                            "VALUES (?, ?, ?, current_timestamp, current_timestamp)"
                    , customer.getBusinessEntityId(), phone.getPhoneNumber(), phone.getPhoneNumberTypeId()
            );
        }

        for (EmailAddressDO emailAddress : customer.getEmailAddresses()) {
            // Insert into EMAIL_ADDRESS_T
            jdbcTemplate.update("INSERT INTO email_address_t (business_entity_id, email_address_id, email_address, created_date, modified_date) " +
                            "VALUES (?, ?, ?, current_timestamp, current_timestamp)"
                    , customer.getBusinessEntityId(), emailAddress.getId(), emailAddress.getEmailAddress()
            );
        }

    }
}
