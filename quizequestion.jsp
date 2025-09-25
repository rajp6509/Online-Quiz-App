<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="quizeApp.QuizServlet.Question" %>

<%
    ArrayList<Question> questions = (ArrayList<Question>) session.getAttribute("questions");
    Integer currentIndex = (Integer) session.getAttribute("currentIndex");
    Integer score = (Integer) session.getAttribute("score");
    String domain = (String) session.getAttribute("domain");

    if(questions == null || currentIndex == null || domain == null) {
        response.sendRedirect("level.jsp");
        return;
    }

    Question currentQuestion = null;
    if(currentIndex < questions.size()) {
        currentQuestion = questions.get(currentIndex);
    }

    String feedback = (String) request.getAttribute("feedback");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= domain %> Quiz</title>
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: #333;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }
    .quiz-container {
        background: #fff;
        padding: 30px;
        border-radius: 15px;
        width: 600px;
        max-width: 90%;
        box-shadow: 0px 8px 20px rgba(0,0,0,0.2);
    }
    h2 {
        text-align: center;
        color: #444;
        margin-bottom: 20px;
    }
    .progress {
        background: #eee;
        border-radius: 10px;
        overflow: hidden;
        margin-bottom: 20px;
    }
    .progress-bar {
        height: 15px;
        background: #4CAF50;
        width: 0%;
        transition: width 0.4s ease;
    }
    .question {
        font-size: 18px;
        margin-bottom: 15px;
    }
    .options label {
        display: block;
        margin: 10px 0;
        border: 2px solid #ccc;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.3s ease;
    }
    .options input {
        display: none;
    }
    .options span {
        display: block;
        padding: 12px;
        border-radius: 8px;
    }
    /* Hover effect */
    .options label:hover span {
        background: #f1f1f1;
        border-radius: 8px;
    }
    /* ✅ Selected option */
    .options input:checked + span {
        background: #4CAF50;
        color: #fff;
        font-weight: bold;
        border: 2px solid #4CAF50;
    }
    button {
        width: 100%;
        padding: 12px;
        margin-top: 20px;
        background: #4CAF50;
        color: #fff;
        font-size: 16px;
        font-weight: bold;
        border: none;
        border-radius: 10px;
        cursor: pointer;
        transition: background 0.3s ease;
    }
    button:hover {
        background: #45a049;
    }
    .feedback {
        margin-top: 15px;
        font-size: 16px;
        font-weight: bold;
        text-align: center;
    }
    .correct { color: green; }
    .wrong { color: red; }
    .result {
        text-align: center;
    }
    .result h2 {
        color: #2a5298;
    }
    .actions a {
        display: inline-block;
        margin: 10px;
        padding: 12px 20px;
        text-decoration: none;
        color: #fff;
        background: #764ba2;
        border-radius: 8px;
        font-weight: bold;
        transition: background 0.3s ease;
    }
    .actions a:hover {
        background: #5a3d85;
    }
</style>
</head>
<body>

<div class="quiz-container">
    <% if(currentQuestion != null) { %>
        <h2><%= domain %> Quiz</h2>

        <!-- Progress bar -->
        <div class="progress">
            <div class="progress-bar" style="width: <%= ((currentIndex+1)*100/questions.size()) %>%"></div>
        </div>
        <p style="text-align:right; font-size:14px; color:#555;">
            Question <%= currentIndex+1 %> of <%= questions.size() %>
        </p>

        <!-- Question -->
        <div class="question"><b>Q<%= currentIndex+1 %>:</b> <%= currentQuestion.question %></div>

        <!-- Options -->
        <form method="post" action="answerHandler" class="options">
            <label><input type="radio" name="answer" value="1" required><span><%= currentQuestion.option1 %></span></label>
            <label><input type="radio" name="answer" value="2"><span><%= currentQuestion.option2 %></span></label>
            <label><input type="radio" name="answer" value="3"><span><%= currentQuestion.option3 %></span></label>
            <label><input type="radio" name="answer" value="4"><span><%= currentQuestion.option4 %></span></label>
            <button type="submit">Submit Answer</button>
        </form>

        <!-- Feedback -->
        <% if(feedback != null){ %>
            <div class="feedback <%= feedback.startsWith("Correct") ? "correct" : "wrong" %>">
                <%= feedback %>
            </div>
        <% } %>

        <p style="margin-top:15px; text-align:center; color:#666;">
            Current Score: <b><%= score %></b>
        </p>

    <% } else { %>
        <!-- Quiz Completed -->
        <div class="result">
            <h2>🎉 Quiz Completed!</h2>
            <p>Your Score: <b><%= score %></b> / <%= questions.size() %></p>
            <div class="actions">
                <a href="level.jsp">🔙 Take Another Quiz</a>
                <a href="history.jsp">📜 View History</a>
            </div>
        </div>
    <% } %>
</div>

</body>
</html>
