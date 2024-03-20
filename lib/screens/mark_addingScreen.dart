import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_1/database/db.model.dart';

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

  List<String> studentNames =
      []; // List to store student names fetched from Hive

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
            DropdownButtonFormField<String>(
              value: studentNames.isNotEmpty ? studentNames[0] : null,
              onChanged: (value) {
                // Handle selecting student name
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
            DropdownButtonFormField<String>(
              value: selectedExam,
              onChanged: (value) {
                setState(() {
                  selectedExam = value!;
                });
              },
              decoration: InputDecoration(
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
            SizedBox(height: 16),
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
              onPressed: () {
                // Handle saving the marks here
                String subject = subjectController.text;
                String studentName =
                    studentNames.isNotEmpty ? studentNames[0] : '';
                String exam = selectedExam;
                String examType = selectedExamType;
                int totalMarks = int.tryParse(totalMarkController.text) ?? 0;
                int obtainedMarks =
                    int.tryParse(obtainedMarkController.text) ?? 0;
                String grade = selectedGrade;

                // Add your logic to save the marks to a database or perform other actions
                // For demonstration, we print the entered data
                print('Subject: $subject');
                print('Student Name: $studentName');
                print('Exam: $exam');
                print('Exam Type: $examType');
                print('Total Marks: $totalMarks');
                print('Obtained Marks: $obtainedMarks');
                print('Grade: $grade');

                // Clear the form fields and selected values
                subjectController.clear();
                totalMarkController.clear();
                obtainedMarkController.clear();
                selectedExam = examOptions[0]; // Reset selected exam
                selectedExamType =
                    examTypeOptions[0]; // Reset selected exam type
                selectedGrade = gradeOptions[0]; // Reset selected grade
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
