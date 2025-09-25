package quizeApp;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final String DB_URL = "jdbc:mysql://localhost:3306/quizedata";
    private final String DB_USER = "root";
    private final String DB_PASS = "Rajp@123";

    // Handle form submission (POST)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String level = request.getParameter("quizLevel");
        String domain = request.getParameter("domain");

        if(level == null || domain == null || level.isEmpty() || domain.isEmpty()) {
            request.setAttribute("errorMessage", "Please select both level and domain.");
            request.getRequestDispatcher("level.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("quizLevel", level);
        session.setAttribute("domain", domain);

        // Redirect to GET to load questions
        response.sendRedirect("QuizServlet");
    }

    // Load questions and redirect to quiz.jsp
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String level = (String) session.getAttribute("quizLevel");
        String domain = (String) session.getAttribute("domain");

        if(level == null || domain == null) {
            response.sendRedirect("level.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "SELECT * FROM questions WHERE domain=? AND level=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, domain);
            ps.setString(2, level);
            ResultSet rs = ps.executeQuery();

            ArrayList<Question> questions = new ArrayList<>();
            while(rs.next()) {
                questions.add(new Question(
                    rs.getInt("id"),
                    rs.getString("question"),
                    rs.getString("option1"),
                    rs.getString("option2"),
                    rs.getString("option3"),
                    rs.getString("option4"),
                    rs.getInt("correct_option")
                ));
            }

            Collections.shuffle(questions);

            session.setAttribute("questions", questions);
            session.setAttribute("currentIndex", 0);
            session.setAttribute("score", 0);

            conn.close();

            response.sendRedirect("quizequestion.jsp"); // quiz page
        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading questions.");
            request.getRequestDispatcher("level.jsp").forward(request, response);
        }
    }

    // Question class
    public static class Question {
        public int id;
        public String question;
        public String option1, option2, option3, option4;
        public int correct_option;

        public Question(int id, String question, String option1, String option2, String option3, String option4, int correct_option) {
            this.id = id;
            this.question = question;
            this.option1 = option1;
            this.option2 = option2;
            this.option3 = option3;
            this.option4 = option4;
            this.correct_option = correct_option;
        }
    }
}
