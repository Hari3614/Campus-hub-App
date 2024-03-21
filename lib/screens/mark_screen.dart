import 'package:flutter/material.dart';
import 'mark_addingScreen.dart'; // Import the AddMarkScreen widget
import 'package:hive/hive.dart';
import 'package:project_1/database/db.model.dart';

class MarkScreen extends StatefulWidget {
  const MarkScreen({Key? key}) : super(key: key);

  @override
  State<MarkScreen> createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  List<MarkModel> marks = []; // List to store marks fetched from Hive

  @override
  void initState() {
    super.initState();
    fetchMarks();
  }

  Future<void> fetchMarks() async {
    final markBox = await Hive.openBox<MarkModel>('mark');
    setState(() {
      marks = markBox.values.toList();
    });
  }

  Future<void> addMarkAndUpdateList() async {
    final newMark = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMarkScreen()),
    );

    if (newMark != null) {
      final markBox = Hive.box<MarkModel>('mark');
      markBox.add(newMark);

      setState(() {
        marks.add(newMark);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 255, 213),
        title: Text(
          'Exam Marks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(
          255, 255, 255, 255), // Set your desired background color here
      body: ListView.builder(
        itemCount: marks.length,
        itemBuilder: (context, index) {
          final mark = marks[index];
          return ListTile(
            title: Text('Subject: ${mark.subject}'),
            subtitle: Text('Student Name: ${mark.studentName}\n'
                'Exam: ${mark.exam}\n'
                'Exam Type: ${mark.examType}\n'
                'Total Marks: ${mark.totalMarks}\n'
                'Obtained Marks: ${mark.obtainedMarks}\n'
                'Grade: ${mark.grade}'),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            bottom: 65.0), // Adjust the bottom padding as needed
        child: FloatingActionButton(
          onPressed: addMarkAndUpdateList,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
