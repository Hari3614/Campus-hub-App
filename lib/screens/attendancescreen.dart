import 'package:flutter/material.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/atattendance_history.dart';

class AttendanceAddingPage extends StatefulWidget {
  const AttendanceAddingPage({Key? key}) : super(key: key);

  @override
  _AttendanceAddingPageState createState() => _AttendanceAddingPageState();
}

class _AttendanceAddingPageState extends State<AttendanceAddingPage> {
  List<StudentModel> _allStudents = [];
  Map<String, bool> _studentSelections = {};
  ValueNotifier<List<StudentModel>> _selectedStudentsNotifier =
      ValueNotifier<List<StudentModel>>([]);

  @override
  void initState() {
    super.initState();
    // Fetch all students when the page is initialized
    getAllStudents();
  }

  Future<void> getAllStudents() async {
    List<StudentModel> fetchedStudents = await getstudents();
    setState(() {
      _allStudents = fetchedStudents;
      // Initialize student selections map with false for each student
      _studentSelections = Map.fromIterable(
        _allStudents,
        key: (student) => '${student.id}',
        value: (_) => false,
      );
    });
  }

  void _saveAttendance() async {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Filter out present students
    List<StudentModel> presentStudents = _allStudents
        .where((student) => _selectedStudentsNotifier.value.contains(student))
        .toList();

    // Filter out absent students
    List<StudentModel> absentStudents = _allStudents
        .where((student) => !_selectedStudentsNotifier.value.contains(student))
        .toList();

    // Create an AttendanceModel object
    AttendanceModel attendance = AttendanceModel(
      id: null, // Let Hive generate the ID
      date: currentDate,
      presentStudents: presentStudents
          .map((student) => '${student.firstName} ${student.lastName}')
          .join(', '),
      absentStudents: absentStudents
          .map((student) => '${student.firstName} ${student.lastName}')
          .join(', '),
    );

    // Save the attendance to the database
    await addAttendance(attendance);

    // Show a message or navigate to another screen if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved successfully!'),
      ),
    );

    // Optionally, reset selections or perform other actions
    // Reset selected students
    _selectedStudentsNotifier.value = [];
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        '${currentDate.day}/${currentDate.month}/${currentDate.year}';

    List<StudentModel> absentStudents = _allStudents
        .where((student) => !_selectedStudentsNotifier.value.contains(student))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        title: const Text(
          'Attendance Adding',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the AttendanceHistoryPage when the history icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceHistoryPage()),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: ValueListenableBuilder<List<StudentModel>>(
        valueListenable: _selectedStudentsNotifier,
        builder: (context, selectedStudents, child) {
          return selectedStudents.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 54, 160, 247),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Date: $formattedDate',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          // Present Students Container
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Present Students:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: selectedStudents
                                      .map(
                                        (student) => ListTile(
                                          title: Text(
                                            '${student.firstName} ${student.lastName}',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Absent Students Container
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Absent Students:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: absentStudents
                                      .map(
                                        (student) => ListTile(
                                          title: Text(
                                            '${student.firstName} ${student.lastName}',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Center(
                              child: ElevatedButton(
                                onPressed: _saveAttendance,
                                child: const Text('Save'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add today\'s attendance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: FloatingActionButton(
            onPressed: () {
              _showStudentsAlert();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void _showStudentsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('All Students'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: _allStudents.length,
                  itemBuilder: (BuildContext context, int index) {
                    final student = _allStudents[index];
                    final isSelected = _studentSelections['${student.id}']!;

                    return ListTile(
                      title: Text(
                        '${student.firstName} ${student.lastName}',
                      ),
                      trailing: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            _studentSelections['${student.id}'] =
                                value ?? false;
                            if (value ?? false) {
                              _selectedStudentsNotifier.value =
                                  List.from(_selectedStudentsNotifier.value)
                                    ..add(student);
                            } else {
                              _selectedStudentsNotifier.value =
                                  List.from(_selectedStudentsNotifier.value)
                                    ..remove(student);
                            }
                          });
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
