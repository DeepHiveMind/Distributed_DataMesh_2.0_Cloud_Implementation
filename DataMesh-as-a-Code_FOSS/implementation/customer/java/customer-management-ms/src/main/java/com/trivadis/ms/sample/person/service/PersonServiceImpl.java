package com.trivadis.ms.sample.person.service;

import com.trivadis.ms.sample.person.model.PersonDO;
import com.trivadis.ms.sample.person.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class PersonServiceImpl implements PersonService {
	
	@Autowired
	private PersonRepository personRepository;

	public List<PersonDO> findAll() {
		return null;
//		return customerRepository.findAll();
	}
	
	public PersonDO findById(Long id) {
		return personRepository.findById(id);
	}

		
	@Override
	public void createPerson(PersonDO customer) {
		/*
		 * Persist person
		 */
		personRepository.save(customer);
	}
	
	@Override
	public void modifyPerson(PersonDO customer) {
		/*
		 * Persist person
		 */
		// personRepository.save(person);

	}
	
	@Override
	public void removePerson(PersonDO customer) {
		/*
		 * Persist person
		 */
		//personRepository.remove(person);

	}
	
	 
}
