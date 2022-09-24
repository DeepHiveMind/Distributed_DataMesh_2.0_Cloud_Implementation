package com.trivadis.ms.sample.person.repository;

import com.trivadis.ms.sample.person.model.PersonDO;


/*
 * Repository Layer is responsible for retrival of data
 */
public interface PersonRepository {

    public PersonDO findById(Long id);

    public void save (PersonDO customer);

}
