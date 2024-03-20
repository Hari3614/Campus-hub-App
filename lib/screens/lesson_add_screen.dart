import 'package:flutter/material.dart';
import 'package:project_1/database/db.model.dart'; // Import your database model
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/lesson_screen.dart';

class AddLessonScreen extends StatefulWidget {
  @override
  _AddLessonScreenState createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _saveLesson() async {
    // Retrieve entered values
    String subject = _subjectController.text;
    String title = _titleController.text;
    String description = _descriptionController.text;

    // Create LessonModel instance
    LessonModel lesson = LessonModel(
      id: null, // You may assign an ID or leave it null to be generated automatically
      subject: subject,
      title: title,
      description: description,
    );

    // Save lesson to database
    await addLesson(lesson);

    // Clear text fields
    _subjectController.clear();
    _titleController.clear();
    _descriptionController.clear();

    // Navigate back to LessonScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LessonScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Lesson', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Dismiss keyboard when tapped outside of text fields
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  'Subject',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    hintText: 'Enter subject',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Lesson Title',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveLesson,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
