import 'package:flutter/material.dart';
import 'package:project_1/screens/lesson_screen.dart'; // Import the globals file

class CoveredLesson extends StatefulWidget {
  @override
  _CoveredLessonState createState() => _CoveredLessonState();
}

class _CoveredLessonState extends State<CoveredLesson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'View Covered Lessons',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: DeletedLessons.deletedList.length,
        itemBuilder: (context, index) {
          final lesson = DeletedLessons.deletedList[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(lesson.subject),
              subtitle: Text(lesson.title),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    DeletedLessons.deletedList
                        .removeAt(index); // Remove the lesson from the list
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
