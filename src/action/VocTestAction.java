package action;

import org.apache.struts2.json.annotations.JSON;

import pojo.Question;
import service.VocTestService;

import com.opensymphony.xwork2.ActionSupport;

public class VocTestAction extends ActionSupport {
	private String userId;
	private int nextLevel;
	private Question question;
	
	private VocTestService vocTestService;
	
	@JSON(serialize=false)
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	@JSON(serialize=false)
	public VocTestService getVocTestService() {
		return vocTestService;
	}

	public void setVocTestService(VocTestService vocTestService) {
		this.vocTestService = vocTestService;
	}

	@JSON(serialize=false)
	public int getNextLevel() {
		return nextLevel;
	}

	public void setNextLevel(int nextLevel) {
		this.nextLevel = nextLevel;
	}

	@JSON(serialize=true)
	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}
	

	public String showPage(){
		return SUCCESS;
	}
	
	public String loadQuestion(){
		System.out.println(nextLevel);
		Question question = vocTestService.getQuestion(nextLevel);
		setQuestion(question);
		return SUCCESS;
	}
}
