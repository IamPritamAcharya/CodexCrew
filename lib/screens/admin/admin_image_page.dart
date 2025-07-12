import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminImagePage extends StatefulWidget {
  @override
  _AdminImagePageState createState() => _AdminImagePageState();
}

class _AdminImagePageState extends State<AdminImagePage> {
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _useCurrentDate = true;
  DateTime _selectedDate = DateTime.now();
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _urlController.addListener(() {
      setState(() {
        _imageUrl = _urlController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _addImage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('gallery_images').add({
        'url': _urlController.text.trim(),
        'created_at':
            _useCurrentDate
                ? Timestamp.now()
                : Timestamp.fromDate(_selectedDate),
      });

      _urlController.clear();
      setState(() => _useCurrentDate = true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image added successfully!'),
          backgroundColor: Colors.green[800],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red[800],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.grey[900]!,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),

                  TextFormField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.link, color: Colors.white70),
                      fillColor: Colors.grey[900],
                      filled: true,
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an image URL';
                      }
                      if (!Uri.tryParse(value.trim())!.hasAbsolutePath) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                    maxLines: 2,
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Checkbox(
                        value: _useCurrentDate,
                        onChanged:
                            (value) => setState(() => _useCurrentDate = value!),
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Use current date/time',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  if (!_useCurrentDate) ...[
                    SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: Icon(Icons.calendar_today, color: Colors.white),
                      label: Text(
                        'Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} '
                        '${_selectedDate.hour.toString().padLeft(2, '0')}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white30),
                      ),
                    ),
                  ],

                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _addImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        _isLoading
                            ? CircularProgressIndicator(color: Colors.black)
                            : Text('Add Image', style: TextStyle(fontSize: 16)),
                  ),

                  if (_imageUrl.isNotEmpty) ...[
                    SizedBox(height: 30),
                    Text(
                      'Preview:',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
