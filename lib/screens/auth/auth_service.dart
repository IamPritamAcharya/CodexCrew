import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const int _maxAttemptsPerDay = 3;
  static const String _attemptsKey = 'auth_attempts';
  static const String _lastAttemptDateKey = 'last_attempt_date';

  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;
  String? get userEmail => currentUser?.email;
  bool get isAdmin =>
      userEmail == 'pritamach.exe@gmail.com' ||
      userEmail == 'bananisahoo20@gmail.com';

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<bool> _hasExceededDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getInt(_attemptsKey) ?? 0;
    final lastAttemptDate = prefs.getString(_lastAttemptDateKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastAttemptDate != today) {
      await prefs.setInt(_attemptsKey, 0);
      await prefs.setString(_lastAttemptDateKey, today);
      return false;
    }

    return attempts >= _maxAttemptsPerDay;
  }

  Future<void> _incrementAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getInt(_attemptsKey) ?? 0;
    final today = DateTime.now().toIso8601String().split('T')[0];

    await prefs.setInt(_attemptsKey, attempts + 1);
    await prefs.setString(_lastAttemptDateKey, today);
  }

  Future<void> _resetAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_attemptsKey);
    await prefs.remove(_lastAttemptDateKey);
  }

  Future<int> getRemainingAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = prefs.getInt(_attemptsKey) ?? 0;
    final lastAttemptDate = prefs.getString(_lastAttemptDateKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastAttemptDate != today) {
      return _maxAttemptsPerDay;
    }

    return _maxAttemptsPerDay - attempts;
  }

  void _showRateLimitSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Maximum sign-in attempts reached. Try again tomorrow.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      if (await _hasExceededDailyLimit()) {
        _showRateLimitSnackbar(context);
        return false;
      }

      print('Starting sign-in...');
      final provider = GoogleAuthProvider();
      provider.addScope('email');
      provider.setCustomParameters({'prompt': 'select_account'});

      late final UserCredential cred;
      if (kIsWeb) {
        cred = await _auth.signInWithPopup(provider);
      } else {
        cred = await _auth.signInWithProvider(provider);
      }

      if (cred.user != null) {
        await _resetAttempts();

        return true;
      } else {
        await _incrementAttempts();
        return false;
      }
    } catch (e, st) {
      print(st);

      await _incrementAttempts();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Sign-in failed. Please try again.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange.shade600,
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(16),
          ),
        );
      }

      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
