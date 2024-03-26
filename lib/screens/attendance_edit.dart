import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/database/student_db.dart';

class EditAttendancePage extends StatefulWidget {
  final DateTime selectedDay;

  const EditAttendancePage(this.selectedDay);

  @override
  _EditAttendancePageState createState() => _EditAttendancePageState();
}

class _EditAttendancePageState extends State<EditAttendancePage> {
  List<StudentModel> _students = []; // List to store students from database
  Map<String, bool> _selectedStudents = {}; // Map to track selected students

  @override
  void initState() {
    super.initState();
    _fetchStudents(); // Call method to fetch students when the page initializes
  }

  Future<void> _fetchStudents() async {
    try {
      // Fetch students from the database
      List<StudentModel> students = await getstudents();
      setState(() {
        _students = students;
        // Initialize _selectedStudents map with false for each student
        _selectedStudents = Map.fromIterable(
          _students,
          key: (student) => '${student.id}',
          value: (_) => false,
        );
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  void _showAllStudents(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('All Students'),
            content: Container(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  StudentModel student = _students[index];
                  return CheckboxListTile(
                    title: Text('${student.firstName} ${student.lastName}'),
                    value: _selectedStudents['${student.id}']!,
                    onChanged: (bool? value) {
                      setState(() {
                        _selectedStudents['${student.id}'] = value!;
                      });
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StudentModel> presentStudents = _students
        .where((student) => _selectedStudents['${student.id}']!)
        .toList();
    List<StudentModel> absentStudents = _students
        .where((student) => !_selectedStudents['${student.id}']!)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        title: const Text('Edit Attendance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Attendance on ${widget.selectedDay.day}/${widget.selectedDay.month}/${widget.selectedDay.year}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Present Students:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: presentStudents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${presentStudents[index].firstName} ${presentStudents[index].lastName}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Absent Students:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: absentStudents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${absentStudents[index].firstName} ${absentStudents[index].lastName}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAllStudents(context);
        },
        child: const Icon(Icons.list),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              _saveChanges(context);
            },
            child: Text('Save Changes'),
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    try {
      Box<AttendanceModel> attendanceBox =
          await Hive.openBox<AttendanceModel>('attendance');
      List<AttendanceModel> attendanceList = attendanceBox.values.toList();

      bool attendanceFound = false;
      for (AttendanceModel attendance in attendanceList) {
        if (attendance.date.year == widget.selectedDay.year &&
            attendance.date.month == widget.selectedDay.month &&
            attendance.date.day == widget.selectedDay.day) {
          attendanceFound = true;
          // Update attendance data based on selected students
          attendance.presentStudents = _selectedStudents.entries
              .where((entry) => entry.value)
              .map((entry) =>
                  '${_students.firstWhere((student) => student.id == entry.key).firstName} ${_students.firstWhere((student) => student.id == entry.key).lastName}')
              .join(', ');
          attendance.absentStudents = _selectedStudents.entries
              .where((entry) => !entry.value)
              .map((entry) =>
                  '${_students.firstWhere((student) => student.id == entry.key).firstName} ${_students.firstWhere((student) => student.id == entry.key).lastName}')
              .join(', ');

          await attendanceBox.put(attendance.key, attendance);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance updated successfully')),
          );

          Navigator.pop(
              context); // Go back to previous page after saving changes
          break; // Exit the loop once attendance is updated
        }
      }

      if (!attendanceFound) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance record not found')),
        );
      }
    } catch (e) {
      print('Error saving edited attendance: $e');
    }
  }
}
