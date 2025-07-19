import 'package:codexcrew/screens/leaderboards/students_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentWithRank {
  final Student student;
  final int rank;

  StudentWithRank(this.student, this.rank);
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final isWeb = screenWidth > 600;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: isWeb ? 120 : 60),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance
                        .collection('students')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'Error loading data',
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }

                  List<Student> students =
                      snapshot.data!.docs
                          .map((doc) => Student.fromFirestore(doc))
                          .toList();

                  students.sort((a, b) => b.totalScore.compareTo(a.totalScore));

                  List<StudentWithRank> studentsWithRank = [];
                  int currentRank = 1;

                  for (int i = 0; i < students.length; i++) {
                    if (i > 0 &&
                        students[i].totalScore != students[i - 1].totalScore) {
                      currentRank++;
                    }
                    studentsWithRank.add(
                      StudentWithRank(students[i], currentRank),
                    );
                  }

                  return _buildLeaderboard(studentsWithRank);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboard(List<StudentWithRank> studentsWithRank) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        double maxWidth = isWide ? 900 : double.infinity;

        return Center(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: maxWidth),
            margin: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 16,
              vertical: 16,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade800, width: 1),
                  ),
                  child: Column(
                    children: [
                      _buildListHeader(isWide),
                      ...studentsWithRank.map((studentWithRank) {
                        return _buildStudentRow(
                          studentWithRank.student,
                          studentWithRank.rank,
                          isWide,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListHeader(bool isWide) {
    return Container(
      padding: EdgeInsets.all(isWide ? 20 : 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 10, 10, 10),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 40, child: _headerText('#')),
          Expanded(flex: 3, child: _headerText('Student')),
          if (isWide) ...[
            SizedBox(width: 12),
            SizedBox(width: 100, child: _headerText('Session')),
            SizedBox(width: 12),
            SizedBox(width: 100, child: _headerText('Development')),
            SizedBox(width: 12),
            SizedBox(width: 100, child: _headerText('Contest')),
            SizedBox(width: 12),
          ],
          SizedBox(width: 100, child: _headerText('Total')),
        ],
      ),
    );
  }

  Widget _headerText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStudentRow(Student student, int rank, bool isWide) {
    bool isTopThree = rank <= 3;

    return Container(
      height: isWide ? 68 : null,
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 20 : 16,
        vertical: isWide ? 14 : 12,
      ),
      decoration: BoxDecoration(
        color: isTopThree ? Colors.blueAccent.withAlpha(10) : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                rank.toString(),
                style: TextStyle(
                  color: isTopThree ? Colors.green : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:
                  isWide ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (student.branch != 'Unknown') ...[
                  const SizedBox(height: 2),
                  Text(
                    student.branch,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (!isWide) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _scoreChip(
                        student.sessionScore,
                        Colors.green,
                        'S',
                        isWide,
                      ),
                      const SizedBox(width: 4),
                      _scoreChip(
                        student.developmentScore,
                        Colors.blue,
                        'D',
                        isWide,
                      ),
                      const SizedBox(width: 4),
                      _scoreChip(
                        student.contestScore,
                        Colors.orange,
                        'C',
                        isWide,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isWide) ...[
            SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: Center(
                child: _scoreChip(
                  student.sessionScore,
                  Colors.green,
                  null,
                  isWide,
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: Center(
                child: _scoreChip(
                  student.developmentScore,
                  Colors.blue,
                  null,
                  isWide,
                ),
              ),
            ),
            SizedBox(width: 12),
            SizedBox(
              width: 100,
              child: Center(
                child: _scoreChip(
                  student.contestScore,
                  Colors.orange,
                  null,
                  isWide,
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 12 : 8,
                  vertical: isWide ? 6 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      isWide
                          ? Border.all(color: Colors.deepPurple, width: 1)
                          : null,
                ),
                child: Text(
                  student.totalScore.toString(),
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: isWide ? 14 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreChip(
    int score,
    Color color, [
    String? prefix,
    bool isWide = false,
  ]) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 12 : 6,
        vertical: isWide ? 6 : 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isWide ? 8 : 6),
        border:
            isWide ? Border.all(color: color.withOpacity(0.3), width: 1) : null,
      ),
      child: Text(
        prefix != null ? '$prefix: $score' : score.toString(),
        style: TextStyle(
          color: color,
          fontSize: isWide ? 14 : 12,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
