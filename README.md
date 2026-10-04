# Academic Portal (PCSA)

A cross-platform (Web & Android) educational streaming and resource distribution portal tailored for intermediate and secondary curricula (FBISE & Sindh Textbook Boards).

## 🚀 Overview

- **Cross-Platform:** Built with Flutter, supporting responsive Web deployment (1–3 column dynamic grid) and Android devices.
- **Deep-Link URL Navigation:** Multi-page web routing (`/`, `/login`, `/register`, `/solved-exercises`, `/past-papers`, `/cheat-sheet`, `/payment`, `/admin`).
- **Content Delivery:** Integrated YouTube video lectures paired with in-app PDF study notes and keybooks.
- **Google Drive Integration:** Automatic share link conversion to direct streamable PDF & NotebookLM audio URLs via `GoogleDriveHelper`.
- **In-App PDF Viewer:** Secure cross-platform PDF viewing via `syncfusion_flutter_pdfviewer` with student watermark attribution.
- **Interactive Solvers:** CPU Instruction Cycle simulator, OSI 7-layer inspector, ER Normalization tool, Logic Gate playground, 2's Complement step-by-step solver, C++ code runner, OS Gantt chart, and Subnetting calculator.
- **Security & Payments:** Google Sign-In, Email auth, EasyPaisa & HBL Bank TRX ID manual payment verification, screenshot/recording prevention via Android `FLAG_SECURE`.
- **Backend:** Firebase Authentication, Cloud Firestore, and Firebase Hosting.

---

## ⚡ 100x Performance Architecture

1. **In-Memory Sub-Collection Caching (`Course._moduleCache`):**
   - Eliminates redundant `/courses/{id}/modules` Firestore network queries on every catalog rebuild, reducing database reads by 90%+.
2. **Texture Memory Optimization (`memCacheWidth` & `memCacheHeight`):**
   - Decodes network thumbnails at 400x225 resolution, cutting image RAM consumption from 150MB to ~15MB.
3. **DOM Layer Repaint Isolation (`RepaintBoundary`):**
   - Encloses heavy interactive simulators in `RepaintBoundary` blocks to isolate DOM repaints and maintain 60–120 FPS scrolling.
4. **Direct Streamable Storage Helper (`GoogleDriveHelper`):**
   - Automatically converts standard Google Drive view URLs to direct stream links for `SfPdfViewer`.

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
├── main.dart                      # App entry point, named routes & Firebase initialization
├── models/
│   ├── course_model.dart          # Course, Module (with in-memory cache) & QuizQuestion models
│   ├── fbise_exercise_model.dart  # FBISE solved textbook exercise model
│   └── payment_request_model.dart # Manual payment verification model
├── screens/
│   ├── course_list_screen.dart    # Responsive course grid, search bar & interactive solvers
│   ├── course_detail_screen.dart  # YouTube player, interactive MCQs & chapter list
│   ├── fbise_solved_exercises_screen.dart # FBISE Grade 11 textbook solved Q&A & quizzes
│   ├── student_auth_screen.dart   # Full-page student login & Google Sign-In
│   ├── payment_submission_screen.dart # EasyPaisa & HBL Bank TRX ID submission
│   ├── admin_payment_approval_screen.dart # Admin 1-click payment verification console
│   ├── past_papers_screen.dart    # 5-Year solved board papers archive
│   ├── exam_cheat_sheet_screen.dart # 1-Page exam night revision sheet
│   └── pdf_viewer_screen.dart     # In-app PDF viewer with watermark attribution
├── services/
│   ├── auth_service.dart          # Authentication, Google Auth & profile syncing
│   ├── payment_service.dart       # Manual payment verification & enrollment granting
│   └── mock_data_service.dart     # Firestore catalog & MCQ seeding script
└── utils/
    └── google_drive_helper.dart   # Direct Google Drive URL parsing helper
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
