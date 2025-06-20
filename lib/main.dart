import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/objects/add_object_screen.dart';
import 'screens/objects/object_details_screen.dart';
import 'screens/objects/report_stolen_object_screen.dart';
import 'screens/home/police_home_screen.dart';
import 'screens/auth/user_type_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objeto Rastreado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          primary: const Color(0xFF1E88E5),
          secondary: const Color(0xFF42A5F5),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/user_type',
      routes: {
        '/user_type': (context) => const UserTypeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/police_home': (context) => const PoliceHomeScreen(),
        '/add_object': (context) => const AddObjectScreen(),
        '/object_details': (context) => const ObjectDetailsScreen(),
        '/report_stolen': (context) => const ReportStolenObjectScreen(),
      },
    );
  }
}
