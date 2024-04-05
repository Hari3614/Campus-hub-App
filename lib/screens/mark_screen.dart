import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/editmark_screen.dart';
import 'package:project_1/screens/mark_addingScreen.dart';

class MarkScreen extends StatefulWidget {
  const MarkScreen({Key? key}) : super(key: key);

  @override
  State<MarkScreen> createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  List<MarkModel> marks = []; // List to store marks fetched from Hive
  Map<int, bool> isExpanded = {}; // Map to track expansion state
  Set<String> uniqueExamNames = Set(); // Set to track unique exam names

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
      uniqueExamNames = marks.map((mark) => mark.exam ?? '').toSet();
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

      // Call fetchMarks again to update the marks list with the latest data
      await fetchMarks();
    }
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpanded[index] = !(isExpanded[index] ?? false);
    });
  }

  Future<void> deleteMark(int index) async {
    final markToDelete = marks[index];
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
              onPressed: () async {
                final markBox = Hive.box<MarkModel>('mark');
                await markBox.delete(markToDelete.id);

                setState(() {
                  marks.removeAt(index);
                  isExpanded.remove(index);
                  uniqueExamNames.remove(markToDelete.exam ?? '');
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

  void navigateToMarks(String examName) {
    final marksForExam = marks.where((mark) => mark.exam == examName).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarksForExamScreen(
          examName: examName,
          marksForExam: marksForExam,
        ),
      ),
    );
  }

  void sortMarks() {
    marks.sort((a, b) => a.subject!.compareTo(b.subject!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        title: const Text(
          'Exam Marks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: ListView.builder(
        itemCount: uniqueExamNames.length,
        itemBuilder: (context, index) {
          final examName = uniqueExamNames.elementAt(index);
          return GestureDetector(
            onTap: () => navigateToMarks(examName),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    examName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMarkAndUpdateList,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: const SizedBox(height: 65),
    );
  }
}

//<<<<<<<.............For Mark Info............>>>>>>>

class MarksForExamScreen extends StatefulWidget {
  final String examName;
  final List<MarkModel> marksForExam;

  const MarksForExamScreen({
    Key? key,
    required this.examName,
    required this.marksForExam,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MarksForExamScreenState createState() => _MarksForExamScreenState();
}

class _MarksForExamScreenState extends State<MarksForExamScreen> {
  List<MarkModel> filteredMarks = [];

  @override
  void initState() {
    super.initState();
    filterMarks('Pass'); // Initialize with 'Pass' as default filter
  }

  void filterMarks(String filterBy) {
    setState(() {
      if (filterBy == 'Pass') {
        filteredMarks = widget.marksForExam
            .where((mark) => mark.obtainedMarks! >= 50)
            .toList();
      } else if (filterBy == 'Failed') {
        filteredMarks = widget.marksForExam
            .where((mark) => mark.obtainedMarks! < 50)
            .toList();
      } else {
        filteredMarks = List.from(widget.marksForExam); // No filtering
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marks Info'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sort Options'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text('Failed'),
                          onTap: () {
                            filterMarks('Failed');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('Pass'),
                          onTap: () {
                            filterMarks('Pass');
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('All'),
                          onTap: () {
                            filterMarks('');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  widget.examName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredMarks.length,
                itemBuilder: (context, index) {
                  final mark = filteredMarks[index];
                  final totalMarks = mark.totalMarks ?? 0;
                  final obtainedMarks = mark.obtainedMarks ?? 0;
                  final grade = calculateGrade(obtainedMarks, totalMarks);

                  return GestureDetector(
                    onLongPress: () => _showPopupMenu(context, mark),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Name: ${mark.studentName ?? ''}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Subject: ${mark.subject ?? ''}'),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Marks: $totalMarks'),
                              Text(
                                'Obtained Marks: $obtainedMarks',
                                style: TextStyle(
                                  color: obtainedMarks >= 50
                                      ? Colors.green
                                      : Colors
                                          .red, // Change color based on condition
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Grade: $grade',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getGradeColor(grade),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calculateGrade(int obtainedMarks, int totalMarks) {
    final percentage = (obtainedMarks / totalMarks) * 100;
    if (percentage >= 90) {
      return 'A+';
    } else if (percentage >= 80) {
      return 'A';
    } else if (percentage >= 70) {
      return 'B';
    } else if (percentage >= 60) {
      return 'C';
    } else if (percentage >= 50) {
      return 'D';
    } else {
      return 'F';
    }
  }

  Color getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green;
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.yellow;
      case 'D':
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  void _showPopupMenu(BuildContext context, MarkModel mark) {
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
                _editMark(context, mark);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                _deleteMark(context, mark);
              },
            ),
          ],
        );
      },
    );
  }

  void _editMark(BuildContext context, MarkModel mark) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditMarkScreen(mark)),
    ).then((editedMark) {
      if (editedMark != null) {
        // Update the edited mark in the database or wherever it's stored
        // For example:
        // markDatabase.updateMark(editedMark);
      }
    });
  }

  void _deleteMark(BuildContext context, MarkModel mark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this mark?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the mark if id is not null
                if (mark.id != null) {
                  // await deleteMark(mark.id!);

                  // Update UI by removing the mark from marksForExam list
                  // marksForExam.remove(mark);
                  // Update the filtered list instead
                  setState(() {
                    filteredMarks.remove(mark);
                  });
                }

                Navigator.of(context).pop(); // Close the alert dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
