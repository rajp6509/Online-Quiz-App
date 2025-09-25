<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // DB connection details
    String DB_URL = "jdbc:mysql://localhost:3306/quizedata";
    String DB_USER = "root";
    String DB_PASS = "Rajp@123";

    // Store quiz history
    ArrayList<HashMap<String, Object>> history = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        PreparedStatement ps = conn.prepareStatement(
            "SELECT * FROM quiz_attempts ORDER BY attempt_id DESC"
        );
        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
            HashMap<String, Object> record = new HashMap<>();
            record.put("userId", rs.getInt("user_id"));
            record.put("domain", rs.getString("domain"));
            record.put("level", rs.getString("level"));
            record.put("score", rs.getInt("score"));
            record.put("total", rs.getInt("total_questions"));
            record.put("date", rs.getTimestamp("attempt_time"));
            history.add(record);
        }

        rs.close();
        ps.close();
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Quiz History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #4facfe, #00f2fe);
            font-family: 'Segoe UI', sans-serif;
        }
        .history-card {
            margin-top: 50px;
            padding: 25px;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
        }
        table th, table td {
            text-align: center;
        }
        .btn-custom {
            border-radius: 30px;
            padding: 8px 20px;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="history-card">
            <h2 class="text-center mb-4">📜 All Users Quiz History</h2>
            
            <div class="d-flex justify-content-center mb-3">
                <a href="userDashboard.jsp" class="btn btn-primary btn-custom me-2">Take New Quiz</a>
                <a href="userDashboard.jsp" class="btn btn-success btn-custom">Home</a>
            </div>
            
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Index no</th>
                        
                        <th>Domain</th>
                        <th>Level</th>
                        <th>Score</th>
                        <th>Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if(history.size() == 0){
                    %>
                    <tr>
                        <td colspan="6">No quiz attempts found.</td>
                    </tr>
                    <%
                        } else {
                            int count = 1;
                            for(HashMap<String, Object> h : history){
                    %>
                    <tr>
                        <td><%= count++ %></td>
                        
                        <td><%= h.get("domain") %></td>
                        <td><%= h.get("level") %></td>
                        <td><%= h.get("score") %> / <%= h.get("total") %></td>
                        <td><%= h.get("date") %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
