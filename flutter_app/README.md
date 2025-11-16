# Flutter Translation of Lovable Quizzes

This folder contains a Flutter 3 application that mirrors every feature of the existing React quiz experience.

## 1. Translation Plan (React ➜ Flutter)
| React Source | Flutter Destination | Notes |
| --- | --- | --- |
| `src/main.tsx`, `src/App.tsx`, router setup | `lib/main.dart` | MaterialApp with `ChangeNotifierProvider` replaces React Router wrapper. |
| `src/types/quiz.ts` | `lib/models/user.dart`, `lib/models/quiz.dart`, `lib/models/quiz_result.dart` | Dart data classes with `copyWith` helpers. |
| `src/lib/storage.ts` | `lib/providers/auth_provider.dart`, `lib/providers/quiz_provider.dart` | LocalStorage logic replaced with in-memory providers powered by `ChangeNotifier`. |
| `src/pages/SignIn.tsx` | `lib/screens/sign_in_screen.dart` | Form validation + Provider-driven auth. |
| `src/pages/SignUp.tsx` | `lib/screens/sign_up_screen.dart` | Handles registration and redirects to Sign In. |
| `src/pages/Home.tsx` | `lib/screens/home_screen.dart` | Lists quizzes, logout action, navigate to solver/create screens. |
| `src/pages/CreateQuiz.tsx` | `lib/screens/add_quiz_screen.dart` + `lib/widgets/question_form_section.dart` | Dynamic question + choice editors with validation. |
| `src/pages/SolveQuiz.tsx` | `lib/screens/solve_quiz_screen.dart` + `lib/widgets/answer_option_tile.dart` | Shows quiz with radio tiles and submit button. |
| Quiz result modal logic in React | `lib/screens/result_screen.dart` + `lib/widgets/question_result_tile.dart` | Displays score, question feedback. |
| `src/components/ui/*` and layout utilities | `lib/widgets/gradient_scaffold.dart`, `lib/widgets/quiz_card.dart`, shared styling helpers | Material 3 theming & reusable widgets. |

## 2. Folder Structure
```
flutter_app/
├── README.md
├── analysis_options.yaml
├── pubspec.yaml
└── lib/
    ├── main.dart
    ├── models/
    │   ├── quiz.dart
    │   ├── quiz_result.dart
    │   └── user.dart
    ├── providers/
    │   ├── auth_provider.dart
    │   └── quiz_provider.dart
    ├── screens/
    │   ├── add_quiz_screen.dart
    │   ├── home_screen.dart
    │   ├── result_screen.dart
    │   ├── sign_in_screen.dart
    │   ├── sign_up_screen.dart
    │   └── solve_quiz_screen.dart
    ├── utils/
    │   └── id_generator.dart
    └── widgets/
        ├── answer_option_tile.dart
        ├── gradient_scaffold.dart
        ├── question_form_section.dart
        ├── question_result_tile.dart
        └── quiz_card.dart
```

## 3. Running the Flutter App
```
cd flutter_app
flutter pub get
flutter run
```

The app uses only in-memory state, so it mirrors the behavior of the React version without external services.
