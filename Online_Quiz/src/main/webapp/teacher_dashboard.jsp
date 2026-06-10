<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Teacher Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7fafc;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
        }
        .header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #2c3e50;
            color: white;
            padding: 15px 25px;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .btn-create {
            background-color: #2ecc71;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            font-size: 14px;
        }
        /* Form Styling */
        .form-section {
            background: white;
            padding: 25px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #4a5568;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #cbd5e0;
            border-radius: 4px;
            box-sizing: border-box;
        }
        /* Grid Layout for Cards */
        .dashboard-grid-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .test-card-block {
            flex: 1 1 calc(50% - 20px);
            box-sizing: border-box;
            background: #ffffff;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            position: relative;
            min-width: 280px;
        }
        .test-title-header {
            font-size: 20px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .test-code-sub {
            font-size: 16px;
            color: #7f8c8d;
        }
        .no-data-alert {
            text-align: center;
            color: #718096;
            padding: 40px;
            background: #edf2f7;
            border-radius: 8px;
            width: 100%;
        }
    </style>
</head>
<body>

<div class="container">

    <div class="header-bar">
        <h2>Teacher Dashboard</h2>
        <button class="btn-create" onclick="toggleForm()">+ Create New Test</button>
    </div>

    <div id="createTestForm" class="form-section" style="display: none;">
        <h3>Publish a New Quiz/Test</h3>
        <form action="TeacherDashboard" method="POST">
            <input type="hidden" name="operation" value="publishTest">
            
            <div class="form-group">
                <label>Test Name:</label>
                <input type="text" name="testName" required placeholder="e.g., Core Java Basic Quiz">
            </div>
            <div class="form-group">
                <label>Test Code:</label>
                <input type="text" name="testCode" required placeholder="e.g., JAVA101">
            </div>
            <div class="form-group">
                <label>Duration (Minutes):</label>
                <input type="number" name="duration" required placeholder="e.g., 30">
            </div>
            <div class="form-group">
                <label>Validation (Hours):</label>
                <input type="number" name="validationHours" required placeholder="e.g., 24">
            </div>

            <hr style="border: 1px solid #e2e8f0; margin: 20px 0;">
            <h4>Question 1</h4>
            <div class="form-group">
                <label>Question Text:</label>
                <input type="text" name="questionText[]" required placeholder="What is Java?">
            </div>
            <div class="form-group">
                <label>Option 1:</label>
                <input type="text" name="option1[]" required placeholder="Option A">
            </div>
            <div class="form-group">
                <label>Option 2:</label>
                <input type="text" name="option2[]" required placeholder="Option B">
            </div>
            <div class="form-group">
                <label>Option 3:</label>
                <input type="text" name="option3[]" required placeholder="Option C">
            </div>
            <div class="form-group">
                <label>Option 4:</label>
                <input type="text" name="option4[]" required placeholder="Option D">
            </div>
            <div class="form-group">
                <label>Correct Answer Value (Exact Option Text):</label>
                <input type="text" name="correctAnswer[]" required placeholder="Type the exact correct text here">
            </div>

            <button type="submit" class="btn-create" style="background-color: #3498db;">Publish Test to Firebase</button>
        </form>
    </div>

    <h3>Active Dynamic Tests</h3>
    <div class="dashboard-grid-container">
        <c:if test="${empty continuousTestsList}">
            <div class="no-data-alert">
                🔒 No active tests found in Firestore database. Click on <b>"+ Create New Test"</b> to add your first quiz!
            </div>
        </c:if>

        <c:forEach var="test" items="${continuousTestsList}">
            <div class="test-card-block">
                <div class="test-title-header">${test.testName}</div>
                <div class="test-code-sub">Code: ${test.testCode}</div>
            </div>
        </c:forEach>
    </div>

</div>

<script type="text/javascript">
    function toggleForm() {
        var form = document.getElementById("createTestForm");
        if(form.style.display === "none") {
            form.style.display = "block";
        } else {
            form.style.display = "none";
        }
    }
</script>

</body>
</html>