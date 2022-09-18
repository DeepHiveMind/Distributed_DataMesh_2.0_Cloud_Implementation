package com.trivadis.ms.sample.person.converter;

import com.trivadis.ms.sample.person.api.AddressApi;
import com.trivadis.ms.sample.person.api.EmailAddressApi;
import com.trivadis.ms.sample.person.api.PersonApi;
import com.trivadis.ms.sample.person.api.PhoneApi;
import com.trivadis.ms.sample.person.model.AddressDO;
import com.trivadis.ms.sample.person.model.PersonDO;
import com.trivadis.ms.sample.person.model.EmailAddressDO;
import com.trivadis.ms.sample.person.model.PhoneDO;

import java.util.ArrayList;

public class PersonConverter {
	
	public static PersonApi convert (PersonDO customer) {

		PersonApi value = PersonApi.builder()
				.businessEntityId(customer.getBusinessEntityId())
				.personType(customer.getPersonType())
				.nameStyle(customer.getNameStyle())
				.title(customer.getTitle())
				.firstName(customer.getFirstName())
				.middleName(customer.getMiddleName())
				.lastName(customer.getLastName())
				.suffix(customer.getSuffix())
				.emailPromotion(customer.getEmailPromotion())
				.addresses(new ArrayList<>())
				.phones(new ArrayList<>())
				.emailAddresses(new ArrayList<>())
				.build();

		com.trivadis.ms.sample.person.api.AddressApi valueAddress;
		if (customer.getAddresses() != null) {
			for (AddressDO address : customer.getAddresses()) {
				valueAddress = AddressApi.builder()
						.id(address.getAddressId())
						.addressTypeId(address.getAddressTypeId())
						.addressLine1(address.getAddressLine1())
						.addressLine2(address.getAddressLine2())
						.city(address.getCity())
						.stateProvinceId(address.getStateProvinceId())
						.postalCode(address.getPostalcode())
						.build();

				value.getAddresses().add(valueAddress);
			}
		}

		com.trivadis.ms.sample.person.api.PhoneApi valuePhone;
		if (customer.getPhones() != null) {
			for (PhoneDO phone : customer.getPhones()) {
				valuePhone = PhoneApi.builder()
						.phoneNumber(phone.getPhoneNumber())
						.phoneNumberTypeId(phone.getPhoneNumberTypeId())
						.build();

				value.getPhones().add(valuePhone);
			}
		}

		com.trivadis.ms.sample.person.api.EmailAddressApi valueEmailAddress;
		if (customer.getPhones() != null) {
			for (EmailAddressDO emailAddress : customer.getEmailAddresses()) {
				valueEmailAddress = EmailAddressApi.builder()
						.id(emailAddress.getId())
						.emailAddress(emailAddress.getEmailAddress())
						.build();

				value.getEmailAddresses().add(valueEmailAddress);
			}
		}

		return value;
	}
	
	public static PersonDO convert (PersonApi customer) {
		PersonDO value = PersonDO.builder()
				.businessEntityId(customer.getBusinessEntityId())
				.personType(customer.getPersonType())
				.nameStyle(customer.getNameStyle())
				.title(customer.getTitle())
				.firstName(customer.getFirstName())
				.middleName(customer.getMiddleName())
				.lastName(customer.getLastName())
				.suffix(customer.getSuffix())
				.emailPromotion(customer.getEmailPromotion())
				.addresses(new ArrayList<>())
				.phones(new ArrayList<>())
				.emailAddresses(new ArrayList<>())
				.build();

		AddressDO valueAddress;
		if (customer.getAddresses() != null) { 
			for (com.trivadis.ms.sample.person.api.AddressApi address : customer.getAddresses()) {
				valueAddress = AddressDO.builder()
						.addressId(address.getId())
						.addressTypeId(address.getAddressTypeId())
						.addressLine1(address.getAddressLine1())
						.addressLine2(address.getAddressLine2())
						.city(address.getCity())
						.stateProvinceId(address.getStateProvinceId())
						.postalcode(address.getPostalCode())
						.build();

				value.getAddresses().add(valueAddress);
			}
		}

		PhoneDO valuePhone;
		if (customer.getPhones() != null) {
			for (com.trivadis.ms.sample.person.api.PhoneApi phone : customer.getPhones()) {
				valuePhone = PhoneDO.builder()
						.phoneNumber(phone.getPhoneNumber())
						.phoneNumberTypeId(phone.getPhoneNumberTypeId())
						.build();

				value.getPhones().add(valuePhone);
			}
		}

		EmailAddressDO valueEmailAddress;
		if (customer.getEmailAddresses() != null) {
			for (com.trivadis.ms.sample.person.api.EmailAddressApi emailAddress : customer.getEmailAddresses()) {
				valueEmailAddress = EmailAddressDO.builder()
						.id(emailAddress.getId())
						.emailAddress(emailAddress.getEmailAddress())
						.build();

				value.getEmailAddresses().add(valueEmailAddress);
			}
		}

		return value;
	}
	
}
