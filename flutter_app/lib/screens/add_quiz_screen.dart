import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/quiz.dart';
import '../providers/auth_provider.dart';
import '../providers/quiz_provider.dart';
import '../utils/id_generator.dart';
import '../widgets/question_form_section.dart';
import 'sign_in_screen.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  static const routeName = '/create-quiz';

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<QuestionFormData> _questions = [QuestionFormData()];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() => _questions.add(QuestionFormData()));
  }

  void _removeQuestion(int index) {
    setState(() {
      final removed = _questions.removeAt(index);
      removed.dispose();
    });
  }

  void _addChoice(QuestionFormData data) {
    setState(() => data.addChoiceController());
  }

  void _removeChoice(QuestionFormData data, int index) {
    setState(() => data.removeChoiceController(index));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final auth = context.read<AuthProvider>();
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false);
      return;
    }

    for (final question in _questions) {
      if (question.choiceControllers.any((controller) => controller.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all choices.')),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);
    final quizProvider = context.read<QuizProvider>();
    final quiz = Quiz(
      id: generateId('quiz'),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      createdBy: currentUser.username,
      createdAt: DateTime.now(),
      questions: _questions.map((data) {
        return QuizQuestion(
          id: generateId('question'),
          text: data.questionController.text.trim(),
          correctAnswerIndex: data.correctAnswerIndex,
          choices: data.choiceControllers
              .map((controller) => QuizChoice(id: generateId('choice'), text: controller.text.trim()))
              .toList(),
        );
      }).toList(),
    );
    quizProvider.addQuiz(quiz);
    setState(() => _isSubmitting = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz created successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Quiz')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Quiz Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ...List.generate(_questions.length, (index) {
                final data = _questions[index];
                return QuestionFormSection(
                  data: data,
                  index: index,
                  onRemoveQuestion: () => _removeQuestion(index),
                  onCorrectChanged: (value) {
                    setState(() => data.correctAnswerIndex = value);
                  },
                  onAddChoice: () => _addChoice(data),
                  onRemoveChoice: (choiceIndex) => _removeChoice(data, choiceIndex),
                );
              }),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add_box_outlined),
                  label: const Text('Add Question'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
