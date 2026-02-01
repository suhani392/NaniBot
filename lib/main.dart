import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'onboarding/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NaniBot',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F0DF),
        textTheme: GoogleFonts.lindenHillTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF488345)),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

