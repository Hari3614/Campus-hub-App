import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package
import 'package:project_1/database/db.model.dart';
import 'package:project_1/screens/EditStudent_screen.dart';

class StudentDetailsPage extends StatelessWidget {
  final StudentModel student;

  const StudentDetailsPage({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${student.firstName} ${student.lastName} Details',
          style: const TextStyle(
            color: Color.fromARGB(255, 94, 94, 94),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 255, 213),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentPage(student: student),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 226, 226, 226),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (student.imagePath != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: MemoryImage(
                      File(student.imagePath!).readAsBytesSync(),
                    ),
                  ),
                ),
              SizedBox(
                width: 330,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'First Name:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${student.firstName}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Last Name:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${student.lastName}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Guardian Name:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${student.guardianName}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.phone, size: 20),
                            SizedBox(width: 5),
                            Text(
                              'Guardian Phone Number:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _launchPhoneCall(student.guardianPhoneNumber);
                          },
                          child: Text(
                            // ignore: unnecessary_string_interpolations
                            '${student.guardianPhoneNumber}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          children: [
                            Icon(Icons.email, size: 20),
                            SizedBox(width: 5),
                            Text(
                              'Email:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            _launchEmail(student.email);
                          },
                          child: Text(
                            // ignore: unnecessary_string_interpolations
                            '${student.email}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Address:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${student.address}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Note:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // ignore: unnecessary_string_interpolations
                          '${student.note}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
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

  void _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final String uri = _emailLaunchUri.toString();

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
