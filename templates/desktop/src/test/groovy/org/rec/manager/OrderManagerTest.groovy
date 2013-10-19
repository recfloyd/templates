package org.rec.manager

import static org.junit.Assert.*;

import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractJUnit4SpringContextTests;

@ContextConfiguration(locations=['classpath:spring/applicationContext*.xml'])
class OrderManagerTest extends AbstractJUnit4SpringContextTests {
	@Autowired
	OrderManager orderManager
	@Test
	void testFindOrderCount() {
		println orderManager.findOrderCount()
	}
}
