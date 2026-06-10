<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teacher Login - Online Quiz Portal</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f1f5f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        .title { font-size: 24px; font-weight: bold; margin-bottom: 20px; text-align: center; color: #1e293b; }
        .input-group { margin-bottom: 20px; }
        .input-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #475569; }
        .input-group input { width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box; font-size: 15px; }
        .btn-login { width: 100%; background: #2563eb; color: white; border: none; padding: 12px; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; transition: 0.2s; }
        .btn-login:hover { background: #1d4ed8; }
        .error-msg { color: #dc2626; text-align: center; margin-bottom: 15px; font-weight: 500; }
    </style>
</head>
<body>

<div class="login-card">
    <div class="title">Teacher Portal Login</div>
    
    <% if(request.getParameter("error") != null) { %>
        <div class="error-msg">❌ Galat Email ya Password! Dubara try karein.</div>
    <% } %>

    <form action="TeacherDashboard" method="POST">
        <input type="hidden" name="operation" value="teacherLogin">
        
        <div class="input-group">
            <label>Email Address</label>
            <input type="email" name="teacherEmail" required placeholder="teacher@gmail.com">
        </div>
        
        <div class="input-group">
            <label>Password</label>
            <input type="password" name="teacherPassword" required placeholder="••••••••">
        </div>
        
        <button type="submit" class="btn-login">Verify & Login</button>
    </form>
</div>

</body>
</html>