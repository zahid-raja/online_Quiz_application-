<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test Performance Ledger</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; padding: 30px; }
        .container { max-width: 1000px; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin: auto; }
        .header-flex { display: flex; justify-content: space-between; align-items: center; }
        .email-btn { background: #2ecc71; color: white; padding: 12px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; border: none; cursor: pointer; }
        .email-btn:hover { background: #27ae60; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #34495e; color: white; }
        tr:hover { background-color: #f1f1f1; }
        .rank-badge { background: #f1c40f; color: #2c3e50; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header-flex">
            <h2>🏆 Scoreboard Ledger (Test: ${selectedTestCode})</h2>
            <a href="SubmitTestEngine?triggerAction=fireRankEmails&testCode=${selectedTestCode}" class="email-btn">📧 Send Rank on Email</a>
        </div>
        
        <c:if test="${param.emailStatus eq 'sent'}">
            <p style="color: #27ae60; font-weight: bold; background: #e8f8f5; padding: 10px; border-radius: 5px;">➔ Success: Ranks have been delivered to students registered emails successfully!</p>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>Rank</th>
                    <th>Student Email</th>
                    <th>Score</th>
                    <th>Time Taken (Duration)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="row" items="${leaderboard}">
                    <tr>
                        <td><span class="rank-badge">#${row.calculatedRank}</span></td>
                        <td><strong>${row.email}</strong></td>
                        <td><span style="color: #c0392b; font-weight: bold;">${row.score} Points</span></td>
                        <td>${row.timeTaken}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>