package com.trivadis.ms.sample.salesorder.repository;

import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


/**
 * This interface provides handles to database, to perform CRUD operations on the table `STUDENT`.
 * The table is represented by the JPA entity {@link SalesOrderDO}.
 *
 * @see JpaRepository
 */
@Repository
public interface SalesOrderRepository extends JpaRepository<SalesOrderDO, Long> {
}
