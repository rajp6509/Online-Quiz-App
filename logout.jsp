<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate session
    session.invalidate();
    response.sendRedirect("index.jsp");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
</head>
<body>
    <p>Logging out... Redirecting to login page.</p>
</body>
</html>