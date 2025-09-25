<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, quizeApp.Question" %>
<%
    // Session check
    if (session.getAttribute("adminUsername") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    if (questions == null) questions = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Questions</title>
    <style>
        body { font-family: Arial, sans-serif; background: #1e1e2f; color: #eee; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; background: #2c2c44; padding: 30px; border-radius: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #555; }
        th { background: #444466; color: #ffd700; }
        .options { font-size: 14px; }
        .actions { text-align: center; }
        .edit-btn, .delete-btn { padding: 5px 10px; margin: 0 5px; border-radius: 5px; text-decoration: none; font-size: 14px; }
        .edit-btn { background: #28a745; color: white; }
        .delete-btn { background: #dc3545; color: white; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #ffd700; text-decoration: none; }
        .no-data { text-align: center; color: #ffd700; font-style: italic; }
    </style>
</head>
<body>
    <div class="container">
        <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
        <h2>Manage Questions</h2>
        
        <% if (questions.isEmpty()) { %>
            <p class="no-data">No questions available. <a href="addQuestion.jsp">Add one now!</a></p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Question</th>
                        <th>Options</th>
                        <th>Correct Option</th>
                        <th>Difficulty</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Question q : questions) { %>
                        <tr>
                            <td><%= q.getId() %></td>
                            <td><%= q.getQuestion() %></td>
                            <td class="options">
                                1. <%= q.getOption1() %><br>
                                2. <%= q.getOption2() %><br>
                                3. <%= q.getOption3() %><br>
                                4. <%= q.getOption4() %>
                            </td>
                            <td><%= q.getCorrectOption() %></td>
                            <td><%= q.getLevel() %></td>
                            <td class="actions">
                                <a href="editQuestion.jsp?id=<%= q.getId() %>" class="edit-btn">Edit</a>
                                <a href="DeleteQuestionServlet?id=<%= q.getId() %>" class="delete-btn" onclick="return confirm('Delete this question?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>