import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexcrew/screens/home/widgets/hero_title.dart';
import 'package:flutter/material.dart';

class HallOfFamePage extends StatefulWidget {
  @override
  _HallOfFamePageState createState() => _HallOfFamePageState();
}

class _HallOfFamePageState extends State<HallOfFamePage> {
  Map<String, List<dynamic>> academicYearData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('halloffame').get();

      Map<String, List<dynamic>> tempData = {};

      for (var doc in snapshot.docs) {
        final members = doc.data()['members'] ?? [];
        tempData[doc.id] = List<dynamic>.from(members);
      }

      final sortedKeys = tempData.keys.toList()..sort((a, b) => b.compareTo(a));

      Map<String, List<dynamic>> sortedData = {};
      for (String key in sortedKeys) {
        sortedData[key] = tempData[key]!;
      }

      setState(() {
        academicYearData = sortedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color get _primaryColor => Color(0xFF8B5CF6);

  String _getTierLabel(int index) {
    return '•';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        child:
            isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFF0A0A0A).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: CircularProgressIndicator(
                          color: _primaryColor,
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Loading Hall of Fame...',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                : academicYearData.isEmpty
                ? Center(
                  child: Container(
                    padding: EdgeInsets.all(48),
                    margin: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A0A0A).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: _primaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            Icons.emoji_events_outlined,
                            size: 64,
                            color: _primaryColor,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'No Hall of Fame data available',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Check back later for new additions',
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                )
                : Container(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 1400 : double.infinity,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(20, 140, 20, 24),
                        itemCount: academicYearData.length,
                        itemBuilder: (context, index) {
                          final year = academicYearData.keys.elementAt(index);
                          final members = academicYearData[year]!;
                          final tierLabel = _getTierLabel(index);

                          return Container(
                            margin: EdgeInsets.only(bottom: 40),
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0) ...[
                                  Center(
                                    child: ShaderMask(
                                      shaderCallback:
                                          (bounds) => LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Color(0xFF6366F1),
                                            ],
                                          ).createShader(bounds),
                                      child: Text(
                                        'Hall Of Fame',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isDesktop ? 80 : 40,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          height: 0.85,
                                          letterSpacing: -4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: isDesktop ? 30 : 15),
                                  Divider(),
                                  SizedBox(height: isDesktop ? 30 : 20),
                                ],
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(100),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: _primaryColor.withOpacity(0.4),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: _primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          border: Border.all(
                                            color: _primaryColor.withOpacity(
                                              0.4,
                                            ),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            tierLabel,
                                            style: TextStyle(
                                              color: _primaryColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Academic Year $year',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isDesktop ? 22 : 14,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              '${members.length} ${members.length == 1 ? 'Member' : 'Members'}',
                                              style: TextStyle(
                                                color: Colors.white60,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.only(top: 6),
                                  padding: EdgeInsets.only(top: 32, bottom: 32),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF070707).withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: _primaryColor.withOpacity(0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child:
                                      members.isEmpty
                                          ? Container(
                                            padding: EdgeInsets.all(56),
                                            child: Center(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.person_search,
                                                    color: Colors.white30,
                                                    size: 52,
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text(
                                                    'No members found',
                                                    style: TextStyle(
                                                      color: Colors.white38,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          : Container(
                                            height: 280,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.only(
                                                left: 32,
                                                right: 32,
                                              ),
                                              itemCount: members.length,
                                              itemBuilder: (
                                                context,
                                                memberIndex,
                                              ) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                    right: 24,
                                                  ),
                                                  child: _buildMemberTile(
                                                    members[memberIndex],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildMemberTile(dynamic member) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Container(
      width: 200,
      height: 280,
      decoration: BoxDecoration(
        color: Color(0xFF0A0A0A).withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: Color(0xFF070707),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _primaryColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child:
                  member['photo_url'] != null &&
                          member['photo_url'].toString().isNotEmpty
                      ? Image.network(
                        member['photo_url'],
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Color(0xFF070707),
                              child: Icon(
                                Icons.person,
                                color: Colors.white54,
                                size: 56,
                              ),
                            ),
                      )
                      : Container(
                        color: Color(0xFF070707),
                        child: Icon(
                          Icons.person,
                          color: Colors.white54,
                          size: 56,
                        ),
                      ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      member['name'] ?? 'Unknown',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      member['position'] ?? 'Member',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
