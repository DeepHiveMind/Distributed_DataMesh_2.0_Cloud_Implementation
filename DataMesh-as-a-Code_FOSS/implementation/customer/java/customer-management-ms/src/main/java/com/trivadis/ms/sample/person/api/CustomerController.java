package com.trivadis.ms.sample.person.api;

import com.google.common.base.Preconditions;
import com.trivadis.ms.sample.person.converter.PersonConverter;
import com.trivadis.ms.sample.person.model.PersonDO;
import com.trivadis.ms.sample.person.repository.PersonRepository;
import com.trivadis.ms.sample.person.service.PersonService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;

@RestController()
public class CustomerController {

    private static final Logger LOGGER = LoggerFactory.getLogger(CustomerController.class);

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private PersonService personService;
    
    private void createCustomer(PersonApi personApi) throws ParseException {
        PersonDO personDO = PersonConverter.convert(personApi);
        personService.createPerson(personDO);
        LOGGER.info("Customer created: " + personDO);
    }
    
    private void modifyCustomer(PersonApi personApi) throws ParseException {
        PersonDO personDO = PersonConverter.convert(personApi);
        personService.modifyPerson(personDO);
        LOGGER.info("Customer created: " + personDO);
    }

    @RequestMapping(value= "/api/customers",
            method = RequestMethod.POST,
            consumes = "application/json") 
    @Transactional
    public void postCustomer(@RequestBody PersonApi personApi) throws ParseException {
        Preconditions.checkNotNull(personApi);
        
        createCustomer(personApi);
    }
    
    @RequestMapping(value= "/api/customer",
            method = RequestMethod.PUT,
            consumes = "application/json") 
    @Transactional
    public void putCustomer(@RequestBody PersonApi personApi) throws ParseException {
        Preconditions.checkNotNull(personApi);
        Preconditions.checkNotNull(personApi.getBusinessEntityId());
        
        modifyCustomer(personApi);
    }

    @RequestMapping(
            method = RequestMethod.GET,
            value= "/api/customer/{id}"
    )
    //@CrossOrigin(origins = "http://localhost:4200")
    public PersonApi getCustomer(@PathVariable(value="id") Long id)  {
        PersonApi person = PersonApi.builder().build();
        PersonDO personDO = null;

        if (id != null) {
            personDO = personRepository.findById(id);
        }
        
        if(personDO != null) {
            person = PersonConverter.convert(personDO);
        }
        return person;
    }

    
}