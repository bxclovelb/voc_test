package dao;

import java.io.IOException;

import pojo.Question;

public interface VocTestDao {
	public Question getQuestion(int index) throws Exception;
}
