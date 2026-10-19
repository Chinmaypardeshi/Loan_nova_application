import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loannova_mobile_app/screens/providers/app_state.dart';
import 'package:loannova_mobile_app/screens/auth/login_screen.dart';
import 'package:loannova_mobile_app/screens/main_navigation_shell.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Supabase with your project credentials
  await Supabase.initialize(
    url: 'https://zexqcbyyosuzmhodyaxk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpleHFjYnl5b3N1em1ob2R5YXhrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTExNjc0MjAsImV4cCI6MjEwNjc0MzQyMH0.SpA4odV6Wd8-BzzNLX-f7xVe9ZAfTK2t2nl-4tGcc1I',
  );

  runApp(
    // 2. Wrap the app with ChangeNotifierProvider and instantly trigger session check
    ChangeNotifierProvider(
      create: (_) => AppState()..checkInitialSession(),
      child: const LoanNovaApp(),
    ),
  );
}

class LoanNovaApp extends StatelessWidget {
  const LoanNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoanNova Enterprise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      // 3. Listen to AppState to automatically switch between Login and the Main Shell
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return appState.isLoggedIn
              ? const MainNavigationShell()
              : const LoginScreen();
        },
      ),
    );
  }
}