import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/id_generator.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider() {
    _users = [
      const User(
        id: 'user-demo',
        username: 'demo',
        email: 'demo@example.com',
        password: 'password123',
      ),
    ];
  }

  late List<User> _users;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  List<User> get users => List.unmodifiable(_users);

  String? signIn({
    required String email,
    required String password,
  }) {
    final user = _users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password,
      orElse: () => const User(id: '', username: '', email: '', password: ''),
    );

    if (user.id.isEmpty) {
      return 'Invalid credentials. Please try again.';
    }

    _currentUser = user;
    notifyListeners();
    return null;
  }

  String? signUp({
    required String username,
    required String email,
    required String password,
  }) {
    final exists = _users.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
    if (exists) {
      return 'An account with that email already exists.';
    }

    final user = User(
      id: generateId('user'),
      username: username,
      email: email,
      password: password,
    );
    _users = [..._users, user];
    notifyListeners();
    return null;
  }

  void signOut() {
    _currentUser = null;
    notifyListeners();
  }
}
