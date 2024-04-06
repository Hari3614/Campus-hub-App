import 'package:flutter/material.dart';
import 'package:project_1/database/db.model.dart';

class EditMarkScreen extends StatefulWidget {
  final MarkModel markToEdit;

  const EditMarkScreen(this.markToEdit, {required MarkModel mark});

  @override
  _EditMarkScreenState createState() => _EditMarkScreenState();
}

class _EditMarkScreenState extends State<EditMarkScreen> {
  late TextEditingController obtainedMarksController;
  late TextEditingController totalMarksController;
  late TextEditingController subjectController;
  late TextEditingController gradeController;

  @override
  void initState() {
    super.initState();
    obtainedMarksController =
        TextEditingController(text: widget.markToEdit.obtainedMarks.toString());
    totalMarksController =
        TextEditingController(text: widget.markToEdit.totalMarks.toString());
    subjectController = TextEditingController(text: widget.markToEdit.subject);
    gradeController = TextEditingController(text: widget.markToEdit.grade);
  }

  @override
  void dispose() {
    obtainedMarksController.dispose();
    totalMarksController.dispose();
    subjectController.dispose();
    gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mark'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: obtainedMarksController,
              decoration: const InputDecoration(labelText: 'Obtained Marks'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: totalMarksController,
              decoration: const InputDecoration(labelText: 'Total Marks'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveChanges();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void saveChanges() {
    final newMark = MarkModel(
      id: widget.markToEdit.id,
      studentName: widget.markToEdit.studentName,
      exam: widget.markToEdit.exam,
      examType: widget.markToEdit.examType,
      obtainedMarks: int.tryParse(obtainedMarksController.text) ?? 0,
      totalMarks: int.tryParse(totalMarksController.text) ?? 0,
      subject: subjectController.text,
      grade: gradeController.text,
    );

    // Show snackbar to indicate successful edit
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Edited successfully',
          style: TextStyle(color: Colors.green),
        ),
      ),
    );

    Navigator.pop(context, newMark);
  }
}
