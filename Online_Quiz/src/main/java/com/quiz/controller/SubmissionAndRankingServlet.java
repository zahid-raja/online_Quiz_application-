package com.quiz.controller;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.quiz.config.FirebaseRegistry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.OutputStream;

@WebServlet("/SubmitTestEngine")
public class SubmissionAndRankingServlet extends HttpServlet {

    private final Firestore db = FirebaseRegistry.getDatabase();
    private final String SENDGRID_API_KEY = "YOUR_SENDGRID_SECURE_HTTP_API_KEY_HERE"; // Put key here

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String email = request.getParameter("studentEmail");
            String testCode = request.getParameter("testCode");
            long startTime = Long.parseLong(request.getParameter("startEpochTime"));
            long submitTime = System.currentTimeMillis();
            
            // Check if submission is forcefully triggered by the Anti-Cheat Tab Window Guard
            boolean wasForceSubmitted = Boolean.parseBoolean(request.getParameter("cheatDetected"));

            // Calculate exact metrics formatting for Duration Took Display Panel
            long durationMillis = submitTime - startTime;
            long minutesTaken = (durationMillis / 1000) / 60;
            long secondsTaken = (durationMillis / 1000) % 60;
            String timeTakenFormatted = minutesTaken + " Mins " + secondsTaken + " Secs";

            // Dynamic Live Evaluation Module against Firebase Schema Core Key Answers
            DocumentSnapshot examDoc = db.collection("exams").document(testCode).get().get();
            List<Map<String, Object>> questions = (List<Map<String, Object>>) examDoc.get("questions");

            int finalScore = 0;
            if (questions != null) {
                for (int i = 0; i < questions.size(); i++) {
                    String studentAnswer = request.getParameter("q_ans_" + i);
                    String correctAnswer = (String) questions.get(i).get("correctValue");

                    if (studentAnswer != null && studentAnswer.trim().equalsIgnoreCase(correctAnswer)) {
                        finalScore++;
                    }
                }
            }

            // Compound Key Generation logic matching schema map instructions
            String documentUniqueId = testCode + "_" + email.replace(".", "_");

            Map<String, Object> submissionPayload = new HashMap<>();
            submissionPayload.put("email", email);
            submissionPayload.put("testCode", testCode);
            submissionPayload.put("score", finalScore);
            submissionPayload.put("startTime", startTime);
            submissionPayload.put("submitTime", submitTime);
            submissionPayload.put("timeTaken", timeTakenFormatted);
            submissionPayload.put("cheatTriggered", wasForceSubmitted);

            // Store inside Firebase Firestore Collections ledger database permanently
            db.collection("submissions").document(documentUniqueId).set(submissionPayload).get();

            // Store instant values inside session scope for local confirmation layout rendering
            HttpSession session = request.getSession();
            session.setAttribute("instantScore", finalScore);
            session.setAttribute("timeTakenString", timeTakenFormatted);
            session.setAttribute("cheatStatus", wasForceSubmitted);

            response.sendRedirect("student_score_card_view.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student_portal.jsp?error=SubmissionPipelineFailed");
        }
    }

    // Trigger Reports Action Trigger Engine (Automated Bulk Email Rank Engine Loop)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String triggerAction = request.getParameter("triggerAction");
        String testCode = request.getParameter("testCode");

        if ("fireRankEmails".equals(triggerAction)) {
            try {
                // Fetch, sort, evaluate, and append absolute ranks matching tie breaker rule rules
                List<Map<String, Object>> leaderboard = fetchAndRankSubmissions(testCode);
                DocumentSnapshot examDoc = db.collection("exams").document(testCode).get().get();
                String testName = examDoc.getString("testName");

                // Loop Engine for bullet-proof execution across all student emails
                for (Map<String, Object> rankRecord : leaderboard) {
                    String recipientEmail = (String) rankRecord.get("email");
                    int calculatedRank = (int) rankRecord.get("calculatedRank");
                    long finalScore = (long) rankRecord.get("score");

                    dispatchSecureCloudEmail(recipientEmail, testName, calculatedRank, finalScore);
                }
                response.sendRedirect("TeacherDashboard?action=viewSpecificResult&testCode=" + testCode + "&emailStatus=sent");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("TeacherDashboard?error=EmailPipelineInterrupted");
            }
        }
    }

    private List<Map<String, Object>> fetchAndRankSubmissions(String testCode) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        List<QueryDocumentSnapshot> docs = db.collection("submissions").whereEqualTo("testCode", testCode).get().get().getDocuments();
        for (QueryDocumentSnapshot d : docs) {
            list.add(new HashMap<>(d.getData()));
        }
        Collections.sort(list, (m1, m2) -> {
            int score1 = ((Long) m1.get("score")).intValue();
            int score2 = ((Long) m2.get("score")).intValue();
            if (score2 != score1) return Integer.compare(score2, score1);
            return Long.compare((Long) m1.get("startTime"), (Long) m2.get("startTime"));
        });
        for (int i = 0; i < list.size(); i++) {
            list.get(i).put("calculatedRank", i + 1);
        }
        return list;
    }

    // Professional Industry Standard Free SendGrid HTTP Mail Delivery Gateway API Logic
    private void dispatchSecureCloudEmail(String email, String testName, int rank, long score) {
        try {
            URL url = new URL("https://api.sendgrid.com/v3/mail/send");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Authorization", "Bearer " + SENDGRID_API_KEY);
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            String jsonPayload = "{"
                    + "\"personalizations\": [{"
                    + "  \"to\": [{\"email\": \"" + email + "\"}]"
                    + "}],"
                    + "\"from\": {\"email\": \"system@jbsirquizplatform.com\", \"name\": \"JB Sir Platform\"},"
                    + "\"subject\": \"🏆 Live Update: Your Rank Card for " + testName + "\","
                    + "\"content\": [{"
                    + "  \"type\": \"text/html\","
                    + "  \"value\": \"<h3>Hello, Student!</h3><p>Aapka <b>" + testName + "</b> ka official report ready hai.</p>"
                    + "             <p><b>Score Scored:</b> " + score + "</p>"
                    + "             <p><b>Final Comparative Rank:</b> #" + rank + "</p>"
                    + "             <br><p>Best Regards,<br><b>JB Sir Platform Support Engine</b></p>\""
                    + "}]"
                    + "}";

            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonPayload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }
            int responseCode = conn.getResponseCode();
            System.out.println("📬 Cloud Mail Engine Response Code for [" + email + "]: " + responseCode);
        } catch (Exception e) {
            System.err.println("❌ Failed to push cloud mail payload infrastructure to " + email);
            e.printStackTrace();
        }
    }
}