<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, quizeApp.ViewUsersServlet.UserInfo" %>
<%
    if (session.getAttribute("adminUsername") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    List<UserInfo> users = (List<UserInfo>) request.getAttribute("users");
    if (users == null) users = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Users</title>
    <style>
        body { font-family: Arial, sans-serif; background: #1e1e2f; color: #eee; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; background: #2c2c44; padding: 30px; border-radius: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #555; }
        th { background: #444466; color: #ffd700; }
        .no-data { text-align: center; color: #ffd700; font-style: italic; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #ffd700; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <a href="adminDashboard.jsp" class="back-link">← Back to Dashboard</a>
        <h2>Registered Users</h2>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <p style="color: red; text-align:center;"><%= request.getAttribute("errorMessage") %></p>
        <% } %>

        <% if (users.isEmpty()) { %>
            <p class="no-data">No users found.</p>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>User Name</th>
                        <th>Creation Time</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (UserInfo u : users) { %>
                        <tr>
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getCreatedAt() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</body>
</html>
