import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/course_list_screen.dart';
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
      title: 'Academic Portal Pakistan',
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
      home: const CourseListScreen(),
    );
  }
}
