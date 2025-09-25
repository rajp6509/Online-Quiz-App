package quizeApp;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/signupServlet")
public class signupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database credentials
    private final String dbURL = "jdbc:mysql://localhost:3306/quizedata";
    private final String dbUser = "root";
    private final String dbPass = "Rajp@123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        // Basic validation
        if (username.isEmpty() || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in all required fields.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Check if username or email already exists
            String checkSql = "SELECT user_id FROM users WHERE username = ? OR email = ?";
            checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            rs = checkStmt.executeQuery();

            if (rs.next()) {
                request.setAttribute("errorMessage", "Username or Email already exists.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
                return;
            }

            // Hash password
            String passwordHash = hashPassword(password);

            // Insert new user (without city)
            String insertSql = "INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, username);
            insertStmt.setString(2, email);
            insertStmt.setString(3, passwordHash);
            insertStmt.setString(4, role);

            int row = insertStmt.executeUpdate();
            if (row > 0) {
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("errorMessage", "Signup failed. Please try again.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (checkStmt != null) checkStmt.close(); } catch (Exception e) {}
            try { if (insertStmt != null) insertStmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }

    // SHA-256 password hashing
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
