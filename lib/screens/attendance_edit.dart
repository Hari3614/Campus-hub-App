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
  late TextEditingController _presentController;
  late TextEditingController _absentController;
  List<StudentModel> _students = []; // List to store students from database

  @override
  void initState() {
    super.initState();
    _presentController = TextEditingController();
    _absentController = TextEditingController();
    _fetchStudents(); // Call method to fetch students when the page initializes
  }

  @override
  void dispose() {
    _presentController.dispose();
    _absentController.dispose();
    super.dispose();
  }

  Future<void> _fetchStudents() async {
    try {
      // Fetch students from the database
      List<StudentModel> students = await getstudents();
      setState(() {
        _students = students;
      });
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  void _showStudentsList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Students List'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              StudentModel student = _students[index];
              return ListTile(
                title: Text('${student.firstName} ${student.lastName}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              _showStudentsList(context); // Show students list on icon press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Attendance for ${widget.selectedDay}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _presentController,
              decoration: InputDecoration(
                labelText: 'Present Students',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _absentController,
              decoration: InputDecoration(
                labelText: 'Absent Students',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    try {
      Box<AttendanceModel> attendanceBox =
          Hive.box<AttendanceModel>('attendance');
      List<AttendanceModel> attendanceList = attendanceBox.values.where(
        (attendance) {
          return attendance.date.year == widget.selectedDay.year &&
              attendance.date.month == widget.selectedDay.month &&
              attendance.date.day == widget.selectedDay.day;
        },
      ).toList();

      // Update attendance data
      attendanceList.forEach((attendance) {
        attendance.presentStudents = _presentController.text;
        attendance.absentStudents = _absentController.text;
        attendanceBox.put(attendance.key, attendance);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance updated successfully')),
      );

      Navigator.pop(context); // Go back to previous page after saving changes
    } catch (e) {
      print('Error saving edited attendance: $e');
    }
  }
}
