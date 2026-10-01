import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import semua screen utama
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/tracking_screen.dart';
import 'screens/education_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/test_learning_style_screen.dart';
import 'screens/forgot_password_screen.dart';

// Tambahan baru: Belanja, Platform, Lainnya
import 'screens/shopping_screen.dart';
import 'screens/platform_screen.dart';
import 'screens/others_screen.dart';

// ✅ Import tambahan untuk notifikasi
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://wyjyfjkschkjhaafbkmw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind5anlmamtzY2hramhhYWZia213Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgwMzM0MzYsImV4cCI6MjA5MzYwOTQzNn0.G6tDQdYrqI3CgdY1E9ccgLukymm1U0EHPZV1UZD22UA',
  );

  // ✅ Inisialisasi service notifikasi lokal
  await NotificationService.init();

  // ✅ Load file environment (.env)
  await dotenv.load(fileName: ".env");

  // Inisialisasi format tanggal lokal Indonesia
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IE-Parent',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/tracking': (context) => const TrackingScreen(),
        '/edukasi': (context) => const EducationScreen(),
        '/plan': (context) => const PlanScreen(),
        '/test': (context) => TestLearningStyleScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),

        // Tambahan rute untuk fitur tambahan
        '/belanja': (context) => const ShoppingScreen(),
        '/platform': (context) => const PlatformScreen(),
        '/lainnya': (context) => const OthersScreen(),
      },
    );
  }
}
