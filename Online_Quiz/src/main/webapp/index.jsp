<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Online Quiz Portal - Login</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f1f5f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); width: 100%; max-width: 420px; text-align: center; }
        .title { font-size: 26px; font-weight: bold; margin-bottom: 8px; color: #1e293b; }
        .subtitle { font-size: 14px; color: #64748b; margin-bottom: 25px; }
        .input-group { margin-bottom: 20px; text-align: left; }
        .input-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #475569; font-size: 14px; }
        .input-group input { width: 100%; padding: 12px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; font-size: 15px; transition: 0.2s; }
        .input-group input:focus { border-color: #2563eb; outline: none; box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
        .btn-login { width: 100%; background: #2563eb; color: white; border: none; padding: 14px; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.2s; margin-top: 10px; }
        .btn-login:hover { background: #1d4ed8; }
        .error-msg { color: #dc2626; background: #fee2e2; padding: 10px; border-radius: 6px; margin-bottom: 20px; font-weight: 500; font-size: 14px; border: 1px solid #fca5a5; }
    </style>
</head>
<body>

<div class="login-card">
    <div class="title">Welcome to Exam Portal</div>
    <div class="subtitle">Enter credentials to log in as Teacher or Student</div>
    
    <% if(request.getParameter("error") != null) { %>
        <div class="error-msg">❌ Galat Email, Password ya Authentication Code!</div>
    <% } %>

    <form id="mainLoginForm" method="POST">
        <div class="input-group">
            <label>Email Address</label>
            <input type="email" id="userEmail" name="studentEmail" required placeholder="name@domain.com">
        </div>
        
        <div class="input-group">
            <label>Password / Test Authentication Code</label>
            <input type="password" id="userSecret" name="testCode" required placeholder="Password or Test Code">
        </div>
        
        <button type="submit" class="btn-login">Login / Start Test</button>
    </form>
</div>

<script>
    document.getElementById("mainLoginForm").onsubmit = function(e) {
        var email = document.getElementById("userEmail").value.trim();
        var secret = document.getElementById("userSecret").value.trim();
        
        // Agar teacher login kar raha hai
        if(email.toLowerCase() === "teacher@gmail.com" && secret === "teacher123") {
            // Isko isi page par post hone do jahan niche Java logic handles karega
            this.action = "index.jsp";
        } else {
            // Agar student hai, toh direct StartExamEngine servlet ko hit karo bina kisi page par bhatke!
            this.action = "StartExamEngine";
        }
    };
</script>

<%
    // Java block sirf Teacher login request intercept karne ke liye
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("studentEmail");
        String secret = request.getParameter("testCode");

        if (email != null && secret != null) {
            email = email.trim();
            secret = secret.trim();

            if ("teacher@gmail.com".equalsIgnoreCase(email) && "teacher123".equals(secret)) {
                session.setAttribute("teacherLoggedIn", "true");
                response.sendRedirect("TeacherDashboard");
                return;
            }
        }
    }
%>

</body>
</html>