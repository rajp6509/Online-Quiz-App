package quizeApp;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/loginServlet")
public class loginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Basic input validation
        if (username == null || password == null || role == null ||
            username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            // Hash the password
            String hashedPassword = hashPassword(password);

            // DB connection (your details)
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/quizedata", "root", "Rajp@123");

            // Prepare SQL query (note: your table has 'password_hash' column)
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE username=? AND password_hash=? AND role=?");
            ps.setString(1, username);
            ps.setString(2, hashedPassword);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Login success
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                
                // For ADMIN role, set admin-specific session attribute
                if ("ADMIN".equalsIgnoreCase(role)) {
                    session.setAttribute("adminUsername", username);
                }

                // Redirect based on role
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect("adminDashboard.jsp");
                } else {
                    response.sendRedirect("userDashboard.jsp");
                }
            } else {
                // Invalid login
                request.setAttribute("errorMessage", "Invalid Username, Password, or Role.");
                RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
                rd.forward(request, response);
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    // SHA-256 hashing method (your code)
    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hashedBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
