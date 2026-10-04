# Pakistan Computer Science Academy (PCSA) Academic Portal

A cross-platform (Web & Android) educational streaming, interactive lab solver, and resource distribution portal tailored for Pakistani secondary and higher secondary CS curricula (FBISE Federal Board & Sindh Textbook Boards - Grades 9, 10, 11 & 12).

🌐 **Production Web URL:** [https://academic-portal-pk.web.app](https://academic-portal-pk.web.app)  
📱 **Direct Android Release APK:** [PCSA-Academic-Portal-v1.0.0-arm64.apk](https://github.com/talanirashid/academic-portal/releases/download/v1.0.0/PCSA-Academic-Portal-v1.0.0-arm64.apk)

---

## 🏛️ Verified Institutional Credentials

- **Official Brand Logo Asset:** `assets/images/logo.png`
- **Official Support Email:** `pcsacademy.pk@gmail.com`
- **Official Helpline / WhatsApp:** `+92 333 6366291` (`923336366291`)
- **Unified Social Handle (`@PCSAcademypk`):**
  - **YouTube:** [https://www.youtube.com/@PCSAcademypk](https://www.youtube.com/@PCSAcademypk)
  - **Facebook:** [https://www.facebook.com/PCSAcademypk](https://www.facebook.com/PCSAcademypk)
  - **Instagram:** [https://www.instagram.com/PCSAcademypk](https://www.instagram.com/PCSAcademypk)
  - **TikTok:** [https://www.tiktok.com/@PCSAcademypk](https://www.tiktok.com/@PCSAcademypk)
  - **WhatsApp Channel:** [https://whatsapp.com/channel/PCSAcademypk](https://whatsapp.com/channel/PCSAcademypk)

---

## 🚀 Key Portal Features

- **Multi-Page Web Routing & Deep-Linking:** Full path routing (`/`, `/login`, `/register`, `/profile`, `/solved-exercises`, `/past-papers`, `/cheat-sheet`, `/payment`, `/admin`, `/admin/approvals`) supporting browser back/forward history and direct link sharing.
- **Reactive Header Action & User Session Widget (`UserHeaderActionWidget`):** Live stream subscription to `FirebaseAuth.instance.authStateChanges()` combined with Cloud Firestore `/users/{uid}` profile snapshots, displaying student name, photo, and **`ADMIN` Amber Badge**.
- **Standardized Student Onboarding & Registration:**
  - Full Name Field & WhatsApp Mobile Number (`03XX-XXXXXXX` format validation).
  - Educational Board Selector (`FBISE Islamabad`, `STBB Sindh Boards`, `Other Boards`).
  - STBB Helper Note: *"Covers Karachi, Hyderabad, Sukkur, Larkana, Mirpurkhas, and SBA under the standardized provincial STBB curriculum."*
  - Class Stream Selector (`Class 9th SSC-I`, `Class 10th SSC-II`, `Class 11th HSSC-I`, `Class 12th HSSC-II`).
  - Forgot Password Reset Email workflow (`FirebaseAuth.instance.sendPasswordResetEmail`).
  - Dual Sign-In: Email/Password or 1-tap Google Sign-In (`GoogleAuthProvider`).
- **Student Profile & Referral Engine (`StudentProfileScreen` at `/profile`):**
  - Profile management, password reset triggers, active subscription badges, and unique referral code sharing (`PCSA_A1B2C3`) for free Pro Pass rewards.
- **Interactive Syllabus Preparation Tracker (`SyllabusTrackerWidget`):**
  - Unit topic checklist (*Theory Read*, *SLO MCQs Passed*, *ERQs Revised*, *Lab Practiced*) with visual progress percentage bar (*"70% Prepared"*).
- **Academic Session Progression & Class Upgrade Loop (`SessionLifecycleService` & `ClassProgressionModal`):**
  - Automated promotion path mapping (`9th -> 10th`, `11th -> 12th`).
  - Hard-cutoff expiration policy terminating subscriptions at annual board exam deadlines.
  - Returning Student Continuity Discount modal offering **Rs. 850** renewal pricing (saving Rs. 150 off Rs. 999 standard rate) with 1-click WhatsApp instant activation.
- **Centralized Session Date Controller (`AdminExamSessionManager`):**
  - Admin DatePicker UI to extend annual board exam deadlines across all enrolled students in real time.
- **FBISE Grade 11 Solved Textbook Exercises & Quizzes:** Solved short questions, long board questions, and practice quizzes with green/red option selection feedback.
- **Google Drive & NotebookLM Integration (`GoogleDriveHelper`):** Automatic share link conversion for direct streamable PDF keybooks and NotebookLM AI audio podcast lectures.
- **Modular Computing Solver & Practical Hub (`PracticalHubWidget`):**
  - 🧠 **CPU & Digital Logic** (CPU Fetch-Execute Cycle Simulator, Logic Gate Playground)
  - 🧮 **Number Systems & K-Map** (2's Complement Solver, K-Map Simplifier, Base Remainder Calculator)
  - 💻 **Programming & OS** (Class 12 C++ Code Runner & Memory Tracer, OS Gantt Scheduler)
  - 🌐 **Networks & DBMS** (Subnetting CIDR Calculator, SQL Sandbox, OSI 7-Layer, ER Normalization)
  - 📖 **Glossary & Acronyms** (Bilingual Technical Glossary, Computing Acronyms)
- **Anti-Piracy Protection:** Dynamic student attribution watermarking (`PdfService`) and text selection/shortcut shield (`ProtectedContentWrapper`).
- **Financial Analytics Console (`AdminPaymentApprovalScreen`):** Real-time daily PKR revenue metrics, pending/approved request counts, and Student Retention Rate % tracking.

---

## ⚡ 100x Performance Architecture

1. **In-Memory Sub-Collection Caching (`Course._moduleCache`):**
   - Eliminates redundant `/courses/{id}/modules` Firestore network queries on every catalog rebuild, reducing database reads by 90%+.
2. **DOM Layer Repaint Isolation (`RepaintBoundary`):**
   - Encloses heavy interactive simulators in `RepaintBoundary` blocks to isolate DOM repaints and maintain 60–120 FPS scrolling.
3. **Smooth Viewport Slivers (`CustomScrollView`):**
   - Replaced rigid column layouts with custom sliver grids and box adapters for fluid viewport scrolling on Web and Mobile.

---

## 🛠️ Repository & Codebase Directory Map

```text
lib/
├── firebase_options.dart               # Local Firebase configuration (git-ignored)
├── firebase_options.example.dart       # Public template for Firebase options
├── main.dart                           # App entry point, MaterialApp routes & Firebase init
├── constants/
│   └── app_constants.dart              # Centralized logo asset, contact details & link launchers
├── models/
│   ├── models.dart                     # Unified barrel export file
│   ├── course_model.dart               # Course class & 100x in-memory cache loader
│   ├── module_model.dart               # Module class with author & notes URL properties
│   ├── quiz_question_model.dart        # QuizQuestion class & options parser
│   ├── fbise_exercise_model.dart       # FBISE Grade 11 textbook solved exercise model
│   ├── past_paper_model.dart          # 5-Year solved board paper model
│   ├── payment_request_model.dart      # EasyPaisa & HBL TRX ID payment request model
│   ├── session_config_model.dart       # Centralized annual board exam session config
│   └── user_model.dart                 # UserModel, UserSubscription, RBAC roles & referrals
├── screens/
│   ├── course_list_screen.dart         # Responsive catalog grid, search bar & solvers accordion
│   ├── course_detail_screen.dart       # YouTube player, speed controls, MCQs & chapter list
│   ├── fbise_solved_exercises_screen.dart # FBISE textbook solved Q&A & practice quizzes
│   ├── student_auth_screen.dart        # Full-page student login & Google Sign-In (/login)
│   ├── student_auth_dialog.dart        # Standardized student authentication modal dialog
│   ├── student_profile_screen.dart     # Student profile & progress management (/profile)
│   ├── payment_submission_screen.dart  # EasyPaisa & HBL TRX ID submission (/payment)
│   ├── admin_payment_approval_screen.dart # Admin 1-click verification console & financial analytics
│   ├── admin_exam_session_manager.dart # Admin DatePicker for board exam session deadlines
│   ├── admin_dashboard_screen.dart     # Content publishing panel & admin tools (/admin)
│   ├── past_papers_screen.dart         # 5-Year solved board papers archive (/past-papers)
│   ├── exam_cheat_sheet_screen.dart    # 1-Page exam night revision sheet (/cheat-sheet)
│   └── pdf_viewer_screen.dart          # In-app PDF viewer with dynamic watermark DRM
├── services/
│   ├── auth_service.dart               # Auth, Google Sign-In, profile sync & safe pop
│   ├── access_control_service.dart     # Real-time board session deadline access evaluator
│   ├── session_lifecycle_service.dart  # Class promotion path mapping & session-end triggers
│   ├── payment_service.dart            # EasyPaisa/HBL account details & subscription upgrades
│   ├── pdf_service.dart                # Anti-piracy student attribution PDF watermarking
│   └── mock_data_service.dart          # Firestore catalog seeding script with Unit 1 Drive link
├── utils/
│   └── google_drive_helper.dart        # Direct Google Drive streamable URL parser
└── widgets/
    ├── app_footer_widget.dart          # Professional web portal academic footer & social grid
    ├── user_header_action_widget.dart   # Reactive top bar session avatar, name & Admin badge
    ├── practical_hub_widget.dart       # Categorized modular computing solver lab grid
    ├── content_access_gate.dart        # Freemium value-hook content gate
    ├── blur_overlay.dart               # Glassmorphic cliffhanger blur overlay widget
    ├── pricing_modal.dart              # Upgrade to Pro modal with 1-click WhatsApp verification
    ├── class_progression_modal.dart    # Returning student class upgrade modal with Rs 850 discount
    ├── protected_content_wrapper.dart  # Anti-piracy content selection & shortcut shield
    ├── syllabus_tracker_widget.dart    # Unit topic preparation checklist & progress bar
    ├── cpu_cycle_simulator_widget.dart  # CPU Fetch-Decode-Execute register simulator
    ├── osi_model_inspector_widget.dart  # OSI 7-Layer encapsulation visualizer
    ├── er_diagram_normalization_widget.dart # 1NF, 2NF, 3NF & ER Cardinality guide
    ├── cpp_code_runner_widget.dart      # C++ code execution & memory tracer
    ├── twos_complement_solver_widget.dart # 2's Complement binary subtraction solver
    ├── gantt_chart_simulator_widget.dart# OS Process scheduling Gantt chart
    ├── subnet_calculator_widget.dart   # Network CIDR subnetting calculator
    ├── sql_sandbox_widget.dart         # DBMS SQL SELECT query sandbox
    ├── logic_gate_simulator_widget.dart# Logic gate playground & truth table
    ├── kmap_solver_widget.dart         # K-Map 2-variable Boolean simplifier
    ├── bilingual_tooltip_widget.dart   # Urdu/English terminology glossary
    ├── acronym_glossary_widget.dart    # Computing acronyms accordion
    ├── number_system_scratchpad_widget.dart # Base conversion remainder scratchpad
    ├── exam_countdown_widget.dart      # Annual board exam countdown timer
    └── student_badges_widget.dart      # Gamified subject mastery achievement badges
```

---

## 🔒 Security & Local Development Setup

Sensitive service configuration files are excluded from this public repository. Follow these steps to configure your local environment:

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
- **Commit Standards:** Use Conventional Commits with scope and detailed bullet points (e.g., `feat(auth): add Google Sign-In support`).
- **Documentation:** Keep `README.md` updated whenever new modules, dependencies, or architectural changes are introduced.

---

## 📄 License

All rights reserved © Pakistan Computer Science Academy (PCSA) / Academic Press.
