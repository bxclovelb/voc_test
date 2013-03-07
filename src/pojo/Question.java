package pojo;

import java.util.List;

public class Question {
	private long id;
	
	private String word;
	
	private List options;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getWord() {
		return word;
	}

	public void setWord(String word) {
		this.word = word;
	}

	public List getOptions() {
		return options;
	}

	public void setOptions(List options) {
		this.options = options;
	}

	public Question(long id, String word, List options) {
		super();
		this.id = id;
		this.word = word;
		this.options = options;
	}
	
	public Question() {
		super();
	}

	@Override
	public String toString() {
		return "Question [id=" + id + ", word=" + word + ", options=" + options
				+ "]";
	}
	
}
