import 'dart:math';

final _random = Random();

String generateId([String prefix = 'id']) {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  final randomPart = _random.nextInt(1 << 32).toRadixString(16);
  return '$prefix-$timestamp-$randomPart';
}
