package com.trivadis.ms.sample.person.service;

import com.trivadis.ms.sample.person.model.PersonDO;
import org.springframework.stereotype.Service;

import java.util.List;

/*
 * Service Layer should be used for Transactional processes
 * 
 * Calls Repository Layers
 * 
 */
@Service
public interface PersonService {

    public List<PersonDO> findAll();
    public PersonDO findById(Long id);

    public void createPerson(PersonDO product);
    public void modifyPerson(PersonDO product);
    public void removePerson(PersonDO product);
}
