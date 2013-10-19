package org.rec.manager.impl;

import org.rec.dao.OrderDAO;
import org.rec.manager.OrderManager;

public class OrderManagerImpl implements OrderManager {
	private OrderDAO orderDAO;

	@Override
	public int findOrderCount() {
		return orderDAO.findOrderCount();
	}

	public void setOrderDAO(OrderDAO orderDAO) {
		this.orderDAO = orderDAO;
	}

}
