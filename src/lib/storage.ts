import { User, Quiz, QuizResult } from "@/types/quiz";

const USERS_KEY = "quiz_app_users";
const QUIZZES_KEY = "quiz_app_quizzes";
const CURRENT_USER_KEY = "quiz_app_current_user";
const RESULTS_KEY = "quiz_app_results";

// User Management
export const getUsers = (): User[] => {
  const users = localStorage.getItem(USERS_KEY);
  return users ? JSON.parse(users) : [];
};

export const saveUser = (user: User): void => {
  const users = getUsers();
  users.push(user);
  localStorage.setItem(USERS_KEY, JSON.stringify(users));
};

export const findUser = (email: string, password: string): User | null => {
  const users = getUsers();
  return users.find((u) => u.email === email && u.password === password) || null;
};

export const getCurrentUser = (): User | null => {
  const user = localStorage.getItem(CURRENT_USER_KEY);
  return user ? JSON.parse(user) : null;
};

export const setCurrentUser = (user: User | null): void => {
  if (user) {
    localStorage.setItem(CURRENT_USER_KEY, JSON.stringify(user));
  } else {
    localStorage.removeItem(CURRENT_USER_KEY);
  }
};

// Quiz Management
export const getQuizzes = (): Quiz[] => {
  const quizzes = localStorage.getItem(QUIZZES_KEY);
  return quizzes ? JSON.parse(quizzes) : [];
};

export const saveQuiz = (quiz: Quiz): void => {
  const quizzes = getQuizzes();
  quizzes.push(quiz);
  localStorage.setItem(QUIZZES_KEY, JSON.stringify(quizzes));
};

export const getQuizById = (id: string): Quiz | null => {
  const quizzes = getQuizzes();
  return quizzes.find((q) => q.id === id) || null;
};

// Results Management
export const saveQuizResult = (result: QuizResult): void => {
  const results = getQuizResults();
  results.push(result);
  localStorage.setItem(RESULTS_KEY, JSON.stringify(results));
};

export const getQuizResults = (): QuizResult[] => {
  const results = localStorage.getItem(RESULTS_KEY);
  return results ? JSON.parse(results) : [];
};
