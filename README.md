# Pakistan Computer Science Academy (PCSA) Academic Portal

A cross-platform (Web & Android) educational streaming, interactive solver, and resource distribution portal tailored for Pakistani secondary and higher secondary CS curricula (FBISE Federal Board & Sindh Textbook Boards - Grade 11 & 12).

🌐 **Production Web URL:** [https://academic-portal-pk.web.app](https://academic-portal-pk.web.app)  
📱 **Direct Android Release APK:** [PCSA-Academic-Portal-v1.0.0-arm64.apk](https://github.com/talanirashid/academic-portal/releases/download/v1.0.0/PCSA-Academic-Portal-v1.0.0-arm64.apk)

---

## 🚀 Key Portal Features

- **Multi-Page Web Routing & Deep-Linking:** Full URL path routing (`/`, `/login`, `/register`, `/solved-exercises`, `/past-papers`, `/cheat-sheet`, `/payment`, `/admin`, `/admin/approvals`) supporting browser back/forward history and direct link sharing.
- **FBISE Grade 11 Solved Textbook Exercises & Quizzes:** Chapter-by-chapter solved short questions, long board questions, and interactive self-assessment MCQs with instant green/red option feedback and explanations.
- **Google Drive & NotebookLM Integration:** Seamless parsing of official Google Drive sharing URLs (`GoogleDriveHelper`) for direct streamable PDF keybooks and NotebookLM AI audio podcast lectures.
- **Interactive Solvers & Simulators:**
  - ⚙️ **CPU Instruction Cycle Simulator:** Visual Fetch-Decode-Execute register inspector (PC, MAR, MDR, IR, ACC) for FBISE Unit 3.
  - 🌐 **OSI 7-Layer Model Inspector:** Data encapsulation PDU, protocol stack, and layer function visualizer for FBISE Unit 5.
  - 📊 **ER Diagram & Normalization Guide:** 1NF, 2NF, 3NF normalization rules and 1:1, 1:N, M:N cardinalities for FBISE Unit 7.
  - 💻 **Class 12 C++ Code Runner & Memory Tracer:** Variable trace simulator for arrays, pointers, and structures.
  - 🔢 **2's Complement Subtraction Solver:** Step-by-step binary subtraction with 1's complement bit inversion and 9th carry bit discard.
  - ⏱️ **OS Process Scheduling Gantt Chart:** FCFS and SJF execution order and average waiting time calculator.
  - 🌐 **Subnetting & CIDR Calculator:** Network ID, prefix mask (`/24`, `/26`, `/28`), and usable host limits.
  - 🗄️ **DBMS SQL Query Sandbox:** Interactive SQL `SELECT`, `WHERE`, `ORDER BY` query simulator.
  - 🧩 **Logic Gate Playground & Truth Table Generator:** Interactive circuit simulator (AND, OR, NOT, NAND, NOR, XOR, XNOR).
  - 🧮 **K-Map 2-Variable Simplifier:** Real-time SOP Boolean expression minimizer.
  - 📝 **1-Page Exam Night Cheat Sheet:** Concise high-yield revision notes across all 5 core units.
  - 🏆 **Gamified Student Mastery Badges:** Achievement tracking (*Logic Guru*, *Binary Architect*, *C++ Master*, *SQL Wizard*, *Board Ready*).
- **Manual Payment Gateways & Instant Unlocking:**
  - **EasyPaisa:** Title: `Muhammad Rashid` | Number: `03123656361`
  - **HBL Bank:** Title: `Muhammad Rashid` | Account: `00717918821503`
  - Students submit TRX IDs via `/payment`, and Admins verify with 1-click at `/admin/approvals` to grant instant course enrollment.
- **In-App DRM PDF Viewer:** Embedded viewing via `syncfusion_flutter_pdfviewer` featuring dynamic position-jitter watermark attribution (`Licensed to: {email} • PCSA DRM`).
- **Security & Protection:** Google Sign-In, Email/Password Registration, Anonymous Guest Session, and screenshot/screen-recording prevention via Android `FLAG_SECURE`.

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
├── models/
│   ├── models.dart                     # Unified barrel export file
│   ├── course_model.dart               # Course class & 100x in-memory cache loader
│   ├── module_model.dart               # Module class with author & notes URL properties
│   ├── quiz_question_model.dart        # QuizQuestion class & options parser
│   ├── fbise_exercise_model.dart       # FBISE Grade 11 textbook solved exercise model
│   ├── past_paper_model.dart          # 5-Year solved board paper model
│   └── payment_request_model.dart      # EasyPaisa & HBL TRX ID payment request model
├── screens/
│   ├── course_list_screen.dart         # Responsive catalog grid, search bar & solvers accordion
│   ├── course_detail_screen.dart       # YouTube player, speed controls, MCQs & chapter list
│   ├── fbise_solved_exercises_screen.dart # FBISE textbook solved Q&A & practice quizzes
│   ├── student_auth_screen.dart        # Full-page student login & Google Sign-In (/login)
│   ├── payment_submission_screen.dart  # EasyPaisa & HBL TRX ID submission (/payment)
│   ├── admin_payment_approval_screen.dart # Admin 1-click payment verification console
│   ├── admin_dashboard_screen.dart     # Content publishing panel & admin tools (/admin)
│   ├── past_papers_screen.dart         # 5-Year solved board papers archive (/past-papers)
│   ├── exam_cheat_sheet_screen.dart    # 1-Page exam night revision sheet (/cheat-sheet)
│   └── pdf_viewer_screen.dart          # In-app PDF viewer with dynamic watermark DRM
├── services/
│   ├── auth_service.dart               # Auth, Google Sign-In & progress tracking
│   ├── payment_service.dart            # EasyPaisa/HBL account details & course enrollment
│   └── mock_data_service.dart          # Firestore catalog seeding script with Unit 1 Drive link
├── utils/
│   └── google_drive_helper.dart        # Direct Google Drive streamable URL parser
└── widgets/
    ├── app_footer_widget.dart          # Professional web portal academic footer
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
