import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../providers/quiz_provider.dart';
import '../widgets/answer_option_tile.dart';
import '../widgets/question_result_tile.dart';
import 'home_screen.dart';

class SolveQuizArguments {
  SolveQuizArguments(this.quizId);

  final String quizId;
}

class SolveQuizScreen extends StatefulWidget {
  const SolveQuizScreen({super.key});

  static const routeName = '/quiz';

  @override
  State<SolveQuizScreen> createState() => _SolveQuizScreenState();
}

class _SolveQuizScreenState extends State<SolveQuizScreen> {
  final Map<String, int?> _selectedAnswers = {};

  void _onSelect(String questionId, int? choiceIndex) {
    setState(() => _selectedAnswers[questionId] = choiceIndex);
  }

  void _submitQuiz(Quiz quiz) {
    final quizProvider = context.read<QuizProvider>();
    final result = quizProvider.submitQuiz(
      quiz: quiz,
      selectedAnswers: _selectedAnswers,
    );
    Navigator.pushReplacementNamed(
      context,
      ResultScreen.routeName,
      arguments: ResultScreenArguments(quiz: quiz, result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final quizId = args is String ? args : (args is SolveQuizArguments ? args.quizId : null);
    final quiz = context.select<QuizProvider, Quiz?>(
      (provider) => quizId != null ? provider.getQuizById(quizId) : null,
    );

    if (quiz == null) {
      return const Scaffold(
        body: Center(child: Text('Quiz not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: quiz.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  final selectedIndex = _selectedAnswers[question.id];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${index + 1}',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(question.text, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          ...List.generate(question.choices.length, (choiceIndex) {
                            final choice = question.choices[choiceIndex];
                            return AnswerOptionTile(
                              value: choiceIndex,
                              groupValue: selectedIndex,
                              label: choice.text,
                              onChanged: (value) => _onSelect(question.id, value),
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => _submitQuiz(quiz),
                child: const Text('Submit Answers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreenArguments {
  const ResultScreenArguments({required this.quiz, required this.result});

  final Quiz quiz;
  final QuizResult result;
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  static const routeName = '/quiz/result';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is! ResultScreenArguments) {
      return const Scaffold(body: Center(child: Text('No results available.')));
    }

    final quiz = args.quiz;
    final result = args.result;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('${result.score} / ${result.totalQuestions} correct'),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: quiz.questions.length,
                itemBuilder: (context, index) {
                  final question = quiz.questions[index];
                  final selected = result.answers.firstWhere(
                    (answer) => answer.questionId == question.id,
                    orElse: () => QuizAnswer(questionId: question.id, selectedChoiceIndex: null),
                  );
                  return QuestionResultTile(
                    question: question,
                    selectedIndex: selected.selectedChoiceIndex,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeName,
                (route) => false,
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
