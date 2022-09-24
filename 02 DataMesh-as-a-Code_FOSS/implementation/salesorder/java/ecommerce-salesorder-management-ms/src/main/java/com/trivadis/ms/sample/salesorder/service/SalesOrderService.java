package com.trivadis.ms.sample.salesorder.service;

import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import org.springframework.stereotype.Service;

/*
 * Service Layer should be used for Transactional processes
 * 
 * Calls Repository Layers
 * 
 */
@Service
public interface SalesOrderService {
    public void submitNewOnlineOrder(SalesOrderDO salesOrder);
}
