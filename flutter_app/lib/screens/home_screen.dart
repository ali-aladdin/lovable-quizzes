import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_card.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final quizProvider = context.watch<QuizProvider>();
    final quizzes = quizProvider.quizzes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Master'),
        actions: [
          IconButton(
            tooltip: 'Create Quiz',
            onPressed: () => Navigator.pushNamed(context, '/create-quiz'),
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                SignInScreen.routeName,
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: quizzes.isEmpty
            ? _EmptyState(onCreateQuiz: () => Navigator.pushNamed(context, '/create-quiz'))
            : _QuizGrid(
                quizzes: quizzes,
                onQuizTap: (quiz) {
                  Navigator.pushNamed(context, '/quiz', arguments: quiz.id);
                },
              ),
      ),
    );
  }
}

class _QuizGrid extends StatelessWidget {
  const _QuizGrid({required this.quizzes, required this.onQuizTap});

  final List<Quiz> quizzes;
  final void Function(Quiz quiz) onQuizTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 4 / 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return QuizCard(
          quiz: quiz,
          onTap: () => onQuizTap(quiz),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateQuiz});

  final VoidCallback onCreateQuiz;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'No quizzes yet',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first quiz to get started.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreateQuiz,
            icon: const Icon(Icons.add),
            label: const Text('Create Quiz'),
          ),
        ],
      ),
    );
  }
}
