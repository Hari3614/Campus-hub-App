import 'package:flutter/material.dart';
import 'package:project_1/screens/editmark_screen.dart';
import 'package:project_1/screens/mark_addingScreen.dart';

import 'package:hive/hive.dart';
import 'package:project_1/database/db.model.dart';

class MarkScreen extends StatefulWidget {
  const MarkScreen({Key? key}) : super(key: key);

  @override
  State<MarkScreen> createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  List<MarkModel> marks = []; // List to store marks fetched from Hive
  Map<int, bool> isExpanded = {}; // Map to track expansion state

  @override
  void initState() {
    super.initState();
    fetchMarks();
  }

  Future<void> fetchMarks() async {
    final markBox = await Hive.openBox<MarkModel>('mark');
    setState(() {
      marks = markBox.values.toList();
      isExpanded = Map<int, bool>.fromIterable(
        marks,
        key: (mark) => marks.indexOf(mark),
        value: (_) => false,
      );
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
        isExpanded[marks.indexOf(newMark)] = false;
      });
    }
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpanded[index] = !(isExpanded[index] ?? false);
    });
  }

  Future<void> deleteMark(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this mark?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final markBox = Hive.box<MarkModel>('mark');
                final markToDelete = marks[index];
                markBox.delete(markToDelete.id);

                setState(() {
                  marks.removeAt(index);
                  isExpanded.remove(index);
                });

                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editMark(int index) async {
    final editedMark = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditMarkScreen(marks[index])),
    );

    if (editedMark != null) {
      final markBox = Hive.box<MarkModel>('mark');
      markBox.put(editedMark.id, editedMark);

      setState(() {
        marks[index] = editedMark;
      });
    }
  }

  void showLongPressMenu(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                editMark(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                deleteMark(index);
              },
            ),
          ],
        );
      },
    );
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
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: ListView.builder(
        itemCount: marks.length,
        itemBuilder: (context, index) {
          final mark = marks[index];
          return GestureDetector(
            onTap: () => toggleExpansion(index),
            onLongPress: () => showLongPressMenu(context, index),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Student Name: ${mark.studentName}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        // Remove the IconButton for delete here
                      ],
                    ),
                    Text('Exam: ${mark.exam}'),
                    if (isExpanded[index] ?? false)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Subject: ${mark.subject}'),
                          Text('Exam Type: ${mark.examType}'),
                          Text('Total Marks: ${mark.totalMarks}'),
                          Text('Obtained Marks: ${mark.obtainedMarks}'),
                          Text('Grade: ${mark.grade}'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMarkAndUpdateList,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: SizedBox(height: 65), // Adjust the FAB position up
    );
  }
}
