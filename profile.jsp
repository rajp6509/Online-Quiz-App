<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,java.text.SimpleDateFormat" session="true" %>
<%@ page import="java.security.MessageDigest" %>
<%! 
// ✅ Password hashing method
public String hashPassword(String password) throws java.security.NoSuchAlgorithmException, java.io.UnsupportedEncodingException {
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] hash = md.digest(password.getBytes("UTF-8"));
    StringBuilder hex = new StringBuilder();
    for (byte b : hash) {
        String hexStr = Integer.toHexString(0xff & b);
        if(hexStr.length() == 1) hex.append('0');
        hex.append(hexStr);
    }
    return hex.toString();
}
%>

<%
    // ✅ Get logged-in username from session
    String sessionUsername = (String) session.getAttribute("username");
    if (sessionUsername == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Database info
    String dbURL = "jdbc:mysql://localhost:3306/quizedata";
    String dbUser = "root";
    String dbPass = "Rajp@123";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String message = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // ✅ Handle update form submission
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String newUsername = request.getParameter("username");
            String newEmail = request.getParameter("email");
            String newPassword = request.getParameter("password");

            String sqlUpdate;
            if (newPassword != null && !newPassword.isEmpty()) {
                String hashedPassword = hashPassword(newPassword);
                sqlUpdate = "UPDATE users SET username=?, email=?, password_hash=? WHERE username=?";
                stmt = conn.prepareStatement(sqlUpdate);
                stmt.setString(1, newUsername);
                stmt.setString(2, newEmail);
                stmt.setString(3, hashedPassword);
                stmt.setString(4, sessionUsername);
            } else {
                sqlUpdate = "UPDATE users SET username=?, email=? WHERE username=?";
                stmt = conn.prepareStatement(sqlUpdate);
                stmt.setString(1, newUsername);
                stmt.setString(2, newEmail);
                stmt.setString(3, sessionUsername);
            }

            int updated = stmt.executeUpdate();
            if (updated > 0) {
                message = "Profile updated successfully!";
                session.setAttribute("username", newUsername); // update session
                sessionUsername = newUsername;
            } else {
                message = "Profile update failed!";
            }
        }

        // ✅ Fetch user details
        String sql = "SELECT user_id, username, email, role, created_at FROM users WHERE username=?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, sessionUsername);
        rs = stmt.executeQuery();

        if (!rs.next()) {
            out.println("<p style='color:red;'>User profile not found.</p>");
            return;
        }

%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Profile</title>
    <style>
        body { font-family: Arial; background:#f4f6f8; margin:0; padding:0; }
        header { background:#1e293b; color:white; padding:15px; text-align:center; }
        .profile-container { max-width:600px; margin:50px auto; background:white; padding:25px; border-radius:10px; box-shadow:0 4px 12px rgba(0,0,0,0.1);}
        h2 { text-align:center; margin-bottom:20px; color:#0f172a; }
        p { font-size:16px; margin:10px 0; }
        input[type=text], input[type=email], input[type=password] { width:100%; padding:10px; margin:5px 0 15px 0; border-radius:5px; border:1px solid #ccc; }
        .btn { display:inline-block; margin-top:15px; padding:10px 18px; border-radius:6px; background:#2563eb; color:white; text-decoration:none; transition:0.3s; border:none; cursor:pointer;}
        .btn:hover { background:#1d4ed8; }
        .message { text-align:center; color:green; font-weight:bold; }
    </style>
</head>
<body>

<header><h1>User Profile</h1></header>

<div class="profile-container">
    <h2>Welcome, <%= rs.getString("username") %>!</h2>
    <% if (message != null) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <form method="post">
        <p><b>User ID:</b> <%= rs.getInt("user_id") %></p>

        <label>Username:</label>
        <input type="text" name="username" value="<%= rs.getString("username") %>" required/>

        <label>Email:</label>
        <input type="email" name="email" value="<%= rs.getString("email") %>" required/>

        <label>Password (leave blank to keep current):</label>
        <input type="password" name="password"/>

        <p><b>Role:</b> <%= rs.getString("role") %></p>
        <p><b>Created At:</b> <%
            java.sql.Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) {
                out.print(new SimpleDateFormat("MMMM dd, yyyy").format(ts));
            }
        %></p>

        <button type="submit" class="btn">Update Profile</button>
        <a href="userDashboard.jsp" class="btn">Back to Dashboard</a>
    </form>
</div>

</body>
</html>

<%
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch(Exception e) {}
        try { if (stmt != null) stmt.close(); } catch(Exception e) {}
        try { if (conn != null) conn.close(); } catch(Exception e) {}
    }
%>
