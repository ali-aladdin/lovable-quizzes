import 'package:flutter/material.dart';

import '../models/quiz.dart';

class QuestionResultTile extends StatelessWidget {
  const QuestionResultTile({
    required this.question,
    required this.selectedIndex,
    super.key,
  });

  final QuizQuestion question;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCorrect = selectedIndex == question.correctAnswerIndex;
    return Card(
      color: isCorrect
          ? theme.colorScheme.secondaryContainer
          : theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              isCorrect ? 'Correct' : 'Incorrect',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isCorrect
                    ? theme.colorScheme.onSecondaryContainer
                    : theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your answer: '
              '${selectedIndex != null ? question.choices[selectedIndex!].text : 'No answer'}',
            ),
            Text('Correct answer: ${question.choices[question.correctAnswerIndex].text}'),
          ],
        ),
      ),
    );
  }
}
