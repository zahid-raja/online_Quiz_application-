<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Show Results - Test List</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; padding: 30px; }
        .container { max-width: 800px; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin: auto; }
        h2 { color: #2c3e50; }
        .test-item { display: flex; justify-content: space-between; align-items: center; padding: 15px; border-bottom: 1px solid #eee; }
        .view-btn { background: #3498db; color: white; padding: 8px 16px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .view-btn:hover { background: #2980b9; }
    </style>
</head>
<body>
    <div class="container">
        <h2>📊 Select Test to View Results</h2>
        <hr>
        <c:forEach var="test" items="${testList}">
            <div class="test-item">
                <div>
                    <strong>${test.testName}</strong> <br>
                    <small style="color: #7f8c8d;">Code: ${test.testCode}</small>
                </div>
                <a href="TeacherDashboard?action=viewSpecificResult&testCode=${test.testCode}" class="view-btn">View Result</a>
            </div>
        </c:forEach>
    </div>
</body>
</html>