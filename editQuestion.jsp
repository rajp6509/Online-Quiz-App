<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, quizeApp.Question" %>
<%
    // Session check
    if (session.getAttribute("adminUsername") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Fetch question by ID if not already in request (for direct access via ?id=)
    Question question = (Question) request.getAttribute("question");
    int questionId = Integer.parseInt(request.getParameter("id"));
    if (question == null || question.getId() != questionId) {
        question = new Question();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM questions WHERE id = ?");
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                question.setId(rs.getInt("id"));
                question.setQuestion(rs.getString("question"));
                question.setOption1(rs.getString("option1"));
                question.setOption2(rs.getString("option2"));
                question.setOption3(rs.getString("option3"));
                question.setOption4(rs.getString("option4"));
                question.setCorrectOption(rs.getInt("correct_option"));
                question.setLevel(rs.getString("level"));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Question not found!");
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Question</title>
    <style>
        body { font-family: Arial, sans-serif; background: #1e1e2f; color: #eee; padding: 20px; }
        .container { max-width: 700px; margin: 0 auto; background: #2c2c44; padding: 30px; border-radius: 10px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #ffd700; }
        input, textarea, select { width: 100%; padding: 10px; border: 1px solid #555; border-radius: 5px; background: #444; color: #eee; }
        textarea { height: 100px; resize: vertical; }
        button { background: #ffd700; color: #2c2c44; padding: 12px 30px; border: none; border-radius: 50px; cursor: pointer; font-weight: bold; width: 100%; }
        button:hover { background: #ffca00; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #ffd700; text-decoration: none; }
        .message { text-align: center; padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background: #28a745; color: white; }
        .error { background: #dc3545; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <a href="ViewQuestionsServlet" class="back-link">← Back to Questions</a>
        
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message success"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        
        <% if (question.getId() == 0) { %>
            <p class="error">Question not found!</p>
        <% } else { %>
            <h2>Edit Question ID: <%= question.getId() %></h2>
            <form action="UpdateQuestionServlet" method="post">
                <input type="hidden" name="id" value="<%= question.getId() %>">
                <div class="form-group">
                    <label>Question Text:</label>
                    <textarea name="question" required><%= question.getQuestion() %></textarea>
                </div>
                <div class="form-group">
                    <label>Option 1:</label>
                    <input type="text" name="option1" value="<%= question.getOption1() %>" required>
                </div>
                <div class="form-group">
                    <label>Option 2:</label>
                    <input type="text" name="option2" value="<%= question.getOption2() %>" required>
                </div>
                <div class="form-group">
                    <label>Option 3:</label>
                    <input type="text" name="option3" value="<%= question.getOption3() %>" required>
                </div>
                <div class="form-group">
                    <label>Option 4:</label>
                    <input type="text" name="option4" value="<%= question.getOption4() %>" required>
                </div>
                <div class="form-group">
                    <label>Correct Option (1-4):</label>
                    <input type="number" name="correctOption" value="<%= question.getCorrectOption() %>" min="1" max="4" required>
                </div>
                <div class="form-group">
                    <label>Difficulty:</label>
                    <select name="difficulty" required>
                        <option value="easy" <%= "easy".equals(question.getLevel()) ? "selected" : "" %>>Easy</option>
                        <option value="medium" <%= "medium".equals(question.getLevel()) ? "selected" : "" %>>Medium</option>
                        <option value="hard" <%= "hard".equals(question.getLevel()) ? "selected" : "" %>>Hard</option>
                    </select>
                </div>
                <button type="submit">Update Question</button>
            </form>
        <% } %>
    </div>
</body>
</html>