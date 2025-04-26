import 'package:client/core/provider/current_user_provider.dart';
import 'package:client/feature/auth/view/pages/login.dart';
import 'package:client/feature/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/feature/home/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharePreferences();
  await container.read(authViewModelProvider.notifier).getCurrentUserData();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Beautiful Church',
      theme: ThemeV2.lightThemeMode,
      darkTheme: ThemeV2.darkThemeMode,
      home: currentUser == null ? LoginPage() : HomePage(),
    );
  }
}
