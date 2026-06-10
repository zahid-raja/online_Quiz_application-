package com.quiz.controller;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.quiz.config.FirebaseRegistry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/TeacherDashboard")
public class MainControllerServlet extends HttpServlet {

    private final Firestore db = FirebaseRegistry.getDatabase();

    // 1. Dashboard View Logic + Strict Session Authorization Protection
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // --- SECURITY VALIDATION BLOCK ---
        // Direct URL bypass rokne ke liye checking rule matrix
        HttpSession session = request.getSession(false);
        if (session == null || !"true".equals(session.getAttribute("teacherLoggedIn"))) {
            // Ab agar valid session token nahi milega toh seedhe root (main index page) par phenk dega
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("showResult".equals(action)) {
                // Show Result workflow activated from Three-Dot menu
                List<Map<String, Object>> testList = fetchAllAvailableTests();
                request.setAttribute("testList", testList);
                request.getRequestDispatcher("/teacher_show_result_list.jsp").forward(request, response);
                return;
            } 
            
            if ("viewSpecificResult".equals(action)) {
                // Deep Ledger View Result Logic
                String testCode = request.getParameter("testCode");
                List<Map<String, Object>> sortedLeaderboard = fetchAndRankSubmissions(testCode);
                request.setAttribute("leaderboard", sortedLeaderboard);
                request.setAttribute("selectedTestCode", testCode);
                request.getRequestDispatcher("/teacher_view_result_ledger.jsp").forward(request, response);
                return;
            }

            // Default Route: Display active dynamic grid tests inside dashboard layout
            List<Map<String, Object>> continuousTestsList = fetchAllAvailableTests();
            request.setAttribute("continuousTestsList", continuousTestsList);
            request.getRequestDispatcher("/teacher_dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error executing dashboard transaction operations", e);
        }
    }

    // 2. Publish New Test Schema Payload Control (Auth handling logic shifted to index.jsp root matrix)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // Security fallback: Ensure teacher is logged in during dynamic post transaction
        HttpSession session = request.getSession(false);
        if (session == null || !"true".equals(session.getAttribute("teacherLoggedIn"))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String operation = request.getParameter("operation");
        
        // --- PUBLISH ACTIVE TEST MECHANISM CORE ---
        if ("publishTest".equals(operation)) {
            try {
                String testName = request.getParameter("testName");
                String testCode = request.getParameter("testCode");
                int duration = Integer.parseInt(request.getParameter("duration"));
                int validationHours = Integer.parseInt(request.getParameter("validationHours"));

                // Dynamic Incremental Question parsing mechanism loop
                String[] questionsArr = request.getParameterValues("questionText[]");
                String[] opt1Arr = request.getParameterValues("option1[]");
                String[] opt2Arr = request.getParameterValues("option2[]");
                String[] opt3Arr = request.getParameterValues("option3[]");
                String[] opt4Arr = request.getParameterValues("option4[]");
                String[] correctAnswersArr = request.getParameterValues("correctAnswer[]");

                List<Map<String, Object>> questionsMatrix = new ArrayList<>();
                if (questionsArr != null) {
                    for (int i = 0; i < questionsArr.length; i++) {
                        Map<String, Object> questionObj = new HashMap<>();
                        questionObj.put("qText", questionsArr[i]);
                        questionObj.put("options", Arrays.asList(opt1Arr[i], opt2Arr[i], opt3Arr[i], opt4Arr[i]));
                        questionObj.put("correctValue", correctAnswersArr[i].trim());
                        questionsMatrix.add(questionObj);
                    }
                }

                // Prepare Schema document payload structure
                Map<String, Object> examPayload = new HashMap<>();
                examPayload.put("testName", testName);
                examPayload.put("testCode", testCode);
                examPayload.put("duration", duration);
                examPayload.put("validationHours", validationHours);
                examPayload.put("questions", questionsMatrix);
                examPayload.put("timestamp", System.currentTimeMillis());

                // Save Document safely inside Firebase (Document Name = Test Code)
                DocumentReference docRef = db.collection("exams").document(testCode);
                docRef.set(examPayload).get();

                response.sendRedirect("TeacherDashboard?status=success");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("add_test_panel.jsp?status=failed");
            }
        }
    }

    private List<Map<String, Object>> fetchAllAvailableTests() throws Exception {
        List<Map<String, Object>> collectionRecords = new ArrayList<>();
        ApiFuture<QuerySnapshot> query = db.collection("exams").orderBy("timestamp", Query.Direction.ASCENDING).get();
        List<QueryDocumentSnapshot> documents = query.get().getDocuments();
        for (QueryDocumentSnapshot doc : documents) {
            collectionRecords.add(doc.getData());
        }
        return collectionRecords;
    }

    private List<Map<String, Object>> fetchAndRankSubmissions(String testCode) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();
        ApiFuture<QuerySnapshot> query = db.collection("submissions").whereEqualTo("testCode", testCode).get();
        List<QueryDocumentSnapshot> docs = query.get().getDocuments();
        
        for (QueryDocumentSnapshot d : docs) {
            list.add(new HashMap<>(d.getData()));
        }

        // Custom Anonymous Tie-Breaker Scoring Algorithm Rule Matrix
        Collections.sort(list, new Comparator<Map<String, Object>>() {
            @Override
            public int compare(Map<String, Object> m1, Map<String, Object> m2) {
                int score1 = ((Long) m1.get("score")).intValue();
                int score2 = ((Long) m2.get("score")).intValue();
                
                if (score2 != score1) {
                    return Integer.compare(score2, score1); // Descending order on Score
                } else {
                    long time1 = (Long) m1.get("startTime");
                    long time2 = (Long) m2.get("startTime");
                    return Long.compare(time1, time2); // Ascending order on timestamp for Tie Break
                }
            }
        });

        // Appending absolute sequence rank to output map data packet
        for (int i = 0; i < list.size(); i++) {
            list.get(i).put("calculatedRank", i + 1);
        }
        return list;
    }
}