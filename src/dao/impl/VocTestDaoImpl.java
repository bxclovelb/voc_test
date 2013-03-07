package dao.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import pojo.Question;
import dao.VocTestDao;

public class VocTestDaoImpl implements VocTestDao {

	@Override
	public Question getQuestion(int index) throws Exception{
		SAXReader reader = new SAXReader();
		String path = Thread.currentThread().getContextClassLoader().getResource("../..").getPath().toString() + "res/voc/"+index+".xml";
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
		System.out.println(question);
		return question;
	}

}
