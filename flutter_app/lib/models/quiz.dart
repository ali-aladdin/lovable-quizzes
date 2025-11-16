class QuizChoice {
  const QuizChoice({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.text,
    required this.choices,
    required this.correctAnswerIndex,
  });

  final String id;
  final String text;
  final List<QuizChoice> choices;
  final int correctAnswerIndex;
}

class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final String createdBy;
  final DateTime createdAt;
}
