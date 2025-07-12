import 'package:codexcrew/screens/admin/admin_image_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexcrew/screens/leaderboards/students_model.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _regController = TextEditingController();
  final _branchController = TextEditingController();
  final _sessionController = TextEditingController();
  final _developmentController = TextEditingController();
  final _contestController = TextEditingController();
  final _searchController = TextEditingController();

  bool _isEditing = false;
  String? _editingDocId;
  String _searchQuery = '';

  @override
  void dispose() {
    _nameController.dispose();
    _regController.dispose();
    _branchController.dispose();
    _sessionController.dispose();
    _developmentController.dispose();
    _contestController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nameController.clear();
    _regController.clear();
    _branchController.clear();
    _sessionController.clear();
    _developmentController.clear();
    _contestController.clear();
    setState(() {
      _isEditing = false;
      _editingDocId = null;
    });
  }

  void _fillForm(Student student, String docId) {
    _nameController.text = student.name;
    _regController.text = student.registrationNumber;
    _branchController.text = student.branch;
    _sessionController.text = student.sessionScore.toString();
    _developmentController.text = student.developmentScore.toString();
    _contestController.text = student.contestScore.toString();
    setState(() {
      _isEditing = true;
      _editingDocId = docId;
    });
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'name': _nameController.text,
          'registration_number': _regController.text,
          'branch': _branchController.text,
          'session_score': int.parse(_sessionController.text),
          'development_score': int.parse(_developmentController.text),
          'contest_score': int.parse(_contestController.text),
        };

        if (_isEditing && _editingDocId != null) {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(_editingDocId)
              .update(data);
        } else {
          await FirebaseFirestore.instance
              .collection('students')
              .doc(_regController.text)
              .set(data);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? 'Student updated!' : 'Student added!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteStudent(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Student deleted!'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 30;

    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(height: 110),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminImagePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.5),
                    ),
                    child: const Text(
                      'Admin Gallery',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),

                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Name or Redg no',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radius),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radius),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(radius),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        filled: true,
                        fillColor: Colors.black.withAlpha(90),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              _isEditing ? 'Edit Student' : 'Add New Student',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField('Name', _nameController),
                          _buildTextField(
                            'Registration Number',
                            _regController,
                          ),
                          _buildTextField('Branch', _branchController),
                          _buildTextField(
                            'Session Score',
                            _sessionController,
                            isNumber: true,
                          ),
                          _buildTextField(
                            'Development Score',
                            _developmentController,
                            isNumber: true,
                          ),
                          _buildTextField(
                            'Contest Score',
                            _contestController,
                            isNumber: true,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveStudent,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  child: Text(_isEditing ? 'Update' : 'Add'),
                                ),
                              ),
                              if (_isEditing) ...[
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _clearForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: Text('Cancel'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(80),
                      borderRadius: BorderRadius.circular(radius),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Students List\n(Tap to Edit)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Divider(),
                        StreamBuilder<QuerySnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('students')
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }

                            List<Student> students =
                                snapshot.data!.docs
                                    .map((doc) => Student.fromFirestore(doc))
                                    .toList();

                            if (_searchQuery.isNotEmpty) {
                              students =
                                  students.where((student) {
                                    return student.name.toLowerCase().contains(
                                          _searchQuery,
                                        ) ||
                                        student.registrationNumber
                                            .toLowerCase()
                                            .contains(_searchQuery);
                                  }).toList();
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final student = students[index];
                                final docId = snapshot.data!.docs[index].id;
                                final totalScore =
                                    student.sessionScore +
                                    student.developmentScore +
                                    student.contestScore;

                                return Card(
                                  color: Colors.grey.withAlpha(70),

                                  margin: EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    onTap: () => _fillForm(student, docId),
                                    title: Text(
                                      student.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),

                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(),
                                        SizedBox(height: 4),
                                        Text(
                                          '${student.registrationNumber}',
                                          style: TextStyle(
                                            color: Colors.deepPurple[400],
                                          ),
                                        ),
                                        Text(
                                          '${student.branch}',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Session: ${student.sessionScore} \nDev: ${student.developmentScore} \nContest: ${student.contestScore}',
                                          style: TextStyle(
                                            color: Colors.yellow,
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          'Total: $totalScore',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => _showDeleteDialog(
                                            docId,
                                            student.name,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "  $label",
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (isNumber && int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  void _showDeleteDialog(String docId, String studentName) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text(
              'Delete Student',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Are you sure you want to delete $studentName?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteStudent(docId);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
