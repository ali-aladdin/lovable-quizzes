class QuizAnswer {
  const QuizAnswer({
    required this.questionId,
    required this.selectedChoiceIndex,
  });

  final String questionId;
  final int? selectedChoiceIndex;
}

class QuizResult {
  const QuizResult({
    required this.quizId,
    required this.answers,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
  });

  final String quizId;
  final List<QuizAnswer> answers;
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
}
