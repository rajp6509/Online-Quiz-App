package quizeApp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AddQuestionServlet")
public class AddQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Load form (GET)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("adminUsername") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<String> domains = new ArrayList<>();
        List<String> categories = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");

            // Fetch distinct domains
            PreparedStatement ps1 = con.prepareStatement("SELECT DISTINCT domain FROM questions ORDER BY domain ASC");
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) domains.add(rs1.getString("domain"));

            // Fetch distinct categories
            PreparedStatement ps2 = con.prepareStatement("SELECT DISTINCT category FROM questions ORDER BY category ASC");
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                String cat = rs2.getString("category");
                if (cat != null && !cat.isEmpty()) categories.add(cat);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("domains", domains);
        request.setAttribute("categories", categories);
        RequestDispatcher rd = request.getRequestDispatcher("addQuestion.jsp");
        rd.forward(request, response);
    }

    // Save question (POST)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("adminUsername") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String domain = request.getParameter("domain");
        String level = request.getParameter("level");
        String questionText = request.getParameter("questionText");
        String option1 = request.getParameter("option1");
        String option2 = request.getParameter("option2");
        String option3 = request.getParameter("option3");
        String option4 = request.getParameter("option4");
        int correctOption = Integer.parseInt(request.getParameter("correctOption"));
        String category = request.getParameter("category");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");

            String sql = "INSERT INTO questions (domain, level, question, option1, option2, option3, option4, correct_option, category) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, domain);
            ps.setString(2, level);
            ps.setString(3, questionText);
            ps.setString(4, option1);
            ps.setString(5, option2);
            ps.setString(6, option3);
            ps.setString(7, option4);
            ps.setInt(8, correctOption);
            ps.setString(9, category);

            ps.executeUpdate();
            con.close();
            request.setAttribute("successMessage", "Question added successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to add question!");
        }

        // Reload form with updated suggestions
        doGet(request, response);
    }
}
