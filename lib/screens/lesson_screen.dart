import 'package:flutter/material.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/lesson_add_screen.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/screens/coverdLesson_screen.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<LessonModel> _lessons = []; // List to store lessons

  @override
  void initState() {
    super.initState();
    _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    List<LessonModel> lessons = await getlesson();
    setState(() {
      // Filter out deleted lessons before updating the _lessons list
      _lessons = lessons
          .where((lesson) => !DeletedLessons.deletedList.contains(lesson))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        title: const Text('Pending Lesson'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CoveredLesson()),
                );
              },
              icon: Icon(Icons.arrow_forward),
              label: Text('Covered Lesson'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return GestureDetector(
                  onLongPress: () => _deleteLesson(lesson),
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(lesson.subject),
                      subtitle: Text(lesson.title),
                      onTap: () {
                        // Show lesson details in an alert dialog
                        _showLessonDialog(context, lesson);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddLessonScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: SizedBox(height: 65), // Adjust the height as needed
      ),
    );
  }

  void _showLessonDialog(BuildContext context, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(lesson.subject),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Title: ${lesson.title}'),
              Text('Description: ${lesson.description}'),
              // Add more information fields here as needed
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteLesson(LessonModel lesson) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Move TO Completed'),
          content:
              Text('Are you sure you want to mark this lesson as completed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _lessons.remove(
                      lesson); // Remove the lesson from the current list
                  DeletedLessons.deletedList.add(
                      lesson); // Add removed lesson to the DeletedLessons list
                });
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class DeletedLessons {
  static List<LessonModel> deletedList = [];
}
