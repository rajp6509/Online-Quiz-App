<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Quiz App - Login</title>
<style>
select {
	width: 100%;
	padding: 10px;
	margin-bottom: 15px;
	border-radius: 4px;
	border: 1px solid black;
	box-sizing: border-box;
	background-color: white;
	font-size: 14px;
	color: #black;
	appearance: none; /* remove default arrow in some browsers */
}

select:invalid {
	color: #black; /* gray for the prompt text */
}

body {
	font-family: Arial, sans-serif;
	background: linear-gradient(to right, #4b6cb7, #182848);
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.container {
	background-color: white;
	padding: 25px 30px;
	border-radius: 8px;
	box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
	width: 320px;
}

h2 {
	text-align: center;
	margin-bottom: 15px;
	color: #333;
}

p.desc {
	text-align: center;
	color: #555;
	margin-bottom: 20px;
	font-size: 14px;
}

label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
	color: #333;
}

input[type="text"], input[type="password"] {
	width: 100%;
	padding: 10px;
	margin-bottom: 15px;
	border-radius: 4px;
	border: 1px solid #999;
	box-sizing: border-box;
}

button {
	width: 100%;
	padding: 10px;
	background-color: #4b6cb7;
	border: none;
	color: white;
	font-size: 16px;
	border-radius: 4px;
	cursor: pointer;
}

button:hover {
	background-color: #3a539b;
}

.links {
	display: flex;
	justify-content: space-between;
	font-size: 13px;
	margin-top: 15px;
}

.links a {
	color: #4b6cb7;
	text-decoration: none;
}

.links a:hover {
	text-decoration: underline;
}

.error {
	text-align: center;
	color: red;
	font-weight: bold;
	margin-top: 10px;
	font-size: 14px;
}
</style>
</head>
<body>

	<div class="container">
		<h2>Welcome Back</h2>
		<p class="desc">Please login to continue your quiz journey</p>

		<form action="loginServlet" method="post">
			<label for="username">Username</label> <input type="text"
				id="username" name="username" required
				placeholder="Enter your username"> <label for="password">Password</label>
			<input type="password" id="password" name="password" required
				placeholder="Enter your password"> <label for="role">Role</label>
			<select id="role" name="role" required>
				<option value="" disabled selected> Select Role </option>
				<option value="USER">User</option>
				<option value="ADMIN">Admin</option>
			</select>



			<button type="submit">Login</button>
		</form>

		<%
		String errorMsg = (String) request.getAttribute("errorMessage");
		if (errorMsg != null) {
		%>
		<div class="error"><%=errorMsg%></div>
		<%
		}
		%>

		<div class="links">
			<a href="forgotPassword.jsp">Forgot Password?</a> <a
				href="signup.jsp">Sign Up</a>
		</div>
	</div>

</body>
</html>
