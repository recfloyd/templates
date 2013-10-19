package org.rec.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.rec.dao.OrderDAO;

public class OrderDAOImpl implements OrderDAO {
	private SqlSession sqlSession;

	@Override
	public int findOrderCount() {
		return (Integer) sqlSession.selectOne("findOrderCount");
	}

	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
}
