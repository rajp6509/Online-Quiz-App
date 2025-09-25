<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("adminUsername") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<String> domains = (List<String>) request.getAttribute("domains");
    if (domains == null) domains = new java.util.ArrayList<>();

    List<String> categories = (List<String>) request.getAttribute("categories");
    if (categories == null) categories = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Question</title>
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
        <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message success"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

        <h2>Add New Question</h2>
        <form action="AddQuestionServlet" method="post">
            <div class="form-group">
                <label>Domain:</label>
                <input list="domainList" name="domain" required placeholder="Enter domain (e.g., Java, Python)">
                <datalist id="domainList">
                    <% for (String d : domains) { %>
                        <option value="<%= d %>">
                    <% } %>
                </datalist>
            </div>

            <div class="form-group">
                <label>Level:</label>
                <select name="level" required>
                    <option value="easy">Easy</option>
                    <option value="medium">Medium</option>
                    <option value="hard">Hard</option>
                </select>
            </div>

            <div class="form-group">
                <label>Question Text:</label>
                <textarea name="questionText" required placeholder="Enter the question..."></textarea>
            </div>

            <div class="form-group">
                <label>Option 1:</label>
                <input type="text" name="option1" required>
            </div>
            <div class="form-group">
                <label>Option 2:</label>
                <input type="text" name="option2" required>
            </div>
            <div class="form-group">
                <label>Option 3:</label>
                <input type="text" name="option3" required>
            </div>
            <div class="form-group">
                <label>Option 4:</label>
                <input type="text" name="option4" required>
            </div>

            <div class="form-group">
                <label>Correct Option (1-4):</label>
                <input type="number" name="correctOption" min="1" max="4" required>
            </div>

            <div class="form-group">
                <label>Category:</label>
                <select name="category">
                    <option value="">--Select Category--</option>
                    <% for (String c : categories) { %>
                        <option value="<%= c %>"><%= c %></option>
                    <% } %>
                  
                </select>
            </div>

           

            <button type="submit">Add Question</button>
        </form>
    </div>

  
</body>
</html>
