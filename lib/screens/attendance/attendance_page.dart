import 'package:codexcrew/screens/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;
  int _attemptCount = 0;
  final int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    _loadAttemptCount();
  }

  Future<void> _loadAttemptCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today =
        DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    String? lastAttemptDate = prefs.getString('last_attempt_date');

    // Reset attempts if it's a new day
    if (lastAttemptDate != today) {
      await prefs.setInt('attempt_count', 0);
      await prefs.setString('last_attempt_date', today);
      setState(() => _attemptCount = 0);
    } else {
      setState(() => _attemptCount = prefs.getInt('attempt_count') ?? 0);
    }
  }

  Future<void> _incrementAttemptCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String today = DateTime.now().toIso8601String().split('T')[0];

    _attemptCount++;
    await prefs.setInt('attempt_count', _attemptCount);
    await prefs.setString('last_attempt_date', today);
    setState(() {});
  }

  bool get _canAttempt => _attemptCount < _maxAttempts;

  String get _remainingAttemptsText {
    int remaining = _maxAttempts - _attemptCount;
    if (remaining <= 0) {
      return "No attempts remaining today";
    }
    return "$remaining attempt${remaining == 1 ? '' : 's'} remaining today";
  }

  Future<void> _submitAttendance() async {
    if (!_canAttempt) {
      _showError('Maximum attempts reached for today. Try again tomorrow.');
      return;
    }

    String enteredCode = _codeController.text.trim();
    String? userEmail = _authService.userEmail;

    if (enteredCode.length != 6) {
      _showError('Please enter a 6-digit code');
      return;
    }

    if (userEmail == null) {
      _showError('Please sign in first');
      return;
    }

    setState(() => _loading = true);

    try {
      DocumentSnapshot configDoc =
          await _firestore.collection('attendance_config').doc('current').get();

      if (!configDoc.exists) {
        _showError('Attendance system not configured');
        await _incrementAttemptCount();
        return;
      }

      Map<String, dynamic> config = configDoc.data() as Map<String, dynamic>;
      bool isActive = config['is_active'] ?? false;
      String correctCode = config['code'] ?? '';

      if (!isActive) {
        _showError('Attendance is currently inactive');
        await _incrementAttemptCount();
        return;
      }

      if (enteredCode != correctCode) {
        _showError('Invalid code');
        await _incrementAttemptCount();
        return;
      }

      DocumentSnapshot emailDoc =
          await _firestore.collection('student_emails').doc(userEmail).get();

      if (!emailDoc.exists) {
        _showError('You are not authorized to mark attendance');
        await _incrementAttemptCount();
        return;
      }

      Map<String, dynamic> emailData = emailDoc.data() as Map<String, dynamic>;
      String regNo = emailData['registration_number'];

      if (regNo == 'admin') {
        _showError('Admin cannot mark attendance');
        await _incrementAttemptCount();
        return;
      }

      DocumentSnapshot attendanceDoc =
          await _firestore.collection('temporary_attendance').doc(regNo).get();

      if (attendanceDoc.exists) {
        _showError('Attendance already marked');
        await _incrementAttemptCount();
        return;
      }

      await _firestore.collection('temporary_attendance').doc(regNo).set({
        'registration_number': regNo,
        'email': userEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSuccess('Attendance marked successfully!');
      _codeController.clear();
      // Don't increment attempt count on success
    } catch (e) {
      _showError('Error marking attendance: $e');
      await _incrementAttemptCount();
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900]!.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[700]!, width: 1),
                ),
                constraints: BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'Enter Attendance Code',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              _canAttempt
                                  ? Colors.blue.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _canAttempt
                                    ? Colors.blue.withOpacity(0.5)
                                    : Colors.red.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          _remainingAttemptsText,
                          style: TextStyle(
                            color:
                                _canAttempt
                                    ? Colors.blue[300]
                                    : Colors.red[300],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _codeController,
                        cursorColor: Colors.white,
                        enabled: _canAttempt && !_loading,
                        decoration: InputDecoration(
                          labelText: '6-Digit Code',
                          labelStyle: TextStyle(
                            color:
                                _canAttempt
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color:
                                  _canAttempt
                                      ? Colors.grey[600]!
                                      : Colors.grey[700]!,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color:
                                  _canAttempt
                                      ? Colors.grey[600]!
                                      : Colors.grey[700]!,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color:
                                _canAttempt
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          filled: true,
                          fillColor:
                              _canAttempt
                                  ? Colors.grey[800]!.withOpacity(0.5)
                                  : Colors.grey[800]!.withOpacity(0.3),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 3,
                          color: _canAttempt ? Colors.white : Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed:
                              (_loading || !_canAttempt)
                                  ? null
                                  : _submitAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _canAttempt ? Colors.white : Colors.grey[600],
                            foregroundColor:
                                _canAttempt ? Colors.black : Colors.grey[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                          child:
                              _loading
                                  ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.black54,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : Text(
                                    _canAttempt
                                        ? 'Submit Attendance'
                                        : 'Max Attempts Reached',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800]!.withOpacity(0.4),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'Signed in as: ${_authService.userEmail ?? "Not signed in"}',
                style: TextStyle(color: Colors.grey[300], fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
