package dao;

import java.io.IOException;

import pojo.Question;

public interface VocTestDao {
	public Question getQuestion(int index) throws Exception;
	public void saveVocabulary(String userId,int vocabulary);
}
