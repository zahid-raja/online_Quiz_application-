package com.quiz.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import com.google.cloud.firestore.Firestore;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.InputStream;

@WebListener
public class FirebaseRegistry implements ServletContextListener {

    private static Firestore db;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            // src/main/resources/ folder me rakhi hui json config key uthana
            InputStream serviceAccount = Thread.currentThread().getContextClassLoader()
                    .getResourceAsStream("firebase-config.json");

            if (serviceAccount == null) {
                throw new RuntimeException("Error: 'firebase-config.json' file resources folder me nahi mili!");
            }

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                System.out.println("🚀 [Firebase Server Alert]: Cloud Firestore Connection Established Successfully!");
            }
            db = FirestoreClient.getFirestore();
        } catch (Exception e) {
            System.err.println("❌ [Firebase Error]: Initialization crashed!");
            e.printStackTrace();
        }
    }

    public static Firestore getDatabase() {
        return db;
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Context shutdown hooks cleanup handle karne ke liye
    }
}