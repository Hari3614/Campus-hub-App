import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/student_details.dart';

class EditStudentPage extends StatefulWidget {
  final StudentModel student;

  const EditStudentPage({Key? key, required this.student}) : super(key: key);

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _guardianNameController;
  late TextEditingController _guardianPhoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _noteController;

  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.student.firstName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _guardianNameController =
        TextEditingController(text: widget.student.guardianName);
    _guardianPhoneNumberController =
        TextEditingController(text: widget.student.guardianPhoneNumber);
    _emailController = TextEditingController(text: widget.student.email);
    _addressController = TextEditingController(text: widget.student.address);
    _noteController = TextEditingController(text: widget.student.note);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Student',
          style: TextStyle(
            color: Color.fromARGB(255, 94, 94, 94),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
      ),
      body: Container(
        color: const Color.fromARGB(255, 232, 232, 232),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _pickedImage != null
                      ? FileImage(File(_pickedImage!.path))
                      : widget.student.imagePath != null
                          ? FileImage(File(widget.student.imagePath!))
                          : null,
                  child:
                      _pickedImage == null && widget.student.imagePath == null
                          ? const Icon(Icons.person,
                              size: 80) // Default icon if no image is selected
                          : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _guardianNameController,
                decoration: InputDecoration(
                  labelText: 'Guardian Name',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _guardianPhoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Guardian Phone Number',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Note',
                  labelStyle:
                      const TextStyle(color: Colors.black87, fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  StudentModel updatedStudent = StudentModel(
                    id: widget.student.id,
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    guardianName: _guardianNameController.text,
                    guardianPhoneNumber: _guardianPhoneNumberController.text,
                    email: _emailController.text,
                    address: _addressController.text,
                    note: _noteController.text,
                    imagePath: _pickedImage?.path ?? widget.student.imagePath,
                  );

                  await updateStudent(updatedStudent);

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const SizedBox(
                        width: 150,
                        child: Text(
                          'Student details updated successfully',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );

                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentDetailsPage(student: updatedStudent),
                    ),
                  );
                },
                child: Text('Save', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
