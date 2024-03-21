import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/mark_screen.dart';

class AddMarkScreen extends StatefulWidget {
  const AddMarkScreen({Key? key}) : super(key: key);

  @override
  State<AddMarkScreen> createState() => _AddMarkScreenState();
}

class _AddMarkScreenState extends State<AddMarkScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController totalMarkController = TextEditingController();
  TextEditingController obtainedMarkController = TextEditingController();

  List<String> examOptions = [
    'Annual Exam',
    'Half-Yearly Exam',
    'Quarterly Exam',
    'Midterm Exam',
    'Others'
  ];

  String selectedExam = 'Annual Exam'; // Default selected exam

  List<String> examTypeOptions = ['Theory', 'Practical'];
  String selectedExamType = 'Theory'; // Default selected exam type

  List<String> gradeOptions = ['A', 'B', 'C', 'D', 'E'];
  String selectedGrade = 'A'; // Default selected grade

  List<String> studentNames = []; // List to store student names

  String? selectedStudentName; // Default selected student name

  @override
  void initState() {
    super.initState();
    fetchStudentNames();
  }

  Future<void> fetchStudentNames() async {
    final studentBox = await Hive.openBox<StudentModel>('students');
    List<StudentModel> students = studentBox.values.toList();
    setState(() {
      studentNames = students.map((student) => student.firstName).toList();
      if (studentNames.isNotEmpty) {
        selectedStudentName =
            studentNames[0]; // Set default selected student name
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 255, 213),
        title: Text(
          'Add Marks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 133, 132, 132),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (studentNames.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                value: selectedStudentName,
                onChanged: (value) {
                  setState(() {
                    selectedStudentName = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
                items: studentNames
                    .map((studentName) => DropdownMenuItem<String>(
                          value: studentName,
                          child: Text(studentName),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
            ],
            DropdownButtonFormField<String>(
              value: selectedExam,
              onChanged: (value) {
                setState(() {
                  selectedExam = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Exam Name',
                border: OutlineInputBorder(),
              ),
              items: examOptions
                  .map((exam) => DropdownMenuItem<String>(
                        value: exam,
                        child: Text(exam),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedExamType,
              onChanged: (value) {
                setState(() {
                  selectedExamType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Exam Type',
                border: OutlineInputBorder(),
              ),
              items: examTypeOptions
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: totalMarkController,
              decoration: InputDecoration(
                labelText: 'Total Marks',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: obtainedMarkController,
              decoration: InputDecoration(
                labelText: 'Obtained Marks',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedGrade,
              onChanged: (value) {
                setState(() {
                  selectedGrade = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
              ),
              items: gradeOptions
                  .map((grade) => DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade),
                      ))
                  .toList(),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (selectedStudentName != null) {
                  String subject = subjectController.text;
                  String studentName = selectedStudentName!;
                  String exam = selectedExam;
                  String examType = selectedExamType;
                  int totalMarks = int.tryParse(totalMarkController.text) ?? 0;
                  int obtainedMarks =
                      int.tryParse(obtainedMarkController.text) ?? 0;
                  String grade = selectedGrade;

                  MarkModel mark = MarkModel(
                    id: null,
                    subject: subject,
                    studentName: studentName,
                    exam: exam,
                    examType: examType,
                    totalMarks: totalMarks,
                    obtainedMarks: obtainedMarks,
                    grade: grade,
                  );

                  addMark(mark);
                }
                await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MarkScreen()),
                );
              },
              child: Text('Save Marks'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color.fromARGB(255, 197, 255, 245),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
