<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Live Examination Terminal</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f8fafc; padding: 40px; margin: 0; }
        .exam-container { max-width: 850px; margin: 0 auto; background: white; padding: 35px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .exam-header { border-bottom: 2px solid #edf2f7; padding-bottom: 20px; margin-bottom: 30px; }
        .exam-title { font-size: 26px; font-weight: bold; color: #1a202c; }
        .question-box { background: #f8fafc; border: 1px solid #e2e8f0; padding: 25px; border-radius: 8px; margin-bottom: 25px; }
        .question-text { font-size: 18px; font-weight: 600; color: #2d3748; margin-bottom: 15px; }
        .option-label { display: block; padding: 12px 15px; background: white; border: 1px solid #cbd5e0; border-radius: 6px; margin-bottom: 10px; cursor: pointer; transition: 0.2s; font-size: 15px; }
        .option-label:hover { background: #f1f5f9; border-color: #94a3b8; }
        .option-label input { margin-right: 12px; transform: scale(1.1); }
        .btn-submit { background-color: #e53e3e; color: white; border: none; padding: 14px 40px; font-size: 16px; font-weight: bold; border-radius: 6px; cursor: pointer; display: block; margin: 30px 0 0 auto; transition: 0.2s; }
        .btn-submit:hover { background-color: #c53030; }
    </style>
</head>
<body>

<div class="exam-container">
    <div class="exam-header">
        <div class="exam-title">${examData.testName}</div>
        <div style="color: #64748b; margin-top: 8px; font-size: 15px;">
            Candidate Email: <b>${sessionScope.studentEmail}</b> | Test Authentication Code: <span style="background: #e2e8f0; padding: 2px 6px; border-radius: 4px; font-weight: bold;">${examData.testCode}</span>
        </div>
    </div>

    <form id="quizForm" action="SubmitTestEngine" method="POST">
        <input type="hidden" name="studentEmail" value="${sessionScope.studentEmail}">
        <input type="hidden" name="testCode" value="${examData.testCode}">
        <input type="hidden" id="startEpochTime" name="startEpochTime" value="">
        <input type="hidden" id="cheatDetected" name="cheatDetected" value="false">

        <c:forEach var="q" items="${examData.questions}" varStatus="status">
            <div class="question-box">
                <div class="question-text">Question ${status.index + 1}: ${q.qText}</div>
                
                <c:forEach var="opt" items="${q.options}">
                    <label class="option-label">
                        <input type="radio" name="q_ans_${status.index}" value="${opt}" required>
                        ${opt}
                    </label>
                </c:forEach>
            </div>
        </c:forEach>

        <button type="submit" class="btn-submit">Submit Final Assessment</button>
    </form>
</div>

<script type="text/javascript">
    // Sirf exam start hone ka time note karega, baki sab cheat codes removed!
    document.getElementById("startEpochTime").value = Date.now();
</script>

</body>
</html>