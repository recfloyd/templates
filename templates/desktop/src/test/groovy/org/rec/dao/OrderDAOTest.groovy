package org.rec.dao

import static org.junit.Assert.*;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

@ContextConfiguration(locations=['classpath:spring/applicationContext*.xml'])
class OrderDAOTest extends AbstractJUnit4SpringContextTests {
	@Autowired
	OrderDAO orderDAO
	
	@Test
	void testFindOrderCount() {
		println orderDAO.findOrderCount()
	}
}
