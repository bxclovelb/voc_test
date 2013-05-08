package dao.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.jdbc.core.support.JdbcDaoSupport;

import pojo.Question;
import dao.VocTestDao;

public class VocTestDaoImpl extends JdbcDaoSupport implements VocTestDao {

	@Override
	public Question getQuestion(int index) throws Exception{
		SAXReader reader = new SAXReader();
		String path = Thread.currentThread().getContextClassLoader().getResource("../..").getPath().toString().replace("%20", " ") + "res/voc/"+index+".xml";
		Document doc = reader.read(new File(path));
		Element root = doc.getRootElement();
		Random rand = new Random();
		Element element = (Element) root.elements().get(rand.nextInt(root.elements().size()));
		Question question = new Question();
		question.setId(Long.parseLong(((Element)element.elements().get(0)).getText()));
		question.setWord(((Element)element.elements().get(1)).getText());
		List options = new ArrayList();
		options.add(((Element)element.elements().get(2)).getText());
		options.add(((Element)element.elements().get(3)).getText());
		options.add(((Element)element.elements().get(4)).getText());
		options.add(((Element)element.elements().get(5)).getText());
		question.setOptions(options);
		return question;
	}

	@Override
	public void saveVocabulary(String userId,int vocabulary) {
		int count = this.getJdbcTemplate().queryForInt("SELECT COUNT(*) "+
			"FROM voc_test_users_vocabulary WHERE user_id = '"+userId+"'");
		if(count == 0){
			this.getJdbcTemplate().update(
				"INSERT INTO voc_test_users_vocabulary(user_id,vocabulary) " +
				"VALUES('"+userId+"',"+vocabulary+")");
		}else{
			this.getJdbcTemplate().update(
				"UPDATE voc_test_users_vocabulary SET vocabulary="+vocabulary+
				" WHERE user_id = '"+userId+"'");
		}
	}
}
