<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Session check: Redirect if not admin
    if (session.getAttribute("adminUsername") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String adminUsername = (String) session.getAttribute("adminUsername");

    // Fetch basic stats
    int totalUsers = 0;
    int totalQuestions = 0;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");
        
        PreparedStatement psUsers = con.prepareStatement("SELECT COUNT(*) FROM users");
        ResultSet rsUsers = psUsers.executeQuery();
        if (rsUsers.next()) totalUsers = rsUsers.getInt(1);
        
        PreparedStatement psQuestions = con.prepareStatement("SELECT COUNT(*) FROM questions");
        ResultSet rsQuestions = psQuestions.executeQuery();
        if (rsQuestions.next()) totalQuestions = rsQuestions.getInt(1);
        
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #1e1e2f; color: #eee; margin: 0; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; background: #2c2c44; border-radius: 10px; padding: 30px; }
        .header { text-align: center; margin-bottom: 30px; color: #ffd700; }
        .stats { display: flex; justify-content: space-around; margin-bottom: 30px; }
        .stat-box { background: #444466; padding: 20px; border-radius: 8px; text-align: center; flex: 1; margin: 0 10px; }
        .nav-links { display: flex; justify-content: center; flex-wrap: wrap; gap: 20px; }
        .nav-btn { background: #ffd700; color: #2c2c44; padding: 15px 25px; text-decoration: none; border-radius: 50px; font-weight: bold; transition: background 0.3s; }
        .nav-btn:hover { background: #ffca00; }
        .logout { background: #dc3545 !important; color: white !important; }
        .message { text-align: center; padding: 10px; margin: 10px 0; border-radius: 5px; }
        .success { background: #28a745; color: white; }
        .error { background: #dc3545; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="header">Welcome, Admin <%= adminUsername %>!</h1>
        
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="message success"><%= request.getAttribute("successMessage") %></div>
        <% } %>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="message error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>
        
        <div class="stats">
            <div class="stat-box">
                <h3>Total Users</h3>
                <p><%= totalUsers %></p>
            </div>
            <div class="stat-box">
                <h3>Total Questions</h3>
                <p><%= totalQuestions %></p>
            </div>
        </div>
        
        <div class="nav-links">
            <a href="addQuestion.jsp" class="nav-btn">Add New Question</a>
            <a href="ViewQuestionsServlet" class="nav-btn">View Questions</a>
            <a href="ViewUsersServlet" class="nav-btn">View Users</a>
            <a href="logout.jsp" class="nav-btn logout">Logout</a>
        </div>
    </div>
</body>
</html>