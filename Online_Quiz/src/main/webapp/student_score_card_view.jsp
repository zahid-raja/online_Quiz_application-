<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Assessment Submitted</title>
    <style>
        body { font-family: Arial, sans-serif; background: #eecda3; background: linear-gradient(to right, #ef629f, #eceba7); height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; }
        .card { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.2); text-align: center; max-width: 450px; }
        h1 { color: #2c3e50; margin-bottom: 10px; }
        .score { font-size: 48px; color: #27ae60; font-weight: bold; margin: 20px 0; }
        .time { font-size: 18px; color: #7f8c8d; margin-bottom: 30px; }
        .notice { background: #f9ebea; color: #c0392b; padding: 10px; border-radius: 5px; font-size: 14px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="card">
        <h1>🎉 Test Submitted!</h1>
        <p>Aapka response safely cloud par save ho gaya hai.</p>
        
        <div class="score">${sessionScope.instantScore} Points</div>
        <div class="time">⏱️ Total Time Taken: ${sessionScope.timeTakenString}</div>

        <c:if var="cheat" test="${sessionScope.cheatStatus}">
            <div class="notice">🚨 Note: System caught tab switching behavior. Test was auto-submitted.</div>
        </c:if>

        <p style="color: #34495e;">💡 <strong>Note:</strong> Aapki final comparative rank test window close hone ke baad aapke mail pe bhej di jayegi.</p>
    </div>
</body>
</html>