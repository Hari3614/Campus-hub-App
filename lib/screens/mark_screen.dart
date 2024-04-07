import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/screens/mark_addingScreen.dart';

class MarkScreen extends StatefulWidget {
  const MarkScreen({Key? key}) : super(key: key);

  @override
  State<MarkScreen> createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  List<MarkModel> marks = [];
  Map<int, bool> isExpanded = {};
  Set<String> uniqueExamNames = Set();
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

      await fetchMarks();
    }
  }

  void toggleExpansion(int index) {
    setState(() {
      isExpanded[index] = !(isExpanded[index] ?? false);
    });
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
    ).then((_) {
      fetchMarks();
    });
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

//<<<<<<<<<<............... Mark Info Showing Page...............>>>>>>>>>>>>>>>>>

class MarksForExamScreen extends StatefulWidget {
  final String examName;
  final List<MarkModel> marksForExam;

  const MarksForExamScreen({
    Key? key,
    required this.examName,
    required this.marksForExam,
  }) : super(key: key);

  @override
  _MarksForExamScreenState createState() => _MarksForExamScreenState();
}

class _MarksForExamScreenState extends State<MarksForExamScreen> {
  List<MarkModel> filteredMarks = [];

  @override
  void initState() {
    super.initState();
    filterMarks('');
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

  void deleteMark(int index) async {
    final markToDelete = filteredMarks[index];
    final markBox = await Hive.openBox<MarkModel>('mark');
    await markBox.delete(markToDelete
        .key); // Assuming `key` is the unique identifier for marks in Hive
    // Update the UI by removing the deleted mark from the filteredMarks list
    setState(() {
      filteredMarks.removeAt(index);
    });
  }

  Future<void> fetchMarks() async {
    // Fetch marks from Hive and update the state
    final markBox = await Hive.openBox<MarkModel>('mark');
    setState(() {
      widget.marksForExam.clear();
      widget.marksForExam.addAll(markBox.values.toList());
      filterMarks(''); // Reset filtering after fetching marks
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Student Name: ${mark.studentName ?? ''}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditMarkScreen(
                                            markModel:
                                                mark, // Pass the mark data to be edited
                                          ),
                                        ),
                                      ).then((result) {
                                        // Handle the result if needed, e.g., refresh the list
                                        if (result != null &&
                                            result is bool &&
                                            result) {
                                          fetchMarks(); // Refresh marks after editing
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteMark(index);
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                      : Colors.red,
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
}

//<<<<<<<<<<...............Edit The Mark...............>>>>>>>>>>>>>>>>>

class EditMarkScreen extends StatefulWidget {
  final MarkModel markModel;

  const EditMarkScreen({Key? key, required this.markModel}) : super(key: key);

  @override
  _EditMarkScreenState createState() => _EditMarkScreenState();
}

class _EditMarkScreenState extends State<EditMarkScreen> {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _totalMarksController = TextEditingController();
  TextEditingController _obtainedMarksController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _subjectController.text = widget.markModel.subject ?? '';
    _totalMarksController.text = widget.markModel.totalMarks.toString();
    _obtainedMarksController.text = widget.markModel.obtainedMarks.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mark'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _totalMarksController,
              decoration: InputDecoration(labelText: 'Total Marks'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _obtainedMarksController,
              decoration: InputDecoration(labelText: 'Obtained Marks'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_subjectController.text.isNotEmpty &&
                    _totalMarksController.text.isNotEmpty &&
                    _obtainedMarksController.text.isNotEmpty) {
                  widget.markModel.subject = _subjectController.text;
                  widget.markModel.totalMarks =
                      int.parse(_totalMarksController.text);
                  widget.markModel.obtainedMarks =
                      int.parse(_obtainedMarksController.text);

                  final markBox = await Hive.openBox<MarkModel>('mark');
                  markBox.put(widget.markModel.key, widget.markModel);

                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill in all fields.'),
                  ));
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
