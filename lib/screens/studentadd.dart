import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_1/database/db.model.dart';
import 'package:project_1/database/student_db.dart';
import 'package:project_1/screens/class_info.dart';

class StudentAdd extends StatefulWidget {
  const StudentAdd({Key? key}) : super(key: key);

  @override
  State<StudentAdd> createState() => _StudentAddState();
}

class _StudentAddState extends State<StudentAdd> {
  late final ImagePicker _picker;
  File? _image;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _guardianNameController = TextEditingController();
  final TextEditingController _guardianPhoneNumberController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validateOnSubmit = false;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildImageWidget() {
    return Column(
      children: [
        GestureDetector(
          onTap: _getImage,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: _image == null
                ? const Icon(
                    Icons.add_photo_alternate,
                    size: 60,
                    color: Colors.grey,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.file(
                      _image!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        Text(
          'Add Photo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 206, 197),
        title: const Text('Add Student'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          autovalidateMode: _validateOnSubmit
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImageWidget(),
              _buildTextField('First Name', _firstNameController),
              _buildTextField('Last Name', _lastNameController),
              _buildTextField('Guardian Name', _guardianNameController),
              _buildTextField(
                  'Guardian Phone Number', _guardianPhoneNumberController),
              _buildTextField('Email', _emailController),
              _buildTextField('Address', _addressController),
              _buildTextField('Note', _noteController),
              const SizedBox(height: 30),
              SizedBox(
                width: 200, // Adjust button width
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _validateOnSubmit = true;
                    });
                    if (_formKey.currentState!.validate()) {
                      // Save student data
                      final newStudent = StudentModel(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        guardianName: _guardianNameController.text,
                        guardianPhoneNumber:
                            _guardianPhoneNumberController.text,
                        email: _emailController.text,
                        address: _addressController.text,
                        note: _noteController.text,
                        id: null,
                        imagePath: _image != null ? _image!.path : null,
                      );
                      addStudent(newStudent);
                      print(newStudent);
                      print('hey');
                      // Clear text controllers
                      _firstNameController.clear();
                      _lastNameController.clear();
                      _guardianNameController.clear();
                      _guardianPhoneNumberController.clear();
                      _emailController.clear();
                      _addressController.clear();
                      _noteController.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClassInfo()),
                      );
                    }
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (_validateOnSubmit) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            if (labelText == 'Guardian Phone Number') {
              if (int.tryParse(value) == null || value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
            }
            if (labelText == 'Email') {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
            }
          }
          return null;
        },
      ),
    );
  }
}
