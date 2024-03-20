import 'package:flutter/material.dart';
import 'mark_addingScreen.dart'; // Import the AddMarkScreen widget

class MarkScreen extends StatefulWidget {
  const MarkScreen({Key? key}) : super(key: key);

  @override
  State<MarkScreen> createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 1, 255, 213),
        title: Text(
          'Exam Marks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(
          255, 255, 255, 255), // Set your desired background color here
      body: Center(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            bottom: 65.0), // Adjust the bottom padding as needed
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMarkScreen()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
