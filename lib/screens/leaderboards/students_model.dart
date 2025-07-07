
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String name;
  final String registrationNumber;
  final String branch;
  final int sessionScore;
  final int developmentScore;
  final int contestScore;

  Student({
    required this.name,
    required this.registrationNumber,
    required this.branch,
    required this.sessionScore,
    required this.developmentScore,
    required this.contestScore,
  });

  int get totalScore => sessionScore + developmentScore + contestScore;

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Student(
      name: data['name'] ?? '',
      registrationNumber: data['registration_number'] ?? '',
      branch: data['branch'] ?? 'Unknown',
      sessionScore: data['session_score'] ?? 0,
      developmentScore: data['development_score'] ?? 0,
      contestScore: data['contest_score'] ?? 0,
    );
  }
}