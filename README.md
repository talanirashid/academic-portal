# Pakistan Computer Science Academy (PCSA) Academic Portal

A cross-platform (Web & Android) educational streaming, interactive lab solver, and resource distribution portal tailored for Pakistani secondary and higher secondary CS curricula (FBISE Federal Board & Sindh Textbook Boards - Grades 9, 10, 11 & 12).

🌐 **Primary Web Production URL:** [https://pcsacademy.web.app](https://pcsacademy.web.app)  
🌐 **Fallback Hosting Target:** [https://academic-portal-pk.web.app](https://academic-portal-pk.web.app)  
📱 **Direct Android Release APK:** [PCSA-Academic-Portal-v1.0.0-arm64.apk](https://github.com/talanirashid/academic-portal/releases/download/v1.0.0/PCSA-Academic-Portal-v1.0.0-arm64.apk)

---

## 🏛️ Verified Institutional Credentials

- **Official Brand Logo Asset:** `assets/images/pcsa_logo.png`
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

- **Multi-Page Web Routing & Deep-Linking:** Full path routing (`/`, `/login`, `/register`, `/profile`, `/solved-exercises`, `/past-papers`, `/cheat-sheet`, `/payment`, `/command-center`, `/admin`, `/admin/approvals`) supporting browser back/forward history and direct link sharing.
- **PCSA Command Center (`/command-center`):**
  - **Module 1: Student Payment Verification Pipeline:** Fast TRX ID verification, `[RENEWAL]` vs `[NEW ENROLLMENT]` badges, and 1-click WhatsApp notification.
  - **Module 2: Course & Chapter Publisher:** Cascading board & class grade dropdowns (restricting 9th/10th for BSEK and 11th/12th for BIEK) with official 2026 textbook unit dropdown selectors (`DriveVaultConfig`).
  - **Module 3: Student Directory & Active Passes:** StreamBuilder roster with role audit and pass management.
  - **Module 4: Regional Board Analytics:** Real-time revenue PKR metrics and Student Retention Rate % tracking across all 8 Pakistani boards.
- **CS Practical & Interactive Lab (`CsPracticalLabSection`):**
  - **Tab 1: `[Board Practicals & Solved Copies]`:** Official Journal Tasks with watermarked PDF copies and Viva Voce Q&As.
  - **Tab 2: `[Interactive Visual Simulators]`:** CPU Instruction Cycle, Logic Gates & Truth Tables, K-Map 2-Variable Simplifier, 2's Complement Subtraction, OS Gantt Scheduler, CIDR Subnetting Calculator, DBMS SQL Sandbox, OSI 7-Layer Inspector, and ER Normalization.
  - **Tab 3: `[Code Runner & Reference]`:** In-Browser C++ & Python Code Runner pre-loaded with board-mandated programs + Technical Glossary & Acronyms Accordion.
- **Centralized Drive DataCenter & Obfuscation (`DriveVaultConfig` & `GoogleDriveHelper`):**
  - Master Folder ID obfuscated via compile-time Base64 reverse encryption (`MXZwSXo3MF9MdXNqWW1TTk1PYnpKUVhHZUVjSzAzaE83`), preventing raw ID exposure in public git commits.
  - Cryptographic link resolver extracting File IDs from share links, embed URLs, and uc export links.
  - Reusable `DrivePdfActionButton` providing clean responsive PDF viewing/downloading with upload pending fallback banners.
- **Reactive Header Action Widget (`UserProfileHeaderChip`):** Live stream subscription to `FirebaseAuth.instance.authStateChanges()` combined with Cloud Firestore `/users/{uid}` profile snapshots, displaying user avatar, name, and **`ADMIN` Amber Badge**.
- **Standardized Student Onboarding & Registration:** Full Name, WhatsApp Mobile (`03XX-XXXXXXX`), Board Selector (`FBISE`, `STBB`, `Other Boards`), Class Stream (`9th`, `10th`, `11th`, `12th`), Forgot Password Reset Email, and Google Sign-In.
- **Student Profile & Referral Engine (`StudentProfileScreen` at `/profile`):** Profile management, active subscription badges, unique referral code sharing (`PCSA_A1B2C3`), and interactive unit topic checklist ([`SyllabusTrackerWidget`](file:///F:/FlutterProjects/academic_portal/lib/widgets/syllabus_tracker_widget.dart)).
- **Academic Session Progression & Class Upgrade Loop (`SessionLifecycleService` & `ClassProgressionModal`):** Automated promotion mapping (`9th -> 10th`, `11th -> 12th`) and returning student renewal discount (**Rs. 850** instead of Rs. 999).
- **Anti-Piracy Protection:** Dynamic student attribution watermarking (`PdfService`) and selection/shortcut shield (`ProtectedContentWrapper`).

---

## 🔐 Enterprise Backend Architecture

1. **Least-Privilege Firestore Security Rules (`firestore.rules`):**
   - Enforces read/write security across `users`, `active_passes`, `payment_verifications`, `curriculums`, and `system_configs`.
2. **Composite Query Index Definitions (`firestore.indexes.json`):**
   - 5 composite indexes ensuring zero latency on sorted queues and multi-field queries.
3. **Cloud Storage Anti-Piracy Rules & CORS (`storage.rules` & `cors.json`):**
   - Size limits (5MB for receipt images, 35MB for curriculum PDFs) and CORS origins configured for `pcsacademy.web.app`.
4. **Automated n8n Payment Webhook Function (`functions/index.js`):**
   - Node 20 Cloud Function (`processAutomatedPaymentWebhook`) handling automated EasyPaisa/JazzCash SMS ingestion via n8n and atomic pass activation.
5. **Admin Custom Claims Provisioning Script (`scripts/grant_admin.js`):**
   - Standalone CLI Node script setting `admin: true` custom auth claims in Firebase Auth JWT.

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
│   ├── app_config.dart                 # Primary hosting domain constants (pcsacademy.web.app)
│   └── app_constants.dart              # Centralized logo asset, contact details & link launchers
├── core/
│   └── config/
│       └── drive_vault_config.dart     # Obfuscated Base64 DataCenter vault & 2026 unit lists
├── models/
│   ├── models.dart                     # Unified barrel export file
│   ├── academic_models.dart            # AcademicClass, CurriculumStream & 8 AcademicBoard registry
│   ├── course_content.dart             # SubLecture, ChapterItem & ComprehensiveCourse models
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
│   ├── command_center_screen.dart      # State-of-the-art PCSA Command Center (/command-center)
│   ├── payment_verification_view.dart  # Responsive payment verification table & filter pills
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
│   ├── auth_service.dart               # Auth, Google Sign-In with safe rootNavigator pop & profile sync
│   ├── access_control_service.dart     # Real-time board session deadline access evaluator
│   ├── session_lifecycle_service.dart  # Class promotion path mapping & session-end triggers
│   ├── payment_service.dart            # EasyPaisa/HBL account details & subscription upgrades
│   ├── student_payment_service.dart    # Duplicate TID check & atomic pass activation transaction
│   ├── pdf_service.dart                # Anti-piracy student attribution PDF watermarking
│   └── mock_data_service.dart          # Firestore catalog seeding script with Unit 1 Drive link
├── utils/
│   ├── board_validator.dart            # BoardJurisdictionGuard for board/grade sanitization
│   ├── google_drive_helper.dart        # Cryptographic Google Drive link extractor & launcher
│   └── media_helper.dart               # YouTube nocookie embed normalization & PDF launcher
└── widgets/
    ├── app_footer_widget.dart          # Professional web portal academic footer & social grid
    ├── brand_logo.dart                 # PCSABrandLogo with Web error fallback
    ├── user_profile_chip.dart          # UserProfileHeaderChip reactive profile pill & Admin badge
    ├── cs_practical_lab_section.dart   # CS Practical & Interactive Lab 3-Tab section
    ├── drive_pdf_action_button.dart    # Reusable PDF action button with pending upload banner
    ├── student_payment_status_widget.dart# Student payment status & resubmit banner
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

### 3. Build & Deploy Target Site
```bash
# Build web release build
flutter build web --release

# Deploy strictly to pcsacademy_web target
npx firebase-tools deploy --only hosting:pcsacademy_web
```

---

## 📋 Operational Rules & Contribution Standards

- **Secrets Sanitation:** Never commit real credentials or keys. Ensure `android/app/google-services.json`, `serviceAccountKey.json`, and `lib/firebase_options.dart` remain in `.gitignore`.
- **Commit Standards:** Use Conventional Commits with scope and detailed bullet points (e.g., `feat(vault): add Base64 reverse obfuscation`).
- **Documentation:** Keep `README.md` updated whenever new modules, dependencies, or architectural changes are introduced.

---

## 📄 License

All rights reserved © Pakistan Computer Science Academy (PCSA) / Academic Press.
