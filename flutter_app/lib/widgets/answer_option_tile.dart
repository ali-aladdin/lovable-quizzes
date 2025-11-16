import 'package:flutter/material.dart';

class AnswerOptionTile extends StatelessWidget {
  const AnswerOptionTile({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final int value;
  final int? groupValue;
  final String label;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(label),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
