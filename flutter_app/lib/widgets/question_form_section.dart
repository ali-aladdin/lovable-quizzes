import 'package:flutter/material.dart';

class QuestionFormData {
  QuestionFormData()
      : questionController = TextEditingController(),
        choiceControllers = List.generate(3, (_) => TextEditingController()),
        correctAnswerIndex = 0;

  final TextEditingController questionController;
  final List<TextEditingController> choiceControllers;
  int correctAnswerIndex;

  void addChoiceController() {
    if (choiceControllers.length >= 5) {
      return;
    }
    choiceControllers.add(TextEditingController());
  }

  void removeChoiceController(int index) {
    if (choiceControllers.length <= 3) {
      return;
    }
    choiceControllers.removeAt(index);
    if (correctAnswerIndex >= choiceControllers.length) {
      correctAnswerIndex = choiceControllers.length - 1;
    }
  }

  void dispose() {
    questionController.dispose();
    for (final controller in choiceControllers) {
      controller.dispose();
    }
  }
}

class QuestionFormSection extends StatelessWidget {
  const QuestionFormSection({
    required this.data,
    required this.index,
    required this.onRemoveQuestion,
    required this.onCorrectChanged,
    required this.onAddChoice,
    required this.onRemoveChoice,
    super.key,
  });

  final QuestionFormData data;
  final int index;
  final VoidCallback onRemoveQuestion;
  final ValueChanged<int> onCorrectChanged;
  final VoidCallback onAddChoice;
  final void Function(int index) onRemoveChoice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${index + 1}',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (index > 0)
                  IconButton(
                    onPressed: onRemoveQuestion,
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Remove question',
                  ),
              ],
            ),
            TextFormField(
              controller: data.questionController,
              decoration: const InputDecoration(labelText: 'Question Text'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a question';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Choices',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...List.generate(data.choiceControllers.length, (choiceIndex) {
              final controller = data.choiceControllers[choiceIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Choice ${choiceIndex + 1}',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a choice';
                          }
                          return null;
                        },
                      ),
                    ),
                    Radio<int>(
                      value: choiceIndex,
                      groupValue: data.correctAnswerIndex,
                      onChanged: (value) {
                        if (value != null) {
                          onCorrectChanged(value);
                        }
                      },
                    ),
                    if (data.choiceControllers.length > 3)
                      IconButton(
                        onPressed: () => onRemoveChoice(choiceIndex),
                        icon: const Icon(Icons.close),
                        tooltip: 'Remove choice',
                      ),
                  ],
                ),
              );
            }),
            Row(
              children: [
                TextButton.icon(
                  onPressed: data.choiceControllers.length >= 5 ? null : onAddChoice,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Choice'),
                ),
                const Spacer(),
                Text(
                  'Tap radio to mark correct',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
