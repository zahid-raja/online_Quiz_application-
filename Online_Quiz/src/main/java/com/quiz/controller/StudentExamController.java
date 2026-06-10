package com.quiz.controller;

import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.quiz.config.FirebaseRegistry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/StartExamEngine")
public class StudentExamController extends HttpServlet {
    private final Firestore db = FirebaseRegistry.getDatabase();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String email = request.getParameter("studentEmail");
            String testCode = request.getParameter("testCode");
            
            if (testCode != null) {
                testCode = testCode.trim();
            }

            // Firebase se 'exams' collection ke andar test document fetch karna
            DocumentSnapshot examDoc = db.collection("exams").document(testCode).get().get();

            if (examDoc.exists()) {
                HttpSession session = request.getSession();
                session.setAttribute("studentEmail", email);
                
                Map<String, Object> examData = examDoc.getData();
                request.setAttribute("examData", examData);

                // Pure dynamic data ke sath student ko test room me forward karna
                request.getRequestDispatcher("/student_exam_room.jsp").forward(request, response);
            } else {
                response.sendRedirect("student_portal.jsp?error=CodeInvalid");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("student_portal.jsp?error=PipelineCrash");
        }
    }
}