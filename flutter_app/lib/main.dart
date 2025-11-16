import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/add_quiz_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/solve_quiz_screen.dart';

void main() {
  runApp(const LovableQuizzesApp());
}

class LovableQuizzesApp extends StatelessWidget {
  const LovableQuizzesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: MaterialApp(
        title: 'Lovable Quizzes',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF6366F1),
          inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
        ),
        routes: {
          SignInScreen.routeName: (_) => const SignInScreen(),
          SignUpScreen.routeName: (_) => const SignUpScreen(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          AddQuizScreen.routeName: (_) => const AddQuizScreen(),
          ResultScreen.routeName: (_) => const ResultScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == SolveQuizScreen.routeName) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => const SolveQuizScreen(),
            );
          }
          return null;
        },
        home: const _RootRouter(),
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isAuthenticated) {
          return const HomeScreen();
        }
        return const SignInScreen();
      },
    );
  }
}
