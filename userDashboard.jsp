<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Quiz App - Home</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;700&display=swap" rel="stylesheet" />
    <!-- Animate.css -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: 'Poppins', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        header {
            background-color: rgba(255, 255, 255, 0.15);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        header h1 {
            font-weight: 700;
            font-size: 45px;
            color: #fff;
            letter-spacing: 2px;
            text-shadow: 1px 1px 5px rgba(0,0,0,0.3);
        }
        nav a {
            margin-left: 25px;
            text-decoration: none;
            color: #ffd700;
            font-weight: 600;
            font-size: 22px;
            transition: color 0.3s ease;
        }
        nav a:hover { color: #fff; }
        nav a.logout {
            color: #ff6b6b;
            font-weight: 700;
        }
        nav a.logout:hover { color: #ff3b3b; }

        main {
            flex-grow: 1;
            padding: 60px 20px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        main h2 {
            font-size: 48px;
            margin-bottom: 15px;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.4);
        }
        main h2 span { color: #ffd700; text-shadow: 2px 2px 10px #ffd700; }
        main p { font-size: 20px; max-width: 600px; margin: 0 auto 40px auto; color: #f0e68c; text-shadow: 1px 1px 5px rgba(0,0,0,0.3); }

        .start-btn {
            background: linear-gradient(45deg, #ffd700, #ffb700);
            color: #4b2e00;
            font-weight: 700;
            font-size: 20px;
            padding: 15px 40px;
            border-radius: 50px;
            text-decoration: none;
            box-shadow: 0 8px 15px rgba(255, 215, 0, 0.4);
            transition: all 0.3s ease;
            display: inline-block;
            position: relative;
            overflow: hidden;
        }
        .start-btn:hover {
            background: linear-gradient(45deg, #ffec70, #ffca00);
            box-shadow: 0 12px 20px rgba(255, 215, 0, 0.7);
            transform: translateY(-3px);
        }
        .start-btn::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 300%;
            height: 300%;
            background: rgba(255, 255, 255, 0.15);
            transform: translate(-50%, -50%) rotate(45deg);
            transition: all 0.5s ease;
            pointer-events: none;
            border-radius: 50%;
        }
        .start-btn:hover::after { width: 400%; height: 400%; background: rgba(255, 255, 255, 0.25); }

        footer {
            background-color: rgba(255, 255, 255, 0.15);
            padding: 15px 20px;
            text-align: center;
            font-size: 14px;
            color: #fff;
            backdrop-filter: blur(10px);
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
        }

        .quiz-icon {
            position: absolute;
            top: 20%;
            right: 10%;
            width: 120px;
            height: 120px;
            opacity: 0.85;
            animation: float 6s ease-in-out infinite;
            filter: drop-shadow(0 0 5px #ffd700);
        }
        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }

        /* Quiz Cards */
        .cards-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
            margin-top: 50px;
        }
        .quiz-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 30px 20px;
            width: 250px;
            color: #fff;
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-align: left;
            position: relative;
            overflow: hidden;
        }
        .quiz-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.4);
        }
        .quiz-card h3 { margin-top: 0; font-size: 22px; color: #ffd700; }
        .quiz-card p { font-size: 16px; color: #f0e68c; }
        .quiz-card a {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background: #ffd700;
            color: #4b2e00;
            font-weight: 600;
            border-radius: 30px;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        .quiz-card a:hover { background: #ffca00; }

        @media (max-width: 768px) {
            main h2 { font-size: 32px; }
            main p { font-size: 16px; }
            .quiz-icon { width: 80px; height: 80px; top: 10%; right: 5%; }
            .cards-container { flex-direction: column; align-items: center; }
        }
    </style>
</head>
<body>

<header>
    <h1 class="animate__animated animate__fadeInDown">Quiz App</h1>
    <nav>
    
        <a href="history.jsp" class="animate__animated animate__fadeInDown animate__delay-1s">View Scores</a>
        <a href="profile.jsp" class="animate__animated animate__fadeInDown animate__delay-1s">Profile</a>
        <a href="LogoutServlet" class="logout animate__animated animate__fadeInDown animate__delay-1s">Logout</a>
    </nav>
</header>

<main>
    <h2 class="animate__animated animate__fadeInUp">Welcome,  <span><%= username %></span> !</h2>
    <p class="animate__animated animate__fadeInUp animate__delay-1s">
        Challenge yourself with quizzes across various topics. Choose a category and start testing your knowledge!
    </p>
    <a href="" class="start-btn animate__animated animate__pulse animate__infinite animate__slow">Start Quiz with Below Selctions</a>

    <!-- Quiz Information Cards -->
    <div class="cards-container animate__animated animate__fadeInUp animate__delay-2s">
    <div class="quiz-card">
        <h3>General Knowledge</h3>
        <p>Test your GK with questions from history, geography, politics and more.</p>
        <a href="level_gk.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Entertainment</h3>
        <p>Movies, music, and TV shows — how much do you really know?</p>
        <a href="level_entertainment.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Sports</h3>
        <p>From cricket to football, challenge your sports knowledge.</p>
        <a href="level_sports.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Science & Technology</h3>
        <p>Physics, chemistry, biology, and latest tech innovations.</p>
        <a href="level_Science_tech.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>History</h3>
        <p>Explore important events and famous personalities from history.</p>
        <a href="level_History.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Geography</h3>
        <p>Countries, capitals, oceans, and continents — test your map skills.</p>
        <a href="level_Geography.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Politics & Current Affairs</h3>
        <p>Stay updated with world leaders, governments, and global issues.</p>
        <a href="level_Politics_CurrentAffairs.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Mathematics & Logic</h3>
        <p>Sharpen your brain with math problems and logical reasoning.</p>
        <a href="level_math_lodgic.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Literature & Art</h3>
        <p>From Shakespeare to Picasso — dive into art and literature.</p>
        <a href="level_Literature_art.jsp">Start Quiz</a>
    </div>

    <div class="quiz-card">
        <h3>Mythology & Culture</h3>
        <p>Explore fascinating stories and traditions from world cultures.</p>
        <a href="level_Mythology_Culture.jsp">Start Quiz</a>
    </div>
      <div class="quiz-card">
        <h3>Tech Langauges</h3>
        <p>Explore the technology language knowledge with future challenge.</p>
        <a href="level.jsp">Start Quiz</a>
    </div>
</div>


    <!-- Floating quiz icon (SVG) -->
    <svg class="quiz-icon" xmlns="http://www.w3.org/2000/svg" fill="#ffd700" viewBox="0 0 64 64" aria-hidden="true">
        <path d="M32 2C15.4 2 2 14.8 2 30.5c0 7.3 3.7 14 9.7 18.5L10 62l13.3-7.1c2.3.6 4.7.9 7.2.9 16.6 0 30-12.8 30-28.5S48.6 2 32 2zm0 50c-2.3 0-4.5-.4-6.5-1.2l-1.5-.6-7.9 4.2 1.5-7.3-1.1-1.3C11.3 44.3 8 38.6 8 32.5 8 19.3 19.8 9 32 9s24 10.3 24 23-11.8 23-24 23z"/>
        <path d="M32 15a15 15 0 1 0 15 15A15 15 0 0 0 32 15zm0 26a11 11 0 1 1 11-11 11 11 0 0 1-11 11z"/>
        <circle cx="32" cy="29" r="4"/>
    </svg>
</main>

<footer>
    &copy; <%= java.time.Year.now() %> Quiz App. All rights reserved by BY Quiz App.
</footer>

</body>
</html>
