import 'package:client/feature/auth/view/pages/signup.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Beautiful Church',
      theme: ThemeV2.lightThemeMode,
      darkTheme: ThemeV2.darkThemeMode,
      home: SignupPage(),
    );
  }
}
