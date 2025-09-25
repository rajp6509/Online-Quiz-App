<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="quizeApp.QuizServlet.Question" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>

<%
    HttpSession userSession = request.getSession(false); 
    if (userSession == null) {
        response.sendRedirect("level.jsp");
        return;
    }

    Integer score = (Integer) userSession.getAttribute("score");
    ArrayList<Question> questions = (ArrayList<Question>) userSession.getAttribute("questions");
    String domain = (String) userSession.getAttribute("domain");
    String level = (String) userSession.getAttribute("quizLevel");

    if (score == null || questions == null || domain == null || level == null) {
        response.sendRedirect("level.jsp");
        return;
    }

    int total = questions.size();
    int percentage = (int) (((double) score / total) * 100);

    // Store result in DB
    String DB_URL = "jdbc:mysql://localhost:3306/quizedata";
    String DB_USER = "root";
    String DB_PASS = "Rajp@123";
    int userId = 1; // Demo static user ID

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO quiz_attempts(user_id, domain, level, score, total_questions) VALUES(?,?,?,?,?)"
        );
        ps.setInt(1, userId);
        ps.setString(2, domain);
        ps.setString(3, level);
        ps.setInt(4, score);
        ps.setInt(5, total);
        ps.executeUpdate();
        ps.close();
        conn.close();
    } catch(Exception e) {
        e.printStackTrace();
    }

    // Clear session after saving
    userSession.removeAttribute("questions");
    userSession.removeAttribute("currentIndex");
    userSession.removeAttribute("score");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quiz Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(to right, #6a11cb, #2575fc);
            font-family: 'Segoe UI', sans-serif;
        }
        .result-card {
            margin-top: 80px;
            border-radius: 15px;
            box-shadow: 0px 10px 30px rgba(0,0,0,0.3);
            background: #fff;
            padding: 40px;
            text-align: center;
            animation: fadeIn 1s ease-in-out;
        }
        .score {
            font-size: 2.5rem;
            font-weight: bold;
            color: #2575fc;
        }
        .btn-custom {
            border-radius: 30px;
            padding: 10px 25px;
            font-weight: 600;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container d-flex justify-content-center">
        <div class="col-md-6 result-card">
            <h2 class="mb-4">🎉 Quiz Completed!</h2>
            <p class="score"><%= score %> / <%= total %></p>
            <p class="mb-3"><b>Domain:</b> <%= domain %> | <b>Level:</b> <%= level %></p>
            
            <!-- Progress Bar -->
            <div class="progress my-4" style="height: 25px; border-radius: 12px;">
                <div class="progress-bar 
                    <%= (percentage >= 70 ? "bg-success" : (percentage >= 40 ? "bg-warning" : "bg-danger")) %>" 
                    role="progressbar" 
                    style="width: <%= percentage %>%;">
                    <%= percentage %>%
                </div>
            </div>

            <div class="d-flex justify-content-around mt-4">
                <a href="level.jsp" class="btn btn-primary btn-custom">🔄 Take Another Quiz</a>
                <a href="history.jsp" class="btn btn-success btn-custom">📜 View Past Attempts</a>
            </div>
        </div>
    </div>
</body>
</html>
