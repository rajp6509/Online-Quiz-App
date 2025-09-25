<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Select Quiz Level & Domain</title>
<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
    font-family: Arial, sans-serif;
    background-image: url("images/istockphoto-857045822-612x612.jpg");
    background-size: cover;
    background-position: center;
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
}
.container {
    background-color: rgba(255,255,255,0.95);
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 0 20px rgba(0,0,0,0.3);
    max-width: 800px;
    width: 90%;
    text-align: center;
}
h2 { margin-bottom: 25px; color:#333; }
.cards-section { display: flex; flex-wrap: wrap; justify-content: center; gap: 20px; margin-bottom: 30px; }
.card {
    background-color: #4CAF50;
    color: white;
    padding: 20px 30px;
    border-radius: 15px;
    cursor: pointer;
    width: 150px;
    font-weight: bold;
    font-size: 18px;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
    transform: translateY(-8px);
    box-shadow: 0 12px 25px rgba(0,0,0,0.4);
}
.card.selected { background-color: #45a049; box-shadow: 0 12px 25px rgba(0,0,0,0.6); }
button {
    background-color:#2196F3;
    color:white;
    border:none;
    padding: 12px 30px;
    font-size: 18px;
    border-radius: 10px;
    cursor:pointer;
    font-weight:bold;
    transition: background 0.3s ease;
}
button:hover { background-color:#0b7dda; }
.error { color:red; font-weight:bold; margin-top:15px; }
</style>
</head>
<body>

<div class="container">
    <h2>Select Quiz Level & Domain</h2>
    
    <form action="QuizServlet" method="post" id="quizForm">
        <!-- Level Selection Cards -->
        <h3>Choose Level</h3>
        <div class="cards-section" id="levelCards">
            <div class="card" data-value="easy">Easy</div>
            <div class="card" data-value="medium">Medium</div>
            <div class="card" data-value="hard">Hard</div>
        </div>
        <input type="hidden" name="quizLevel" id="quizLevel" required>
        
        <!-- Domain Selection Cards -->
        <h3>Choose Domain</h3>
        <div class="cards-section" id="domainCards">
            <%
                String DB_URL = "jdbc:mysql://localhost:3306/quizedata";
                String DB_USER = "root";
                String DB_PASS = "Rajp@123";

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    String sql = "SELECT DISTINCT domain FROM questions WHERE category='Mythology & Culture'";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
                        String domain = rs.getString("domain");
            %>
                        <div class="card" data-value="<%= domain %>"><%= domain %></div>
            <%
                    }
                    rs.close();
                    ps.close();
                    conn.close();
                } catch(Exception e) {
                    out.println("<p class='error'>Error loading domains</p>");
                    e.printStackTrace();
                }
            %>
        </div>
        <input type="hidden" name="domain" id="domain" required>

        <button type="submit">Start Quiz</button>
    </form>

    <%
        String errorMsg = (String) request.getAttribute("errorMessage");
        if (errorMsg != null) {
    %>
        <p class="error"><%= errorMsg %></p>
    <% } %>
</div>

<script>
    // Handle Level Selection
    const levelCards = document.querySelectorAll('#levelCards .card');
    const levelInput = document.getElementById('quizLevel');
    levelCards.forEach(card => {
        card.addEventListener('click', () => {
            levelCards.forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            levelInput.value = card.getAttribute('data-value');
        });
    });

    // Handle Domain Selection
    const domainCards = document.querySelectorAll('#domainCards .card');
    const domainInput = document.getElementById('domain');
    domainCards.forEach(card => {
        card.addEventListener('click', () => {
            domainCards.forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            domainInput.value = card.getAttribute('data-value');
        });
    });

    // Optional: Form validation before submit
    document.getElementById('quizForm').addEventListener('submit', function(e){
        if(!levelInput.value || !domainInput.value){
            e.preventDefault();
            alert('Please select both level and domain!');
        }
    });
</script>

</body>
</html>
