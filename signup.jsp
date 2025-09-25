<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quiz App - Sign Up</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: linear-gradient(to right, #4b6cb7, #182848);
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 10px;
        }
        p.sub {
            text-align: center;
            color: #666;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type=text], input[type=email], input[type=password] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            padding: 12px;
            background-color: #4b6cb7;
            color: #fff;
            font-weight: bold;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #3951a3;
        }
        .error-msg {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
        .login-link {
            text-align: center;
            margin-top: 15px;
        }
        .login-link a {
            color: #4b6cb7;
            text-decoration: none;
            font-weight: bold;
        }
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Create Your Account</h2>
    <p class="sub">Join us and start your quiz journey today!</p>

    <form action="signupServlet" method="post" novalidate>
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required placeholder="Choose a username">

        <label for="email">Email</label>
        <input type="email" id="email" name="email" required placeholder="Enter your email">
         
         <label for="Role">Role</label>
        <input type="text" id="role" name="role" required placeholder="Enter your Role (Adimn/User)">

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required minlength="6" placeholder="Create a password">

        <label for="confirmPassword">Confirm Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6" placeholder="Re-enter your password">

        <button type="submit">Sign Up</button>
    </form>

    <% 
      String errorMsg = (String) request.getAttribute("errorMessage"); 
      if (errorMsg != null) { 
    %>
      <p class="error-msg"><%= errorMsg %></p>
    <% } %>

    <div class="login-link">
        Already have an account? <a href="login.jsp">Login here</a>
    </div>
</div>

<script>
    // Simple password match check
    const form = document.querySelector('form');
    form.addEventListener('submit', e => {
        const pwd = form.password.value;
        const confirmPwd = form.confirmPassword.value;
        if (pwd !== confirmPwd) {
            e.preventDefault();
            alert('Passwords do not match!');
        }
    });
</script>

</body>
</html>
