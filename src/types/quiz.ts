export interface User {
  id: string;
  username: string;
  email: string;
  password: string;
}

export interface QuizChoice {
  id: string;
  text: string;
}

export interface QuizQuestion {
  id: string;
  text: string;
  choices: QuizChoice[];
  correctAnswerIndex: number;
}

export interface Quiz {
  id: string;
  title: string;
  description: string;
  questions: QuizQuestion[];
  createdBy: string;
  createdAt: string;
}

export interface QuizAnswer {
  questionId: string;
  selectedChoiceIndex: number | null;
}

export interface QuizResult {
  quizId: string;
  answers: QuizAnswer[];
  score: number;
  totalQuestions: number;
  completedAt: string;
}
