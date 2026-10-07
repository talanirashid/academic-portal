import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'features/curriculum/screens/curriculum_hub_screen.dart';
import 'features/profile/screens/student_profile_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_payment_approval_screen.dart';
import 'screens/command_center_screen.dart';
import 'screens/course_list_screen.dart';
import 'screens/exam_cheat_sheet_screen.dart';
import 'screens/fbise_solved_exercises_screen.dart';
import 'screens/past_papers_screen.dart';
import 'screens/payment_submission_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/student_auth_screen.dart';
import 'services/auth_service.dart';
import 'services/mock_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Force seed sample courses into Firestore immediately on startup
  await MockDataService.forceSeedDatabase();

  // Auto-ensure anonymous student user session on startup if not logged in
  final authService = AuthService();
  if (authService.currentUser == null) {
    try {
      await authService.signInAnonymously();
    } catch (_) {
      // Silent catch for initial offline launches
    }
  }

  runApp(const AcademicPortalApp());
}

class AcademicPortalApp extends StatelessWidget {
  const AcademicPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pakistan Computer Science Academy | Academic Portal & Resource Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006633),
          primary: const Color(0xFF006633),
          secondary: const Color(0xFF004D26),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CourseListScreen(),
        '/login': (context) => const StudentAuthScreen(initialIsSignUp: false),
        '/register': (context) => const StudentAuthScreen(initialIsSignUp: true),
        '/profile': (context) => const StudentProfileScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),
        '/hub': (context) => const CurriculumHubScreen(),
        '/past-papers': (context) => const PastPapersScreen(),
        '/cheat-sheet': (context) => const ExamCheatSheetScreen(),
        '/solved-exercises': (context) => const FbiseSolvedExercisesScreen(),
        '/payment': (context) => const PaymentSubmissionScreen(),
        '/command-center': (context) => const CommandCenterScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
        '/admin/approvals': (context) => const AdminPaymentApprovalScreen(),
      },
    );
  }
}
