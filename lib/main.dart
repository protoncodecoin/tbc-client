import 'package:client/feature/auth/view/pages/signup.dart';
import 'package:client/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container
      .read(authRegisterViewModelProvider.notifier)
      .initSharePreferences();
  final userModel = await container
      .read(authRegisterViewModelProvider.notifier)
      .getCurrentUserData();

  print(userModel);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
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
