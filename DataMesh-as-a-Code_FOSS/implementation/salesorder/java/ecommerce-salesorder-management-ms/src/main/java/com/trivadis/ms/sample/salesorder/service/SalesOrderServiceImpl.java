package com.trivadis.ms.sample.salesorder.service;

import com.trivadis.ms.sample.salesorder.model.OrderStatusEnum;
import com.trivadis.ms.sample.salesorder.model.SalesOrderDO;
import com.trivadis.ms.sample.salesorder.outbox.EventPublisher;
import com.trivadis.ms.sample.salesorder.repository.CreditCardRepository;
import com.trivadis.ms.sample.salesorder.repository.SalesOrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.Instant;

@Service
public class SalesOrderServiceImpl implements SalesOrderService {

	@Autowired
	private SalesOrderRepository salesOrderRepository;
	@Autowired
	private CreditCardRepository creditCardRepository;
	/**
	 * Handle to the Outbox Eventing framework.
	 */
	@Autowired
	private EventPublisher eventPublisher;

	@Autowired
	private EventUtils eventUtils;

	@Override
	@Transactional
	public void submitNewOnlineOrder(SalesOrderDO salesOrder) {

		if (!creditCardRepository.existsById(salesOrder.getCreditCard().getId())) {
			creditCardRepository.save(salesOrder.getCreditCard());
		}
		// TODO make sure if it already exists, that it works

		/*
		 * Persist Sales Order as a new order (automatically APPROVED)
		 */
		salesOrder.setStatus(OrderStatusEnum.APPROVED);
		salesOrder.setOrderDate(Instant.now());
		salesOrder.setOnlineChannel(true);
		salesOrderRepository.save(salesOrder);

		//Publish the event
		eventPublisher.fire(eventUtils.createSalesOrderSubmitEvent(salesOrder));

	}

	 
}
