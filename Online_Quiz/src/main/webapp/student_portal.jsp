<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // --- MASTER ROUTER & BYPASS MATRIX ---
    // Index.jsp se forward hoke aaye data ko catch karo
    String forwardedEmail = (String) request.getAttribute("studentEmail");
    String forwardedCode = (String) request.getAttribute("testCode");

    if (forwardedEmail != null && forwardedCode != null) {
        forwardedEmail = forwardedEmail.trim();
        forwardedCode = forwardedCode.trim();

        // 1. CONDITION: Agar Teacher hai toh bina form dikhaye direct dashboard phenko
        if ("teacher@gmail.com".equalsIgnoreCase(forwardedEmail) && "teacher123".equals(forwardedCode)) {
            session.setAttribute("teacherLoggedIn", "true");
            response.sendRedirect("TeacherDashboard");
            return;
        } 
        
        // 2. CONDITION: Agar Student hai toh bina form dikhaye direct StartExamEngine ko forward karo
        else {
            // Data ko request parameters ki tarah aage pass karne ke liye dispatch matrix
            request.getRequestDispatcher("StartExamEngine").forward(request, response);
            return;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Portal - Entry</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-card { background: white; padding: 35px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #4a5568; }
        input { width: 100%; padding: 12px; border: 1px solid #cbd5e0; border-radius: 5px; box-sizing: border-box; font-size: 14px; }
        .btn-start { width: 100%; background-color: #3498db; color: white; border: none; padding: 12px; border-radius: 5px; cursor: pointer; font-weight: bold; font-size: 16px; margin-top: 10px; transition: 0.2s; }
        .btn-start:hover { background-color: #2980b9; }
        .error { color: #e74c3c; font-size: 14px; text-align: center; margin-bottom: 15px; font-weight: bold; }
    </style>
</head>
<body>

<div class="login-card">
    <h2>Student Quiz Entry Portal</h2>
    
    <% if(request.getParameter("error") != null) { %>
        <div class="error">❌ Invalid Test Code or Examination Finished!</div>
    <% } %>
    
    <form action="StartExamEngine" method="POST">
        <div class="form-group">
            <label>Registered Email Address:</label>
            <input type="email" name="studentEmail" required placeholder="example@gmail.com">
        </div>
        <div class="form-group">
            <label>Active Test Code:</label>
            <input type="text" name="testCode" required placeholder="e.g., java101">
        </div>
        <button type="submit" class="btn-start">Verify & Start Exam</button>
    </form>
</div>

</body>
</html>