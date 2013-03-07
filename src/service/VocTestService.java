package service;

import pojo.Question;
import dao.VocTestDao;

public class VocTestService {
	private VocTestDao vocTestDao;

	public void setVocTestDao(VocTestDao vocTestDao) {
		this.vocTestDao = vocTestDao;
	}
	
	public Question getQuestion(int index){
		Question question = null;
		try {
			question = vocTestDao.getQuestion(index);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return question;
	}
	
	public void saveVocabulary(String userId,int vocabulary){
		vocTestDao.saveVocabulary(userId, vocabulary);
	}
}
