# Academic Portal (PCSA)

A cross-platform (Web & Android) educational streaming and resource distribution portal tailored for intermediate and secondary curricula (FBISE & Sindh Textbook Boards).

## 🚀 Overview

- **Cross-Platform:** Built with Flutter, supporting responsive Web deployment (1–3 column dynamic grid) and Android devices.
- **Content Delivery:** Integrated YouTube video lectures paired with in-app PDF study notes and keybooks.
- **In-App PDF Viewer:** Secure cross-platform PDF viewing via `syncfusion_flutter_pdfviewer` with student watermark attribution.
- **Interactive MCQs & Search:** Real-time query search across courses, topics, and instructors alongside topic-wise self-assessment quizzes with instant explanation feedback.
- **Security & Authentication:** Anonymous and email authentication creating user profiles under `/users/{uid}`, screenshot and screen-recording prevention via Android `FLAG_SECURE`, sanitized public version control, and template-based Firebase configurations.
- **Backend:** Firebase Authentication, Cloud Firestore, and Firebase Hosting.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) (v3+)
- **Backend:** [Google Cloud Firebase](https://firebase.google.com/) (Auth, Cloud Firestore, Firebase Hosting)
- **PDF & Video Libraries:** `syncfusion_flutter_pdfviewer`, `youtube_player_iframe`, `url_launcher`
- **State & UI:** `google_fonts`, Material 3 design system

```
lib/
├── firebase_options.dart          # Local Firebase options (git-ignored)
├── firebase_options.example.dart  # Public template for Firebase options
├── main.dart                      # App entry point & Firebase initialization
├── models/
│   └── course_model.dart          # Course, Module & QuizQuestion models
├── screens/
│   ├── course_list_screen.dart    # Responsive course grid, search bar & web APK banner
│   ├── course_detail_screen.dart  # YouTube player, interactive MCQs & chapter list
│   └── pdf_viewer_screen.dart     # In-app PDF viewer with watermark attribution
└── services/
    ├── auth_service.dart          # Authentication & student profile syncing
    └── mock_data_service.dart     # Firestore catalog & MCQ seeding script
```

---

## 🔒 Security & Local Setup Guide

Sensitive service configuration files are excluded from this public repository. Follow these steps to configure your local development environment:

### 1. Firebase Options Setup
Copy the template configuration files and supply your project keys:

```bash
# Web / Dart options
cp lib/firebase_options.example.dart lib/firebase_options.dart

# Android options
cp android/app/google-services.json.example android/app/google-services.json
```

### 2. Fetch Dependencies & Run
```bash
# Fetch dependencies
flutter pub get

# Run on Web (Chrome)
flutter run -d chrome

# Run on connected Android device
flutter run
```

### 3. Build & Deploy
```bash
# Build web release build
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

---

## 📋 Operational Rules & Contribution Standards

- **Secrets Sanitation:** Never commit real credentials or keys. Ensure `android/app/google-services.json` and `lib/firebase_options.dart` remain in `.gitignore`.
- **Commit Standards:** Use Conventional Commits with scope and detailed bullet points (e.g., `feat(courses): add category filter`).
- **Documentation:** Keep `README.md` updated whenever new modules, dependencies, or architectural changes are introduced.

---

## 📄 License

All rights reserved © PCS Academy / Academic Press.
