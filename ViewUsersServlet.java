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

@WebServlet("/ViewUsersServlet")
public class ViewUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("adminUsername") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<UserInfo> users = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");

            String sql = "SELECT username, created_at FROM users"; // only username & creation time
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserInfo u = new UserInfo();
                u.setUsername(rs.getString("username"));
                u.setCreatedAt(rs.getString("created_at")); // assuming column name is created_at
                users.add(u);
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to fetch users!");
        }

        request.setAttribute("users", users);
        RequestDispatcher rd = request.getRequestDispatcher("viewUsers.jsp");
        rd.forward(request, response);
    }

    // Inner model class
    public static class UserInfo {
        private String username;
        private String createdAt;

        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }

        public String getCreatedAt() { return createdAt; }
        public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    }
}
