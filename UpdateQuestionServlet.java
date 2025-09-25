package quizeApp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import quizeApp.*;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateQuestionServlet")
public class UpdateQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("adminUsername") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String question = request.getParameter("question");
        String option1 = request.getParameter("option1");
        String option2 = request.getParameter("option2");
        String option3 = request.getParameter("option3");
        String option4 = request.getParameter("option4");
        int correctOption = Integer.parseInt(request.getParameter("correctOption"));
        String level = request.getParameter("difficulty");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");
            String sql = "UPDATE questions SET question = ?, option1 = ?, option2 = ?, option3 = ?, option4 = ?, correct_option = ?, level = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, question);
            ps.setString(2, option1);
            ps.setString(3, option2);
            ps.setString(4, option3);
            ps.setString(5, option4);
            ps.setInt(6, correctOption);
            ps.setString(7, level);
            ps.setInt(8, id);
            ps.executeUpdate();
            con.close();
            request.setAttribute("successMessage", "Question updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to update question!");
        }

        // Fetch the updated question for display in edit form
        Question q = fetchQuestionById(id);
        request.setAttribute("question", q);
        RequestDispatcher rd = request.getRequestDispatcher("editQuestion.jsp");
        rd.forward(request, response);
    }

    // Helper to fetch single question
    private Question fetchQuestionById(int id) {
        Question q = new Question();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM questions WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                q.setId(rs.getInt("id"));
                q.setQuestion(rs.getString("question"));
                q.setOption1(rs.getString("option1"));
                q.setOption2(rs.getString("option2"));
                q.setOption3(rs.getString("option3"));
                q.setOption4(rs.getString("option4"));
                q.setCorrectOption(rs.getInt("correct_option"));
                q.setLevel(rs.getString("level"));
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return q;
    }
}