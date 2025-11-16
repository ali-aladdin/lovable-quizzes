import 'package:flutter/material.dart';

import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../utils/id_generator.dart';

class QuizProvider with ChangeNotifier {
  QuizProvider() {
    _quizzes = [
      Quiz(
        id: generateId('quiz'),
        title: 'General Knowledge',
        description: 'A quick trivia warm-up covering history, science, and pop culture.',
        createdBy: 'Quiz Master',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        questions: [
          QuizQuestion(
            id: generateId('question'),
            text: 'Which planet is known as the Red Planet?',
            correctAnswerIndex: 1,
            choices: const [
              QuizChoice(id: 'choice-1', text: 'Venus'),
              QuizChoice(id: 'choice-2', text: 'Mars'),
              QuizChoice(id: 'choice-3', text: 'Jupiter'),
            ],
          ),
          QuizQuestion(
            id: generateId('question'),
            text: 'In which year did the World Wide Web go public?',
            correctAnswerIndex: 0,
            choices: const [
              QuizChoice(id: 'choice-4', text: '1991'),
              QuizChoice(id: 'choice-5', text: '1989'),
              QuizChoice(id: 'choice-6', text: '1995'),
            ],
          ),
        ],
      ),
    ];
  }

  late List<Quiz> _quizzes;
  final List<QuizResult> _results = [];

  List<Quiz> get quizzes => List.unmodifiable(_quizzes);
  List<QuizResult> get results => List.unmodifiable(_results);

  Quiz? getQuizById(String id) {
    try {
      return _quizzes.firstWhere((quiz) => quiz.id == id);
    } catch (_) {
      return null;
    }
  }

  void addQuiz(Quiz quiz) {
    _quizzes = [..._quizzes, quiz];
    notifyListeners();
  }

  QuizResult submitQuiz({
    required Quiz quiz,
    required Map<String, int?> selectedAnswers,
  }) {
    var score = 0;
    final answers = quiz.questions.map((question) {
      final selectedIndex = selectedAnswers[question.id];
      if (selectedIndex != null && selectedIndex == question.correctAnswerIndex) {
        score++;
      }
      return QuizAnswer(
        questionId: question.id,
        selectedChoiceIndex: selectedIndex,
      );
    }).toList();

    final result = QuizResult(
      quizId: quiz.id,
      answers: answers,
      score: score,
      totalQuestions: quiz.questions.length,
      completedAt: DateTime.now(),
    );
    _results.add(result);
    notifyListeners();
    return result;
  }
}
