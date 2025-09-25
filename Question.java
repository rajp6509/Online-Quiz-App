package quizeApp;

public class Question {
    private int id;
    private String domain;
    private String level;
    private String question;
    private String option1;
    private String option2;
    private String option3;
    private String option4;
    private int correctOption;
    private String category;

    public Question() {}

    // Getters (null safety for strings)
    public int getId() { return id; }
    public String getDomain() { return domain != null ? domain : ""; }
    public String getLevel() { return level != null ? level : ""; }
    public String getQuestion() { return question != null ? question : ""; }
    public String getOption1() { return option1 != null ? option1 : ""; }
    public String getOption2() { return option2 != null ? option2 : ""; }
    public String getOption3() { return option3 != null ? option3 : ""; }
    public String getOption4() { return option4 != null ? option4 : ""; }
    public int getCorrectOption() { return correctOption; }
    public String getCategory() { return category != null ? category : ""; }

    // Setters
    public void setId(int id) { this.id = id; }
    public void setDomain(String domain) { this.domain = domain; }
    public void setLevel(String level) { this.level = level; }
    public void setQuestion(String question) { this.question = question; }
    public void setOption1(String option1) { this.option1 = option1; }
    public void setOption2(String option2) { this.option2 = option2; }
    public void setOption3(String option3) { this.option3 = option3; }
    public void setOption4(String option4) { this.option4 = option4; }
    public void setCorrectOption(int correctOption) { this.correctOption = correctOption; }
    public void setCategory(String category) { this.category = category; }
}
