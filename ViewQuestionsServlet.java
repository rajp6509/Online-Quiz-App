package quizeApp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ViewQuestionsServlet")
public class ViewQuestionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // DB connection details (your existing)
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/quizedata";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Rajp@123";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Don't create new session if invalid
        if (session == null || session.getAttribute("adminUsername") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Question> questions = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
            String sql = "SELECT * FROM questions ORDER BY id DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setDomain(rs.getString("domain")); // FIXED: Added domain from schema
                q.setLevel(rs.getString("level"));    // FIXED: level instead of difficulty
                q.setQuestion(rs.getString("question")); // FIXED: question instead of question_text
                q.setOption1(rs.getString("option1"));
                q.setOption2(rs.getString("option2"));
                q.setOption3(rs.getString("option3"));
                q.setOption4(rs.getString("option4"));
                q.setCorrectOption(rs.getInt("correct_option"));
                q.setCategory(rs.getString("category")); // Added category from schema
                questions.add(q);
            }
            
            request.setAttribute("questions", questions);
            // Optional: Success message
            request.setAttribute("successMessage", questions.size() + " questions loaded successfully!");

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database driver not found. Check MySQL JDBC setup.");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage() + ". Ensure 'questions' table exists with correct schema.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
        } finally {
            // Clean up resources to prevent leaks
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        RequestDispatcher rd = request.getRequestDispatcher("viewQuestions.jsp");
        rd.forward(request, response);
    }

    // Updated Question class to match schema (added domain, level, category; renamed questionText to question)
}
